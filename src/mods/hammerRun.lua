local prevEnabled = false
local previousUnderValue = config.HammerAmountUnderWorld
local previousSurfaceValue = config.HammerAmountSurface

local function RemoveHammers(removeCustomOnly)
	for i = #game.RewardStoreData.RunProgress, 1, -1 do
		local v = game.RewardStoreData.RunProgress[i]
		if v.Name == "WeaponUpgrade" and (not removeCustomOnly or v.CustomHammer) then
			table.remove(game.RewardStoreData.RunProgress, i)
		end
	end

	for i = #game.RewardStoreData.HubRewards, 1, -1 do
		local v = game.RewardStoreData.HubRewards[i]
		if v.Name == "WeaponUpgrade" and (not removeCustomOnly or v.CustomHammer) then
			table.remove(game.RewardStoreData.HubRewards, i)
		end
	end
end

-- Remove the cleared biomes requirement for Hammers
local function EnableDisableHammerRunDrops()
	if not config.HammerRateMod then
		return
	end

	local hammerupgrade = {
		Name = "WeaponUpgrade",
		AllowDuplicates = true,
		CustomHammer = true,
		GameStateRequirements = {
			--
		},
	}

	RemoveHammers() -- Remove Original Hammer Drops

	if not prevEnabled or config.HammerAmountUnderWorld ~= previousUnderValue then
		previousUnderValue = config.HammerAmountUnderWorld
		for i = 1, config.HammerAmountUnderWorld do
			table.insert(game.RewardStoreData.RunProgress, hammerupgrade)
		end
	end

	if not prevEnabled or config.HammerAmountSurface ~= previousSurfaceValue then
		previousSurfaceValue = config.HammerAmountSurface
		for i = 1, config.HammerAmountSurface do
			table.insert(game.RewardStoreData.HubRewards, hammerupgrade)
		end
	end

	prevEnabled = true
end

ModUtil.LoadOnce(function()
	EnableDisableHammerRunDrops()
end)

-- ========= ImGUI CODE
function DrawHammerDrops()
	if config.HammerRateMod then
		rom.ImGui.Text("NOTE, 4 = Chance of 4 Hammers per Biome.\nAs opposed to the default of 1 per 2 biomes")

		local underworldValue, underworldSelected = rom.ImGui.SliderInt("Underworld Drop Amount", config.HammerAmountUnderWorld, 1, 4)
		if underworldSelected then
			config.HammerAmountUnderWorld = underworldValue
		end

		local surfaceValue, surfaceSelected = rom.ImGui.SliderInt("Surface Drop Amount", config.HammerAmountSurface, 1, 4)
		if surfaceSelected then
			config.HammerAmountSurface = surfaceValue
		end

		-- Make sure its called only when it needs to be
		if config.HammerAmountUnderWorld ~= previousUnderValue or config.HammerAmountSurface ~= previousSurfaceValue then
			EnableDisableHammerRunDrops()
		end
	else
		if prevEnabled then
			prevEnabled = false
			RemoveHammers(true) -- Remove custom hammer drops

			local hammerupgradedefault = {
				Name = "WeaponUpgrade",
				GameStateRequirements = {
					NamedRequirements = { "HammerLootRequirements" },
				},
			}

			local hammerupgradebiome = {
				Name = "WeaponUpgrade",
				GameStateRequirements = {
					NamedRequirements = { "LateHammerLootRequirements" },
				},
			}

			-- Underworld
			table.insert(game.RewardStoreData.RunProgress, hammerupgradedefault)
			table.insert(game.RewardStoreData.RunProgress, hammerupgradebiome)

			-- Surface
			table.insert(game.RewardStoreData.HubRewards, hammerupgradedefault)
		end
	end
end
