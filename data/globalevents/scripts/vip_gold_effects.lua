-- VIP Gold Visual Effects
-- Shows [VIP] text and fireworks every 30 seconds for VIP Gold (Level 3) players

function onThink(interval, lastExecution)
    local players = Game.getPlayers()
    
    for _, player in ipairs(players) do
        local vipLevel = player:getVipLevel()
        
        -- Only VIP Gold (Level 3) gets the special effects
        if vipLevel == 3 then
            local playerPos = player:getPosition()
            
            -- Send fireworks effect
            playerPos:sendMagicEffect(CONST_ME_FIREWORK_RED)
            
            -- Send animated text [VIP] above player
            Game.sendAnimatedText("[VIP]", playerPos, TEXTCOLOR_LIGHTBLUE)
            
            -- Optional: Send message to player
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "VIP Gold Active!")
        end
    end
    
    return true
end
