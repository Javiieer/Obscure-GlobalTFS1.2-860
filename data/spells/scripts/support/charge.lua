local combat = Combat()
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 5000)
condition:setFormula(0.9, -72, 0.9, -72)

function onCastSpell(creature, variant)
	if not creature or not creature:isPlayer() then
		return false
	end

	local player = creature
	if player:getCondition(CONDITION_PARALYZE) then
		player:removeCondition(CONDITION_PARALYZE)
	end
	
	player:addCondition(condition)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:say("You feel like a warrior!", TALKTYPE_MONSTER_SAY)
	return true
end