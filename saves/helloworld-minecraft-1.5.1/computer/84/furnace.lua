
function leave()
  turtle.suck()
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.forward()
  turtle.forward()
  turtle.up()
  turtle.up()
  turtle.forward()
  turtle.dropDown()
end

function pickup()
  turtle.back()
  turtle.down()
  turtle.down()
  turtle.forward()
  turtle.suckUp()
end

function back()
  turtle.turnLeft()
  turtle.forward()
  turtle.turnLeft()
  for i = 1,3 do
    turtle.forward()
  end

  turtle.drop()
  turtle.turnLeft()
  turtle.forward()
  turtle.turnRight()
end

while true do
  leave()
  pickup()
  back()
end
