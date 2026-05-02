--[[
    Roblox Advanced Remote Loader (With Error Handling)
    功能：偵測 PlaceId、遠端載入、錯誤分類提示、自動重試機制
]]

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local PlaceId = game.PlaceId

-- 配置區域
local SCRIPT_CONFIG = {
    [18408132742] = { Name = "Money Clicker Incremental", Url = "https://raw.githubusercontent.com/XiongDev123/RemoteEvent-Hub/refs/heads/main/Games/MoneyClickerIncremental.lua" },
    ["Default"] = { Name = "Universal Script", Url = "https://raw.githubusercontent.com/user/repo/main/universal.lua" }
}

local THEME = {
    Background = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 255, 150),
    Error = Color3.fromRGB(255, 70, 70),
    Text = Color3.fromRGB(255, 255, 255)
}

local MAX_RETRIES = 3 -- 最大重試次數

-- 建立載入介面
local function CreateLoaderUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ManusAdvancedLoader"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 100)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = THEME.Accent
    UIStroke.Thickness = 2
    UIStroke.Transparency = 1
    UIStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0.5, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "初始化中..."
    Title.TextColor3 = THEME.Text
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextTransparency = 1
    Title.Parent = MainFrame

    local Status = Instance.new("TextLabel")
    Status.Name = "Status"
    Status.Size = UDim2.new(1, 0, 0.4, 0)
    Status.Position = UDim2.new(0, 0, 0.5, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "準備就緒"
    Status.TextColor3 = THEME.Accent
    Status.TextSize = 14
    Status.Font = Enum.Font.Gotham
    Status.TextTransparency = 1
    Status.Parent = MainFrame

    -- 動態效果
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    TweenService:Create(Title, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(Status, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    return ScreenGui, MainFrame, Title, Status, UIStroke
end

-- 錯誤處理顯示
local function ShowError(title, status, titleLabel, statusLabel, stroke)
    titleLabel.Text = title
    statusLabel.Text = status
    statusLabel.TextColor3 = THEME.Error
    TweenService:Create(stroke, TweenInfo.new(0.3), {Color = THEME.Error}):Play()
end

-- 核心載入邏輯
local function LoadScript(titleLabel, statusLabel, stroke)
    local config = SCRIPT_CONFIG[PlaceId] or SCRIPT_CONFIG["Default"]
    
    if not config then
        ShowError("載入失敗", "找不到對應的 Place ID 配置", titleLabel, statusLabel, stroke)
        return false
    end

    titleLabel.Text = "載入: " .. config.Name
    
    local attempt = 0
    local success, result
    
    while attempt < MAX_RETRIES do
        attempt = attempt + 1
        statusLabel.Text = string.format("嘗試連線 GitHub... (%d/%d)", attempt, MAX_RETRIES)
        
        success, result = pcall(function()
            return game:HttpGet(config.Url)
        end)
        
        if success then
            -- 檢查是否為 404 或無效內容 (GitHub Raw 在 404 時會回傳 "404: Not Found")
            if result == "404: Not Found" then
                ShowError("404 錯誤", "GitHub 找不到該檔案路徑", titleLabel, statusLabel, stroke)
                return false
            end
            break
        else
            task.wait(1.5) -- 失敗後等待再重試
        end
    end

    if not success then
        ShowError("網路錯誤", "無法連接至 GitHub，請檢查網路", titleLabel, statusLabel, stroke)
        return false
    end

    statusLabel.Text = "正在解析代碼..."
    local loadFunc, err = loadstring(result)
    
    if not loadFunc then
        ShowError("語法錯誤", "遠端腳本代碼損壞", titleLabel, statusLabel, stroke)
        warn("Lua Error: " .. tostring(err))
        return false
    end

    statusLabel.Text = "啟動成功！"
    task.spawn(loadFunc)
    return true
end

-- 執行
local ui, frame, title, status, stroke = CreateLoaderUI()
task.wait(0.6)

local isSuccess = LoadScript(title, status, stroke)

-- 結束處理
task.wait(isSuccess and 1.5 or 5) -- 成功則快閃，失敗則留 5 秒讓玩家看錯誤訊息

TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(stroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(status, TweenInfo.new(0.5), {TextTransparency = 1}):Play()

task.wait(0.5)
ui:Destroy()
