--!__inline_bundle__
--!__inline_begin__
function loadBundle()local a,b,c,d=(function(e)local f={[{}]=true}local g;local h={}local require;local i={}g=function(j,k)if not h[j]then h[j]=k end end;require=function(j)local l=i[j]if l then if l==f then return nil end else if not h[j]then if not e then local m=type(j)=='string'and'\"'..j..'\"'or tostring(j)error('Tried to require '..m..', but no such module has been registered')else return e(j)end end;i[j]=f;l=h[j](require,i,g,h)i[j]=l end;return l end;return require,i,g,h end)(nil)c("__root",function(require,n,c,d)require("reporter")require("luabundle")require("global")local o=require("githubTrigger")local p=require("reporterTrigger")function mainPostHook()o()p()end;return require end)c("reporterTrigger",function(require,n,c,d)local function q()local r=CreateTrigger()local s=GetPlayableMapRect()local t=GetUnitsInRectOfPlayer(s,Player(1))local u=FirstOfGroup(t)DestroyGroup(t)TriggerRegisterUnitEvent(r,u,EVENT_UNIT_DAMAGED)TriggerAddAction(r,function()print('Oof!')end)return r end;return q end)c("githubTrigger",function(require,n,c,d)local function q()local r=CreateTrigger()TriggerAddAction(r,function()TriggerSleepAction(5.00)local v=require("github")v()TriggerSleepAction(1.00)local w=require("luabundle")w()TriggerSleepAction(1.00)local x=require("luamin")x()end)TriggerExecute(r)return r end;return q end)c("luamin",function(require,n,c,d)local function w()print("Give a star: https://github.com/mathiasbynens/luamin !")end;return w end)c("luabundle",function(require,n,c,d)local function w()print("Give a star: https://github.com/Benjamin-Dobell/luabundle !")end;return w end)c("github",function(require,n,c,d)local function v()print("war3-lua-seed https://github.com/netd777/war3-lua-seed")end;return v end)c("global",function(require,n,c,d)function GlobalHello()print("hello from global context!")end;return end)c("reporter",function(require,n,c,d)local function y()print("Ouch!")end;return y end)return a("__root")end;require=loadBundle()
--!__inline_end__
gg_trg_bundleCheck=nil;gg_trg_require=nil;gg_trg_global=nil;gg_trg_fileNotIncluded=nil;gg_unit_Edem_0004=nil;function InitGlobals()end;function CreateBuildingsForPlayer0()local a=Player(0)local b;local c;local d;local e;b=BlzCreateUnitWithSkin(a,FourCC("etol"),512.0,-1024.0,270.000,FourCC("etol"))end;function CreateUnitsForPlayer0()local a=Player(0)local b;local c;local d;local e;gg_unit_Edem_0004=BlzCreateUnitWithSkin(a,FourCC("Edem"),206.9,-1055.3,356.800,FourCC("Edem"))SetHeroLevel(gg_unit_Edem_0004,10,false)SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEmb"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEmb"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEmb"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEim"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEim"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEim"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEev"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEev"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEev"))SelectHeroSkill(gg_unit_Edem_0004,FourCC("AEme"))end;function CreateBuildingsForPlayer1()local a=Player(1)local b;local c;local d;local e;b=BlzCreateUnitWithSkin(a,FourCC("ogre"),-576.0,576.0,270.000,FourCC("ogre"))end;function CreateUnitsForPlayer1()local a=Player(1)local b;local c;local d;local e;b=BlzCreateUnitWithSkin(a,FourCC("Obla"),-301.6,610.1,320.420,FourCC("Obla"))SetHeroLevel(b,10,false)SelectHeroSkill(b,FourCC("AOmi"))SelectHeroSkill(b,FourCC("AOmi"))SelectHeroSkill(b,FourCC("AOmi"))SelectHeroSkill(b,FourCC("AOcr"))SelectHeroSkill(b,FourCC("AOcr"))SelectHeroSkill(b,FourCC("AOcr"))SelectHeroSkill(b,FourCC("AOww"))end;function CreatePlayerBuildings()CreateBuildingsForPlayer0()CreateBuildingsForPlayer1()end;function CreatePlayerUnits()CreateUnitsForPlayer0()CreateUnitsForPlayer1()end;function CreateAllUnits()CreatePlayerBuildings()CreatePlayerUnits()end;function Trig_bundleCheck_Actions()if loadBundle==nil then print("ERROR: bundle loader not found!")end;if require==nil then print("ERROR: require not found!")end end;function InitTrig_bundleCheck()gg_trg_bundleCheck=CreateTrigger()TriggerAddAction(gg_trg_bundleCheck,Trig_bundleCheck_Actions)end;function Trig_require_Actions()require("reporter")()end;function InitTrig_require()gg_trg_require=CreateTrigger()TriggerRegisterUnitEvent(gg_trg_require,gg_unit_Edem_0004,EVENT_UNIT_DAMAGED)TriggerAddAction(gg_trg_require,Trig_require_Actions)end;function Trig_global_Actions()TriggerSleepAction(3.00)GlobalHello()end;function InitTrig_global()gg_trg_global=CreateTrigger()TriggerAddAction(gg_trg_global,Trig_global_Actions)end;function Trig_fileNotIncluded_Actions()TriggerSleepAction(1.00)if require("treeshaken")~=nil then print("Treeshaken file was included!!!")end end;function InitTrig_fileNotIncluded()gg_trg_fileNotIncluded=CreateTrigger()TriggerAddAction(gg_trg_fileNotIncluded,Trig_fileNotIncluded_Actions)end;function InitCustomTriggers()InitTrig_bundleCheck()InitTrig_require()InitTrig_global()InitTrig_fileNotIncluded()end;function RunInitializationTriggers()ConditionalTriggerExecute(gg_trg_bundleCheck)ConditionalTriggerExecute(gg_trg_global)ConditionalTriggerExecute(gg_trg_fileNotIncluded)end;function InitCustomPlayerSlots()SetPlayerStartLocation(Player(0),0)SetPlayerColor(Player(0),ConvertPlayerColor(0))SetPlayerRacePreference(Player(0),RACE_PREF_HUMAN)SetPlayerRaceSelectable(Player(0),true)SetPlayerController(Player(0),MAP_CONTROL_USER)end;function InitCustomTeams()SetPlayerTeam(Player(0),0)end;function main()SetCameraBounds(-1280.0+GetCameraMargin(CAMERA_MARGIN_LEFT),-1536.0+GetCameraMargin(CAMERA_MARGIN_BOTTOM),1280.0-GetCameraMargin(CAMERA_MARGIN_RIGHT),1024.0-GetCameraMargin(CAMERA_MARGIN_TOP),-1280.0+GetCameraMargin(CAMERA_MARGIN_LEFT),1024.0-GetCameraMargin(CAMERA_MARGIN_TOP),1280.0-GetCameraMargin(CAMERA_MARGIN_RIGHT),-1536.0+GetCameraMargin(CAMERA_MARGIN_BOTTOM))SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl","Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")NewSoundEnvironment("Default")SetAmbientDaySound("LordaeronSummerDay")SetAmbientNightSound("LordaeronSummerNight")SetMapMusic("Music",true,0)CreateAllUnits()InitBlizzard()InitGlobals()InitCustomTriggers()RunInitializationTriggers()end;function config()SetMapName("TRIGSTR_001")SetMapDescription("TRIGSTR_003")SetPlayers(1)SetTeams(1)SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)DefineStartLocation(0,512.0,-1024.0)InitCustomPlayerSlots()SetPlayerSlotAvailable(Player(0),MAP_CONTROL_USER)InitGenericPlayerSlots()end
--!__inline_hooks__
--!__inline_begin__
mapMain=main;main=function()if loadBundle==nil then print("ERROR: bundle loader not found!")end;if require==nil then print("ERROR: require not found!")end;if mainPreHook~=nil then runMapMain=mainPreHook()end;if runMapMain~=false then mapMain()end;if mainPostHook~=nil then mainPostHook()end end;mapConfig=config;config=function()if configPreHook~=nil then runMapConfig=configPreHook()end;if runMapConfig~=false then mapConfig()end;if configPostHook~=nil then configPostHook()end end
--!__inline_end__