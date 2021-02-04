rednet.open("right")

while true do
 id, msg = rednet.receive()
 if msg == "tv" then
  for i=1, 3 do
   turtle.forward()
  end
  turtle.turnRight()
  for i=1, 6 do
   turtle.forward()
  end
  turtle.turnLeft()
  redstone.setOutput("left", true)
 end
end
