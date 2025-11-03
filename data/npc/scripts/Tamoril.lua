local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

-- Funciones de callback corregidas a formato multilinea (soluciona el error de la línea 6)
function onCreatureAppear(cid)
    npcHandler:onCreatureAppear(cid)
end

function onCreatureDisappear(cid)
    npcHandler:onCreatureDisappear(cid)
end

function onCreatureSay(cid, type, msg)
    npcHandler:onCreatureSay(cid, type, msg)
end

function onThink()
    npcHandler:onThink()
end

-- Función genérica para la venta de spells (soluciona el error addSpellKeyword)
local function learnSpellCallback(cid, message, keywords, parameters, node)
    -- Verifica si el jugador quiere aprenderlo ('yes' o 'si')
    if not npcHandler:isSay(message) then
        return false
    end

    local spellName = parameters.spellName
    local price = parameters.price
    local level = parameters.level
    local vocations = parameters.vocations
    
    -- Utiliza la función tryLearn que maneja la lógica de validación
    return npcHandler:tryLearn(cid, spellName, price, level, vocations)
end

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Another pesky mortal who believes his gold outweighs his nutrition value.")
	return true
end

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

	local player = Player(cid)
	if msgcontains(msg, "first dragon") then
		npcHandler:say("The First Dragon? The first of all of us? The Son of Garsharak? I'm surprised you heard about him. It is such a long time that he wandered Tibia. Yet, there are some {rumours}.", cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "rumours") and npcHandler.topic[cid] == 1 then
		npcHandler.topic[cid] = 2
		npcHandler:say("It is told that the First Dragon had four {descendants}, who became the ancestors of the four kinds of dragons we know in Tibia. They perhaps still have knowledge about the First Dragon's whereabouts - if one could find them.", cid)
	elseif msgcontains(msg, "descendants") and npcHandler.topic[cid] == 2 then
		npcHandler.topic[cid] = 3
		npcHandler:say("The names of these four are Tazhadur, Kalyassa, Gelidrazah and Zorvorax. Not only were they the ancestors of all dragons after but also the primal representation of the {draconic incitements}. About whom do you want to learn more?", cid)
	elseif msgcontains(msg, "draconic incitements") and npcHandler.topic[cid] == 3 then
		npcHandler.topic[cid] = 4
		npcHandler:say({
			'Each kind of dragon has its own incitement, an important aspect that impels them and occupies their mind. For the common dragons this is the lust for power, for the dragon lords the greed for treasures. ...',
			'The frost dragons\' incitement is the thirst for knowledge und for the undead dragons it\'s the desire for life, as they regret their ancestor\'s mistake. ...',
			'These incitements are also a kind of trial that has to be undergone if one wants to {find} the First Dragon\'s four descendants.'
		}, cid)
	elseif msgcontains(msg, "find") then
		npcHandler.topic[cid] = 5
		npcHandler:say("What do you want to do, if you know about these mighty dragons' abodes? Go there and look for a fight?", cid)
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 5 then
		npcHandler.topic[cid] = 6
		npcHandler:say({
			' Fine! I\'ll tell you where to find our ancestors. You now may ask yourself why I should want you to go there and fight them. It\'s quite simple: I am a straight descendant of Kalyassa herself. She was not really a caring mother. ...',
			'No, she called herself an empress and behaved exactly like that. She was domineering, farouche and conceited and this finally culminated in a serious quarrel between us. ...',
			'I sought support by my aunt and my uncles but they were not a bit better than my mother was! So, feel free to go to their lairs and challenge them. I doubt you will succeed but then again that\'s not my problem. ...',
			'So, you want to know about their secret lairs?'
		}, cid)
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 6 then
		npcHandler:say({
			'So listen: The lairs are secluded and you can only reach them by using a magical gem teleporter. You will find a teleporter carved out of a giant emerald in the dragon lairs deep beneath the Darama desert, which will lead you to Tazhadur\'s lair. ...',
			'A ruby teleporter located in the western Dragonblaze Peaks allows you to enter the lair of Kalyassa. A teleporter carved out of sapphire is on the island Okolnir and leads you to Gelidrazah\'s lair. ...',
			'And finally an amethyst teleporter in undead-infested caverns underneath Edron allows you to enter the lair of Zorvorax.'
		}, cid)
		npcHandler.topic[cid] = 0
		player:setStorageValue(Storage.FirstDragon.Start, 1)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- *** Venta de Spells (Corregido) ***
local spellList = {
    -- SpellName, Price, Level, {Vocations}, {Keywords}
    {'Animate Dead', 1200, 27, {1}, {'animate', 'dead'}},
    {'Creature Illusion', 1000, 23, {1}, {'creature', 'illusion'}},
    {'Cure Poison', 150, 10, {1}, {'cure', 'poison'}},
    {'Death Strike', 800, 16, {1}, {'death', 'strike'}},
    {'Destroy Field', 700, 17, {1}, {'destroy', 'field'}},
    {'Disintegrate', 900, 21, {1}, {'disintegrate'}},
    {'Energy Beam', 1000, 23, {1}, {'energy', 'beam'}},
    {'Energy Bomb', 2300, 37, {1}, {'energy', 'bomb'}},
    {'Energy Field', 700, 18, {1}, {'energy', 'field'}},
    {'Energy Strike', 800, 12, {1}, {'energy', 'strike'}},
    {'Energy Wall', 2500, 41, {1}, {'energy', 'wall'}},
    {'Energy Wave', 2500, 38, {1}, {'energy', 'wave'}},
    {'Explosion', 1800, 31, {1}, {'explosion'}},
    {'Find Person', 80, 8, {1}, {'find', 'person'}},
    {'Fire Bomb', 1500, 27, {1}, {'fire', 'bomb'}},
    {'Fire Field', 500, 15, {1}, {'fire', 'field'}},
    {'Fire Wall', 2000, 33, {1}, {'fire', 'wall'}},
    {'Fire Wave', 850, 18, {1}, {'fire', 'wave'}},
    {'Fireball', 1600, 27, {1}, {'fireball'}},
    {'Flame Strike', 800, 14, {1}, {'flame', 'strike'}},
    {'Great Energy Beam', 1800, 29, {1}, {'great', 'energy', 'beam'}},
    {'Great Light', 500, 13, {1}, {'great', 'light'}},
    {'Haste', 600, 14, {1}, {'haste'}},
    {'Heavy Magic Missile', 1500, 25, {1}, {'heavy', 'magic', 'missile'}},
    {'Ice Strike', 800, 15, {1}, {'ice', 'strike'}},
    {'Intense Healing', 350, 20, {1}, {'intense', 'healing'}},
    {'Invisible', 2000, 35, {1}, {'invisible'}},
    {'Levitate', 500, 12, {1}, {'levitate'}},
    {'Light', 0, 8, {1}, {'light'}},
    {'Light Healing', 0, 8, {1}, {'light', 'healing'}},
    {'Light Magic Missile', 500, 15, {1}, {'light', 'magic', 'missile'}},
    {'Magic Rope', 200, 9, {1}, {'magic', 'rope'}},
    {'Magic Shield', 450, 14, {1}, {'magic', 'shield'}},
    {'Magic Wall', 2100, 32, {1}, {'magic', 'wall'}},
    {'Poison Field', 300, 14, {1}, {'poison', 'field'}},
    {'Poison Wall', 1600, 29, {1}, {'poison', 'wall'}},
    {'Soulfire', 1800, 27, {1}, {'soulfire'}},
    {'Stalagmite', 1400, 24, {1}, {'stalagmite'}},
    {'Strong Haste', 1300, 20, {1}, {'strong', 'haste'}},
    {'Sudden Death', 3000, 45, {1}, {'sudden', 'death'}},
    {'Summon Creature', 2000, 25, {1}, {'summon', 'creature'}},
    {'Summon Thundergiant', 50000, 200, {1}, {'summon', 'thundergiant'}},
    {'Terra Strike', 800, 13, {1}, {'terra', 'strike'}},
    {'Thunderstorm', 1100, 28, {1}, {'thunderstorm'}},
    {'Ultimate Healing', 1000, 30, {1}, {'ultimate', 'healing'}},
    {'Ultimate Light', 1600, 26, {1}, {'ultimate', 'light'}},
}

for i = 1, #spellList do
    local s = spellList[i]
    local spellName = s[1]
    local price = s[2]
    local level = s[3]
    local vocations = s[4]
    local keywords = s[5]
    
    local params = {
        npcHandler = npcHandler, 
        spellName = spellName, 
        price = price, 
        level = level, 
        vocations = vocations
    }
    
    -- Construye el texto de la oferta
    local offerText = "Do you want to learn the spell '" .. spellName .. "' for " .. price .. " gold?"
    
    -- Utiliza addKeyword con el callback para la venta de spells
    keywordHandler:addKeyword(keywords, StdModule.say, {npcHandler = npcHandler, text = offerText}, learnSpellCallback)
end

-- Keywords de categoría
keywordHandler:addKeyword({'attack', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Death Strike}', '{Energy Beam}', '{Energy Strike}', '{Energy Wave}', '{Fire Wave}', '{Flame Strike}', '{Great Energy Beam}', '{Ice Strike}' and '{Terra Strike}'."})
keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Cure Poison}', '{Intense Healing}', '{Light Healing}' and '{Ultimate Healing}'."})
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Animate Dead}', '{Creature Illusion}', '{Destroy Field}', '{Disintegrate}', '{Energy Bomb}', '{Energy Field}', '{Energy Wall}', '{Explosion}', '{Find Person}', '{Fire Bomb}', '{Fire Field}', '{Fire Wall}', '{Fireball}', '{Great Light}', '{Haste}', '{Heavy Magic Missile}', '{Invisible}', '{Levitate}', '{Light}', '{Light Magic Missile}', '{Magic Rope}', '{Magic Shield}', '{Magic Wall}', '{Poison Field}', '{Poison Wall}', '{Soulfire}', '{Stalagmite}', '{Strong Haste}', '{Sudden Death}', '{Summon Creature}', '{Summon Thundergiant}', '{Thunderstorm}' and '{Ultimate Light}'."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {Attack spells}, {Healing spells} and {Support spells}.'})