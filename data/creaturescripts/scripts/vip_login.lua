-- VIP System - Login Check
-- Updates VIP days and notifies player of VIP status

function onLogin(player)
    local vipLevel = player:getVipLevel()
    
    if vipLevel > 0 then
        local vipDays = player:getVipDays()
        
        -- Get last check from database
        local resultId = db.storeQuery("SELECT `vip_lastday` FROM `players` WHERE `id` = " .. player:getId())
        local lastCheck = 0
        if resultId then
            lastCheck = result.getNumber(resultId, "vip_lastday")
            result.free(resultId)
        end
        
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
        db.query("UPDATE `players` SET `vip_lastday` = " .. currentTime .. " WHERE `id` = " .. player:getId())
        
        -- Send welcome message
        local vipName = player:getVipName()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(VIP_CONFIG.messages.vipActive, vipName, vipDays))
    end
    
    return true
end
