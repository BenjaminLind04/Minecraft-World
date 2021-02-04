
--(( Settings ))--
local s_password = "25790"

local s_monSide = "back"
local s_rsSide = "front"
local s_rsTime = 10


local s_btnFG = colors.white
local s_btnBG = colors.green
local s_btnSelBG = colors.orange
local s_btnDelBG = colors.red
local s_btnGoBG = colors.lime

local s_screenBG = colors.black
local s_titleFG = colors.lightBlue
local s_titleBG = colors.gray

local s_inputFG = colors.lime
local s_inputWrongFG = colors.red
local s_inputCorrectFG = colors.lime
local s_inputBG = colors.gray

local s_selectedTimer = 0.2
local s_textScale = 1.5

local s_title = "Skriv in\nlösenordet"

--(( Variables ))--
local m = peripheral.wrap(s_monSide)
local input = ""

local buttons = {}
local selected = nil
local selectedTimer = nil
local mt = {}
mt.__index = mt

--(( Functions ))--

local function openRedstoneHatch()
	rs.setOutput(s_rsSide, true)
	sleep(s_rsTime)
 rs.setOutput(s_rsSide, false)
end

function mt:draw()
	if selected == self then
		m.setBackgroundColor(s_btnSelBG)
	else
		m.setBackgroundColor(self.bg)
	end
	m.setTextColor(self.fg)

	m.setCursorPos(self.x, self.y)
	m.write(self.label)
end

function mt:isInside(x, y)
	return x >= self.x
		and x < self.x + #self.label
		and y == self.y
end

function mt:press()
	local oldSelected = selected
	selected = self
	self:draw()
	if oldSelected then
		oldSelected:draw()
	end
	selectedTimer = os.startTimer(s_selectedTimer)
	if self.callback then
		self:callback()
	end
end

function mt:unpress()
	selected = nil
	self:draw()
end

local function writeCentered(text)
	local _,y = m.getCursorPos()
	local w = m.getSize()
	for line in (text .. "\n"):gmatch("(.-)\n") do
		local x = (w - #line) / 2 + 1
		m.setCursorPos(x, y)
		m.clearLine()
		m.write(line)
		y = y + 1
	end
end

local function redrawTitle()
	m.setBackgroundColor(s_titleBG)
	m.setTextColor(s_titleFG)
	m.setCursorPos(1,1)
	writeCentered(s_title)
end

local function redrawInput()
	m.setBackgroundColor(s_inputBG)
	m.setTextColor(s_inputFG)
	for i=1,#s_password do
		m.setCursorPos(4+i*2, 4)
		m.write((input:sub(i,i).." "):sub(1,1))
	end
end

local function redrawButtons()
	for i,btn in ipairs(buttons) do
		btn:draw()
	end
end

local function redraw()
    if m.setTextScale then
	    	m.setTextScale(s_textScale)
    end
	m.setBackgroundColor(s_screenBG)
	m.clear()
	redrawTitle()
	redrawInput()
	redrawButtons()
end

local function addButton(label, x, y, fg, bg, callback)
	local btn = {
        label = " " .. tostring(label) .. " ",
        x = x,
        y = y,
        callback = callback,
        fg = fg or s_btnFG,
        bg = bg or s_btnBG,
    }
    setmetatable(btn, mt)
    table.insert(buttons, btn)
end

local function addNumpadButton(num, x, y)
	addButton(num, x, y, s_btnFG, s_btnBG, function()
		input = (input .. num):sub(-#s_password,-1)
		redrawInput()
	end)
end

local function handleEvent(ev, p1,p2,p3,p4,p5)
	if ev == "timer" and p1 == selectedTimer then
		if selected then
			selected:unpress()
		end
	elseif ev == "monitor_touch" or ev == "mouse_click" then
		local x,y = p2, p3
		for i,btn in ipairs(buttons) do
			if btn:isInside(x,y) then
				btn:press()
				break
			end
		end
	elseif ev == "monitor_resize" then
		redraw()
	end
end

local function callbackDel()
	input = ""
	redrawInput()
end

local function callbackGo()
	m.setCursorPos(6, 4)
	if input == s_password then
		m.setBackgroundColor(s_inputBG)
		m.setTextColor(s_inputCorrectFG)
		m.write(" KORREKT ")

		openRedstoneHatch()
	else
		m.setBackgroundColor(s_inputBG)
		m.setTextColor(s_inputWrongFG)
		m.write("   FEL   ")
	end
	sleep(3)
	input = ""
	redraw()
end

--(( Arrange ))--

local x,y = 5,6
addNumpadButton(1, x, y)
addNumpadButton(2, x + 4, y)
addNumpadButton(3, x + 8, y)
addNumpadButton(4, x, y + 2)
addNumpadButton(5, x + 4, y + 2)
addNumpadButton(6, x + 8, y + 2)
addNumpadButton(7, x, y + 4)
addNumpadButton(8, x + 4, y + 4)
addNumpadButton(9, x + 8, y + 4)
addNumpadButton(0, x + 4, y + 6)
addButton("x", x, y + 6, nil, s_btnDelBG, callbackDel)
addButton(">", x + 8, y + 6, nil, s_btnGoBG, callbackGo)

redraw()

--(( Main loop ))--

while true do
	handleEvent(os.pullEvent())
end

--(( EOF ))--
