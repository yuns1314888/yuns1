-- ============================================================
-- FY
-- ============================================================
-- 加载 UI 库（以 Rayfield 为例）
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 创建卡密验证窗口
local Window = Rayfield:CreateWindow({
    Name = "脚本授权验证系统",
    LoadingTitle = "正在初始化验证...",
    LoadingSubtitle = "By 你的名字",
    ConfigurationSaving = {
        Enabled = false
    },
    
    -- 卡密系统核心配置
    KeySystem = true, -- 开启卡密验证
    KeySettings = {
        Title = "请输入卡密",
        Subtitle = "本地硬编码验证模式",
        Note = "请输入您的专属卡密以进入脚本",
        FileName = "MyScriptKeySave", -- 本地存储卡密的文件名（防止重复输入）
        SaveKey = true, -- 验证成功后自动保存
        GrabKeyFromSite = false, -- 关闭远程获取，使用本地硬编码
        Key = {
            "FYNB666" -- 设置你的专属卡密
        } 
    }
})

-- ==========================================
-- 验证通过后执行的代码写在下方
-- ==========================================

Rayfield:Notify({
    Title = "验证成功",
    Content = "卡密正确，欢迎使用！",
    Duration = 3
})

-- 1. 加载库
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

-- 2. 服务和工具
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local FromRGB = Color3.fromRGB
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new
local task = task

-- 3. 远程事件与模块
local PlayerEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("PlayerEvent")
local Modules = ReplicatedStorage.Modules
local Algorithms = require(Modules.Algorithms)

-- 4. 全局状态
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
-- 5. 核心功能（完全原始逻辑）
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
        pcall(function()
            PlayerEvent:FireServer("combatMode", true)
        end)
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
                    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                    local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
                    if targetRoot and targetHum and targetHum.Health > 0 then
                        local dist = (targetRoot.Position - root.Position).Magnitude
                        if dist <= Settings.KillAuraRange then
                            pcall(function()
                                PlayerEvent:FireServer("attack", targetRoot.Position)
                            end)
                        end
                    end
                end
            end
        end
    end)
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
                    if obj.Name == "Area" then
                        table.insert(areas, obj)
                    end
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
                                root.CFrame = area.CFrame * CFrame_new(0, 0, 5)
                            end)
                        end
                        task.wait(Settings.TaxiWaitTime)
                    end
                end
            end
        end)
        Library:Notify({Time = 2, Title = "出租车", Description = "已开启"})
    else
        if TaxiTask then
            task.cancel(TaxiTask)
            TaxiTask = nil
        end
    end
end

-- 公交车（严格原始顺序：不移动根部件，只操作座位）
function StartAutoBus()
    if AutoBusTask then task.cancel(AutoBusTask) end
    AutoBusTask = task.spawn(function()
        while Toggles.AutoBus do
            local areas = {}
            local clientContent = Workspace:FindFirstChild("Gameplay") and Workspace.Gameplay:FindFirstChild("Entities") and Workspace.Gameplay.Entities:FindFirstChild("ClientContent")
            local searchRoot = clientContent or Workspace
            for _, obj in ipairs(searchRoot:GetDescendants()) do
                if obj.Name == "Area" then
                    table.insert(areas, obj)
                end
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
                        local targetCF = (area.CFrame * CFrame_new(3, 3, 16)) * CFrame.Angles(0, math.pi, 0)
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
                    task.wait(Settings.TaxiWaitTime)
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

function ToggleAtmHack(enabled)
    Toggles.AtmHack = enabled
    if enabled then
        if AtmHackTask then task.cancel(AtmHackTask) end
        AtmHackTask = task.spawn(function()
            while Toggles.AtmHack do
                task.wait(5)
                pcall(function()
                    PlayerEvent:FireServer("atmHack")
                end)
            end
        end)
        Library:Notify({Time = 2, Title = "ATM破解", Description = "已开启"})
    else
        if AtmHackTask then
            task.cancel(AtmHackTask)
            AtmHackTask = nil
        end
        Library:Notify({Time = 2, Title = "ATM破解", Description = "已关闭"})
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
        pcall(function()
            root.CFrame = CFrame_new(position)
        end)
        Library:Notify({Time = 2, Title = "传送", Description = "已传送"})
    end
end

function ToggleBulletTrack(enabled)
    Toggles.BulletTrack = enabled
    if enabled then
        pcall(function()
            local old = Algorithms.bulletSpread
            Algorithms.bulletSpread = function(...)
                if Toggles.BulletTrack then
                    -- 追踪逻辑（原始未实现）
                end
                return old(...)
            end
        end)
    end
end

-- ============================================================
-- 6. GUI 构建（与原始完全一致，无额外控件）
-- ============================================================

local Window = Library:CreateWindow({
    Title = "FY HUB",
    Footer = "FY | 正式版本 | v9.1",
    NotifySide = "Right",
    MobileButtonsSide = "Right",
    Icon = 95816097006870,
    ShowCustomCursor = true,
})

local TabMain = Window:AddTab("主要", "target")
local TabTeleport = Window:AddTab("传送点", "map-pin")
local TabSettings = Window:AddTab("设置", "settings")
local TabBullet = Window:AddTab("子弹追踪", "crosshair")

-- 主要标签页分组
local LeftMain = TabMain:AddLeftGroupbox("交互设置", "hand")
local RightMain = TabMain:AddRightGroupbox("碰撞箱扩展", "target")
local AimGroup = TabMain:AddRightGroupbox("自瞄功能", "crosshair")
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

-- 碰撞箱扩展
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

-- 自瞄
AimGroup:AddToggle("AimToggle", {
    Text = "启用自瞄",
    Default = false,
    Callback = function(val) Toggles.Aim = val end
})
AimGroup:AddSlider("AimSmoothness", {
    Min = 1, Default = 5, Max = 20, Text = "平滑度", Rounding = 0,
    Callback = function(val) Settings.AimSmoothness = val end
})
AimGroup:AddSlider("AimMaxDistance", {
    Min = 50, Default = 200, Suffix = "单位", Max = 500, Text = "检测距离", Rounding = 0,
    Callback = function(val) Settings.AimMaxDistance = val end
})
AimGroup:AddToggle("AimCheckWall", {
    Text = "墙壁检测",
    Default = true,
    Callback = function(val) Settings.AimCheckWall = val end
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

-- ESP（仅UI）
TabMain:AddLeftGroupbox("ESP透视", "target"):AddToggle("SkeletonToggle", {
    Text = "启用ESP透视",
    Default = false,
    Callback = function(val) end
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

-- 自动公交车（无额外偏移滑块）
BusGroup:AddToggle("AutoBusToggle", {
    Text = "启用自动传送（圈）",
    Default = false,
    Callback = function(val)
        Toggles.AutoBus = val
        if val then
            StartAutoBus()
            Library:Notify({Time = 2, Title = "自动公交车", Description = "已启动"})
        else
            StopAutoBus()
            Library:Notify({Time = 2, Title = "自动公交车", Description = "已停止"})
        end
    end
})

-- ATM
AtmGroup:AddToggle("AtmHackToggle", {
    Text = "启用ATM自动破解（每5秒）",
    Default = false,
    Callback = function(val) ToggleAtmHack(val) end
})

-- ---- 传送点标签页 ----
local TeleLeft = TabTeleport:AddLeftGroupbox("传送控制", "navigation")
TeleLeft:AddToggle("TeleportToggle", {
    Text = "启用传送",
    Default = false,
    Callback = function(val) Toggles.Teleport = val end
})

local function AddTeleportButton(group, name, pos)
    group:AddButton({
        Text = name,
        Func = function() TeleportTo(pos) end
    })
end

-- 所有传送点（与原始一致）
local TeleLeft1 = TabTeleport:AddLeftGroupbox("其他", "map-pin")
AddTeleportButton(TeleLeft1, "黑色市场", Vector3_new(1038.969849, -22.73295, 895.430237))
AddTeleportButton(TeleLeft1, "鱼夫码头", Vector3_new(-50.147552, -24.555279, 1462.145996))
AddTeleportButton(TeleLeft1, "农场", Vector3_new(-1268.339233, 2.572412, 2560.060303))
AddTeleportButton(TeleLeft1, "监狱门口", Vector3_new(-1697.931885, 2.630666, 1284.567383))
AddTeleportButton(TeleLeft1, "监狱广场", Vector3_new(-1600.602417, 2.631028, 1268.060059))
AddTeleportButton(TeleLeft1, "代尔山", Vector3_new(847.062988, 194.115753, -326.212708))
AddTeleportButton(TeleLeft1, "水帘洞(消星点)", Vector3_new(3040.956055, 109.688538, 2711.069336))
AddTeleportButton(TeleLeft1, "大桥", Vector3_new(949.014954, 25.215754, 2897.654785))
AddTeleportButton(TeleLeft1, "地图右下(消星点)", Vector3_new(-1651.38501, 2.414712, 3225.27832))
AddTeleportButton(TeleLeft1, "下部加油站", Vector3_new(2270.378174, 2.630927, 154.161484))
AddTeleportButton(TeleLeft1, "游戏厅", Vector3_new(2934.893799, 2.956458, 1693.660034))
AddTeleportButton(TeleLeft1, "高尔夫", Vector3_new(2280.76709, 3.037836, 1982.3573))
AddTeleportButton(TeleLeft1, "修船厂", Vector3_new(4096.405273, -30.401447, 2865.045166))

local TeleRight1 = TabTeleport:AddRightGroupbox("圣奥里", "map-pin")
AddTeleportButton(TeleRight1, "车辆经销商", Vector3_new(3719.9501953125, 3.0185735225677, -333.31185913086))
AddTeleportButton(TeleRight1, "医院", Vector3_new(3980.0910644531, 2.8760607242584, -138.79454040527))
AddTeleportButton(TeleRight1, "警察局", Vector3_new(3364.2731933594, 3.9188079834, -394.7233581543))
AddTeleportButton(TeleRight1, "圣奥里修车店", Vector3_new(2782.46875, 2.6309957504272, -418.59930419922))
AddTeleportButton(TeleRight1, "圣奥里银行", Vector3_new(3134.0541992188, 6.1160483360291, -171.36976623535))
AddTeleportButton(TeleRight1, "圣奥里服装店", Vector3_new(3617.9125976562, 3.1072206497192, -452.82064819336))
AddTeleportButton(TeleRight1, "圣奥里平民重生", Vector3_new(3741.1149902344, 3.7205736637115, -438.10598754883))
AddTeleportButton(TeleRight1, "圣奥里码头", Vector3_new(4527.65625, -23.968238830566, -280.59356689453))
AddTeleportButton(TeleRight1, "圣奥里餐饮店", Vector3_new(3182.4167480469, 3.0185918807983, 426.51791381836))
AddTeleportButton(TeleRight1, "消防部门", Vector3_new(3578.6760253906, 8.4088230133057, 579.65679931641))
AddTeleportButton(TeleRight1, "宠物店", Vector3_new(3678.237305, 3.01792, 693.114624))
AddTeleportButton(TeleRight1, "圣奥里大码头", Vector3_new(2736.307617, 2.630299, -1120.333008))
AddTeleportButton(TeleRight1, "圣奥里海滩桥下(消星点)", Vector3_new(3964.504395, -25.068211, -854.057251))

local TeleLeft2 = TabTeleport:AddLeftGroupbox("大景", "map-pin")
AddTeleportButton(TeleLeft2, "大景超级超市", Vector3_new(3936.582764, 3.038293, 1136.326416))
AddTeleportButton(TeleLeft2, "转镜中心", Vector3_new(4152.919922, 2.631675, 941.446045))
AddTeleportButton(TeleLeft2, "道路服务", Vector3_new(4271.33252, 2.628108, 1200.086914))
AddTeleportButton(TeleLeft2, "大景餐饮店", Vector3_new(4476.997559, 3.037825, 906.802979))
AddTeleportButton(TeleLeft2, "送货中心(美团外卖)", Vector3_new(4399.419434, 3.038999, 1609.455933))
AddTeleportButton(TeleLeft2, "大景卖车店", Vector3_new(3434.377441, 42.931786, 2687.99707))

local TeleRight2 = TabTeleport:AddRightGroupbox("米尔顿", "map-pin")
AddTeleportButton(TeleRight2, "米尔顿左上加油站", Vector3_new(1145.635742, 2.630916, -864.273682))
AddTeleportButton(TeleRight2, "米尔顿右下加油站", Vector3_new(-1646.802734, 2.630164, 1812.894653))
AddTeleportButton(TeleRight2, "米尔顿上方加油站", Vector3_new(-900.70166, 2.630927, 1124.683105))
AddTeleportButton(TeleRight2, "米尔顿居民区", Vector3_new(-528.565552, 2.630996, 1331.981689))

local TeleLeft3 = TabTeleport:AddLeftGroupbox("约克镇", "map-pin")
AddTeleportButton(TeleLeft3, "约克镇小银行", Vector3_new(-668.217224, 2.630995, -65.347839))
AddTeleportButton(TeleLeft3, "约克镇修车厂", Vector3_new(-407.163025, 3.076807, -6.098211))
AddTeleportButton(TeleLeft3, "约克镇枪店", Vector3_new(-323.869293, 3.037825, 37.14967))
AddTeleportButton(TeleLeft3, "约克镇重生点", Vector3_new(-219.560318, 3.039824, -85.725433))
AddTeleportButton(TeleLeft3, "约克镇当铺", Vector3_new(-168.513733, 3.039, -106.926529))
AddTeleportButton(TeleLeft3, "约克镇卫星车", Vector3_new(-302.093567, 3.037825, -167.621017))
AddTeleportButton(TeleLeft3, "约克镇中心点", Vector3_new(-275.995209, 2.630996, -139.985352))

local TeleRight3 = TabTeleport:AddRightGroupbox("莱斯维尔", "map-pin")
AddTeleportButton(TeleRight3, "莱斯维尔餐饮店", Vector3_new(753.757812, 3.039824, 998.132996))
AddTeleportButton(TeleRight3, "莱斯维尔服装店", Vector3_new(820.745117, 2.766988, 1047.445679))
AddTeleportButton(TeleRight3, "莱斯维尔自由广场", Vector3_new(926.523376, 2.630995, 865.764771))
AddTeleportButton(TeleRight3, "莱斯维尔码头(游艇)", Vector3_new(947.84021, -22.529087, 1216.085693))

-- ---- 设置标签页 ----
local SetLeft = TabSettings:AddLeftGroupbox("菜单设置", "sliders")
SetLeft:AddToggle("ShowCustomCursor", {
    Text = "自定义光标",
    Default = Library.ShowCustomCursor,
    Callback = function(val)
        Library.ShowCustomCursor = val
        Toggles.ShowCustomCursor = val
    end
})
SetLeft:AddButton({
    Text = "卸载 FY HUB",
    Func = function() Library:Unload() end,
    Risky = true
})

-- ---- 子弹追踪标签页 ----
local BulletGroup = TabBullet:AddLeftGroupbox("追踪控制", "target")
BulletGroup:AddToggle("BulletTrackToggle", {
    Text = "启用子弹追踪",
    Default = false,
    Callback = function(val) ToggleBulletTrack(val) end
})
BulletGroup:AddDivider()
BulletGroup:AddToggle("ScreenPriority", {
    Text = "屏幕中心优先",
    Default = true,
    Callback = function(val) Toggles.ScreenPriority = val end
})
BulletGroup:AddToggle("DistancePriority", {
    Text = "距离优先（锁定最近）",
    Default = false,
    Callback = function(val) Toggles.DistancePriority = val end
})

-- ============================================================
-- 7. 事件监听
-- ============================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    task.wait(0.5)
    if Toggles.Noclip then
        for _, part in ipairs(newChar:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if Toggles.Hitbox then ApplyHitbox(Settings.HitboxSize) end
    if Toggles.AutoBus then StartAutoBus() end
    if Toggles.Taxi then ToggleTaxi(true) end
    if Toggles.KillAura then StartKillAura() end
    if Toggles.NoDizziness then StartNoDizziness() end
end)

Workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("ProximityPrompt") then
        desc.HoldDuration = Settings.HoldTime
        desc.MaxActivationDistance = Settings.Distance
    end
end)

Players.PlayerAdded:Connect(function(player)
    if Toggles.Whitelist then
        pcall(function()
            if player:IsFriendsWith(LocalPlayer.UserId) then
                FriendWhitelist[player.UserId] = true
            end
        end)
    end
end)

-- ============================================================
-- 8. 配置管理
-- ============================================================

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("FY_HUB")
SaveManager:SetFolder("FY_HUB")
SaveManager:SetSubFolder("Configs")
SaveManager:BuildConfigSection(TabSettings)
ThemeManager:ApplyToTab(TabSettings)
SaveManager:LoadAutoloadConfig()

-- ============================================================
-- 9. 初始化默认值
-- ============================================================

task.spawn(function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
            obj.MaxActivationDistance = 25
        end
    end
end)

-- ============================================================
-- 10. 卸载清理
-- ============================================================

local OldUnload = Library.OnUnload
Library.OnUnload = function(...)
    Toggles.AutoBus = false; StopAutoBus()
    Toggles.Taxi = false; ToggleTaxi(false)
    Toggles.AtmHack = false; ToggleAtmHack(false)
    Toggles.KillAura = false; ToggleKillAura(false)
    Toggles.NoDizziness = false; StopNoDizziness()
    if Toggles.Hitbox then ResetHitbox() end
    if OldUnload then OldUnload(...) end
    Library:Notify({Time = 1, Title = "FY HUB", Description = "已卸载"})
end

print("FY已加载")
print("冷知识: 脚本作者其实是你爹")