-- ============================================================
-- FY HUB - 核心安全加密版本
-- ============================================================

-- 1. 加载卡密验证 UI (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local KeyWindow = Rayfield:CreateWindow({
    Name = "FY 核心安全协议 // SECURE ENVIRONMENT",
    LoadingTitle = "正在初始化安全通道...",
    LoadingSubtitle = "加密架构设计 By FY",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "节点身份验证协议",
        Subtitle = "访问控制核心校验",
        Note = "请输入专属授权密钥以继续访问（密钥：FYNB666）。",
        FileName = "FY_Secure_Session",
        SaveKey = false, -- 每次注入均需重新输入密钥
        GrabKeyFromSite = false,
        Key = {"FYNB666"}
    }
})

Rayfield:Notify({
    Title = "授权成功",
    Content = "密钥效验通过，正在加载主程序...",
    Duration = 3
})

-- 2. 加载主 UI 库 (Obsidian)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

-- 3. 服务和工具
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FromRGB = Color3.fromRGB
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new
local task = task

-- 4. 远程事件与模块
local PlayerEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("PlayerEvent")
local Modules = ReplicatedStorage.Modules
local Algorithms = require(Modules.Algorithms)

-- 5. 全局状态
local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChild("Humanoid")
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

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
    BulletTrack = false,
    ScreenPriority = true,
    DistancePriority = false,
    ShowCustomCursor = true,
}

local Settings = {
    HoldTime = 0,
    Distance = 25,
    KillAuraRange = 50,
    HitboxSize = 10,
    AimSmoothness = 5,
    AimMaxDistance = 200,
    AimCheckWall = true,
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
-- 6. 核心功能函数（已修复出租车传送 Bug）
-- ============================================================

function ApplyHitbox(size)
    size = size or Settings.HitboxSize
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and head then
                    head.Size = Vector3_new(size, size, size)
                    head.Transparency = 1
                    head.Color = FromRGB(255, 215, 0)
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                end
            end
        end
    end
end

function ResetHitbox()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    head.Size = Vector3_new(2, 2, 2)
                    head.Transparency = 0
                    head.Color = FromRGB(255, 255, 255)
                    head.Material = Enum.Material.SmoothPlastic
                    head.CanCollide = true
                end
            end
        end
    end
end

function UpdateWhitelist()
    local userId = LocalPlayer.UserId
    FriendWhitelist = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            pcall(function()
                if player:IsFriendsWith(userId) then
                    FriendWhitelist[player.UserId] = true
                end
            end)
        end
    end
end

function ToggleKillAura(enabled)
    Toggles.KillAura = enabled
    if enabled then
        pcall(function() PlayerEvent:FireServer("combatMode", true) end)
        StartKillAura()
    else
        if KillAuraConnection then KillAuraConnection:Disconnect() end
        KillAuraConnection = nil
    end
end

function StartKillAura()
    if KillAuraConnection then KillAuraConnection:Disco
