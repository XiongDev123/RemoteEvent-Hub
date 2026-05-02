-- ╔══════════════════════════════════════════════════════╗
-- ║     Money Clicker Incremental - Auto Script          ║
-- ║     UI: Obsidian (mspaint.cc)  |  By @XiongDev123   ║
-- ╚══════════════════════════════════════════════════════╝

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()

-- ── Services ──────────────────────────────────────────────────────────────────
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS         = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ── RemoteEvents ──────────────────────────────────────────────────────────────
local Events               = RS:WaitForChild("Events")
local ClickMoney           = Events:WaitForChild("ClickMoney")
local ClickGem             = ClickMoney:WaitForChild("ClickGem")
local ClickMining          = ClickMoney:WaitForChild("ClickMining")
local RequestChange        = Events:WaitForChild("RequestChange")
local UpgradeEvent         = Events:WaitForChild("Upgrade")
local GemUpgradeEvent      = UpgradeEvent:WaitForChild("GemUpgrade")
local GemFeatureEvent      = UpgradeEvent:WaitForChild("GemFeature")
local JewelUpgradeEvent    = UpgradeEvent:WaitForChild("JewelUpgrade")
local MiningUpgradeEvent   = UpgradeEvent:WaitForChild("MiningUpgrade")
local RareUpgradeEvent     = UpgradeEvent:WaitForChild("RareUpgrade")
local ExtraUpgradeEvent    = UpgradeEvent:WaitForChild("ExtraUpgrade")
local BuildEvent           = UpgradeEvent:WaitForChild("Build")
local PrestigeEvent        = Events:WaitForChild("Prestige")
local PrestigeUpgradeEvent = PrestigeEvent:WaitForChild("PrestigeUpgrade")
local GemPrestigeEvent     = PrestigeEvent:WaitForChild("GemPrestige")
local JewelryEvent         = PrestigeEvent:WaitForChild("Jewelry")
local ResearchUpgradeEvent = PrestigeEvent:WaitForChild("ResearchUpgrade")
local Stats                = LocalPlayer:WaitForChild("Stats")

-- ── Window ────────────────────────────────────────────────────────────────────
local Window = Library:CreateWindow({
    Title         = "RemoteEvent Hub",
    Footer        = "Game: Money Clicker Incremental | By @XiongDev123",
    NotifySide    = "Right",
    Center        = true,
    AutoShow      = true,
    ToggleKeybind = Enum.KeyCode.RightControl,
})

-- ── Tabs ──────────────────────────────────────────────────────────────────────
local Tabs = {
    Main           = Window:AddTab("Main",        "zap"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local Toggles = Library.Toggles
local Options  = Library.Options

-- ═══════════════════════════════════════════════════════════════════════════════
--  TAB: MAIN
-- ═══════════════════════════════════════════════════════════════════════════════

local Clicker    = Tabs.Main:AddLeftGroupbox("Clicker")
local Gem        = Tabs.Main:AddLeftGroupbox("Gem")
local MyHouseMain = Tabs.Main:AddLeftGroupbox("My House")
local MainSettings = Tabs.Main:AddRightGroupbox("Settings")
local Mining     = Tabs.Main:AddRightGroupbox("Mining")
local UpgradeTree = Tabs.Main:AddRightGroupbox("Upgrade Tree")
local ResearchMain = Tabs.Main:AddRightGroupbox("Research")

-- ── Clicker ───────────────────────────────────────────────────────────────────
Clicker:AddToggle("AutoClick", {
    Text    = "Auto Click Money",
    Default = false,
    Tooltip = "Fires ClickMoney RemoteEvent every interval",
})

Clicker:AddToggle("AutoPrestigeUpgrade", {
    Text    = "Auto Upgrades",
    Default = false,
    Tooltip = "Automatically purchases selected Prestige Upgrades",
})

Clicker:AddToggle("AutoBuyUpgrades", {
    Text    = "Auto Buy",
    Default = false,
    Tooltip = "Automatically purchases selected upgrade types",
})

Clicker:AddDropdown("ClickerTypes", {
    Text    = "Clicker",
    Default = { "Currency", "Clicker", "GPU" },
    Values  = { "Currency", "Clicker", "GPU", "Robot", "Generator", "Office", "Money Machine", "Money Factory" },
    Multi   = true,
    Tooltip = "Select which upgrade types to auto-buy",
})

Clicker:AddDropdown("BucksUpgrades", {
    Text    = "Bucks",
    Default = {},
    Values  = { "More Money", "More Gems", "More Pickaxe Damage", "Gold Chance" },
    Multi   = true,
    Tooltip = "Select which Bucks Upgrades to auto-buy",
})

Clicker:AddDivider()

Clicker:AddToggle("AutoPrestige", {
    Text    = "Auto Prestige",
    Default = false,
    Tooltip = "Automatically prestiges when Money reaches the threshold",
})

local prestigeThreshold = 10000
local PrestigeThresholdInput

PrestigeThresholdInput = Clicker:AddInput("PrestigeThreshold", {
    Text        = "Prestige At ($)",
    Default     = "10000",
    Numeric     = true,
    Finished    = true,
    Placeholder = "Min: 10000",
    Tooltip     = "Prestige when Money reaches this value (min 10000)",
    Callback    = function(value)
        local n = tonumber(value)
        if n and n >= 10000 then
            prestigeThreshold = n
        else
            prestigeThreshold = 10000
            Library:Notify("Prestige threshold cannot be less than 10000.", 3)
            Options.PrestigeThreshold:SetValue("10000")
        end
    end,
})

Clicker:AddButton("Prestige", function()
    pcall(function()
        PrestigeEvent:FireServer()
    end)
end)

-- ── Gem ───────────────────────────────────────────────────────────────────────
Gem:AddToggle("AutoClickGem", {
    Text    = "Auto Click Gem",
    Default = false,
    Tooltip = "Fires ClickGem RemoteEvent every interval",
})

Gem:AddToggle("AutoBuyGemUpgrades", {
    Text    = "Auto Buy",
    Default = false,
    Tooltip = "Automatically purchases selected Gem Upgrades",
})

Gem:AddDropdown("GemUpgrades", {
    Text    = "Gem Upgrades",
    Default = {},
    Values  = { "Gem Tier", "Gems Are $$$", "More Prestige P.", "Faster Gems", "Click Power" },
    Multi   = true,
    Tooltip = "Select which Gem Upgrades to auto-buy",
})

Gem:AddToggle("AutoJewelUpgrades", {
    Text    = "Auto Buy",
    Default = false,
    Tooltip = "Automatically purchases selected Jewel Upgrades",
})

Gem:AddDropdown("JewelUpgradeTypes", {
    Text    = "Jewel Upgrades",
    Default = {},
    Values  = { "T1 Upgrades", "T2 Upgrades", "T3 Upgrades", "T4 Upgrades" },
    Multi   = true,
    Tooltip = "Select which Jewel Upgrade tiers to auto-buy",
})

Gem:AddDivider()

Gem:AddToggle("AutoGemPrestige", {
    Text    = "Auto Gem Prestige",
    Default = false,
    Tooltip = "Automatically Gem Prestiges when Gems reach the required amount",
})

Gem:AddButton("Gem Prestige", function()
    pcall(function()
        GemPrestigeEvent:FireServer()
    end)
end)

Gem:AddToggle("AutoGetJewels", {
    Text    = "Auto Get Jewels",
    Default = false,
    Tooltip = "Automatically gets Jewels when Gems reach the threshold",
})

local jewelryThreshold = 100000

Gem:AddInput("JewelryThreshold", {
    Text        = "Get Jewels At (G)",
    Default     = "100000",
    Numeric     = true,
    Finished    = true,
    Placeholder = "Min: 100000",
    Tooltip     = "Get Jewels when Gems reach this value (min 100000)",
    Callback    = function(value)
        local n = tonumber(value)
        if n and n >= 100000 then
            jewelryThreshold = n
        else
            jewelryThreshold = 100000
            Library:Notify("Jewelry threshold cannot be less than 100000.", 3)
            Options.JewelryThreshold:SetValue("100000")
        end
    end,
})

Gem:AddButton("Get Jewels", function()
    pcall(function()
        JewelryEvent:FireServer()
    end)
end)

Gem:AddToggle("AutoBuyGemFeature", {
    Text    = "Auto Buy Gem Feature",
    Default = false,
    Tooltip = "Cycles through Gem Features 1-7 and buys them repeatedly",
})

-- ── My House ──────────────────────────────────────────────────────────────────
MyHouseMain:AddToggle("AutoUpgradeHouse", {
    Text    = "Auto Upgrade House",
    Default = false,
    Tooltip = "Automatically upgrades selected house parts",
})

MyHouseMain:AddDropdown("HouseUpgrades", {
    Text    = "House Upgrades",
    Default = {},
    Values  = { "House", "Fence", "Yerd" },
    Multi   = true,
    Tooltip = "Select which parts to auto-upgrade",
})

-- ── Settings ──────────────────────────────────────────────────────────────────
MainSettings:AddSlider("AutoClickCPS", {
    Text     = "Clicks Per Second",
    Default  = 20,
    Min      = 1,
    Max      = 60,
    Rounding = 0,
    Suffix   = " CPS",
})

MainSettings:AddToggle("UpgradeMax", {
    Text    = "Upgrade Max",
    Default = false,
    Tooltip = "Buy maximum amount instead of one at a time",
})

MainSettings:AddSlider("AutoBuyDelay", {
    Text     = "Upgrade Delay (s)",
    Default  = 0.2,
    Min      = 0.0,
    Max      = 10.0,
    Rounding = 1,
    Suffix   = "s",
})

-- ── Mining ────────────────────────────────────────────────────────────────────
Mining:AddToggle("AutoMining", {
    Text    = "Auto Mining",
    Default = false,
    Tooltip = "Fires ClickMining RemoteEvent every interval",
})

Mining:AddToggle("AutoBuyMiningUpgrades", {
    Text    = "Auto Buy",
    Default = false,
    Tooltip = "Automatically purchases selected Mining Upgrades",
})

Mining:AddDropdown("MiningUpgrades", {
    Text    = "Mining Upgrades",
    Default = {},
    Values  = { "Pickaxe", "Mining Profits", "Critical Hit", "Gems And Gems", "XPlosion", "Faster Research", "Critical Damage", "Silver Bucks", "Layer Hop", "Super Faster Gems", "Faster Crafting", "More Population", "More Rare Gems", "Inflation", "Passive Prestige" },
    Multi   = true,
    Tooltip = "Select which Mining Upgrades to auto-buy",
})

Mining:AddDropdown("ExtraUpgrades", {
    Text    = "Extra Upgrades",
    Default = {},
    Values  = { "More Gems", "Depth Jump", "More XP", "Blocks Are Molten", "More Silver Bucks", "More Rare Gems" },
    Multi   = true,
    Tooltip = "Select which Extra Upgrades to auto-buy",
})

-- ── Upgrade Tree ──────────────────────────────────────────────────────────────
UpgradeTree:AddDropdown("PrestigeUpgradeList", {
    Text        = "Prestige Upgrades",
    Default     = {},
    Values      = {
        "Expansion !",                -- 1
        "Unlock Level",               -- 2
        "Unlock Gems",                -- 3
        "Unlock Mines",               -- 4
        "My House",                   -- 5
        "Research",                   -- 6
        "Population",                 -- 7
        "Industry",                   -- 8
        "More Money",                 -- 9
        "More Automators",            -- 10
        "Money Upgrades",             -- 10
        "Enhanced Clicker",           -- 11
        "Time Played Bonus",          -- 12
        "Bronze Money Pack",          -- 13
        "Silver Money Pack",          -- 14
        "Golden Money Pack",          -- 15
        "More Gem Levels",            -- 16
        "Silver Money = Money",       -- 17
        "Expand Silver Upgrades Cap", -- 18
        "Pickaxe Damage",             -- 19
        "Extended Pickaxe DMG",       -- 20
        "Faster House Building",      -- 21
        "Land",                       -- 22
        "Even More Money",            -- 28
        "More Gems ll",               -- 29
        "More Gems lll",              -- 30
        "More Gems",                  -- 31
        "More Ores",                  -- 32
        "More Ores ll",               -- 33
        "Extra Population",           -- 37
        "Extra Mega",                 -- 38
    },
    Multi      = true,
    Searchable = true,
    Tooltip    = "Select which Prestige Upgrades to auto-buy",
})

UpgradeTree:AddSlider("PrestigeUpgradeDelay", {
    Text     = "Upgrade Delay (s)",
    Default  = 1.0,
    Min      = 0.0,
    Max      = 10.0,
    Rounding = 1,
    Suffix   = "s",
})

-- ── Research ──────────────────────────────────────────────────────────────────
ResearchMain:AddToggle("AutoResearchUpgrade", {
    Text    = "Auto Upgrades",
    Default = false,
    Tooltip = "Automatically purchases selected Research Upgrades",
})

ResearchMain:AddDropdown("ResearchUpgradeList", {
    Text       = "Research Upgrades",
    Default    = {},
    Values     = {
        "Increase Pickaxe Damage", -- 2
        "Increase Gem Gain",       -- 3
        "Increase Money Gain",     -- 4
        "Construction Speed",      -- 5
        "Unlock Fences",           -- 6
        "Unlock Decoration",       -- 7
        "Unlock Roads",            -- 8
        "Autobuy Money",           -- 9
        "Autobuy Amount",          -- 10
        "Money Autoclick",         -- 11
        "Autobuy Gem Upgrade",     -- 12
        "Gem Autoclick",           -- 13
        "More Ores",               -- 14
        "Faster Population",       -- 15
        "More Jewels",             -- 16
        "Extra Money",             -- 17
        "Research = Money",        -- 18
        "Free Money Upgrades",     -- 19
        "Free Gem Upgrades",       -- 20
        "Population Power",        -- 22
        "Silver Buck Chance",      -- 23
    },
    Multi      = true,
    Searchable = true,
    Tooltip    = "Select which Research Upgrades to auto-buy",
})

ResearchMain:AddSlider("ResearchUpgradeDelay", {
    Text     = "Upgrades Delay (s)",
    Default  = 0.5,
    Min      = 0.0,
    Max      = 10.0,
    Rounding = 1,
    Suffix   = "s",
})

-- ═══════════════════════════════════════════════════════════════════════════════
--  TAB: SETTINGS
-- ═══════════════════════════════════════════════════════════════════════════════

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("RemoteEventHub/Money-Clicker-Incremental")

-- ── Menu Group ────────────────────────────────────────────────────────────────
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default  = "100%",
    Text     = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddSlider("UICornerSlider", {
    Text     = "Corner Radius",
    Default  = Library.CornerRadius,
    Min      = 0,
    Max      = 20,
    Rounding = 0,
    Callback = function(value)
        Window:SetCornerRadius(value)
    end,
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

-- ── Theme + Config ────────────────────────────────────────────────────────────
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("RemoteEventHub/Money-Clicker-Incremental")
ThemeManager:ApplyToTab(Tabs["UI Settings"])
ThemeManager:LoadDefault()

SaveManager:BuildConfigSection(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- ═══════════════════════════════════════════════════════════════════════════════
--  AUTOMATION LOGIC
-- ═══════════════════════════════════════════════════════════════════════════════

-- ── Auto Buy Upgrades ─────────────────────────────────────────────────────────
-- Maps dropdown label -> upgrade index
local upgradeIndex = {
    Currency  = 1,
    Clicker   = 2,
    GPU       = 3,
    Robot     = 4,
    Generator     = 5,
    Office        = 6,
    ["Money Machine"]  = 7,
    ["Money Factory"]  = 8,
}

local function tryBuyUpgrades()
    local isMax = Toggles.UpgradeMax.Value
    local selected = Options.ClickerTypes.Value

    for label, _ in pairs(selected) do
        local idx = upgradeIndex[label]
        if idx then
            pcall(function()
                UpgradeEvent:FireServer(idx, isMax)
            end)
        end
    end
end

local gemUpgradeIndex = {
    ["Gem Tier"]         = 1,
    ["Gems Are $$$"]     = 2,
    ["More Prestige P."] = 3,
    ["Faster Gems"]      = 4,
    ["Click Power"]      = 5,
}

local miningUpgradeIndex = {
    ["Pickaxe"]          = 1,
    ["Mining Profits"]   = 2,
    ["Critical Hit"]     = 3,
    ["Gems And Gems"]    = 4,
    ["XPlosion"]         = 5,
    ["Faster Research"]  = 6,
    ["Critical Damage"]  = 7,
    ["Silver Bucks"]     = 8,
    ["Layer Hop"]         = 9,
    ["Super Faster Gems"] = 10,
    ["Faster Crafting"]   = 11,
    ["More Population"]   = 12,
    ["More Rare Gems"]    = 13,
    ["Inflation"]         = 14,
    ["Passive Prestige"]  = 15,
}

local rareUpgradeIndex = {
    ["More Gems"]         = 1,
    ["Depth Jump"]        = 2,
    ["More XP"]           = 3,
    ["Blocks Are Molten"] = 4,
    ["More Silver Bucks"] = 5,
    ["More Rare Gems"]    = 6,
}

local extraUpgradeIndex = {
    ["More Money"]           = 1,
    ["More Gems"]            = 2,
    ["More Pickaxe Damage"]  = 3,
    ["Gold Chance"]          = 4,
}

local function tryGemUpgrades()
    local isMax = Toggles.UpgradeMax.Value
    local selected = Options.GemUpgrades.Value

    for label, _ in pairs(selected) do
        local idx = gemUpgradeIndex[label]
        if idx then
            pcall(function()
                GemUpgradeEvent:FireServer(idx, isMax)
            end)
        end
    end
end

local function tryMiningUpgrades()
    local selected = Options.MiningUpgrades.Value
    for label, _ in pairs(selected) do
        local idx = miningUpgradeIndex[label]
        if idx then
            pcall(function()
                MiningUpgradeEvent:FireServer(idx)
            end)
        end
    end
end

local function tryRareUpgrades()
    local selected = Options.ExtraUpgrades.Value
    for label, _ in pairs(selected) do
        local idx = rareUpgradeIndex[label]
        if idx then
            pcall(function()
                RareUpgradeEvent:FireServer(idx)
            end)
        end
    end
end

local function tryExtraUpgrades()
    local selected = Options.BucksUpgrades.Value
    for label, _ in pairs(selected) do
        local idx = extraUpgradeIndex[label]
        if idx then
            pcall(function()
                ExtraUpgradeEvent:FireServer(idx)
            end)
        end
    end
end

local jewelUpgradeMap = {
    ["T1 Upgrades"] = { 1, 2, 3 },
    ["T2 Upgrades"] = { 4, 5, 6 },
    ["T3 Upgrades"] = { 7, 8, 9 },
    ["T4 Upgrades"] = { 10, 11, 12 },
}

local function tryJewelUpgrades()
    local selected = Options.JewelUpgradeTypes.Value
    for label, _ in pairs(selected) do
        local indices = jewelUpgradeMap[label]
        if indices then
            for _, idx in ipairs(indices) do
                pcall(function()
                    JewelUpgradeEvent:FireServer(idx)
                end)
            end
        end
    end
end

-- ── Prestige Upgrade Tree ─────────────────────────────────────────────────────
local prestigeUpgradeIndex = {
    ["Expansion !"]           = 1,
    ["Unlock Level"]          = 2,
    ["Unlock Gems"]           = 3,
    ["Unlock Mines"]          = 4,
    ["My House"]              = 5,
    ["Research"]              = 6,
    ["Population"]            = 7,
    ["Industry"]              = 8,
    ["More Money"]            = 9,
    ["More Automators"]       = 10,
    ["Money Upgrades"]        = 10,
    ["Enhanced Clicker"]      = 11,
    ["Time Played Bonus"]     = 12,
    ["Bronze Money Pack"]     = 13,
    ["Silver Money Pack"]     = 14,
    ["Golden Money Pack"]     = 15,
    ["More Gem Levels"]       = 16,
    ["Silver Money = Money"]       = 17,
    ["Expand Silver Upgrades Cap"] = 18,
    ["Pickaxe Damage"]        = 19,
    ["Extended Pickaxe DMG"]  = 20,
    ["Faster House Building"] = 21,
    ["Land"]                  = 22,
    ["Even More Money"]       = 28,
    ["More Gems ll"]          = 29,
    ["More Gems lll"]         = 30,
    ["More Gems"]             = 31,
    ["More Ores"]             = 32,
    ["More Ores ll"]          = 33,
    ["Extra Population"]      = 37,
    ["Extra Mega"]            = 38,
}

local function tryPrestigeUpgrades()
    local selected = Options.PrestigeUpgradeList.Value
    for label, _ in pairs(selected) do
        local idx = prestigeUpgradeIndex[label]
        if idx then
            pcall(function()
                PrestigeUpgradeEvent:FireServer(idx)
            end)
        end
    end
end

local researchUpgradeIndex = {
    ["Increase Pickaxe Damage"] = 2,
    ["Increase Gem Gain"]       = 3,
    ["Increase Money Gain"]     = 4,
    ["Construction Speed"]      = 5,
    ["Unlock Fences"]           = 6,
    ["Unlock Decoration"]       = 7,
    ["Unlock Roads"]            = 8,
    ["Autobuy Money"]           = 9,
    ["Autobuy Amount"]          = 10,
    ["Money Autoclick"]         = 11,
    ["Autobuy Gem Upgrade"]     = 12,
    ["Gem Autoclick"]           = 13,
    ["More Ores"]               = 14,
    ["Faster Population"]       = 15,
    ["More Jewels"]             = 16,
    ["Extra Money"]             = 17,
    ["Research = Money"]        = 18,
    ["Free Money Upgrades"]     = 19,
    ["Free Gem Upgrades"]       = 20,
    ["Population Power"]        = 22,
    ["Silver Buck Chance"]      = 23,
}

local function tryResearchUpgrades()
    local selected = Options.ResearchUpgradeList.Value
    for label, _ in pairs(selected) do
        local idx = researchUpgradeIndex[label]
        if idx then
            pcall(function()
                ResearchUpgradeEvent:FireServer(idx)
            end)
        end
    end
end

-- ── Auto Collect Essence ──────────────────────────────────────────────────────
-- NOTE: Replace with actual RemoteEvent name found via RemoteSpy
local CollectEssenceEvent = Events:FindFirstChild("CollectEssence")

local function tryCollectEssence()
    if CollectEssenceEvent then
        CollectEssenceEvent:FireServer()
    else
        for _, v in ipairs(Events:GetChildren()) do
            if v:IsA("RemoteEvent") then
                local name = string.lower(v.Name)
                if name:find("essence") or name:find("collect") or name:find("claim") then
                    v:FireServer()
                    return
                end
            end
        end
    end
end

local function fireClick()
    pcall(function()
        ClickMoney:FireServer()
    end)
end

local clickAccum         = 0
local clickGemAccum      = 0
local miningAccum        = 0
local buyAccum           = 0
local prestigeAccum      = 0
local gemPrestigeAccum   = 0
local jewelryAccum       = 0
local jewelUpgradeAccum  = 0
local houseAccum         = 0
local prestigeUpgrAccum  = 0
local researchAccum      = 0
local gemFeatureAccum    = 0
local currentGemFeature  = 1

RunService.Heartbeat:Connect(function(dt)
    -- Auto Click Money
    if Toggles.AutoClick.Value then
        local interval = 1 / math.max(Options.AutoClickCPS.Value, 1)
        clickAccum = clickAccum + dt
        if clickAccum >= interval then
            clickAccum = 0
            fireClick()
        end
    else
        clickAccum = 0
    end

    -- Auto Click Gem
    if Toggles.AutoClickGem.Value then
        local interval = 1 / math.max(Options.AutoClickCPS.Value, 1)
        clickGemAccum = clickGemAccum + dt
        if clickGemAccum >= interval then
            clickGemAccum = 0
            pcall(function()
                ClickGem:FireServer()
            end)
        end
    else
        clickGemAccum = 0
    end

    -- Auto Mining
    if Toggles.AutoMining.Value then
        local interval = 1 / math.max(Options.AutoClickCPS.Value, 1)
        miningAccum = miningAccum + dt
        if miningAccum >= interval then
            miningAccum = 0
            pcall(function()
                ClickMining:FireServer()
            end)
        end
    else
        miningAccum = 0
    end

    -- Auto Upgrades
    if Toggles.AutoBuyUpgrades.Value then
        local delay = Options.AutoBuyDelay.Value
        buyAccum = buyAccum + dt
        if buyAccum >= delay then
            buyAccum = 0
            tryBuyUpgrades()
            tryGemUpgrades()
            tryMiningUpgrades()
            tryRareUpgrades()
            tryExtraUpgrades()
        end
    else
        buyAccum = 0
    end

    -- Auto Prestige
    if Toggles.AutoPrestige.Value then
        prestigeAccum = prestigeAccum + dt
        if prestigeAccum >= 1 then
            prestigeAccum = 0
            local money = Stats:FindFirstChild("Money")
            if money and money.Value >= prestigeThreshold then
                pcall(function()
                    PrestigeEvent:FireServer()
                end)
            end
        end
    else
        prestigeAccum = 0
    end

    -- Auto Gem Prestige
    if Toggles.AutoGemPrestige.Value then
        gemPrestigeAccum = gemPrestigeAccum + dt
        if gemPrestigeAccum >= 1 then
            gemPrestigeAccum = 0
            pcall(function()
                local required = PlayerGui
                    :WaitForChild("GameUi")
                    :WaitForChild("GameBackground")
                    :WaitForChild("GemClicker")
                    :WaitForChild("Prestige")
                    :WaitForChild("PrestigeLabel")
                    :WaitForChild("PrestigeLocked")
                    :WaitForChild("Required")
                if required.Text == "YOU CAN PRESTIGE" then
                    GemPrestigeEvent:FireServer()
                end
            end)
        end
    else
        gemPrestigeAccum = 0
    end

    -- Auto Prestige Upgrade Tree
    if Toggles.AutoPrestigeUpgrade.Value then
        local delay = Options.PrestigeUpgradeDelay.Value
        prestigeUpgrAccum = prestigeUpgrAccum + dt
        if prestigeUpgrAccum >= delay then
            prestigeUpgrAccum = 0
            tryPrestigeUpgrades()
        end
    else
        prestigeUpgrAccum = 0
    end

    -- Auto Research Upgrades
    if Toggles.AutoResearchUpgrade.Value then
        local delay = Options.ResearchUpgradeDelay.Value
        researchAccum = researchAccum + dt
        if researchAccum >= delay then
            researchAccum = 0
            tryResearchUpgrades()
        end
    else
        researchAccum = 0
    end

    -- Auto Get Jewels
    if Toggles.AutoGetJewels.Value then
        jewelryAccum = jewelryAccum + dt
        if jewelryAccum >= 1 then
            jewelryAccum = 0
            local gems = Stats:FindFirstChild("Gems")
            if gems and gems.Value >= jewelryThreshold then
                pcall(function()
                    JewelryEvent:FireServer()
                end)
            end
        end
    else
        jewelryAccum = 0
    end

    -- Auto Jewel Upgrades
    if Toggles.AutoJewelUpgrades.Value then
        jewelUpgradeAccum = jewelUpgradeAccum + dt
        if jewelUpgradeAccum >= 0.5 then
            jewelUpgradeAccum = 0
            tryJewelUpgrades()
        end
    else
        jewelUpgradeAccum = 0
    end

    -- Auto Upgrade House
    if Toggles.AutoUpgradeHouse.Value then
        houseAccum = houseAccum + dt
        if houseAccum >= 0.5 then
            houseAccum = 0
            local houseIndex = { House = 1, Fence = 2, Yerd = 3 }
            local selected = Options.HouseUpgrades.Value
            for label, _ in pairs(selected) do
                local idx = houseIndex[label]
                if idx then
                    pcall(function()
                        BuildEvent:FireServer(idx)
                    end)
                end
            end
        end
    else
        houseAccum = 0
    end

    -- Auto Buy Gem Feature (cycles 1-7)
    if Toggles.AutoBuyGemFeature.Value then
        gemFeatureAccum = gemFeatureAccum + dt
        if gemFeatureAccum >= 0.2 then
            gemFeatureAccum = 0
            pcall(function()
                GemFeatureEvent:FireServer(currentGemFeature)
            end)
            currentGemFeature = currentGemFeature % 7 + 1
        end
    else
        gemFeatureAccum   = 0
        currentGemFeature = 1
    end

end)

-- ── Mutual Exclusion: Auto Click Money / Auto Click Gem / Auto Mining / Upgrade Tree / Research ──
Toggles.AutoClick:OnChanged(function(value)
    if value then
        RequestChange:FireServer("Clicker")
        Toggles.AutoClickGem:SetValue(false)
        Toggles.AutoMining:SetValue(false)
        Toggles.AutoPrestigeUpgrade:SetValue(false)
        Toggles.AutoResearchUpgrade:SetValue(false)
    end
end)

Toggles.AutoClickGem:OnChanged(function(value)
    if value then
        RequestChange:FireServer("GemClicker")
        Toggles.AutoClick:SetValue(false)
        Toggles.AutoMining:SetValue(false)
        Toggles.AutoPrestigeUpgrade:SetValue(false)
        Toggles.AutoResearchUpgrade:SetValue(false)
    end
end)

Toggles.AutoMining:OnChanged(function(value)
    if value then
        RequestChange:FireServer("Mining")
        Toggles.AutoClick:SetValue(false)
        Toggles.AutoClickGem:SetValue(false)
        Toggles.AutoPrestigeUpgrade:SetValue(false)
        Toggles.AutoResearchUpgrade:SetValue(false)
    end
end)

Toggles.AutoPrestigeUpgrade:OnChanged(function(value)
    if value then
        RequestChange:FireServer("PrestigeTree")
        Toggles.AutoClick:SetValue(false)
        Toggles.AutoClickGem:SetValue(false)
        Toggles.AutoMining:SetValue(false)
        Toggles.AutoResearchUpgrade:SetValue(false)
    end
end)

Toggles.AutoResearchUpgrade:OnChanged(function(value)
    if value then
        RequestChange:FireServer("Research")
        Toggles.AutoClick:SetValue(false)
        Toggles.AutoClickGem:SetValue(false)
        Toggles.AutoMining:SetValue(false)
        Toggles.AutoPrestigeUpgrade:SetValue(false)
    end
end)
