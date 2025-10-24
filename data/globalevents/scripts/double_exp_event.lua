-- Double Experience Event System
-- Configura los días y horarios específicos para el evento de doble exp

local config = {
    -- Días de la semana (1 = Lunes, 7 = Domingo)
    days = {6, 7}, -- Sábado y Domingo
    
    -- Horarios del evento (formato 24h)
    schedules = {
        {start = "18:00:00", finish = "23:59:59"}, -- Viernes/Sábado/Domingo tarde-noche
        {start = "12:00:00", finish = "16:00:00"}  -- Sábado/Domingo mediodía
    },
    
    -- Multiplicador de experiencia durante el evento
    expMultiplier = 2, -- 2x exp (doble experiencia)
    
    -- Mensajes
    messages = {
        start = "¡EVENTO DE DOBLE EXPERIENCIA ACTIVADO! Disfruta de %dx exp durante las próximas horas.",
        finish = "El evento de doble experiencia ha finalizado. ¡Gracias por jugar!",
        broadcast = "Recuerda: Evento de doble exp activo. ¡Aprovecha para subir de nivel!"
    }
}

local function isEventActive()
    local currentDay = os.date("*t").wday -- 1=Domingo, 2=Lunes, ..., 7=Sábado
    -- Convertir al formato usado en config (1=Lunes, 7=Domingo)
    local dayConverted = currentDay == 1 and 7 or currentDay - 1
    
    -- Verificar si hoy es un día de evento
    local isDayActive = false
    for _, day in ipairs(config.days) do
        if day == dayConverted then
            isDayActive = true
            break
        end
    end
    
    if not isDayActive then
        return false
    end
    
    -- Verificar si estamos en un horario de evento
    local currentTime = os.date("%H:%M:%S")
    for _, schedule in ipairs(config.schedules) do
        if currentTime >= schedule.start and currentTime <= schedule.finish then
            return true
        end
    end
    
    return false
end

local function setExperienceRate(multiplier)
    local baseRate = configManager.getNumber(configKeys.RATE_EXPERIENCE)
    local newRate = baseRate * multiplier
    
    -- Nota: En TFS 1.2, no hay una función directa para cambiar rates en runtime
    -- Esta función es conceptual y requeriría modificación del source o uso de stages.xml
    -- Por ahora, enviamos el mensaje a los jugadores
    return true
end

local function broadcastEventMessage(message)
    Game.broadcastMessage(string.format(message, config.expMultiplier), MESSAGE_EVENT_ADVANCE)
end

-- Función que se ejecuta cada minuto para verificar el estado del evento
function onThink(interval)
    local isActive = isEventActive()
    local storageKey = GlobalStorage.DoubleExpEvent or 50001
    local wasActive = Game.getStorageValue(storageKey) == 1
    
    if isActive and not wasActive then
        -- El evento acaba de comenzar
        broadcastEventMessage(config.messages.start)
        Game.setStorageValue(storageKey, 1)
        
        -- Broadcast cada 30 minutos mientras el evento está activo
        addEvent(function()
            if isEventActive() then
                broadcastEventMessage(config.messages.broadcast)
            end
        end, 30 * 60 * 1000)
        
    elseif not isActive and wasActive then
        -- El evento acaba de terminar
        broadcastEventMessage(config.messages.finish)
        Game.setStorageValue(storageKey, 0)
    end
    
    return true
end
