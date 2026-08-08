-- ============================================================
-- FY HUB // EVA-01 TERMINAL
-- EVA-01 紫绿主题 + EVA 图片背景 + 小型灵动岛
-- 低占用优化版
-- ============================================================

-- ============================================================
-- 0. SERVICES
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Vector3_new = Vector3.new
local CFrame_new = CFrame.new
local FromRGB = Color3.fromRGB

-- ============================================================
-- 1. EVA-01 CONFIG
-- ============================================================

local CorrectKey = "FYNB666"
local KeyPassed = false

-- EVA-01 图片
-- 使用 Roblox EVA-01 相关资源缩略图
local EVA_IMAGE =
    "rbxthumb://type=Asset&id=128042533967335&w=420&h=420"

-- EVA-01 配色
local EVA = {
    Purple = FromRGB(105, 55, 185),
    PurpleLight = FromRGB(145, 85, 235),
    PurpleDark = FromRGB(48, 25, 82),

    Green = FromRGB(92, 255, 120),
    GreenDark = FromRGB(32, 105, 55),

    Background = FromRGB(25, 18, 38),
    Background2 = FromRGB(34, 24, 50),

    Main = FromRGB(54, 35, 78),
    Outline = FromRGB(105, 70, 145),

    Text = FromRGB(245, 240, 255),
}

-- ============================================================
-- 2. NATIVE KEY SYSTEM
-- ============================================================

if PlayerGui:FindFirstChild("FY_NativeKeySystem") then
    PlayerGui.FY_NativeKeySystem:Destroy()
end

local KeyScreenGui = Instance.new("ScreenGui")
KeyScreenGui.Name = "FY_NativeKeySystem"
KeyScreenGui.ResetOnSpawn = false
KeyScreenGui.IgnoreGuiInset = true
KeyScreenGui.DisplayOrder = 999999
KeyScreenGui.Parent = PlayerGui

local KeyMainFrame = Instance.new("Frame")
KeyMainFrame.Size = UDim2.fromOffset(350, 195)
KeyMainFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyMainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyMainFrame.BackgroundColor3 = EVA.Background
KeyMainFrame.BorderSizePixel = 0
KeyMainFrame.Parent = KeyScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 16)
KeyCorner.Parent = KeyMainFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = EVA.Purple
KeyStroke.Thickness = 1.5
KeyStroke.Parent = KeyMainFrame

-- EVA 图片
local KeyImage = Instance.new("ImageLabel")
KeyImage.Size = UDim2.fromOffset(45, 45)
KeyImage.Position = UDim2.fromOffset(18, 15)
KeyImage.BackgroundTransparency = 1
KeyImage.Image = EVA_IMAGE
KeyImage.ScaleType = Enum.ScaleType.Fit
KeyImage.Parent = KeyMainFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -75, 0, 45)
KeyTitle.Position = UDim2.fromOffset(70, 15)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "EVA-01 // FY HUB"
KeyTitle.TextColor3 = EVA.Green
KeyTitle.TextSize = 17
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.Parent = KeyMainFrame

local KeySubTitle = Instance.new("TextLabel")
KeySubTitle.Size = UDim2.new(1, -35, 0, 22)
KeySubTitle.Position = UDim2.fromOffset(18, 58)
KeySubTitle.BackgroundTransparency = 1
KeySubTitle.Text = "NEURAL CONNECTION AUTHORIZATION"
KeySubTitle.TextColor3 = EVA.PurpleLight
KeySubTitle.TextSize = 10
KeySubTitle.Font = Enum.Font.Code
KeySubTitle.TextXAlignment = Enum.TextXAlignment.Left
KeySubTitle.Parent = KeyMainFrame

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Size = UDim2.new(1, -36, 0, 42)
KeyTextBox.Position = UDim2.fromOffset(18, 85)
KeyTextBox.BackgroundColor3 = EVA.Main
KeyTextBox.TextColor3 = EVA.Text
KeyTextBox.PlaceholderColor3 = FromRGB(160, 145, 175)
KeyTextBox.PlaceholderText = "请输入卡密"
KeyTextBox.Text = ""
KeyTextBox.TextSize = 14
KeyTextBox.Font = Enum.Font.Code
KeyTextBox.ClearTextOnFocus = false
KeyTextBox.Parent = KeyMainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 9)
BoxCorner.Parent = KeyTextBox

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = EVA.Outline
BoxStroke.Thickness = 1
BoxStroke.Parent = KeyTextBox

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -36, 0, 40)
SubmitBtn.Position = UDim2.fromOffset(18, 137)
SubmitBtn.BackgroundColor3 = EVA.Purple
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
SubmitBtn.Text = "连接 EVA-01"
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.AutoButtonColor = false
SubmitBtn.Parent = KeyMainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 9)
BtnCorner.Parent = SubmitBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = EVA.PurpleLight
BtnStroke.Thickness = 1
BtnStroke.Parent = SubmitBtn

SubmitBtn.MouseEnter:Connect(function()
    SubmitBtn.BackgroundColor3 = EVA.PurpleLight
end)

SubmitBtn.MouseLeave:Connect(function()
    SubmitBtn.BackgroundColor3 = EVA.Purple
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyTextBox.Text == CorrectKey then
        KeyPassed = true
        SubmitBtn.Text = "EVA-01 连接成功"
        SubmitBtn.BackgroundColor3 = EVA.Green

        task.wait(0.35)

        KeyScreenGui:Destroy()
    else
        SubmitBtn.Text = "连接失败 // 卡密错误"
        SubmitBtn.BackgroundColor3 = FromRGB(190, 45, 65)

        task.delay(1.3, function()
            if SubmitBtn and SubmitBtn.Parent then
                SubmitBtn.Text = "连接 EVA-01"
                SubmitBtn.BackgroundColor3 = EVA.Purple
            end
        end)
    end
end)

repeat
    task.wait()
until KeyPassed

-- ============================================================
-- 3. LOAD GAME
-- ============================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ============================================================
-- 4. REMOTE / MODULES
-- ============================================================

local PlayerEvent = nil

pcall(function()
    local remoteFolder = ReplicatedStorage:WaitForChild("Remote", 3)

    if remoteFolder then
        PlayerEvent =
            remoteFolder:WaitForChild("PlayerEvent", 3)
    end
end)

local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Algorithms = nil

pcall(function()
    if Modules then
        Algorithms = require(
            Modules:WaitForChild("Algorithms", 3)
        )
    end
end)

-- ============================================================
-- 5. OBSIDIAN
-- ============================================================

local Repo =
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Library = loadstring(
    game:HttpGet(Repo .. "Library.lua")
)()

local ThemeManager = loadstring(
    game:HttpGet(Repo .. "addons/ThemeManager.lua")
)()

local SaveManager = loadstring(
    game:HttpGet(Repo .. "addons/SaveManager.lua")
)()

-- 重要：原代码缺少这个
local Options = Library.Options

-- ============================================================
-- 6. STATES
-- ============================================================

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

    ShowCustomCursor = false,
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
-- 7. CHARACTER
-- ============================================================

local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChild("Humanoid")
local HumanoidRootPart =
    Character and Character:FindFirstChild("HumanoidRootPart")

local function RefreshCharacter()
    Character = LocalPlayer.Character

    if not Character then
        Humanoid = nil
        HumanoidRootPart = nil
        return
    end

    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart =
        Character:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- 8. HITBOX
-- ============================================================

local OriginalHeadData = {}

local function SaveOriginalHead(head)
    if OriginalHeadData[head] then
        return
    end

    OriginalHeadData[head] = {
        Size = head.Size,
        Transparency = head.Transparency,
        Color = head.Color,
        Material = head.Material,
        CanCollide = head.CanCollide,
    }
end

local function ApplyHitbox(size)
    size = size or Settings.HitboxSize

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then

            local char = player.Character

            if char then
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")

                if head and hum and hum.Health > 0 then

                    SaveOriginalHead(head)

                    head.Size =
                        Vector3_new(size, size, size)

                    head.Transparency = 1
                    head.Color = EVA.Green
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                end
            end
        end
    end
end

local function ResetHitbox()
    for head, data in pairs(OriginalHeadData) do

        if head and head.Parent then

            pcall(function()
                head.Size = data.Size
                head.Transparency = data.Transparency
                head.Color = data.Color
                head.Material = data.Material
                head.CanCollide = data.CanCollide
            end)
        end

        OriginalHeadData[head] = nil
    end
end

-- ============================================================
-- 9. WHITELIST
-- ============================================================

local function UpdateWhitelist()

    table.clear(FriendWhitelist)

    local userId = LocalPlayer.UserId

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

-- ============================================================
-- 10. KILL AURA
-- ============================================================

local function StartKillAura()

    if KillAuraConnection then
        KillAuraConnection:Disconnect()
    end

    KillAuraConnection =
        RunService.Heartbeat:Connect(function()

            if not Toggles.KillAura then
                return
            end

            RefreshCharacter()

            local root = HumanoidRootPart

            if not root then
                return
            end

            for _, player in ipairs(Players:GetPlayers()) do

                if player ~= LocalPlayer then

                    if Toggles.Whitelist
                        and FriendWhitelist[player.UserId]
                    then
                        continue
                    end

                    local targetChar = player.Character

                    if targetChar then

                        local targetRoot =
                            targetChar:FindFirstChild("HumanoidRootPart")

                        local targetHum =
                            targetChar:FindFirstChildOfClass("Humanoid")

                        if targetRoot
                            and targetHum
                            and targetHum.Health > 0
                        then

                            local distance =
                                (targetRoot.Position - root.Position).Magnitude

                            if distance <= Settings.KillAuraRange then

                                if PlayerEvent then
                                    pcall(function()
                                        PlayerEvent:FireServer(
                                            "attack",
                                            targetRoot.Position
                                        )
                                    end)
                                end

                            end

                        end
                    end
                end
            end
        end)
end

local function ToggleKillAura(enabled)

    Toggles.KillAura = enabled

    if enabled then

        if PlayerEvent then
            pcall(function()
                PlayerEvent:FireServer(
                    "combatMode",
                    true
                )
            end)
        end

        StartKillAura()

    else

        if KillAuraConnection then
            KillAuraConnection:Disconnect()
            KillAuraConnection = nil
        end

    end
end

-- ============================================================
-- 11. NO DIZZINESS
-- ============================================================

local function StartNoDizziness()

    if NoDizzinessConnection then
        NoDizzinessConnection:Disconnect()
    end

    NoDizzinessConnection =
        RunService.RenderStepped:Connect(function()

            if not Toggles.NoDizziness then
                return
            end

            RefreshCharacter()

            if not Humanoid or not HumanoidRootPart then
                return
            end

            local moveDir = Humanoid.MoveDirection

            if moveDir.Magnitude > 0 then

                local speed =
                    Settings.NoDizzinessSpeed

                HumanoidRootPart.AssemblyLinearVelocity =
                    Vector3_new(
                        moveDir.X * speed,
                        HumanoidRootPart.AssemblyLinearVelocity.Y,
                        moveDir.Z * speed
                    )

            end
        end)
end

local function StopNoDizziness()

    if NoDizzinessConnection then

        NoDizzinessConnection:Disconnect()
        NoDizzinessConnection = nil

    end
end

-- ============================================================
-- 12. AREA CACHE
-- ============================================================

local AreaCache = {}
local LastAreaScan = 0

local function GetAreas()

    local now = os.clock()

    -- 10 秒内不重复疯狂扫描 Workspace
    if now - LastAreaScan < 10
        and #AreaCache > 0
    then
        return AreaCache
    end

    table.clear(AreaCache)

    local gameplay =
        Workspace:FindFirstChild("Gameplay")

    local entities =
        gameplay and gameplay:FindFirstChild("Entities")

    local clientContent =
        entities and entities:FindFirstChild("ClientContent")

    local searchRoot =
        clientContent or Workspace

    for _, obj in ipairs(searchRoot:GetDescendants()) do

        if obj.Name == "Area" then
            table.insert(AreaCache, obj)
        end

    end

    LastAreaScan = now

    return AreaCache
end

-- ============================================================
-- 13. TAXI
-- ============================================================

local function ToggleTaxi(enabled)

    Toggles.Taxi = enabled

    if enabled then

        if TaxiTask then
            task.cancel(TaxiTask)
        end

        TaxiTask = task.spawn(function()

            while Toggles.Taxi do

                local areas = GetAreas()

                if #areas == 0 then

                    task.wait(5)

                else

                    for _, area in ipairs(areas) do

                        if not Toggles.Taxi then
                            break
                        end

                        RefreshCharacter()

                        if HumanoidRootPart then

                            pcall(function()

                                HumanoidRootPart.CFrame =
                                    area.CFrame
                                    * CFrame_new(0, 0, 5)

                            end)

                        end

                        task.wait(
                            Settings.TaxiWaitTime
                        )

                    end

                end

            end

        end)

        Library:Notify({
            Time = 2,
            Title = "EVA-01 // 出租车",
            Description = "自动循环已启动",
        })

    else

        if TaxiTask then

            task.cancel(TaxiTask)
            TaxiTask = nil

        end

    end
end

-- ============================================================
-- 14. AUTO BUS
-- ============================================================

local function StartAutoBus()

    if AutoBusTask then
        task.cancel(AutoBusTask)
    end

    AutoBusTask = task.spawn(function()

        while Toggles.AutoBus do

            local areas = GetAreas()

            if #areas == 0 then

                task.wait(5)

            else

                for _, area in ipairs(areas) do

                    if not Toggles.AutoBus then
                        break
                    end

                    RefreshCharacter()

                    if Humanoid
                        and HumanoidRootPart
                    then

                        local targetCF =
                            (
                                area.CFrame
                                * CFrame_new(3, 3, 16)
                            )
                            * CFrame.Angles(
                                0,
                                math.pi,
                                0
                            )

                        pcall(function()

                            local seat =
                                Humanoid.SeatPart

                            if seat then

                                local oldRootCF =
                                    HumanoidRootPart.CFrame

                                local newSeatCF =
                                    targetCF
                                    * oldRootCF:ToObjectSpace(
                                        seat.CFrame
                                    )

                                seat.CFrame =
                                    newSeatCF

                                seat.Velocity =
                                    Vector3_new(0, 0, 0)

                                seat.RotVelocity =
                                    Vector3_new(0, 0, 0)

                                task.wait(0.1)

                                Humanoid.Sit = false

                            end

                        end)

                    end

                    task.wait(
                        Settings.TaxiWaitTime
                    )

                end

            end

        end

    end)
end

local function StopAutoBus()

    if AutoBusTask then
        task.cancel(AutoBusTask)
        AutoBusTask = nil
    end

end

-- ============================================================
-- 15. ATM
-- ============================================================

local function ToggleAtmHack(enabled)

    Toggles.AtmHack = enabled

    if enabled then

        if AtmHackTask then
            task.cancel(AtmHackTask)
        end

        AtmHackTask = task.spawn(function()

            while Toggles.AtmHack do

                task.wait(5)

                if not Toggles.AtmHack then
                    break
                end

                if PlayerEvent then

                    pcall(function()

                        PlayerEvent:FireServer(
                            "atmHack"
                        )

                    end)

                end

            end

        end)

        Library:Notify({
            Time = 2,
            Title = "EVA-01 // ATM",
            Description = "自动破解已启动",
        })

    else

        if AtmHackTask then
            task.cancel(AtmHackTask)
            AtmHackTask = nil
        end

        Library:Notify({
            Time = 2,
            Title = "EVA-01 // ATM",
            Description = "自动破解已关闭",
        })

    end
end

-- ============================================================
-- 16. TELEPORT
-- ============================================================

local function TeleportTo(position)

    if not Toggles.Teleport then

        Library:Notify({
            Time = 2,
            Title = "EVA-01 // 传送",
            Description = "请先打开「启用传送」",
        })

        return
    end

    RefreshCharacter()

    if HumanoidRootPart then

        pcall(function()

            HumanoidRootPart.CFrame =
                CFrame_new(position)

        end)

        Library:Notify({
            Time = 1.5,
            Title = "EVA-01 // NERV",
            Description = "传送完成",
        })

    end
end

-- ============================================================
-- 17. BULLET TRACK
-- ============================================================

local OldBulletSpread = nil

local function ToggleBulletTrack(enabled)

    Toggles.BulletTrack = enabled

    if enabled
        and Algorithms
        and type(Algorithms.bulletSpread) == "function"
    then

        if not OldBulletSpread then
            OldBulletSpread =
                Algorithms.bulletSpread
        end

        Algorithms.bulletSpread =
            function(...)

                if Toggles.BulletTrack then
                    -- 子弹追踪逻辑入口
                    -- 保留原始算法，避免破坏游戏
                end

                return OldBulletSpread(...)
            end

    elseif not enabled
        and Algorithms
        and OldBulletSpread
    then

        pcall(function()
            Algorithms.bulletSpread =
                OldBulletSpread
        end)

    end
end

-- ============================================================
-- 18. WINDOW
-- ============================================================

local Window = Library:CreateWindow({

    Title = "EVA-01 // FY HUB",

    Footer =
        "NERV NEURAL TERMINAL // v10.0",

    Icon = EVA_IMAGE,

    -- EVA 图片直接进入 Obsidian 主窗口背景
    BackgroundImage = EVA_IMAGE,

    NotifySide = "Right",

    -- 手机不要 Obsidian 原生 Lock / Toggle
    ShowMobileButtons = false,

    MobileButtonsSide = "Right",

    ShowCustomCursor = false,

    -- UI 稍微小一点
    Size = UDim2.fromOffset(760, 520),

    Center = true,

    -- 低占用：减少不必要动画
    Animations = {
        ToggleWindow = false,
        TabSwitch = false,
        Groupbox = false,
    },

    TabTransitionTime = 0,

    GlobalSearch = true,
})

-- ============================================================
-- 19. EVA THEME
-- ============================================================

ThemeManager:SetLibrary(Library)

SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({
    "MenuKeybind"
})

ThemeManager:SetFolder("FY_HUB")

SaveManager:SetFolder("FY_HUB")

SaveManager:SetSubFolder("Configs")

-- ============================================================
-- 20. THEME FUNCTION
-- ============================================================

local function SetEVATheme()

    local ThemeData = {
        FontColor = EVA.Text,

        MainColor = EVA.Main,

        AccentColor = EVA.PurpleLight,

        BackgroundColor = EVA.Background,

        OutlineColor = EVA.Outline,

        BackgroundImage = EVA_IMAGE,
    }

    for name, color in pairs(ThemeData) do

        if name ~= "BackgroundImage" then

            local option =
                Options[name]

            if option then

                pcall(function()
                    option:SetValue(color)
                end)

            end

        end
    end

    -- 图片背景
    if Options.BackgroundImage then

        pcall(function()

            Options.BackgroundImage:SetValue(
                EVA_IMAGE
            )

        end)

    end

    -- 再强制更新一次
    pcall(function()
        Library:UpdateColorsUsingRegistry()
    end)

    pcall(function()
        Library:SetBackgroundImage(
            EVA_IMAGE
        )
    end)

end

-- ============================================================
-- 21. TABS
-- ============================================================

local TabMain =
    Window:AddTab("主要", "target")

local TabTeleport =
    Window:AddTab("传送点", "map-pin")

local TabSettings =
    Window:AddTab("设置", "settings")

local TabBullet =
    Window:AddTab("子弹追踪", "crosshair")

-- ============================================================
-- 22. MAIN GROUPS
-- ============================================================

local LeftMain =
    TabMain:AddLeftGroupbox(
        "交互设置",
        "hand"
    )

local RightMain =
    TabMain:AddRightGroupbox(
        "战斗系统",
        "target"
    )

local AimGroup =
    TabMain:AddRightGroupbox(
        "自瞄功能",
        "crosshair"
    )

local MoveGroup =
    TabMain:AddRightGroupbox(
        "移动增强",
        "move"
    )

local TaxiGroup =
    TabMain:AddLeftGroupbox(
        "自动赚钱 // 出租车",
        "car"
    )

local BusGroup =
    TabMain:AddLeftGroupbox(
        "自动公交车",
        "bus"
    )

local AtmGroup =
    TabMain:AddLeftGroupbox(
        "ATM自动破解",
        "dollar-sign"
    )

-- ============================================================
-- 23. INTERACTION
-- ============================================================

LeftMain:AddSlider("HoldTime", {

    Min = 0,
    Default = 0,
    Suffix = " 秒",
    Max = 10,

    Text = "交互按住时间",

    Rounding = 0,

    Callback = function(value)

        Settings.HoldTime = value

        for _, obj in ipairs(
            Workspace:GetDescendants()
        ) do

            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = value
            end

        end

    end,
})

LeftMain:AddSlider("Distance", {

    Min = 5,
    Default = 25,
    Suffix = " 单位",
    Max = 150,

    Text = "交互距离",

    Rounding = 0,

    Callback = function(value)

        Settings.Distance = value

        for _, obj in ipairs(
            Workspace:GetDescendants()
        ) do

            if obj:IsA("ProximityPrompt") then
                obj.MaxActivationDistance = value
            end

        end

    end,
})

LeftMain:AddDivider()

LeftMain:AddToggle(
    "NoclipToggle",
    {
        Text = "人物穿墙",
        Default = false,

        Callback = function(value)

            Toggles.Noclip = value

            RefreshCharacter()

            if Character then

                for _, part in ipairs(
                    Character:GetDescendants()
                ) do

                    if part:IsA("BasePart") then
                        part.CanCollide = not value
                    end

                end

            end

        end,
    }
)

-- ============================================================
-- 24. COMBAT
-- ============================================================

RightMain:AddToggle(
    "KillAuraToggle",
    {
        Text = "杀戮光环",
        Default = false,

        Callback = function(value)
            ToggleKillAura(value)
        end,
    }
)

RightMain:AddSlider(
    "KillAuraRange",
    {
        Min = 1,
        Default = 50,
        Suffix = " 单位",
        Max = 1000,

        Text = "光环距离",

        Rounding = 0,

        Callback = function(value)
            Settings.KillAuraRange = value
        end,
    }
)

RightMain:AddToggle(
    "HitboxToggle",
    {
        Text = "扩大头部碰撞箱",
        Default = false,

        Callback = function(value)

            Toggles.Hitbox = value

            if value then
                ApplyHitbox(
                    Settings.HitboxSize
                )
            else
                ResetHitbox()
            end

        end,
    }
)

RightMain:AddSlider(
    "HitboxSize",
    {
        Min = 5,
        Default = 10,
        Suffix = " 单位",
        Max = 40,

        Text = "头部大小",

        Rounding = 0,

        Callback = function(value)

            Settings.HitboxSize = value

            if Toggles.Hitbox then
                ApplyHitbox(value)
            end

        end,
    }
)

RightMain:AddToggle(
    "WhitelistToggle",
    {
        Text = "好友白名单",
        Default = false,

        Callback = function(value)

            Toggles.Whitelist = value

            if value then
                UpdateWhitelist()
            end

        end,
    }
)

-- ============================================================
-- 25. AIM
-- ============================================================

AimGroup:AddToggle(
    "AimToggle",
    {
        Text = "启用自瞄",
        Default = false,

        Callback = function(value)
            Toggles.Aim = value
        end,
    }
)

AimGroup:AddSlider(
    "AimSmoothness",
    {
        Min = 1,
        Default = 5,
        Max = 20,

        Text = "自瞄平滑度",

        Rounding = 0,

        Callback = function(value)
            Settings.AimSmoothness = value
        end,
    }
)

AimGroup:AddSlider(
    "AimMaxDistance",
    {
        Min = 50,
        Default = 200,
        Suffix = " 单位",
        Max = 500,

        Text = "最大检测距离",

        Rounding = 0,

        Callback = function(value)
            Settings.AimMaxDistance = value
        end,
    }
)

AimGroup:AddToggle(
    "AimCheckWall",
    {
        Text = "墙壁检测",
        Default = true,

        Callback = function(value)
            Settings.AimCheckWall = value
        end,
    }
)

-- ============================================================
-- 26. MOVEMENT
-- ============================================================

MoveGroup:AddToggle(
    "NoDizzinessToggle",
    {
        Text = "无眩晕 / 移动增强",
        Default = false,

        Callback = function(value)

            Toggles.NoDizziness = value

            if value then
                StartNoDizziness()
            else
                StopNoDizziness()
            end

        end,
    }
)

MoveGroup:AddSlider(
    "NoDizzinessSpeed",
    {
        Min = 5,
        Default = 24,
        Suffix = " stud/s",
        Max = 80,

        Text = "移动速度",

        Rounding = 0,

        Callback = function(value)
            Settings.NoDizzinessSpeed = value
        end,
    }
)

-- ============================================================
-- 27. ESP PLACEHOLDER
-- ============================================================

local ESPGroup =
    TabMain:AddLeftGroupbox(
        "EVA视觉系统",
        "eye"
    )

ESPGroup:AddToggle(
    "SkeletonToggle",
    {
        Text = "ESP透视",
        Default = false,

        Callback = function(value)
            -- ESP接口
        end,
    }
)

ESPGroup:AddLabel(
    "EVA-01 // VISUAL SYSTEM"
)

-- ============================================================
-- 28. TAXI
-- ============================================================

TaxiGroup:AddToggle(
    "TaxiToggle",
    {
        Text = "出租车自动循环",
        Default = false,

        Callback = function(value)
            ToggleTaxi(value)
        end,
    }
)

TaxiGroup:AddSlider(
    "TaxiWaitTime",
    {
        Min = 1,
        Default = 7,
        Suffix = " 秒",
        Max = 30,

        Text = "每个地点等待",

        Rounding = 0,

        Callback = function(value)
            Settings.TaxiWaitTime = value
        end,
    }
)

-- ============================================================
-- 29. BUS
-- ============================================================

BusGroup:AddToggle(
    "AutoBusToggle",
    {
        Text = "自动公交循环",
        Default = false,

        Callback = function(value)

            Toggles.AutoBus = value

            if value then

                StartAutoBus()

                Library:Notify({
                    Time = 2,
                    Title = "EVA-01 // BUS",
                    Description = "自动公交已启动",
                })

            else

                StopAutoBus()

                Library:Notify({
                    Time = 2,
                    Title = "EVA-01 // BUS",
                    Description = "自动公交已停止",
                })

            end

        end,
    }
)

-- ============================================================
-- 30. ATM
-- ============================================================

AtmGroup:AddToggle(
    "AtmHackToggle",
    {
        Text = "ATM自动破解",
        Default = false,

        Callback = function(value)
            ToggleAtmHack(value)
        end,
    }
)

AtmGroup:AddLabel(
    "周期：5 秒 / 次"
)

-- ============================================================
-- 31. TELEPORT
-- ============================================================

local TeleLeft =
    TabTeleport:AddLeftGroupbox(
        "传送控制",
        "navigation"
    )

TeleLeft:AddToggle(
    "TeleportToggle",
    {
        Text = "启用传送",
        Default = false,

        Callback = function(value)
            Toggles.Teleport = value
        end,
    }
)

local function AddTeleportButton(
    group,
    name,
    pos
)

    group:AddButton({
        Text = name,

        Func = function()
            TeleportTo(pos)
        end,
    })

end

-- ============================================================
-- 32. TELEPORT DATA
-- ============================================================

local TeleportGroups = {

    {
        Side = "Left",
        Name = "其他",

        Points = {

            {"黑色市场",
                1038.969849, -22.73295, 895.430237},

            {"鱼夫码头",
                -50.147552, -24.555279, 1462.145996},

            {"农场",
                -1268.339233, 2.572412, 2560.060303},

            {"监狱门口",
                -1697.931885, 2.630666, 1284.567383},

            {"监狱广场",
                -1600.602417, 2.631028, 1268.060059},

            {"代尔山",
                847.062988, 194.115753, -326.212708},

            {"水帘洞(消星点)",
                3040.956055, 109.688538, 2711.069336},

            {"大桥",
                949.014954, 25.215754, 2897.654785},

            {"地图右下(消星点)",
                -1651.38501, 2.414712, 3225.27832},

            {"下部加油站",
                2270.378174, 2.630927, 154.161484},

            {"游戏厅",
                2934.893799, 2.956458, 1693.660034},

            {"高尔夫",
                2280.76709, 3.037836, 1982.3573},

            {"修船厂",
                4096.405273, -30.401447, 2865.045166},
        },
    },

    {
        Side = "Right",
        Name = "圣奥里",

        Points = {

            {"车辆经销商",
                3719.950195, 3.018573, -333.311859},

            {"医院",
                3980.091064, 2.876061, -138.794540},

            {"警察局",
                3364.273193, 3.918808, -394.723358},

            {"圣奥里修车店",
                2782.468750, 2.630996, -418.599304},

            {"圣奥里银行",
                3134.054199, 6.116048, -171.369766},

            {"圣奥里服装店",
                3617.912598, 3.107221, -452.820648},

            {"圣奥里平民重生",
                3741.114990, 3.720574, -438.105988},

            {"圣奥里码头",
                4527.656250, -23.968239, -280.593567},

            {"圣奥里餐饮店",
                3182.416748, 3.018592, 426.517914},

            {"消防部门",
                3578.676025, 8.408823, 579.656799},

            {"宠物店",
                3678.237305, 3.017920, 693.114624},

            {"圣奥里大码头",
                2736.307617, 2.630299, -1120.333008},

            {"圣奥里海滩桥下(消星点)",
                3964.504395, -25.068211, -854.057251},
        },
    },

    {
        Side = "Left",
        Name = "大景",

        Points = {

            {"大景超级超市",
                3936.582764, 3.038293, 1136.326416},

            {"转镜中心",
                4152.919922, 2.631675, 941.446045},

            {"道路服务",
                4271.332520, 2.628108, 1200.086914},

            {"大景餐饮店",
                4476.997559, 3.037825, 906.802979},

            {"送货中心(美团外卖)",
                4399.419434, 3.038999, 1609.455933},

            {"大景卖车店",
                3434.377441, 42.931786, 2687.997070},
        },
    },

    {
        Side = "Right",
        Name = "米尔顿",

        Points = {

            {"米尔顿左上加油站",
                1145.635742, 2.630916, -864.273682},

            {"米尔顿右下加油站",
                -1646.802734, 2.630164, 1812.894653},

            {"米尔顿上方加油站",
                -900.701660, 2.630927, 1124.683105},

            {"米尔顿居民区",
                -528.565552, 2.630996, 1331.981689},
        },
    },

    {
        Side = "Left",
        Name = "约克镇",

        Points = {

            {"约克镇小银行",
                -668.217224, 2.630995, -65.347839},

            {"约克镇修车厂",
                -407.163025, 3.076807, -6.098211},

            {"约克镇枪店",
                -323.869293, 3.037825, 37.149670},

            {"约克镇重生点",
                -219.560318, 3.039824, -85.725433},

            {"约克镇当铺",
                -168.513733, 3.039000, -106.926529},

            {"约克镇卫星车",
                -302.093567, 3.037825, -167.621017},

            {"约克镇中心点",
                -275.995209, 2.630996, -139.985352},
        },
    },

    {
        Side = "Right",
        Name = "莱斯维尔",

        Points = {

            {"莱斯维尔餐饮店",
                753.757812, 3.039824, 998.132996},

            {"莱斯维尔服装店",
                820.745117, 2.766988, 1047.445679},

            {"莱斯维尔自由广场",
                926.523376, 2.630996, 865.764771},

            {"莱斯维尔码头(游艇)",
                947.840210, -22.529087, 1216.085693},
        },
    },
}

-- ============================================================
-- 33. BUILD TELEPORTS
-- ============================================================

for _, data in ipairs(TeleportGroups) do

    local group

    if data.Side == "Left" then

        group =
            TabTeleport:AddLeftGroupbox(
                data.Name,
                "map-pin"
            )

    else

        group =
            TabTeleport:AddRightGroupbox(
                data.Name,
                "map-pin"
            )

    end

    for _, point in ipairs(data.Points) do

        AddTeleportButton(
            group,
            point[1],
            Vector3_new(
                point[2],
                point[3],
                point[4]
            )
        )

    end
end

-- ============================================================
-- 34. SETTINGS
-- ============================================================

local SetLeft =
    TabSettings:AddLeftGroupbox(
        "EVA-01 // 菜单设置",
        "settings"
    )

SetLeft:AddDropdown(
    "AnimeThemeSelector",
    {
        Values = {
            "EVA-01 初号机",
            "EVA-02 二号机",
            "Cyberpunk",
            "Genshin",
        },

        Default = 1,

        Text = "选择 UI 主题",

        Callback = function(value)

            if value == "EVA-01 初号机" then

                SetEVATheme()

            elseif value == "EVA-02 二号机" then

                if Options.AccentColor then
                    Options.AccentColor:SetValue(
                        FromRGB(255, 75, 55)
                    )
                end

                if Options.MainColor then
                    Options.MainColor:SetValue(
                        FromRGB(80, 28, 30)
                    )
                end

                if Options.BackgroundColor then
                    Options.BackgroundColor:SetValue(
                        FromRGB(35, 17, 20)
                    )
                end

            elseif value == "Cyberpunk" then

                if Options.AccentColor then
                    Options.AccentColor:SetValue(
                        FromRGB(0, 255, 255)
                    )
                end

                if Options.MainColor then
                    Options.MainColor:SetValue(
                        FromRGB(22, 30, 45)
                    )
                end

                if Options.BackgroundColor then
                    Options.BackgroundColor:SetValue(
                        FromRGB(12, 20, 30)
                    )
                end

            elseif value == "Genshin" then

                if Options.AccentColor then
                    Options.AccentColor:SetValue(
                        FromRGB(70, 205, 100)
                    )
                end

                if Options.MainColor then
                    Options.MainColor:SetValue(
                        FromRGB(30, 55, 35)
                    )
                end

                if Options.BackgroundColor then
                    Options.BackgroundColor:SetValue(
                        FromRGB(17, 30, 20)
                    )
                end

            end

            Library:Notify({
                Time = 2,
                Title = "EVA-01 // Theme",
                Description = "主题已切换：" .. value,
            })

        end,
    }
)

SetLeft:AddToggle(
    "ShowCustomCursor",
    {
        Text = "自定义光标",
        Default = false,

        Callback = function(value)

            Library.ShowCustomCursor = value
            Toggles.ShowCustomCursor = value

        end,
    }
)

SetLeft:AddDivider()

SetLeft:AddLabel(
    "EVA-01 // NEURAL CONNECTION"
)

SetLeft:AddLabel(
    "紫色：初号机神经系统"
)

SetLeft:AddLabel(
    "绿色：暴走 / 启动状态"
)

SetLeft:AddDivider()

SetLeft:AddButton({
    Text = "卸载 FY HUB",

    Func = function()

        Library:Unload()

    end,

    Risky = true,
})

-- ============================================================
-- 35. THEME MANAGER
-- ============================================================

ThemeManager:ApplyToTab(
    TabSettings
)

SaveManager:BuildConfigSection(
    TabSettings
)

-- ============================================================
-- 36. BULLET TAB
-- ============================================================

local BulletGroup =
    TabBullet:AddLeftGroupbox(
        "EVA-01 // 子弹追踪",
        "target"
    )

BulletGroup:AddToggle(
    "BulletTrackToggle",
    {
        Text = "启用子弹追踪",
        Default = false,

        Callback = function(value)
            ToggleBulletTrack(value)
        end,
    }
)

BulletGroup:AddDivider()

BulletGroup:AddToggle(
    "ScreenPriority",
    {
        Text = "屏幕中心优先",
        Default = true,

        Callback = function(value)
            Toggles.ScreenPriority = value
        end,
    }
)

BulletGroup:AddToggle(
    "DistancePriority",
    {
        Text = "距离优先",
        Default = false,

        Callback = function(value)
            Toggles.DistancePriority = value
        end,
    }
)

-- ============================================================
-- 37. LOAD SAVED CONFIG
-- ============================================================

ThemeManager:SetFolder("FY_HUB")

SaveManager:SetFolder("FY_HUB")
SaveManager:SetSubFolder("Configs")

SaveManager:LoadAutoloadConfig()

-- ============================================================
-- 38. FORCE EVA-01 THEME
-- ============================================================

task.defer(function()

    task.wait(0.25)

    pcall(function()
        SetEVATheme()
    end)

end)

-- ============================================================
-- 39. CHARACTER EVENTS
-- ============================================================

LocalPlayer.CharacterAdded:Connect(
    function(newChar)

        Character = newChar

        task.wait(0.35)

        RefreshCharacter()

        if Toggles.Noclip then

            for _, part in ipairs(
                newChar:GetDescendants()
            ) do

                if part:IsA("BasePart") then
                    part.CanCollide = false
                end

            end

        end

        if Toggles.Hitbox then
            ApplyHitbox(
                Settings.HitboxSize
            )
        end

        if Toggles.KillAura then
            StartKillAura()
        end

        if Toggles.NoDizziness then
            StartNoDizziness()
        end

        if Toggles.AutoBus then
            StartAutoBus()
        end

        if Toggles.Taxi then
            ToggleTaxi(true)
        end

    end
)

-- ============================================================
-- 40. PROXIMITY PROMPT OPTIMIZATION
-- ============================================================

Workspace.DescendantAdded:Connect(
    function(desc)

        if desc:IsA("ProximityPrompt") then

            desc.HoldDuration =
                Settings.HoldTime

            desc.MaxActivationDistance =
                Settings.Distance

        end

    end
)

-- ============================================================
-- 41. PLAYER EVENTS
-- ============================================================

Players.PlayerAdded:Connect(
    function(player)

        if Toggles.Whitelist then

            task.delay(1, function()

                pcall(function()

                    if player:IsFriendsWith(
                        LocalPlayer.UserId
                    ) then

                        FriendWhitelist[
                            player.UserId
                        ] = true

                    end

                end)

            end)

        end

    end
)

Players.PlayerRemoving:Connect(
    function(player)

        FriendWhitelist[
            player.UserId
        ] = nil

    end
)

-- ============================================================
-- 42. SMALL EVA-01 DYNAMIC ISLAND
-- ============================================================

local OldIsland =
    PlayerGui:FindFirstChild(
        "FY_EVA01_DynamicIsland"
    )

if OldIsland then
    OldIsland:Destroy()
end

local IslandGui = Instance.new("ScreenGui")
IslandGui.Name = "FY_EVA01_DynamicIsland"
IslandGui.ResetOnSpawn = false
IslandGui.IgnoreGuiInset = true
IslandGui.DisplayOrder = 100000
IslandGui.Parent = PlayerGui

-- 小尺寸
local Island = Instance.new("Frame")

Island.Name = "EVA01Island"

Island.Size =
    UDim2.fromOffset(190, 46)

Island.Position =
    UDim2.new(0.5, 0, 0.5, -170)

Island.AnchorPoint =
    Vector2.new(0.5, 0.5)

Island.BackgroundColor3 =
    FromRGB(18, 14, 26)

Island.BorderSizePixel = 0

Island.Parent = IslandGui

local IslandCorner =
    Instance.new("UICorner")

IslandCorner.CornerRadius =
    UDim.new(1, 0)

IslandCorner.Parent =
    Island

local IslandStroke =
    Instance.new("UIStroke")

IslandStroke.Color =
    EVA.PurpleLight

IslandStroke.Thickness = 1.5

IslandStroke.Transparency = 0.1

IslandStroke.Parent =
    Island

-- 左侧 EVA 图片
local IslandImage =
    Instance.new("ImageLabel")

IslandImage.Size =
    UDim2.fromOffset(30, 30)

IslandImage.Position =
    UDim2.fromOffset(8, 8)

IslandImage.BackgroundTransparency = 1

IslandImage.Image =
    EVA_IMAGE

IslandImage.ScaleType =
    Enum.ScaleType.Fit

IslandImage.Parent =
    Island

local ImageCorner =
    Instance.new("UICorner")

ImageCorner.CornerRadius =
    UDim.new(1, 0)

ImageCorner.Parent =
    IslandImage

-- 状态灯
local Status =
    Instance.new("Frame")

Status.Size =
    UDim2.fromOffset(7, 7)

Status.Position =
    UDim2.fromOffset(45, 10)

Status.BackgroundColor3 =
    EVA.Green

Status.BorderSizePixel = 0

Status.Parent =
    Island

local StatusCorner =
    Instance.new("UICorner")

StatusCorner.CornerRadius =
    UDim.new(1, 0)

StatusCorner.Parent =
    Status

-- 主文字
local IslandTitle =
    Instance.new("TextLabel")

IslandTitle.Size =
    UDim2.fromOffset(110, 20)

IslandTitle.Position =
    UDim2.fromOffset(54, 9)

IslandTitle.BackgroundTransparency = 1

IslandTitle.Text =
    "EVA-01 // FY HUB"

IslandTitle.TextColor3 =
    EVA.Text

IslandTitle.TextSize = 11

IslandTitle.Font =
    Enum.Font.GothamBold

IslandTitle.TextXAlignment =
    Enum.TextXAlignment.Left

IslandTitle.Parent =
    Island

-- 状态文字
local IslandStatus =
    Instance.new("TextLabel")

IslandStatus.Size =
    UDim2.fromOffset(110, 14)

IslandStatus.Position =
    UDim2.fromOffset(54, 25)

IslandStatus.BackgroundTransparency = 1

IslandStatus.Text =
    "NEURAL LINK // ONLINE"

IslandStatus.TextColor3 =
    EVA.Green

IslandStatus.TextSize = 8

IslandStatus.Font =
    Enum.Font.Code

IslandStatus.TextXAlignment =
    Enum.TextXAlignment.Left

IslandStatus.Parent =
    Island

-- 右侧按钮
local IslandButton =
    Instance.new("TextButton")

IslandButton.Size =
    UDim2.fromOffset(28, 28)

IslandButton.Position =
    UDim2.new(1, -35, 0.5, -14)

IslandButton.BackgroundColor3 =
    EVA.PurpleDark

IslandButton.BorderSizePixel = 0

IslandButton.Text =
    "≡"

IslandButton.TextColor3 =
    EVA.Green

IslandButton.TextSize =
    19

IslandButton.Font =
    Enum.Font.GothamBold

IslandButton.AutoButtonColor =
    false

IslandButton.Parent =
    Island

local IslandButtonCorner =
    Instance.new("UICorner")

IslandButtonCorner.CornerRadius =
    UDim.new(1, 0)

IslandButtonCorner.Parent =
    IslandButton

local IslandButtonStroke =
    Instance.new("UIStroke")

IslandButtonStroke.Color =
    EVA.PurpleLight

IslandButtonStroke.Thickness =
    1

IslandButtonStroke.Parent =
    IslandButton

-- ============================================================
-- 43. DYNAMIC ISLAND CLICK
-- ============================================================

local function UpdateIsland()

    if Library.Toggled then

        IslandStatus.Text =
            "TERMINAL // OPEN"

        IslandStatus.TextColor3 =
            EVA.Green

        Status.BackgroundColor3 =
            EVA.Green

        IslandStroke.Color =
            EVA.Green

        IslandButton.Text =
            "×"

    else

        IslandStatus.Text =
            "NEURAL LINK // READY"

        IslandStatus.TextColor3 =
            EVA.PurpleLight

        Status.BackgroundColor3 =
            EVA.PurpleLight

        IslandStroke.Color =
            EVA.PurpleLight

        IslandButton.Text =
            "≡"

    end

end

IslandButton.MouseButton1Click:Connect(
    function()

        Library:Toggle()

        task.defer(
            UpdateIsland
        )

    end
)

Island.MouseEnter:Connect(
    function()

        IslandButton.BackgroundColor3 =
            EVA.Purple

    end
)

Island.MouseLeave:Connect(
    function()

        IslandButton.BackgroundColor3 =
            EVA.PurpleDark

    end
)

-- ============================================================
-- 44. ISLAND DRAG
-- ============================================================

local dragging = false
local dragStart
local startPos

Island.InputBegan:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.Touch
            or input.UserInputType ==
            Enum.UserInputType.MouseButton1
        then

            dragging = true

            dragStart =
                input.Position

            startPos =
                Island.Position

            input.Changed:Connect(
                function()

                    if input.UserInputState ==
                        Enum.UserInputState.End
                    then
                        dragging = false
                    end

                end
            )

        end

    end
)

UserInputService.InputChanged:Connect(
    function(input)

        if not dragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or input.UserInputType ==
            Enum.UserInputType.Touch
        then

            local delta =
                input.Position - dragStart

            Island.Position =
                UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

        end

    end
)

-- ============================================================
-- 45. INITIAL ISLAND STATE
-- ============================================================

task.defer(function()

    task.wait(0.5)

    UpdateIsland()

end)

-- ============================================================
-- 46. FINAL
-- ============================================================

print(
    "========================================"
)

print(
    "EVA-01 // FY HUB"
)

print(
    "NEURAL CONNECTION ONLINE"
)

print(
    "Purple-Green EVA Theme Loaded"
)

print(
    "Dynamic Island Loaded"
)

print(
    "Low Memory UI Mode"
)

print(
    "========================================"
)
