local m = peripheral.wrap("bottom")

m.setTextScale(2.5)
m.clear()

m.setTextColor(colors.lime)
m.setCursorPos(3,2)
m.write("Tips för")

m.setTextColor(colors.green)
m.setCursorPos(3,3)
m.write("labyrinterna:")

m.setTextColor(colors.yellow)
m.setCursorPos(3,5)
m.write("for")
m.setTextColor(colors.white)
m.write(" i = 1, 5 ")
m.setTextColor(colors.yellow)
m.write("do")

m.setTextColor(colors.gray)
m.setCursorPos(3,6)
m.write("    skriv kod här")

m.setCursorPos(3,7)
m.setTextColor(colors.yellow)
m.write("end")
