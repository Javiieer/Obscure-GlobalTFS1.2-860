-- AutoLoot System - Automatic Loot Collection
-- Automatically picks up configured items from monster corpses

local function lootCorpse(player, container, corpsePos)
    if not player or not container then
        return
    end
    
    local autolootList = player:getAutolootList()
    if #autolootList == 0 then
        return
    end
    
    -- Get player's main backpack
    local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
    if not backpack then
        return
    end
    
    local lootedItems = {}
    local skippedItems = {}
    
    -- Iterate through corpse items
    for i = container:getSize() - 1, 0, -1 do
        local item = container:getItem(i)
        if item then
            local itemId = item:getId()
            
            -- Check if item is in autoloot list
            for _, autolootId in ipairs(autolootList) do
                if itemId == autolootId then
                    local itemCount = item:getCount()
                    
                    -- Try to add to player's backpack
                    local ret = backpack:addItemEx(item, INDEX_WHEREEVER, FLAG_NOLIMIT)
                    
                    if ret == RETURNVALUE_NOERROR then
                        table.insert(lootedItems, {
                            name = item:getName(),
                            count = itemCount
                        })
                    else
                        table.insert(skippedItems, item:getName())
                    end
                    
                    break
                end
            end
        end
    end
    
    -- Send loot notification
    if #lootedItems > 0 then
        local message = "AutoLoot: "
        for i, loot in ipairs(lootedItems) do
            if i > 1 then
                message = message .. ", "
            end
            if loot.count > 1 then
                message = message .. loot.count .. "x " .. loot.name
            else
                message = message .. loot.name
            end
        end
        player:sendTextMessage(MESSAGE_LOOT, message)
    end
    
    -- Notify skipped items
    for _, itemName in ipairs(skippedItems) do
        player:sendTextMessage(MESSAGE_STATUS_WARNING, 
            string.format(AUTOLOOT_CONFIG.messages.noSpace, itemName))
    end
end

function onKill(player, target)
    if not target:isMonster() then
        return true
    end
    
    if not player:isAutolootEnabled() then
        return true
    end
    
    -- Get corpse container
    local corpseId = target:getCorpse()
    if corpseId == 0 then
        return true
    end
    
    -- Small delay to ensure corpse is created
    addEvent(function(playerId, targetPos)
        local p = Player(playerId)
        if not p then
            return
        end
        
        -- Find corpse at target position
        local tile = Tile(targetPos)
        if not tile then
            return
        end
        
        local corpse = nil
        for i = tile:getThingCount() - 1, 0, -1 do
            local thing = tile:getThing(i)
            if thing and thing:isItem() and thing:getType():isCorpse() then
                corpse = thing
                break
            end
        end
        
        if corpse and corpse:isContainer() then
            lootCorpse(p, corpse, targetPos)
        end
    end, 100, player:getId(), target:getPosition())
    
    return true
end
