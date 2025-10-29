-- !autoloot command
-- Usage: !autoloot [on/off/add/remove/clear/list]

function onSay(player, words, param)
    if param == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "AutoLoot Commands:")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "!autoloot on - Enable autoloot")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "!autoloot off - Disable autoloot")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "!autoloot add, itemname - Add item to list")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "!autoloot remove, itemname - Remove item from list")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "!autoloot clear - Clear all items")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "!autoloot list - Show your list")
        return false
    end
    
    local split = param:split(",")
    local action = split[1]:trim():lower()
    
    -- Enable autoloot
    if action == "on" then
        player:enableAutoloot()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, AUTOLOOT_CONFIG.messages.enabled)
        return false
    end
    
    -- Disable autoloot
    if action == "off" then
        player:disableAutoloot()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, AUTOLOOT_CONFIG.messages.disabled)
        return false
    end
    
    -- Add item to list
    if action == "add" then
        if #split < 2 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: !autoloot add, item name")
            return false
        end
        
        local itemName = split[2]:trim()
        local itemType = ItemType(itemName)
        
        if not itemType or itemType:getId() == 0 then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Item '" .. itemName .. "' not found.")
            return false
        end
        
        local itemId = itemType:getId()
        local success, result = player:addItemToAutoloot(itemId)
        
        if success then
            local count = player:getAutolootCount()
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
                string.format(AUTOLOOT_CONFIG.messages.added, itemType:getName(), count, AUTOLOOT_CONFIG.maxItems))
        elseif result == "already_exists" then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, 
                string.format(AUTOLOOT_CONFIG.messages.alreadyAdded, itemType:getName()))
        elseif result == "list_full" then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, 
                string.format(AUTOLOOT_CONFIG.messages.listFull, AUTOLOOT_CONFIG.maxItems, AUTOLOOT_CONFIG.maxItems))
        end
        
        return false
    end
    
    -- Remove item from list
    if action == "remove" then
        if #split < 2 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: !autoloot remove, item name")
            return false
        end
        
        local itemName = split[2]:trim()
        local itemType = ItemType(itemName)
        
        if not itemType or itemType:getId() == 0 then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Item '" .. itemName .. "' not found.")
            return false
        end
        
        local itemId = itemType:getId()
        if player:removeItemFromAutoloot(itemId) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
                string.format(AUTOLOOT_CONFIG.messages.removed, itemType:getName()))
        else
            player:sendTextMessage(MESSAGE_STATUS_WARNING, AUTOLOOT_CONFIG.messages.notFound)
        end
        
        return false
    end
    
    -- Clear list
    if action == "clear" then
        local count = player:clearAutolootList()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, AUTOLOOT_CONFIG.messages.cleared)
        return false
    end
    
    -- Show list
    if action == "list" then
        local items = player:getAutolootList()
        local count = #items
        
        if count == 0 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your autoloot list is empty.")
        else
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
                "=== AutoLoot List (" .. count .. "/" .. AUTOLOOT_CONFIG.maxItems .. ") ===")
            
            for i, itemId in ipairs(items) do
                local itemType = ItemType(itemId)
                if itemType then
                    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
                        i .. ". " .. itemType:getName() .. " (ID: " .. itemId .. ")")
                end
            end
        end
        
        local status = player:isAutolootEnabled() and "ON" or "OFF"
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Status: " .. status)
        
        return false
    end
    
    return false
end
