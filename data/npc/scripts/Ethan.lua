local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

npcHandler:addModule(FocusModule:new())


keywordHandler:addKeyword({'cancel','invisibility'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Cancel Invisibility', price = 1600})
keywordHandler:addKeyword({'conjure','arrow'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Conjure Arrow', price = 450})
keywordHandler:addKeyword({'conjure','bolt'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Conjure Bolt', price = 750})
keywordHandler:addKeyword({'conjure','explosive','arrow'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Conjure Explosive Arrow', price = 1000})
keywordHandler:addKeyword({'conjure','piercing','bolt'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Conjure Piercing Bolt', price = 850})
keywordHandler:addKeyword({'conjure','poisoned','arrow'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Conjure Poisoned Arrow', price = 700})
keywordHandler:addKeyword({'conjure','sniper','arrow'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Conjure Sniper Arrow', price = 800})
keywordHandler:addKeyword({'cure','poison'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Cure Poison', price = 150})
keywordHandler:addKeyword({'destroy','field'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Destroy Field', price = 700})
keywordHandler:addKeyword({'divine','caldera'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Divine Caldera', price = 3000})
keywordHandler:addKeyword({'divine','healing'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Divine Healing', price = 3000})
keywordHandler:addKeyword({'divine','missile'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Divine Missile', price = 1800})
keywordHandler:addKeyword({'enchant','spear'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Enchant Spear', price = 2000})
keywordHandler:addKeyword({'ethereal','spear'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Ethereal Spear', price = 1100})
keywordHandler:addKeyword({'find','person'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Find Person', price = 80})
keywordHandler:addKeyword({'great','light'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Great Light', price = 500})
keywordHandler:addKeyword({'haste'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Haste', price = 600})
keywordHandler:addKeyword({'holy','missile'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Holy Missile', price = 1600})
keywordHandler:addKeyword({'intense','healing'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Intense Healing', price = 350})
keywordHandler:addKeyword({'levitate'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Levitate', price = 500})
keywordHandler:addKeyword({'light'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Light', price = 0})
keywordHandler:addKeyword({'light','healing'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Light Healing', price = 0})
keywordHandler:addKeyword({'magic','rope'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Magic Rope', price = 200})
keywordHandler:addKeyword({'summon','emberwing'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = 'Summon Emberwing', price = 50000})
keywordHandler:addKeyword({'attack', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Divine Caldera}', '{Divine Missile}' and '{Ethereal Spear}'."})
keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cure Poison}', '{Divine Healing}', '{Intense Healing}' and '{Light Healing}'."})
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cancel Invisibility}', '{Conjure Arrow}', '{Conjure Bolt}', '{Conjure Explosive Arrow}', '{Conjure Piercing Bolt}', '{Conjure Poisoned Arrow}', '{Conjure Sniper Arrow}', '{Destroy Field}', '{Enchant Spear}', '{Find Person}', '{Great Light}', '{Haste}', '{Holy Missile}', '{Levitate}', '{Light}', '{Magic Rope}' and '{Summon Emberwing}'."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {Attack spells}, {Healing spells} and {Support spells}.'})