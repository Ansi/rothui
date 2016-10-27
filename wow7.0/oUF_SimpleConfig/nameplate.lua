
-- oUF_SimpleConfig: nameplate
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- NamePlateCallback
-----------------------------

local function NamePlateCallback(...)
  print(...)
end
--L.C.NamePlateCallback = NamePlateCallback

-----------------------------
-- NamePlateCVars
-----------------------------

local cvars = {}
cvars["nameplateMinScale"] = 1
cvars["nameplateMaxScale"] = 1
cvars["nameplateGlobalScale"] = 1
cvars["nameplateShowFriendlyNPCs"] = 1
L.C.NamePlateCVars = cvars

-----------------------------
-- NamePlateConfig
-----------------------------

--custom filter for nameplate debuffs
--local function CustomFilter(icons, unit, icon, name, rank, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll)
local function CustomFilter(...)
  local _, _, _, name, _, _, _, _, _, _, caster, _, nameplateShowPersonal, _, _, _, _, nameplateShowAll = ...
  --print(name,caster,nameplateShowPersonal,nameplateShowAll)
  --return nameplateShowAll or (nameplateShowPersonal and (caster == "player" or caster == "pet" or caster == "vehicle"))
  return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end

L.C.nameplate = {
  enabled = true,
  size = {130,26},
  point = {"CENTER"}, --relative to the nameplate base!
  scale = 1*UIParent:GetScale()*L.C.globalscale,--nameplates are not part of uiparent, they must be multiplied by uiparent scale!
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorTapping = true,
    colorReaction = true,
    colorClass = true,
    colorHealth = true,
    colorThreat = true,
    colorThreatInvers = true,
    frequentUpdates = true,
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 16,
      align = "CENTER",
      tag = "[difficulty][name]|r",
    },
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,0},
  },
  --castbar
  castbar = {
    enabled = true,
    size = {130,26},
    point = {"TOP","BOTTOM",0,-5},
    name = {
      enabled = true,
      points = {
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 16,
    },
    icon = {
      enabled = true,
      size = {26,26},
      point = {"RIGHT","LEFT",-6,0},
    },
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"BOTTOMLEFT","TOPLEFT",0,5},
    num = 5,
    cols = 5,
    size = 22,
    spacing = 5,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "UP",
    disableCooldown = true,
    filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY",
    CustomFilter = CustomFilter
  },
}