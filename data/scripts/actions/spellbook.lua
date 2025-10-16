local spellbook = Action()

function spellbook.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local text = ""
	local spells = {}
	for _, spell in ipairs(player:getInstantSpells()) do
		if spell.level ~= 0 then
			if spell.manapercent > 0 then
				spell.mana = spell.manapercent .. "%"
			end
			spells[#spells + 1] = spell
		end
	end

	table.sort(spells, function(a, b) return a.level < b.level end)

	if #spells == 0 then
		text = "You don't know any spells yet."
		player:showTextDialog(item:getId(), text)
		return true
	end

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

spellbook:id(2175, 6120, 8900, 8901, 8902, 8903, 8904, 8918, 12647, 16112, 18401, 22422, 29003)
spellbook:register()
