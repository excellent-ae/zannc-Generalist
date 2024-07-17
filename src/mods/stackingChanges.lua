local function setStackAmount(value)
	-- In case the user is dumb and sets stack amount to 0
	if value < 1 then
		config.StackAmount = 1
		print("Pom Level Increase is less than 1.... why... setting default to 1")
	end
end
setStackAmount(config.StackAmount)

-- Makes it so whatever the default stack upgrade is, it will never be greater than the double/triple poms
game.LootSetData.Loot.StackUpgrade.StackNum = config.StackAmount
game.LootSetData.Loot.StackUpgradeBig.StackNum = config.StackAmount + 1
game.LootSetData.Loot.StackUpgradeTriple.StackNum = config.StackAmount + 2

modutil.mod.Path.Wrap("CreateStackLoot", function(base, args)
	-- Basically all this will do is that if this is called then it will always set stack number to 3
	args = args or {}
	args.StackNum = config.StackAmount
	return base(args)
	-- Default Function
	-- 	args = args or {}
	-- 	if args.StackNum == nil then
	-- 		args.StackNum = 1
	-- 	end
	-- 	return CreateLoot(MergeTables(args, { Name = "StackUpgrade" }))
end)

--pray chatgpt
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

modutil.mod.Path.Wrap("SetupMap", function(base)
	--Doing this here so it can catch any boons added by other mods
	--Add Options to remove all Stacking Negatives, just iterate over loot data and check if there is ever a mention of like IdenticalMultiplier or StackingMultiplier and set it to nil
	if config.RemoveDiminishingReturns then
		for _, trait in pairs(game.TraitData) do
			removeDiminishingReturns(trait)
		end
	end

	base()
end)
