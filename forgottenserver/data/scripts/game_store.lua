local DONATION_URL = "https://xangelserver.com/donate.php"

local GAME_STORE = nil

local LoginEvent = CreatureEvent("GameStoreLogin")

local chars = {
    ' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 
    'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 
    'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 
    'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 
    'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
}

local ExtendedOPCodes = {
	CODE_GAMESTORE = 102
}

local forbiddenWords = {'gm', 'adm', 'tutor', 'god', 'cm', 'admin', 'owner', 'g m', 'g o d', 'g0d', 'g 0 d', 'c m', 'administrator', 'senior', 'a d m', 'xangel', 'x-angel',
'Trainer','Devil My Cry','Lavahole','Deaththrower','A Carved Stone Tile','Acolyte Of The Cult','Adept Of The Cult','Amazon','Ancient Scarab','Ashmunrah','Assassin','Azure Frog','Badger','Bandit','Banshee','Barbarian Bloodwalker','Barbarian Brutetamer','Barbarian Headsplitter','Barbarian Skullhunter','Bat','Bear','Behemoth','Beholder','Betrayed Wraith','Black Knight','Black Sheep','Blightwalker','Blood Crab','Blue Butterfly','Blue Djinn','Bonebeast','Braindeath','Bug','Carniphila','Carrion Worm','Cave Rat','Centipede','Chakoya Toolshaper','Chakoya Tribewarden','Chakoya Windcaller','Chicken','Cobra','Coral Frog','Crab','Crimson Frog','Crocodile','Crypt Shambler','Crystal Spider','Cyclops','Dark Magician','Dark Monk','Dark Torturer','Deathslicer','Deer','Defiler','Demon Skeleton','Demon','Destroyer','Diabolic Imp','Dipthrah','Dog','Dragon Lord','Dragon','Dwarf Geomancer','Dwarf Guard','Dwarf Soldier','Dwarf','Dworc Fleshhunter','Dworc Venomsniper','Dworc Voodoomaster','Efreet','Elder Beholder','Elephant','Elf Arcanist','Elf Scout','Elf','Enlightened Of The Cult','Eye Of The Seven','Fire Devil','Fire Elemental','Flamethrower','Flamingo','Frost Dragon','Frost Giant','Frost Giantess','Frost Troll','Fury','Gargoyle','Gazer','Ghost','Ghoul','Giant Spider','Goblin','Green Djinn','Green Frog','Hand Of Cursed Fate','Hell Hole','Hellfire Fighter','Hellhound','Hero','Hunter','Husky','Hyaena','Hydra','Ice Golem','Ice Witch','Juggernaut','Kongra','Larva','Lich','Lion','Lizard Noble','Lizard Sentinel','Lizard Snakecharmer','Lizard Templar','Lost Soul','Magic Pillar','Magicthrower','Mahrdis','Mammoth','Marid','Massive Fire Elemental','Massive Water Elemental','Merlkin','Minotaur Archer','Minotaur Guard','Minotaur Mage','Minotaur','Monk','Morguthis','Mummy','Necromancer','Nightmare','Nomad','Novice Of The Cult','Omruc','Orc Berserker','Orc Leader','Orc Rider','Orc Shaman','Orc Spearman','Orc Warlord','Orc Warrior','Orc','Orchid Frog','Panda','Parrot','Penguin','Phantasm Summon','Phantasm','Pig','Pillar','Pirate Buccaneer','Pirate Corsair','Pirate Cutthroat','Pirate Ghost','Pirate Marauder','Pirate Skeleton','Plaguesmith','Plaguethrower','Poison Spider','Polar Bear','Priestess','Purple Butterfly','Quara Constrictor Scout','Quara Constrictor','Quara Hydromancer Scout','Quara Hydromancer','Quara Mantassin Scout','Quara Mantassin','Quara Pincher Scout','Quara Pincher','Quara Predator Scout','Quara Predator','Rabbit','Rahemos','Rat','Red Butterfly','Rotworm','Scarab','Scorpion','Seagull','Serpent Spawn','Sheep','Shredderthrower','Sibang','Silver Rabbit','Skeleton','Skunk','Slime','Smuggler','Snake','Son Of Verminor','Spectre','Spider','Spit Nettle','Stalker','Stone Golem','Swamp Troll','Tarantula','Terror Bird','Thalas','Thornback Tortoise','Tiger','Toad','Tortoise','Troll','Undead Dragon','Valkyrie','Vampire','Vashresamun','War wolf','Warlock','Wasp','Wild Warrior','Winter Wolf','Witch','Wolf','Wyvern','Yellow Butterfly','Yeti','Annihilon','Apprentice Sheng','Barbaria','Bones','Brutus Bloodbeard','Countess Sorrow','Deadeye Devious','Demodras','Dharalion','Dire Penguin',	'Dracola','Fernfang','Ferumbras','Fluffy','Foreman Kneebiter','General Murius','Ghazbaran','Golgordan','Grorlam','Hairman The Huge',	'Hellgorak','Koshei The Deathless','Latrivan','Lethal Lissy','Mad Technomancer','Madareth','Man In The Cave','Massacre',	'Minishabaal','Morgaroth','Mr. Punish','Munster','Necropharus','Orshabaal',	'Ron the Ripper','The Abomination','The Evil Eye','The Handmaiden','The Horned Fox','The Imperor','The Old Widow',	'The Plasmother','Thul','Tiquandas Revenge','Undead Minion', 'Ungreez','Ushuriel','Xenia','Zugurosh', 
}

local maxWords = 5
local maxLength = 20
local minChars = 2

function LoginEvent.onLogin(player)
	player:registerEvent("GameStoreExtended")
	return true
end

local CATEGORY_NONE = -1
local CATEGORY_PREMIUM = 0
local CATEGORY_ITEM = 1
local CATEGORY_BLESSING = 2
local CATEGORY_OUTFIT = 3
local CATEGORY_MOUNT = 4
local CATEGORY_EXTRAS = 5

local HEALTH_POTION_DESCRIPTION = "Restores your character's hit points.\n\n- only usable by purchasing character\n- only buyable if fitting vocation and level of purchasing character\n- will be sent to your Store inbox and can only be stored there and in depot box\n- cannot be purchased by characters with protection zone block or battle sign\n- cannot be purchased if capacity is exceeded"

local MANA_POTION_DESCRIPTION = "Refills your character's mana.\n\n- only usable by purchasing character\n- only buyable if fitting vocation and level of purchasing character\n- will be sent to your Store inbox and can only be stored there and in depot box\n- cannot be purchased by characters with protection zone block or battle sign\n- cannot be purchased if capacity is exceeded"

function gameStoreInitialize()
	GAME_STORE = {
		categories = {},
		categoriesId = {},
		offers = {}
	}
	
	addCategory(nil, "Premium Time", 20, CATEGORY_PREMIUM, "Enhance your gaming experience by gaining additional abilities and advantages:\n\n• access to Premium areas\n• use Tibia's transport system (ships, carpet)\n• more spells\n• rent houses\n• found guilds\n• offline training\n• larger Depots\n• and many more\n\n- valid for all characters on this account\n- activated at purchase")
	addItem("Premium Time", "30 Days of Premium Time", "30_days", 250, 30)
	addItem("Premium Time", "90 Days of Premium Time", "90_days", 750, 90)
	addItem("Premium Time", "180 Days of Premium Time", "180_days", 1500, 180)
	addItem("Premium Time", "360 Days of Premium Time", "360_days", 3000, 360)

	addCategory(nil, "Consumables", 6, CATEGORY_NONE)
	addCategory("Consumables", "Blessings", 8, CATEGORY_BLESSING, "Reduces your character's chance to lose any items as well as the amount of your character's experience and skill loss upon death:\n\n• 1 blessing = 8.00% less Skill / XP loss, 30% equipment protection\n• 2 blessing = 16.00% less Skill / XP loss, 55% equipment protection\n• 3 blessing = 24.00% less Skill / XP loss, 75% equipment protection\n• 4 blessing = 32.00% less Skill / XP loss, 90% equipment protection\n• 5 blessing = 40.00% less Skill / XP loss, 100% equipment protection\n• 6 blessing = 48.00% less Skill / XP loss, 100% equipment protection\n• 7 blessing = 56.00% less Skill / XP loss, 100% equipment protection\n\n- only usable by purchasing character\n- maximum amount that can be owned by character: 5\n- added directly to the Record of Blessings\n- characters with a red or black skull will always lose all equipment upon death")
	addItem("Blessings", "All regular Blessings", "All_regular_Blessings", 130, -1)
	addItem("Blessings", "The Spiritual Shielding", "The_Spiritual_Shielding", 25, 1)
	addItem("Blessings", "The Embrace of Tibia", "The_Embrace_of_Tibia", 25, 2)
	addItem("Blessings", "The Fire of the Suns", "The_Fire_of_the_Suns", 25, 3)
	addItem("Blessings", "The Wisdom of Solitude", "The_Wisdom_of_Solitude", 25, 4)
	addItem("Blessings", "The Spark of the Phoenix", "The_Spark_of_the_Phoenix", 25, 5)

	addCategory("Consumables", "Potions", 10, CATEGORY_ITEM)
	addItem("Potions", "Mana Potion", 7620, 6, 125, MANA_POTION_DESCRIPTION)
	addItem("Potions", "Mana Potion", 7620, 12, 300, MANA_POTION_DESCRIPTION)
	addItem("Potions", "Strong Mana Potion", 7589, 7, 100, MANA_POTION_DESCRIPTION)
	addItem("Potions", "Strong Mana Potion", 7589, 17, 250, MANA_POTION_DESCRIPTION)
	addItem("Potions", "Great Mana Potion", 7590, 11, 100, MANA_POTION_DESCRIPTION)
	addItem("Potions", "Great Mana Potion", 7590, 26, 250, MANA_POTION_DESCRIPTION)
	addItem("Potions", "Health Potion", 7618, 6, 125, HEALTH_POTION_DESCRIPTION)
	addItem("Potions", "Health Potion", 7618, 11, 300, HEALTH_POTION_DESCRIPTION)
	addItem("Potions", "Strong Health Potion", 7588, 10, 100, HEALTH_POTION_DESCRIPTION)
	addItem("Potions", "Strong Health Potion", 7588, 21, 250, HEALTH_POTION_DESCRIPTION)
	addItem("Potions", "Great Health Potion", 7591, 18, 100, HEALTH_POTION_DESCRIPTION)
	addItem("Potions", "Great Health Potion", 7591, 41, 250, HEALTH_POTION_DESCRIPTION)

	addCategory(nil, "Cosmetics", 21, CATEGORY_NONE)
	addCategory("Cosmetics", "Mounts", 14, CATEGORY_MOUNT)
	addItem("Mounts", "Widow Queen", 368, 450, 1, "Badgers have been a staple of the Tibian fauna for a long time, and finally some daring souls have braved the challenge to tame some exceptional specimens - and succeeded! While the common badger you can encounter during your travels might seem like a rather unassuming creature, the Battle Badger, the Ether Badger, and the Zaoan Badger are fierce and mighty beasts, which are at your beck and call")
	addItem("Mounts", "Racing Bird", 369, 450, 1, "Once captured and held captive by a mad hunter, the Woodland Prince is the result of sick experiments. Fed only with demon dust and concentrated demonic blood it had to endure a dreadful transformation. The demonic blood that is now running through its veins, however, provides it with incredible strength and endurance.")
	addItem("Mounts", "War Bear", 370, 450, 1, "Do you like fluffy bunnies but think they are too small? Do you admire the majesty of stags and their antlers but are afraid of their untameable wilderness? Do not worry, the mystic creature Wolpertinger consolidates the best qualities of both animals. Hop on its backs and enjoy the ride.")
	addItem("Mounts", "Black Sheep", 371, 450, 1, "Tenacity, strength and loyalty are the hallmarks of a Frostbringer, a Winterstride or an Icebreacher. Those travelling through barren lands, pursuing goals in forbidding environments, or simply wanting a comrade for a lifetime should fall back on this stalwart companion.")

	addCategory("Cosmetics", "Outfits", 15, CATEGORY_OUTFIT)
	addItem("Outfits", "Elementalist", 432, 450, 1, "The warm and cosy cloak of the Winter Warden outfit will keep you warm in every situation. Best thing, it is not only comfortable but fashionable as well. You will be the envy of any snow queen or king, guaranteed!")
	addItem("Outfits", "Deepling", 463, 450, 1, "The Trailblazer is on a mission of enlightenment and carries the flame of wisdom near and far. The everlasting shine brightens the hearts and minds of all creatures its rays touch, bringing light even to the darkest corners of the world as a beacon of insight and knowledge.")
	addItem("Outfits", "Insectoid", 465, 450, 1, "Do you worship warm temperatures and are opposed to the thought of long and dark winter nights? Do you refuse to spend countless evenings in front of your chimney while ice-cold wind whistles through the cracks and niches of your house? It is time to stop freezing and to become an honourable Sun Priest! With this stylish outfit, you can finally show the world your unconditional dedication and commitment to the sun!")
	addItem("Outfits", "Entrepreneur", 472, 450, 1, "The mutated pumpkin is too weak for your mighty weapons? Time to show that evil vegetable how to scare the living daylight out of people! Put on a scary looking pumpkin on your head and spread terror and fear amongst the Tibian population.")

	addCategory(nil, "Extras", 9, CATEGORY_NONE)
	addCategory("Extras", "Extra Services", 7, CATEGORY_EXTRAS)
	addItem("Extra Services", "Name Change", "Name_Change", 250, 1, "Tired of your current character name? Purchase a new one!")
	addItem("Extra Services", "Sex Change", "Sex_Change", 120, 1, "Turns your female character into a male one - or vice versa.")
end

function addCategory(parent, title, iconId, categoryId, description)
	GAME_STORE.categoriesId[title] = categoryId
	table.insert(GAME_STORE.categories, {
		title = title,
		parent = parent,
		iconId = iconId,
		categoryId = categoryId,
		description = description
	})
end

function addItem(parent, name, id, price, count, description)
	if not GAME_STORE.offers[parent] then
		GAME_STORE.offers[parent] = {}
	end

	local serverId = id
	if type(id) == "number" and GAME_STORE.categoriesId[parent] == CATEGORY_ITEM then
		id = ItemType(id):getClientId()
	end

	table.insert(GAME_STORE.offers[parent], {
		parent = parent,
		name = name,
		serverId = serverId,
		id = id,
		price = price,
		count = count,
		description = description,
		categoryId = GAME_STORE.categoriesId[parent]
	})
end

function gameStorePurchase(player, offer)
	local offers = GAME_STORE.offers[offer.parent]
	if not offers then
		return errorMsg(player, "Something went wrong, try again or contact server admin [#1]!")
	end

	for i = 1, #offers do
		if offers[i].name == offer.name and offers[i].price == offer.price and offers[i].count == offer.count then
			local points = getPoints(player)
			if offers[i].price > points then
				return errorMsg(player, "You don't have enough points!")
			end

			offer.serverId = offers[i].serverId
			local status = finalizePurchase(player, offer)
			if status then
				return errorMsg(player, status)
			end

			local aid = player:getAccountId()
			local escapeName = db.escapeString(offers[i].name)
			local escapePrice = db.escapeString(offers[i].price)
			local escapeCount = offers[i].count and db.escapeString(offers[i].count) or 0

			db.query("UPDATE `znote_accounts` set `points` = `points` - " .. offers[i].price .. " WHERE `id` = " .. aid)
			db.asyncQuery("INSERT INTO `shop_history` VALUES (NULL, " .. aid .. ", " .. player:getGuid() .. ", NOW(), " .. escapeName .. ", " .. escapePrice .. ", " .. escapeCount .. ", NULL)")
			addEvent(gameStoreUpdateHistory, 1000, player:getId())
			addEvent(gameStoreUpdatePoints, 1000, player:getId())
			return infoMsg(player, "You've bought " .. offers[i].name .. "!", true)
		end
	end
	
	return errorMsg(player, "Something went wrong, try again or contact server admin [#3]!")
end

function finalizePurchase(player, offer)
	local categoryId = GAME_STORE.categoriesId[offer.parent]
	if categoryId == CATEGORY_PREMIUM then
		return defaultPremiumCallback(player, offer)
	elseif categoryId == CATEGORY_ITEM then
		return defaultItemCallback(player, offer)
	elseif categoryId == CATEGORY_BLESSING then
		return defaultBlessingCallback(player, offer)
	elseif categoryId == CATEGORY_OUTFIT then
		return defaultOutfitCallback(player, offer)
	elseif categoryId == CATEGORY_MOUNT then
		return defaultMountCallback(player, offer)
	elseif categoryId == CATEGORY_EXTRAS then
		return defaultExtrasCallback(player, offer)
	end

	return "Something went wrong, try again or contact server admin [#2]!"
end

function defaultPremiumCallback(player, offer)
	player:addPremiumDays(offer.count)
	return false
end

function defaultItemCallback(player, offer)
	local weight = ItemType(offer.serverId):getWeight(offer.count)
	if player:getFreeCapacity() < weight then
		return "This item is too heavy for you!"
	end

	local item = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not item then
		return "You don't have enough space in backpack."
	end

	local slots = item:getEmptySlots(true)
	if slots <= 0 then
		return "You don't have enough space in backpack."
	end

	if player:addItem(offer.serverId, offer.count, false) then
		return false
	end

	return "Something went wrong, item couldn't be added."
end

function defaultBlessingCallback(player, offer)
	if offer.count == -1 then
		for i = 1, 5 do
			if not player:hasBlessing(i) then
				for i = 1, 5 do
					player:addBlessing(i)
				end

				return false
			end
		end

		return "You already have all blessings."
	elseif player:hasBlessing(offer.count) then
		return "You already have this blessing."
	end
	
	layer:addBlessing(offer.count)
	return false
end

function defaultOutfitCallback(player, offer)
	if player:hasOutfit(offer.id, 3) then
		return "You already have this outfit with addons."
	end

	player:addOutfitAddon(offer.id, 3)
	return false
end

function defaultMountCallback(player, offer)
	if player:hasMount(offer.id) then
		return "You already have this mount."
	end

	if not player:addMount(offer.id) then
		return "Something went wrong, mount cannot be added."
	end

	return false
end

function defaultExtrasCallback(player, offer)
	if offer.name == "Name Change" then
		return defaultChangeNameCallback(player, offer)
	elseif offer.name == "Sex Change" then
		return defaultChangeSexCallback(player)
	end

	return "Something went wrong, extra service couldn't be executed."
end

function defaultChangeSexCallback(player)
    if player:getCondition(CONDITION_INFIGHT) then
        return "You can't do this during a fight."
    end

    if not getTilePzInfo(getPlayerPosition(player)) then
        return "You need to be in pz."
    end

    if not player:getGroup() then
        return "You can't do this."
    end

    player:setSex(player:getSex() == PLAYERSEX_FEMALE and PLAYERSEX_MALE or PLAYERSEX_FEMALE)
	
    local outfit = player:getOutfit()
    if player:getSex(player) == PLAYERSEX_MALE then
        outfit.lookType = 128
    else
        outfit.lookType = 136
    end

    player:setOutfit(outfit)
    return false
end

function defaultChangeNameCallback(player, offer)
    if player:getCondition(CONDITION_INFIGHT) then
        return "You can't do this during a fight."
    end

    if not getTilePzInfo(getPlayerPosition(player)) then
        return "You need to be in pz."
    end

    if not player:getGroup() then
        return "You can't do this."
    end

	local characterName = offer.nick:trim()
	local v = getValid(characterName:lower(), false) -- true se quiser que toda primeira letra seja maiÃºscula
	if not validName(v) then
		return "You can't use this character name."
	end

	if getPlayerDatabaseInfo(v) then
		return "Character name already taken."
	end

	local lastName = getPlayerName(player)
	db.query("UPDATE players SET name = "..db.escapeString(characterName).." WHERE name = "..db.escapeString(lastName)..";")
	db.query("UPDATE player_deaths SET killed_by = "..db.escapeString(characterName)..", mostdamage_by = "..db.escapeString(characterName).." WHERE killed_by = "..db.escapeString(lastName).." OR mostdamage_by = "..db.escapeString(lastName)..";")
    db.query("UPDATE player_deaths_backup SET killed_by = "..db.escapeString(characterName)..", mostdamage_by = "..db.escapeString(characterName).." WHERE killed_by = "..db.escapeString(lastName).." OR mostdamage_by = "..db.escapeString(lastName)..";")
	db.query(string.format("INSERT INTO `change_name_history` (`player_id`, `last_name`, `current_name`, `changed_name_in`) VALUES (%d, %s, %s, %d)", player:getGuid(), db.escapeString(lastName), db.escapeString(characterName), os.time()))
	return false
end

function getValid(name, opt)
    local function tchelper(first, rest)
        return first:upper()..rest:lower()
    end

    return opt and name:gsub("(%a)([%w_']*)", tchelper) or name:gsub("^%l", string.upper)
end

function wordCount(str)
    local count = 0
    for word in string.gmatch(str, "%a+") do
        count = count + 1
    end

    return count
end

function validName(name)
    if not name then
		return false
	end

	if name:len() < minChars then
		return false
	end

	for i = 1, #forbiddenWords do
		for word in string.gmatch(name, "%a+") do
			if word:lower() == forbiddenWords[i] then
				return false
			end
		end
	end

    for i = 1, name:len() do
        if not(isInArray(chars, name:sub(i,i))) or wordCount(name) > maxWords or name:len() > maxLength or string.find(name, "  ") then
            return false
        end
    end

    return true
end

function gameStoreUpdateHistory(player)
	if type(player) == "number" then
		player = Player(player)
	end

	local history = {}
	local resultId = db.storeQuery("SELECT * FROM `shop_history` WHERE `account` = " .. player:getAccountId() .. " order by `id` DESC")
	if resultId ~= false then
		repeat
			table.insert(history, {
				date = result.getDataString(resultId, "date"),
				price = result.getDataInt(resultId, "price"),
				name = result.getDataString(resultId, "title"),
				count = result.getDataInt(resultId, "count")
			})
		until not result.next(resultId)
		result.free(resultId)
	end
	
	player:sendExtendedOpcode(ExtendedOPCodes.CODE_GAMESTORE, json.encode({action = "history", data = history}))
end

local ExtendedEvent = CreatureEvent("GameStoreExtended")

function ExtendedEvent.onExtendedOpcode(player, opcode, buffer)
	if opcode == ExtendedOPCodes.CODE_GAMESTORE then
		if not GAME_STORE then
			gameStoreInitialize()
			addEvent(refreshPlayersPoints, 10 * 1000)
		end

		local status, json_data =
			pcall(
			function()
				return json.decode(buffer)
			end
		)
		if not status then
			return
		end

		local action = json_data.action
		local data = json_data.data
		if not action or not data then
			return
		end

		if action == "fetch" then
			gameStoreFetch(player)
		elseif action == "purchase" then
			gameStorePurchase(player, data)
		elseif action == "transfer" then
			gameStoreTransferCoins(player, data)
		elseif action == "changeName" then
			gameStoreChangeName(player, data)
		end
	end
end

function gameStoreFetch(player)
	gameStoreUpdatePoints(player)
	gameStoreUpdateHistory(player)

	player:sendExtendedOpcode(ExtendedOPCodes.CODE_GAMESTORE, json.encode({action = "fetchBase", data = {categories = GAME_STORE.categories, url = DONATION_URL}}))

	for category, offersTable in pairs(GAME_STORE.offers) do
		player:sendExtendedOpcode(ExtendedOPCodes.CODE_GAMESTORE, json.encode({action = "fetchOffers", data = {category = category, offers = offersTable}}))
	end
end

function gameStoreUpdatePoints(player)
	if type(player) == "number" then
		player = Player(player)
	end

	player:sendExtendedOpcode(ExtendedOPCodes.CODE_GAMESTORE, json.encode({action = "points", data = getPoints(player)}))
end

function gameStoreUpdatePointsAndRemovePlayer(player)
	if type(player) == "number" then
		player = Player(player)
	end

	player:sendExtendedOpcode(ExtendedOPCodes.CODE_GAMESTORE, json.encode({action = "points", data = getPoints(player)}))
	player:remove()
end

function gameStoreChangeName(player, offer)
	local offers = GAME_STORE.offers[offer.category]
	if not offers then
		return errorMsg(player, "Something went wrong, try again or contact server admin [#1]!")
	end
	
	if not offer.nick then
		return errorMsg(player, "You need to choose a new nickname.")
	end

	for i = 1, #offers do
		if offers[i].title == offer.title and offers[i].price == offer.price then
			local callback = offers[i].callback
			if not callback then
				return errorMsg(player, "Something went wrong, try again or contact server admin [#2]!")
			end

			local points = getPoints(player)
			if offers[i].price > points then
				return errorMsg(player, "You don't have enough points!")
			end

			if player:getName() == offer.nick then
				return errorMsg(player, "Please choose a new nickname different from your previous one")
			end

			local status = callback(player, offer)
			if status ~= true then
				return errorMsg(player, status)
			end

			local aid = player:getAccountId()
			local escapeTitle = db.escapeString(offers[i].title)
			local escapePrice = db.escapeString(offers[i].price)
			local escapeCount = offers[i].count and db.escapeString(offers[i].count) or 0
			db.query("UPDATE `znote_accounts` set `points` = `points` - " .. offers[i].price .. " WHERE `id` = " .. aid)
			db.asyncQuery("INSERT INTO `shop_history` VALUES (NULL, '" .. aid .. "', '" .. player:getGuid() .. "', NOW(), " .. escapeTitle .. ", " .. escapePrice .. ", " .. escapeCount .. ", NULL)")

			addEvent(gameStoreUpdateHistory, 1000, player:getId())
			addEvent(gameStoreUpdatePointsAndRemovePlayer, 1000, player:getId())
			return infoMsg(player, "You've bought " .. offers[i].title .. "! Please log out of your account and join us with your new name already set.", true)
		end
	end

	return errorMsg(player, "Something went wrong, try again or contact server admin [#4]!")
end

function gameStoreTransferCoins(player, transfer)
	local receiver = transfer.target
	local amount = transfer.amount
	if not receiver then
		return errorMsg(player, "Target player not found! Make sure the receiver is online")
	end

	local points = getPoints(player)
	if amount > points then
		return errorMsg(player, "You don't have enough points!")
	end

	local targetPlayer = Player(receiver)
	if not targetPlayer then
		return errorMsg(player, "Target player not found! Make sure the receiver is online")
	end

	if receiver:lower() == player:getName():lower() then
		return errorMsg(player, "You can't transfer coins to yourself.")
	end

	local aid = player:getAccountId()
	local title = "Coin Transfer"
	local escapeTitle = db.escapeString(title)
	local escapePrice = db.escapeString(amount)
	local escapeCount = 1
	local escapeTarget = db.escapeString(targetPlayer:getName())
	db.query("UPDATE `znote_accounts` set `points` = `points` - " .. amount .. " WHERE `id` = " .. aid)
	db.asyncQuery("INSERT INTO `shop_history` VALUES (NULL, '" .. aid .. "', '" .. player:getGuid() .. "', NOW(), " .. escapeTitle .. ", " .. escapePrice .. ", " .. escapeCount .. ", " .. escapeTarget .. ")")

	local targetaid = targetPlayer:getAccountId()
	db.query("UPDATE `znote_accounts` set `points` = `points` + " .. amount .. " WHERE `id` = " .. targetaid)
	addEvent(gameStoreUpdateHistory, 1000, player:getId())
	addEvent(gameStoreUpdatePoints, 1000, player:getId())
	addEvent(gameStoreUpdateHistory, 1000, targetPlayer:getId())
	addEvent(gameStoreUpdatePoints, 1000, targetPlayer:getId())
	return infoMsg(player, "You've sent " .. amount .. " coins to " .. targetPlayer:getName() .. "!", true)
end

function getPoints(player)
	local points = 0
	local resultId = db.storeQuery("SELECT `points` FROM `znote_accounts` WHERE `id` = " .. player:getAccountId())
	if resultId ~= false then
		points = result.getDataInt(resultId, "points")
		result.free(resultId)
	end

	return points
end

function errorMsg(player, msg)
	player:sendExtendedOpcode(ExtendedOPCodes.CODE_GAMESTORE, json.encode({action = "msg", data = {type = "error", msg = msg}}))
end

function infoMsg(player, msg, close)
	if not close then
		close = false
	end

	player:sendExtendedOpcode(ExtendedOPCodes.CODE_GAMESTORE, json.encode({action = "msg", data = {type = "info", msg = msg, close = close}}))
end

function refreshPlayersPoints()
	for _, p in ipairs(Game.getPlayers()) do
		if p:getIp() > 0 then
			gameStoreUpdatePoints(p)
		end
	end
	addEvent(refreshPlayersPoints, 10 * 1000)
end

LoginEvent:type("login")
LoginEvent:register()
ExtendedEvent:type("extendedopcode")
ExtendedEvent:register()