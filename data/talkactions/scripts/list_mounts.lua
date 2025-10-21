function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    -- Lista de monturas disponibles
    local mountList = {
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

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "=== Available Mounts ===")
    for id, name in pairs(mountList) do
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, id .. " - " .. name)
    end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /mount <player>, <mount_id>")
    
    return false
end