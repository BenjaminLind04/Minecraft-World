
local turtle_goal = "minecraft:lit_redstone_lamp"
local function hasReachedGoal()
	rs.setOutput("bottom", true)
	local succ, data = turtle.inspectDown()
	if succ and data and data.name == turtle_goal then
		return true
	end
	return false
end

-- lock functions
local turtle_locked = {
	"up",
	"down",
}
for i,v in ipairs(turtle_locked) do
	turtle[v] = function()
		error("turtle."..v.."() är avstängd för denna turtle!", 0)
		return false
	end
end

-- keep tracks
local turtle_path = {}
local turtle_reverse = {
	[turtle.forward] = turtle.back,
	[turtle.back] = turtle.forward,
--	[turtle.up] = turtle.down,
--	[turtle.down] = turtle.up,
	[turtle.turnRight] = turtle.turnLeft,
	[turtle.turnLeft] = turtle.turnRight,
}
local function track(func)
	return function(...)
		local res = {func(...)}
		if res[1] then
			table.insert(turtle_path, func)
		end
		return unpack(res)
	end
end

-- Track the functions
for i,v in ipairs({
	"forward",
	"back",
--	"up",
--	"down",
	"turnLeft",
	"turnRight",
}) do
	turtle[v] = track(turtle[v])
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

-- Hide startup.lua from listing
local _fsList = fs.list
function fs.list(...)
	local args = {...}
	local res = {_fsList(...)}

	-- filter out /startup.lua
	if res[1] and args[1] == "" then
		for i,v in ipairs(res[1]) do
			if v == "startup.lua" then
				table.remove(res[1], i)
				break
			end
		end
	end

	return unpack(res)
end

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

local function checkGoal()
	if #turtle_path > 0 then
		term.setBackgroundColor(bgColour)
		term.setTextColour(promptColour)
		if hasReachedGoal() then
	    	print("Du klarade labyrinten! Tjohoo!")
	    else
	    	print("Ajaj, du klarade det inte. Återvänder till början...")
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

local succ,err = pcall(main)
term.setTextColour(errColour)
term.setCursorBlink(false)
print(err)
read()
shell.run("shutdown")