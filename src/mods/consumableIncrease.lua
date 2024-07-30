-- Set Custom Consumable (Ash/Psyche/Bones) amounts
local function ChangeConsumableAmountDropped()
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

-- Initial Run
ChangeConsumableAmountDropped()

-- ========= ImGUI CODE
function DrawConsumableChanges()
	local function mainGUICode()
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
	end

	local value, checked = rom.ImGui.Checkbox("Enable Consumable Gain Changes", config.ConsumableMod)
	if checked then
		config.ConsumableMod = value
	end
	if config.ConsumableMod then
		mainGUICode()
	end
end

-- ========= ImGUI CODE
-- function DrawZoomMod()
-- 	if config.ZoomMod then
-- 		rom.ImGui.Text("Zoom Amount")
-- 		local value, selected = rom.ImGui.SliderFloat("Default: 0.75", config.ZoomModValue, 0, 2)
-- 		if selected then
-- 			config.ZoomModValue = value
-- 		end
-- 		ChangeZoomAmount()
-- 	else
-- 		-- Reset everything
-- 		if prevEnabled then
-- 			game.RoomSetData = DeepCopyTable(zanncdwbl_Generalist.origianRoomSet)
-- 			AdjustZoom({ Fraction = 0.75, LerpTime = 0.02 })
-- 			hasChanged = false
-- 			prevEnabled = false
-- 		end
-- 	end
-- end
