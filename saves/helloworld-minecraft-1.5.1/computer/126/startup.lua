mon = peripheral.wrap("front")
mon.setTextScale(2)
mon.setCursorPos(1,1)
mon.clear()

mon.setTextColor(colors.green)
mon.write("Nu ska du ")

mon.setTextColor(colors.lime)
mon.setCursorPos(1,2)
mon.write("placera")
mon.setTextColor(colors.green)
mon.write(" några")

mon.setCursorPos(1,3)
mon.write("broar!")

mon.setCursorPos(2,5)
mon.setTextColor(colors.lightGray)
mon.write("*Hint Hint*")
