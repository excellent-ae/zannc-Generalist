---@meta _
---@diagnostic disable: lowercase-global

local mods = rom.mods
local practicalGods = mods["zannc-Practical_Gods"]

local upgrades = {
	{ name = "WeaponUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "WeaponUpgrade" } } }, custconfig = "Hammer" },
	{ name = "SpellDrop", requirements = { { PathFalse = { "GameState", "UseRecord", "SpellDrop" } } }, custconfig = "Selene" },
	{ loot = "ZeusUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "ZeusUpgrade" } } }, name = "Boon", custconfig = "Zeus" },
	{ loot = "HeraUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "HeraUpgrade" } } }, name = "Boon", custconfig = "Hera" },
	{ loot = "HestiaUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "HestiaUpgrade" } } }, name = "Boon", custconfig = "Hestia" },
	{ loot = "AphroditeUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "AphroditeUpgrade" } } }, name = "Boon", custconfig = "Aphrodite" },
	{ loot = "PoseidonUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "PoseidonUpgrade" } } }, name = "Boon", custconfig = "Poseidon" },
	{ loot = "HephaestusUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "HephaestusUpgrade" } } }, name = "Boon", custconfig = "Hephaestus" },
	{ loot = "HermesUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "HermesUpgrade" } } }, name = "Boon", custconfig = "Hermes" },
	{ loot = "ApolloUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "ApolloUpgrade" } } }, name = "Boon", custconfig = "Apollo" },
	{ loot = "DemeterUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "DemeterUpgrade" } } }, name = "Boon", custconfig = "Demeter" },
}
if practicalGods then
	table.insert(upgrades, { loot = "ArtemisUpgrade", requirements = { { PathFalse = { "GameState", "UseRecord", "ArtemisUpgrade" } } }, name = "Boon", custconfig = "Artemis" })
end

game.RoomData.F_Opening01.ForcedRewards = {}

-- check how many upgrades are enabled
local amountEnabled = 0
for _, upgrade in ipairs(upgrades) do
	if config[upgrade.custconfig].Enabled then
		amountEnabled = amountEnabled + 1
	end
end

-- insert into table if enabled, if it has a lootname aka god, insert that, and if thereis more than 1 thing enabled, add gamestate
for _, upgrade in ipairs(upgrades) do
	if config[upgrade.custconfig].Enabled then
		local reward = { Name = upgrade.name }
		if upgrade.loot then
			reward.LootName = upgrade.loot
		end
		if amountEnabled > 1 then
			reward.GameStateRequirements = upgrade.requirements
		end
		table.insert(game.RoomData.F_Opening01.ForcedRewards, reward)
	end
end

-- Do it for 2 and 3, and surface
game.RoomData.F_Opening02.ForcedRewards = game.RoomData.F_Opening01.ForcedRewards
game.RoomData.F_Opening03.ForcedRewards = game.RoomData.F_Opening01.ForcedRewards
game.RoomData.N_Opening01.ForcedRewards = game.RoomData.F_Opening01.ForcedRewards
