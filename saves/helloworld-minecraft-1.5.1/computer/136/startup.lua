local m = peripheral.wrap("left")

m.clear()
m.setTextScale(2)
m.setCursorPos(1,1)
m.blit("Sidor:",
       "dddddd",
       "ffffff")

local sides = {
    "bottom",
    "top",
    "back",
    "front",
    "right",
    "left",
}

local translation = {
    "under",
    "över",
    "bakom",
    "framför",
    "höger",
    "vänster",
}

for i,side in ipairs(sides) do
    m.setTextColor(colors.red)
    m.setCursorPos(1,i+1)
    m.write('"'..side..'"')
    
    m.setCursorPos(10,i+1)
    m.setTextColor(colors.lightGray)
    m.write('= '..translation[i])
end
