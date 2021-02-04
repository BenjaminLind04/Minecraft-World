--DETTA SKRIPT ÄR SKRIVET
--PÅ HELLO WORLD!
--
--DU FÅR GÄRNA LÄSA DET
--MEN BLI INTE FÖR DISTRAHERAD
--DET ÄR ETT GANSKA AVANCERAT SKRIPT

--(( SETTINGS ))--

local turtle_path_file = ".path"

local turtle_goal = "minecraft:lit_redstone_lamp"
local turtle_disabled = {
	"turnLeft",
	"turnRight",
--	"up",
--	"down",
}

local turtle_goal_success = "Du klarade pusslet! Tjohoo!"
local turtle_goal_fail = "Ajaj, du klarade det inte. Tryck valfri knapp för att återvända till början..."

local hiddenFiles = {
	"startup.lua",
	turtle_path_file
}

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

local turtle_path = nil
local turtle_reverse = {
	forward = turtle.back,
	back = turtle.forward,
	up = turtle.down,
	down = turtle.up,
	turnRight = turtle.turnLeft,
	turnLeft = turtle.turnRight,
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

local function tryRefuel()
	local oldSlot = turtle.getSelectedSlot()
	for slot=1,16 do
		if turtle.getItemCount(slot) > 0 then
			turtle.select(slot)
			if turtle.refuel(1) then
				turtle.select(oldSlot)
				return true
			end
		end
	end
	turtle.select(oldSlot)
	return false
end

local function forceRefuel()
	if turtle.getFuelLevel() == 0 and not tryRefuel() then
		print("Slut på bränsle! Mata mig kol så jag kan åka hem.")
		repeat
			os.pullEvent("turtle_inventory")
			tryRefuel()
		until turtle.getFuelLevel() ~= 0
		print("Tack så mycket :)")
	end
end

local function savePath()
	local file = fs.open(turtle_path_file, "w")
	file.write(textutils.serialize(turtle_path))
	file.close()
end

local function resetPath()
	turtle_path = {}
	savePath()
end

local function removeFromPath(index)
	table.remove(turtle_path, index)
	savePath()
end

local function addToPath(name)
	table.insert(turtle_path, name)
	savePath()
end

local function loadPath()
	if fs.exists(turtle_path_file) then
		local file = fs.open(turtle_path_file, "r")
		local data = file.readAll()
		file.close()
		turtle_path = textutils.unserialize(data)
	else
		resetPath()
	end
end

-- Reverse
local function reversePath()
	for i=#turtle_path,1,-1 do
		local func = turtle_path[i]
		local reverse = turtle_reverse[func]
		forceRefuel()
		repeat until reverse()
		removeFromPath(i)
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
			addToPath(name)
		elseif res[2] == "Out of fuel" then
			error("Fanns inget bränsle kvar vid turtle."..name.."()", 2)
		elseif res[2] == "Movement obstructed" then
			error("Något var ivägen för turtle."..name.."()", 2)
		end
		return unpack(res)
	end
end

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

local function setupHideFiles()
	-- Hide startup.lua from listing
	local _fsList = fs.list
	function fs.list(...)
		local args = {...}
		local res = {_fsList(...)}

		-- filter out /startup.lua
		if res[1] and args[1] == "" then
			for _, file in ipairs(hiddenFiles) do
				tableRemoveFirst(res[1], file)
			end
		end

		return unpack(res)
	end
end

local function setupDisableEditRun()
	-- Pretty haxy, but the edit.lua program checks
	-- if shell.openTab then //add run button
	shell.openTab = nil
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
			term.setTextColour(textColour)
	    	pause()
		    reversePath()
		end
	end
end

local function main()
	loadPath()
	checkGoal()

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

setupHideFiles()
setupTurtleFuncs()
setupDisableEditRun()

--(( MAIN PROGRAM ))--

local succ,err = pcall(main)

-- Print error if any
term.setTextColour(errColour)
term.setCursorBlink(false)
print(err)
shell.run("shutdown")

--(( EOF ))--