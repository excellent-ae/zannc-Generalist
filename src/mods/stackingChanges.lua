local prevEnabledStacking = false
local prevEnabledDiminishing = false
local previousStackAmount = config.StackAmount
local previousDiminishing = config.RemoveDiminishingReturns

local function setStackAmount(value)
	-- In case the user is dumb and sets stack amount to 0
	if value < 1 then
		config.StackAmount = 1
		print("Pom Level Increase is less than 1.... why... setting default to 1")
	end
end

local function removeDiminishingReturns(tbl)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			if v.IdenticalMultiplier then
				v.IdenticalMultiplier = nil
			end

			if v.AbsoluteStackValues then
				for key in pairs(v.AbsoluteStackValues) do
					if key ~= 1 then
						v.AbsoluteStackValues[key] = nil
					end
				end
			end
			removeDiminishingReturns(v)
		end
	end
end

local function RemoveAddTraits()
	local traitsToProcess = {}
	for i, currentTraitData in pairs(CurrentRun.Hero.Traits) do
		if currentTraitData.Slot ~= "Familiar" and currentTraitData.Slot ~= "Aspect" and currentTraitData.Slot ~= "Keepsake" and currentTraitData.Name ~= "RoomRewardMaxManaTrait" and currentTraitData.Name ~= "RoomRewardMaxHealthTrait" then
			table.insert(traitsToProcess, currentTraitData)
		end
	end

	for i, currentTraitData in ipairs(traitsToProcess) do
		local persistentValues = {}
		for i, key in pairs(PersistentTraitKeys) do
			persistentValues[key] = currentTraitData[key]
		end

		local newTrait = GetProcessedTraitData({ Unit = game.CurrentRun.Hero, TraitName = currentTraitData.Name, StackNum = currentTraitData.StackNum, Rarity = currentTraitData.Rarity })
		newTrait.RarityMultiplier = currentTraitData.RarityMultiplier
		for i, key in pairs(PersistentTraitKeys) do
			newTrait[key] = persistentValues[key]
		end

		RemoveTrait(game.CurrentRun.Hero, currentTraitData.Name, { SkipActivatedTraitUpdate = true })
		-- wait(0.01) -- kinda have to do this or else it just glitches out for some reason
		AddTraitToHero({ TraitData = newTrait, SkipNewTraitHighlight = true, SkipActivatedTraitUpdate = true, SkipSetup = true })
	end
end

local function ApplyStackingMod(stacking, diminishing)
	if not stacking then
		return
	end

	if not prevEnabledStacking or config.StackAmount ~= previousStackAmount then
		prevEnabledStacking = true
		previousStackAmount = config.StackAmount

		setStackAmount(config.StackAmount)

		-- Makes it so whatever the default stack upgrade is, it will never be greater than the double/triple poms
		game.LootSetData.Loot.StackUpgrade.StackNum = config.StackAmount
		game.LootSetData.Loot.StackUpgradeBig.StackNum = config.StackAmount + 1
		game.LootSetData.Loot.StackUpgradeTriple.StackNum = config.StackAmount + 2
	end

	-- Diminishing Returns stuff
	if diminishing then
		if not prevEnabledDiminishing or config.RemoveDiminishingReturns ~= previousDiminishing then
			prevEnabledDiminishing = true
			previousDiminishing = config.RemoveDiminishingReturns

			for key, trait in pairs(game.TraitData) do
				removeDiminishingReturns(trait)
			end
			RemoveAddTraits()
		end
	else
		if not prevEnabledDiminishing then
			return
		end

		prevEnabledDiminishing = false

		game.TraitData = DeepCopyTable(zanncdwbl_Generalist.orginalTraitData)
		RemoveAddTraits()
	end
end

ModUtil.LoadOnce(function()
	zanncdwbl_Generalist.orginalTraitData = DeepCopyTable(game.TraitData) -- Doesn't need hasLoaded check i did before, this loads after all mods
	-- Initial Run
	ApplyStackingMod(config.StackingMod, config.RemoveDiminishingReturns)
end)

modutil.mod.Path.Wrap("CreateStackLoot", function(base, args)
	if config.StackingMod then
		-- Basically, all this will do is that if this is called, then it will always set stack number to config amount
		args = args or {}
		args.StackNum = config.StackAmount
		return base(args)
	else
		return base(args)
	end
end)

-- ! ImGUI CODE
function DrawPomUpgrades()
	if config.StackingMod then
		rom.ImGui.Text("Pom Level Amount")

		local value, selected = rom.ImGui.SliderInt("Level(s)", config.StackAmount, 1, 20)
		if selected then
			config.StackAmount = value
		end

		local value, selected = rom.ImGui.Checkbox("Remove diminishing returns (Poms scale infinitely)", config.RemoveDiminishingReturns)
		if selected then
			config.RemoveDiminishingReturns = value
		end

		rom.ImGui.Spacing()
		rom.ImGui.TextWrapped("If there are any boons that are scaling incorrectly please submit a bug report.")
		-- Aphrodite
		--     Shameless Attitude
		--     Healthy Rebound
		-- Demeter
		--     Snow Queen
		-- Hestia
		--     Cardio Gain
		--     Hot Pot
		--     Snuffed Candle
		-- Hera
		--     Uncommon Grace

		-- Make sure its called only when it needs to be
		if config.StackAmount ~= previousStackAmount or config.RemoveDiminishingReturns ~= previousDiminishing then
			ApplyStackingMod(config.StackingMod, config.RemoveDiminishingReturns)
		end
	else
		if not prevEnabledStacking then
			return
		end

		prevEnabledStacking = false
		game.LootSetData.Loot.StackUpgrade.StackNum = 1
		game.LootSetData.Loot.StackUpgradeBig.StackNum = 2
		game.LootSetData.Loot.StackUpgradeTriple.StackNum = 3
	end
end
