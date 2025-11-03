local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DEATH)

function onCastSpell(creature, variant)
    return true
end

function onTargetCreature(cid, target)
    if not target:isCreature() then
        return false
    end
    
    local damage = math.random(74, 107)
    
    return doCombat(cid, target, combat, -damage, -damage)
end