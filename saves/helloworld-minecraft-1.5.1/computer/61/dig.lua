function dig_down()
    for i =1,5 do
        turtle.digDown()
        turtle.down()
    end
end
function dig_forward()
    for i =1,35 do
        turtle.dig()
        turtle.forward()
   end
end

function turn_around()
    turtle.digUp()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.up()
end

function allt()
    for i=1,12 do
        dig_forward()
        turn_around()
    end
end

function start_over()
    turtle.turnLeft()


end

dig_down()
allt()
     
    
  
