--__inline_bundle__
--__inline_begin__
function loadBundle()
        -- Bundled by luabundle {"version":"1.6.0"}
    local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
    	local loadingPlaceholder = {[{}] = true}
    

    	local register
    	local modules = {}
    

    	local require
    	local loaded = {}
    

    	register = function(name, body)
    		if not modules[name] then
    			modules[name] = body
    		end
    	end
    

    	require = function(name)
    		local loadedModule = loaded[name]
    

    		if loadedModule then
    			if loadedModule == loadingPlaceholder then
    				return nil
    			end
    		else
    			if not modules[name] then
    				if not superRequire then
    					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
    					error('Tried to require ' .. identifier .. ', but no such module has been registered')
    				else
    					return superRequire(name)
    				end
    			end
    

    			loaded[name] = loadingPlaceholder
    			loadedModule = modules[name](require, loaded, register, modules)
    			loaded[name] = loadedModule
    		end
    

    		return loadedModule
    	end
    

    	return require, loaded, register, modules
    end)(nil)
    __bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
    -- ? modules not required in main or any file required by main (__root module or submodules) are not included in the bundle
    require("reporter");
    require("luabundle");
    require("global");
    local githubTrigger = require("githubTrigger");
    

    -- function mainPreHook()
    -- end
    function mainPostHook()
      githubTrigger()
    end
    

    -- function configPreHook()
    -- end
    -- function configPostHook()
    -- end
    

    -- ? if you don't return require, it won't be acessible outside bundle
    return require
    

    end)
    __bundle_register("githubTrigger", function(require, _LOADED, __bundle_register, __bundle_modules)
    local function registerTrigger()
      local trigger = CreateTrigger()
      TriggerAddAction(trigger, function()
        TriggerSleepAction(5.00)
        local github = require("github")
        github()
        TriggerSleepAction(1.00)
        local luabundle = require("luabundle")
        luabundle()
      end)
      ConditionalTriggerExecute(trigger)
      return trigger
    end
    

    return registerTrigger
    

    end)
    __bundle_register("luabundle", function(require, _LOADED, __bundle_register, __bundle_modules)
    local function luabundle()
      print("Give a star: https://github.com/Benjamin-Dobell/luabundle !")
    end
    

    return luabundle
    end)
    __bundle_register("github", function(require, _LOADED, __bundle_register, __bundle_modules)
    local function github()
      print("war3-lua-seed https://github.com/netd777/war3-lua-seed")
    end
    

    return github
    end)
    __bundle_register("global", function(require, _LOADED, __bundle_register, __bundle_modules)
    function GlobalHello()
      print("hello from global context!")
    end
    

    return
    end)
    __bundle_register("reporter", function(require, _LOADED, __bundle_register, __bundle_modules)
    local function reporter()
      print("Ouch! That really hurts!")
    end
    

    return reporter
    end)
    return __bundle_require("__root")
      end
      require = loadBundle()
--__inline_end__
gg_trg_bundleCheck = nil
gg_trg_require = nil
gg_trg_global = nil
gg_trg_fileNotIncluded = nil
gg_unit_Edem_0004 = nil
function InitGlobals()
end

function CreateBuildingsForPlayer0()
    local p = Player(0)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("etol"), 512.0, -1024.0, 270.000, FourCC("etol"))
end

function CreateUnitsForPlayer0()
    local p = Player(0)
    local u
    local unitID
    local t
    local life
    gg_unit_Edem_0004 = BlzCreateUnitWithSkin(p, FourCC("Edem"), 206.9, -1055.3, 356.800, FourCC("Edem"))
    SetHeroLevel(gg_unit_Edem_0004, 10, false)
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEmb"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEmb"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEmb"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEim"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEim"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEim"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEev"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEev"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEev"))
    SelectHeroSkill(gg_unit_Edem_0004, FourCC("AEme"))
end

function CreateBuildingsForPlayer1()
    local p = Player(1)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("ogre"), -576.0, 576.0, 270.000, FourCC("ogre"))
end

function CreateUnitsForPlayer1()
    local p = Player(1)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("Obla"), -301.6, 610.1, 320.420, FourCC("Obla"))
    SetHeroLevel(u, 10, false)
    SelectHeroSkill(u, FourCC("AOmi"))
    SelectHeroSkill(u, FourCC("AOmi"))
    SelectHeroSkill(u, FourCC("AOmi"))
    SelectHeroSkill(u, FourCC("AOcr"))
    SelectHeroSkill(u, FourCC("AOcr"))
    SelectHeroSkill(u, FourCC("AOcr"))
    SelectHeroSkill(u, FourCC("AOww"))
end

function CreatePlayerBuildings()
    CreateBuildingsForPlayer0()
    CreateBuildingsForPlayer1()
end

function CreatePlayerUnits()
    CreateUnitsForPlayer0()
    CreateUnitsForPlayer1()
end

function CreateAllUnits()
    CreatePlayerBuildings()
    CreatePlayerUnits()
end

function Trig_bundleCheck_Actions()
        if (loadBundle == nil) then print("ERROR: bundle loader not found!") end
        if (require == nil) then print("ERROR: require not found!") end
end

function InitTrig_bundleCheck()
    gg_trg_bundleCheck = CreateTrigger()
    TriggerAddAction(gg_trg_bundleCheck, Trig_bundleCheck_Actions)
end

function Trig_require_Actions()
        require("reporter")()
end

function InitTrig_require()
    gg_trg_require = CreateTrigger()
    TriggerRegisterUnitEvent(gg_trg_require, gg_unit_Edem_0004, EVENT_UNIT_DAMAGED)
    TriggerAddAction(gg_trg_require, Trig_require_Actions)
end

function Trig_global_Actions()
    TriggerSleepAction(3.00)
        GlobalHello()
end

function InitTrig_global()
    gg_trg_global = CreateTrigger()
    TriggerAddAction(gg_trg_global, Trig_global_Actions)
end

function Trig_fileNotIncluded_Actions()
    TriggerSleepAction(1.00)
        if (require("treeshaken") ~= nil) then print("Treeshaken file was included!!!") end
end

function InitTrig_fileNotIncluded()
    gg_trg_fileNotIncluded = CreateTrigger()
    TriggerAddAction(gg_trg_fileNotIncluded, Trig_fileNotIncluded_Actions)
end

function InitCustomTriggers()
    InitTrig_bundleCheck()
    InitTrig_require()
    InitTrig_global()
    InitTrig_fileNotIncluded()
end

function RunInitializationTriggers()
    ConditionalTriggerExecute(gg_trg_bundleCheck)
    ConditionalTriggerExecute(gg_trg_global)
    ConditionalTriggerExecute(gg_trg_fileNotIncluded)
end

function InitCustomPlayerSlots()
    SetPlayerStartLocation(Player(0), 0)
    SetPlayerColor(Player(0), ConvertPlayerColor(0))
    SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    SetPlayerRaceSelectable(Player(0), true)
    SetPlayerController(Player(0), MAP_CONTROL_USER)
end

function InitCustomTeams()
    SetPlayerTeam(Player(0), 0)
end

function main()
    SetCameraBounds(-1280.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -1536.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 1280.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 1024.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -1280.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 1024.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 1280.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -1536.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    NewSoundEnvironment("Default")
    SetAmbientDaySound("LordaeronSummerDay")
    SetAmbientNightSound("LordaeronSummerNight")
    SetMapMusic("Music", true, 0)
    CreateAllUnits()
    InitBlizzard()
    InitGlobals()
    InitCustomTriggers()
    RunInitializationTriggers()
end

function config()
    SetMapName("TRIGSTR_001")
    SetMapDescription("TRIGSTR_003")
    SetPlayers(1)
    SetTeams(1)
    SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
    DefineStartLocation(0, 512.0, -1024.0)
    InitCustomPlayerSlots()
    SetPlayerSlotAvailable(Player(0), MAP_CONTROL_USER)
    InitGenericPlayerSlots()
end

