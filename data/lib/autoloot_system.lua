-- AutoLoot System Library
-- Configure autoloot settings and manage player lists

AUTOLOOT_CONFIG = {
    -- Maximum items a player can add to autoloot list
    maxItems = 100,
    
    -- Storage keys
    storage = {
        enabled = 45000,      -- AutoLoot on/off
        listStart = 45001     -- Start of item list storage (45001-45100 for 100 items)
    },
    
    -- Container preferences
    preferredContainer = "backpack", -- Where to store looted items
    
    -- Messages
    messages = {
        enabled = "AutoLoot has been enabled.",
        disabled = "AutoLoot has been disabled.",
        added = "Item '%s' added to your autoloot list. (%d/%d)",
        removed = "Item '%s' removed from your autoloot list.",
        cleared = "AutoLoot list cleared. All items removed.",
        listFull = "Your autoloot list is full! (%d/%d items)",
        alreadyAdded = "Item '%s' is already in your autoloot list.",
        notFound = "Item not found in your autoloot list.",
        noSpace = "No space in backpack for '%s'. Item left on corpse."
    }
}

-- Check if autoloot is enabled for player
function Player.isAutolootEnabled(self)
    return self:getStorageValue(AUTOLOOT_CONFIG.storage.enabled) == 1
end

-- Enable autoloot
function Player.enableAutoloot(self)
    self:setStorageValue(AUTOLOOT_CONFIG.storage.enabled, 1)
    return true
end

-- Disable autoloot
function Player.disableAutoloot(self)
    self:setStorageValue(AUTOLOOT_CONFIG.storage.enabled, 0)
    return true
end

-- Get autoloot list
function Player.getAutolootList(self)
    local items = {}
    for i = 0, AUTOLOOT_CONFIG.maxItems - 1 do
        local itemId = self:getStorageValue(AUTOLOOT_CONFIG.storage.listStart + i)
        if itemId > 0 then
            table.insert(items, itemId)
        end
    end
    return items
end

-- Check if item is in autoloot list
function Player.hasItemInAutoloot(self, itemId)
    for i = 0, AUTOLOOT_CONFIG.maxItems - 1 do
        local storedId = self:getStorageValue(AUTOLOOT_CONFIG.storage.listStart + i)
        if storedId == itemId then
            return true, i
        end
    end
    return false, -1
end

-- Add item to autoloot list
function Player.addItemToAutoloot(self, itemId)
    -- Check if already in list
    if self:hasItemInAutoloot(itemId) then
        return false, "already_exists"
    end
    
    -- Find empty slot
    for i = 0, AUTOLOOT_CONFIG.maxItems - 1 do
        local storedId = self:getStorageValue(AUTOLOOT_CONFIG.storage.listStart + i)
        if storedId <= 0 then
            self:setStorageValue(AUTOLOOT_CONFIG.storage.listStart + i, itemId)
            return true, i
        end
    end
    
    return false, "list_full"
end

-- Remove item from autoloot list
function Player.removeItemFromAutoloot(self, itemId)
    local hasItem, slot = self:hasItemInAutoloot(itemId)
    if hasItem then
        self:setStorageValue(AUTOLOOT_CONFIG.storage.listStart + slot, -1)
        return true
    end
    return false
end

-- Clear entire autoloot list
function Player.clearAutolootList(self)
    local count = 0
    for i = 0, AUTOLOOT_CONFIG.maxItems - 1 do
        if self:getStorageValue(AUTOLOOT_CONFIG.storage.listStart + i) > 0 then
            self:setStorageValue(AUTOLOOT_CONFIG.storage.listStart + i, -1)
            count = count + 1
        end
    end
    return count
end

-- Count items in autoloot list
function Player.getAutolootCount(self)
    local count = 0
    for i = 0, AUTOLOOT_CONFIG.maxItems - 1 do
        if self:getStorageValue(AUTOLOOT_CONFIG.storage.listStart + i) > 0 then
            count = count + 1
        end
    end
    return count
end

-- Process autoloot on monster kill
function Player.processAutoloot(self, monster)
    if not self:isAutolootEnabled() then
        return
    end
    
    local corpse = monster:getCorpse()
    -- This function will be called from creaturescript
    -- Actual looting logic is in the kill script
end

