-- Mount Lottery NPC Auto Spawn System
-- This script spawns the Mount Lottery NPC in different cities at specific times

local config = {
    npcName = "Mount Lottery", -- Exact name of your NPC
    
    -- Schedule: {hour, minute, cityName, position, duration in minutes}
    schedule = {
        -- Thais - Every day at 09:00 for 60 minutes
        {hour = 9, minute = 0, city = "Thais", pos = Position(126, 46, 7), duration = 60},
        
        -- Carlin - Every day at 11:00 for 60 minutes  
        {hour = 11, minute = 0, city = "Carlin", pos = Position(129, 48, 6), duration = 60},
        
        -- Venore - Every day at 13:00 for 60 minutes
        {hour = 13, minute = 0, city = "Venore", pos = Position(127, 41, 6), duration = 60},
        
        -- Edron - Every day at 15:00 for 60 minutes
        {hour = 15, minute = 0, city = "Edron", pos = Position(130, 38, 6), duration = 60},
        
        -- Ab'Dendriel - Every day at 17:00 for 60 minutes
        {hour = 17, minute = 0, city = "Ab'Dendriel", pos = Position(131, 42, 7), duration = 60},
        
        -- Darashia - Every day at 19:00 for 60 minutes
        {hour = 19, minute = 0, city = "Darashia", pos = Position(33, 85, 1), duration = 60},
        
        -- Port Hope - Every day at 21:00 for 60 minutes
        {hour = 21, minute = 0, city = "Port Hope", pos = Position(127, 43, 4), duration = 60},
        
        -- Late night Thais - Every day at 23:00 for 60 minutes
        {hour = 23, minute = 0, city = "Thais", pos = Position(126, 46, 7), duration = 60}
    },
    
    -- Storage to track current spawned NPC
    storage = 45002,
    
    -- Broadcast messages - more eye-catching
    spawnMessage = "*** MOUNT LOTTERY *** The Mount Lottery NPC has appeared in %s! Get rare mounts now! ***",
    despawnMessage = "*** MOUNT LOTTERY *** The NPC has left %s! Next location coming soon! ***",
    
    -- Pre-spawn warning (5 minutes before)
    preSpawnMessage = "*** MOUNT LOTTERY *** The NPC will appear in %s in 5 minutes! Get ready! ***",
    
    -- Area around spawn position to clear (radius)
    clearRadius = 2
}

-- Function to clear area around spawn position
local function clearSpawnArea(position, radius)
    local spectators = Game.getSpectators(position, false, false, radius, radius, radius, radius)
    for _, creature in ipairs(spectators) do
        if creature:isNpc() and creature:getName() == config.npcName then
            creature:remove()
            return true
        end
    end
    return false
end

-- Function to spawn NPC
local function spawnMountLotteryNPC(scheduleEntry)
    -- Clear any existing NPC first
    clearSpawnArea(scheduleEntry.pos, config.clearRadius)
    
    -- Create new NPC
    local npc = Game.createNpc(config.npcName, scheduleEntry.pos)
    
    if npc then
        -- Store NPC ID for later removal
        Game.setStorageValue(config.storage, npc:getId())
        
        -- Multiple broadcast announcements for visibility
        local message = string.format(config.spawnMessage, scheduleEntry.city)
        
        -- Send broadcast message multiple times with effects
        Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
        
        -- Delayed second announcement for emphasis
        addEvent(function()
            Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
        end, 3000)
        
        -- Add spectacular effects at spawn location
        scheduleEntry.pos:sendMagicEffect(CONST_ME_TELEPORT)
        addEvent(function()
            scheduleEntry.pos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        end, 1000)
        
        -- Schedule despawn
        addEvent(function()
            local npcId = Game.getStorageValue(config.storage)
            local currentNpc = Npc(npcId)
            
            if currentNpc then
                local npcPos = currentNpc:getPosition()
                currentNpc:remove()
                
                -- Spectacular effects at despawn location
                npcPos:sendMagicEffect(CONST_ME_POFF)
                addEvent(function()
                    npcPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
                end, 500)
                
                -- Multiple broadcast despawn messages
                local despawnMsg = string.format(config.despawnMessage, scheduleEntry.city)
                Game.broadcastMessage(despawnMsg, MESSAGE_EVENT_ADVANCE)
                
                -- Second despawn announcement with next location info
                addEvent(function()
                    local nextSpawn, minutesUntil = getNextSpawnInfo()
                    if nextSpawn then
                        local hours = math.floor(minutesUntil / 60)
                        local minutes = minutesUntil % 60
                        local nextMessage = string.format("*** MOUNT LOTTERY *** Next appearance: %s in %dh %dm! ***", 
                                                        nextSpawn.city, hours, minutes)
                        Game.broadcastMessage(nextMessage, MESSAGE_EVENT_ADVANCE)
                    end
                end, 2000)
            end
            
            -- Clear storage
            Game.setStorageValue(config.storage, -1)
        end, scheduleEntry.duration * 60 * 1000) -- Convert minutes to milliseconds
        
        print("[Mount Lottery] NPC spawned in " .. scheduleEntry.city .. " at " .. scheduleEntry.hour .. ":" .. string.format("%02d", scheduleEntry.minute))
        return true
    else
        print("[Mount Lottery] Failed to spawn NPC in " .. scheduleEntry.city)
        return false
    end
end

-- Function to check if it's time to spawn or send warnings
local function checkSpawnTime()
    local currentTime = os.date("*t")
    local currentHour = currentTime.hour
    local currentMinute = currentTime.min
    
    -- Check each schedule entry
    for _, entry in ipairs(config.schedule) do
        -- Check for exact spawn time
        if currentHour == entry.hour and currentMinute == entry.minute then
            spawnMountLotteryNPC(entry)
            break
        end
        
        -- Check for 5-minute warning
        local warningHour = entry.hour
        local warningMinute = entry.minute - 5
        
        -- Handle minute underflow
        if warningMinute < 0 then
            warningMinute = warningMinute + 60
            warningHour = warningHour - 1
            if warningHour < 0 then
                warningHour = 23
            end
        end
        
        if currentHour == warningHour and currentMinute == warningMinute then
            local preMessage = string.format(config.preSpawnMessage, entry.city)
            Game.broadcastMessage(preMessage, MESSAGE_EVENT_ADVANCE)
            
            -- Second warning message
            addEvent(function()
                Game.broadcastMessage(preMessage, MESSAGE_EVENT_ADVANCE)
            end, 3000)
            break
        end
    end
end

-- Function to get next spawn info
local function getNextSpawnInfo()
    local currentTime = os.date("*t")
    local currentHour = currentTime.hour
    local currentMinute = currentTime.min
    local currentTotalMinutes = currentHour * 60 + currentMinute
    
    local nextSpawn = nil
    local minDifference = 24 * 60 -- 24 hours in minutes
    
    for _, entry in ipairs(config.schedule) do
        local entryTotalMinutes = entry.hour * 60 + entry.minute
        local difference
        
        if entryTotalMinutes > currentTotalMinutes then
            -- Same day
            difference = entryTotalMinutes - currentTotalMinutes
        else
            -- Next day
            difference = (24 * 60) + entryTotalMinutes - currentTotalMinutes
        end
        
        if difference < minDifference then
            minDifference = difference
            nextSpawn = entry
        end
    end
    
    return nextSpawn, minDifference
end

-- Main globalevent function for interval-based checking
function onThink(interval)
    checkSpawnTime()
    return true
end

-- Alternative function name for time-based events
function onTime(interval)
    checkSpawnTime()
    return true
end

-- Startup function to announce next spawn
function onStartup()
    local nextSpawn, minutesUntil = getNextSpawnInfo()
    
    if nextSpawn then
        local hours = math.floor(minutesUntil / 60)
        local minutes = minutesUntil % 60
        
        local message = string.format("Mount Lottery NPC will appear in %s in %d hours and %d minutes!", 
                                    nextSpawn.city, hours, minutes)
        print("[Mount Lottery] " .. message)
    end
    
    return true
end