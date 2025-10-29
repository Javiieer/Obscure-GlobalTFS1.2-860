-- /addpoints command (TFS 1.2 compatible)
-- Allows GMs to give premium points to players

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local split = param:split(",")
    if #split < 2 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /addpoints PlayerName, Amount")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Example: /addpoints Player Name, 500")
        return false
    end

    local targetName = split[1]:trim()
    local points = tonumber(split[2]:trim())

    if not points or points < 1 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Amount must be a positive number.")
        return false
    end

    local target = Player(targetName)
    if not target then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. targetName .. " is not online.")
        return false
    end

    -- Get account ID
    local accountId = target:getAccountId()
    
    -- Add premium points to account
    db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + " .. points .. " WHERE `id` = " .. accountId)
    
    -- Notify both players
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have added " .. points .. " premium points to " .. targetName .. "'s account.")
    target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received " .. points .. " premium points from a Game Master!")
    target:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)

    return false
end
