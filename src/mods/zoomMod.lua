ModUtil.LoadOnce(function()
	zanncdwbl_Generalist.origianRoomSet = DeepCopyTable(game.RoomSetData)
end)

local previousZoomModValue = config.ZoomModValue
local hasChanged = false
local prevEnabled = false

local function roomZoomFraction()
	for _, roomSetData in pairs(game.RoomSetData) do
		for _, roomData in pairs(roomSetData) do
			roomData.ZoomFraction = config.ZoomModValue
		end
	end

	game.HubRoomData.Hub_Main.ZoomFraction = config.ZoomModValue -- 1.23
	game.HubRoomData.Hub_PreRun.ZoomFraction = config.ZoomModValue -- 0.95
end

-- doing a slider may or may not lag people heavily.
local function ChangeZoomAmount(zoom)
	if not zoom then
		return
	end

	for name, weapon in pairs(game.WeaponData) do
		if weapon.FireCameraMotion then
			weapon.FireCameraMotion.fromWeapon = true
		end
		if weapon.ChargeCameraMotion then
			weapon.ChargeCameraMotion.fromWeapon = true
		end
		if weapon.ChargeCancelCameraMotion then
			weapon.ChargeCancelCameraMotion.fromWeapon = true
		end
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

modutil.mod.Path.Wrap("DoCameraMotion", function(base, cameraData)
	if not config.ZoomMod then
		return base(cameraData)
	end

	if cameraData and cameraData.fromWeapon then
		print("Early return - Weapon camera motion")
		return
	end

	return base(cameraData)
end)

local function resetZoom()
	game.RoomSetData = DeepCopyTable(zanncdwbl_Generalist.origianRoomSet)
	game.HubRoomData.Hub_Main.ZoomFraction = config.ZoomModValue -- 1.23
	game.HubRoomData.Hub_PreRun.ZoomFraction = config.ZoomModValue -- 0.95

	AdjustZoom({ Fraction = 0.75, LerpTime = 0.1 })
	hasChanged = false
	prevEnabled = false
end

-- ! ImGUI CODE
function DrawZoomMod()
	if config.ZoomMod then
		rom.ImGui.Text("Zoom Amount")
		local value, selected = rom.ImGui.SliderFloat("Mod Default: 0.80", config.ZoomModValue, 0, 2)

		-- This chunk of code is so that its done automatically, no button
		-- if selected then
		-- 	config.ZoomModValue = value
		-- end
		-- ChangeZoomAmount()

		config.ZoomModValue = value

		if rom.ImGui.Button("Apply Zoom") then
			ChangeZoomAmount(config.ZoomMod)
		end

		rom.ImGui.SameLine()

		if rom.ImGui.Button("Reset Zoom") then
			resetZoom()
		end
	else
		if prevEnabled then
			resetZoom()
		end
	end
end
