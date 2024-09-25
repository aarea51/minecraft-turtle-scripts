-- Diamond mining turtle script

local targetDiamonds = 10
local diamondCount = 0
local startX, startY, startZ = gps.locate() -- Get starting position

-- Function to mine one block
function mineBlock()
    while turtle.detect() do
        turtle.dig()
        sleep(1) -- Wait a moment to allow the block to be mined
    end
    turtle.forward()
end

-- Function to check inventory and drop items if full
function checkInventory()
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and item.name ~= "minecraft:diamond" then
            turtle.drop()
        end
    end
end

-- Main mining loop
while diamondCount < targetDiamonds do
    mineBlock() -- Mine the block in front
    checkInventory() -- Check inventory for space

    -- Check for diamonds in inventory
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and item.name == "minecraft:diamond" then
            diamondCount = diamondCount + item.count
        end
    end

    -- Simple navigation to avoid falling into caves
    if not turtle.detectDown() then
        turtle.down()
    else
        turtle.turnRight() -- Turn right if we can't go down
        if turtle.detect() then
            turtle.dig() -- Dig if we can
        end
        turtle.forward() -- Move forward
    end
end

-- Return to starting position
function returnToStart()
    -- Assuming you've been mining straight down a tunnel
    turtle.turnAround()
    for i = 1, diamondCount do
        turtle.forward()
    end
end

returnToStart() -- Go back to the starting point
print("Collected " .. diamondCount .. " diamonds!")
