---@meta _
---@diagnostic disable: lowercase-global

local mods = rom.mods
local practicalGods = mods["zannc-Practical_Gods"]

zanncdwbl_Generalist.upgrades = {
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
	table.insert(zanncdwbl_Generalist.upgrades, { loot = "ArtemisUpgrade", name = "Boon", custconfig = "Artemis" })
end

local function pickRandomUpgrade()
	local enabled = {}
	for _, upgrade in ipairs(zanncdwbl_Generalist.upgrades) do
		if config[upgrade.custconfig].Enabled then
			table.insert(enabled, upgrade.name)
		end
	end

	local randomIndex = math.random(1, #enabled)
	return enabled[randomIndex]
end

local function pickRandomGod()
	local enabled = {}
	for _, upgrade in ipairs(zanncdwbl_Generalist.upgrades) do
		if config[upgrade.custconfig].Enabled then
			table.insert(enabled, upgrade.loot)
		end
	end

	local randomIndex = math.random(1, #enabled)
	return enabled[randomIndex]
end

function SpawnRoomRewardFunc()
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
end

SpawnRoomRewardFunc()
