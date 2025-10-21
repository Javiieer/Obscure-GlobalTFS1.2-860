dofile("data/lib/zombie_event.lua")

function onSay(player, words, param)
    if not ZombieEvent.isActive then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "No Zombie Event is currently active!")
        return false
    end

    if ZombieEvent.currentWave > 0 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Zombie Event has already started! Registration is closed.")
        return false
    end

    local playerId = player:getId()
    
    -- Verificar si ya está registrado
    if ZombieEvent.participants[playerId] then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You are already registered for the Zombie Event!")
        return false
    end

    -- Verificar límite de jugadores
    local participantCount = 0
    for _, _ in pairs(ZombieEvent.participants) do
        participantCount = participantCount + 1
    end

    if participantCount >= ZombieEvent.maxPlayers then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Zombie Event is full! (" .. ZombieEvent.maxPlayers .. "/" .. ZombieEvent.maxPlayers .. ")")
        return false
    end

    -- Verificar nivel mínimo (opcional)
    if player:getLevel() < 20 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need to be at least level 20 to join the Zombie Event!")
        return false
    end

    -- Registrar jugador
    ZombieEvent.participants[playerId] = {
        name = player:getName(),
        level = player:getLevel(),
        joinTime = os.time()
    }

    -- Teleportar a sala de espera
    local oldPos = player:getPosition()
    player:teleportTo(ZombieEvent.waitingRoom)
    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    oldPos:sendMagicEffect(CONST_ME_POFF)

    -- Mensaje de confirmación
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have joined the Zombie Event! Wait for the event to start...")
    
    -- Curar al jugador
    player:addHealth(player:getMaxHealth())
    player:addMana(player:getMaxMana())
    
    -- Broadcast de nuevo participante
    participantCount = participantCount + 1
    Game.broadcastMessage(player:getName() .. " joined the Zombie Event! (" .. participantCount .. "/" .. ZombieEvent.maxPlayers .. ")", MESSAGE_STATUS_WARNING)

    return false
end