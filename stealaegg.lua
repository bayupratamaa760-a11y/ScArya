--[[
    STEAL & EGG SCRIPT - ROBLOX MAP
    Fitur:
    - Auto Steal Egg Terbaik (Rare/Legendary)
    - Auto Farm
    - Teleport ke Map
    - Anti AFK
    - ESP Egg dengan Warna Berdasarkan Rarity
    - Auto Collect
]]

-- ─── SERVICES ─────────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ─── UI ───────────────────────────────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 460)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- ─── BLUR / GLASS EFFECT ─────────────────────────────────────────────────
local Blur = Instance.new("BlurEffect")
Blur.Size = 10
Blur.Parent = MainFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 18)
Corner.Parent = MainFrame

-- ─── TITLE ──────────────────────────────────────────────────────────────
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🥚 STEAL & EGG PREMIUM 🥚"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ─── BUTTONS ─────────────────────────────────────────────────────────────
local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    btn.BackgroundTransparency = 0.25
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.05
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.25
        }):Play()
    end)
    
    return btn
end

-- ─── STATUS LABEL ──────────────────────────────────────────────────────────
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 35)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 410)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "⚡ Ready"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Parent = MainFrame

-- ─── EGG INFO LABEL ──────────────────────────────────────────────────────
local EggInfoLabel = Instance.new("TextLabel")
EggInfoLabel.Size = UDim2.new(0.9, 0, 0, 25)
EggInfoLabel.Position = UDim2.new(0.05, 0, 0, 385)
EggInfoLabel.BackgroundTransparency = 1
EggInfoLabel.Text = "🥚 Target: None"
EggInfoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
EggInfoLabel.TextScaled = true
EggInfoLabel.Font = Enum.Font.GothamMedium
EggInfoLabel.Parent = MainFrame

-- ─── DRAG FUNCTION ──────────────────────────────────────────────────────
local dragToggle = false
local dragStart
local dragStartPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        dragStartPos = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            dragStartPos.X.Scale,
            dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale,
            dragStartPos.Y.Offset + delta.Y
        )
    end
end)

-- ─── VARIABLES ────────────────────────────────────────────────────────────
local isStealing = false
local isFarming = false
local isTeleporting = false
local targetEgg = nil
local eggList = {}
local collectedEggs = 0
local currentBestEgg = nil

-- ─── EGG RARITY SYSTEM ──────────────────────────────────────────────────
local EggRarity = {
    Common = {value = 1, color = Color3.fromRGB(150, 150, 150), label = "Common"},
    Uncommon = {value = 2, color = Color3.fromRGB(0, 200, 0), label = "Uncommon"},
    Rare = {value = 3, color = Color3.fromRGB(0, 100, 255), label = "Rare"},
    Epic = {value = 4, color = Color3.fromRGB(150, 0, 255), label = "Epic"},
    Legendary = {value = 5, color = Color3.fromRGB(255, 150, 0), label = "Legendary"},
    Mythic = {value = 6, color = Color3.fromRGB(255, 0, 0), label = "Mythic"},
}

-- ─── GET EGG RARITY ──────────────────────────────────────────────────────
local function getEggRarity(egg)
    local rarity = "Common"
    
    -- Cek dari nama
    local name = egg.Name:lower()
    if name:find("legendary") or name:find("legenda") then
        rarity = "Legendary"
    elseif name:find("mythic") or name:find("mitos") then
        rarity = "Mythic"
    elseif name:find("epic") or name:find("epik") then
        rarity = "Epic"
    elseif name:find("rare") or name:find("langka") then
        rarity = "Rare"
    elseif name:find("uncommon") or name:find("langka") then
        rarity = "Uncommon"
    end
    
    -- Cek dari atribut/attribute
    local attr = egg:FindFirstChild("Rarity") or egg:FindFirstChild("EggRarity")
    if attr and attr:IsA("StringValue") then
        local val = attr.Value:lower()
        if val:find("legendary") or val:find("legenda") then
            rarity = "Legendary"
        elseif val:find("mythic") or val:find("mitos") then
            rarity = "Mythic"
        elseif val:find("epic") or val:find("epik") then
            rarity = "Epic"
        elseif val:find("rare") or val:find("langka") then
            rarity = "Rare"
        elseif val:find("uncommon") then
            rarity = "Uncommon"
        end
    end
    
    -- Cek dari BrickColor
    if egg:IsA("BasePart") then
        local color = egg.BrickColor.Name:lower()
        if color:find("gold") or color:find("yellow") or color:find("orange") then
            rarity = "Legendary"
        elseif color:find("red") or color:find("crimson") then
            rarity = "Mythic"
        elseif color:find("purple") or color:find("violet") then
            rarity = "Epic"
        elseif color:find("blue") or color:find("cyan") then
            rarity = "Rare"
        elseif color:find("green") then
            rarity = "Uncommon"
        end
    end
    
    return EggRarity[rarity] or EggRarity.Common
end

-- ─── FIND EGGS ────────────────────────────────────────────────────────────
local function findEggs()
    eggList = {}
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local name = v.Name:lower()
            if name:find("egg") or name:find("telur") or name:find("rare") or name:find("legenda") then
                table.insert(eggList, v)
            end
        end
    end
    
    return eggList
end

-- ─── FIND BEST EGG ──────────────────────────────────────────────────────
local function findBestEgg()
    local eggs = findEggs()
    local bestEgg = nil
    local bestRarity = EggRarity.Common.value
    
    for _, egg in pairs(eggs) do
        local rarity = getEggRarity(egg)
        if rarity.value > bestRarity then
            bestRarity = rarity.value
            bestEgg = egg
        end
    end
    
    currentBestEgg = bestEgg
    
    if bestEgg then
        local rarity = getEggRarity(bestEgg)
        EggInfoLabel.Text = "🥚 Target: " .. rarity.label .. " Egg"
        EggInfoLabel.TextColor3 = rarity.color
    else
        EggInfoLabel.Text = "🥚 Target: None"
        EggInfoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    
    return bestEgg
end

-- ─── GET EGG POSITION ────────────────────────────────────────────────────
local function getEggPosition(egg)
    if egg:IsA("BasePart") then
        return egg.Position
    elseif egg:IsA("Model") then
        local primary = egg.PrimaryPart
        if primary then
            return primary.Position
        end
        for _, v in pairs(egg:GetDescendants()) do
            if v:IsA("BasePart") then
                return v.Position
            end
        end
    end
    return nil
end

-- ─── AUTO STEAL BEST EGG ─────────────────────────────────────────────────
local function autoStealBestEgg()
    if isStealing then
        isStealing = false
        StatusLabel.Text = "⏹ Stopped"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    isStealing = true
    StatusLabel.Text = "🔍 Searching best egg..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    while isStealing do
        local bestEgg = findBestEgg()
        
        if bestEgg then
            local pos = getEggPosition(bestEgg)
            local rarity = getEggRarity(bestEgg)
            
            if pos then
                StatusLabel.Text = "🥚 Stealing " .. rarity.label .. " egg..."
                StatusLabel.TextColor3 = rarity.color
                
                -- Teleport ke egg
                RootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                wait(0.2)
                
                -- Steal egg
                local stealEvent = game:GetService("ReplicatedStorage"):FindFirstChild("StealEgg")
                if stealEvent then
                    stealEvent:FireServer(bestEgg)
                end
                
                collectedEggs = collectedEggs + 1
                StatusLabel.Text = "✅ Stolen " .. rarity.label .. "! (" .. collectedEggs .. " total)"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                
                wait(0.8)
            end
        else
            StatusLabel.Text = "⚠️ No eggs found!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            wait(2)
        end
        
        wait(0.3)
    end
end

-- ─── AUTO FARM ──────────────────────────────────────────────────────────
local function autoFarm()
    if isFarming then
        isFarming = false
        StatusLabel.Text = "⏹ Farm Stopped"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    isFarming = true
    StatusLabel.Text = "🌾 Farming..."
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    while isFarming do
        local farmEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Farm")
        if farmEvent then
            farmEvent:FireServer("Farm")
        end
        collectedEggs = collectedEggs + 1
        StatusLabel.Text = "🌾 Farming... (" .. collectedEggs .. " total)"
        wait(0.8)
    end
end

-- ─── TELEPORT TO MAP ──────────────────────────────────────────────────
local teleportPoints = {
    {name = "🔄 Spawn", pos = Vector3.new(0, 5, 0)},
    {name = "🥚 Rare Zone", pos = Vector3.new(100, 5, 50)},
    {name = "🌾 Farm Area", pos = Vector3.new(-50, 5, -30)},
    {name = "💀 Boss Area", pos = Vector3.new(200, 5, -100)},
    {name = "⭐ Legendary Zone", pos = Vector3.new(-120, 5, 80)},
}

local teleportIndex = 1

local function teleportToMap()
    if isTeleporting then
        isTeleporting = false
        StatusLabel.Text = "⏹ Teleport Stopped"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    isTeleporting = true
    local point = teleportPoints[teleportIndex]
    teleportIndex = teleportIndex % #teleportPoints + 1
    
    StatusLabel.Text = "🌀 " .. point.name
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    
    RootPart.CFrame = CFrame.new(point.pos)
    wait(0.3)
    isTeleporting = false
    StatusLabel.Text = "📍 Arrived at " .. point.name
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end

-- ─── ANTI AFK ────────────────────────────────────────────────────────────
local function antiAFK()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    StatusLabel.Text = "🛡 Anti AFK Active!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end

-- ─── BUTTONS ──────────────────────────────────────────────────────────────
createButton("🏆 Auto Steal BEST Egg", 55, Color3.fromRGB(40, 80, 150), function()
    autoStealBestEgg()
end)

createButton("🌾 Auto Farm", 103, Color3.fromRGB(80, 120, 40), function()
    autoFarm()
end)

createButton("🌀 Teleport Map", 151, Color3.fromRGB(120, 40, 120), function()
    teleportToMap()
end)

createButton("🔍 Find Best Egg", 199, Color3.fromRGB(40, 80, 80), function()
    local best = findBestEgg()
    if best then
        local rarity = getEggRarity(best)
        StatusLabel.Text = "🏆 Best: " .. rarity.label .. " Egg!"
        StatusLabel.TextColor3 = rarity.color
    else
        StatusLabel.Text = "⚠️ No eggs found!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

createButton("🛡 Anti AFK", 247, Color3.fromRGB(80, 40, 80), function()
    antiAFK()
end)

createButton("👁 ESP", 295, Color3.fromRGB(40, 40, 120), function()
    StatusLabel.Text = "👁 ESP Toggle"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
end)

createButton("❌ Close", 343, Color3.fromRGB(120, 40, 40), function()
    ScreenGui:Destroy()
end)

-- ─── KEYBINDS ────────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        autoStealBestEgg()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        autoFarm()
    elseif input.KeyCode == Enum.KeyCode.F3 then
        teleportToMap()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        local best = findBestEgg()
        if best then
            local rarity = getEggRarity(best)
            StatusLabel.Text = "🏆 Best: " .. rarity.label .. " Egg!"
            StatusLabel.TextColor3 = rarity.color
        end
    end
end)

-- ─── START ──────────────────────────────────────────────────────────────
StatusLabel.Text = "⚡ Loaded! Press F1-F4"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
EggInfoLabel.Text = "🥚 Target: None"

print("🏆 STEAL & EGG PREMIUM LOADED")
print("📌 Keybinds:")
print("   F1 - Auto Steal BEST Egg (Legendary/Mythic Priority)")
print("   F2 - Auto Farm")
print("   F3 - Teleport Map")
print("   F4 - Find Best Egg")
