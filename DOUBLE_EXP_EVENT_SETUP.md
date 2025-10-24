# Sistema de Evento de Doble Experiencia

## Descripción
Sistema automático que activa eventos de doble experiencia en días y horarios específicos configurables.

## Archivos del Sistema

### 1. Script Principal
- **Archivo**: `data/globalevents/scripts/double_exp_event.lua`
- **Función**: Verifica cada minuto si el evento debe estar activo según configuración

### 2. Registro del Evento
- **Archivo**: `data/globalevents/globalevents.xml`
- **Línea**: `<globalevent name="DoubleExpEvent" interval="60000" script="double_exp_event.lua" />`
- **Intervalo**: 60000ms (1 minuto)

## Configuración del Evento

### Días de la Semana
Editar el array `days` en `double_exp_event.lua`:
```lua
days = {6, 7}, -- Sábado y Domingo
```

**Códigos de días:**
- 1 = Lunes
- 2 = Martes
- 3 = Miércoles
- 4 = Jueves
- 5 = Viernes
- 6 = Sábado
- 7 = Domingo

**Ejemplos:**
- `days = {1, 2, 3, 4, 5}` - Lunes a Viernes
- `days = {6, 7}` - Fin de semana
- `days = {5, 6, 7}` - Viernes, Sábado y Domingo
- `days = {1, 2, 3, 4, 5, 6, 7}` - Todos los días

### Horarios del Evento
Editar el array `schedules`:
```lua
schedules = {
    {start = "18:00:00", finish = "23:59:59"}, -- Tarde-noche
    {start = "12:00:00", finish = "16:00:00"}  -- Mediodía
}
```

**Formato**: Hora militar 24h (HH:MM:SS)

**Ejemplos de configuración:**
```lua
-- Solo por las noches
schedules = {
    {start = "20:00:00", finish = "23:59:59"}
}

-- Mañana y noche
schedules = {
    {start = "08:00:00", finish = "12:00:00"},
    {start = "18:00:00", finish = "23:59:59"}
}

-- Todo el día
schedules = {
    {start = "00:00:00", finish = "23:59:59"}
}
```

### Multiplicador de Experiencia
Editar `expMultiplier`:
```lua
expMultiplier = 2, -- 2x exp (doble)
```

**Opciones:**
- `2` = Doble experiencia (200%)
- `3` = Triple experiencia (300%)
- `1.5` = 50% más de experiencia

### Mensajes del Evento
Editar el objeto `messages`:
```lua
messages = {
    start = "¡EVENTO DE DOBLE EXPERIENCIA ACTIVADO!",
    finish = "El evento de doble experiencia ha finalizado.",
    broadcast = "Recuerda: Evento de doble exp activo."
}
```

## Ejemplos de Configuración

### Ejemplo 1: Fin de Semana Completo
```lua
days = {6, 7}, -- Sábado y Domingo
schedules = {
    {start = "00:00:00", finish = "23:59:59"}
}
```

### Ejemplo 2: Happy Hours Entre Semana
```lua
days = {1, 2, 3, 4, 5}, -- Lunes a Viernes
schedules = {
    {start = "12:00:00", finish = "14:00:00"}, -- Almuerzo
    {start = "20:00:00", finish = "22:00:00"}  -- Noche
}
```

### Ejemplo 3: Viernes Social
```lua
days = {5}, -- Solo Viernes
schedules = {
    {start = "18:00:00", finish = "23:59:59"}
}
```

### Ejemplo 4: Evento 24/7
```lua
days = {1, 2, 3, 4, 5, 6, 7}, -- Todos los días
schedules = {
    {start = "00:00:00", finish = "23:59:59"}
}
```

## Funcionamiento

1. **Verificación Automática**: El script se ejecuta cada 60 segundos
2. **Detección de Inicio**: Cuando el evento comienza, envía mensaje broadcast a todos los jugadores
3. **Recordatorios**: Cada 30 minutos durante el evento, envía recordatorio
4. **Detección de Fin**: Cuando el evento termina, envía mensaje de despedida

## Mensajes del Sistema

### Inicio del Evento
```
¡EVENTO DE DOBLE EXPERIENCIA ACTIVADO! Disfruta de 2x exp durante las próximas horas.
```

### Durante el Evento (cada 30 min)
```
Recuerda: Evento de doble exp activo. ¡Aprovecha para subir de nivel!
```

### Fin del Evento
```
El evento de doble experiencia ha finalizado. ¡Gracias por jugar!
```

## Nota Importante sobre Rates

⚠️ **IMPORTANTE**: Este script usa el sistema de mensajes para informar a los jugadores sobre el evento.

**Para que el rate de experiencia cambie realmente**, necesitas una de estas soluciones:

### Opción 1: Modificar Source (C++)
Agregar función en el source de TFS para cambiar rates en runtime.

### Opción 2: Usar stages.xml Dinámico
Activar/desactivar `data/XML/stages.xml` mediante script y reload.

### Opción 3: Comando Manual
Crear un talkaction para que GMs cambien el rate:
```lua
-- En data/talkactions/scripts/changerate.lua
function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end
    
    local newRate = tonumber(param)
    if not newRate then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Uso: /exprate <numero>")
        return false
    end
    
    -- Aquí iría la función para cambiar el rate (requiere source modificado)
    Game.broadcastMessage("El rate de experiencia ha sido cambiado a " .. newRate .. "x", MESSAGE_EVENT_ADVANCE)
    return false
end
```

### Opción 4: Script con Bonificación Individual
Dar bonus de exp a cada jugador conectado durante el evento:
```lua
-- Aplicar storage a cada jugador con bonus de exp
for _, player in ipairs(Game.getPlayers()) do
    player:setStorageValue(STORAGE_EXP_BONUS, 100) -- 100% más = doble
end
```

## Activación

1. Edita la configuración en `double_exp_event.lua`
2. Reinicia el servidor o usa `/reload globalevents`
3. El sistema comenzará a verificar automáticamente

## Desactivación

Para desactivar temporalmente sin borrar el script:

**Opción 1**: Comentar en `globalevents.xml`:
```xml
<!--<globalevent name="DoubleExpEvent" interval="60000" script="double_exp_event.lua" />-->
```

**Opción 2**: Configurar días vacíos:
```lua
days = {}, -- Sin días activos
```

## Storage Key Utilizado

- **Key**: `50001` (GlobalStorage.DoubleExpEvent)
- **Valores**: 
  - `0` = Evento inactivo
  - `1` = Evento activo

## Requisitos del Sistema

- TFS 1.2+
- Lua 5.1+
- Permisos de escritura en game storage

## Soporte y Personalización

Para personalizar más el evento:
- Cambiar intervalos de verificación (60000ms en globalevents.xml)
- Agregar efectos visuales cuando el evento comienza
- Agregar recompensas adicionales durante el evento
- Integrar con sistema de stages.xml para rates reales
