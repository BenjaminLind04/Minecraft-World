turtle.dig()
turtle.forward()
turtle.turnLeft()
function dig_start()
    for i= 1, 3 do
        turtle.dig()
        turtle.forward()
    end 
end
turtle.digUp()
turtle.turnLeft()
turtle.turnLeft()
dig_start()
turtle.digUp()
