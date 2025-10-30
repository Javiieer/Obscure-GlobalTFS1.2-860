-- Mount Lottery GM Commands
-- /mountlottery spawn <city> - Spawn NPC in specific city
-- /mountlottery remove - Remove current NPC
-- /mountlottery schedule - Show next spawn times
-- /mountlottery force <city> - Force spawn in city (bypasses schedule)

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return false
    end
    
    local split = param:split(" ")
    local action = split[1]
    
    -- Configuration (same as in globalevent)
    local config = {
        npcName = "Mount Lottery",
        cities = {
            thais = {name = "Thais", pos = Position(126, 46, 7)},
            carlin = {name = "Carlin", pos = Position(129, 48, 6)},
            venore = {name = "Venore", pos = Position(127, 41, 6)},
            edron = {name = "Edron", pos = Position(130, 38, 6)},
            abdendriel = {name = "Ab'Dendriel", pos = Position(131, 42, 7)},
            darashia = {name = "Darashia", pos = Position(33, 85, 1)},
            porthope = {name = "Port Hope", pos = Position(127, 43, 4)}
        },
        storage = 45002,
        clearRadius = 2
    }
    
    -- Function to clear existing NPC
    local function clearExistingNPC()
        local npcId = Game.getStorageValue(config.storage)
        local currentNpc = Npc(npcId)
        
        if currentNpc then
            local npcPos = currentNpc:getPosition()
            currentNpc:remove()
            npcPos:sendMagicEffect(CONST_ME_POFF)
            Game.setStorageValue(config.storage, -1)
            return true
        end
        return false
    end
    
    -- Function to spawn NPC
    local function spawnNPC(cityData, duration)
        duration = duration or 60 -- Default 60 minutes
        
        -- Clear existing NPC first
        clearExistingNPC()
        
        -- Create new NPC
        local npc = Game.createNpc(config.npcName, cityData.pos)
        
        if npc then
            Game.setStorageValue(config.storage, npc:getId())
            cityData.pos:sendMagicEffect(CONST_ME_TELEPORT)
            
            -- Enhanced broadcast message
            local message = "*** MOUNT LOTTERY *** GM has spawned the NPC in " .. cityData.name .. "! Limited time! ***"
            Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
            
            -- Second announcement for visibility
            addEvent(function()
                Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
            end, 3000)
            
            -- Schedule auto-removal
            addEvent(function()
                local npcId = Game.getStorageValue(config.storage)
                local currentNpc = Npc(npcId)
                
                if currentNpc then
                    local npcPos = currentNpc:getPosition()
                    currentNpc:remove()
                    npcPos:sendMagicEffect(CONST_ME_POFF)
                    
                    local despawnMsg = "The Mount Lottery NPC has left " .. cityData.name .. "!"
                    Game.broadcastMessage(despawnMsg, MESSAGE_EVENT_ADVANCE)
                end
                
                Game.setStorageValue(config.storage, -1)
            end, duration * 60 * 1000)
            
            return true
        end
        return false
    end
    
    if action == "spawn" or action == "force" then
        local cityName = split[2]
        local duration = tonumber(split[3]) or 60
        
        if not cityName then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /mountlottery spawn <city> [duration_minutes]")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Available cities: thais, carlin, venore, edron, abdendriel, darashia, porthope")
            return false
        end
        
        local cityData = config.cities[cityName:lower()]
        if not cityData then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid city! Available: thais, carlin, venore, edron, abdendriel, darashia, porthope")
            return false
        end
        
        if spawnNPC(cityData, duration) then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Mount Lottery NPC spawned in " .. cityData.name .. " for " .. duration .. " minutes.")
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Failed to spawn Mount Lottery NPC in " .. cityData.name .. ".")
        end
        
    elseif action == "remove" then
        if clearExistingNPC() then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Mount Lottery NPC removed.")
            Game.broadcastMessage("*** MOUNT LOTTERY *** GM has removed the NPC. Check !mountlottery for next schedule! ***", MESSAGE_EVENT_ADVANCE)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "No Mount Lottery NPC found to remove.")
        end
        
    elseif action == "schedule" then
        local schedule = {
            {hour = 9, minute = 0, city = "Thais"},
            {hour = 11, minute = 0, city = "Carlin"}, 
            {hour = 13, minute = 0, city = "Venore"},
            {hour = 15, minute = 0, city = "Edron"},
            {hour = 17, minute = 0, city = "Ab'Dendriel"},
            {hour = 19, minute = 0, city = "Darashia"},
            {hour = 21, minute = 0, city = "Port Hope"},
            {hour = 23, minute = 0, city = "Thais"}
        }
        
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Mount Lottery NPC Schedule:")
        for _, entry in ipairs(schedule) do
            local timeStr = string.format("%02d:%02d", entry.hour, entry.minute)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, timeStr .. " - " .. entry.city)
        end
        
        -- Show current status
        local npcId = Game.getStorageValue(config.storage)
        local currentNpc = Npc(npcId)
        
        if currentNpc then
            local npcPos = currentNpc:getPosition()
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Currently active at position: " .. npcPos.x .. ", " .. npcPos.y .. ", " .. npcPos.z)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "No NPC currently active.")
        end
        
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Mount Lottery GM Commands:")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/mountlottery spawn <city> [duration] - Spawn NPC")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/mountlottery remove - Remove current NPC")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/mountlottery schedule - Show schedule")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Cities: thais, carlin, venore, edron, abdendriel, darashia, porthope")
    end
    
    return false
end