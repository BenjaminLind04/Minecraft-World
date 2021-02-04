local m = peripheral.wrap("bottom")
local col = colors.lightGray
local x = 2
local y = 3

m.setTextScale(3)
m.clear()

m.setTextColor(col)
m.setCursorPos(x,y)
m.write("Här ska vi lösa")

m.setCursorPos(x,y+1)
m.write("labyrinterna")

m.setCursorPos(x,y+2)
m.write("med ")
m.setTextColor(colors.yellow)
m.write("for")
m.setTextColor(col)
m.write(" loopar.")

print("press key to continue")
read()
