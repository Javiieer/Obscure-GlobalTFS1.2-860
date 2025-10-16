function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local text = ""
	local spells = {}
	
	-- Get all instant spells for the player
	for _, spell in ipairs(player:getInstantSpells()) do
		if spell.level and spell.level > 0 then
			-- Format mana cost
			local manaCost = ""
			if spell.mana and spell.mana > 0 then
				manaCost = spell.mana
			elseif spell.manapercent and spell.manapercent > 0 then
				manaCost = spell.manapercent .. "%"
			else
				manaCost = "0"
			end
			
			-- Add spell to list
			spells[#spells + 1] = {
				level = spell.level,
				words = spell.words or "",
				name = spell.name or "",
				mana = manaCost
			}
		end
	end

	-- Sort spells by level
	table.sort(spells, function(a, b) return a.level < b.level end)
	
	-- Check if player has any spells
	if #spells == 0 then
		text = "You don't know any spells yet."
		player:showTextDialog(item:getId(), text)
		return true
	end

	-- Build the spell list text
	local prevLevel = -1
	for i, spell in ipairs(spells) do
		if prevLevel ~= spell.level then
			if text ~= "" then
				text = text .. "\n"
			end
			text = text .. "Spells for Level " .. spell.level .. "\n"
			prevLevel = spell.level
		end
		text = text .. spell.words .. " - " .. spell.name .. " : " .. spell.mana .. "\n"
	end

	player:showTextDialog(item:getId(), text)
	return true
end

