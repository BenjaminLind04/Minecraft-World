rs.setOutput("right", true)

while true do
  local front = rs.getInput("front")
  os.pullEvent("redstone")
  
  -- detect high->low
  if front and not rs.getInput("front") then
    rs.setOutput("right", false)
    sleep(5)
    rs.setOutput("right", true)
  end
end
