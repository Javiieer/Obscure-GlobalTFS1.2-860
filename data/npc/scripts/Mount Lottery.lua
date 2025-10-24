local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

-- Mount Lottery NPC Configuration
local config = {
	storage = 45001, -- Storage to track last lottery time
	cooldown = 86400, -- 24 hours in seconds (86400 = 24h, set to -1 for no cooldown)
	cost = 0, -- Gold cost (set to 0 for free)
	itemRequired = 6527, -- CHANGE THIS: Item ID required for lottery (6527 = demonic essence, 0 = no item)
	itemCount = 1, -- How many items are required
	
	-- Mount tiers with probability weights
	-- IDs reference mount IDs from data/XML/mounts.xml
	mountTiers = {
		-- Common Mounts (weight 30) - Basic early-game mounts
		{
			ids = {2, 3, 4, 10, 13, 17, 22, 23}, 
			weight = 30,
			broadcast = false -- Don't announce common wins
		},
		
		-- Uncommon Mounts (weight 20) - Mid-tier mounts
		{
			ids = {5, 6, 11, 14, 16, 18, 19, 24, 27, 28, 35, 40}, 
			weight = 20,
			broadcast = false
		},
		
		-- Rare Mounts (weight 10) - Higher tier mounts
		{
			ids = {7, 8, 9, 15, 21, 29, 30, 31, 32, 38, 39, 42, 43}, 
			weight = 10,
			broadcast = true -- Announce rare+ wins
		},
		
		-- Very Rare Mounts (weight 5) - Premium/Special mounts
		{
			ids = {1, 12, 71, 87, 94, 98, 99, 130, 131, 132, 133, 134}, 
			weight = 5,
			broadcast = true
		},
		
		-- Ultra Rare Mounts (weight 2) - Extremely rare legendary mounts
		{
			ids = {144, 146, 162, 167, 174, 175, 182, 183, 194}, 
			weight = 2,
			broadcast = true
		}
	}
}

-- Build weighted mount pool
local function buildMountPool()
	local pool = {}
	for _, tier in ipairs(config.mountTiers) do
		for _, mountId in ipairs(tier.ids) do
			table.insert(pool, {
				id = mountId,
				weight = tier.weight,
				broadcast = tier.broadcast
			})
		end
	end
	return pool
end

local mountPool = buildMountPool()

-- Get random mount based on weights
local function getRandomMount()
	local totalWeight = 0
	for _, mount in ipairs(mountPool) do
		totalWeight = totalWeight + mount.weight
	end
	
	local random = math.random(1, totalWeight)
	local currentWeight = 0
	
	for _, mount in ipairs(mountPool) do
		currentWeight = currentWeight + mount.weight
		if random <= currentWeight then
			return mount
		end
	end
	
	return mountPool[1] -- Fallback
end

-- Mount names table (from mounts.xml)
local mountNames = {
	[1] = "Widow Queen", [2] = "Racing Bird", [3] = "War Bear", [4] = "Black Sheep",
	[5] = "Midnight Panther", [6] = "Draptor", [7] = "Titanica", [8] = "Tin Lizzard",
	[9] = "Blazebringer", [10] = "Rapid Boar", [11] = "Stampor", [12] = "Undead Cavebear",
	[13] = "Donkey", [14] = "Tiger Slug", [15] = "Uniwheel", [16] = "Crystal Wolf",
	[17] = "War Horse", [18] = "Kingly Deer", [19] = "Tamed Panda", [20] = "Dromedary",
	[21] = "Scorpion King", [22] = "Rented Horse", [23] = "Armoured War Horse", [24] = "Shadow Draptor",
	[27] = "Lady Bug", [28] = "Manta Ray", [29] = "Ironblight", [30] = "Magma Crawler",
	[31] = "Dragonling", [32] = "Gnarlhound", [35] = "Water Buffalo", [38] = "Ursagrodon",
	[39] = "The Hellgrip", [40] = "Noble Lion", [42] = "Shock Head", [43] = "Walker",
	[71] = "Glooth Glider", [87] = "Rift Runner", [94] = "Sparkion", [98] = "Neon Sparkid",
	[99] = "Vortexion", [130] = "Lacewing Moth", [131] = "Hibernal Moth", [132] = "Cold Percht Sleigh",
	[133] = "Bright Percht Sleigh", [134] = "Dark Percht Sleigh", [144] = "Gryphon", [146] = "Cerberus Champion",
	[162] = "Haze", [167] = "Spectral Horse", [174] = "White Lion", [175] = "Krakoloss",
	[182] = "Phant", [183] = "Shellodon", [194] = "Gloothomotive"
}

-- Get mount name
local function getMountName(mountId)
	return mountNames[mountId] or "Rare Mount"
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	local player = Player(cid)
	if not player then
		return false
	end
	
	if msgcontains(msg, "lottery") or msgcontains(msg, "mount") or msgcontains(msg, "try") then
		-- Check cooldown
		if config.cooldown > 0 then
			local lastTime = player:getStorageValue(config.storage)
			if lastTime > 0 then
				local timeLeft = (lastTime + config.cooldown) - os.time()
				if timeLeft > 0 then
					local hours = math.floor(timeLeft / 3600)
					local minutes = math.floor((timeLeft % 3600) / 60)
					npcHandler:say("You've already tried the mount lottery recently! Come back in " .. hours .. " hours and " .. minutes .. " minutes.", cid)
					npcHandler:resetNpc(cid)
					return true
				end
			end
		end
		
		-- Check item requirement
		if config.itemRequired > 0 then
			local itemType = ItemType(config.itemRequired)
			local itemName = itemType:getName() or "special item"
			
			if player:getItemCount(config.itemRequired) < config.itemCount then
				npcHandler:say("To try the mount lottery, you need " .. config.itemCount .. "x " .. itemName .. ". Bring it to me and say {lottery} again!", cid)
				npcHandler:resetNpc(cid)
				return true
			end
			
			npcHandler:say("Are you ready to exchange " .. config.itemCount .. "x " .. itemName .. " for a chance at a random mount? Say {yes} to confirm!", cid)
			npcHandler.topic[cid] = 1
			return true
		else
			-- No item required, check gold cost
			if config.cost > 0 then
				if not player:removeMoney(config.cost) then
					npcHandler:say("You need " .. config.cost .. " gold pieces to try the mount lottery!", cid)
					npcHandler:resetNpc(cid)
					return true
				end
			end
			
			-- Proceed with lottery
			npcHandler.topic[cid] = 2
		end
	end
	
	if msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
		-- Remove required item
		if config.itemRequired > 0 then
			if player:removeItem(config.itemRequired, config.itemCount) then
				npcHandler:say("The lottery wheel spins...", cid)
				
				-- Small delay for dramatic effect
				addEvent(function(playerId)
					local p = Player(playerId)
					if p then
						-- Get random mount
						local selectedMount = getRandomMount()
						
						-- Check if player already has this mount
						if p:hasMount(selectedMount.id) then
							npcHandler:say("You received a mount you already have! Better luck next time.", playerId)
							p:setStorageValue(config.storage, os.time())
							return
						end
						
						-- Grant mount
						p:addMount(selectedMount.id)
						
						-- Get mount name
						local mountName = getMountName(selectedMount.id)
						
						-- Announce to player
						npcHandler:say("Congratulations! You won: " .. mountName .. "!", playerId)
						
						-- Broadcast rare mounts
						if selectedMount.broadcast then
							Game.broadcastMessage(p:getName() .. " has won " .. mountName .. " from the Mount Lottery!", MESSAGE_EVENT_ADVANCE)
						end
						
						-- Set cooldown
						p:setStorageValue(config.storage, os.time())
					end
				end, 2000, player:getId())
				
				npcHandler:resetNpc(cid)
				return true
			else
				npcHandler:say("Something went wrong! Make sure you have the required items.", cid)
				npcHandler:resetNpc(cid)
				return true
			end
		end
	end
	
	if msgcontains(msg, "no") then
		npcHandler:say("Maybe another time then!", cid)
		npcHandler:resetNpc(cid)
		npcHandler.topic[cid] = 0
		return true
	end
	
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

-- Keywords
keywordHandler:addKeyword({'lottery'}, StdModule.say, {npcHandler = npcHandler, text = 'Would you like to try your luck at the {mount} lottery?'})
keywordHandler:addKeyword({'mount'}, StdModule.say, {npcHandler = npcHandler, text = 'I can give you a chance to win a random mount! Just say {lottery} to try your luck!'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Say {lottery} or {mount} to participate in the mount lottery! You can win rare and legendary mounts!'})
