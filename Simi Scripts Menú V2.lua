-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Estados
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false
local godEnabled = false
local fpsBoostEnabled = false
local menuVisible = false

-- Servicios
local RunService = game:GetService("RunService")
local playerGui = player:WaitForChild("PlayerGui")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Botón circular para abrir menú
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 15, 0, 15)
openButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
openButton.BorderSizePixel = 2
openButton.BorderColor3 = Color3.fromRGB(255,0,0)
openButton.Text = "Simi Scripts"
openButton.TextColor3 = Color3.fromRGB(255,255,255)
openButton.TextScaled = true
openButton.AutoButtonColor = true
openButton.Visible = true
openButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5,0)
corner.Parent = openButton

-- Menú principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 300)
mainFrame.Position = UDim2.new(0, 80, 0, 80)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderSizePixel = 2
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Título y subtítulo
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0,10,0,5)
title.Text = "Menú Plus"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.BackgroundTransparency = 1

local subtitle = Instance.new("TextLabel", mainFrame)
subtitle.Size = UDim2.new(1, -20, 0, 20)
subtitle.Position = UDim2.new(0,10,0,45)
subtitle.Text = "TikTok: @gerardovillaruizoficial"
subtitle.TextColor3 = Color3.fromRGB(255,255,255)
subtitle.TextScaled = true
subtitle.BackgroundTransparency = 1

-- Función para crear botones ON/OFF
local function createToggleButton(name, posY, stateVar, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(255,0,0)
    btn.TextScaled = true
    btn.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local function updateText()
        btn.Text = name.." ["..(stateVar() and "ON" or "OFF").."]"
    end

    btn.MouseButton1Click:Connect(function()
        callback()
        updateText()
    end)

    updateText()
    return btn
end

-- Crear botones principales
createToggleButton("Noclip", 75, function() return noclipEnabled end, function()
    noclipEnabled = not noclipEnabled
end)

createToggleButton("Speed Boost", 115, function() return speedEnabled end, function()
    speedEnabled = not speedEnabled
    humanoid.WalkSpeed = speedEnabled and 100 or 16
end)

createToggleButton("Jump Boost", 155, function() return jumpEnabled end, function()
    jumpEnabled = not jumpEnabled
    humanoid.JumpPower = jumpEnabled and 200 or 50
end)

createToggleButton("God Mode", 195, function() return godEnabled end, function()
    godEnabled = not godEnabled
end)

createToggleButton("Mejorador de FPS", 235, function() return fpsBoostEnabled end, function()
    fpsBoostEnabled = not fpsBoostEnabled
    if fpsBoostEnabled then
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 100000
        lighting.Brightness = 2
        lighting.ClockTime = 12
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.Plastic
                part.Reflectance = 0
                part.CastShadow = false
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
                part.Enabled = false
            end
        end
    end
end)

-- Abrir/cerrar menú principal
openButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
end)

-- Bordes RGB animados
RunService.Stepped:Connect(function()
    local t = tick()
    local r = math.floor(127 * math.sin(t) + 128)
    local g = math.floor(127 * math.sin(t + 2) + 128)
    local b = math.floor(127 * math.sin(t + 4) + 128)

    mainFrame.BorderColor3 = Color3.fromRGB(r,g,b)
    openButton.BorderColor3 = Color3.fromRGB(b,r,g)
end)

-- God Mode y Noclip
RunService.Stepped:Connect(function()
    if godEnabled then
        humanoid.Health = humanoid.MaxHealth
        humanoid.MaxHealth = math.huge
    else
        humanoid.MaxHealth = 100
    end

    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        local vel = hrp.Velocity
        hrp.Velocity = Vector3.new(vel.X,0,vel.Z)
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)
