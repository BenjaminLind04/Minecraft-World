
--(( Settings ))--
print("Colored password")

local s_password = "34561"
local t_colorMap = {
	['0'] = colors.white, --		1		0x1		0	#F0F0F0
	['1'] = colors.orange, --		2		0x2		1	#F2B233
	['2'] = colors.magenta, --		4		0x4		2	#E57FD8
	['3'] = colors.lightBlue, --	8		0x8		3	#99B2F2
	['4'] = colors.yellow, --		16		0x10	4	#DEDE6C
	['5'] = colors.lime, --			32		0x20	5	#7FCC19
	['6'] = colors.pink, --			64		0x40	6	#F2B2CC
	['7'] = colors.gray, --			128		0x80	7	#4C4C4C
	['8'] = colors.lightGray, --	256		0x100	8	#999999
	['9'] = colors.cyan, --			512		0x200	9	#4C99B2
	['a'] = colors.purple, --		1024	0x400	a	#B266E5
	['b'] = colors.blue, --			2048	0x800	b	#3366CC
	['c'] = colors.brown, --		4096	0x1000	c	#7F664C
	['d'] = colors.green, --		8192	0x2000	d	#57A64E
	['e'] = colors.red, --			16384	0x4000	e	#CC4C4C
	['f'] = colors.black, --		32768	0x8000	f	#191919
}

local s_monSide = "monitor_1"
local s_rsSide = "bottom"
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
	sleep(0.3)
	rs.setOutput(s_rsSide, true)
	sleep(s_rsTime)
	rs.setOutput(s_rsSide, false)
end

function mt:draw()
	if self.colored then
		m.setBackgroundColor(self.bg)
		m.write(string.rep(' ', self.width or string.len(self.label)))
	else
		if selected == self then
			m.setBackgroundColor(s_btnSelBG)
		else
			m.setBackgroundColor(self.bg)
		end
		m.setTextColor(self.fg)

		m.setCursorPos(self.x, self.y)
		m.write(self.label)
	end
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
	for i=1,#s_password do
		m.setCursorPos(4+i*2, 4)
		local colorKey = (input:sub(i,i).." "):sub(1,1)
		m.setBackgroundColor(t_colorMap[colorKey] or s_inputBG)
		m.write(" ")
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

local function addColoredButton(colorKey, x, y)
	addButton(" ", x, y, nil, t_colorMap[colorKey], function()
		input = (input .. colorKey):sub(-#s_password,-1)
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

local function disableCtrlT()
    os.pullEvent = os.pullEventRaw
end

--(( Arrange ))--

local x,y = 5,6
-- addColoredButton(colorKey, x, y)
addColoredButton('1', x, y)
addColoredButton('3', x + 4, y)
addColoredButton('4', x + 8, y)
addColoredButton('5', x, y + 2)
addColoredButton('6', x + 4, y + 2)
addColoredButton('a', x + 8, y + 2)
addColoredButton('b', x, y + 4)
addColoredButton('c', x + 4, y + 4)
addColoredButton('e', x + 8, y + 4)
-- addColoredButton('e', x + 4, y + 6)
addButton("x", x + 2, y + 6, nil, s_btnDelBG, callbackDel)
addButton(">", x + 6, y + 6, nil, s_btnGoBG, callbackGo)

redraw()

print("Skriv in lösenordet")
print("på skärmen bredvid")

disableCtrlT()

--(( Main loop ))--

while true do
	handleEvent(os.pullEvent())
end

--(( EOF ))--
