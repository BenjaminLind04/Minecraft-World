local m = peripheral.wrap("left")
m.setTextScale(3)
local w,h = m.getSize()

m.clear()

m.setCursorPos(1,1)
m.blit("function namn()",
       "444444440888800",
       "fffffffffffffff")
m.setCursorPos(1,2)
m.blit("    -- kod",
       "0000dddddd",
       "ffffffffff")
m.setCursorPos(1,3)
m.blit("end",
       "444",
       "fff")

local y = h-1
m.setCursorPos(1,y)
m.blit('rs.setOutput("sida", true)',
       "0000000000000dddddd0044440",
       "ffffffffffffffffffffffffff")
m.setCursorPos(1,y+1)
m.blit('rs.setOutput("sida", false)',
       "0000000000000dddddd00444440",
       "fffffffffffffffffffffffffff")

