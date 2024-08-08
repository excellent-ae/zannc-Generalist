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
	local value, checked

	-- Draw Starting Boon Mod
	ImGUICheckbox("Enable Starting Room Drop Manager", "StartingDropMod", DrawBoonManager)

	-- Draw Pom Mod
	ImGUICheckbox("Enable Pom of Power Mod", "StackingMod", DrawPomUpgrades)

	-- Draw Max Grasp Mod
	ImGUICheckbox("Enable Max Grasp Changes", "GraspCardMod", DrawMaxGrasp)

	ImGUICheckbox("Enable Hammer to drop more than 2 times per run.", "HammerRateMod", DrawHammerDrops)

	-- Draw Consumables Mod
	ImGUICheckbox("Enable Consumable Mod", "ConsumableMod", DrawConsumableChanges)

	-- Draw Zoom Mod
	ImGUICheckbox("Enable Zoom Mod", "ZoomMod", DrawZoomMod)
end

-- standalone
rom.gui.add_imgui(function()
	if rom.ImGui.Begin("Generalist") then
		drawMenu()
		rom.ImGui.End()
	end
end)

-- dropdown
rom.gui.add_to_menu_bar(function()
	if rom.ImGui.BeginMenu("Configure") then
		drawMenu()
		rom.ImGui.EndMenu()
	end
end)
