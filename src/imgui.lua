---@meta _
---@diagnostic disable

local function drawCollapsingHeader(title, func)
	if rom.ImGui.CollapsingHeader(title) then
		func()
	end
end

local function drawBoonManager()
	for _, boon in ipairs(zanncdwbl_Generalist.upgrades) do
		local value, checked = rom.ImGui.Checkbox(config[boon.custconfig], currentConfig.Enabled)
		if checked then
			config[boon.custconfig].Enabled = value
		end
	end
end

local function drawPomUpgrades()
	local value, selected

	value, selected = rom.ImGui.SliderInt("Level(s)", config.StackAmount, 1, 20)
	if selected then
		config.StackAmount = value
	end

	value, checked = rom.ImGui.Checkbox("Remove diminishing returns (Poms scale infinitely)", config.RemoveDiminishingReturns)
	if checked then
		config.RemoveDiminishingReturns = value
	end
end

local function drawMaxGrasp()
	local value, selected

	value, selected = rom.ImGui.SliderInt("Grasp Amount", config.MaxGrasp, 10, zanncdwbl_Generalist.maxCardCost)
	if selected then
		config.MaxGrasp = value
	end
end

local function drawMenu()
	drawCollapsingHeader("Starting Room Drop Manager", drawBoonManager)
	rom.ImGui.Separator()
	drawCollapsingHeader("Pom of Power Upgrades", drawPomUpgrades)
	rom.ImGui.Separator()
	drawCollapsingHeader("Max Grasp", drawMaxGrasp)
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
