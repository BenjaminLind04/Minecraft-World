--(( SETTINGS ))--

local turtle_goal = "minecraft:lit_redstone_lamp"
local turtle_disabled = {
	"turnLeft",
	"turnRight",
--	"up",
--	"down",
}

local turtle_goal_success = "Du klarade pusslet! Tjohoo!"
local turtle_goal_fail = "Ajaj, du klarade det inte. Tryck valfri knapp för att återvända till början..."

-- Colours
local promptColour, textColour, bgColour, errColour
if term.isColour() then
    promptColour = colours.yellow
    textColour = colours.white
    bgColour = colours.black
    errColour = colours.red
else
    promptColour = colours.white
    textColour = colours.white
    bgColour = colours.black
    errColour = colours.white
end

--(( VARIABLES ))--

local turtle_path = {}
local turtle_reverse = {
	[turtle.forward] = turtle.back,
	[turtle.back] = turtle.forward,
	[turtle.up] = turtle.down,
	[turtle.down] = turtle.up,
	[turtle.turnRight] = turtle.turnLeft,
	[turtle.turnLeft] = turtle.turnRight,
}
local turtle_track = {
	"forward",
	"back",
	"up",
	"down",
	"turnLeft",
	"turnRight",
}

--(( FUNCTIONS ))--
local function pause()
	term.setCursorBlink(true)
	repeat until os.pullEvent() == "key"
	term.setCursorBlink(false)
	print()
end

local function tableRemoveFirst(tbl, elem)
	for k,v in pairs(tbl) do
		if v == elem then
			return table.remove(tbl, k)
		end
	end
end

local function hasReachedGoal()
	rs.setOutput("front", true)
	local succ, data = turtle.inspect()
	if succ and data and data.name == turtle_goal then
		return true
	end
	rs.setOutput("bottom", true)
	succ, data = turtle.inspectDown()
	if succ and data and data.name == turtle_goal then
		return true
	end
	return false
end

-- keep tracks
local function trackTurtleFunc(func, name)
	return function(...)
		local res = {func(...)}
		if res[1] then
			table.insert(turtle_path, func)
		elseif res[2] == "Movement obstructed" then
			error("Något var ivägen för turtle."..name.."()", 2)
		end
		return unpack(res)
	end
end

-- Reverse
local function reversePath()
	for i=#turtle_path,1,-1 do
		local func = turtle_path[i]
		local reverse = turtle_reverse[func]
		repeat until reverse()
		table.remove(turtle_path, i)
	end
end

local function resetPath()
	turtle_path = {}
end


local function setupTurtleFuncs()
	-- lock functions
	for i,v in ipairs(turtle_disabled) do
		turtle[v] = function()
			error("turtle."..v.."() är avstängd för denna turtle!", 0)
			return false
		end
		tableRemoveFirst(turtle_track, v)
	end

	-- Track the functions
	for i,v in ipairs(turtle_track) do
		turtle[v] = trackTurtleFunc(turtle[v], v)
	end
end

local function setupHideStartup()
	-- Hide startup.lua from listing
	local _fsList = fs.list
	function fs.list(...)
		local args = {...}
		local res = {_fsList(...)}

		-- filter out /startup.lua
		if res[1] and args[1] == "" then
			tableRemoveFirst(res[1], "startup.lua")
		end

		return unpack(res)
	end
end

local function checkGoal()
	if #turtle_path > 0 then
		term.setBackgroundColor(bgColour)
		term.setTextColour(promptColour)
		if hasReachedGoal() then
	    	print(turtle_goal_success)
	    	resetPath()
	    else
	    	write(turtle_goal_fail)
	    	pause()
		    reversePath()
		end
	end
end

local function main()
	-- Read commands and execute them
	local tCommandHistory = {}
	while true do
	    term.setBackgroundColor(bgColour)
	    term.setTextColour(promptColour)
	    write(shell.dir() .. "> ")
	    term.setTextColour(textColour)

	    local sLine
	    if settings.get("shell.autocomplete") then
	        sLine = read(nil, tCommandHistory, shell.complete)
	    else
	        sLine = read(nil, tCommandHistory)
	    end
	    if sLine:match("%S") and tCommandHistory[#tCommandHistory] ~= sLine then
	        table.insert(tCommandHistory, sLine)
	    end
	    shell.run(sLine)
		
		checkGoal()
	end
end

--(( SETUP ))--

setupHideStartup()
setupTurtleFuncs()

--(( MAIN PROGRAM ))--

local succ,err = pcall(main)

-- Print error if any
term.setTextColour(errColour)
term.setCursorBlink(false)
print(err)
shell.run("shutdown")

--(( EOF ))--