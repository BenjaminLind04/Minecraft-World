m = peripheral.wrap("right")
m.clear()
m.setTextScale(3)

function n()
x,y = m.getCursorPos()
m.setCursorPos(2,y+1)
end
m.setCursorPos(2,4)

m.write("Uteplats->entré->")
n()
m.write("->lounge->rum->")
n()
m.write("->resturang->badsluss->")
n()
m.write("->pool->kiosk->")
n()
m.write("reception->samlingsrum->")
n()
m.write("->källare...")

