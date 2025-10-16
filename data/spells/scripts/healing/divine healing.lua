function onCastSpell(creature, variant)
	if not creature or not creature:isPlayer() then
		return false
	end

	local player = creature
	local health = player:getHealth()
	local maxHealth = player:getMaxHealth()
	local healMin = 250
	local healMax = 350

	if health >= maxHealth then
		player:sendCancelMessage("You are already at full health.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local healAmount = math.random(healMin, healMax)
	player:addHealth(healAmount)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:say("Aaaah...", TALKTYPE_MONSTER_SAY)
	return true
end