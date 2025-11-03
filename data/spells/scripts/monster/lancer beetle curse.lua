local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)

function onCastSpell(creature, variant)
    return true
end

function onTargetCreature(cid, target)
    if not target:isCreature() then
        return false
    end

    local condition = Condition(CONDITION_CURSED)
    
    condition:setParameter(CONDITION_PARAM_TICKS, 10000) 
    condition:setParameter(CONDITION_PARAM_INTERVAL, 2000)

    local damagePerTick = math.random(17, 43)
    condition:addDamage(damagePerTick)

    local caster = Creature(cid)
    local casterPos = caster:getPosition()
    local targetPos = target:getPosition()
    
    caster:doSendDistanceShoot(casterPos, targetPos, CONST_ANI_DEATH)
    targetPos:sendMagicEffect(CONST_ME_SMALLCLOUDS)
    
    return target:addCondition(condition)
end