local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addKeyword({'berserk'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Berserk', price = 2500})
keywordHandler:addKeyword({'charge'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Charge', price = 1300})
keywordHandler:addKeyword({'cure','poison'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Cure Poison', price = 150})
keywordHandler:addKeyword({'fierce','berserk'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Fierce Berserk', price = 7500})
keywordHandler:addKeyword({'find','person'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Find Person', price = 80})
keywordHandler:addKeyword({'great','light'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Great Light', price = 500})
keywordHandler:addKeyword({'groundshaker'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Groundshaker', price = 1500})
keywordHandler:addKeyword({'haste'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Haste', price = 600})
keywordHandler:addKeyword({'levitate'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Levitate', price = 500})
keywordHandler:addKeyword({'light'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Light', price = 0})
keywordHandler:addKeyword({'magic','rope'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Magic Rope', price = 200})
keywordHandler:addKeyword({'summon','skullfrost'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Summon Skullfrost', price = 50000})
keywordHandler:addKeyword({'whirlwind','throw'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Whirlwind Throw', price = 1500})
keywordHandler:addKeyword({'attack', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Berserk}', '{Fierce Berserk}', '{Groundshaker}' and '{Whirlwind Throw}'."})
keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cure Poison}'."})
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Charge}', '{Find Person}', '{Great Light}', '{Haste}', '{Levitate}', '{Light}', '{Magic Rope}' and '{Summon Skullfrost}'."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {Attack spells}, {Healing spells} and {Support spells}.'})

npcHandler:addModule(FocusModule:new())
