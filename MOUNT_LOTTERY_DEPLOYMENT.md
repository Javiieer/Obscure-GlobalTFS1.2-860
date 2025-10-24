# Mount Lottery NPC - Deployment Guide

## Overview
The Mount Lottery NPC allows players to exchange specific items for a chance to win random mounts. The system uses weighted probability tiers and includes a 24-hour cooldown.

## Features
- **Item Requirement**: Configurable item (default: Demonic Essence, item ID 6527)
- **Weighted Probability**: 5 tiers from Common to Ultra Rare
- **Cooldown System**: 24-hour cooldown between attempts
- **Broadcast System**: Announces rare+ mount wins to all players
- **Duplicate Protection**: Won't give mounts the player already owns

## Configuration

### Item Requirement (Mount_Lottery.lua)
To change the required item, edit line 15:
```lua
itemRequired = 6527, -- CHANGE THIS: Item ID required for lottery (6527 = demonic essence, 0 = no item)
itemCount = 1, -- How many items are required
```

**Popular Item ID Options:**
- `0` = No item required (free)
- `2160` = Crystal Coin
- `5944` = Soul Orb
- `6527` = Demonic Essence
- `9971` = Gold Ingot
- `22721` = Gold Token
- `2494` = Demon Horn
- `5809` = Soul Stone
- `2393` = Giant Sword

### Mount Tiers (Mount_Lottery.lua, lines 19-53)
The NPC uses 5 probability tiers:

1. **Common (weight 30)** - 8 basic mounts
2. **Uncommon (weight 20)** - 12 mid-tier mounts  
3. **Rare (weight 10)** - 13 higher-tier mounts (broadcasts wins)
4. **Very Rare (weight 5)** - 12 premium mounts (broadcasts wins)
5. **Ultra Rare (weight 2)** - 9 legendary mounts (broadcasts wins)

To add/remove mounts from tiers, edit the `ids` arrays. All mount IDs reference `data/XML/mounts.xml`.

### Cooldown Settings
```lua
cooldown = 86400, -- 24 hours in seconds (86400 = 24h, set to -1 for no cooldown)
```

## Multi-City Deployment

### Method 1: Add to global-spawn.xml (Recommended)
Add NPC spawns to `data/world/global-spawn.xml` for each city location:

```xml
<!-- Mount Lottery NPCs in Major Cities -->

<!-- Thais (Temple) -->
<spawn centerx="32369" centery="32241" centerz="7" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Carlin (Temple) -->
<spawn centerx="32360" centery="31782" centerz="7" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Venore (Temple) -->
<spawn centerx="32957" centery="32076" centerz="7" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Ab'Dendriel (Temple) -->
<spawn centerx="32732" centery="31634" centerz="7" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Edron (Temple) -->
<spawn centerx="33217" centery="31814" centerz="8" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Ankrahmun (Temple) -->
<spawn centerx="33194" centery="32853" centerz="8" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Darashia (Temple) -->
<spawn centerx="33213" centery="32454" centerz="1" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Port Hope (Temple) -->
<spawn centerx="32594" centery="32745" centerz="7" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Liberty Bay (Temple) -->
<spawn centerx="32317" centery="32826" centerz="7" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>

<!-- Kazordoon (Temple) -->
<spawn centerx="32649" centery="31904" centerz="11" radius="1">
    <npc name="Mount Lottery" x="0" y="0" z="0" spawntime="60" />
</spawn>
```

### Method 2: Use Map Editor
1. Open your map in Remere's Map Editor
2. Browse to the NPC panel
3. Find "Mount Lottery" in the NPC list
4. Place the NPC in desired locations (temples, depots, main squares)
5. Save the map

**Note**: Coordinates above are standard temple locations. Adjust as needed for your custom map.

## Files

### Required Files
1. `data/npc/Mount_Lottery.xml` - NPC definition (appearance, behavior)
2. `data/npc/scripts/Mount_Lottery.lua` - NPC script (lottery logic)
3. `data/XML/mounts.xml` - Mount database (already exists)

### File Locations
```
Darktibia860/
├── data/
│   ├── npc/
│   │   ├── Mount_Lottery.xml          # NPC definition
│   │   └── scripts/
│   │       └── Mount_Lottery.lua      # NPC script with lottery logic
│   ├── XML/
│   │   └── mounts.xml                 # Mount database (reference)
│   └── world/
│       └── global-spawn.xml           # Add NPC spawns here
```

## Customization Examples

### Example 1: Free Daily Mount (No Item Required)
```lua
itemRequired = 0,  -- No item needed
itemCount = 0,
cost = 0,          -- No gold cost
cooldown = 86400,  -- Once per day
```

### Example 2: Expensive Crystal Coin Lottery
```lua
itemRequired = 2160,  -- Crystal Coin
itemCount = 10,       -- Requires 10 Crystal Coins
cost = 0,
cooldown = -1,        -- No cooldown (can spam if rich)
```

### Example 3: Soul Stone Exchange
```lua
itemRequired = 5809,  -- Soul Stone
itemCount = 1,
cost = 0,
cooldown = 86400,     -- 24h cooldown
```

### Example 4: Weekly Ultra Rare Only
```lua
cooldown = 604800,  -- 7 days (604800 seconds)

-- Keep only Ultra Rare tier, remove others:
mountTiers = {
    {
        ids = {144, 146, 162, 167, 174, 175, 182, 183, 194}, 
        weight = 1,
        broadcast = true
    }
}
```

## Mount Probability

With default configuration:
- **Common** (weight 30): ~41% chance per mount in tier
- **Uncommon** (weight 20): ~27% chance per mount in tier
- **Rare** (weight 10): ~14% chance per mount in tier
- **Very Rare** (weight 5): ~7% chance per mount in tier
- **Ultra Rare** (weight 2): ~3% chance per mount in tier

The system randomly selects from weighted pool. With 8 common mounts and 9 ultra rare mounts:
- Total common weight: 8 × 30 = 240
- Total ultra rare weight: 9 × 2 = 18
- Common mounts are ~13x more likely than ultra rare

## Testing

### Quick Test (No Cooldown, No Item)
Edit configuration temporarily:
```lua
itemRequired = 0,
cooldown = -1,
```

### Grant Test Item
```lua
/i 6527, 100  -- Give 100 Demonic Essences for testing
```

### Force Reset Cooldown
In-game SQL command or directly:
```sql
UPDATE player_storage SET value = 0 WHERE key = 45001 AND player_id = YOUR_PLAYER_ID;
```

## Troubleshooting

### NPC Not Appearing
1. Check `data/world/global-spawn.xml` has correct spawn entries
2. Verify coordinates match your map
3. Reload NPC: `/reload npcs` or restart server

### Mount Not Being Granted
1. Check mount ID exists in `data/XML/mounts.xml`
2. Verify player doesn't already have the mount
3. Check server console for errors

### Item Not Being Consumed
1. Verify item ID is correct
2. Check player has exact item count
3. Test with `itemRequired = 0` to isolate issue

## Database Storage

The NPC uses player storage value to track cooldowns:
- **Storage Key**: 45001
- **Storage Value**: Unix timestamp of last lottery attempt

To manually reset a player's cooldown:
```lua
/storage 45001 0
```

## Credits
- Compatible with TFS 1.2+
- Uses standard NPC system
- Integrates with existing mount system from mounts.xml
- Created for Tibia 8.60 protocol servers

## Support

For issues or customization help:
1. Check server console for Lua errors
2. Verify all files are in correct directories
3. Test with simplified configuration (no item, no cooldown)
4. Ensure `data/XML/mounts.xml` is properly loaded
