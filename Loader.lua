--[[
    Roblox Multi-Game Remote Loader
    功能：偵測 PlaceId 並從 GitHub 載入對應的腳本
]]

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local PlaceId = game.PlaceId

-- 配置區域：在此定義不同遊戲對應的腳本連結
local SCRIPT_CONFIG = {
    -- 格式：[PlaceId] = {Name = "顯示名稱", Url = "GitHub Raw 連結"}
    [18408132742] = {
        Name = "Money Clicker Incremental",
        Url = "https://raw.githubusercontent.com/XiongDev123/RemoteEvent-Hub/main/Games/MoneyClickerIncremental.lua"
    }
}

local AccentColor = Color3.fromRGB(0, 255, 127) -- 介面主題色

-- 建立載入介面
local function CreateLoaderUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ManusMultiLoader"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 280, 0, 90)
    MainFrame.Position = UDim2.new(0.5, -140, 0.5, -45)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = AccentColor
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 1
    UIStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0.5, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "正在辨識遊戲..."
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextTransparency = 1
    Title.Parent = MainFrame

    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(1, 0, 0.4, 0)
    Status.Position = UDim2.new(0, 0, 0.5, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Place ID: " .. tostring(PlaceId)
    Status.TextColor3 = Color3.fromRGB(200, 200, 200)
    Status.TextSize = 13
    Status.Font = Enum.Font.Gotham
    Status.TextTransparency = 1
    Status.Parent = MainFrame

    -- 淡入動畫
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    TweenService:Create(Title, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(Status, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    return ScreenGui, Title, Status
end

-- 執行遠端載入邏輯
local function StartLoading(titleLabel, statusLabel)
    local config = SCRIPT_CONFIG[PlaceId] or SCRIPT_CONFIG["Default"]

    if config then
        titleLabel.Text = "載入中: " .. config.Name
        statusLabel.Text = "正在從 GitHub 獲取數據..."
        
        local success, result = pcall(function()
            return game:HttpGet(config.Url)
        end)

        if success then
            statusLabel.Text = "獲取成功，正在初始化..."
            task.wait(0.8)
            
            local loadFunc, err = loadstring(result)
            if loadFunc then
                task.spawn(loadFunc)
                statusLabel.Text = "腳本已啟動！"
            else
                statusLabel.Text = "代碼解析錯誤"
                warn("Loader Error: " .. tostring(err))
            end
        else
            statusLabel.Text = "連線失敗，請檢查網路"
        end
    else
        titleLabel.Text = "不支援此遊戲"
        statusLabel.Text = "未找到對應的 Place ID 配置"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end

-- 主程序
local ui, title, status = CreateLoaderUI()
task.wait(0.6)
StartLoading(title, status)

-- 結束動畫與清理
task.wait(2)
TweenService:Create(ui.MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(ui.MainFrame.UIStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(status, TweenInfo.new(0.5), {TextTransparency = 1}):Play()

task.wait(0.5)
ui:Destroy()
