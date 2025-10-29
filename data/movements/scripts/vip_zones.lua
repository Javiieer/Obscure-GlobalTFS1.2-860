-- VIP Zone Access Control
-- Action ID system for VIP zones
-- ActionID 50001 = VIP Level 1 required
-- ActionID 50002 = VIP Level 2 required
-- ActionID 50003 = VIP Level 3 required

local vipZones = {
    [50001] = {level = 1, name = "VIP Zone 1"},
    [50002] = {level = 2, name = "VIP Zone 2"},
    [50003] = {level = 3, name = "VIP Zone 3"}
}

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end
    
    local zoneInfo = vipZones[item.actionid]
    if not zoneInfo then
        return true
    end
    
    local requiredLevel = zoneInfo.level
    local playerVipLevel = player:getVipLevel()
    
    if playerVipLevel >= requiredLevel then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to " .. zoneInfo.name .. "!")
        return true
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(VIP_CONFIG.messages.noAccess, requiredLevel))
        player:teleportTo(fromPosition, true)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        return false
    end
end
