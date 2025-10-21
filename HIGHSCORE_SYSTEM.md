# Sistema de Highscore para TFS 1.2

Este sistema permite a los jugadores ver rankings de diferentes categorías dentro del juego mediante comandos.

## Instalación

1. El archivo `highscore.lua` debe estar en: `data/talkactions/scripts/`
2. La entrada en `talkactions.xml` ya está registrada

## Comandos Disponibles

### Comando Principal
- `!highscore [categoría]` - Muestra el ranking de la categoría especificada

### Categorías Disponibles

| Comando | Descripción |
|---------|-------------|
| `!highscore level` | Ranking por nivel |
| `!highscore exp` | Ranking por experiencia |
| `!highscore magic` | Ranking por magic level |
| `!highscore fist` | Ranking por fist fighting |
| `!highscore club` | Ranking por club fighting |
| `!highscore sword` | Ranking por sword fighting |
| `!highscore axe` | Ranking por axe fighting |
| `!highscore distance` | Ranking por distance fighting |
| `!highscore shielding` | Ranking por shielding |
| `!highscore fishing` | Ranking por fishing |
| `!highscore frags` | Ranking por frags (solo muestra jugadores con frags > 0) |

### Ejemplos de Uso
```
!highscore level        - Muestra los 20 jugadores con mayor nivel
!highscore magic        - Muestra los 20 jugadores con mayor magic level
!highscore sword        - Muestra los 20 jugadores con mayor sword skill
!highscore              - Muestra la lista de comandos disponibles
```

## Características

### Filtros Automáticos
- **Excluye GMs**: Solo muestra jugadores normales (group_id < 4)
- **Excluye eliminados**: No muestra personajes marcados como deleted
- **Frags válidos**: En frags solo muestra jugadores con al menos 1 frag

### Presentación
- Muestra hasta 20 jugadores por ranking
- Formato numerado (1, 2, 3, etc.)
- Nombres de jugadores y valores correspondientes
- Números grandes formateados con comas (ej: 1,000,000)

### Optimización TFS 1.2
- Usa la nueva sintaxis de base de datos (`db.storeQuery`, `result.getString`)
- Manejo correcto de memoria (`result.free`)
- Compatible con las nuevas funciones de mensajes (`player:popupFYI`)
- Queries optimizadas con LIMIT para mejor rendimiento

## Estructura de Base de Datos

El sistema funciona con la estructura estándar de TFS 1.2:

### Tabla `players`
- `name` - Nombre del jugador
- `level` - Nivel del jugador
- `experience` - Experiencia total
- `maglevel` - Magic level
- `skill_fist` - Fist fighting skill
- `skill_club` - Club fighting skill
- `skill_sword` - Sword fighting skill
- `skill_axe` - Axe fighting skill
- `skill_dist` - Distance fighting skill
- `skill_shielding` - Shielding skill
- `skill_fishing` - Fishing skill
- `frags` - Número de frags
- `group_id` - Grupo del jugador (usado para filtrar GMs)
- `deleted` - Estado de eliminación

## Configuración

### Modificar Cantidad de Jugadores
En el archivo `highscore.lua`, línea 6:
```lua
local maxPlayers = 20  -- Cambiar este valor
```

### Modificar Filtro de GMs
En las queries, cambiar `group_id < 4` por el valor deseado:
```lua
WHERE `group_id` < 4  -- 4 = Excluir GM+, cambiar según necesidad
```

## Compatibilidad

- ✅ TFS 1.2+
- ✅ Compatible con MySQL/MariaDB
- ✅ No requiere librerías adicionales
- ✅ Optimizado para servidores con muchos jugadores

## Troubleshooting

### El comando no funciona
1. Verificar que `highscore.lua` esté en `data/talkactions/scripts/`
2. Verificar que la entrada esté en `talkactions.xml`
3. Reiniciar el servidor

### No muestra datos
1. Verificar que hay jugadores en la base de datos
2. Verificar que el `group_id` filter es correcto
3. Verificar conexión a la base de datos

### Error en queries
1. Verificar estructura de la tabla `players`
2. Verificar permisos de base de datos
3. Revisar logs del servidor para detalles