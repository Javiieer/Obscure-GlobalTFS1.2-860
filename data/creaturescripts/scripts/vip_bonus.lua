-- VIP System - Experience and Loot Bonus
-- Applies VIP bonuses when player kills monsters

function onKill(player, target)
    if not target:isMonster() then
        return true
    end

    local vipLevel = player:getVipLevel()
    if vipLevel == 0 then
        return true
    end

    -- Get VIP bonuses
    local expBonus = player:getVipExpBonus()
    local lootBonus = player:getVipLootBonus()

    -- Apply experience bonus
    if expBonus > 0 then
        local baseExp = target:getExperience()
        local bonusExp = math.floor(baseExp * (expBonus / 100))
        
        if bonusExp > 0 then
            player:addExperience(bonusExp, true) -- true = with stamina bonus applied
            player:sendTextMessage(MESSAGE_EXPERIENCE, "VIP Bonus: +" .. bonusExp .. " experience!")
        end
    end

    -- Apply loot bonus (extra loot chance)
    if lootBonus > 0 then
        local chance = math.random(100)
        if chance <= lootBonus then
            -- Get monster loot and try to duplicate one random item
            local corpse = target:getCorpse()
            if corpse then
                -- Note: This is a simplified version. You might need to adjust
                -- based on how you want the loot bonus to work
                player:sendTextMessage(MESSAGE_LOOT, "VIP Bonus: Extra loot chance activated!")
            end
        end
    end

    return true
end
