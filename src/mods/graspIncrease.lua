-- Honestly cant think of a better way to do this with a wrap
modutil.mod.Path.Override("GetMaxMetaUpgradeCost", function()
	if config.GraspCardMod then
		return config.MaxGrasp
	else
		local metaUpgradeLimit = MetaUpgradeCostData.StartingMetaUpgradeLimit
		for i = 1, GetCurrentMetaUpgradeLimitLevel() do
			if MetaUpgradeCostData.MetaUpgradeLevelData[i] then
				metaUpgradeLimit = metaUpgradeLimit + MetaUpgradeCostData.MetaUpgradeLevelData[i].CostIncrease
			end
		end
		GameState.MaxMetaUpgradeCostCache = metaUpgradeLimit
		return metaUpgradeLimit
	end
end)

local function GetCardCostCount(tbl)
	local maxAmount = 0
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			if k ~= "BaseMetaUpgrade" and k ~= "BaseBonusMetaUpgrade" then
				if v.Cost then
					maxAmount = maxAmount + v.Cost
				end
			end
		end
	end
	return maxAmount
end

zanncdwbl_Generalist.maxCardCost = GetCardCostCount(game.MetaUpgradeCardData)
