-- ============================================================
-- FY HUB
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- 1. 安全获取 UI 挂载容器（确保卡密界面 100% 弹出来）
local protect_gui = protectgui or (syn and syn.protect_gui)
local guiParent = nil

if gethui then
    guiParent = gethui()
elseif protect_gui then
    guiParent = CoreGui
else
    guiParent = LocalPlayer:FindFirstChild("PlayerGui") or CoreGui
end

if guiParent:FindFirstChild("FY_KeySystem") then
    guiParent.FY_KeySystem:Destroy()
end

-- 2. 原生卡密验证界面
local CorrectKey = "FYHUB2026" -- 可在这里修改你的卡密
local KeyPassed = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FY_KeySystem"
ScreenGui.ResetOnSpawn = false
if protect_gui then
    protect_gui(ScreenGui)
end
ScreenGui.Parent = guiParent

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 190)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "FY HUB // 神经连接卡密验证"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.85, 0, 0, 42)
TextBox.Position = UDim2.new(0.075, 0, 0.35, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "请输入卡密: FYHUB666
"
TextBox.Text = ""
TextBox.TextSize = 14
TextBox.Font = Enum.Font.Gotham
TextBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = TextBox

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 40)
SubmitBtn.Position = UDim2.new(0.075, 0, 0.68, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Text = "验证并进入"
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = SubmitBtn

SubmitBtn.MouseButton1Click:Connect(function()
    if TextBox.Text == CorrectKey then
        KeyPassed = true
        ScreenGui:Destroy()
    else
        SubmitBtn.Text = "卡密错误！"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.2)
        SubmitBtn.Text = "验证并进入"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    end
end)

-- 阻塞等待卡密通过
while not KeyPassed do
    task.wait(0.2)
end

-- ============================================================
-- 3. 主功能初始化与 UI 加载
-- ============================================================

local PlayerEvent = nil
pcall(function()
    local remoteFolder = ReplicatedStorage:WaitForChild("Remote", 3)
    if remoteFolder then
        PlayerEvent = remoteFolder:WaitForChild("PlayerEvent", 3)
    end
end)

local FromRGB = Color3.fromRGB
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new

local success, libResult = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
end)

if not success or not libResult then
    warn("UI 库加载失败，请检查网络！")
    return
end

local Library = libResult
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Toggles = {
    Noclip = false,
    KillAura = false,
    Hitbox = false,
    Whitelist = false,
    Aim = false,
    NoDizziness = false,
    Taxi = false,
    AutoBus = false,
    AtmHack = false,
    Teleport = false,
    ShowCustomCursor = true,
}

local Settings = {
    HoldTime = 0,
    Distance = 25,
    KillAuraRange = 50,
    HitboxSize = 10,
    AimSmoothness = 5,
    AimMaxDistance = 200,
    NoDizzinessSpeed = 24,
    TaxiWaitTime = 7,
}

local KillAuraConnection = nil
local NoDizzinessConnection = nil
local AutoBusTask = nil
local AtmHackTask = nil
local TaxiTask = nil
local FriendWhitelist = {}

-- ============================================================
-- 4. 核心功能函数
-- ============================================================

function ApplyHitbox(size)
    size = size or Settings.HitboxSize
    for _, player in ipa
