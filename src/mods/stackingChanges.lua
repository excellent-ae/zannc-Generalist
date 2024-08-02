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
			-- Recursively check nested tables
			removeDiminishingReturns(v)
		end
	end
end

if config.StackingMod then
	setStackAmount(config.StackAmount)

	-- Makes it so whatever the default stack upgrade is, it will never be greater than the double/triple poms
	game.LootSetData.Loot.StackUpgrade.StackNum = config.StackAmount
	game.LootSetData.Loot.StackUpgradeBig.StackNum = config.StackAmount + 1
	game.LootSetData.Loot.StackUpgradeTriple.StackNum = config.StackAmount + 2

	modutil.mod.Path.Wrap("CreateStackLoot", function(base, args)
		-- Basically, all this will do is that if this is called, then it will always set stack number to 3
		args = args or {}
		args.StackNum = config.StackAmount
		return base(args)
	end)
end

local hasLoaded = false

local function printtable(tbl, indent)
	if type(tbl) ~= "table" then
		print("bad argument #1 to 'printtable' (table expected, got " .. type(tbl) .. ")")
		return
	end

	indent = indent or 0
	local formatting = string.rep("  ", indent)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			print(formatting .. k .. ":")
			printtable(v, indent + 1)
		else
			print(formatting .. k .. ": " .. tostring(v))
		end
	end
end

modutil.mod.Path.Wrap("SetupMap", function(base)
	if not hasLoaded then
		zanncdwbl_Generalist.orginalTraitData = DeepCopyTable(game.TraitData)
		hasLoaded = true
	end

	if config.StackingMod then
		if config.RemoveDiminishingReturns then
			for key, trait in pairs(game.TraitData) do
				removeDiminishingReturns(trait)
			end

			local traitsToProcess = {}
			for i, currentTraitData in pairs(CurrentRun.Hero.Traits) do
				if currentTraitData.Slot ~= "Familiar" and currentTraitData.Slot ~= "Aspect" and currentTraitData.Slot ~= "Keepsake" then
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
				wait(0.1)
				AddTraitToHero({ TraitData = newTrait, SkipNewTraitHighlight = true, SkipActivatedTraitUpdate = true, SkipSetup = true })
			end
		else
			-- If it's disabled, run this
			game.TraitData = DeepCopyTable(zanncdwbl_Generalist.orginalTraitData)
			for i, currentTraitData in pairs(CurrentRun.Hero.Traits) do
				print(i)

				-- print("Removing Trait" .. currentTraitData.Name)
				-- RemoveTrait(CurrentRun.Hero, currentTraitData.Name, { SkipActivatedTraitUpdate = true })

				-- print("Adding Trait" .. currentTraitData.Name)
				-- AddTraitToHero({ TraitData = currentTraitData, SkipNewTraitHighlight = true, SkipActivatedTraitUpdate = true, SkipSetup = true })
			end
		end
	else
		game.LootSetData.Loot.StackUpgrade.StackNum = 1
		game.LootSetData.Loot.StackUpgradeBig.StackNum = 2
		game.LootSetData.Loot.StackUpgradeTriple.StackNum = 3

		game.TraitData = DeepCopyTable(zanncdwbl_Generalist.orginalTraitData)
	end

	base()
end)

-- ========= ImGUI CODE
function drawPomUpgrades()
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
