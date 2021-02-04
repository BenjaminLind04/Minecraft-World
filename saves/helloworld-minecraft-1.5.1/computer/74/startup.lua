local monitor = peripheral.wrap("front")

local function centered(text)
    local w,h = monitor.getSize()
    local x,y = math.ceil((w - #text) / 2) + 1,
        math.ceil(h/2)
        
    monitor.setCursorPos(x,y)
    monitor.write(text)
end

monitor.clear()
monitor.setTextColour(colours.yellow)
monitor.setTextScale(1.5)

centered(os.getComputerLabel() or "Minecraft 4")
