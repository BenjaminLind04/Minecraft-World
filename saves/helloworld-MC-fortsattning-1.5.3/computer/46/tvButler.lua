function forward(x)
 for i=1, x do
  turtle.forward()
 end
end
rednet.open("right")

id, msg = rednet.receive()

if msg == "tv" then
 forward(3)
 turtle.turnRight()
 forward(6)
 turtle.turnLeft()
 forward(2)
 redstone.setOutput("left", true)
end
