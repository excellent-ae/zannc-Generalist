---@meta _
---@diagnostic disable

local function addSeperatorSpacing()
	rom.ImGui.Spacing()
	rom.ImGui.Spacing()
	rom.ImGui.Separator()
	rom.ImGui.Spacing()
	rom.ImGui.Spacing()
end

local function ImGUICheckbox(label, configKey, func)
	local value, checked = rom.ImGui.Checkbox(label, config[configKey])

	if checked then
		config[configKey] = value
	end

	func()

	addSeperatorSpacing()
end

local function drawMenu()
	ImGUICheckbox("Enable Starting Room Drop Manager", "StartingDropMod", DrawBoonManager)

	ImGUICheckbox("Enable Max Grasp Changes", "GraspCardMod", DrawMaxGrasp)

	ImGUICheckbox("Enable Pom of Power Mod", "StackingMod", DrawPomUpgrades)

	ImGUICheckbox("Enable Hammer to drop more than 2 times per run.", "HammerRateMod", DrawHammerDrops)

	ImGUICheckbox("Enable Consumable Mod", "ConsumableMod", DrawConsumableChanges)

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
