# VIP System - Pay to Win Zones
## Sistema de VIP con 3 niveles para zonas exclusivas

---

## 📋 Tabla de Contenidos
1. [Descripción General](#descripción-general)
2. [Beneficios por Nivel](#beneficios-por-nivel)
3. [Configuración de Precios](#configuración-de-precios)
4. [Configuración de Bonificaciones](#configuración-de-bonificaciones)
5. [Instalación](#instalación)
6. [Uso del Sistema](#uso-del-sistema)
7. [Comandos de Administración](#comandos-de-administración)
8. [Configuración de Zonas VIP](#configuración-de-zonas-vip)
9. [Personalización](#personalización)

---

## 🎮 Descripción General

Sistema VIP completo con 3 niveles que otorga beneficios progresivos:
- **Bonificaciones de experiencia** (+10%, +20%, +30%)
- **Bonificaciones de loot** (+5%, +15%, +25%)
- **Acceso a zonas exclusivas** con mejores spawns
- **Teleports VIP** (niveles 2 y 3)
- **Descuentos en trainers** (nivel 3: 50% descuento)

Los jugadores compran VIP con **premium points** a través del NPC "VIP Seller".

---

## ⭐ Beneficios por Nivel

### VIP 1 - Bronze 🥉
- **+10% experiencia extra**
- **+5% loot extra**
- Acceso a **VIP Zone 1**
- Duración: 7, 15 o 30 días

### VIP 2 - Silver 🥈
- **+20% experiencia extra**
- **+15% loot extra**
- Acceso a **VIP Zone 1 y 2**
- **Teleports a zonas VIP**
- Duración: 7, 15 o 30 días

### VIP 3 - Gold 🥇
- **+30% experiencia extra**
- **+25% loot extra**
- Acceso a **todas las zonas VIP**
- **Teleports ilimitados**
- **50% descuento en trainers**
- Duración: 7, 15 o 30 días

---

## 💰 Configuración de Precios

### Precios Actuales (Premium Points)

| Nivel | 7 días | 15 días | 30 días |
|-------|--------|---------|---------|
| VIP 1 | 150    | 300     | 500     |
| VIP 2 | 300    | 550     | 900     |
| VIP 3 | 500    | 900     | 1500    |

### 📝 Cómo Modificar Precios

Edita el archivo: `data/lib/vip_system.lua`

```lua
prices = {
    [1] = { -- VIP Level 1
        [7] = 150,      -- 7 days
        [15] = 300,     -- 15 days
        [30] = 500      -- 30 days
    },
    [2] = { -- VIP Level 2
        [7] = 300,
        [15] = 550,
        [30] = 900
    },
    [3] = { -- VIP Level 3
        [7] = 500,
        [15] = 900,
        [30] = 1500
    }
}
```

**Ejemplo:** Para cambiar VIP 1 de 30 días a 400 points:
```lua
[1] = {
    [7] = 150,
    [15] = 300,
    [30] = 400  -- Cambiado de 500 a 400
}
```

---

## 🎯 Configuración de Bonificaciones

### Bonificaciones Actuales

Edita el archivo: `data/lib/vip_system.lua`

```lua
benefits = {
    [1] = { -- VIP Level 1
        expBonus = 10,      -- +10% experience
        lootBonus = 5,      -- +5% loot chance
        name = "VIP Bronze",
        zoneName = "VIP Zone 1"
    },
    [2] = { -- VIP Level 2
        expBonus = 20,      -- +20% experience
        lootBonus = 15,     -- +15% loot chance
        name = "VIP Silver",
        zoneName = "VIP Zone 2",
        hasTeleport = true
    },
    [3] = { -- VIP Level 3
        expBonus = 30,      -- +30% experience
        lootBonus = 25,     -- +25% loot chance
        name = "VIP Gold",
        zoneName = "All VIP Zones",
        hasTeleport = true,
        trainerDiscount = 50 -- 50% discount
    }
}
```

### 📝 Ejemplos de Modificación

**Aumentar bonus de exp VIP 3 a 50%:**
```lua
[3] = {
    expBonus = 50,  -- Cambiado de 30 a 50
    lootBonus = 25,
    -- ... resto igual
}
```

**Cambiar descuento de trainers a 75%:**
```lua
[3] = {
    -- ...
    trainerDiscount = 75  -- Cambiado de 50 a 75
}
```

**Agregar teleports a VIP 1:**
```lua
[1] = {
    expBonus = 10,
    lootBonus = 5,
    name = "VIP Bronze",
    zoneName = "VIP Zone 1",
    hasTeleport = true  -- Agregar esta línea
}
```

---

## 🔧 Instalación

### 1. Base de Datos

Ejecuta este query en tu MySQL para agregar campos VIP:

```sql
ALTER TABLE `players` 
ADD `vip_level` tinyint(1) NOT NULL DEFAULT '0',
ADD `vip_days` int(11) NOT NULL DEFAULT '0',
ADD `vip_lastday` int(11) NOT NULL DEFAULT '0';
```

**Nota:** Si instalaste desde el `Schema.sql` actualizado, estos campos ya están incluidos.

### 2. Archivos del Sistema

Los siguientes archivos ya están creados:

#### Librería Principal
- `data/lib/vip_system.lua` - Configuración y funciones

#### Scripts de Creaturescripts
- `data/creaturescripts/scripts/vip_login.lua` - Verifica VIP al login
- `data/creaturescripts/scripts/vip_bonus.lua` - Aplica bonus exp/loot
- `data/creaturescripts/creaturescripts.xml` - ✅ Registrado

#### Scripts de Movements
- `data/movements/scripts/vip_zones.lua` - Control de acceso a zonas
- `data/movements/movements.xml` - ✅ Registrado

#### NPC Vendedor
- `data/npc/scripts/vip_seller.lua` - Script del NPC
- `data/npc/VIP Seller.xml` - XML del NPC

#### Comandos de Admin
- `data/talkactions/scripts/vip_add.lua` - `/addvip`
- `data/talkactions/scripts/vip_remove.lua` - `/removevip`
- `data/talkactions/scripts/vip_check.lua` - `/checkvip`
- `data/talkactions/talkactions.xml` - ✅ Registrado

### 3. Reiniciar Servidor

Reinicia el servidor para cargar todos los scripts:
```bash
# En Windows
Ctrl+C en la consola del servidor
# Luego reinicia el ejecutable
```

---

## 🎮 Uso del Sistema

### Comprar VIP (Jugadores)

1. **Encuentra al NPC "VIP Seller"**
   - Colócalo en una ciudad principal (Thais, Carlin, etc.)
   - Usa el RME para colocar el NPC en el mapa

2. **Habla con el NPC:**
   ```
   Player: hi
   VIP Seller: Hello! I sell VIP access. Say 'benefits' to learn more!
   
   Player: benefits
   VIP Seller: [Muestra info de todos los niveles]
   
   Player: buy vip 2
   VIP Seller: VIP 2 costs 300 points for 7 days, 550 for 15 days...
   
   Player: 30 days
   VIP Seller: You want VIP 2 for 30 days for 900 premium points. Confirm?
   
   Player: yes
   VIP Seller: You have purchased VIP Silver for 30 days!
   ```

3. **El VIP se activa inmediatamente** y cuenta los días cada vez que el jugador entra.

### Ver Estado VIP

Los jugadores pueden usar:
```
/checkvip
```
Para ver su propio estado VIP (si tienen permisos).

---

## 🛠️ Comandos de Administración

### `/addvip` - Dar VIP a un Jugador

**Sintaxis:**
```
/addvip PlayerName, VipLevel, Days
```

**Ejemplos:**
```
/addvip John Doe, 1, 30
/addvip Admin, 3, 365
/addvip NewPlayer, 2, 7
```

**Notas:**
- El jugador debe estar online
- VipLevel: 1, 2 o 3
- Days: cualquier número positivo

### `/removevip` - Quitar VIP a un Jugador

**Sintaxis:**
```
/removevip PlayerName
```

**Ejemplo:**
```
/removevip John Doe
```

### `/checkvip` - Verificar Estado VIP

**Sintaxis:**
```
/checkvip [PlayerName]
```

**Ejemplos:**
```
/checkvip              # Verifica tu propio VIP
/checkvip John Doe     # Verifica el VIP de otro jugador
```

**Muestra:**
- Nivel VIP actual
- Días restantes
- Bonificaciones activas

---

## 🗺️ Configuración de Zonas VIP

### Crear Zonas VIP en el Mapa

Usa el **Remere's Map Editor** para crear zonas VIP:

#### 1. Marcar Tiles de Entrada

1. Abre tu mapa en RME
2. Selecciona los tiles donde quieres la entrada VIP
3. Click derecho → **Properties**
4. En **Action ID**, coloca:
   - `50001` para VIP Zone 1 (requiere VIP 1+)
   - `50002` para VIP Zone 2 (requiere VIP 2+)
   - `50003` para VIP Zone 3 (requiere VIP 3)

#### 2. Ejemplo de Diseño

```
[Normal Area] → [Tile ActionID 50001] → [VIP Zone 1]
                      ↓
              Solo VIP 1, 2 o 3 pueden pasar
```

#### 3. Mensajes Automáticos

Cuando un jugador intenta entrar:
- **Con VIP suficiente:** "Welcome to VIP Zone 1!"
- **Sin VIP:** "You need VIP Level 1 to access this area." + teleport de regreso

### Action IDs Disponibles

| Action ID | Zona      | Requiere  |
|-----------|-----------|-----------|
| 50001     | VIP 1     | VIP 1+    |
| 50002     | VIP 2     | VIP 2+    |
| 50003     | VIP 3     | VIP 3     |

**Ejemplo de uso:**
- VIP Zone 1: Bosque con Dragons mejorados
- VIP Zone 2: Cueva con Demons
- VIP Zone 3: Isla exclusiva con custom bosses

---

## 🎨 Personalización

### Cambiar Nombres de Niveles VIP

En `data/lib/vip_system.lua`:

```lua
benefits = {
    [1] = {
        name = "VIP Guerrero",  -- Cambiar de "VIP Bronze"
        zoneName = "Zona Guerrera"
    },
    [2] = {
        name = "VIP Elite",
        zoneName = "Zona Elite"
    },
    [3] = {
        name = "VIP Legendario",
        zoneName = "Zona Legendaria"
    }
}
```

### Cambiar Mensajes del Sistema

En `data/lib/vip_system.lua`:

```lua
messages = {
    vipExpired = "¡Tu VIP ha expirado! Renueva en el NPC.",
    vipActive = "¡Bienvenido! Tu %s está activo por %d días más.",
    vipPurchased = "¡Has comprado %s por %d días!",
    noAccess = "Necesitas VIP Nivel %d para entrar aquí.",
    insufficientPoints = "Necesitas %d premium points."
}
```

### Ajustar Apariencia del NPC

En `data/npc/VIP Seller.xml`:

```xml
<look type="131" head="114" body="119" legs="114" feet="114" addons="3"/>
```

Cambia los valores para diferentes outfits:
- `type`: ID del outfit
- `head`, `body`, `legs`, `feet`: Colores (0-132)
- `addons`: 0 (sin addon), 1 (primer addon), 2 (segundo), 3 (ambos)

### Agregar Más Duraciones

En `data/lib/vip_system.lua`, agrega nuevas duraciones:

```lua
prices = {
    [1] = {
        [7] = 150,
        [15] = 300,
        [30] = 500,
        [60] = 900,   -- Agregar 60 días
        [90] = 1200   -- Agregar 90 días
    }
}
```

Luego actualiza el NPC en `data/npc/scripts/vip_seller.lua` para ofrecer estas opciones.

---

## ❓ Preguntas Frecuentes

### ¿Cómo dar premium points a los jugadores?

Ejecuta en MySQL:
```sql
UPDATE `accounts` SET `premium_points` = `premium_points` + 1000 WHERE `id` = ACCOUNT_ID;
```

### ¿Los días VIP se consumen si el jugador no se conecta?

Sí, los días se cuentan por día calendario (cada 24 horas), no por tiempo online.

### ¿Se puede tener más de un nivel VIP?

No, solo puedes tener un nivel activo. Si compras un nivel superior, reemplaza al anterior.

### ¿El bonus de exp se suma al rate del servidor?

Sí, el bonus VIP es **adicional** al rate base configurado en `config.lua`.

Ejemplo:
- Rate server: 250x
- VIP 3 bonus: +30%
- Total: 250x + (250 × 0.30) = 325x

### ¿Cómo resetear el VIP de todos los jugadores?

Ejecuta en MySQL:
```sql
UPDATE `players` SET `vip_level` = 0, `vip_days` = 0, `vip_lastday` = 0;
```

---

## 🐛 Solución de Problemas

### El NPC no aparece en el juego
1. Verifica que `VIP Seller.xml` esté en `data/npc/`
2. Coloca el NPC en el mapa con RME
3. Reinicia el servidor

### Los bonus no se aplican
1. Verifica que `vip_bonus.lua` esté registrado en `creaturescripts.xml`
2. Verifica que el jugador tiene VIP: `/checkvip PlayerName`
3. Reinicia el servidor

### No puedo entrar a zonas VIP
1. Verifica el Action ID del tile (50001, 50002 o 50003)
2. Verifica tu nivel VIP: `/checkvip`
3. Verifica que `vip_zones.lua` esté registrado en `movements.xml`

### Los comandos /addvip no funcionan
1. Verifica permisos: necesitas ACCOUNT_TYPE_GOD
2. Verifica que esté registrado en `talkactions.xml`
3. Sintaxis correcta: `/addvip Name, Level, Days` (con comas)

---

## 📊 Storage Keys Utilizados

El sistema usa estos storage keys (no cambiar sin modificar código):

| Key   | Uso                        |
|-------|----------------------------|
| 50100 | VIP Level                  |
| 50101 | VIP Days remaining         |
| 50102 | Last login check timestamp |

---

## ✅ Checklist de Instalación

- [ ] Ejecutar ALTER TABLE en MySQL para agregar campos
- [ ] Verificar que `vip_system.lua` está en `data/lib/`
- [ ] Verificar registros en `creaturescripts.xml`
- [ ] Verificar registros en `movements.xml`
- [ ] Verificar registros en `talkactions.xml`
- [ ] Colocar NPC "VIP Seller" en el mapa con RME
- [ ] Marcar tiles de zonas VIP con Action IDs
- [ ] Reiniciar servidor
- [ ] Probar comprando VIP con un personaje de prueba
- [ ] Verificar acceso a zonas VIP
- [ ] Verificar bonus de exp/loot matando monsters

---

## 📝 Notas Finales

- **Backup:** Siempre haz backup de tu base de datos antes de modificar
- **Testing:** Prueba el sistema con cuentas de prueba antes de lanzar
- **Balance:** Ajusta precios y bonus según la economía de tu servidor
- **Zones:** Crea zonas VIP atractivas con buenos spawns para incentivar compras

**Sistema creado para:** TFS 1.2 - Tibia 8.60
**Compatible con:** MySQL 8.0+

---

¿Necesitas ayuda? Revisa la sección de Solución de Problemas o contacta al administrador del servidor.
