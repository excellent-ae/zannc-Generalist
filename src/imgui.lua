---@meta _
---@diagnostic disable

local function addSeperatorSpacing()
	rom.ImGui.Spacing()
	rom.ImGui.Spacing()
	rom.ImGui.Separator()
	rom.ImGui.Spacing()
	rom.ImGui.Spacing()
end

local function ImGUICheckbox(label, configKey, func, spacing)
	local value, checked = rom.ImGui.Checkbox(label, config[configKey])

	if checked then
		config[configKey] = value
	end

	func()

	if spacing == true then
		addSeperatorSpacing()
	end
end

local function drawMenu()
	ImGUICheckbox("Enable Starting Room Drop Manager", "StartingDropMod", DrawBoonManager, true)

	ImGUICheckbox("Enable Max Grasp Changes", "GraspCardMod", DrawMaxGrasp, false)

	rom.ImGui.Spacing()

	local value, selected = rom.ImGui.Checkbox("Disable 'Untapped Potential' when you can select more cards.", config.DisableGraspCheck)
	if selected then
		config.DisableGraspCheck = value
	end

	addSeperatorSpacing()

	ImGUICheckbox("Enable Pom of Power Mod", "StackingMod", DrawPomUpgrades, true)

	ImGUICheckbox("Enable Hammer to drop more than 2 times per run.", "HammerRateMod", DrawHammerDrops, true)

	ImGUICheckbox("Enable Consumable Mod", "ConsumableMod", DrawConsumableChanges, true)

	ImGUICheckbox("Enable Zoom Mod", "ZoomMod", DrawZoomMod)
end

rom.gui.add_imgui(function()
	if rom.ImGui.Begin("Generalist") then
		drawMenu()
		rom.ImGui.End()
	end
end)

rom.gui.add_to_menu_bar(function()
	if rom.ImGui.BeginMenu("Configure") then
		drawMenu()
		rom.ImGui.EndMenu()
	end
end)
