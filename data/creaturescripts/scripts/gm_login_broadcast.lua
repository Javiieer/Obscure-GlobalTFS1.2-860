-- GM Login Broadcast System
-- Sends automatic broadcast when specific GMs login

function onLogin(player)
    local playerId = player:getId()
    local playerName = player:getName()
    local groupId = player:getGroup():getId()
    
    -- Configuration: GM group IDs that trigger broadcast
    local gmGroups = {
        [5] = "Game Master",     -- God account type 5
        [6] = "Administrator"    -- Admin/God group 6
    }
    
    -- Check if player is in a GM group that should trigger broadcast
    if gmGroups[groupId] then
        -- Custom messages based on player name or group
        local broadcastMessages = {
            ["[GOD] Bruno"] = "¡El Administrador Bruno se ha conectado al servidor! ¡Bienvenido!",
            -- Add more custom messages for specific players
            -- ["PlayerName"] = "Custom message",
        }
        
        -- Default message if no custom message is set
        local defaultMessage = string.format("%s %s se ha conectado al servidor!", gmGroups[groupId], playerName)
        
        -- Get the message (custom or default)
        local message = broadcastMessages[playerName] or defaultMessage
        
        -- Send broadcast with magic effect
        Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
        
        -- Optional: Add visual effects around all online players
        local onlinePlayers = Game.getPlayers()
        for _, onlinePlayer in pairs(onlinePlayers) do
            if onlinePlayer ~= player then -- Don't send effect to the GM themselves
                onlinePlayer:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
                -- You can change the effect: CONST_ME_FIREWORK_BLUE, CONST_ME_FIREWORK_YELLOW, etc.
            end
        end
        
        -- Special effect for the GM
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        
        -- Optional: Send a private message to the GM
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Bienvenido de vuelta, " .. playerName .. "!")
    end
    
    return true
end