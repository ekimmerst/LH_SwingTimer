local driver = CreateFrame("Frame")
local bar, endMarker, remainingText, started, duration
local layoutElapsed = 0

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
        bar = CreateFrame("StatusBar", "MiniSwingTimerBar", UIParent)
        bar:Hide()
        bar:EnableMouse(false)
        bar:SetFrameStrata("HIGH")
        bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
        bar:SetStatusBarColor(1, 0.78, 0.15, 1)
        bar:SetOrientation("HORIZONTAL")
        bar:SetReverseFill(false)
        bar:SetMinMaxValues(0, 1)

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
    endMarker:SetSize(1 / bar:GetEffectiveScale(), 8 / bar:GetEffectiveScale())
    bar:ClearAllPoints()
    bar:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)
    bar:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -2)
    return true
end

local function Stop()
    started, duration = nil, nil
    driver:SetScript("OnUpdate", nil)
    if bar then bar:Hide() end
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
    bar:SetValue(math.max(0, progress))
    remainingText:SetFormattedText("%.1f", math.max(0, duration * (1 - progress)))
end

driver:SetScript("OnEvent", function(_, event, swingDuration, swingType)
    if event == "PLAYER_SWING" then
        if not Readable(swingType) then return end
        if swingType ~= Enum.PlayerSwingType.MainHand
            and swingType ~= Enum.PlayerSwingType.Ranged then return end
        if not Readable(swingDuration) or type(swingDuration) ~= "number" or swingDuration <= 0 then
            Stop()
            return
        end
        if not Layout() then return end
        started, duration = GetTime(), swingDuration
        layoutElapsed = 0
        bar:SetValue(0)
        remainingText:SetFormattedText("%.1f", duration)
        bar:Show()
        driver:SetScript("OnUpdate", Update)
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
if C_SwingTimer and Enum and Enum.PlayerSwingType then
    driver:RegisterEvent("PLAYER_SWING")
    driver:RegisterEvent("WEAPON_SLOT_CHANGED")
end
