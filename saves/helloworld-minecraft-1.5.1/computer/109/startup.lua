
term.write("Den här datorn med ")
term.setTextColor(colors.magenta)
term.write("F")
term.setTextColor(colors.pink)
term.write("Ä")
term.setTextColor(colors.lightBlue)
term.write("R")
term.setTextColor(colors.lime)
term.write("G")
term.setTextColor(colors.yellow)
term.write("E")
term.setTextColor(colors.orange)
term.write("R")
term.setTextColor(colors.red)
term.write("!")
term.setTextColor(colors.white)
term.write(" är låst.")
os.pullEvent = os.pullEventRaw

while true do
    os.pullEvent()
end
