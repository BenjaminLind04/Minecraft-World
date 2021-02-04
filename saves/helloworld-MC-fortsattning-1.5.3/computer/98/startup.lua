while true do
print("Skriv in kodordet för att lämna...")
 if read() == "gräddfil" then
  print("Grattis, du kan lämna!")
  redstone.setOutput("back", true)
  sleep(1)
  redstone.setOutput("back", false)
  sleep(1)
 else
  print("Tyvärr det var fel, utforska källaren för att hitta svaret")
 end
end
