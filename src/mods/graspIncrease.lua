local function setGraspAmount(value)
	-- In case the user is dumb and sets grasp amount to less than 10
	if value < 10 then
		config.MaxGrasp = 10
		print("Grasp Amount is less than 10.... why... setting to the game default of 10")
	end
end

-- Honestly cant think of a better way to do this with a wrap
modutil.mod.Path.Override("GetMaxMetaUpgradeCost", function()
	if config.GraspCardMod then
		setGraspAmount(config.MaxGrasp)
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

modutil.mod.Path.Wrap("ShouldShowMetaUpgradeCapacityHint", function(base, screen)
	if config.GraspCardMod and config.DisableGraspCheck then
		return false
	else
		return base(screen)
	end
end)

-- This function is just to get the max grasp needed to activate all cards
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

local maxCardCost = GetCardCostCount(game.MetaUpgradeCardData)

-- ! ImGUI CODE
function DrawMaxGrasp()
	if not config.GraspCardMod then
		return
	end

	local value, selected = rom.ImGui.SliderInt("Grasp Amount", config.MaxGrasp, 10, maxCardCost)
	if selected then
		config.MaxGrasp = value
	end

	rom.ImGui.Spacing()

	local value, selected = rom.ImGui.Checkbox("Disable 'Untapped Potential' when you can select more cards.", config.DisableGraspCheck)
	if selected then
		config.DisableGraspCheck = value
	end
end
