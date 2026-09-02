--[[
    STEAL & EGG SCRIPT - STEALTH MODE + EGG LIST
    Fix: Menu Muncul, Tidak Blur, Auto Activate
]]

-- ─── SERVICES ─────────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- ─── PLAYER ──────────────────────────────────────────────────────────────
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ─── RANDOM FUNCTIONS ────────────────────────────────────────────────────
local function random(min, max)
    return math.random(min or 0, max or 100)
end

local function randomDelay(min, max)
    return random(min, max) / 1000
end

local function randomWait(min, max)
    wait(randomDelay(min or 500, max or 2000))
end

-- ─── EGG LIST ────────────────────────────────────────────────────────────
local EggList = {}
local EggCount = 0

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
    
    local name = egg.Name:lower()
    if name:find("legendary") or name:find("legenda") or name:find("gold") then
        rarity = "Legendary"
    elseif name:find("mythic") or name:find("mitos") or name:find("red") then
        rarity = "Mythic"
    elseif name:find("epic") or name:find("epik") or name:find("purple") then
        rarity = "Epic"
    elseif name:find("rare") or name:find("langka") or name:find("blue") then
        rarity = "Rare"
    elseif name:find("uncommon") or name:find("green") then
        rarity = "Uncommon"
    end
    
    local attr = egg:FindFirstChild("Rarity") or egg:FindFirstChild("EggRarity")
    if attr then
        local val = attr.Value:lower()
        if val:find("legendary") or val:find("legenda") then rarity = "Legendary"
        elseif val:find("mythic") or val:find("mitos") then rarity = "Mythic"
        elseif val:find("epic") or val:find("epik") then rarity = "Epic"
        elseif val:find("rare") or val:find("langka") then rarity = "Rare"
        elseif val:find("uncommon") then rarity = "Uncommon"
        end
    end
    
    return EggRarity[rarity] or EggRarity.Common
end

-- ─── FIND EGGS ────────────────────────────────────────────────────────────
local function findEggs()
    local eggList = {}
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local name = v.Name:lower()
            if name:find("egg") or name:find("telur") or name:find("rare") or name:find("legenda") or name:find("gold") or name:find("mythic") then
                table.insert(eggList, v)
            end
        end
    end
    
    return eggList
end

-- ─── UPDATE EGG LIST ─────────────────────────────────────────────────────
local function updateEggList()
    EggList = {}
    EggCount = 0
    
    for _, v in pairs(findEggs()) do
        table.insert(EggList, {
            Object = v,
            Name = v.Name,
            Rarity = getEggRarity(v)
        })
        EggCount = EggCount + 1
    end
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
    
    return bestEgg
end

-- ─── GET EGG POSITION ────────────────────────────────────────────────────
local function getEggPosition(egg)
    if egg:IsA("BasePart") then
        return egg.Position
    elseif egg:IsA("Model") then
        local primary = egg.PrimaryPart
        if primary then return primary.Position end
        for _, v in pairs(egg:GetDescendants()) do
            if v:IsA("BasePart") then
                return v.Position
            end
        end
    end
    return nil
end

-- ─── SHOW EGG LIST (MENU) ──────────────────────────────────────────────
local function showEggList()
    updateEggList()
    
    -- Clear previous prints with separator
    print("")
    print("═══════════════════════════════════")
    print("  🥚 EGG LIST FOUND")
    print("═══════════════════════════════════")
    print("Total Eggs: " .. EggCount)
    print("")
    
    if EggCount == 0 then
        print("  ❌ No eggs found!")
        print("═══════════════════════════════════")
        return
    end
    
    -- Sort by rarity
    table.sort(EggList, function(a, b)
        return a.Rarity.value > b.Rarity.value
    end)
    
    local categories = {
        Mythic = {},
        Legendary = {},
        Epic = {},
        Rare = {},
        Uncommon = {},
        Common = {}
    }
    
    for _, egg in pairs(EggList) do
        categories[egg.Rarity.label] = categories[egg.Rarity.label] or {}
        table.insert(categories[egg.Rarity.label], egg.Name)
    end
    
    for rarity, eggs in pairs(categories) do
        if #eggs > 0 then
            local emoji = rarity == "Mythic" and "👑" or
                          rarity == "Legendary" and "⭐" or
                          rarity == "Epic" and "💜" or
                          rarity == "Rare" and "💙" or
                          rarity == "Uncommon" and "💚" or "⚪"
            print("  " .. emoji .. " " .. rarity:upper() .. " (" .. #eggs .. ")")
            for _, name in pairs(eggs) do
                print("    - " .. name)
            end
            print("")
        end
    end
    
    print("═══════════════════════════════════")
    
    local best = findBestEgg()
    if best then
        local rarity = getEggRarity(best)
        print("🏆 BEST EGG: " .. best.Name)
        print("   Rarity: " .. rarity.label)
        print("═══════════════════════════════════")
    end
    print("")
end

-- ─── UI MENU (VISIBLE) ──────────────────────────────────────────────────
local function createMenu()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EggMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Player.PlayerGui

    -- ─── MAIN FRAME ──────────────────────────────────────────────────
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    MainFrame.BackgroundTransparency = 0.08
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- ─── CORNER ──────────────────────────────────────────────────────
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 16)
    Corner.Parent = MainFrame

    -- ─── SHADOW ──────────────────────────────────────────────────────
    local Shadow = Instance.new("Shadow")
    Shadow.Size = 8
    Shadow.Parent = MainFrame

    -- ─── TITLE ──────────────────────────────────────────────────────
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🥚 STEAL & EGG 🥚"
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    -- ─── BUTTONS ─────────────────────────────────────────────────────
    local function createButton(text, yPos, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 38)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
        btn.BackgroundTransparency = 0.2
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
            btn.BackgroundTransparency = 0.05
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.2
        end)
        
        return btn
    end

    -- ─── STATUS LABEL ────────────────────────────────────────────────
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 35)
    StatusLabel.Position = UDim2.new(0.05, 0, 0, 400)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⚡ Ready"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Parent = MainFrame

    -- ─── EGG INFO ────────────────────────────────────────────────────
    local EggInfo = Instance.new("TextLabel")
    EggInfo.Size = UDim2.new(0.9, 0, 0, 25)
    EggInfo.Position = UDim2.new(0.05, 0, 0, 375)
    EggInfo.BackgroundTransparency = 1
    EggInfo.Text = "🥚 Target: None"
    EggInfo.TextColor3 = Color3.fromRGB(255, 200, 100)
    EggInfo.TextScaled = true
    EggInfo.Font = Enum.Font.GothamMedium
    EggInfo.Parent = MainFrame

    -- ─── BUTTONS ─────────────────────────────────────────────────────
    createButton("🏆 Auto Steal BEST Egg", 55, Color3.fromRGB(40, 80, 150), function()
        autoStealBestEgg()
        StatusLabel.Text = isStealing and "🔴 Stealing..." or "⏹ Stopped"
        StatusLabel.TextColor3 = isStealing and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
    end)

    createButton("🌾 Auto Farm", 103, Color3.fromRGB(80, 120, 40), function()
        autoFarm()
        StatusLabel.Text = isFarming and "🌾 Farming..." or "⏹ Farm Stopped"
        StatusLabel.TextColor3 = isFarming and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    end)

    createButton("📋 Show Egg List", 151, Color3.fromRGB(40, 80, 80), function()
        showEggList()
        StatusLabel.Text = "📋 Egg List shown in console!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        wait(2)
        StatusLabel.Text = "⚡ Ready"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)

    createButton("🔍 Find Best Egg", 199, Color3.fromRGB(40, 60, 120), function()
        local best = findBestEgg()
        if best then
            local rarity = getEggRarity(best)
            StatusLabel.Text = "🏆 Best: " .. rarity.label .. " Egg!"
            StatusLabel.TextColor3 = rarity.color
            EggInfo.Text = "🥚 Target: " .. best.Name
            EggInfo.TextColor3 = rarity.color
        else
            StatusLabel.Text = "⚠️ No eggs found!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    createButton("🛡 Anti AFK", 247, Color3.fromRGB(80, 40, 80), function()
        antiAFK()
        StatusLabel.Text = "🛡 Anti AFK Active!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        wait(2)
        StatusLabel.Text = "⚡ Ready"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)

    createButton("❌ Close", 295, Color3.fromRGB(120, 40, 40), function()
        isStealing = false
        isFarming = false
        ScreenGui:Destroy()
        print("[Stealth] Menu closed, scripts still running")
    end)

    -- ─── DRAG ────────────────────────────────────────────────────────
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

    return StatusLabel, EggInfo
end

-- ─── VARIABLES ────────────────────────────────────────────────────────────
local isStealing = false
local isFarming = false
local StatusLabel = nil
local EggInfo = nil

-- ─── HUMAN-LIKE MOVEMENT ─────────────────────────────────────────────────
local function humanLikeWalk(destination)
    if not destination then return end
    
    local targetPos = destination + Vector3.new(
        random(-3, 3),
        0,
        random(-3, 3)
    )
    
    RootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
    randomWait(200, 600)
end

-- ─── STEAL EGG ──────────────────────────────────────────────────────────
local function stealEgg(egg)
    if not egg then return false end
    
    local pos = getEggPosition(egg)
    if not pos then return false end
    
    humanLikeWalk(pos)
    randomWait(300, 800)
    
    local stealEvent = ReplicatedStorage:FindFirstChild("StealEgg") or 
                       ReplicatedStorage:FindFirstChild("CollectEgg") or 
                       ReplicatedStorage:FindFirstChild("GrabEgg")
    
    if stealEvent then
        stealEvent:FireServer(egg)
        randomWait(200, 500)
        return true
    end
    
    return false
end

-- ─── AUTO STEAL ──────────────────────────────────────────────────────────
local function autoStealBestEgg()
    if isStealing then
        isStealing = false
        if StatusLabel then
            StatusLabel.Text = "⏹ Stopped"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    isStealing = true
    if StatusLabel then
        StatusLabel.Text = "🔴 Stealing..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    while isStealing do
        randomWait(1500, 4000)
        
        local bestEgg = findBestEgg()
        if bestEgg then
            local rarity = getEggRarity(bestEgg)
            if EggInfo then
                EggInfo.Text = "🥚 Target: " .. bestEgg.Name
                EggInfo.TextColor3 = rarity.color
            end
            stealEgg(bestEgg)
            randomWait(800, 2000)
        else
            randomWait(3000, 7000)
        end
        
        if random(1, 100) > 85 then
            randomWait(5000, 15000)
        end
    end
end

-- ─── AUTO FARM ──────────────────────────────────────────────────────────
local function autoFarm()
    if isFarming then
        isFarming = false
        if StatusLabel then
            StatusLabel.Text = "⏹ Farm Stopped"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    isFarming = true
    if StatusLabel then
        StatusLabel.Text = "🌾 Farming..."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    while isFarming do
        randomWait(2000, 5000)
        
        local farmEvent = ReplicatedStorage:FindFirstChild("Farm") or 
                          ReplicatedStorage:FindFirstChild("Collect")
        
        if farmEvent then
            farmEvent:FireServer("Farm")
            randomWait(500, 1500)
        end
        
        if random(1, 100) > 80 then
            randomWait(5000, 15000)
        end
    end
end

-- ─── ANTI AFK ────────────────────────────────────────────────────────────
local function antiAFK()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    
    Player.Idled:Connect(function()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ─── ANTI DETECTION ──────────────────────────────────────────────────────
local function antiDetection()
    local mouse = Player:GetMouse()
    
    spawn(function()
        while wait(random(1, 5)) do
            if random(1, 100) > 70 then
                local x = random(0, 1920)
                local y = random(0, 1080)
                pcall(function() mouse.Move(x, y) end)
            end
        end
    end)
    
    spawn(function()
        while wait(random(3, 8)) do
            if random(1, 100) > 85 then
                pcall(function()
                    Humanoid.Jump = true
                    wait(random(0.1, 0.3))
                    Humanoid.Jump = false
                end)
            end
        end
    end)
end

-- ─── START ──────────────────────────────────────────────────────────────
-- Create menu
local statusLabel, eggInfo = createMenu()
StatusLabel = statusLabel
EggInfo = eggInfo

-- Activate features
antiDetection()
antiAFK()

-- Show egg list on start
wait(2)
showEggList()

print("")
print("🥚 STEALTH EGG STEALER ACTIVATED")
print("📌 Features:")
print("   - Auto Steal Best Egg (F9)")
print("   - Auto Farm (F10)")
print("   - Show Egg List (F8)")
print("   - Find Best Egg")
print("   - Anti Detection Active")
print("   - Anti AFK Active")

-- ─── KEYBINDS ──────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F8: Show Egg List
    if input.KeyCode == Enum.KeyCode.F8 then
        showEggList()
        if StatusLabel then
            StatusLabel.Text = "📋 Egg List shown!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            wait(2)
            StatusLabel.Text = "⚡ Ready"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
    
    -- F9: Toggle Auto Steal
    if input.KeyCode == Enum.KeyCode.F9 then
        autoStealBestEgg()
        if StatusLabel then
            StatusLabel.Text = isStealing and "🔴 Stealing..." or "⏹ Stopped"
            StatusLabel.TextColor3 = isStealing and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
        end
    end
    
    -- F10: Toggle Auto Farm
    if input.KeyCode == Enum.KeyCode.F10 then
        autoFarm()
        if StatusLabel then
            StatusLabel.Text = isFarming and "🌾 Farming..." or "⏹ Farm Stopped"
            StatusLabel.TextColor3 = isFarming and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end
    end
    
    -- F11: Manual Steal
    if input.KeyCode == Enum.KeyCode.F11 then
        local best = findBestEgg()
        if best then
            local rarity = getEggRarity(best)
            if EggInfo then
                EggInfo.Text = "🥚 Target: " .. best.Name
                EggInfo.TextColor3 = rarity.color
            end
            stealEgg(best)
            if StatusLabel then
                StatusLabel.Text = "✅ Stolen: " .. best.Name
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                wait(2)
                StatusLabel.Text = "⚡ Ready"
            end
        else
            if StatusLabel then
                StatusLabel.Text = "⚠️ No eggs found!"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                wait(2)
                StatusLabel.Text = "⚡ Ready"
            end
        end
    end
end)

print("📌 Keybinds:")
print("   F8 - Show Egg List")
print("   F9 - Toggle Auto Steal")
print("   F10 - Toggle Auto Farm")
print("   F11 - Manual Steal Best Egg")
print("")
print("[Stealth] System fully operational")
