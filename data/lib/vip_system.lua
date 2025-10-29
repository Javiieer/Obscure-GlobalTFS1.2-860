-- VIP System Configuration and Library
-- Configure all VIP benefits, prices, and multipliers here

VIP_CONFIG = {
    -- VIP Benefits Configuration (edit here to adjust bonuses)
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
            trainerDiscount = 50 -- 50% discount on trainers
        }
    },
    
    -- VIP Prices Configuration
    prices = {
        -- Using premium_points from accounts table
        [1] = { -- VIP Level 1
            [7] = 150,      -- 7 days = 150 premium points
            [15] = 300,     -- 15 days = 300 premium points
            [30] = 500      -- 30 days = 500 premium points
        },
        [2] = { -- VIP Level 2
            [7] = 300,      -- 7 days = 300 premium points
            [15] = 550,     -- 15 days = 550 premium points
            [30] = 900      -- 30 days = 900 premium points
        },
        [3] = { -- VIP Level 3
            [7] = 500,      -- 7 days = 500 premium points
            [15] = 900,     -- 15 days = 900 premium points
            [30] = 1500     -- 30 days = 1500 premium points
        }
    },
    
    -- Messages Configuration
    messages = {
        vipExpired = "Your VIP status has expired!",
        vipActive = "Welcome back! Your VIP %s is active for %d more days.",
        vipPurchased = "You have purchased VIP %s for %d days!",
        noAccess = "You need VIP Level %d to access this area.",
        insufficientPoints = "You need %d premium points to purchase this VIP package."
    },
    
    -- Storage Keys (don't change unless you know what you're doing)
    storage = {
        vipLevel = 50100,
        vipDays = 50101,
        vipLastCheck = 50102
    }
}

-- Library Functions

function Player.getVipLevel(self)
    return self:getStorageValue(VIP_CONFIG.storage.vipLevel) > 0 and self:getStorageValue(VIP_CONFIG.storage.vipLevel) or 0
end

function Player.setVipLevel(self, level)
    if level < 0 or level > 3 then
        return false
    end
    self:setStorageValue(VIP_CONFIG.storage.vipLevel, level)
    return true
end

function Player.getVipDays(self)
    return self:getStorageValue(VIP_CONFIG.storage.vipDays) > 0 and self:getStorageValue(VIP_CONFIG.storage.vipDays) or 0
end

function Player.setVipDays(self, days)
    self:setStorageValue(VIP_CONFIG.storage.vipDays, days)
    return true
end

function Player.addVipDays(self, days)
    local currentDays = self:getVipDays()
    self:setVipDays(currentDays + days)
    return true
end

function Player.removeVipDays(self, days)
    local currentDays = self:getVipDays()
    local newDays = math.max(0, currentDays - days)
    self:setVipDays(newDays)
    return true
end

function Player.hasVipAccess(self, requiredLevel)
    local vipLevel = self:getVipLevel()
    return vipLevel >= requiredLevel
end

function Player.getVipExpBonus(self)
    local vipLevel = self:getVipLevel()
    if vipLevel == 0 then
        return 0
    end
    return VIP_CONFIG.benefits[vipLevel].expBonus or 0
end

function Player.getVipLootBonus(self)
    local vipLevel = self:getVipLevel()
    if vipLevel == 0 then
        return 0
    end
    return VIP_CONFIG.benefits[vipLevel].lootBonus or 0
end

function Player.getVipName(self)
    local vipLevel = self:getVipLevel()
    if vipLevel == 0 then
        return "No VIP"
    end
    return VIP_CONFIG.benefits[vipLevel].name or "VIP Level " .. vipLevel
end

function Player.hasVipTeleport(self)
    local vipLevel = self:getVipLevel()
    if vipLevel == 0 then
        return false
    end
    return VIP_CONFIG.benefits[vipLevel].hasTeleport == true
end

function Player.getVipTrainerDiscount(self)
    local vipLevel = self:getVipLevel()
    if vipLevel == 0 then
        return 0
    end
    return VIP_CONFIG.benefits[vipLevel].trainerDiscount or 0
end

function Player.addVip(self, level, days)
    if level < 1 or level > 3 then
        return false
    end
    
    local currentLevel = self:getVipLevel()
    
    -- If upgrading level, reset days
    if level > currentLevel then
        self:setVipLevel(level)
        self:setVipDays(days)
    -- If same level, add days
    elseif level == currentLevel then
        self:addVipDays(days)
    -- If downgrading, set new level and days
    else
        self:setVipLevel(level)
        self:setVipDays(days)
    end
    
    self:setStorageValue(VIP_CONFIG.storage.vipLastCheck, os.time())
    return true
end

function Player.removeVip(self)
    self:setVipLevel(0)
    self:setVipDays(0)
    self:setStorageValue(VIP_CONFIG.storage.vipLastCheck, 0)
    return true
end

-- Global helper function
function getVipPrice(level, days)
    if not VIP_CONFIG.prices[level] then
        return nil
    end
    return VIP_CONFIG.prices[level][days]
end
