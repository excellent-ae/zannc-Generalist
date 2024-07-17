-- Honestly cant think of a better way to do this with a wrap
modutil.mod.Path.Override("GetMaxMetaUpgradeCost", function()
	return config.MaxGrasp
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
