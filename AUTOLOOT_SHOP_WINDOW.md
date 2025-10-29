# AutoLoot System - Shop Window Interface

## Overview
Sistema de AutoLoot con interfaz visual usando Shop Window que muestra sprites de items.

## Components

### 1. NPC: AutoLoot Manager
- **Location**: Place in any accessible area (temple, depot, etc.)
- **XML File**: `data/npc/AutoLoot_Manager.xml`
- **Script**: `data/npc/scripts/autoloot_manager.lua`

### 2. How to Use

#### Talk to NPC
1. Say **hi** to greet
2. Say **configure** or **config** to open category menu
3. Choose category:
   - Say **category 1** for Currencies
   - Say **category 2** for Gems & Valuables
   - Say **category 3** for Magic Items
   - Say **category 4** for Creature Products
   - Say **category 5** for Demon Items
   - Say **category 6** for Dragon Items

#### Shop Window Interface
- Click on any item to **add** it to your autoloot list
- Click on an item already in your list to **remove** it
- The window shows item sprites (visual icons)
- Max 100 items per player

#### Other Commands
- Say **enable** or **on** - Turn on autoloot
- Say **disable** or **off** - Turn off autoloot
- Say **list** - Show current autoloot items
- Say **clear** - Remove all items (requires confirmation)

### 3. Item Categories

#### Category 1: Currencies
- Gold coins, platinum coins, crystal coins, gold ingots

#### Category 2: Gems & Valuables
- Small gems (sapphire, ruby, emerald, amethyst, diamond)
- Large gems (blue, red, green, yellow, violet, white)
- Pearls (black, white)

#### Category 3: Magic Items
- Blank runes
- Ultimate healing runes
- Sudden death runes
- Heaven blossom, ancient stone, ankh

#### Category 4: Creature Products
- Flasks (warrior's sweat, pure spirit, magic dust)
- Dragon materials (scales, leather)
- Various creature parts (bat wing, fish fin, turtle shell, etc.)
- Demon horns
- Colored cloths

#### Category 5: Demon Items
- Giant sword, magic plate armor
- Demon shield, devil helmet
- Mad mage hat, royal helmet
- Mastermind shield, golden legs

#### Category 6: Dragon Items
- Dragon scale mail
- Dragon shield
- Dragon scale legs
- Dragon slayer

## Configuration

### Adding More Items
Edit `data/npc/scripts/autoloot_manager.lua`:

```lua
local autolootCategories = {
    {
        name = "Your Category Name",
        items = {
            {id = 1234, name = "item name"},
            {id = 5678, name = "another item"},
            -- Add more items...
        }
    },
    -- Add more categories...
}
```

### Changing Max Items
Edit `data/lib/autoloot_system.lua`:

```lua
AUTOLOOT_CONFIG = {
    maxItems = 100, -- Change this number
    -- ...
}
```

## How Shop Window Works

### Visual Display
- Shows item sprites/icons (visual representation)
- Better UX than text commands
- Click-based interaction

### Add/Remove Logic
1. Player clicks item in shop window
2. System checks if item is already in list
3. If in list → remove it
4. If not in list → add it (if not full)
5. Window refreshes to show updated state

### Limitations
- TFS 1.2 shop windows are designed for trading
- We repurpose them for configuration (price = 0)
- Cannot show checkmarks or highlight selected items
- Player must use **!autoloot list** command to see current list

## Alternative: Text Commands
The original text-based interface still works:

```
!autoloot on          - Enable autoloot
!autoloot off         - Disable autoloot
!autoloot add item1, item2, item3  - Add items by name
!autoloot remove item1, item2      - Remove items by name
!autoloot clear       - Clear all items
!autoloot list        - Show current items
```

## Deployment

### 1. Place NPC in Game
- Open map editor (Remere's Map Editor)
- Find AutoLoot Manager in NPC list
- Place in temple, depot, or custom location
- Save map

### 2. Test NPC
1. Login to server
2. Walk to NPC location
3. Say "hi"
4. Say "configure"
5. Say "category 1"
6. Click items to add/remove
7. Kill monster to test autoloot

### 3. Verify Functionality
- Items should auto-loot to backpack
- Check with `!autoloot list`
- Enable/disable with NPC commands
- Clear list with "clear" → "yes"

## Tips

### Best Categories to Configure First
1. **Currencies** - Always autoloot gold/platinum
2. **Gems & Valuables** - High-value items
3. **Creature Products** - For quests and tasks

### Performance
- 100 item limit prevents slowdowns
- Autoloot only processes when enabled
- No impact when disabled

### Player Education
Tell players:
- "Visit AutoLoot Manager NPC in temple"
- "Say 'configure' to choose items visually"
- "Click items to add or remove them"
- "Max 100 items, choose wisely"

## Troubleshooting

### Shop window doesn't open
- Check if NPC script loaded correctly
- Verify `autoloot_system.lua` is loaded in `lib.lua`
- Check console for Lua errors

### Items not auto-looting
- Verify autoloot is enabled: `!autoloot list`
- Check if item is in list
- Ensure backpack has space
- Verify kill script is registered in `creaturescripts.xml`

### "List full" error
- Player has 100 items already
- Must remove some items first
- Use NPC "clear" command to reset

## Future Enhancements

### Possible Improvements
1. **Visual feedback**: Show count of selected items in shop window
2. **Category filtering**: Search items by name
3. **Preset lists**: Save/load common configurations
4. **Container selection**: Choose which container receives items
5. **Item value filter**: Auto-add items worth > X gold

### Known Limitations
- Cannot show which items are already selected (shop window limitation)
- Player must remember or check list with command
- TFS 1.2 doesn't support custom modal windows with checkboxes

---

**Created**: October 2025
**TFS Version**: 1.2 (Tibia 8.60)
**Author**: Custom implementation for Darktibia860
