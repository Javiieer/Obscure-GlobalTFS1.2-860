-- /checkvip command
function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local targetName = param ~= "" and param or player:getName()
    local target = Player(targetName)
    
    if not target then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. targetName .. " is not online.")
        return false
    end

    local vipLevel = target:getVipLevel()
    local vipDays = target:getVipDays()

    if vipLevel == 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, targetName .. " does not have VIP.")
    else
        local vipName = target:getVipName()
        local expBonus = target:getVipExpBonus()
        local lootBonus = target:getVipLootBonus()
        
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "VIP Status for " .. targetName .. ":")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Level: " .. vipName .. " (Level " .. vipLevel .. ")")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Days remaining: " .. vipDays)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Exp bonus: +" .. expBonus .. "%")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Loot bonus: +" .. lootBonus .. "%")
    end

    return false
end
