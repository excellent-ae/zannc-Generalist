---@meta _
---@diagnostic disable

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

function drawMenu()
	if rom.ImGui.CollapsingHeader("Starting Room Drop Manager") then
		-- boon manager
		local managedBoons = {
			"Aphrodite",
			"Apollo",
			"Artemis",
			"Demeter",
			"Hephaestus",
			"Hera",
			"Hermes",
			"Hestia",
			"Poseidon",
			"Zeus",
			"Hammer",
			"Selene",
		}

		for _, boon in ipairs(managedBoons) do
			value, checked = rom.ImGui.Checkbox(boon, config[boon].Enabled)
			if checked then
				config[boon].Enabled = value
			end
		end
	end

	rom.ImGui.Separator()

	if rom.ImGui.CollapsingHeader("Pom of Power Upgrades") then
		-- pom stuff
		value, selected = rom.ImGui.SliderInt("Levels", config.StackAmount, 1, 20)
		if selected then
			config.StackAmount = value
		end

		value, checked = rom.ImGui.Checkbox("Remove diminishing returns (Poms scale infinitely)", config.RemoveDiminishingReturns)
		if checked then
			config.RemoveDiminishingReturns = value
		end
	end

	rom.ImGui.Separator()

	if rom.ImGui.CollapsingHeader("Max Grasp") then
		-- graspIncrease
		value, selected = rom.ImGui.SliderInt("Grasp", config.MaxGrasp, 10, zanncdwbl_Generalist.maxCardCost)
		if selected then
			config.MaxGrasp = value
		end
	end
end
