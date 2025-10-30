-- !mountlottery command for players
-- Shows when and where the Mount Lottery NPC will appear next

function onSay(player, words, param)
    local schedule = {
        {hour = 9, minute = 0, city = "Thais", duration = 60},
        {hour = 11, minute = 0, city = "Carlin", duration = 60}, 
        {hour = 13, minute = 0, city = "Venore", duration = 60},
        {hour = 15, minute = 0, city = "Edron", duration = 60},
        {hour = 17, minute = 0, city = "Ab'Dendriel", duration = 60},
        {hour = 19, minute = 0, city = "Darashia", duration = 60},
        {hour = 21, minute = 0, city = "Port Hope", duration = 60},
        {hour = 23, minute = 0, city = "Thais", duration = 60}
    }
    
    -- Function to get next spawn info
    local function getNextSpawnInfo()
        local currentTime = os.date("*t")
        local currentHour = currentTime.hour
        local currentMinute = currentTime.min
        local currentTotalMinutes = currentHour * 60 + currentMinute
        
        local nextSpawn = nil
        local minDifference = 24 * 60 -- 24 hours in minutes
        
        for _, entry in ipairs(schedule) do
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
    
    -- Check if NPC is currently active
    local storage = 45002
    local npcId = Game.getStorageValue(storage)
    local currentNpc = Npc(npcId)
    
    if currentNpc then
        local npcPos = currentNpc:getPosition()
        player:sendTextMessage(MESSAGE_INFO_DESCR, "The Mount Lottery NPC is currently available!")
        
        -- Try to identify current city based on position
        local currentCity = "Unknown Location"
        if npcPos.z == 7 and npcPos.x >= 120 and npcPos.x <= 140 and npcPos.y >= 40 and npcPos.y <= 60 then
            currentCity = "Thais"
        elseif npcPos.z == 6 and npcPos.x >= 120 and npcPos.x <= 140 and npcPos.y >= 40 and npcPos.y <= 60 then
            currentCity = "Carlin or Venore"
        elseif npcPos.z == 1 and npcPos.x >= 30 and npcPos.x <= 40 then
            currentCity = "Darashia"
        end
        
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Location: " .. currentCity)
        return false
    end
    
    -- Get next spawn information
    local nextSpawn, minutesUntil = getNextSpawnInfo()
    
    if nextSpawn then
        local hours = math.floor(minutesUntil / 60)
        local minutes = minutesUntil % 60
        
        local timeStr = string.format("%02d:%02d", nextSpawn.hour, nextSpawn.minute)
        
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Mount Lottery Schedule:")
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Next appearance: " .. nextSpawn.city .. " at " .. timeStr)
        
        if hours > 0 then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Time remaining: " .. hours .. " hours and " .. minutes .. " minutes")
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Time remaining: " .. minutes .. " minutes")
        end
        
        -- Show today's full schedule
        local currentTime = os.date("*t")
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Today's schedule:")
        
        for _, entry in ipairs(schedule) do
            local entryTimeStr = string.format("%02d:%02d", entry.hour, entry.minute)
            local endHour = entry.hour + 1
            local endTimeStr = string.format("%02d:%02d", endHour, entry.minute)
            
            local status = ""
            local entryTotalMinutes = entry.hour * 60 + entry.minute
            local currentTotalMinutes = currentTime.hour * 60 + currentTime.min
            
            if entryTotalMinutes <= currentTotalMinutes and (entryTotalMinutes + entry.duration) > currentTotalMinutes then
                status = " (ACTIVE NOW!)"
            elseif entryTotalMinutes < currentTotalMinutes then
                status = " (finished)"
            end
            
            player:sendTextMessage(MESSAGE_INFO_DESCR, entryTimeStr .. "-" .. endTimeStr .. " " .. entry.city .. status)
        end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Mount Lottery schedule not available.")
    end
    
    return false
end