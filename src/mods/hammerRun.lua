-- ========= ImGUI CODE
function drawHammerDrops()
	rom.ImGui.Text("NOTE, 4 = Chance of 4 Hammers per Biome.\nAs opposed to the default of 1 per 2 biomes")

	local underworldValue, underworldSelected = rom.ImGui.SliderInt("Underworld Drop Amount", config.HammerAmountUnderWorld, 1, 4)
	if underworldSelected then
		config.HammerAmountUnderWorld = underworldValue
	end

	local surfaceValue, surfaceSelected = rom.ImGui.SliderInt("Surface Drop Amount", config.HammerAmountSurface, 1, 4)
	if surfaceSelected then
		config.HammerAmountSurface = surfaceValue
	end
end
-- ========= END

-- Remove the cleared biomes requirement for Hammers
function EnableDisableHammerRunDrops()
	if config.HammerRateMod then
		local hammerupgrade = {
			Name = "WeaponUpgrade",
			AllowDuplicates = true,
			CustomHammer = true,
			GameStateRequirements = {
				--
			},
		}

		for i = 1, config.HammerAmountUnderWorld do
			table.insert(game.RewardStoreData.RunProgress, hammerupgrade)
		end
		for i = 1, config.HammerAmountSurface do
			table.insert(game.RewardStoreData.HubRewards, hammerupgrade)
		end
	else
		for i = #game.RewardStoreData.RunProgress, 1, -1 do
			local v = game.RewardStoreData.RunProgress[i]
			if v.Name == "WeaponUpgrade" and v.CustomHammer then
				table.remove(game.RewardStoreData.RunProgress, i)
			end
		end

		for i = #game.RewardStoreData.HubRewards, 1, -1 do
			local v = game.RewardStoreData.HubRewards[i]
			if v.Name == "WeaponUpgrade" and v.CustomHammer then
				table.remove(game.RewardStoreData.HubRewards, i)
			end
		end
	end
end

EnableDisableHammerRunDrops()
