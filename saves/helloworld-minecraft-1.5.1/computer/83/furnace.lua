function dit()
  turtle.turnLeft()
  turtle.turnLeft()
  for i = 1,2 do
    turtle.forward()
  end
  turtle.turnRight()
  turtle.forward()
  turtle.turnLeft()
  turtle.forward()
  turtle.up()
  turtle.turnLeft()
end

function tillbaka()
  turtle.turnRight()
  turtle.down()
  turtle.back()
  turtle.turnRight()
  turtle.back()
  turtle.turnRight()
  for i = 1,2 do
    turtle.forward()
  end
end
