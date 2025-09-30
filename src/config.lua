---@meta zannc-config-Generalist
return {
	-- Set all Mods to false, but give people the option to enable/disable
	StartingDropMod = false,
	StackingMod = false,
	GraspCardMod = false,
	HammerRateMod = false,
	ConsumableMod = false,
	ZoomMod = false,

	-- Start Boon Manager
	Hammer = { Enabled = true },
    Selene = { Enabled = true },
    Chaos = { Enabled = true },

	Zeus = { Enabled = true },
	Hera = { Enabled = true },
	Hestia = { Enabled = true },
	Aphrodite = { Enabled = true },
	Poseidon = { Enabled = true },
	Hephaestus = { Enabled = true },
	Artemis = { Enabled = true },
	Hermes = { Enabled = true },
	Apollo = { Enabled = true },
    Demeter = { Enabled = true },
    Ares = { Enabled = true },

	-- Stacking Upgrades
	StackAmount = 1,
	RemoveDiminishingReturns = false,

	-- Max Grasp
	MaxGrasp = 30,

	-- [[ Hammer Amount to add, note there are already 2 hammer spawns, one is once per 2 biome clears
	-- and 1 which removes itself after the first spawn ]]
	HammerAmountUnderWorld = 2,
	HammerAmountSurface = 2,

	-- Consumables
	AshAmount = 5,
	PsycheAmount = 10,
	BonesAmount = 50,

	--Zoom Value
	ZoomModValue = 0.80,
}
