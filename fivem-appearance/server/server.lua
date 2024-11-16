-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local Legacy = exports.LEGACYCORE:GetCoreData()



MySQL.ready(function()

    MySQL.prepare.await(
        "CREATE TABLE IF NOT EXISTS `outfits` (" ..
        "`id` int NOT NULL AUTO_INCREMENT, " ..
        "`identifier` varchar(60) NOT NULL, " ..
        "`name` longtext, " ..
        "`ped` longtext, " ..
        "`components` longtext, " ..
        "`props` longtext, " ..
        "`charIdentifier` longtext, " ..
        "PRIMARY KEY (`id`), " ..
        "UNIQUE KEY `id_UNIQUE` (`id`) " ..
        ") ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;"
    )
end)



RegisterServerEvent('fivem-appearance:save')
AddEventHandler('fivem-appearance:save', function(appearance, slot)
    local source = source
    local xPlayer = Legacy.DATA:GetPlayerDataBySlot(source)
    print("Saving appearance for slot:", slot)
    
    MySQL.prepare('UPDATE users SET skin = ? WHERE identifier = ? AND charIdentifier = ?', 
        { json.encode(appearance), xPlayer.identifier, slot }
    )
end)



RegisterServerEvent("fivem-appearance:saveOutfit")
AddEventHandler("fivem-appearance:saveOutfit", function(name, pedModel, pedComponents, pedProps, Slot)
    local source = source
    local xPlayer = Legacy.DATA:GetPlayerDataBySlot(source)
    print("Saving outfit for slot:", Slot)
    
    MySQL.insert.await(
        'INSERT INTO outfits (identifier, name, ped, components, props, charIdentifier) VALUES (?, ?, ?, ?, ?, ?)',
        { xPlayer.identifier, name, json.encode(pedModel), json.encode(pedComponents), json.encode(pedProps), Slot }
    )
end)


RegisterServerEvent("fivem-appearance:deleteOutfit")
AddEventHandler("fivem-appearance:deleteOutfit", function(id)
	local source = source
	local xPlayer = Legacy.DATA:GetPlayerDataBySlot(source)
	MySQL.Async.execute('DELETE FROM `outfits` WHERE `id` = @id', {
		['@id'] = id
	})
end)

-- Callbacks

lib.callback.register('fivem-appearance:getPlayerSkin', function(source)
	local xPlayer = Legacy.DATA:GetPlayerDataBySlot(source)
	local SLot = xPlayer.charIdentifier
	local users = MySQL.query.await('SELECT skin FROM outfits users identifier = ? AND charIdentifier = ?', { xPlayer.identifier,SLot })
	if users then
		local user, appearance = users[1]
		if user.skin then
			appearance = json.decode(user.skin)
		end
	end
	return appearance
end)

local function decodeJSON(jsonString)
	local ok, result = pcall(function()
		return json.decode(jsonString)
	end)
	if ok then
		return result
	else
		print("Errore nella decodifica JSON:", result)
		return nil
	end
end

lib.callback.register('fivem-appearance:payFunds', function(source, price)
	local xPlayer = Legacy.DATA:GetPlayerDataBySlot(source)
	if not xPlayer then return false end
	local bankAccountData = xPlayer.accounts
	local bankAccount = decodeJSON(bankAccountData)
	if not bankAccount then return false end
	local bankBalance = bankAccount.Bank or 0
	if bankBalance >= price then
		local newBankBalance = bankBalance - price
		local updatedBankAccount = { Bank = newBankBalance, money = bankAccount.money }
		local success = Legacy.DATA:SetPlayerData(source, 'accounts', json.encode(updatedBankAccount))
		if success then
			return true
		else
			return false
		end
	else
		return false
	end
end)


lib.callback.register('fivem-appearance:getOutfits', function(source)
	local xPlayer = Legacy.DATA:GetPlayerDataBySlot(source)
	local SLot = xPlayer.charIdentifier
	local outfits = {}
	local result = MySQL.query.await('SELECT * FROM outfits WHERE identifier = ?  AND charIdentifier = ?', { xPlayer.identifier , SLot })
	if result then
		for i = 1, #result, 1 do
			outfits[#outfits + 1] = {
				id = result[i].id,
				name = result[i].name,
				ped = json.decode(result[i].ped),
				components = json.decode(result[i].components),
				props = json.decode(result[i].props)
			}
		end
		return outfits
	else
		return false
	end
end)


-- esx_skin/skinchanger/other compatibility
getGender = function(model)
	if model == 'mp_f_freemode_01' then
		return 1
	else
		return 0
	end
end

lib.callback.register('esx_skin:getPlayerSkin', function(source)
	local xPlayer = Legacy.DATA:GetPlayerDataBySlot(source)
	local users = MySQL.query.await('SELECT skin FROM users WHERE identifier = ?', { xPlayer.identifier })
	local appearance
	local jobSkin = {
		skin_male   = xPlayer.job.skin_male,
		skin_female = xPlayer.job.skin_female
	}

	if users and users[1] then
		local user = users[1]
		if user.skin then
			appearance = json.decode(user.skin)
		else
			appearance = Config.DefaultSkin
		end
		appearance.sex = getGender(appearance.model)
	else
		appearance = Config.DefaultSkin
	end

	return { appearance = appearance, jobSkin = jobSkin }
end)


lib.callback.register('fivem-appearance:getPlayerSkin', function(source)
	local xPlayer = Legacy.DATA:GetPlayerDataBySlot(source)
	local users = MySQL.query.await('SELECT skin FROM outfits WHERE identifier = ?', { xPlayer.identifier })
	local appearance = {}

	if users and #users > 0 then
		local user = users[1]
		if user.skin then
			appearance = json.decode(user.skin)
		end
	end

	return appearance
end)
