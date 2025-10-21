dofile("data/lib/zombie_event.lua")

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local split = param:split(" ")
    local command = split[1]

    if command == "start" then
        if ZombieEvent.isActive then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Zombie Event is already active!")
            return false
        end

        -- Iniciar evento
        ZombieEvent.isActive = true
        ZombieEvent.currentWave = 0
        ZombieEvent.participants = {}
        
        Game.broadcastMessage("=== ZOMBIE EVENT STARTING ===", MESSAGE_STATUS_WARNING)
        Game.broadcastMessage("Registration is now open! Type '!joinzombie' to participate!", MESSAGE_STATUS_WARNING)
        Game.broadcastMessage("Registration will close in " .. ZombieEvent.registrationTime .. " seconds!", MESSAGE_STATUS_WARNING)
        
        -- Programar inicio después del tiempo de registro
        addEvent(function()
            if #ZombieEvent.participants < ZombieEvent.minPlayers then
                Game.broadcastMessage("Zombie Event cancelled - not enough players!", MESSAGE_STATUS_WARNING)
                ZombieEvent.endEvent()
                return
            end
            
            Game.broadcastMessage("Zombie Event starting! Wave 1 incoming!", MESSAGE_STATUS_WARNING)
            ZombieEvent.currentWave = 1
            ZombieEvent.spawnWave(1)
            
            -- Programar siguiente oleada
            ZombieEvent.scheduleNextWave()
            
        end, ZombieEvent.registrationTime * 1000)
        
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Zombie Event started! Registration open for " .. ZombieEvent.registrationTime .. " seconds.")

    elseif command == "stop" then
        if not ZombieEvent.isActive then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "No Zombie Event is currently active!")
            return false
        end
        
        ZombieEvent.endEvent()
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Zombie Event stopped!")

    elseif command == "status" then
        if ZombieEvent.isActive then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Zombie Event Status:")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Active: Yes")
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Current Wave: " .. ZombieEvent.currentWave)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Participants: " .. #ZombieEvent.participants)
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "No Zombie Event is currently active.")
        end

    elseif command == "config" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "=== Zombie Event Configuration ===")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Waiting Room: " .. ZombieEvent.waitingRoom.x .. ", " .. ZombieEvent.waitingRoom.y .. ", " .. ZombieEvent.waitingRoom.z)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Event Area: " .. ZombieEvent.eventArea.fromPos.x .. "," .. ZombieEvent.eventArea.fromPos.y .. " to " .. ZombieEvent.eventArea.toPos.x .. "," .. ZombieEvent.eventArea.toPos.y)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Max Waves: " .. ZombieEvent.maxWaves)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Wave Duration: " .. ZombieEvent.waveDuration .. " seconds")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Min Players: " .. ZombieEvent.minPlayers)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Max Players: " .. ZombieEvent.maxPlayers)

    elseif command == "clean" then
        ZombieEvent.cleanArea()
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Event area cleaned!")

    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Zombie Event Commands:")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/zombieevent start - Start the event")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/zombieevent stop - Stop the event")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/zombieevent status - Check event status")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/zombieevent config - Show configuration")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "/zombieevent clean - Clean event area")
    end

    return false
end

-- Función para programar la siguiente oleada
function ZombieEvent.scheduleNextWave()
    addEvent(function()
        if not ZombieEvent.isActive then return end
        
        -- Verificar si quedan jugadores vivos en el área
        local alivePlayers = 0
        for playerId, _ in pairs(ZombieEvent.participants) do
            local player = Player(playerId)
            if player and ZombieEvent.isInEventArea(player:getPosition()) then
                alivePlayers = alivePlayers + 1
            end
        end
        
        if alivePlayers == 0 then
            Game.broadcastMessage("All players have been eliminated! Zombie Event ended!", MESSAGE_STATUS_WARNING)
            ZombieEvent.endEvent()
            return
        end
        
        -- Limpiar monsters restantes
        ZombieEvent.cleanArea()
        
        -- Dar recompensas por oleada completada
        for playerId, _ in pairs(ZombieEvent.participants) do
            local player = Player(playerId)
            if player and ZombieEvent.isInEventArea(player:getPosition()) then
                ZombieEvent.giveRewards(player, ZombieEvent.currentWave)
            end
        end
        
        -- Verificar si es la última oleada
        if ZombieEvent.currentWave >= ZombieEvent.maxWaves then
            Game.broadcastMessage("Congratulations! All waves completed! You are the survivors!", MESSAGE_STATUS_WARNING)
            ZombieEvent.endEvent()
            return
        end
        
        -- Siguiente oleada
        ZombieEvent.currentWave = ZombieEvent.currentWave + 1
        Game.broadcastMessage("Wave " .. ZombieEvent.currentWave .. " incoming! Get ready!", MESSAGE_STATUS_WARNING)
        
        addEvent(function()
            ZombieEvent.spawnWave(ZombieEvent.currentWave)
            ZombieEvent.scheduleNextWave()
        end, 5000) -- 5 segundos de preparación
        
    end, ZombieEvent.waveDuration * 1000)
end