function length(x)
    for i=1, x do
        turtle.digDown()
        turtle.forward()
    end
    for i=1, x do
        turtle.back()
    end
    turtle.down()
end

function height(y) 
    for i=1, y do
        lenght(x)
    end
    for i=1, y do
        turtle.up()
    end
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
end

function width(z)
    for i=1, z do
        height(y)
    end
end

function pool(x,y,z)
    width(z)
end

print("Hej, hur stor pool vill du bygga? Ange:")
print("längd:")
x= tonumber(read())
print("bredd:")
z = tonumber(read())
print("djup:")
y = tonumber(read())
if x<10 and y<10 and z<10 then
    pool(x,y,z)
else
    print("Poolen har för stora dimensioner, max 10)
end
    
    
    


        


    
    
