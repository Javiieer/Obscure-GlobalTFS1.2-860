function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local split = param:split(",")
    if #split < 2 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /mount <player>, <mount_id>")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Example: /mount Player, 1")
        return false
    end

    local targetName = split[1]:trim()
    local mountId = tonumber(split[2]:trim())

    if not mountId then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid mount ID. Please use a number.")
        return false
    end

    local target = Player(targetName)
    if not target then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player '" .. targetName .. "' not found.")
        return false
    end

    -- Lista de monturas válidas para Tibia 8.60
    local validMounts = {
        [1] = "Widow Queen",
        [2] = "Racing Bird", 
        [3] = "War Bear",
        [4] = "Black Sheep",
        [5] = "Midnight Panther",
        [6] = "Draptor",
        [7] = "Titanica",
        [8] = "Tin Lizzard",
        [9] = "Blazebringer",
        [10] = "Rapid Boar",
        [11] = "Stampor",
        [12] = "Undead Cavebear",
        [13] = "Donkey",
        [14] = "Tiger Slug",
        [15] = "Uniwheel",
        [16] = "Crystal Wolf",
        [17] = "War Horse",
        [18] = "Kingly Deer",
        [19] = "Tamed Panda",
        [20] = "Dromedary"
    }

    if not validMounts[mountId] then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid mount ID. Valid IDs: 1-20")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Use '/mounts' to see available mounts.")
        return false
    end

    -- Dar la montura al jugador
    target:addMount(mountId)
    
    -- Mensajes de confirmación
    target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received the mount: " .. validMounts[mountId] .. "!")
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Mount '" .. validMounts[mountId] .. "' given to " .. targetName .. ".")
    
    return false
end