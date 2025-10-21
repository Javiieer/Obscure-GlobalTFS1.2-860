# 🧟 SISTEMA ZOMBIE EVENT - GUÍA DE INSTALACIÓN

## 📋 ARCHIVOS CREADOS:
- `/data/lib/zombie_event.lua` - Configuración principal
- `/data/talkactions/scripts/zombie_event.lua` - Comandos de administración
- `/data/talkactions/scripts/join_zombie.lua` - Comando para unirse
- `/data/creaturescripts/scripts/zombie_event_death.lua` - Manejo de muertes
- Registrados en `talkactions.xml` y `creaturescripts.xml`

## 🗺️ CONFIGURACIÓN DE COORDENADAS (OBLIGATORIO)

### 📍 Editar archivo: `/data/lib/zombie_event.lua`

**LÍNEAS A CAMBIAR:**

```lua
-- LÍNEA 7: Sala de espera (donde aparecen los jugadores al unirse)
waitingRoom = {x = 1000, y = 1000, z = 7}, -- CAMBIAR POR TUS COORDENADAS

-- LÍNEAS 10-11: Área del evento (rectángulo donde ocurre el evento)
eventArea = {
    fromPos = {x = 1010, y = 1010, z = 7}, -- Esquina noroeste
    toPos = {x = 1050, y = 1050, z = 7}     -- Esquina sureste
},

-- LÍNEAS 15-20: Spawns de zombies (donde aparecen los monsters)
zombieSpawns = {
    {x = 1015, y = 1015, z = 7}, -- Spawn 1
    {x = 1045, y = 1015, z = 7}, -- Spawn 2
    {x = 1030, y = 1045, z = 7}, -- Spawn 3
    {x = 1015, y = 1045, z = 7}, -- Spawn 4
    -- Puedes agregar más spawns aquí
},

-- LÍNEA 24: Posición de salida (temple/spawn principal)
exitPosition = {x = 160, y = 54, z = 7}, -- CAMBIAR POR TU TEMPLE
```

## 🎮 COMANDOS DISPONIBLES:

### 👑 **Comandos de GM:**
- `/zombieevent start` - Iniciar evento
- `/zombieevent stop` - Detener evento  
- `/zombieevent status` - Ver estado del evento
- `/zombieevent config` - Ver configuración actual
- `/zombieevent clean` - Limpiar área del evento

### 👥 **Comandos de Jugadores:**
- `!joinzombie` - Unirse al evento

## 🏗️ REQUISITOS DEL MAPA:

### 📐 **Área del Evento:**
1. **Tamaño recomendado:** 40x40 tiles mínimo
2. **Terreno:** Preferiblemente plano, sin obstáculos grandes
3. **Acceso:** No debe ser accesible desde el mundo normal
4. **Paredes:** Área cerrada para evitar que escapen

### 🚪 **Sala de Espera:**
1. **Ubicación:** Separada del área del evento
2. **Tamaño:** Para 20+ jugadores
3. **Decoración:** Opcional (bancas, carteles informativos)

### 👹 **Spawns de Zombies:**
1. **Cantidad:** 4-8 spawns recomendados
2. **Distribución:** Esparcidos por el área
3. **Distancia:** Al menos 10 tiles entre spawns

## ⚙️ CONFIGURACIÓN AVANZADA:

### 🔢 **Parámetros del Evento (en zombie_event.lua):**
```lua
maxWaves = 10,           -- Número de oleadas
waveDuration = 120,      -- Segundos entre oleadas
registrationTime = 60,   -- Tiempo de registro
minPlayers = 2,          -- Mínimo de jugadores
maxPlayers = 20,         -- Máximo de jugadores
```

### 👹 **Configuración de Oleadas:**
```lua
waveConfig = {
    [1] = {count = 3, monsters = {"rat", "cave rat"}},
    [2] = {count = 5, monsters = {"skeleton", "ghoul"}},
    -- Personalizar según tu servidor
}
```

### 🎁 **Recompensas por Oleada:**
```lua
rewards = {
    [1] = {items = {{2148, 100}}, exp = 5000},    -- Gold coins y exp
    [3] = {items = {{2148, 200}, {2160, 1}}, exp = 10000}, -- +crystal coin
    -- Personalizar recompensas
}
```

## 🚀 PASOS DE INSTALACIÓN:

1. **✅ Archivos ya creados** - El sistema está instalado
2. **📝 Configurar coordenadas** - Editar `/data/lib/zombie_event.lua`
3. **🗺️ Crear el mapa** - Área del evento + sala de espera
4. **🔄 Reiniciar servidor** - Para cargar los nuevos scripts
5. **🧪 Probar evento** - `/zombieevent start`

## 📝 EJEMPLO DE USO:

1. GM: `/zombieevent start`
2. Jugadores: `!joinzombie` (durante tiempo de registro)
3. Evento inicia automáticamente
4. 10 oleadas progresivas
5. Recompensas automáticas
6. Fin automático cuando todos mueren o completan oleadas

## 🐛 REGISTRO DE MUERTES:

**IMPORTANTE:** Para que funcione el sistema de eliminación, agregar esto al login.lua principal:

```lua
-- Agregar esta línea en login.lua
player:registerEvent("ZombieEventDeath")
```

## 🎯 EJEMPLO DE COORDENADAS:

```lua
-- Ejemplo basado en un área 40x40:
waitingRoom = {x = 100, y = 100, z = 7},
eventArea = {
    fromPos = {x = 120, y = 120, z = 7},
    toPos = {x = 160, y = 160, z = 7}
},
zombieSpawns = {
    {x = 125, y = 125, z = 7}, -- Noroeste
    {x = 155, y = 125, z = 7}, -- Noreste  
    {x = 125, y = 155, z = 7}, -- Suroeste
    {x = 155, y = 155, z = 7}, -- Sureste
    {x = 140, y = 140, z = 7}, -- Centro
},
exitPosition = {x = 160, y = 54, z = 7}, -- Temple Thais
```

¡Sistema listo para usar! Solo configura las coordenadas según tu mapa. 🎮