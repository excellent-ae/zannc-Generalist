---@meta _
---@diagnostic disable: lowercase-global

local mods = rom.mods
local practicalGods = mods["zannc-Practical_Gods"]

-- These functions are just to define all rewards, then a func for choosing upgrade, and if its a boon then a random god
local dropUpgrades = {
	{ name = "WeaponUpgrade", custconfig = "Hammer" },
	{ name = "SpellDrop", custconfig = "Selene" },
	{ loot = "TrialUpgrade", name = "Boon", custconfig = "Chaos" },

	{ loot = "ZeusUpgrade", name = "Boon", custconfig = "Zeus" },
	{ loot = "HeraUpgrade", name = "Boon", custconfig = "Hera" },
	{ loot = "HestiaUpgrade", name = "Boon", custconfig = "Hestia" },
	{ loot = "AphroditeUpgrade", name = "Boon", custconfig = "Aphrodite" },
	{ loot = "PoseidonUpgrade", name = "Boon", custconfig = "Poseidon" },
	{ loot = "HephaestusUpgrade", name = "Boon", custconfig = "Hephaestus" },
	{ loot = "HermesUpgrade", name = "Boon", custconfig = "Hermes" },
	{ loot = "ApolloUpgrade", name = "Boon", custconfig = "Apollo" },
	{ loot = "DemeterUpgrade", name = "Boon", custconfig = "Demeter" },
	{ loot = "AresUpgrade", name = "Boon", custconfig = "Ares" },
}
if practicalGods then
	table.insert(dropUpgrades, { loot = "ArtemisUpgrade", name = "Boon", custconfig = "Artemis" })
end

local boonConfigs = {}

local function initBoonConfigs()
	for i, boon in ipairs(dropUpgrades) do
		boonConfigs[i] = {
			label = boon.custconfig,
			configKey = boon.custconfig,
			enabled = config[boon.custconfig].Enabled,
		}
	end
end

initBoonConfigs()

local function pickRandomUpgrade()
	local enabled = {}
	for _, upgrade in ipairs(dropUpgrades) do
		if config[upgrade.custconfig].Enabled then
			table.insert(enabled, upgrade.name)
		end
	end

	local randomIndex = math.random(1, #enabled)
	return enabled[randomIndex]
end

local function pickRandomGod()
	local enabled = {}
	for _, upgrade in ipairs(dropUpgrades) do
		if config[upgrade.custconfig].Enabled then
			table.insert(enabled, upgrade.loot)
		end
	end

	local randomIndex = math.random(1, #enabled)
	return enabled[randomIndex]
end

-- Main Chunk of code which overrides spawns
modutil.mod.Path.Wrap("SpawnRoomReward", function(base, eventSource, args)
	if config.StartingDropMod then
		args = args or {}
		if game.CurrentRun.CurrentRoom.BiomeStartRoom then
			if args.WaitUntilPickup then
				args.RewardOverride = pickRandomUpgrade()
				if args.RewardOverride == "Boon" then
					args.LootName = pickRandomGod()
				end
				local spawn = args.LootName or args.RewardOverride or "unknown"
				print("Spawning: " .. spawn)
			end
		end
		-- Needs to return smh
		return base(eventSource, args)
	else
		print("Starting Reward mod is disabled")
		return base(eventSource, args)
	end
end)

-- ! ImGUI CODE
function DrawBoonManager()
	if not config.StartingDropMod then
		return
	end

	rom.ImGui.Spacing()
	local open = rom.ImGui.CollapsingHeader("Starting Room Drop Manager")
	if open then
		rom.ImGui.BeginChild("BoonScrolling", 0, 220)

		for i, boonConfig in ipairs(boonConfigs) do
			local value, checked = rom.ImGui.Checkbox(boonConfig.label, boonConfig.enabled)
			if checked then
				config[boonConfig.configKey].Enabled = value
				boonConfigs[i].enabled = value
			end
		end

		rom.ImGui.EndChild()
	end
end
