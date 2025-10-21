-- Highscore System for TFS 1.2
-- Original by Shawak - Updated for TFS 1.2 by Copilot
-- Usage: !highscore [type]
-- Types: level, exp, magic, fist, club, sword, axe, distance, shielding, fishing, frags

function onSay(player, words, param)
    -- Maximum players to show in highscore
    local maxPlayers = 20
    
    -- Convert parameter to lowercase for case-insensitive comparison
    param = param:lower()
    
    local query = ""
    local title = ""
    local valueColumn = ""
    local nameColumn = "name"
    local orderColumn = ""
    
    -- Determine query based on parameter
    if param == "level" or param == "lvl" then
        title = "Level Highscore"
        valueColumn = "level"
        orderColumn = "level"
        query = string.format("SELECT `name`, `level` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `level` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "exp" or param == "experience" then
        title = "Experience Highscore"
        valueColumn = "experience"
        orderColumn = "experience"
        query = string.format("SELECT `name`, `experience` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `experience` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "magic" or param == "magiclevel" or param == "ml" then
        title = "Magic Level Highscore"
        valueColumn = "maglevel"
        orderColumn = "maglevel"
        query = string.format("SELECT `name`, `maglevel` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `maglevel` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "fist" then
        title = "Fist Fighting Highscore"
        valueColumn = "skill_fist"
        orderColumn = "skill_fist"
        query = string.format("SELECT `name`, `skill_fist` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `skill_fist` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "club" then
        title = "Club Fighting Highscore"
        valueColumn = "skill_club"
        orderColumn = "skill_club"
        query = string.format("SELECT `name`, `skill_club` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `skill_club` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "sword" then
        title = "Sword Fighting Highscore"
        valueColumn = "skill_sword"
        orderColumn = "skill_sword"
        query = string.format("SELECT `name`, `skill_sword` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `skill_sword` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "axe" then
        title = "Axe Fighting Highscore"
        valueColumn = "skill_axe"
        orderColumn = "skill_axe"
        query = string.format("SELECT `name`, `skill_axe` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `skill_axe` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "dist" or param == "distance" then
        title = "Distance Fighting Highscore"
        valueColumn = "skill_dist"
        orderColumn = "skill_dist"
        query = string.format("SELECT `name`, `skill_dist` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `skill_dist` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "shield" or param == "shielding" then
        title = "Shielding Highscore"
        valueColumn = "skill_shielding"
        orderColumn = "skill_shielding"
        query = string.format("SELECT `name`, `skill_shielding` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `skill_shielding` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "fish" or param == "fishing" then
        title = "Fishing Highscore"
        valueColumn = "skill_fishing"
        orderColumn = "skill_fishing"
        query = string.format("SELECT `name`, `skill_fishing` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 ORDER BY `skill_fishing` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    elseif param == "frags" then
        title = "Frags Highscore"
        valueColumn = "frags"
        orderColumn = "frags"
        query = string.format("SELECT `name`, `frags` FROM `players` WHERE `group_id` < 4 AND `deleted` = 0 AND `frags` > 0 ORDER BY `frags` DESC, `name` ASC LIMIT %d", maxPlayers)
        
    else
        local helpText = "Available highscore types:\n"
        helpText = helpText .. "> !highscore level - Level rankings\n"
        helpText = helpText .. "> !highscore exp - Experience rankings\n"
        helpText = helpText .. "> !highscore magic - Magic level rankings\n"
        helpText = helpText .. "> !highscore fist - Fist fighting rankings\n"
        helpText = helpText .. "> !highscore club - Club fighting rankings\n"
        helpText = helpText .. "> !highscore sword - Sword fighting rankings\n"
        helpText = helpText .. "> !highscore axe - Axe fighting rankings\n"
        helpText = helpText .. "> !highscore distance - Distance fighting rankings\n"
        helpText = helpText .. "> !highscore shielding - Shielding rankings\n"
        helpText = helpText .. "> !highscore fishing - Fishing rankings\n"
        helpText = helpText .. "> !highscore frags - Frags rankings"
        
        player:popupFYI(helpText)
        return false
    end
    
    -- Execute query
    local resultId = db.storeQuery(query)
    if not resultId then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Error: Unable to fetch highscore data.")
        return false
    end
    
    local resultText = title .. "\n" .. string.rep("=", string.len(title)) .. "\n\n"
    local position = 1
    
    repeat
        local playerName = result.getString(resultId, "name")
        local value = result.getNumber(resultId, valueColumn)
        
        -- Format value based on type
        local formattedValue
        if param == "exp" or param == "experience" then
            formattedValue = string.format("%s", formatNumber(value))
        else
            formattedValue = tostring(value)
        end
        
        resultText = resultText .. string.format("%d. %s - %s\n", position, playerName, formattedValue)
        position = position + 1
        
    until not result.next(resultId) or position > maxPlayers
    
    result.free(resultId)
    
    -- Show results to player
    if position == 1 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "No players found for this highscore category.")
    else
        player:popupFYI(resultText)
    end
    
    return false
end

-- Helper function to format large numbers
function formatNumber(number)
    local formatted = tostring(number)
    local k
    
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    
    return formatted
end