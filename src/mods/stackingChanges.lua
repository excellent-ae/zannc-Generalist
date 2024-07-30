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
-- ========= END

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
				v.AbsoluteStackValues = nil
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

modutil.mod.Path.Wrap("SetupMap", function(base)
	if not hasLoaded then
		zanncdwbl_Generalist.orginalTraitData = DeepCopyTable(game.TraitData)
		hasLoaded = true
	end

	if config.StackingMod then
		if config.RemoveDiminishingReturns then
			for _, trait in pairs(game.TraitData) do
				removeDiminishingReturns(trait)
			end
		else
			-- If it's disabled, run this
			game.TraitData = DeepCopyTable(zanncdwbl_Generalist.orginalTraitData)
		end
	else
		game.LootSetData.Loot.StackUpgrade.StackNum = 1
		game.LootSetData.Loot.StackUpgradeBig.StackNum = 2
		game.LootSetData.Loot.StackUpgradeTriple.StackNum = 3

		game.TraitData = DeepCopyTable(zanncdwbl_Generalist.orginalTraitData)
	end

	base()
end)
