
print("Den här datorn är låst.")
os.pullEvent = os.pullEventRaw

while true do
    os.pullEvent()
end
