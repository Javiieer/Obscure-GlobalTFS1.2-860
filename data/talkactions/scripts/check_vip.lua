-- !checkvip command (Player command)
-- Shows VIP status: level, name, and remaining days

function onSay(player, words, param)
    local vipLevel = player:getVipLevel()
    local vipDays = player:getVipDays()
    
    if vipLevel == 0 then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You don't have VIP status.")
    else
        local vipName = player:getVipName()
        local expBonus = player:getVipExpBonus()
        local lootBonus = player:getVipLootBonus()
        
        -- Build message
        local message = "=== VIP STATUS ===\n"
        message = message .. "VIP Type: " .. vipName .. " (Level " .. vipLevel .. ")\n"
        message = message .. "Days Remaining: " .. vipDays .. " days\n"
        message = message .. "Exp Bonus: +" .. expBonus .. "%\n"
        message = message .. "Loot Bonus: +" .. lootBonus .. "%\n"
        message = message .. "=================="
        
        player:sendTextMessage(MESSAGE_STATUS_WARNING, message)
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    end
    
    return false
end
