---@meta _
---@diagnostic disable: lowercase-global

local mods = rom.mods
local practicalGods = mods["zannc-Practical_Gods"]

local upgrades = {
	{ name = "WeaponUpgrade", custconfig = "Hammer" },
	{ name = "SpellDrop", custconfig = "Selene" },

	{ loot = "ZeusUpgrade", name = "Boon", custconfig = "Zeus" },
	{ loot = "HeraUpgrade", name = "Boon", custconfig = "Hera" },
	{ loot = "HestiaUpgrade", name = "Boon", custconfig = "Hestia" },
	{ loot = "AphroditeUpgrade", name = "Boon", custconfig = "Aphrodite" },
	{ loot = "PoseidonUpgrade", name = "Boon", custconfig = "Poseidon" },
	{ loot = "HephaestusUpgrade", name = "Boon", custconfig = "Hephaestus" },
	{ loot = "HermesUpgrade", name = "Boon", custconfig = "Hermes" },
	{ loot = "ApolloUpgrade", name = "Boon", custconfig = "Apollo" },
	{ loot = "DemeterUpgrade", name = "Boon", custconfig = "Demeter" },
}
if practicalGods then
	table.insert(upgrades, { loot = "ArtemisUpgrade", name = "Boon", custconfig = "Artemis" })
end

local function pickRandomUpgrade()
	local enabled = {}
	for _, upgrade in ipairs(upgrades) do
		if config[upgrade.custconfig].Enabled then
			table.insert(enabled, upgrade.name)
		end
	end

	local randomIndex = math.random(1, #enabled)
	return enabled[randomIndex]
end

local function pickRandomGod()
	local enabled = {}
	for _, upgrade in ipairs(upgrades) do
		if config[upgrade.custconfig].Enabled then
			table.insert(enabled, upgrade.loot)
		end
	end

	local randomIndex = math.random(1, #enabled)
	return enabled[randomIndex]
end

modutil.mod.Path.Wrap("SpawnRoomReward", function(base, eventSource, args)
	args = args or {}
	if args.WaitUntilPickup then
		args.RewardOverride = pickRandomUpgrade()
		if args.RewardOverride == "Boon" then
			args.LootName = pickRandomGod()
		end
	end
	base(eventSource, args)
end)
