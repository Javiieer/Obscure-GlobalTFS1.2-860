local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)            npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)        npcHandler:onCreatureDisappear(cid)            end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                        npcHandler:onThink()                        end

local function greetCallback(cid)
    local player = Player(cid)
    if player then
        local vipLevel = player:getVipLevel()
        local vipDays = player:getVipDays()
        
        if vipLevel > 0 then
            npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! You currently have " .. player:getVipName() .. " active for " .. vipDays .. " more days. Would you like to {extend} your VIP or {upgrade} to a higher level?")
        else
            npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! I sell VIP access to exclusive zones with special benefits. We have {VIP 1}, {VIP 2}, and {VIP 3}. Would you like to know more about {benefits}?")
        end
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    if not player then
        return false
    end

    -- Show benefits
    if msgcontains(msg, "benefits") or msgcontains(msg, "info") then
        npcHandler:say({
            "Our VIP system has 3 levels:",
            "VIP 1 (Bronze): +10% exp, +5% loot, access to VIP Zone 1",
            "VIP 2 (Silver): +20% exp, +15% loot, access to VIP Zones 1-2, VIP teleports",
            "VIP 3 (Gold): +30% exp, +25% loot, all VIP zones, VIP teleports, 50% trainer discount",
            "Say {buy vip 1}, {buy vip 2}, or {buy vip 3} to purchase!"
        }, cid)
        return true
    end

    -- VIP 1 purchase
    if msgcontains(msg, "buy vip 1") or msgcontains(msg, "vip 1") then
        npcHandler:say("VIP 1 costs 150 premium points for 7 days, 300 for 15 days, or 500 for 30 days. Say {7 days}, {15 days}, or {30 days}.", cid)
        npcHandler.topic[cid] = 1
        return true
    end

    -- VIP 2 purchase
    if msgcontains(msg, "buy vip 2") or msgcontains(msg, "vip 2") then
        npcHandler:say("VIP 2 costs 300 premium points for 7 days, 550 for 15 days, or 900 for 30 days. Say {7 days}, {15 days}, or {30 days}.", cid)
        npcHandler.topic[cid] = 2
        return true
    end

    -- VIP 3 purchase
    if msgcontains(msg, "buy vip 3") or msgcontains(msg, "vip 3") then
        npcHandler:say("VIP 3 costs 500 premium points for 7 days, 900 for 15 days, or 1500 for 30 days. Say {7 days}, {15 days}, or {30 days}.", cid)
        npcHandler.topic[cid] = 3
        return true
    end

    -- Days selection
    if msgcontains(msg, "7 days") or msgcontains(msg, "15 days") or msgcontains(msg, "30 days") then
        local days = 0
        if msgcontains(msg, "7 days") then
            days = 7
        elseif msgcontains(msg, "15 days") then
            days = 15
        elseif msgcontains(msg, "30 days") then
            days = 30
        end

        local vipLevel = npcHandler.topic[cid]
        if vipLevel and vipLevel >= 1 and vipLevel <= 3 and days > 0 then
            local price = getVipPrice(vipLevel, days)
            if not price then
                npcHandler:say("Sorry, there was an error. Please try again.", cid)
                npcHandler.topic[cid] = 0
                return true
            end

            npcHandler:say("You want to purchase VIP " .. vipLevel .. " for " .. days .. " days for " .. price .. " premium points. Do you {confirm}?", cid)
            npcHandler.topic[cid] = vipLevel * 100 + days -- Store both level and days
            return true
        end
    end

    -- Confirm purchase
    if msgcontains(msg, "confirm") or msgcontains(msg, "yes") then
        local encoded = npcHandler.topic[cid]
        if encoded and encoded >= 100 then
            local vipLevel = math.floor(encoded / 100)
            local days = encoded % 100

            local price = getVipPrice(vipLevel, days)
            if not price then
                npcHandler:say("Sorry, there was an error. Please try again.", cid)
                npcHandler.topic[cid] = 0
                return true
            end

            -- Check premium points
            local accountId = player:getAccountId()
            local resultId = db.storeQuery("SELECT `premium_points` FROM `accounts` WHERE `id` = " .. accountId)
            
            if resultId then
                local premiumPoints = result.getNumber(resultId, "premium_points")
                result.free(resultId)

                if premiumPoints >= price then
                    -- Deduct points
                    db.query("UPDATE `accounts` SET `premium_points` = `premium_points` - " .. price .. " WHERE `id` = " .. accountId)
                    
                    -- Add VIP
                    player:addVip(vipLevel, days)
                    
                    npcHandler:say(string.format(VIP_CONFIG.messages.vipPurchased, VIP_CONFIG.benefits[vipLevel].name, days), cid)
                    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
                else
                    npcHandler:say(string.format(VIP_CONFIG.messages.insufficientPoints, price), cid)
                end
            else
                npcHandler:say("Sorry, there was an error accessing your account.", cid)
            end

            npcHandler.topic[cid] = 0
            return true
        end
    end

    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
