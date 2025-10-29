-- VIP Gold Visual Effects
-- Shows [VIP] text and fireworks every 30 seconds for VIP Gold (Level 3) players

local vipGoldEffects = GlobalEvent("vipGoldEffects")

function vipGoldEffects.onThink(interval)
    local players = Game.getPlayers()
    
    for _, player in ipairs(players) do
        local vipLevel = player:getVipLevel()
        
        -- Only VIP Gold (Level 3) gets the special effects
        if vipLevel == 3 then
            local playerPos = player:getPosition()
            
            -- Send fireworks effect
            playerPos:sendMagicEffect(CONST_ME_FIREWORK_RED)
            
            -- Send animated text [VIP]
            local spectators = Game.getSpectators(playerPos, false, true, 7, 7, 5, 5)
            for _, spectator in ipairs(spectators) do
                spectator:say("[VIP]", TALKTYPE_MONSTER_SAY, false, spectator, playerPos)
            end
        end
    end
    
    return true
end

vipGoldEffects:interval(30000) -- 30 seconds = 30000 milliseconds
vipGoldEffects:register()
