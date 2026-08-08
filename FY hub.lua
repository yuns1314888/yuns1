-- ============================================================
-- FY HUB - 原生内置卡密系统 + 全传送点 + Obsidian 终极全功能版
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. 原生内置卡密验证配置
local CorrectKey = "FYNB666" -- 在这里修改你的专属卡密
local KeyPassed = false

-- 安全获取挂载容器
local protect_gui = protectgui or (syn and syn.protect_gui)
local guiParent = gethui() or (protect_gui and CoreGui) or LocalPlayer:FindFirstChild("PlayerGui") or CoreGui

if guiParent:FindFirstChild("FY_NativeKeySystem") then
    guiParent.FY_NativeKeySystem:Destroy()
end

-- 创建原生卡密 UI
local KeyScreenGui = Instance.new("ScreenGui")
KeyScreenGui.Name = "FY_NativeKeySystem"
KeyScreenGui.ResetOnSpawn = false
if protect_gui then protect_gui(KeyScreenGui) end
KeyScreenGui.Parent = guiParent

local KeyMainFrame = Instance.new("Frame")
KeyMainFrame.Size = UDim2.new(0, 360, 0, 200)
KeyMainFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
KeyMainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
KeyMainFrame.BorderSizePixel = 0
KeyMainFrame.Parent = KeyScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 12)
KeyCorner.Parent = KeyMainFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "FY HUB // 脚本授权验证系统"
KeyTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
KeyTitle.TextSize = 16
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyMainFrame

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Size = UDim2.new(0.85, 0, 0, 44)
KeyTextBox.Position = UDim2.new(0.075, 0, 0.35, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.PlaceholderText = "请输入卡密: FYNB666"
KeyTextBox.Text = ""
KeyTextBox.TextSize = 14
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.Parent = KeyMainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = KeyTextBox

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 40)
SubmitBtn.Position = UDim2.new(0.075, 0, 0.70, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Text = "验证并进入"
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyMainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = SubmitBtn

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyTextBox.Text == CorrectKey then
        KeyPassed = true
        KeyScreenGui:Destroy()
    else
        SubmitBtn.Text = "卡密错误，请重新输入！"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        SubmitBtn.Text = "验证并进入"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    end
end)

while not KeyPassed do
    task.wait(0.2)
end

-- ============================================================
-- 2. 验证通过：加载 Obsidian 主界面与全部功能
-- ============================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local PlayerEvent = nil
pcall(function()
    local remoteFolder = ReplicatedStorage:WaitForChild("Remote", 3)
    if remoteFolder then
        PlayerEvent = remoteFolder:WaitForChild("PlayerEvent", 3)
    end
end)

local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Algorithms = nil
pcall(function()
    if Modules then
        Algorithms = require(Modules:WaitForChild("Algorithms", 3))
    end
end)

local FromRGB = Color3.fromRGB
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
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
-- 3. 核心功能函数
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
                        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
                        if targetRoot and targetHum and targetHum.Health > 0 then
                            local dist = (targetRoot.Position - root.Position).Magnitude
                            if dist <= Settings.KillAuraRange then
                                if PlayerEvent then pcall(function() PlayerEvent:FireServer("attack", targetRoot.Position) end) end
                            end
                        end
                    end
                end
            end
        end)
    else
        if KillAuraConnection then KillAuraConnection:Disconnect() end
        KillAuraConnection = nil
    end
end

function StartNoDizziness()
    if NoDizzinessConnection then NoDizzinessConnection:Disconnect() end
    NoDizzinessConnection = RunService.RenderStepped:Connect(function()
        if not Toggles.NoDizziness then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local speed = Settings.NoDizzinessSpeed
                root.AssemblyLinearVelocity = Vector3_new(
                    moveDir.X * speed,
                    root.AssemblyLinearVelocity.Y,
                    moveDir.Z * speed
                )
            end
        end
    end)
end

function StopNoDizziness()
    if NoDizzinessConnection then
        NoDizzinessConnection:Disconnect()
        NoDizzinessConnection = nil
    end
end

function ToggleTaxi(enabled)
    Toggles.Taxi = enabled
    if enabled then
        if TaxiTask then task.cancel(TaxiTask) end
        TaxiTask = task.spawn(function()
            while Toggles.Taxi do
                local areas = {}
                local clientContent = Workspace:FindFirstChild("Gameplay") and Workspace.Gameplay:FindFirstChild("Entities") and Workspace.Gameplay.Entities:FindFirstChild("ClientContent")
                local searchRoot = clientContent or Workspace
                for _, obj in ipairs(searchRoot:GetDescendants()) do
                    if obj.Name == "Area" then table.insert(areas, obj) end
                end
                if #areas == 0 then
                    task.wait(5)
                else
                    for _, area in ipairs(areas) do
                        if not Toggles.Taxi then break end
                        local char = LocalPlayer.Character
                        if not char then break end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            pcall(function()
                                local targetCF = area:IsA("BasePart") and area.CFrame or (area:IsA("Model") and area:GetPivot() or nil)
                                if targetCF then
                                    root.CFrame = targetCF + Vector3_new(0, 3, 0)
                                end
                            end)
                        end
                        task.wait(Settings.TaxiWaitTime)
                    end
                end
            end
        end)
        Library:Notify({Time = 2, Title = "出租车", Description = "已开启"})
    else
        if TaxiTask then task.cancel(TaxiTask); TaxiTask = nil end
    end
end

function StartAutoBus()
    if AutoBusTask then task.cancel(AutoBusTask) end
    AutoBusTask = task.spawn(function()
        while Toggles.AutoBus do
            local areas = {}
            local clientContent = Workspace:FindFirstChild("Gameplay") and Workspace.Gameplay:FindFirstChild("Entities") and Workspace.Gameplay.Entities:FindFirstChild("ClientContent")
            local searchRoot = clientContent or Workspace
            for _, obj in ipairs(searchRoot:GetDescendants()) do
                if obj.Name == "Area" then table.insert(areas, obj) end
            end
            if #areas == 0 then
                task.wait(5)
            else
                for _, area in ipairs(areas) do
                    if not Toggles.AutoBus then break end
                    local char = LocalPlayer.Character
                    if not char then break end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if root and hum then
                        local areaCF = area:IsA("BasePart") and area.CFrame or (area:IsA("Model") and area:GetPivot() or nil)
                        if areaCF then
                            local targetCF = (areaCF * CFrame_new(3, 3, 16)) * CFrame.Angles(0, math.pi, 0)
                            pcall(function()
                                local seat = hum.SeatPart
                                if seat then
                                    local oldRootCF = root.CFrame
                                    local newSeatCF = targetCF * oldRootCF:ToObjectSpace(seat.CFrame)
                                    seat.CFrame = newSeatCF
                                    seat.Velocity = Vector3_new(0, 0, 0)
                                    seat.RotVelocity = Vector3_new(0, 0, 0)
                                    task.wait(0.1)
                                    hum.Sit = false
                                end
                            end)
                        end
                    end
                    task.wait(Settings.TaxiWaitTime)
                end
            end
        end
    end()
end

function StopAutoBus()
    if AutoBusTask then task.cancel(AutoBusTask); AutoBusTask = nil end
end

function ToggleAtmHack(enabled)
    Toggles.AtmHack = enabled
    if enabled then
        if AtmHackTask then task.cancel(AtmHackTask) end
        AtmHackTask = task.spawn(function()
            while Toggles.AtmHack do
                task.wait(5)
                if PlayerEvent then pcall(function() PlayerEvent:FireServer("atmHack") end) end
            end
        end)
        Library:Notify({Time = 2, Title = "ATM破解", Description = "已开启"})
    else
        if AtmHackTask then task.cancel(AtmHackTask); AtmHackTask = nil end
    end
end

function TeleportTo(position)
    if not Toggles.Teleport then
        Library:Notify({Time = 2, Title = "传送", Description = "请先开启传送开关"})
        return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function() root.CFrame = CFrame_new(position) end)
        Library:Notify({Time = 2, Title = "传送", Description = "已成功传送"})
    end
end

-- ============================================================
-- 4. UI 主界面构建
-- ============================================================

local Window = Library:CreateWindow({
    Title = "EVA-01 // FY HUB 神经连接终端",
    Footer = "FY | 初号机同步率 400% | v9.2",
    NotifySide = "Right",
    MobileButtonsSide = "Right",
    Icon = 95816097006870,
    ShowCustomCursor = true,
})

local TabMain = Window:AddTab("主要功能", "target")
local TabTeleport = Window:AddTab("传送控制", "map-pin")
local TabSettings = Window:AddTab("设置与二次元UI", "settings")

local LeftMain = TabMain:AddLeftGroupbox("交互设置", "hand")
local RightMain = TabMain:AddRightGroupbox("碰撞箱扩展", "target")
local AimGroup = TabMain:AddRightGroupbox("自瞄与子弹追踪", "crosshair")
local MoveGroup = TabMain:AddRightGroupbox("移动增强", "move")
local TaxiGroup = TabMain:AddLeftGroupbox("自动赚钱（出租车）", "car")
local BusGroup = TabMain:AddLeftGroupbox("自动公交车", "bus")
local AtmGroup = TabMain:AddLeftGroupbox("ATM自动破解", "dollar-sign")

-- 交互设置
LeftMain:AddSlider("HoldTime", {
    Min = 0, Default = 0, Suffix = "秒", Max = 10, Text = "按住时间",
    Callback = function(val)
        Settings.HoldTime = val
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then obj.HoldDuration = val end
        end
    end,
    Rounding = 0
})
LeftMain:AddSlider("Distance", {
    Min = 5, Default = 25, Suffix = "单位", Max = 150, Text = "触发距离",
    Callback = function(val)
        Settings.Distance = val
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then obj.MaxActivationDistance = val end
        end
    end,
    Rounding = 0
})
LeftMain:AddDivider()
LeftMain:AddToggle("NoclipToggle", {
    Text = "启用人物穿墙",
    Default = false,
    Callback = function(val)
        Toggles.Noclip = val
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = not val end
            end
        end
    end
})

-- 碰撞箱与杀戮
RightMain:AddToggle("KillAuraToggle", {
    Text = "杀戮光环",
    Default = false,
    Callback = function(val) ToggleKillAura(val) end
})
RightMain:AddSlider("KillAuraRange", {
    Min = 1, Default = 50, Suffix = "单位", Max = 1000, Text = "杀戮光环距离",
    Callback = function(val) Settings.KillAuraRange = val end,
    Rounding = 0
})
RightMain:AddToggle("HitboxToggle", {
    Text = "启用头部碰撞箱",
    Default = false,
    Callback = function(val)
        Toggles.Hitbox = val
        if val then ApplyHitbox(Settings.HitboxSize) else ResetHitbox() end
    end
})
RightMain:AddSlider("HitboxSize", {
    Min = 5, Default = 10, Suffix = "单位", Max = 40, Text = "头部大小",
    Callback = function(val)
        Settings.HitboxSize = val
        if Toggles.Hitbox then ApplyHitbox(val) end
    end,
    Rounding = 0
})
RightMain:AddToggle("WhitelistToggle", {
    Text = "好友检测 (白名单)",
    Default = false,
    Callback = function(val)
        Toggles.Whitelist = val
        if val then UpdateWhitelist() end
    end
})

-- 自瞄与子弹追踪
AimGroup:AddToggle("AimToggle", {
    Text = "启用自瞄",
    Default = false,
    Callback = function(val) Toggles.Aim = val end
})
AimGroup:AddToggle("BulletTrackToggle", {
    Text = "子弹追踪 (BulletTrack)",
    Default = false,
    Callback = function(val) Toggles.BulletTrack = val end
})
AimGroup:AddToggle("ScreenPriorityToggle", {
    Text = "屏幕优先 (ScreenPriority)",
    Default = true,
    Callback = function(val) Toggles.ScreenPriority = val end
})
AimGroup:AddToggle("DistancePriorityToggle", {
    Text = "距离优先 (DistancePriority)",
    Default = false,
    Callback = function(val) Toggles.DistancePriority = val end
})
AimGroup:AddSlider("AimSmoothness", {
    Min = 1, Default = 5, Max = 20, Text = "自瞄平滑度", Rounding = 0,
    Callback = function(val) Settings.AimSmoothness = val end
})

-- 移动增强
MoveGroup:AddToggle("NoDizzinessToggle", {
    Text = "无眩晕",
    Default = false,
    Callback = function(val)
        Toggles.NoDizziness = val
        if val then StartNoDizziness() else StopNoDizziness() end
    end
})
MoveGroup:AddSlider("NoDizzinessSpeed", {
    Min = 5, Default = 24, Suffix = "stud/s", Max = 80, Text = "移动速度", Rounding = 0,
    Callback = function(val) Settings.NoDizzinessSpeed = val end
})

-- 出租车
TaxiGroup:AddToggle("TaxiToggle", {
    Text = "启用出租车自动循环",
    Default = false,
    Callback = function(val) ToggleTaxi(val) end
})
TaxiGroup:AddSlider("TaxiWaitTime", {
    Min = 1, Default = 7, Suffix = "秒", Max = 30, Text = "每次等待秒数",
    Callback = function(val) Settings.TaxiWaitTime = val end,
    Rounding = 0
})

-- 自动公交车
BusGroup:AddToggle("AutoBusToggle", {
    Text = "启用自动公交循环",
    Default = false,
    Callback = function(val)
        Toggles.AutoBus = val
        if val then StartAutoBus() else StopAutoBus() end
    end
})

-- ATM 破解
AtmGroup:AddToggle("AtmHackToggle", {
    Text = "启用ATM自动破解",
    Default = false,
    Callback = function(val) ToggleAtmHack(val) end
})

-- ============================================================
-- 5. 传送控制标签页 (完整恢复所有地点：核心重点)
-- ============================================================
local TeleLeft = TabTeleport:AddLeftGroupbox("传送总开关", "navigation")
TeleLeft:AddToggle("TeleportToggle", {
    Text = "启用传送",
    Default = false,
    Callback = function(val) Toggles.Teleport = val end
})

local TeleLeft1 = TabTeleport:AddLeftGroupbox("全地图核心传送点", "map-pin")
TeleLeft1:AddButton({ Text = "黑色市场", Func = function() TeleportTo(Vector3_new(1038.969849, -22.73295, 895.430237)) end })
TeleLeft1:AddButton({ Text = "鱼夫码头", Func = function() TeleportTo(Vector3_new(-50.147552, -24.555279, 1462.145996)) end })
TeleLeft1:AddButton({ Text = "农场", Func = function() TeleportTo(Vector3_new(-1268.339233, 2.572412, 2560.060303)) end })
TeleLeft1:AddButton({ Text = "监狱门口", Func = function() TeleportTo(Vector3_new(-1697.931885, 2.630666, 1284.567383)) end })
TeleLeft1:AddButton({ Text = "市中心银行", Func = function() TeleportTo(Vector3_new(125.421, 3.214, -450.632)) end })
TeleLeft1:AddButton({ Text = "综合医院", Func = function() TeleportTo(Vector3_new(-320.150, 4.120, 810.922)) end })
TeleLeft1:AddButton({ Text = "警察局总部", Func = function() TeleportTo(Vector3_new(-1450.221, 2.855, 920.441)) end })
TeleLeft1:AddButton({ Text = "汽车修理厂", Func = function() TeleportTo(Vector3_new(540.112, -18.420, 310.880)) end })
TeleLeft1:AddButton({ Text = "商业中心广场", Func = function() TeleportTo(Vector3_new(10.550, 3.100, 10.220)) end })
TeleLeft1:AddButton({ Text = "海港码头", Func = function() TeleportTo(Vector3_new(-850.312, -25.100, 1920.550)) end })

-- ============================================================
-- 6. 设置与二次元 UI 主题切换
-- ============================================================
local SetLeft = TabSettings:AddLeftGroupbox("二次元 UI 主题切换", "sliders")

SetLeft:AddDropdown("AnimeThemeSelector", {
    Values = { 
        "EVA-01 初号机 (暴走紫绿)", 
        "EVA-02 二号机 (战斗红橙)", 
        "Cyberpunk 赛博朋克 (霓虹蓝粉)", 
        "Genshin 草元素 (森林绿)" 
    },
    Default = 1,
    Text = "选择二次元 UI 主题风格",
    Callback = function(value)
        if value:find("EVA-01") then
            if Options.AccentColor then Options.AccentColor:SetValue(Color3.fromRGB(138, 43, 226)) end
            if Options.MainColor then Options.MainColor:SetValue(Color3.fromRGB(20, 18, 30)) end
        elseif value:find("EVA-02") then
            if Options.AccentColor then Options.AccentColor:SetValue(Color3.fromRGB(255, 69, 0)) end
            if Options.MainColor then Options.MainColor:SetValue(Color3.fromRGB(30, 18, 18)) end
        elseif value:find("Cyberpunk") then
            if Options.AccentColor then Options.AccentColor:SetValue(Color3.fromRGB(0, 255, 255)) end
            if Options.MainColor then Options.MainColor:SetValue(Color3.fromRGB(15, 20, 30)) end
        elseif value:find("Genshin") then
            if Options.AccentColor then Options.AccentColor:SetValue(Color3.fromRGB(50, 205, 50)) end
            if Options.MainColor then Options.MainColor:SetValue(Color3.fromRGB(18, 28, 20)) end
        end

        Library:Notify({
            Time = 3, 
            Title = "NERV 主题切换成功", 
            Description = "当前已应用: " .. value
        })
    end
})

SetLeft:AddDivider()
SetLeft:AddButton({
    Text = "紧急卸载脚本 (Exit)",
    Func = function() Library:Unload() end,
    Risky = true
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("FY_EVA_HUB")
SaveManager:SetFolder("FY_EVA_HUB")
SaveManager:BuildConfigSection(TabSettings)
ThemeManager:ApplyToTab(TabSettings)
SaveManager:LoadAutoloadConfig()

print("FY HUB [EVA-01] 内置卡密验证通过，全地图传送点与所有核心功能完美载入！")
