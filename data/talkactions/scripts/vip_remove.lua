-- /removevip command
function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    if param == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /removevip PlayerName")
        return false
    end

    local target = Player(param)
    if not target then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. param .. " is not online.")
        return false
    end

    local vipLevel = target:getVipLevel()
    if vipLevel == 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, param .. " does not have VIP.")
        return false
    end

    target:removeVip()
    
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have removed VIP from " .. param .. ".")
    target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your VIP status has been removed by a Game Master.")

    return false
end
