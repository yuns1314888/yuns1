-- ============================================================
-- FY HUB 
-- ============================================================

-- 0. 安全等待游戏加载，防止直接崩溃
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- 1. 服务与核心工具安全初始化
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 安全获取远程事件，防止无限挂起报错
local PlayerEvent = nil
pcall(function()
    local remoteFolder = ReplicatedStorage:WaitForChild("Remote", 3)
    if remoteFolder then
        PlayerEvent = remoteFolder:WaitForChild("PlayerEvent", 3)
    end
end)

local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Algorithms = Modules and require(Modules:WaitForChild("Algorithms", 3)) or nil

local FromRGB = Color3.fromRGB
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new
local task = task

-- 2. 加载高级圆角 UI 库 (Obsidian)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

-- 3. 全局状态与配置
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
-- 4. 核心功能实现（已修复出租车卡地里 Bug）
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
        if PlayerEvent then pcall(function() PlayerEvent:FireServer("combatMode", true) end) end
        StartKillAura()
    else
        if KillAuraConnection then KillAuraConnection:Disconnect() end
        KillAuraConnection = nil
    end
end

function StartKillAura()
    if KillAuraConnection then KillAuraConnection:Disconnect() end
    KillAuraConnection = RunService.Heartbeat:Connect(function()
        if not Toggles.KillAura then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if Toggles.Whitelist and FriendWhitelist[player.UserId] then continue end
                local targetChar = player.Character
                if targetChar then
                    local targetRoot = targetChar:FindFirst
