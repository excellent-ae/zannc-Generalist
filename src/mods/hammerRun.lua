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
