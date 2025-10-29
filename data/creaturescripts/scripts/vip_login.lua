-- VIP System - Login Check
-- Updates VIP days and notifies player of VIP status

function onLogin(player)
    local vipLevel = player:getVipLevel()
    
    if vipLevel > 0 then
        local vipDays = player:getVipDays()
        local lastCheck = player:getStorageValue(VIP_CONFIG.storage.vipLastCheck)
        local currentTime = os.time()
        
        -- Calculate days passed since last login
        if lastCheck > 0 then
            local daysPassed = math.floor((currentTime - lastCheck) / 86400) -- 86400 seconds in a day
            
            if daysPassed > 0 then
                local newDays = math.max(0, vipDays - daysPassed)
                player:setVipDays(newDays)
                
                -- VIP expired
                if newDays == 0 then
                    player:removeVip()
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, VIP_CONFIG.messages.vipExpired)
                    return true
                end
                
                vipDays = newDays
            end
        end
        
        -- Update last check time
        player:setStorageValue(VIP_CONFIG.storage.vipLastCheck, currentTime)
        
        -- Send welcome message
        local vipName = player:getVipName()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(VIP_CONFIG.messages.vipActive, vipName, vipDays))
    end
    
    return true
end
