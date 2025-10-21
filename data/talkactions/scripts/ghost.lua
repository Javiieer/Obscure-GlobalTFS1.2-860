function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local position = player:getPosition()
	local isGhost = not player:isInGhostMode()
	local playerName = player:getName()
	local groupId = player:getGroup():getId()
	
	-- Configuration: GM group IDs that trigger fake disconnect messages  
	local gmGroups = {
		[5] = "Game Master",     -- God account type 5
		[6] = "Administrator"    -- Admin/God group 6
	}

	player:setGhostMode(isGhost)
	
	if isGhost then
		-- Volviéndose invisible (fake disconnect)
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You are now invisible. Fake disconnect message sent!")
		position:sendMagicEffect(CONST_ME_POFF)
		
		-- Send fake disconnect message if player is GM/God
		if gmGroups[groupId] then
			-- Custom disconnect messages
			local disconnectMessages = {
				["[GOD] Bruno"] = "El Administrador Bruno se ha desconectado del servidor.",
				-- Add more custom messages for specific players
				-- ["PlayerName"] = "Custom disconnect message",
			}
			
			-- Default disconnect message if no custom message is set
			local defaultMessage = string.format("%s %s se ha desconectado del servidor.", gmGroups[groupId], playerName)
			
			-- Get the message (custom or default)
			local message = disconnectMessages[playerName] or defaultMessage
			
			-- Send fake disconnect broadcast
			Game.broadcastMessage(message, MESSAGE_STATUS_CONSOLE_ORANGE)
			
			-- Add visual effect for "disconnection"
			local onlinePlayers = Game.getPlayers()
			for _, onlinePlayer in pairs(onlinePlayers) do
				if onlinePlayer ~= player then -- Don't send effect to the GM
					onlinePlayer:getPosition():sendMagicEffect(CONST_ME_POFF)
				end
			end
		end
		
	else
		-- Volviéndose visible (fake reconnect)
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You are visible again. Fake reconnect message sent!")
		position.x = position.x + 1
		position:sendMagicEffect(CONST_ME_TELEPORT)
		
		-- Send fake reconnect message if player is GM/God
		if gmGroups[groupId] then
			-- Custom reconnect messages
			local reconnectMessages = {
				["[GOD] Bruno"] = "¡El Administrador Bruno se ha reconectado al servidor! ¡Bienvenido de vuelta!",
				-- Add more custom messages for specific players
				-- ["PlayerName"] = "Custom reconnect message",
			}
			
			-- Default reconnect message if no custom message is set
			local defaultMessage = string.format("¡%s %s se ha reconectado al servidor!", gmGroups[groupId], playerName)
			
			-- Get the message (custom or default)
			local message = reconnectMessages[playerName] or defaultMessage
			
			-- Send fake reconnect broadcast
			Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
			
			-- Add visual effect for "reconnection"
			local onlinePlayers = Game.getPlayers()
			for _, onlinePlayer in pairs(onlinePlayers) do
				if onlinePlayer ~= player then -- Don't send effect to the GM
					onlinePlayer:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
				end
			end
		end
	end
	
	return false
end
