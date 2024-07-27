-- Set Custom Consumable (Ash/Psyche/Bones) amounts
function ChangeConsumableAmountDropped()
	if config.ConsumableMod then
		-- Ash
		game.ConsumableData.MetaCardPointsCommonDrop.AddResources.MetaCardPointsCommon = config.AshAmount

		-- Psyche
		game.ConsumableData.MemPointsCommonDrop.AddResources.MemPointsCommon = config.PsycheAmount

		-- Bones
		game.ConsumableData.MetaCurrencyDrop.AddResources.MetaCurrency = config.BonesAmount
	else
		-- Ash
		game.ConsumableData.MetaCardPointsCommonDrop.AddResources.MetaCardPointsCommon = 5

		-- Psyche
		game.ConsumableData.MemPointsCommonDrop.AddResources.MemPointsCommon = 10

		-- Bones
		game.ConsumableData.MetaCurrencyDrop.AddResources.MetaCurrency = 50
	end
end

ChangeConsumableAmountDropped()
