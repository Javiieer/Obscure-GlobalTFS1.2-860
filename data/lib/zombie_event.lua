-- Zombie Event System
-- Configuración principal del evento

ZombieEvent = {
    -- ===== CONFIGURACIÓN DE COORDENADAS =====
    -- CAMBIAR ESTAS COORDENADAS SEGÚN TU MAPA
    
    -- Posición donde aparecen los jugadores al unirse
    waitingRoom = {x = 1000, y = 1000, z = 7}, -- CAMBIAR: Sala de espera
    
    -- Área del evento (esquina superior izquierda y inferior derecha)
    eventArea = {
        fromPos = {x = 1010, y = 1010, z = 7}, -- CAMBIAR: Esquina NW del área
        toPos = {x = 1050, y = 1050, z = 7}     -- CAMBIAR: Esquina SE del área
    },
    
    -- Posiciones donde aparecen los zombies (agregar más según necesites)
    zombieSpawns = {
        {x = 1015, y = 1015, z = 7}, -- CAMBIAR: Spawn 1
        {x = 1045, y = 1015, z = 7}, -- CAMBIAR: Spawn 2
        {x = 1030, y = 1045, z = 7}, -- CAMBIAR: Spawn 3
        {x = 1015, y = 1045, z = 7}, -- CAMBIAR: Spawn 4
        -- Agregar más spawns aquí si necesitas
    },
    
    -- Posición de retorno (donde vuelven los jugadores al terminar)
    exitPosition = {x = 160, y = 54, z = 7}, -- CAMBIAR: Temple/spawn principal
    
    -- ===== CONFIGURACIÓN DEL EVENTO =====
    isActive = false,
    participants = {},
    currentWave = 0,
    maxWaves = 10,
    waveDuration = 120, -- segundos entre oleadas
    registrationTime = 60, -- tiempo de registro en segundos
    minPlayers = 2,
    maxPlayers = 20,
    
    -- Configuración de oleadas (zombies por oleada)
    waveConfig = {
        [1] = {count = 3, monsters = {"rat", "cave rat"}},
        [2] = {count = 5, monsters = {"skeleton", "ghoul"}},
        [3] = {count = 7, monsters = {"zombie", "ghoul"}},
        [4] = {count = 8, monsters = {"zombie", "crypt shambler"}},
        [5] = {count = 10, monsters = {"demon skeleton", "necromancer"}},
        [6] = {count = 12, monsters = {"lich", "demon skeleton"}},
        [7] = {count = 15, monsters = {"dragon", "demon"}},
        [8] = {count = 18, monsters = {"dragon lord", "demon"}},
        [9] = {count = 20, monsters = {"hydra", "medusa"}},
        [10] = {count = 1, monsters = {"ferumbras"}} -- Boss final
    },
    
    -- Recompensas por oleada sobrevivida
    rewards = {
        [1] = {items = {{2148, 100}}, exp = 5000},
        [3] = {items = {{2148, 200}, {2160, 1}}, exp = 10000},
        [5] = {items = {{2148, 500}, {2160, 2}}, exp = 20000},
        [7] = {items = {{2148, 1000}, {2160, 5}}, exp = 50000},
        [10] = {items = {{2148, 2000}, {2160, 10}, {2472, 1}}, exp = 100000} -- Premio final
    }
}

-- Función para verificar si una posición está en el área del evento
function ZombieEvent.isInEventArea(position)
    return position.x >= ZombieEvent.eventArea.fromPos.x 
        and position.x <= ZombieEvent.eventArea.toPos.x
        and position.y >= ZombieEvent.eventArea.fromPos.y 
        and position.y <= ZombieEvent.eventArea.toPos.y
        and position.z == ZombieEvent.eventArea.fromPos.z
end

-- Función para limpiar el área del evento
function ZombieEvent.cleanArea()
    for x = ZombieEvent.eventArea.fromPos.x, ZombieEvent.eventArea.toPos.x do
        for y = ZombieEvent.eventArea.fromPos.y, ZombieEvent.eventArea.toPos.y do
            local pos = {x = x, y = y, z = ZombieEvent.eventArea.fromPos.z}
            local tile = Tile(pos)
            if tile then
                local creatures = tile:getCreatures()
                if creatures then
                    for _, creature in pairs(creatures) do
                        if creature:isMonster() then
                            creature:remove()
                        end
                    end
                end
            end
        end
    end
end

-- Función para crear una oleada de zombies
function ZombieEvent.spawnWave(waveNumber)
    local config = ZombieEvent.waveConfig[waveNumber]
    if not config then return false end
    
    for i = 1, config.count do
        local spawnPos = ZombieEvent.zombieSpawns[math.random(1, #ZombieEvent.zombieSpawns)]
        local monsterName = config.monsters[math.random(1, #config.monsters)]
        
        local monster = Game.createMonster(monsterName, spawnPos)
        if monster then
            -- Configurar el monster para que persiga jugadores
            monster:setTarget(nil)
        end
    end
    
    return true
end

-- Función para dar recompensas
function ZombieEvent.giveRewards(player, wave)
    local reward = ZombieEvent.rewards[wave]
    if reward then
        -- Dar items
        if reward.items then
            for _, item in pairs(reward.items) do
                player:addItem(item[1], item[2])
            end
        end
        
        -- Dar experiencia
        if reward.exp then
            player:addExperience(reward.exp)
        end
        
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Wave " .. wave .. " completed! You received rewards!")
    end
end

-- Función para terminar el evento
function ZombieEvent.endEvent()
    ZombieEvent.isActive = false
    ZombieEvent.currentWave = 0
    
    -- Teleportar jugadores de vuelta
    for playerId, _ in pairs(ZombieEvent.participants) do
        local player = Player(playerId)
        if player then
            player:teleportTo(ZombieEvent.exitPosition)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Zombie Event has ended! Thanks for participating!")
        end
    end
    
    ZombieEvent.participants = {}
    ZombieEvent.cleanArea()
    
    Game.broadcastMessage("Zombie Event has ended!", MESSAGE_STATUS_WARNING)
end