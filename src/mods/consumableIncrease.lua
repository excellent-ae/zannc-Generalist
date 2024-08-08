-- Set Custom Consumable (Ash/Psyche/Bones) amounts
local function ChangeConsumableAmountDropped()
	if not config.ConsumableMod then
		return
	end

	-- Ash
	game.ConsumableData.MetaCardPointsCommonDrop.AddResources.MetaCardPointsCommon = config.AshAmount
	game.ConsumableData.MetaCardPointsCommonBigDrop.AddResources.MetaCardPointsCommon = config.AshAmount

	-- Psyche
	game.ConsumableData.MemPointsCommonDrop.AddResources.MemPointsCommon = config.PsycheAmount
	game.ConsumableData.MemPointsCommonBigDrop.AddResources.MemPointsCommon = config.PsycheAmount

	-- Bones
	game.ConsumableData.MetaCurrencyDrop.AddResources.MetaCurrency = config.BonesAmount

	-- in a function so i can minimize
	local function undone()
		-- undone and im lazy to implement these, can honest to god just use ponymenu for resources
		-- -- Silver
		-- game.ConsumableData.OreFSilverDrop.AddResources.OreFSilver = config.SilverAmount

		-- -- Bronze
		-- game.ConsumableData.OreNBronzeDrop.AddResources.OreNBronze = config.BronzeAmount

		-- -- Iron
		-- game.ConsumableData.OreOIronDrop.AddResources.OreOIron = config.IronAmount

		-- -- Iron
		-- game.ConsumableData.PlantFMolyDrop.AddResources.PlantFMoly = config.MolyAmount

		-- MetaFabricDrop
		--     GiftDrop
		--     GiftPointsRareDrop
		--     GiftPointsEpicDrop
		--     WeaponPointsRareDrop
		--     MixerFBossDrop
		--     MixerGBossDrop
		--     MixerHBossDrop
		--     MixerIBossDrop
		--     MixerNBossDrop
		--     MixerOBossDrop
		--     Mixer5CommonDrop
		--     Mixer6CommonDrop
		--     CardUpgradePointsDrop
		--     FamiliarPointsDrop
		--    CharonPointsDrop
	end
end

-- Initial Run
ModUtil.LoadOnce(function()
	ChangeConsumableAmountDropped()
end)

-- ========= ImGUI CODE
function DrawConsumableChanges()
	-- Max x100 amount
	if config.ConsumableMod then
		-- Ash Slider
		local ashValue, ashSelected = rom.ImGui.SliderInt("Ash Amount", config.AshAmount, 5, 500)
		if ashSelected then
			config.AshAmount = ashValue
			ChangeConsumableAmountDropped()
		end

		-- Psyche  Slider
		local psycheValue, psycheSelected = rom.ImGui.SliderInt("Psyche Amount", config.PsycheAmount, 10, 1000)
		if psycheSelected then
			config.PsycheAmount = psycheValue
			ChangeConsumableAmountDropped()
		end

		-- Bones Slider
		local bonesValue, bonesSelected = rom.ImGui.SliderInt("Bones Amount", config.BonesAmount, 50, 5000)
		if bonesSelected then
			config.BonesAmount = bonesValue
			ChangeConsumableAmountDropped()
		end
	else
		-- Ash
		game.ConsumableData.MetaCardPointsCommonDrop.AddResources.MetaCardPointsCommon = 5
		game.ConsumableData.MetaCardPointsCommonBigDrop.AddResources.MetaCardPointsCommon = 10

		-- Psyche
		game.ConsumableData.MemPointsCommonDrop.AddResources.MemPointsCommon = 10
		game.ConsumableData.MemPointsCommonBigDrop.AddResources.MemPointsCommon = 20

		-- Bones
		game.ConsumableData.MetaCurrencyDrop.AddResources.MetaCurrency = 50
	end
end
