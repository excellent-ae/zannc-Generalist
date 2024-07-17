---@meta _
zanncdwbl_Generalist = zanncdwbl_Generalist or {}

---@diagnostic disable-next-line: undefined-global
local mods = rom.mods

---@diagnostic disable: lowercase-global
---@module 'SGG_Modding-ENVY-auto'
mods["SGG_Modding-ENVY"].auto()

---@diagnostic disable-next-line: undefined-global
rom = rom
---@diagnostic disable-next-line: undefined-global
_PLUGIN = PLUGIN

---@module 'SGG_Modding-Hades2GameDef-Globals'
game = rom.game

---@module 'SGG_Modding-SJSON'
sjson = mods["SGG_Modding-SJSON"]

---@module 'SGG_Modding-ModUtil'
modutil = mods["SGG_Modding-ModUtil"]

---@module 'SGG_Modding-Chalk'
chalk = mods["SGG_Modding-Chalk"]

---@module 'SGG_Modding-ReLoad'
reload = mods["SGG_Modding-ReLoad"]

---@module 'zannc-config-Generalist'
config = chalk.auto("config.lua")
public.config = config

local function on_ready()
	if config.enabled == false then
		return
	end
	import_as_fallback(rom.game)

	import("mods/startingBan.lua")
	import("mods/stackingChanges.lua")
	import("mods/graspIncrease.lua")
	import("sjson.lua")
end

local function on_reload()
	if config.Enabled == false then
		return
	end
	import_as_fallback(rom.game)
	import("imgui.lua")
end

local loader = reload.auto_single()

modutil.once_loaded.game(function()
	loader.load(on_ready, on_reload)
end)
