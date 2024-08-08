local previousZoomModValue = config.ZoomModValue
local hasChanged = false
local prevEnabled = false

local function roomZoomFraction()
	for _, roomSetData in pairs(game.RoomSetData) do
		for _, roomData in pairs(roomSetData) do
			roomData.ZoomFraction = config.ZoomModValue
		end
	end
end

-- doing a slider may or may not lag people heavily.
local function ChangeZoomAmount(zoom)
	if not zoom then
		return
	end

	-- Basically don't want/need it running ever iter, and to always have your config, don't want zoom reseting on refresh/new room
	if not hasChanged then
		roomZoomFraction()
		hasChanged = true
	end

	-- [[ First set is so that if you enabled the mod after disabling it, it will automatically adjust zoom
	-- Second set is to allow for the camera to zoom in/out as you move the slider (very important to compare if its different or else it will lag)]]
	if not prevEnabled or config.ZoomModValue ~= previousZoomModValue then
		AdjustZoom({ Fraction = config.ZoomModValue, LerpTime = 0.1 })
		previousZoomModValue = config.ZoomModValue
		prevEnabled = true

		-- Change the ZoomFraction too
		roomZoomFraction()
	end
end

-- Initial Run, has to be outside of LoadOnce in order to automatically scale
ChangeZoomAmount(config.ZoomMod)

ModUtil.LoadOnce(function()
	zanncdwbl_Generalist.origianRoomSet = DeepCopyTable(game.RoomSetData)
end)

-- ========= ImGUI CODE
function DrawZoomMod()
	if config.ZoomMod then
		rom.ImGui.Text("Zoom Amount")
		local value, selected = rom.ImGui.SliderFloat("Default: 0.75", config.ZoomModValue, 0, 2)

		-- This chunk of code is so that its done automatically, no button
		-- if selected then
		-- 	config.ZoomModValue = value
		-- end
		-- ChangeZoomAmount()

		config.ZoomModValue = value

		if rom.ImGui.Button("Apply Zoom") then
			ChangeZoomAmount(config.ZoomMod)
		end
	else
		-- Reset everything
		if prevEnabled then
			game.RoomSetData = DeepCopyTable(zanncdwbl_Generalist.origianRoomSet)
			AdjustZoom({ Fraction = 0.75, LerpTime = 0.02 })
			hasChanged = false
			prevEnabled = false
		end
	end
end
