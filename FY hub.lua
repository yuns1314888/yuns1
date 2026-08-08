-- ============================================================
-- FY HUB v9.2
-- EVA-01 // NERV NEURAL TERMINAL
-- EVA-01 紫绿 UI + 灵动岛悬浮开关完整版
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local FromRGB = Color3.fromRGB
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new

-- ============================================================
-- 1. 卡密系统
-- ============================================================

local CorrectKey = "FYNB666"
local KeyPassed = false

if PlayerGui:FindFirstChild("FY_NativeKeySystem") then
    PlayerGui.FY_NativeKeySystem:Destroy()
end

local KeyScreenGui = Instance.new("ScreenGui")
KeyScreenGui.Name = "FY_NativeKeySystem"
KeyScreenGui.ResetOnSpawn = false
KeyScreenGui.IgnoreGuiInset = true
KeyScreenGui.DisplayOrder = 999
KeyScreenGui.Parent = PlayerGui

local KeyMainFrame = Instance.new("Frame")
KeyMainFrame.Size = UDim2.new(0, 390, 0, 230)
KeyMainFrame.Position = UDim2.new(0.5, -195, 0.5, -115)
KeyMainFrame.BackgroundColor3 = FromRGB(48, 25, 60)
KeyMainFrame.BorderSizePixel = 0
KeyMainFrame.Parent = KeyScreenGui

local KeyGradient = Instance.new("UIGradient")
KeyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, FromRGB(65, 30, 82)),
    ColorSequenceKeypoint.new(0.55, FromRGB(45, 24, 58)),
    ColorSequenceKeypoint.new(1, FromRGB(28, 48, 30))
})
KeyGradient.Rotation = 25
KeyGradient.Parent = KeyMainFrame

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 16)
KeyCorner.Parent = KeyMainFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = FromRGB(145, 45, 235)
KeyStroke.Thickness = 2
KeyStroke.Parent = KeyMainFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -30, 0, 50)
KeyTitle.Position = UDim2.new(0, 15, 0, 8)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "EVA-01  //  FY HUB"
KeyTitle.TextColor3 = FromRGB(190, 255, 90)
KeyTitle.TextSize = 21
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.Parent = KeyMainFrame

local KeySubtitle = Instance.new("TextLabel")
KeySubtitle.Size = UDim2.new(1, -30, 0, 25)
KeySubtitle.Position = UDim2.new(0, 15, 0, 50)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "NERV NEURAL CONNECTION TERMINAL"
KeySubtitle.TextColor3 = FromRGB(225, 205, 235)
KeySubtitle.TextSize = 11
KeySubtitle.Font = Enum.Font.GothamMedium
KeySubtitle.Parent = KeyMainFrame

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Size = UDim2.new(0.86, 0, 0, 45)
KeyTextBox.Position = UDim2.new(0.07, 0, 0.39, 0)
KeyTextBox.BackgroundColor3 = FromRGB(28, 18, 35)
KeyTextBox.TextColor3 = FromRGB(255, 255, 255)
KeyTextBox.PlaceholderColor3 = FromRGB(160, 135, 170)
KeyTextBox.PlaceholderText = "请输入授权卡密"
KeyTextBox.Text = ""
KeyTextBox.TextSize = 14
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.ClearTextOnFocus = false
KeyTextBox.Parent = KeyMainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 9)
BoxCorner.Parent = KeyTextBox

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = FromRGB(105, 40, 145)
BoxStroke.Thickness = 1
BoxStroke.Parent = KeyTextBox

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.86, 0, 0, 42)
SubmitBtn.Position = UDim2.new(0.07, 0, 0.69, 0)
SubmitBtn.BackgroundColor3 = FromRGB(125, 40, 200)
SubmitBtn.TextColor3 = FromRGB(255, 255, 255)
SubmitBtn.Text = "验证并进入"
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.BorderSizePixel = 0
SubmitBtn.Parent = KeyMainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 9)
BtnCorner.Parent = SubmitBtn

local BtnGradient = Instance.new("UIGradient")
BtnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, FromRGB(140, 45, 225)),
    ColorSequenceKeypoint.new(1, FromRGB(65, 175, 55))
})
BtnGradient.Parent = SubmitBtn

SubmitBtn.MouseButton1Click:Connect(function()

    if KeyTextBox.Text == CorrectKey then

        KeyPassed = true

        SubmitBtn.Text = "✓ NERV 授权成功"
        SubmitBtn.BackgroundColor3 = FromRGB(65, 190, 70)

        task.wait(0.35)

        KeyScreenGui:Destroy()

    else

        SubmitBtn.Text = "卡密错误"
        SubmitBtn.BackgroundColor3 = FromRGB(200, 50, 70)

        task.wait(1.2)

        SubmitBtn.Text = "验证并进入"
        SubmitBtn.BackgroundColor3 = FromRGB(125, 40, 200)

    end
end)

KeyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        SubmitBtn:Activate()
    end
end)

while not KeyPassed do
    task.wait(0.2)
end

-- ============================================================
-- 2. 游戏加载
-- ============================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ============================================================
-- 3. Remote
-- ============================================================

local PlayerEvent = nil

pcall(function()

    local remoteFolder =
        ReplicatedStorage:WaitForChild("Remote", 3)

    if remoteFolder then
        PlayerEvent =
            remoteFolder:WaitForChild("PlayerEvent", 3)
    end

end)

local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Algorithms = nil

pcall(function()

    if Modules then

        Algorithms =
            require(
                Modules:WaitForChild("Algorithms", 3)
            )

    end

end)

-- ============================================================
-- 4. Obsidian
-- ============================================================

local Repo =
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Library =
    loadstring(game:HttpGet(Repo .. "Library.lua"))()

local ThemeManager =
    loadstring(
        game:HttpGet(
            Repo .. "addons/ThemeManager.lua"
        )
    )()

local SaveManager =
    loadstring(
        game:HttpGet(
            Repo .. "addons/SaveManager.lua"
        )
    )()

local Options = Library.Options
local LibraryToggles = Library.Toggles

-- ============================================================
-- 5. EVA-01 默认主题
-- 必须在 ThemeManager:ApplyToTab 前设置
-- ============================================================

local EVA01Theme = {

    FontColor = FromRGB(
        238, 235, 242
    ),

    MainColor = FromRGB(
        58, 29, 72
    ),

    AccentColor = FromRGB(
        145, 45, 235
    ),

    BackgroundColor = FromRGB(
        30, 17, 40
    ),

    OutlineColor = FromRGB(
        105, 40, 145
    ),

    FontFace = Enum.Font.Gotham,

}

pcall(function()
    ThemeManager:SetDefaultTheme(EVA01Theme)
end)

-- ============================================================
-- 6. 状态
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
-- 7. 核心功能
-- ============================================================

function ApplyHitbox(size)

    size = size or Settings.HitboxSize

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer then

            local char = player.Character

            if char then

                local head =
                    char:FindFirstChild("Head")

                local hum =
                    char:FindFirstChildOfClass("Humanoid")

                if hum
                    and hum.Health > 0
                    and head then

                    head.Size =
                        Vector3_new(
                            size,
                            size,
                            size
                        )

                    head.Transparency = 1

                    head.Color =
                        FromRGB(
                            175,
                            255,
                            70
                        )

                    head.Material =
                        Enum.Material.Neon

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

                local head =
                    char:FindFirstChild("Head")

                if head then

                    head.Size =
                        Vector3_new(
                            2,
                            2,
                            2
                        )

                    head.Transparency = 0

                    head.Color =
                        FromRGB(
                            255,
                            255,
                            255
                        )

                    head.Material =
                        Enum.Material.SmoothPlastic

                    head.CanCollide = true

                end
            end
        end
    end
end

function UpdateWhitelist()

    FriendWhitelist = {}

    local userId =
        LocalPlayer.UserId

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

function StartKillAura()

    if KillAuraConnection then
        KillAuraConnection:Disconnect()
    end

    KillAuraConnection =
        RunService.Heartbeat:Connect(function()

            if not Toggles.KillAura then
                return
            end

            local char =
                LocalPlayer.Character

            if not char then
                return
            end

            local root =
                char:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not root then
                return
            end

            for _, player in ipairs(
                Players:GetPlayers()
            ) do

                if player ~= LocalPlayer then

                    if Toggles.Whitelist
                        and FriendWhitelist[player.UserId] then

                        continue

                    end

                    local targetChar =
                        player.Character

                    if targetChar then

                        local targetRoot =
                            targetChar:FindFirstChild(
                                "HumanoidRootPart"
                            )

                        local targetHum =
                            targetChar:FindFirstChildOfClass(
                                "Humanoid"
                            )

                        if targetRoot
                            and targetHum
                            and targetHum.Health > 0 then

                            local dist =
                                (
                                    targetRoot.Position
                                    -
                                    root.Position
                                ).Magnitude

                            if dist <=
                                Settings.KillAuraRange then

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

function ToggleKillAura(enabled)

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
        end

        KillAuraConnection = nil

    end
end

function StartNoDizziness()

    if NoDizzinessConnection then
        NoDizzinessConnection:Disconnect()
    end

    NoDizzinessConnection =
        RunService.RenderStepped:Connect(
            function()

                if not Toggles.NoDizziness then
                    return
                end

                local char =
                    LocalPlayer.Character

                if not char then
                    return
                end

                local hum =
                    char:FindFirstChild(
                        "Humanoid"
                    )

                local root =
                    char:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if hum and root then

                    local moveDir =
                        hum.MoveDirection

                    if moveDir.Magnitude > 0 then

                        local speed =
                            Settings.NoDizzinessSpeed

                        root.AssemblyLinearVelocity =
                            Vector3_new(
                                moveDir.X * speed,
                                root.AssemblyLinearVelocity.Y,
                                moveDir.Z * speed
                            )

                    end
                end
            end
        )
end

function StopNoDizziness()

    if NoDizzinessConnection then

        NoDizzinessConnection:Disconnect()

        NoDizzinessConnection = nil

    end
end

-- ============================================================
-- 出租车
-- ============================================================

function ToggleTaxi(enabled)

    Toggles.Taxi = enabled

    if enabled then

        if TaxiTask then
            task.cancel(TaxiTask)
        end

        TaxiTask =
            task.spawn(function()

                while Toggles.Taxi do

                    local areas = {}

                    local gameplay =
                        Workspace:FindFirstChild(
                            "Gameplay"
                        )

                    local entities =
                        gameplay
                        and gameplay:FindFirstChild(
                            "Entities"
                        )

                    local clientContent =
                        entities
                        and entities:FindFirstChild(
                            "ClientContent"
                        )

                    local searchRoot =
                        clientContent
                        or Workspace

                    for _, obj in ipairs(
                        searchRoot:GetDescendants()
                    ) do

                        if obj.Name == "Area" then
                            table.insert(
                                areas,
                                obj
                            )
                        end

                    end

                    if #areas == 0 then

                        task.wait(5)

                    else

                        for _, area in ipairs(areas) do

                            if not Toggles.Taxi then
                                break
                            end

                            local char =
                                LocalPlayer.Character

                            if not char then
                                break
                            end

                            local root =
                                char:FindFirstChild(
                                    "HumanoidRootPart"
                                )

                            if root then

                                pcall(function()

                                    root.CFrame =
                                        area.CFrame
                                        *
                                        CFrame_new(
                                            0,
                                            0,
                                            5
                                        )

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
            Title = "EVA-01",
            Description = "出租车自动循环已开启"
        })

    else

        if TaxiTask then

            task.cancel(TaxiTask)

            TaxiTask = nil

        end
    end
end

-- ============================================================
-- 公交
-- ============================================================

function StartAutoBus()

    if AutoBusTask then
        task.cancel(AutoBusTask)
    end

    AutoBusTask =
        task.spawn(function()

            while Toggles.AutoBus do

                local areas = {}

                local gameplay =
                    Workspace:FindFirstChild(
                        "Gameplay"
                    )

                local entities =
                    gameplay
                    and gameplay:FindFirstChild(
                        "Entities"
                    )

                local clientContent =
                    entities
                    and entities:FindFirstChild(
                        "ClientContent"
                    )

                local searchRoot =
                    clientContent
                    or Workspace

                for _, obj in ipairs(
                    searchRoot:GetDescendants()
                ) do

                    if obj.Name == "Area" then

                        table.insert(
                            areas,
                            obj
                        )

                    end
                end

                if #areas == 0 then

                    task.wait(5)

                else

                    for _, area in ipairs(areas) do

                        if not Toggles.AutoBus then
                            break
                        end

                        local char =
                            LocalPlayer.Character

                        if not char then
                            break
                        end

                        local root =
                            char:FindFirstChild(
                                "HumanoidRootPart"
                            )

                        local hum =
                            char:FindFirstChild(
                                "Humanoid"
                            )

                        if root and hum then

                            local targetCF =
                                (
                                    area.CFrame
                                    *
                                    CFrame_new(
                                        3,
                                        3,
                                        16
                                    )
                                )
                                *
                                CFrame.Angles(
                                    0,
                                    math.pi,
                                    0
                                )

                            pcall(function()

                                local seat =
                                    hum.SeatPart

                                if seat then

                                    local oldRootCF =
                                        root.CFrame

                                    local newSeatCF =
                                        targetCF
                                        *
                                        oldRootCF:ToObjectSpace(
                                            seat.CFrame
                                        )

                                    seat.CFrame =
                                        newSeatCF

                                    seat.Velocity =
                                        Vector3_new(
                                            0,
                                            0,
                                            0
                                        )

                                    seat.RotVelocity =
                                        Vector3_new(
                                            0,
                                            0,
                                            0
                                        )

                                    task.wait(0.1)

                                    hum.Sit = false

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

function StopAutoBus()

    if AutoBusTask then

        task.cancel(AutoBusTask)

        AutoBusTask = nil

    end
end

-- ============================================================
-- ATM
-- ============================================================

function ToggleAtmHack(enabled)

    Toggles.AtmHack = enabled

    if enabled then

        if AtmHackTask then
            task.cancel(AtmHackTask)
        end

        AtmHackTask =
            task.spawn(function()

                while Toggles.AtmHack do

                    task.wait(5)

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
            Title = "EVA-01",
            Description = "ATM自动破解已开启"
        })

    else

        if AtmHackTask then

            task.cancel(AtmHackTask)

            AtmHackTask = nil

        end

        Library:Notify({
            Time = 2,
            Title = "EVA-01",
            Description = "ATM自动破解已关闭"
        })

    end
end

-- ============================================================
-- 传送
-- ============================================================

function TeleportTo(position)

    if not Toggles.Teleport then

        Library:Notify({
            Time = 2,
            Title = "传送",
            Description = "请先开启传送开关"
        })

        return
    end

    local char =
        LocalPlayer.Character

    if not char then
        return
    end

    local root =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if root then

        pcall(function()

            root.CFrame =
                CFrame_new(position)

        end)

        Library:Notify({
            Time = 2,
            Title = "传送",
            Description = "已传送"
        })

    end
end

-- ============================================================
-- 子弹追踪
-- ============================================================

function ToggleBulletTrack(enabled)

    Toggles.BulletTrack = enabled

    if enabled and Algorithms then

        pcall(function()

            local old =
                Algorithms.bulletSpread

            if old then

                Algorithms.bulletSpread =
                    function(...)

                        return old(...)

                    end

            end

        end)
    end
end

-- ============================================================
-- 8. 创建主窗口
-- ============================================================

local Window =
    Library:CreateWindow({

        Title =
            "EVA-01 // FY HUB",

        Footer =
            "NERV NEURAL TERMINAL | v9.2",

        NotifySide =
            "Right",

        Icon =
            95816097006870,

        ShowCustomCursor =
            true,

        -- 关键：
        -- 关闭 Obsidian 默认 Lock / Toggle
        ShowMobileButtons =
            false,

        -- 手机/平板也不显示默认悬浮按钮
        MobileButtonsSide =
            "Right",

        Animations = {

            ToggleWindow = true,

            TabSwitch = true,

            Groupbox = true,

            Dropdown = true,

            KeyPicker = true,

        },

        TabTransitionTime =
            0.22,

        TabSwipeOffset =
            26,

        TabSwipeFrom =
            "bottom",

        Resizable =
            true,

    })

-- ============================================================
-- 9. Tabs
-- ============================================================

local TabMain =
    Window:AddTab(
        "主要",
        "target"
    )

local TabTeleport =
    Window:AddTab(
        "传送点",
        "map-pin"
    )

local TabSettings =
    Window:AddTab(
        "设置",
        "settings"
    )

local TabBullet =
    Window:AddTab(
        "子弹追踪",
        "crosshair"
    )

-- ============================================================
-- 10. 主页面
-- ============================================================

local LeftMain =
    TabMain:AddLeftGroupbox(
        "交互设置",
        "hand"
    )

local RightMain =
    TabMain:AddRightGroupbox(
        "碰撞箱扩展",
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
        "自动赚钱（出租车）",
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
-- 交互设置
-- ============================================================

LeftMain:AddSlider(
    "HoldTime",
    {

        Min = 0,

        Default = 0,

        Suffix = "秒",

        Max = 10,

        Text = "按住时间",

        Callback = function(val)

            Settings.HoldTime =
                val

            for _, obj in ipairs(
                Workspace:GetDescendants()
            ) do

                if obj:IsA(
                    "ProximityPrompt"
                ) then

                    obj.HoldDuration =
                        val

                end
            end
        end,

        Rounding = 0

    }
)

LeftMain:AddSlider(
    "Distance",
    {

        Min = 5,

        Default = 25,

        Suffix = "单位",

        Max = 150,

        Text = "触发距离",

        Callback = function(val)

            Settings.Distance =
                val

            for _, obj in ipairs(
                Workspace:GetDescendants()
            ) do

                if obj:IsA(
                    "ProximityPrompt"
                ) then

                    obj.MaxActivationDistance =
                        val

                end
            end
        end,

        Rounding = 0

    }
)

LeftMain:AddDivider()

LeftMain:AddToggle(
    "NoclipToggle",
    {

        Text =
            "启用人物穿墙",

        Default =
            false,

        Callback =
            function(val)

                Toggles.Noclip =
                    val

                local char =
                    LocalPlayer.Character

                if char then

                    for _, part in ipairs(
                        char:GetDescendants()
                    ) do

                        if part:IsA(
                            "BasePart"
                        ) then

                            part.CanCollide =
                                not val

                        end
                    end
                end
            end
    }
)

-- ============================================================
-- 碰撞箱
-- ============================================================

RightMain:AddToggle(
    "KillAuraToggle",
    {

        Text =
            "杀戮光环",

        Default =
            false,

        Callback =
            function(val)

                ToggleKillAura(val)

            end
    }
)

RightMain:AddSlider(
    "KillAuraRange",
    {

        Min = 1,

        Default = 50,

        Suffix = "单位",

        Max = 1000,

        Text =
            "杀戮光环距离",

        Callback =
            function(val)

                Settings.KillAuraRange =
                    val

            end,

        Rounding = 0

    }
)

RightMain:AddToggle(
    "HitboxToggle",
    {

        Text =
            "启用头部碰撞箱",

        Default =
            false,

        Callback =
            function(val)

                Toggles.Hitbox =
                    val

                if val then

                    ApplyHitbox(
                        Settings.HitboxSize
                    )

                else

                    ResetHitbox()

                end
            end
    }
)

RightMain:AddSlider(
    "HitboxSize",
    {

        Min = 5,

        Default = 10,

        Suffix = "单位",

        Max = 40,

        Text =
            "头部大小",

        Callback =
            function(val)

                Settings.HitboxSize =
                    val

                if Toggles.Hitbox then

                    ApplyHitbox(val)

                end

            end,

        Rounding = 0

    }
)

RightMain:AddToggle(
    "WhitelistToggle",
    {

        Text =
            "好友检测（白名单）",

        Default =
            false,

        Callback =
            function(val)

                Toggles.Whitelist =
                    val

                if val then
                    UpdateWhitelist()
                end

            end
    }
)

-- ============================================================
-- 自瞄
-- ============================================================

AimGroup:AddToggle(
    "AimToggle",
    {

        Text =
            "启用自瞄",

        Default =
            false,

        Callback =
            function(val)

                Toggles.Aim =
                    val

            end
    }
)

AimGroup:AddSlider(
    "AimSmoothness",
    {

        Min = 1,

        Default = 5,

        Max = 20,

        Text =
            "平滑度",

        Rounding = 0,

        Callback =
            function(val)

                Settings.AimSmoothness =
                    val

            end
    }
)

AimGroup:AddSlider(
    "AimMaxDistance",
    {

        Min = 50,

        Default = 200,

        Suffix = "单位",

        Max = 500,

        Text =
            "检测距离",

        Rounding = 0,

        Callback =
            function(val)

                Settings.AimMaxDistance =
                    val

            end
    }
)

AimGroup:AddToggle(
    "AimCheckWall",
    {

        Text =
            "墙壁检测",

        Default =
            true,

        Callback =
            function(val)

                Settings.AimCheckWall =
                    val

            end
    }
)

-- ============================================================
-- 移动
-- ============================================================

MoveGroup:AddToggle(
    "NoDizzinessToggle",
    {

        Text =
            "无眩晕",

        Default =
            false,

        Callback =
            function(val)

                Toggles.NoDizziness =
                    val

                if val then

                    StartNoDizziness()

                else

                    StopNoDizziness()

                end

            end
    }
)

MoveGroup:AddSlider(
    "NoDizzinessSpeed",
    {

        Min = 5,

        Default = 24,

        Suffix = "stud/s",

        Max = 80,

        Text =
            "移动速度",

        Rounding = 0,

        Callback =
            function(val)

                Settings.NoDizzinessSpeed =
                    val

            end
    }
)

-- ============================================================
-- ESP
-- ============================================================

local ESPGroup =
    TabMain:AddLeftGroupbox(
        "ESP透视",
        "target"
    )

ESPGroup:AddToggle(
    "SkeletonToggle",
    {

        Text =
            "启用ESP透视",

        Default =
            false,

        Callback =
            function(val)

        end
    }
)

-- ============================================================
-- 出租车
-- ============================================================

TaxiGroup:AddToggle(
    "TaxiToggle",
    {

        Text =
            "启用出租车自动循环",

        Default =
            false,

        Callback =
            function(val)

                ToggleTaxi(val)

            end
    }
)

TaxiGroup:AddSlider(
    "TaxiWaitTime",
    {

        Min = 1,

        Default = 7,

        Suffix = "秒",

        Max = 30,

        Text =
            "每次等待秒数",

        Callback =
            function(val)

                Settings.TaxiWaitTime =
                    val

            end,

        Rounding = 0

    }
)

-- ============================================================
-- 公交
-- ============================================================

BusGroup:AddToggle(
    "AutoBusToggle",
    {

        Text =
            "启用自动传送（圈）",

        Default =
            false,

        Callback =
            function(val)

                Toggles.AutoBus =
                    val

                if val then

                    StartAutoBus()

                    Library:Notify({

                        Time = 2,

                        Title =
                            "EVA-01",

                        Description =
                            "自动公交车已启动"

                    })

                else

                    StopAutoBus()

                    Library:Notify({

                        Time = 2,

                        Title =
                            "EVA-01",

                        Description =
                            "自动公交车已停止"

                    })

                end
            end
    }
)

-- ============================================================
-- ATM
-- ============================================================

AtmGroup:AddToggle(
    "AtmHackToggle",
    {

        Text =
            "启用ATM自动破解（每5秒）",

        Default =
            false,

        Callback =
            function(val)

                ToggleAtmHack(val)

            end
    }
)

-- ============================================================
-- 11. 传送点
-- ============================================================

local TeleLeft =
    TabTeleport:AddLeftGroupbox(
        "传送控制",
        "navigation"
    )

TeleLeft:AddToggle(
    "TeleportToggle",
    {

        Text =
            "启用传送",

        Default =
            false,

        Callback =
            function(val)

                Toggles.Teleport =
                    val

            end
    }
)

local function AddTeleportButton(
    group,
    name,
    pos
)

    group:AddButton({

        Text =
            name,

        Func =
            function()

                TeleportTo(pos)

            end

    })

end

local TeleLeft1 =
    TabTeleport:AddLeftGroupbox(
        "其他",
        "map-pin"
    )

AddTeleportButton(
    TeleLeft1,
    "黑色市场",
    Vector3_new(
        1038.969849,
        -22.73295,
        895.430237
    )
)

AddTeleportButton(
    TeleLeft1,
    "鱼夫码头",
    Vector3_new(
        -50.147552,
        -24.555279,
        1462.145996
    )
)

AddTeleportButton(
    TeleLeft1,
    "农场",
    Vector3_new(
        -1268.339233,
        2.572412,
        2560.060303
    )
)

AddTeleportButton(
    TeleLeft1,
    "监狱门口",
    Vector3_new(
        -1697.931885,
        2.630666,
        1284.567383
    )
)

AddTeleportButton(
    TeleLeft1,
    "监狱广场",
    Vector3_new(
        -1600.602417,
        2.631028,
        1268.060059
    )
)

AddTeleportButton(
    TeleLeft1,
    "代尔山",
    Vector3_new(
        847.062988,
        194.115753,
        -326.212708
    )
)

AddTeleportButton(
    TeleLeft1,
    "水帘洞（消星点）",
    Vector3_new(
        3040.956055,
        109.688538,
        2711.069336
    )
)

AddTeleportButton(
    TeleLeft1,
    "大桥",
    Vector3_new(
        949.014954,
        25.215754,
        2897.654785
    )
)

AddTeleportButton(
    TeleLeft1,
    "地图右下（消星点）",
    Vector3_new(
        -1651.38501,
        2.414712,
        3225.27832
    )
)

AddTeleportButton(
    TeleLeft1,
    "下部加油站",
    Vector3_new(
        2270.378174,
        2.630927,
        154.161484
    )
)

AddTeleportButton(
    TeleLeft1,
    "游戏厅",
    Vector3_new(
        2934.893799,
        2.956458,
        1693.660034
    )
)

AddTeleportButton(
    TeleLeft1,
    "高尔夫",
    Vector3_new(
        2280.76709,
        3.037836,
        1982.3573
    )
)

AddTeleportButton(
    TeleLeft1,
    "修船厂",
    Vector3_new(
        4096.405273,
        -30.401447,
        2865.045166
    )
)

-- ============================================================
-- 圣奥里
-- ============================================================

local TeleRight1 =
    TabTeleport:AddRightGroupbox(
        "圣奥里",
        "map-pin"
    )

AddTeleportButton(
    TeleRight1,
    "车辆经销商",
    Vector3_new(
        3719.950195,
        3.018573,
        -333.311859
    )
)

AddTeleportButton(
    TeleRight1,
    "医院",
    Vector3_new(
        3980.091064,
        2.876061,
        -138.79454
    )
)

AddTeleportButton(
    TeleRight1,
    "警察局",
    Vector3_new(
        3364.273193,
        3.918808,
        -394.723358
    )
)

AddTeleportButton(
    TeleRight1,
    "圣奥里修车店",
    Vector3_new(
        2782.46875,
        2.630996,
        -418.599304
    )
)

AddTeleportButton(
    TeleRight1,
    "圣奥里银行",
    Vector3_new(
        3134.054199,
        6.116048,
        -171.369766
    )
)

AddTeleportButton(
    TeleRight1,
    "圣奥里服装店",
    Vector3_new(
        3617.912598,
        3.107221,
        -452.820648
    )
)

AddTeleportButton(
    TeleRight1,
    "圣奥里平民重生",
    Vector3_new(
        3741.11499,
        3.720574,
        -438.105988
    )
)

AddTeleportButton(
    TeleRight1,
    "圣奥里码头",
    Vector3_new(
        4527.65625,
        -23.968239,
        -280.593567
    )
)

AddTeleportButton(
    TeleRight1,
    "圣奥里餐饮店",
    Vector3_new(
        3182.416748,
        3.018592,
        426.517914
    )
)

AddTeleportButton(
    TeleRight1,
    "消防部门",
    Vector3_new(
        3578.676025,
        8.408823,
        579.656799
    )
)

AddTeleportButton(
    TeleRight1,
    "宠物店",
    Vector3_new(
        3678.237305,
        3.01792,
        693.114624
    )
)

AddTeleportButton(
    TeleRight1,
    "圣奥里大码头",
    Vector3_new(
        2736.307617,
        2.630299,
        -1120.333008
    )
)

AddTeleportButton(
    TeleRight1,
    "圣奥里海滩桥下（消星点）",
    Vector3_new(
        3964.504395,
        -25.068211,
        -854.057251
    )
)

-- ============================================================
-- 大景
-- ============================================================

local TeleLeft2 =
    TabTeleport:AddLeftGroupbox(
        "大景",
        "map-pin"
    )

AddTeleportButton(
    TeleLeft2,
    "大景超级超市",
    Vector3_new(
        3936.582764,
        3.038293,
        1136.326416
    )
)

AddTeleportButton(
    TeleLeft2,
    "转镜中心",
    Vector3_new(
        4152.919922,
        2.631675,
        941.446045
    )
)

AddTeleportButton(
    TeleLeft2,
    "道路服务",
    Vector3_new(
        4271.33252,
        2.628108,
        1200.086914
    )
)

AddTeleportButton(
    TeleLeft2,
    "大景餐饮店",
    Vector3_new(
        4476.997559,
        3.037825,
        906.802979
    )
)

AddTeleportButton(
    TeleLeft2,
    "送货中心（美团外卖）",
    Vector3_new(
        4399.419434,
        3.038999,
        1609.455933
    )
)

AddTeleportButton(
    TeleLeft2,
    "大景卖车店",
    Vector3_new(
        3434.377441,
        42.931786,
        2687.99707
    )
)

-- ============================================================
-- 米尔顿
-- ============================================================

local TeleRight2 =
    TabTeleport:AddRightGroupbox(
        "米尔顿",
        "map-pin"
    )

AddTeleportButton(
    TeleRight2,
    "米尔顿左上加油站",
    Vector3_new(
        1145.635742,
        2.630916,
        -864.273682
    )
)

AddTeleportButton(
    TeleRight2,
    "米尔顿右下加油站",
    Vector3_new(
        -1646.802734,
        2.630164,
        1812.894653
    )
)

AddTeleportButton(
    TeleRight2,
    "米尔顿上方加油站",
    Vector3_new(
        -900.70166,
        2.630927,
        1124.683105
    )
)

AddTeleportButton(
    TeleRight2,
    "米尔顿居民区",
    Vector3_new(
        -528.565552,
        2.630996,
        1331.981689
    )
)

-- ============================================================
-- 约克镇
-- ============================================================

local TeleLeft3 =
    TabTeleport:AddLeftGroupbox(
        "约克镇",
        "map-pin"
    )

AddTeleportButton(
    TeleLeft3,
    "约克镇小银行",
    Vector3_new(
        -668.217224,
        2.630995,
        -65.347839
    )
)

AddTeleportButton(
    TeleLeft3,
    "约克镇修车厂",
    Vector3_new(
        -407.163025,
        3.076807,
        -6.098211
    )
)

AddTeleportButton(
    TeleLeft3,
    "约克镇枪店",
    Vector3_new(
        -323.869293,
        3.037825,
        37.14967
    )
)

AddTeleportButton(
    TeleLeft3,
    "约克镇重生点",
    Vector3_new(
        -219.560318,
        3.039824,
        -85.725433
    )
)

AddTeleportButton(
    TeleLeft3,
    "约克镇当铺",
    Vector3_new(
        -168.513733,
        3.039,
        -106.926529
    )
)

AddTeleportButton(
    TeleLeft3,
    "约克镇卫星车",
    Vector3_new(
        -302.093567,
        3.037825,
        -167.621017
    )
)

AddTeleportButton(
    TeleLeft3,
    "约克镇中心点",
    Vector3_new(
        -275.995209,
        2.630996,
        -139.985352
    )
)

-- ============================================================
-- 莱斯维尔
-- ============================================================

local TeleRight3 =
    TabTeleport:AddRightGroupbox(
        "莱斯维尔",
        "map-pin"
    )

AddTeleportButton(
    TeleRight3,
    "莱斯维尔餐饮店",
    Vector3_new(
        753.757812,
        3.039824,
        998.132996
    )
)

AddTeleportButton(
    TeleRight3,
    "莱斯维尔服装店",
    Vector3_new(
        820.745117,
        2.766988,
        1047.445679
    )
)

AddTeleportButton(
    TeleRight3,
    "莱斯维尔自由广场",
    Vector3_new(
        926.523376,
        2.630996,
        865.764771
    )
)

AddTeleportButton(
    TeleRight3,
    "莱斯维尔码头（游艇）",
    Vector3_new(
        947.84021,
        -22.529087,
        1216.085693
    )
)

-- ============================================================
-- 12. 设置
-- ============================================================

local SetLeft =
    TabSettings:AddLeftGroupbox(
        "EVA-01 菜单设置",
        "sliders"
    )

SetLeft:AddDropdown(
    "AnimeThemeSelector",
    {

        Values = {

            "EVA-01 初号机（暴走紫绿）",

            "EVA-02 二号机（战斗红橙）",

            "Cyberpunk 赛博朋克（霓虹蓝粉）",

            "Genshin 草元素（森林绿）",

        },

        Default = 1,

        Text =
            "选择 UI 主题",

        Callback =
            function(value)

                local Theme

                if value:find("EVA%-01") then

                    Theme = {

                        FontColor =
                            FromRGB(
                                240,
                                238,
                                245
                            ),

                        MainColor =
                            FromRGB(
                                58,
                                29,
                                72
                            ),

                        AccentColor =
                            FromRGB(
                                145,
                                45,
                                235
                            ),

                        BackgroundColor =
                            FromRGB(
                                30,
                                17,
                                40
                            ),

                        OutlineColor =
                            FromRGB(
                                105,
                                40,
                                145
                            ),

                    }

                elseif value:find("EVA%-02") then

                    Theme = {

                        FontColor =
                            FromRGB(
                                255,
                                245,
                                240
                            ),

                        MainColor =
                            FromRGB(
                                90,
                                32,
                                28
                            ),

                        AccentColor =
                            FromRGB(
                                255,
                                75,
                                35
                            ),

                        BackgroundColor =
                            FromRGB(
                                48,
                                20,
                                20
                            ),

                        OutlineColor =
                            FromRGB(
                                160,
                                45,
                                30
                            ),

                    }

                elseif value:find(
                    "Cyberpunk"
                ) then

                    Theme = {

                        FontColor =
                            FromRGB(
                                235,
                                255,
                                255
                            ),

                        MainColor =
                            FromRGB(
                                20,
                                48,
                                58
                            ),

                        AccentColor =
                            FromRGB(
                                0,
                                255,
                                255
                            ),

                        BackgroundColor =
                            FromRGB(
                                12,
                                28,
                                35
                            ),

                        OutlineColor =
                            FromRGB(
                                0,
                                170,
                                190
                            ),

                    }

                else

                    Theme = {

                        FontColor =
                            FromRGB(
                                235,
                                255,
                                235
                            ),

                        MainColor =
                            FromRGB(
                                30,
                                65,
                                38
                            ),

                        AccentColor =
                            FromRGB(
                                60,
                                220,
                                90
                            ),

                        BackgroundColor =
                            FromRGB(
                                17,
                                38,
                                22
                            ),

                        OutlineColor =
                            FromRGB(
                                45,
                                145,
                                60
                            ),

                    }

                end

                -- 实时修改 Obsidian 的主题颜色
                pcall(function()

                    if Options.FontColor then
                        Options.FontColor:SetValue(
                            Theme.FontColor
                        )
                    end

                    if Options.MainColor then
                        Options.MainColor:SetValue(
                            Theme.MainColor
                        )
                    end

                    if Options.AccentColor then
                        Options.AccentColor:SetValue(
                            Theme.AccentColor
                        )
                    end

                    if Options.BackgroundColor then
                        Options.BackgroundColor:SetValue(
                            Theme.BackgroundColor
                        )
                    end

                    if Options.OutlineColor then
                        Options.OutlineColor:SetValue(
                            Theme.OutlineColor
                        )
                    end

                end)

                pcall(function()
                    ThemeManager:ThemeUpdate()
                end)

                Library:Notify({

                    Time = 3,

                    Title =
                        "NERV // THEME",

                    Description =
                        "已应用：" .. value

                })

            end
    }
)

SetLeft:AddToggle(
    "ShowCustomCursor",
    {

        Text =
            "自定义光标",

        Default =
            true,

        Callback =
            function(val)

                Library.ShowCustomCursor =
                    val

                Toggles.ShowCustomCursor =
                    val

            end
    }
)

SetLeft:AddDivider()

SetLeft:AddButton({

    Text =
        "卸载 FY HUB",

    Func =
        function()

            Library:Unload()

            local island =
                PlayerGui:FindFirstChild(
                    "FY_EVA01_DynamicIsland"
                )

            if island then
                island:Destroy()
            end

        end,

    Risky =
        true

})

-- ============================================================
-- 13. 子弹追踪
-- ============================================================

local BulletGroup =
    TabBullet:AddLeftGroupbox(
        "追踪控制",
        "target"
    )

BulletGroup:AddToggle(
    "BulletTrackToggle",
    {

        Text =
            "启用子弹追踪",

        Default =
            false,

        Callback =
            function(val)

                ToggleBulletTrack(val)

            end
    }
)

BulletGroup:AddDivider()

BulletGroup:AddToggle(
    "ScreenPriority",
    {

        Text =
            "屏幕中心优先",

        Default =
            true,

        Callback =
            function(val)

                Toggles.ScreenPriority =
                    val

            end
    }
)

BulletGroup:AddToggle(
    "DistancePriority",
    {

        Text =
            "距离优先（锁定最近）",

        Default =
            false,

        Callback =
            function(val)

                Toggles.DistancePriority =
                    val

            end
    }
)

-- ============================================================
-- 14. ThemeManager / SaveManager
-- ============================================================

ThemeManager:SetLibrary(
    Library
)

SaveManager:SetLibrary(
    Library
)

ThemeManager:SetFolder(
    "FY_HUB"
)

SaveManager:SetFolder(
    "FY_HUB"
)

SaveManager:SetSubFolder(
    "Configs"
)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({

    "MenuKeybind",

    "AnimeThemeSelector",

})

-- ============================================================
-- 关键：
-- ThemeManager 在这里生成颜色控制
-- ============================================================

ThemeManager:ApplyToTab(
    TabSettings
)

SaveManager:BuildConfigSection(
    TabSettings
)

-- ============================================================
-- 强制应用 EVA-01
-- ============================================================

task.defer(function()

    task.wait(0.25)

    pcall(function()

        if Options.FontColor then

            Options.FontColor:SetValue(
                EVA01Theme.FontColor
            )

        end

        if Options.MainColor then

            Options.MainColor:SetValue(
                EVA01Theme.MainColor
            )

        end

        if Options.AccentColor then

            Options.AccentColor:SetValue(
                EVA01Theme.AccentColor
            )

        end

        if Options.BackgroundColor then

            Options.BackgroundColor:SetValue(
                EVA01Theme.BackgroundColor
            )

        end

        if Options.OutlineColor then

            Options.OutlineColor:SetValue(
                EVA01Theme.OutlineColor
            )

        end

    end)

    pcall(function()

        ThemeManager:ThemeUpdate()

    end)

end)

-- ============================================================
-- 15. 灵动岛
-- ============================================================

if PlayerGui:FindFirstChild(
    "FY_EVA01_DynamicIsland"
) then

    PlayerGui.FY_EVA01_DynamicIsland:Destroy()

end

local DynamicIslandGui =
    Instance.new("ScreenGui")

DynamicIslandGui.Name =
    "FY_EVA01_DynamicIsland"

DynamicIslandGui.ResetOnSpawn =
    false

DynamicIslandGui.IgnoreGuiInset =
    true

DynamicIslandGui.DisplayOrder =
    1000

DynamicIslandGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

DynamicIslandGui.Parent =
    PlayerGui

-- ============================================================
-- 灵动岛主体
-- ============================================================

local Island =
    Instance.new("Frame")

Island.Name =
    "DynamicIsland"

Island.Size =
    UDim2.new(
        0,
        345,
        0,
        70
    )

Island.Position =
    UDim2.new(
        0.5,
        -172,
        0,
        125
    )

Island.BackgroundColor3 =
    FromRGB(
        24,
        15,
        30
    )

Island.BackgroundTransparency =
    0.03

Island.BorderSizePixel =
    0

Island.Active =
    true

Island.Parent =
    DynamicIslandGui

local IslandCorner =
    Instance.new("UICorner")

IslandCorner.CornerRadius =
    UDim.new(
        1,
        0
    )

IslandCorner.Parent =
    Island

local IslandStroke =
    Instance.new("UIStroke")

IslandStroke.Thickness =
    2

IslandStroke.Color =
    FromRGB(
        145,
        45,
        235
    )

IslandStroke.Parent =
    Island

-- ============================================================
-- 灵动岛渐变
-- ============================================================

local IslandGradient =
    Instance.new("UIGradient")

IslandGradient.Color =
    ColorSequence.new({

        ColorSequenceKeypoint.new(
            0,
            FromRGB(
                115,
                30,
                190
            )
        ),

        ColorSequenceKeypoint.new(
            0.45,
            FromRGB(
                155,
                45,
                220
            )
        ),

        ColorSequenceKeypoint.new(
            0.75,
            FromRGB(
                100,
                180,
                75
            )
        ),

        ColorSequenceKeypoint.new(
            1,
            FromRGB(
                165,
                255,
                80
            )
        ),

    })

IslandGradient.Rotation =
    0

IslandGradient.Parent =
    Island

-- ============================================================
-- EVA-01 左侧
-- ============================================================

local EvaIcon =
    Instance.new("Frame")

EvaIcon.Size =
    UDim2.new(
        0,
        50,
        0,
        50
    )

EvaIcon.Position =
    UDim2.new(
        0,
        10,
        0.5,
        -25
    )

EvaIcon.BackgroundColor3 =
    FromRGB(
        52,
        22,
        70
    )

EvaIcon.BorderSizePixel =
    0

EvaIcon.Parent =
    Island

local EvaCorner =
    Instance.new("UICorner")

EvaCorner.CornerRadius =
    UDim.new(
        1,
        0
    )

EvaCorner.Parent =
    EvaIcon

local EvaStroke =
    Instance.new("UIStroke")

EvaStroke.Color =
    FromRGB(
        165,
        60,
        240
    )

EvaStroke.Thickness =
    1.5

EvaStroke.Parent =
    EvaIcon

local EvaText =
    Instance.new("TextLabel")

EvaText.Size =
    UDim2.new(
        1,
        0,
        1,
        0
    )

EvaText.BackgroundTransparency =
    1

EvaText.Text =
    "01"

EvaText.TextColor3 =
    FromRGB(
        175,
        255,
        80
    )

EvaText.TextSize =
    17

EvaText.Font =
    Enum.Font.GothamBlack

EvaText.Parent =
    EvaIcon

-- ============================================================
-- 标题
-- ============================================================

local IslandTitle =
    Instance.new("TextLabel")

IslandTitle.Size =
    UDim2.new(
        0,
        180,
        0,
        25
    )

IslandTitle.Position =
    UDim2.new(
        0,
        70,
        0,
        10
    )

IslandTitle.BackgroundTransparency =
    1

IslandTitle.Text =
    "EVA-01  //  FY HUB"

IslandTitle.TextColor3 =
    FromRGB(
        245,
        240,
        250
    )

IslandTitle.TextSize =
    15

IslandTitle.Font =
    Enum.Font.GothamBold

IslandTitle.TextXAlignment =
    Enum.TextXAlignment.Left

IslandTitle.Parent =
    Island

-- ============================================================
-- 状态
-- ============================================================

local IslandStatus =
    Instance.new("TextLabel")

IslandStatus.Size =
    UDim2.new(
        0,
        185,
        0,
        18
    )

IslandStatus.Position =
    UDim2.new(
        0,
        71,
        0,
        36
    )

IslandStatus.BackgroundTransparency =
    1

IslandStatus.Text =
    "● NERV NEURAL LINK"

IslandStatus.TextColor3 =
    FromRGB(
        160,
        255,
        80
    )

IslandStatus.TextSize =
    10

IslandStatus.Font =
    Enum.Font.GothamMedium

IslandStatus.TextXAlignment =
    Enum.TextXAlignment.Left

IslandStatus.Parent =
    Island

-- ============================================================
-- 灵动岛开关按钮
-- ============================================================

local IslandButton =
    Instance.new("TextButton")

IslandButton.Size =
    UDim2.new(
        0,
        58,
        0,
        50
    )

IslandButton.Position =
    UDim2.new(
        1,
        -68,
        0.5,
        -25
    )

IslandButton.BackgroundColor3 =
    FromRGB(
        50,
        23,
        65
    )

IslandButton.Text =
    "≡"

IslandButton.TextColor3 =
    FromRGB(
        175,
        255,
        80
    )

IslandButton.TextSize =
    28

IslandButton.Font =
    Enum.Font.GothamBlack

IslandButton.BorderSizePixel =
    0

IslandButton.AutoButtonColor =
    false

IslandButton.Parent =
    Island

local IslandButtonCorner =
    Instance.new("UICorner")

IslandButtonCorner.CornerRadius =
    UDim.new(
        1,
        0
    )

IslandButtonCorner.Parent =
    IslandButton

local IslandButtonStroke =
    Instance.new("UIStroke")

IslandButtonStroke.Color =
    FromRGB(
        130,
        45,
        190
    )

IslandButtonStroke.Thickness =
    1.5

IslandButtonStroke.Parent =
    IslandButton

-- ============================================================
-- 灵动岛点击开关
-- ============================================================

local IslandOpen = true

local function ToggleFYHub()

    IslandOpen =
        not IslandOpen

    pcall(function()

        Window:Toggle(
            IslandOpen
        )

    end)

    if IslandOpen then

        IslandButton.Text =
            "×"

        IslandStatus.Text =
            "● NERV NEURAL LINK"

        IslandStatus.TextColor3 =
            FromRGB(
                160,
                255,
                80
            )

        IslandStroke.Color =
            FromRGB(
                145,
                45,
                235
            )

    else

        IslandButton.Text =
            "≡"

        IslandStatus.Text =
            "● STANDBY"

        IslandStatus.TextColor3 =
            FromRGB(
                175,
                120,
                200
            )

        IslandStroke.Color =
            FromRGB(
                85,
                45,
                105
            )

    end
end

IslandButton.MouseButton1Click:Connect(
    ToggleFYHub
)

-- ============================================================
-- 灵动岛拖动
-- ============================================================

local Dragging =
    false

local DragStart =
    nil

local StartPosition =
    nil

local DragInput =
    nil

local function UpdateIsland(
    input
)

    if not DragStart
        or not StartPosition then

        return

    end

    local Delta =
        input.Position
        -
        DragStart

    Island.Position =
        UDim2.new(

            StartPosition.X.Scale,

            StartPosition.X.Offset
                + Delta.X,

            StartPosition.Y.Scale,

            StartPosition.Y.Offset
                + Delta.Y

        )

end

Island.InputBegan:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging =
                true

            DragStart =
                input.Position

            StartPosition =
                Island.Position

            input.Changed:Connect(
                function()

                    if input.UserInputState ==
                        Enum.UserInputState.End then

                        Dragging =
                            false

                    end

                end
            )

        end

    end
)

Island.InputChanged:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            DragInput =
                input

        end

    end
)

UserInputService.InputChanged:Connect(
    function(input)

        if input == DragInput
            and Dragging then

            UpdateIsland(
                input
            )

        end

    end
)

-- ============================================================
-- 16. 角色重生
-- ============================================================

LocalPlayer.CharacterAdded:Connect(
    function(newChar)

        task.wait(0.5)

        if Toggles.Noclip then

            for _, part in ipairs(
                newChar:GetDescendants()
            ) do

                if part:IsA(
                    "BasePart"
                ) then

                    part.CanCollide =
                        false

                end

            end
        end

        if Toggles.Hitbox then

            ApplyHitbox(
                Settings.HitboxSize
            )

        end

        if Toggles.AutoBus then

            StartAutoBus()

        end

        if Toggles.Taxi then

            ToggleTaxi(true)

        end

        if Toggles.KillAura then

            StartKillAura()

        end

        if Toggles.NoDizziness then

            StartNoDizziness()

        end

    end
)

-- ============================================================
-- 17. ProximityPrompt
-- ============================================================

Workspace.DescendantAdded:Connect(
    function(desc)

        if desc:IsA(
            "ProximityPrompt"
        ) then

            desc.HoldDuration =
                Settings.HoldTime

            desc.MaxActivationDistance =
                Settings.Distance

        end

    end
)

-- ============================================================
-- 18. 玩家加入
-- ============================================================

Players.PlayerAdded:Connect(
    function(player)

        if Toggles.Whitelist then

            pcall(function()

                if player:IsFriendsWith(
                    LocalPlayer.UserId
                ) then

                    FriendWhitelist[
                        player.UserId
                    ] = true

                end

            end)

        end

    end
)

-- ============================================================
-- 19. 最终应用 EVA-01
-- ============================================================

task.defer(function()

    task.wait(0.6)

    pcall(function()

        if Options.FontColor then

            Options.FontColor:SetValue(
                EVA01Theme.FontColor
            )

        end

        if Options.MainColor then

            Options.MainColor:SetValue(
                EVA01Theme.MainColor
            )

        end

        if Options.AccentColor then

            Options.AccentColor:SetValue(
                EVA01Theme.AccentColor
            )

        end

        if Options.BackgroundColor then

            Options.BackgroundColor:SetValue(
                EVA01Theme.BackgroundColor
            )

        end

        if Options.OutlineColor then

            Options.OutlineColor:SetValue(
                EVA01Theme.OutlineColor
            )

        end

    end)

    pcall(function()

        ThemeManager:ThemeUpdate()

    end)

end)

-- ============================================================
-- 20. 完成
-- ============================================================

print(
    "=========================================="
)

print(
    "EVA-01 // FY HUB"
)

print(
    "NERV NEURAL TERMINAL ONLINE"
)

print(
    "Dynamic Island: ONLINE"
)

print(
    "EVA-01 Theme: ONLINE"
)

print(
    "=========================================="
)
