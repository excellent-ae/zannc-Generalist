---@meta _
---@diagnostic disable

local function add2Spacing()
	rom.ImGui.Spacing()
	rom.ImGui.Spacing()
end

local function drawBoonManager()
	for _, boon in ipairs(zanncdwbl_Generalist.upgrades) do
		local value, checked = rom.ImGui.Checkbox(boon.custconfig, config[boon.custconfig].Enabled)
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
	local value, selected = rom.ImGui.SliderInt("Grasp Amount", config.MaxGrasp, 10, zanncdwbl_Generalist.maxCardCost)
	if selected then
		config.MaxGrasp = value
	end
end

local function drawHammerDrops()
	rom.ImGui.Text("NOTE, 4 = Chance of 4 Hammers per Biome.\nAs opposed to the default of 1 per 2 biomes")

	local underworldValue, underworldSelected = rom.ImGui.SliderInt("Underworld Drop Amount", config.HammerAmountUnderWorld, 1, 4)
	if underworldSelected then
		config.HammerAmountUnderWorld = underworldValue
	end

	local surfaceValue, surfaceSelected = rom.ImGui.SliderInt("Surface Drop Amount", config.HammerAmountSurface, 1, 4)
	if surfaceSelected then
		config.HammerAmountSurface = surfaceValue
	end
end

local function drawConsumableChanges()
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

local function drawMenu()
	local value, checked

	value, checked = rom.ImGui.Checkbox("Enable Starting Room Drop Manager", config.StartingDropMod)
	if checked then
		config.StartingDropMod = value
	end
	if config.StartingDropMod and rom.ImGui.CollapsingHeader("Starting Room Drop Manager") then
		drawBoonManager()
	end

	add2Spacing()
	rom.ImGui.Separator()
	add2Spacing()

	value, checked = rom.ImGui.Checkbox("Enable Pom of Power Changes/Mod", config.StackingMod)
	if checked then
		config.StackingMod = value
	end
	if config.StackingMod then
		drawPomUpgrades()
	end

	add2Spacing()
	rom.ImGui.Separator()
	add2Spacing()

	value, checked = rom.ImGui.Checkbox("Enable Max Grasp Changes", config.GraspCardMod)
	if checked then
		config.GraspCardMod = value
	end
	if config.GraspCardMod then
		drawMaxGrasp()
	end

	add2Spacing()
	rom.ImGui.Separator()
	add2Spacing()

	value, checked = rom.ImGui.Checkbox("Enable Hammer to drop more than 2 times per run.", config.HammerRateMod)
	if checked then
		config.HammerRateMod = value
		EnableDisableHammerRunDrops()
	end
	if config.HammerRateMod then
		drawHammerDrops()
	end

	add2Spacing()
	rom.ImGui.Separator()
	add2Spacing()

	value, checked = rom.ImGui.Checkbox("Enable Consumable Gain Changes", config.ConsumableMod)
	if checked then
		config.ConsumableMod = value
	end
	if config.ConsumableMod then
		drawConsumableChanges()
	end
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
