rednet.open("back")

while true do
print("Ska jag lyfta hög eller låg vikt?")

rednet.broadcast(read())
id, msg = rednet.receive()

if msg == "klar" then
 for i = 1,6 do
  redstone.setOutput("bottom", true)
  sleep(1.5)
  redstone.setOutput("bottom", false)
  sleep(1.5)
 end
end
end
