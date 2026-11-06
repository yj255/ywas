local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ==========================================
-- DEFAULT CONFIGURATIONS
-- ==========================================
local FLYING = false
local NOCLIP = false
local ANTIDIE = false
local ANTIAFK = false 
local TimerEnabled = false 
local AUTOTELEPORT = false -- الميزة الجديدة

local FLY_SPEED = 60
local RUN_SPEED = 32
local SpeedEnabled = false
local savedPosition = nil
local timerActive = false
local menuCollapsed = false

-- Create Soothing Hover Sound
local HoverSound = Instance.new("Sound")
HoverSound.SoundId = "rbxassetid://6895079853"
HoverSound.Volume = 0.5
HoverSound.Parent = CoreGui:FindFirstChild("RobloxGui") or player:WaitForChild("PlayerGui")

-- ==========================================
-- ANTI-AFK SYSTEM
-- ==========================================
player.Idled:Connect(function()
    if ANTIAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- ==========================================
-- PREMIUM USER INTERFACE (V3 ULTRA EDITION)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenuV3_Premium"
ScreenGui.ResetOnSpawn = false
local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 520)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(35, 38, 50)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
Title.BorderSizePixel = 0
Title.Text = "⚡ GANG MENU V2 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = Title

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 15)
TitleFix.Position = UDim2.new(0, 0, 1, -15)
TitleFix.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = Title

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Name = "CollapseBtn"
CollapseBtn.Size = UDim2.new(0, 35, 0, 35)
CollapseBtn.Position = UDim2.new(1, -45, 0, 10)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(24, 27, 38)
CollapseBtn.Text = "_"
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.Font = Enum.Font.GothamBold
CollapseBtn.TextSize = 16
CollapseBtn.AutoButtonColor = false
CollapseBtn.ZIndex = 5
CollapseBtn.Parent = MainFrame

local CollapseCorner = Instance.new("UICorner")
CollapseCorner.CornerRadius = UDim.new(0, 8)
CollapseCorner.Parent = CollapseBtn

local CollapseStroke = Instance.new("UIStroke")
CollapseStroke.Thickness = 1
CollapseStroke.Color = Color3.fromRGB(45, 50, 68)
CollapseStroke.Parent = CollapseBtn

local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 0, 54)
Line.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Name = "TimerLabel"
TimerLabel.Size = UDim2.new(0, 260, 0, 60)
TimerLabel.Position = UDim2.new(0.5, -130, 0, 65)
TimerLabel.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
TimerLabel.TextColor3 = Color3.fromRGB(0, 255, 204)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextSize = 20
TimerLabel.Text = "Time: 00:00"
TimerLabel.Visible = false
TimerLabel.Parent = ScreenGui

local TimerCorner = Instance.new("UICorner")
TimerCorner.CornerRadius = UDim.new(0, 14)
TimerCorner.Parent = TimerLabel

local TimerStroke = Instance.new("UIStroke")
TimerStroke.Thickness = 2.5
TimerStroke.Color = Color3.fromRGB(0, 204, 255)
TimerStroke.Parent = TimerLabel

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -24, 1, -75)
Container.Position = UDim2.new(0, 12, 0, 65)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 0 
Container.CanvasSize = UDim2.new(0, 0, 0, 610) -- تم زيادة الحجم لتناسب الزر الجديد
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

local function setToggleStyle(button, enabled)
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(0, 168, 102)
        button.Text = button.Name .. "  •  ON"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        if button:FindFirstChild("Stroke") then 
            button.Stroke.Color = Color3.fromRGB(0, 255, 150) 
            button.Stroke.Thickness = 1.5
        end
    else
        button.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
        button.Text = button.Name .. "  •  OFF"
        button.TextColor3 = Color3.fromRGB(140, 145, 160) 
        if button:FindFirstChild("Stroke") then 
            button.Stroke.Color = Color3.fromRGB(40, 45, 58) 
            button.Stroke.Thickness = 1
        end
    end
end

local function createButton(name, order)
    local btn = Instance.new("TextButton")
    local btnStroke = Instance.new("UIStroke") 
    
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.LayoutOrder = order
    btn.AutoButtonColor = false 
    btn.Parent = Container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    btnStroke.Name = "Stroke"
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        HoverSound:Play()
        if not string.find(btn.Text, "ON") and btn.Name ~= "Save Position" and btn.Name ~= "Teleport to Save" and btn.Name ~= "Auto Teleport" then
            btn.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
            btnStroke.Color = Color3.fromRGB(75, 80, 100)
        end
    end)
    btn.MouseLeave:Connect(function()
        if not string.find(btn.Text, "ON") and btn.Name ~= "Save Position" and btn.Name ~= "Teleport to Save" and btn.Name ~= "Auto Teleport" then
            btn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
            btnStroke.Color = Color3.fromRGB(40, 45, 58)
        end
    end)
    
    setToggleStyle(btn, false)
    return btn
end

local function createInput(placeholder, default, order)
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, 0, 0, 36)
    input.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = Color3.fromRGB(80, 85, 100)
    input.Text = tostring(default)
    input.Font = Enum.Font.GothamMedium
    input.TextSize = 12
    input.LayoutOrder = order
    input.Parent = Container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Thickness = 1
    inputStroke.Color = Color3.fromRGB(35, 40, 52)
    inputStroke.Parent = input
    
    input.Focused:Connect(function() inputStroke.Color = Color3.fromRGB(0, 162, 255) end)
    input.FocusLost:Connect(function() inputStroke.Color = Color3.fromRGB(35, 40, 52) end)
    
    return input
end

local FlyBtn = createButton("Fly", 1)
local FlyInput = createInput("Set Fly Speed...", FLY_SPEED, 2)
local SpeedBtn = createButton("Speed", 3)
local SpeedInput = createInput("Set Walk Speed...", RUN_SPEED, 4)
local NoclipBtn = createButton("Noclip", 5)
local AntiDieBtn = createButton("Anti-Die", 6)
local SavePosBtn = createButton("Save Position", 7)
local TeleportBtn = createButton("Teleport to Save", 8)
local AutoTeleportBtn = createButton("Auto Teleport", 9) -- الزر الجديد
local AntiAfkBtn = createButton("Anti-AFK", 10)
local TimerBtn = createButton("Timer", 11)

SavePosBtn.BackgroundColor3 = Color3.fromRGB(20, 45, 78)
SavePosBtn.Stroke.Color = Color3.fromRGB(32, 78, 135)
SavePosBtn.TextColor3 = Color3.fromRGB(225, 240, 255)
SavePosBtn.Text = "Save Position"

TeleportBtn.BackgroundColor3 = Color3.fromRGB(48, 22, 78)
TeleportBtn.Stroke.Color = Color3.fromRGB(85, 38, 135)
TeleportBtn.TextColor3 = Color3.fromRGB(245, 230, 255)
TeleportBtn.Text = "Teleport"

CollapseBtn.MouseEnter:Connect(function()
    HoverSound:Play()
    CollapseBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
end)
CollapseBtn.MouseLeave:Connect(function()
    CollapseBtn.BackgroundColor3 = Color3.fromRGB(24, 27, 38)
end)

CollapseBtn.MouseButton1Click:Connect(function()
    menuCollapsed = not menuCollapsed
    local targetSize = menuCollapsed and UDim2.new(0, 320, 0, 55) or UDim2.new(0, 320, 0, 520)
    
    if menuCollapsed then
        Container.Visible = false
        CollapseBtn.Text = "+"
    else
        CollapseBtn.Text = "_"
    end
    
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize})
    moveDir = nil 
    tween:Play()
    
    tween.Completed:Connect(function()
        if not menuCollapsed then
            Container.Visible = true
        end
    end)
end)

-- ==========================================
-- CORE FUNCTIONAL LOGIC
-- ==========================================

local isChangingSpeed = false
local function applySpeed()
    if isChangingSpeed then return end
    if SpeedEnabled and humanoid then
        if humanoid.WalkSpeed ~= RUN_SPEED then
            isChangingSpeed = true
            humanoid.WalkSpeed = RUN_SPEED
            isChangingSpeed = false
        end
    end
end

SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then
        RUN_SPEED = val
        applySpeed()
    end
end)

FlyInput.FocusLost:Connect(function()
    local val = tonumber(FlyInput.Text)
    if val then FLY_SPEED = val end
end)

local function updateAntiDie()
    if not humanoid then return end
    if ANTIDIE then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanTouch = false end
        end
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanTouch = true end
        end
    end
end

local function startTimerLogic()
    if timerActive then return end
    timerActive = true
    TimerLabel.Visible = true
    
    local startTime = os.time()
    
    task.spawn(function()
        while TimerEnabled and humanoid and humanoid.Health > 0 do
            local elapsed = os.time() - startTime
            local minutes = math.floor(elapsed / 60)
            local seconds = elapsed % 60
            TimerLabel.Text = string.format("Time: %02d:%02d", minutes, seconds)
            task.wait(1)
        end
        timerActive = false
        if not TimerEnabled then
            TimerLabel.Visible = false
        end
    end)
end

-- منطق الانتقال التلقائي كل ثانية
local function startAutoTeleportLogic()
    task.spawn(function()
        while AUTOTELEPORT do
            if savedPosition and rootPart and character and character.Parent then
                rootPart.CFrame = savedPosition
            end
            task.wait(1) -- الانتظار ثانية واحدة قبل التكرار
        end
    end)
end

local speedConnection

local function setupCharacterConnections(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    
    if speedConnection then speedConnection:Disconnect() end
    speedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(applySpeed)
    
    humanoid.Died:Connect(function()
        if TimerEnabled then
            TimerEnabled = false
            setToggleStyle(TimerBtn, false)
            TimerLabel.Visible = false
        end
    end)
    
    task.wait(0.2)
    if SpeedEnabled then applySpeed() end
    if ANTIDIE then updateAntiDie() end
end

-- Initialize first character
setupCharacterConnections(character)
player.CharacterAdded:Connect(setupCharacterConnections)

RunService.RenderStepped:Connect(function()
    if character and character.Parent then
        if NOCLIP then
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
            for _, child in pairs(character:GetDescendants()) do
                if child:IsA("BasePart") then child.CanCollide = false end
            end
        end
        
        if ANTIDIE and humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            if rootPart and rootPart.Position.Y < -2000 then
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                rootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end
    end
end)

-- Button Click Listeners
SpeedBtn.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    setToggleStyle(SpeedBtn, SpeedEnabled)
    if SpeedEnabled then applySpeed() else if humanoid then humanoid.WalkSpeed = 16 end end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    NOCLIP = not NOCLIP 
    setToggleStyle(NoclipBtn, NOCLIP)
end)

AntiDieBtn.MouseButton1Click:Connect(function()
    ANTIDIE = not ANTIDIE
    setToggleStyle(AntiDieBtn, ANTIDIE)
    updateAntiDie()
end)

AntiAfkBtn.MouseButton1Click:Connect(function()
    ANTIAFK = not ANTIAFK
    setToggleStyle(AntiAfkBtn, ANTIAFK)
end)

TimerBtn.MouseButton1Click:Connect(function()
    TimerEnabled = not TimerEnabled
    setToggleStyle(TimerBtn, TimerEnabled)
    if TimerEnabled then startTimerLogic() else TimerLabel.Visible = false end
end)

-- تفعيل / إيقاف الأوتو تيليبورت عند الضغط
AutoTeleportBtn.MouseButton1Click:Connect(function()
    if not savedPosition and not AUTOTELEPORT then
        AutoTeleportBtn.Text = "Save a Position First! ❌"
        task.wait(1)
        AutoTeleportBtn.Text = "Auto Teleport  •  OFF"
        return
    end
    
    AUTOTELEPORT = not AUTOTELEPORT
    setToggleStyle(AutoTeleportBtn, AUTOTELEPORT)
    if AUTOTELEPORT then
        startAutoTeleportLogic()
    end
end)

SavePosBtn.MouseButton1Click:Connect(function()
    if rootPart then
        savedPosition = rootPart.CFrame
        SavePosBtn.Text = "Position Saved! ✔"
        task.wait(1)
        SavePosBtn.Text = "Save Position"
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    if savedPosition and rootPart then
        rootPart.CFrame = savedPosition
    else
        TeleportBtn.Text = "No Saved Position! ❌"
        task.wait(1)
        TeleportBtn.Text = "Teleport"
    end
end)

FlyBtn.MouseButton1Click:Connect(function()
    FLYING = not FLYING
    setToggleStyle(FlyBtn, FLYING)
    
    if FLYING and rootPart then
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = rootPart.CFrame
        bg.Parent = rootPart
        
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0.1, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = rootPart
        
        task.spawn(function()
            while FLYING and rootPart and character:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end
                
                bv.Velocity = moveDir.Unit.Magnitude > 0 and moveDir.Unit * FLY_SPEED or Vector3.new(0, 0.1, 0)
                bg.CFrame = cam
                RunService.RenderStepped:Wait()
            end
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end)
    end
end)
