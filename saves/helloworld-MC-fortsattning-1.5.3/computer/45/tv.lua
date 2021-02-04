function newLine()
 x,y =monitor.getCursorPos()
 monitor.setCursorPos(2, y-1)
end

rednet.open("right")

--while true do
id, msg = rednet.receive()
 
 if redstone.getInput() == "front" then
  monitor = peripheral.wrap("back")
  monitor.clear()
  monitor.setTextColor(colors.blue)
  monitor.setCursorPos(2,1)
  monitor.setTextScale(4)
  monitor.write("Hello")
  newLine()
  monitor.write("World")
 end
 
--end
