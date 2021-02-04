
print("Den här turtlen är låst.")
os.pullEvent = os.pullEventRaw

while true do
    os.pullEvent()
end
