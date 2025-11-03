local config = {
	[9056] = 4, -- Kazordoon
	[9057] = 1, -- Thais
	[9058] = 2, -- Carlin
	[9059] = 5, -- Ab´Dendriel
	[9060] = 3, -- Rookgard
	[9061] = 10, -- Port Hope
	[9062] = 9, -- Ankrahmun
	[9063] = 11, -- Liberty Bay
	[9064] = 7, -- Darashia
	[9065] = 8, -- Venore
	[9066] = 12, -- Svargrond
	[9067] = 13, -- Yalahar
	[9068] = 14, -- Farmine
	[9240] = 28, -- Nothing
	[9500] = 29, -- Nothing
	[9510] = 33  -- Nothing
}

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local townId = config[item.actionid]
	if not townId then
		return true
	end

	local town = Town(townId)
	if not town then
		return true
	end

	if town:getId() == 12 and player:getStorageValue(Storage.BarbarianTest.Questline) < 8 then
		player:sendTextMessage(MESSAGE_STATUS_WARNING, 'You first need to absolve the Barbarian Test Quest to become citizen!')
		player:teleportTo(town:getTemplePosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:setTown(town)
	player:teleportTo(town:getTemplePosition())
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You are now a citizen of ' .. town:getName() .. '.')
	return true
end