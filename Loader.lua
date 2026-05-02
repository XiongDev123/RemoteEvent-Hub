--[[
    Manus Professional Roblox Loader
    功能：執行器檢查、版本檢查、遠端公告、安全性檢查、手動啟動按鈕
]]

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 配置區域
local CONFIG = {
    Version = "1.0.0",
    VersionUrl = "https://raw.githubusercontent.com/user/repo/main/version.txt", -- 存放版本號的檔案
    NewsUrl = "https://raw.githubusercontent.com/user/repo/main/news.txt",       -- 存放公告內容的檔案
    Scripts = {
        [18408132742] = { Name = "Money Clicker Incremental", Url = "https://raw.githubusercontent.com/XiongDev123/RemoteEvent-Hub/refs/heads/main/Games/MoneyClickerIncremental.lua" },
        ["Default"] = { Name = "Universal Script", Url = "https://raw.githubusercontent.com/user/repo/main/universal.lua" }
    }
}

local THEME = {
    Background = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Error = Color3.fromRGB(255, 80, 80)
}

-- 獲取執行器名稱
local function GetExecutor()
    return identifyexecutor and identifyexecutor() or "Unknown Executor"
end

-- 建立 UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ManusProLoader"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 220)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = THEME.Accent
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame

    -- 標題
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "MANUS LOADER PRO"
    Title.TextColor3 = THEME.Text
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    -- 執行器與版本資訊
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, -20, 0, 20)
    InfoLabel.Position = UDim2.new(0, 10, 0, 40)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = string.format("Executor: %s | Ver: %s", GetExecutor(), CONFIG.Version)
    InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    InfoLabel.TextSize = 12
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.Parent = MainFrame

    -- 公告欄
    local NewsFrame = Instance.new("Frame")
    NewsFrame.Size = UDim2.new(1, -40, 0, 60)
    NewsFrame.Position = UDim2.new(0, 20, 0, 70)
    NewsFrame.BackgroundColor3 = THEME.Secondary
    NewsFrame.BorderSizePixel = 0
    NewsFrame.Parent = MainFrame

    local NewsCorner = Instance.new("UICorner")
    NewsCorner.CornerRadius = UDim.new(0, 6)
    NewsCorner.Parent = NewsFrame

    local NewsText = Instance.new("TextLabel")
    NewsText.Size = UDim2.new(1, -10, 1, -10)
    NewsText.Position = UDim2.new(0, 5, 0, 5)
    NewsText.BackgroundTransparency = 1
    NewsText.Text = "正在獲取最新公告..."
    NewsText.TextColor3 = Color3.fromRGB(200, 200, 200)
    NewsText.TextSize = 13
    NewsText.Font = Enum.Font.Gotham
    NewsText.TextWrapped = true
    NewsText.Parent = NewsFrame

    -- 啟動按鈕
    local StartBtn = Instance.new("TextButton")
    StartBtn.Size = UDim2.new(1, -40, 0, 45)
    StartBtn.Position = UDim2.new(0, 20, 0, 145)
    StartBtn.BackgroundColor3 = THEME.Accent
    StartBtn.Text = "啟動腳本 (START)"
    StartBtn.TextColor3 = THEME.Text
    StartBtn.Font = Enum.Font.GothamBold
    StartBtn.TextSize = 16
    StartBtn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = StartBtn

    -- 狀態提示
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 195)
    Status.BackgroundTransparency = 1
    Status.Text = "等待操作..."
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.TextSize = 12
    Status.Font = Enum.Font.Gotham
    Status.Parent = MainFrame

    return ScreenGui, StartBtn, NewsText, Status, UIStroke
end

-- 獲取遠端資料 (公告與版本)
local function FetchRemoteData(newsLabel, statusLabel)
    task.spawn(function()
        local success, news = pcall(function() return game:HttpGet(CONFIG.NewsUrl) end)
        if success then newsLabel.Text = news else newsLabel.Text = "無法載入公告" end
        
        local vSuccess, remoteVer = pcall(function() return game:HttpGet(CONFIG.VersionUrl) end)
        if vSuccess and remoteVer:gsub("%s+", "") ~= CONFIG.Version then
            statusLabel.Text = "⚠️ 發現新版本: " .. remoteVer
            statusLabel.TextColor3 = THEME.Error
        end
    end)
end

-- 安全性檢查
local function SecurityCheck()
    if not game:GetService("RunService"):IsClient() then return false, "請在客戶端執行" end
    if not getgenv then return false, "不支援的執行器環境" end
    return true
end

-- 執行載入
local function ExecuteLoad(statusLabel, startBtn, stroke)
    startBtn.Active = false
    startBtn.Text = "處理中..."
    TweenService:Create(startBtn, TweenInfo.new(0.3), {BackgroundColor3 = THEME.Secondary}):Play()

    local isSafe, msg = SecurityCheck()
    if not isSafe then
        statusLabel.Text = "安全檢查失敗: " .. msg
        return
    end

    local config = CONFIG.Scripts[game.PlaceId] or CONFIG.Scripts["Default"]
    statusLabel.Text = "正在從 GitHub 獲取腳本..."

    local success, content = pcall(function() return game:HttpGet(config.Url) end)
    if success and content ~= "404: Not Found" then
        statusLabel.Text = "載入成功！正在啟動..."
        local func, err = loadstring(content)
        if func then
            task.spawn(func)
            task.wait(1)
            startBtn.Parent.Parent:Destroy() -- 關閉 UI
        else
            statusLabel.Text = "代碼解析錯誤"
            warn(err)
        end
    else
        statusLabel.Text = "載入失敗，請檢查連結"
        statusLabel.TextColor3 = THEME.Error
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = THEME.Error}):Play()
    end
end

-- 主邏輯
local ui, btn, news, status, stroke = CreateUI()
FetchRemoteData(news, status)

btn.MouseButton1Click:Connect(function()
    ExecuteLoad(status, btn, stroke)
end)

-- 按鈕懸停效果
btn.MouseEnter:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent:Lerp(Color3.new(1,1,1), 0.2)}):Play()
end)
btn.MouseLeave:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent}):Play()
end)
