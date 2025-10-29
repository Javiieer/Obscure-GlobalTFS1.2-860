-- VIP Gold Visual Effects
-- Shows [VIP] text and fireworks every 30 seconds for VIP Gold (Level 3) players

function onThink(interval, lastExecution)
    print("[VIP System] Running VIP Gold effects check...")
    
    local players = Game.getPlayers()
    print("[VIP System] Online players: " .. #players)
    
    for _, player in ipairs(players) do
        local vipLevel = player:getVipLevel()
        print("[VIP System] Player: " .. player:getName() .. " - VIP Level: " .. vipLevel)
        
        -- Only VIP Gold (Level 3) gets the special effects
        if vipLevel == 3 then
            local playerPos = player:getPosition()
            
            print("[VIP System] Applying VIP Gold effects to " .. player:getName())
            
            -- Send fireworks effect
            playerPos:sendMagicEffect(CONST_ME_FIREWORK_RED)
            
            -- Send animated text [VIP] - Try different method
            local animatedText = Game.createItem(2, 1) -- Create temporary item for text
            if animatedText then
                animatedText:remove()
            end
            
            -- Create text effect manually
            player:say("[VIP GOLD]", TALKTYPE_MONSTER_SAY)
            
            -- Send message to player
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "[VIP GOLD] Active!")
        end
    end
    
    return true
end
