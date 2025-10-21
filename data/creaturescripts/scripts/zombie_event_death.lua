dofile(getDataDir() .. "lib/zombie_event.lua")

function onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    -- Verificar si el jugador está en el evento zombie
    if not ZombieEvent.isActive then
        return true
    end
    
    local playerId = player:getId()
    if not ZombieEvent.participants[playerId] then
        return true
    end
    
    if not ZombieEvent.isInEventArea(player:getPosition()) then
        return true
    end
    
    -- El jugador murió en el evento zombie
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been eliminated from the Zombie Event!")
    
    -- Programar teleport después de la muerte
    addEvent(function()
        local deadPlayer = Player(playerId)
        if deadPlayer then
            deadPlayer:teleportTo(ZombieEvent.exitPosition)
            deadPlayer:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        end
    end, 3000) -- 3 segundos después de morir
    
    -- Anunciar eliminación
    Game.broadcastMessage(player:getName() .. " has been eliminated from the Zombie Event!", MESSAGE_STATUS_WARNING)
    
    -- Verificar si quedan jugadores vivos
    local alivePlayers = 0
    for participantId, _ in pairs(ZombieEvent.participants) do
        if participantId ~= playerId then -- Excluir al jugador que acaba de morir
            local participant = Player(participantId)
            if participant and ZombieEvent.isInEventArea(participant:getPosition()) then
                alivePlayers = alivePlayers + 1
            end
        end
    end
    
    if alivePlayers == 0 then
        addEvent(function()
            Game.broadcastMessage("All players have been eliminated! Zombie Event ended!", MESSAGE_STATUS_WARNING)
            ZombieEvent.endEvent()
        end, 1000)
    end
    
    return true -- Permitir muerte normal
end