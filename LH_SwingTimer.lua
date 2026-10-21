local addonName = ...
local Addon = {}
LH_SwingTimer = Addon
local driver = CreateFrame("Frame")
local bar, orange, startMarker, endMarker, remainingText, started, duration, activeType
local layoutElapsed = 0

local function Options()
    LH_SwingTimerDB = type(LH_SwingTimerDB) == "table" and LH_SwingTimerDB or {}
    for _, key in ipairs({"enabled", "mainHand", "ranged"}) do
        if type(LH_SwingTimerDB[key]) ~= "boolean" then LH_SwingTimerDB[key] = true end
    end
    return LH_SwingTimerDB
end
function Addon:GetOption(key) return Options()[key] end

local function Readable(value)
    return not (issecretvalue and issecretvalue(value))
        and not (canaccessvalue and not canaccessvalue(value))
end

local function CastBar()
    return PlayerCastingBarFrame or CastingBarFrame
end

local function Layout()
    local anchor = CastBar()
    if not anchor then return false end
    if not bar then
        -- UIParent keeps the timer visible when the cast bar itself is hidden.
        bar = CreateFrame("StatusBar", "LH_SwingTimerBar", UIParent)
        bar:Hide()
        bar:EnableMouse(false)
        bar:SetFrameStrata("HIGH")
        bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
        bar:SetStatusBarColor(1, 0.78, 0.15, 1)
        bar:SetOrientation("HORIZONTAL")
        bar:SetReverseFill(false)
        bar:SetMinMaxValues(0, 1)

        orange = CreateFrame("StatusBar", nil, bar)
        orange:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
        orange:SetStatusBarColor(1, 0.38, 0.04, 1)
        orange:SetOrientation("HORIZONTAL")
        orange:SetReverseFill(false)
        orange:SetMinMaxValues(0, 1)
        orange:SetFrameLevel(bar:GetFrameLevel() + 1)

        startMarker = bar:CreateTexture(nil, "OVERLAY")
        startMarker:SetColorTexture(1, 0.38, 0.04, 1)

        endMarker = bar:CreateTexture(nil, "OVERLAY")
        endMarker:SetColorTexture(1, 0.78, 0.15, 1)
        endMarker:SetPoint("CENTER", bar, "RIGHT", 0, 0)

        remainingText = bar:CreateFontString(nil, "OVERLAY")
        remainingText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        remainingText:SetTextColor(1, 1, 1, 1)
        remainingText:SetPoint("LEFT", endMarker, "RIGHT", 4, 0)
        remainingText:SetJustifyH("LEFT")
    end
    -- Two physical pixels, independent of the cast bar's own scale.
    bar:SetHeight(2 / bar:GetEffectiveScale())
    startMarker:SetSize(1 / bar:GetEffectiveScale(), 8 / bar:GetEffectiveScale())
    endMarker:SetSize(1 / bar:GetEffectiveScale(), 8 / bar:GetEffectiveScale())
    bar:ClearAllPoints()
    bar:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)
    bar:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -2)
    if duration and activeType == Enum.PlayerSwingType.Ranged then
        local cutoff = math.max(0, 1 - 0.5 / duration)
        local x = bar:GetWidth() * cutoff
        startMarker:ClearAllPoints()
        startMarker:SetPoint("CENTER", bar, "LEFT", x, 0)
        orange:ClearAllPoints()
        orange:SetPoint("TOPLEFT", bar, "TOPLEFT", x, 0)
        orange:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
        orange:SetMinMaxValues(0, 1)
        orange:SetValue(0)
        orange:Show()
        startMarker:Show()
    else
        orange:Hide()
        startMarker:Hide()
    end
    return true
end

local function Stop()
    started, duration, activeType = nil, nil, nil
    driver:SetScript("OnUpdate", nil)
    if bar then bar:Hide() end
end

function Addon:SetOption(key, value)
    if key ~= "enabled" and key ~= "mainHand" and key ~= "ranged" then return end
    Options()[key] = not not value
    local swingTypes = Enum and Enum.PlayerSwingType
    if not Options().enabled or (swingTypes and activeType == swingTypes.MainHand and not Options().mainHand)
        or (swingTypes and activeType == swingTypes.Ranged and not Options().ranged) then Stop() end
    if self.RefreshSettings then self:RefreshSettings() end
end

local function Update(_, elapsed)
    local progress = (GetTime() - started) / duration
    if progress >= 1 then
        Stop()
        return
    end
    layoutElapsed = layoutElapsed + elapsed
    if layoutElapsed >= 0.25 then
        layoutElapsed = 0
        Layout()
    end
    if activeType == Enum.PlayerSwingType.Ranged then
        local cutoff = math.max(0, 1 - 0.5 / duration)
        bar:SetValue(math.max(0, math.min(progress, cutoff)))
        orange:SetValue(math.max(0, math.min(1, (progress - cutoff) / (1 - cutoff))))
    else
        bar:SetValue(math.max(0, progress))
    end
    remainingText:SetFormattedText("%.1f", math.max(0, duration * (1 - progress)))
end

driver:SetScript("OnEvent", function(_, event, swingDuration, swingType)
    if event == "PLAYER_SWING" then
        if not Readable(swingType) then return end
        if swingType ~= Enum.PlayerSwingType.MainHand
            and swingType ~= Enum.PlayerSwingType.Ranged then return end
        local options = Options()
        if not options.enabled or (swingType == Enum.PlayerSwingType.MainHand and not options.mainHand)
            or (swingType == Enum.PlayerSwingType.Ranged and not options.ranged) then return end
        if not Readable(swingDuration) or type(swingDuration) ~= "number" or swingDuration <= 0 then
            Stop()
            return
        end
        started, duration = GetTime(), swingDuration
        activeType = swingType
        if not Layout() then Stop(); return end
        layoutElapsed = 0
        bar:SetValue(0)
        orange:SetValue(0)
        remainingText:SetFormattedText("%.1f", duration)
        bar:Show()
        driver:SetScript("OnUpdate", Update)
    elseif event == "ADDON_LOADED" then
        if swingDuration == addonName then Options() end
    elseif event == "WEAPON_SLOT_CHANGED" then
        -- Do not carry the previous weapon's swing across an equipment change.
        Stop()
    else
        Stop()
        Layout()
    end
end)

driver:RegisterEvent("PLAYER_ENTERING_WORLD")
driver:RegisterEvent("PLAYER_LEAVING_WORLD")
driver:RegisterEvent("UI_SCALE_CHANGED")
driver:RegisterEvent("ADDON_LOADED")
if C_SwingTimer and Enum and Enum.PlayerSwingType then
    driver:RegisterEvent("PLAYER_SWING")
    driver:RegisterEvent("WEAPON_SLOT_CHANGED")
end

SLASH_LH_SWINGTIMER1 = "/lh_swingtimer"
SlashCmdList.LH_SWINGTIMER = function(message)
    local command = (message or ""):lower():match("^%s*(.-)%s*$")
    if command == "" and Addon.category and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(Addon.category:GetID())
    elseif command == "on" then Addon:SetOption("enabled", true)
    elseif command == "off" then Addon:SetOption("enabled", false)
    else print("LH_SwingTimer: /lh_swingtimer on | off") end
end
