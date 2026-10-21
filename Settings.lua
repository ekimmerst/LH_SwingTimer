local addonName = ...
local Addon = LH_SwingTimer
local variables = {}

function Addon:RefreshSettings()
    if self.notifying or not Settings or not Settings.NotifyUpdate then return end
    self.notifying = true
    for _, variable in ipairs(variables) do Settings.NotifyUpdate(variable) end
    self.notifying = false
end

local function Build(category, layout)
    Addon.category = category
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Swing timer"))
    local parent
    for _, option in ipairs({
        {key = "enabled", label = "Enable swing timer", tooltip = "Show the timer below Blizzard's player cast bar. Saved per character."},
        {key = "mainHand", label = "Track main-hand swings", tooltip = "Start or restart the timer on main-hand attacks. Off-hand attacks are ignored. Saved per character."},
        {key = "ranged", label = "Track automatic ranged attacks", tooltip = "Start or restart the timer on automatic ranged attacks. The last 0.5 seconds have an orange marker and fill. Saved per character."},
    }) do
        local key = option.key
        local variable = "LH_SwingTimer_" .. key
        variables[#variables + 1] = variable
        local setting = Settings.RegisterProxySetting(category, variable, "boolean", option.label, true,
            function() return Addon:GetOption(key) end,
            function(value) Addon:SetOption(key, value) end)
        local control = Settings.CreateCheckbox(category, setting, option.tooltip)
        if parent then
            control:SetParentInitializer(parent, function() return Addon:GetOption("enabled") end)
        else parent = control end
    end
end

LH_Tweaks:RegisterModule(addonName, "LH SwingTimer", Build)
