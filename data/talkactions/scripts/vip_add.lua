-- /addvip command
function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local split = param:split(",")
    if #split < 3 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /addvip PlayerName, VipLevel, Days")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Example: /addvip Player Name, 2, 30")
        return false
    end

    local targetName = split[1]:trim()
    local vipLevel = tonumber(split[2]:trim())
    local days = tonumber(split[3]:trim())

    if not vipLevel or vipLevel < 1 or vipLevel > 3 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "VIP level must be 1, 2, or 3.")
        return false
    end

    if not days or days < 1 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Days must be a positive number.")
        return false
    end

    local target = Player(targetName)
    if not target then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. targetName .. " is not online.")
        return false
    end

    target:addVip(vipLevel, days)
    
    -- Force save player to database
    target:save()
    
    local vipName = VIP_CONFIG.benefits[vipLevel].name
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have added " .. vipName .. " for " .. days .. " days to " .. targetName .. ".")
    target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received " .. vipName .. " for " .. days .. " days from a Game Master!")
    target:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)

    return false
end
