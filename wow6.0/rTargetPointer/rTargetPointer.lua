
  -- // rTargetPointer
  -- // zork - 2015
  
  -----------------------------
  -- CONFIG
  -----------------------------
  
  local cfg = {}
  
  cfg.arrowSize       = 256
  cfg.arrowTexture    = "pointer"
  cfg.arrowColor      = {1,0,0,1} -- r,g,b,a
  cfg.arrowBlendMode  = "ADD"     -- "ADD" or "BLEND"

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...

  local WorldFrame, math, string = WorldFrame, math, string
  local hasTarget, lastPoint, namePlateIndex, plates = false, {}, nil, {}
  local onUpdateElapsed, onUpdateInterval = 0, 0.1

  local timer = CreateFrame("Frame")
  local addon = CreateFrame("Frame", nil, UIParent)
  local arrow = addon:CreateTexture(nil,"BACKGROUND",nil,-8)
  local sizer = CreateFrame("Frame", nil, WorldFrame)

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --rTP_RotateArrow func
  local function rTP_RotateArrow()
    local x2,y2 = WorldFrame:GetCenter()
    local x3 = lastPoint.x-x2
    local y3 = lastPoint.y-y2
    local d = math.deg(math.atan(x3/y3))
    --print("x",x3,"y",y3,"@",d)
    if x3 >= 0 and y3 >= 0 then
      d = d*(-1)
    elseif x3 >= 0 and y3 <= 0 then
      d = (-180-d)
    elseif x3 <= 0 and y3 >= 0 then
      d = d*(-1)
    elseif x3 <= 0 and y3 <= 0 then
      d = (180-d)
    end
    arrow:SetRotation(math.rad(d))
  end

  --rTP_SizerOnSizeChanged func
  local function rTP_SizerOnSizeChanged(self, x, y)
    if self:IsShown() then
      lastPoint.x,lastPoint.y = x, y
      rTP_RotateArrow()
    end
  end

  --rTP_NamePlateTargetSearch func
  local function rTP_NamePlateTargetSearch()
    if not namePlateIndex then return end
    sizer:Hide()
    if not hasTarget then return end
    --print("rTP_NamePlateTargetSearch")
    for plate, _ in next, plates do
      if plate:IsShown() and plate:GetAlpha() == 1 then
        sizer:ClearAllPoints()
        sizer:SetPoint("TOPRIGHT", plate, "CENTER")
        sizer:SetPoint("BOTTOMLEFT", WorldFrame)
        lastPoint.x,lastPoint.y = plate:GetCenter()
        rTP_RotateArrow()
        sizer:Show()
        arrow:Show()
        break
      end
    end
  end

  --rTP_NamePlateLookup func
  local function rTP_NamePlateLookup()    
    if not namePlateIndex then return end
    local plate = _G["NamePlate"..namePlateIndex]
    if not plate then return end
    if plates[plate] then return end
    --print("rTP_NamePlateLookup")
    plates[plate] = true
    namePlateIndex = namePlateIndex+1
  end

  --rTP_NamePlateIndexSearch func
  local function rTP_NamePlateIndexSearch()
    if namePlateIndex then return end
    --print("rTP_NamePlateIndexSearch")
    for _, frame in next, { WorldFrame:GetChildren() } do
      local name = frame:GetName()
      if name and string.match(name, "^NamePlate%d+$") then
        namePlateIndex = string.gsub(name,"NamePlate","")
        break
      end
    end
  end

  --rTP_TimerOnUpdate func
  local function rTP_TimerOnUpdate(self,elapsed)
    onUpdateElapsed = onUpdateElapsed+elapsed
    if onUpdateElapsed > onUpdateInterval then
      if not namePlateIndex then rTP_NamePlateIndexSearch() end
      if namePlateIndex then rTP_NamePlateTargetSearch() end
      onUpdateElapsed = 0
    end
    if namePlateIndex then rTP_NamePlateLookup() end
  end

  --rTP_PlayerTargetChanged func
  local function rTP_PlayerTargetChanged(...)
    --print("rTP_PlayerTargetChanged")
    sizer:Hide()
    arrow:Hide()
    if UnitExists("target") and not UnitIsUnit("target","player") and not UnitIsDead("target") then
      hasTarget = true
      timer:Show()
    else
      hasTarget = false
      timer:Hide()
    end
  end

  -----------------------------
  -- INIT
  -----------------------------

  --timer
  timer:SetScript("OnUpdate",rTP_TimerOnUpdate)
  timer:Hide()

  --addon
  addon:RegisterEvent("PLAYER_TARGET_CHANGED")
  addon:SetScript("OnEvent",rTP_PlayerTargetChanged)
  addon:SetSize(32,32)
  addon:SetPoint("CENTER")

  --arrow
  arrow:SetTexture("Interface\\AddOns\\"..an.."\\media\\"..cfg.arrowTexture)
  arrow:SetSize(sqrt(2)*cfg.arrowSize,sqrt(2)*cfg.arrowSize)
  arrow:SetPoint("CENTER")
  arrow:SetVertexColor(unpack(cfg.arrowColor))
  arrow:SetBlendMode(cfg.arrowBlendMode) --"ADD" or "BLEND"
  arrow:SetRotation(math.rad(0))
  arrow:Hide()

  --sizer
  sizer:SetScript("OnSizeChanged", rTP_SizerOnSizeChanged)
  sizer:Hide()

  --debug
  --[[
  local t = sizer:CreateTexture()
  t:SetAllPoints()
  t:SetTexture(1,1,1)
  t:SetVertexColor(0,1,1,0.3)
  ]]