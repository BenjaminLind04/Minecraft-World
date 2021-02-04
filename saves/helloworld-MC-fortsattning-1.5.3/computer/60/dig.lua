function langd(x)
    for i=1, x do
        turtle.digDown()
        turtle.forward()
    end
    for i=1, x do
        turtle.back()
    end
    turtle.down()
end

function djup(z) 
    for i=1, z do
        langd(x)
    end
    for i=1, z do
        turtle.up()
    end
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
end

function bredd(y)
    for i=1, y do
        djup(z)
    end
end

--Till Extrauppgift
function sida(q)
    for i = 1, q do
        turtle.digDown()
        turtle.placeDown()
        turtle.forward()
    end
end

function kanter(x,y)
    turtle.back()
        for i=1, 2 do
            sida(x+1)
            turtle.turnRight()
            sida(y+1)
            turtle.turnRight()
        end
end

-- Extrauppgift för att prata med användaren       
print("Hej, hur stor pool vill du bygga? Ange:")
print("längd:")
x= tonumber(read())
print("bredd:")
y = tonumber(read())
print("djup:")
z = tonumber(read())
if x<10 and y<10 and z<10 then
    bredd(y)
    kanter(x,y)
else
    print("Poolen har för stora dimensioner, max 10")
end    
    
    


        


    
    
