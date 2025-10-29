local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)            npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)        npcHandler:onCreatureDisappear(cid)            end
function onCreatureSay(cid, type, msg)    npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                        npcHandler:onThink()                        end

-- AutoLoot items organized by category
local autolootCategories = {
    {
        name = "Currencies",
        items = {
            {id = 2148, name = "gold coin"},
            {id = 2152, name = "platinum coin"},
            {id = 2160, name = "crystal coin"},
            {id = 9971, name = "gold ingot"}
        }
    },
    {
        name = "Gems & Valuables",
        items = {
            {id = 2146, name = "small sapphire"},
            {id = 2147, name = "small ruby"},
            {id = 2149, name = "small emerald"},
            {id = 2150, name = "small amethyst"},
            {id = 2158, name = "blue gem"},
            {id = 2156, name = "red gem"},
            {id = 2155, name = "green gem"},
            {id = 2154, name = "yellow gem"},
            {id = 2153, name = "violet gem"},
            {id = 2157, name = "white gem"},
            {id = 2145, name = "small diamond"},
            {id = 2159, name = "black pearl"},
            {id = 7761, name = "white pearl"}
        }
    },
    {
        name = "Magic Items",
        items = {
            {id = 2260, name = "blank rune"},
            {id = 2273, name = "ultimate healing rune"},
            {id = 2268, name = "sudden death rune"},
            {id = 2287, name = "heaven blossom"},
            {id = 2285, name = "ancient stone"},
            {id = 2283, name = "ankh"}
        }
    },
    {
        name = "Creature Products",
        items = {
            {id = 5877, name = "flask of warrior's sweat"},
            {id = 5878, name = "flask of pure spirit"},
            {id = 5879, name = "flask of magic dust"},
            {id = 5880, name = "iron ore"},
            {id = 5892, name = "red dragon scale"},
            {id = 5893, name = "red dragon leather"},
            {id = 5894, name = "bat wing"},
            {id = 5895, name = "fish fin"},
            {id = 5896, name = "piece of turtle shell"},
            {id = 5897, name = "piece of dragon claw"},
            {id = 5898, name = "minotaur horn"},
            {id = 5899, name = "piece of cyclops eye"},
            {id = 5902, name = "honeycomb"},
            {id = 5906, name = "demon horn"},
            {id = 5909, name = "white piece of cloth"},
            {id = 5910, name = "green piece of cloth"},
            {id = 5911, name = "red piece of cloth"},
            {id = 5912, name = "brown piece of cloth"},
            {id = 5913, name = "yellow piece of cloth"}
        }
    },
    {
        name = "Demon Items",
        items = {
            {id = 2393, name = "giant sword"},
            {id = 2472, name = "magic plate armor"},
            {id = 2520, name = "demon shield"},
            {id = 2462, name = "devil helmet"},
            {id = 2488, name = "mad mage hat"},
            {id = 2391, name = "royal helmet"},
            {id = 2454, name = "mastermind shield"},
            {id = 2470, name = "golden legs"}
        }
    },
    {
        name = "Dragon Items",
        items = {
            {id = 2547, name = "dragon scale mail"},
            {id = 2516, name = "dragon shield"},
            {id = 2492, name = "dragon scale legs"},
            {id = 2400, name = "dragon slayer"}
        }
    }
}

-- Store category index for each player
local playerCategory = {}

-- Buy callback function
local function onBuy(cid, itemId, subType, amount, ignoreCap, inBackpacks)
    local player = Player(cid)
    if not player then
        return
    end
    
    local itemType = ItemType(itemId)
    if not itemType then
        return
    end
    
    local hasItem = player:hasItemInAutoloot(itemId)
    
    if hasItem then
        -- Remove from list
        if player:removeItemFromAutoloot(itemId) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
                string.format(AUTOLOOT_CONFIG.messages.removed, itemType:getName()))
        end
    else
        -- Add to list
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
    end
end

-- Sell callback (not used but required)
local function onSell(cid, itemId, subType, amount, ignoreCap, inBackpacks)
    -- Not used for autoloot
end

-- Get shop items for category
local function getShopItems(categoryIndex)
    if categoryIndex < 1 or categoryIndex > #autolootCategories then
        return {}
    end
    
    local category = autolootCategories[categoryIndex]
    local shopItems = {}
    
    for _, item in ipairs(category.items) do
        table.insert(shopItems, {
            itemId = item.id,
            subType = -1,
            buy = 1,
            sell = 0,
            name = item.name
        })
    end
    
    return shopItems
end

local function greetCallback(cid)
    local player = Player(cid)
    if not player then
        return false
    end
    
    local count = player:getAutolootCount()
    local status = player:isAutolootEnabled() and "enabled" or "disabled"
    
    npcHandler:setMessage(MESSAGE_GREET, 
        "Hello |PLAYERNAME|! I can help you configure your AutoLoot system. " ..
        "You currently have " .. count .. "/" .. AUTOLOOT_CONFIG.maxItems .. " items in your list. " ..
        "AutoLoot is currently " .. status .. ". Say {configure}, {enable}, {disable}, {clear}, or {list}.")
    
    return true
end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    
    local player = Player(cid)
    if not player then
        return false
    end
    
    -- Configure - open shop window
    if msgcontains(msg, "configure") or msgcontains(msg, "config") or msgcontains(msg, "shop") then
        npcHandler:say({
            "Choose a category:",
            "1. Currencies",
            "2. Gems & Valuables",
            "3. Magic Items",
            "4. Creature Products",
            "5. Demon Items",
            "6. Dragon Items",
            "Say {category 1}, {category 2}, etc."
        }, cid)
        npcHandler.topic[cid] = 1
        return true
    end
    
    -- Category selection
    if npcHandler.topic[cid] == 1 and msgcontains(msg, "category") then
        local categoryNum = tonumber(msg:match("%d+"))
        if categoryNum and categoryNum >= 1 and categoryNum <= #autolootCategories then
            npcHandler:say("Opening " .. autolootCategories[categoryNum].name .. " items. Click items to add/remove from your list.", cid)
            playerCategory[cid] = categoryNum
            openShopWindow(cid, getShopItems(categoryNum), onBuy, onSell)
            npcHandler.topic[cid] = 0
        else
            npcHandler:say("Invalid category. Choose 1-" .. #autolootCategories .. ".", cid)
        end
        return true
    end
    
    -- Enable autoloot
    if msgcontains(msg, "enable") or msgcontains(msg, "on") then
        player:enableAutoloot()
        npcHandler:say(AUTOLOOT_CONFIG.messages.enabled, cid)
        return true
    end
    
    -- Disable autoloot
    if msgcontains(msg, "disable") or msgcontains(msg, "off") then
        player:disableAutoloot()
        npcHandler:say(AUTOLOOT_CONFIG.messages.disabled, cid)
        return true
    end
    
    -- Clear list
    if msgcontains(msg, "clear") then
        npcHandler:say("Are you sure you want to clear your entire autoloot list? Say {yes} to confirm.", cid)
        npcHandler.topic[cid] = 2
        return true
    end
    
    if npcHandler.topic[cid] == 2 and msgcontains(msg, "yes") then
        local count = player:clearAutolootList()
        npcHandler:say(AUTOLOOT_CONFIG.messages.cleared, cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Show list
    if msgcontains(msg, "list") or msgcontains(msg, "show") then
        local items = player:getAutolootList()
        local count = #items
        
        if count == 0 then
            npcHandler:say("Your autoloot list is empty.", cid)
        else
            local itemNames = {}
            for i, itemId in ipairs(items) do
                local itemType = ItemType(itemId)
                if itemType then
                    table.insert(itemNames, itemType:getName())
                end
            end
            
            npcHandler:say("Your autoloot list (" .. count .. "/" .. AUTOLOOT_CONFIG.maxItems .. "): " .. table.concat(itemNames, ", ") .. ".", cid)
        end
        
        local status = player:isAutolootEnabled() and "enabled" or "disabled"
        npcHandler:say("AutoLoot is currently " .. status .. ".", cid)
        return true
    end
    
    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

local function greetCallback(cid)
    local player = Player(cid)
    if not player then
        return false
    end
    
    local count = player:getAutolootCount()
    local status = player:isAutolootEnabled() and "enabled" or "disabled"
    
    npcHandler:setMessage(MESSAGE_GREET, 
        "Hello |PLAYERNAME|! I can help you configure your AutoLoot system. " ..
        "You currently have " .. count .. "/" .. AUTOLOOT_CONFIG.maxItems .. " items in your list. " ..
        "AutoLoot is currently " .. status .. ". Say {configure}, {enable}, {disable}, {clear}, or {list}.")
    
    return true
end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    
    local player = Player(cid)
    if not player then
        return false
    end
    
    -- Configure - open shop window
    if msgcontains(msg, "configure") or msgcontains(msg, "config") or msgcontains(msg, "shop") then
        npcHandler:say({
            "Choose a category:",
            "1. Currencies",
            "2. Gems & Valuables",
            "3. Magic Items",
            "4. Creature Products",
            "5. Demon Items",
            "6. Dragon Items",
            "Say {category 1}, {category 2}, etc."
        }, cid)
        npcHandler.topic[cid] = 1
        return true
    end
    
    -- Category selection
    if npcHandler.topic[cid] == 1 and msgcontains(msg, "category") then
        local categoryNum = tonumber(msg:match("%d+"))
        if categoryNum and categoryNum >= 1 and categoryNum <= #autolootCategories then
            npcHandler:say("Opening " .. autolootCategories[categoryNum].name .. " items. Click items to add/remove from your list.", cid)
            openAutolootShop(cid, categoryNum)
            npcHandler.topic[cid] = 0
        else
            npcHandler:say("Invalid category. Choose 1-" .. #autolootCategories .. ".", cid)
        end
        return true
    end
    
    -- Enable autoloot
    if msgcontains(msg, "enable") or msgcontains(msg, "on") then
        player:enableAutoloot()
        npcHandler:say(AUTOLOOT_CONFIG.messages.enabled, cid)
        return true
    end
    
    -- Disable autoloot
    if msgcontains(msg, "disable") or msgcontains(msg, "off") then
        player:disableAutoloot()
        npcHandler:say(AUTOLOOT_CONFIG.messages.disabled, cid)
        return true
    end
    
    -- Clear list
    if msgcontains(msg, "clear") then
        npcHandler:say("Are you sure you want to clear your entire autoloot list? Say {yes} to confirm.", cid)
        npcHandler.topic[cid] = 2
        return true
    end
    
    if npcHandler.topic[cid] == 2 and msgcontains(msg, "yes") then
        local count = player:clearAutolootList()
        npcHandler:say(AUTOLOOT_CONFIG.messages.cleared, cid)
        npcHandler.topic[cid] = 0
        return true
    end
    
    -- Show list
    if msgcontains(msg, "list") or msgcontains(msg, "show") then
        local items = player:getAutolootList()
        local count = #items
        
        if count == 0 then
            npcHandler:say("Your autoloot list is empty.", cid)
        else
            local itemNames = {}
            for i, itemId in ipairs(items) do
                local itemType = ItemType(itemId)
                if itemType then
                    table.insert(itemNames, itemType:getName())
                end
            end
            
            npcHandler:say("Your autoloot list (" .. count .. "/" .. AUTOLOOT_CONFIG.maxItems .. "): " .. table.concat(itemNames, ", ") .. ".", cid)
        end
        
        local status = player:isAutolootEnabled() and "enabled" or "disabled"
        npcHandler:say("AutoLoot is currently " .. status .. ".", cid)
        return true
    end
    
    return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
