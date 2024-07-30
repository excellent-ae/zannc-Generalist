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

	value, checked = rom.ImGui.Checkbox("Enable Starting Room Drop Manager", config.StartingDropMod)
	if checked then
		config.StartingDropMod = value
	end
	if config.StartingDropMod and rom.ImGui.CollapsingHeader("Starting Room Drop Manager") then
		drawBoonManager()
	end

	addSeperatorSpacing()

	value, checked = rom.ImGui.Checkbox("Enable Pom of Power Changes/Mod", config.StackingMod)
	if checked then
		config.StackingMod = value
	end
	if config.StackingMod then
		drawPomUpgrades()
	end

	addSeperatorSpacing()

	value, checked = rom.ImGui.Checkbox("Enable Max Grasp Changes", config.GraspCardMod)
	if checked then
		config.GraspCardMod = value
	end
	if config.GraspCardMod then
		drawMaxGrasp()
	end

	addSeperatorSpacing()

	value, checked = rom.ImGui.Checkbox("Enable Hammer to drop more than 2 times per run.", config.HammerRateMod)
	if checked then
		config.HammerRateMod = value
		EnableDisableHammerRunDrops()
	end
	if config.HammerRateMod then
		drawHammerDrops()
	end

	addSeperatorSpacing()

	-- Draw Consumables
	DrawConsumableChanges()

	addSeperatorSpacing()

	-- Draw Zoom
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
