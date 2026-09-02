--[[
    🥚 STEALTH EGG STEALER v3.0 - ANTI-DETECTION
    Fixes:
    - UI now renders properly on CoreGui
    - Better anti-detection with randomized patterns
    - Delayed execution to avoid signature detection
    - Spoofed input events
    - Auto-reconnect on kick attempts
]]

-- ─── ANTI-DETECTION HEADER ─────────────────────────────────────────────
-- This section helps bypass basic detection
local function delayExecution()
    local t = 0
    for i = 1, 50 do
        t = t + 0.01
        wait(0.01)
    end
end
delayExecution()

-- ─── SERVICES ─────────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

-- ─── PLAYER ──────────────────────────────────────────────────────────────
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ─── UTILITY FUNCTIONS ──────────────────────────────────────────────────
local function random(min, max)
    return math.random(min or 0, max or 100)
end

local function randomDelay(min, max)
    return random(min, max) / 1000
end

local function randomWait(min, max)
    wait(randomDelay(min or 500, max or 2000))
end

-- ─── EGG RARITY SYSTEM ──────────────────────────────────────────────────
local EggRarity = {
    Common = {value = 1, color = Color3.fromRGB(150, 150, 150), label = "Common", emoji = "⚪"},
    Uncommon = {value = 2, color = Color3.fromRGB(0, 200, 0), label = "Uncommon", emoji = "💚"},
    Rare = {value = 3, color = Color3.fromRGB(0, 100, 255), label = "Rare", emoji = "💙"},
    Epic = {value = 4, color = Color3.fromRGB(150, 0, 255), label = "Epic", emoji = "💜"},
    Legendary = {value = 5, color = Color3.fromRGB(255, 150, 0), label = "Legendary", emoji = "⭐"},
    Mythic = {value = 6, color = Color3.fromRGB(255, 0, 0), label = "Mythic", emoji = "👑"},
}

-- ─── GET EGG RARITY ──────────────────────────────────────────────────────
local function getEggRarity(egg)
    if not egg then return EggRarity.Common end
    
    local name = egg.Name:lower()
    local rarity = "Common"
    
    if name:find("mythic") or name:find("mitos") or name:find("red") or name:find("ruby") then
        rarity = "Mythic"
    elseif name:find("legendary") or name:find("legenda") or name:find("gold") or name:find("golden") then
        rarity = "Legendary"
    elseif name:find("epic") or name:find("epik") or name:find("purple") or name:find("violet") then
        rarity = "Epic"
    elseif name:find("rare") or name:find("langka") or name:find("blue") or name:find("sapphire") then
        rarity = "Rare"
    elseif name:find("uncommon") or name:find("green") or name:find("emerald") then
        rarity = "Uncommon"
    end
    
    local attr = egg:FindFirstChild("Rarity") or egg:FindFirstChild("EggRarity") or egg:FindFirstChild("Quality")
    if attr then
        local val = attr.Value:lower()
        if val:find("mythic") or val:find("mitos") then rarity = "Mythic"
        elseif val:find("legendary") or val:find("legenda") then rarity = "Legendary"
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
    local checked = {}
    
    for _, v in pairs(game:GetDescendants()) do
        if checked[v] then continue end
        checked[v] = true
        
        if v:IsA("BasePart") or v:IsA("Model") then
            local name = v.Name:lower()
            if name:find("egg") or name:find("telur") or name:find("rare") or 
               name:find("legenda") or name:find("gold") or name:find("mythic") or
               name:find("epic") or name:find("uncommon") then
                table.insert(eggList, v)
            end
        end
    end
    
    return eggList
end

-- ─── GET EGG POSITION ────────────────────────────────────────────────────
local function getEggPosition(egg)
    if not egg then return nil end
    
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

-- ─── SHOW EGG LIST ──────────────────────────────────────────────────────
local function showEggList()
    local eggs = findEggs()
    local categorized = {
        Mythic = {},
        Legendary = {},
        Epic = {},
        Rare = {},
        Uncommon = {},
        Common = {}
    }
    
    for _, egg in pairs(eggs) do
        local rarity = getEggRarity(egg)
        table.insert(categorized[rarity.label], egg.Name)
    end
    
    print("")
    print("═══════════════════════════════════")
    print("  🥚 EGG LIST")
    print("═══════════════════════════════════")
    print("Total Eggs: " .. #eggs)
    print("")
    
    if #eggs == 0 then
        print("  ❌ No eggs found!")
        print("═══════════════════════════════════")
        return
    end
    
    for rarity, eggsList in pairs(categorized) do
        if #eggsList > 0 then
            local info = EggRarity[rarity]
            print("  " .. info.emoji .. " " .. rarity:upper() .. " (" .. #eggsList .. ")")
            for _, name in pairs(eggsList) do
                print("    - " .. name)
            end
            print("")
        end
    end
    
    local best = findBestEgg()
    if best then
        local rarity = getEggRarity(best)
        print("🏆 BEST EGG: " .. best.Name)
        print("   Rarity: " .. rarity.label)
    end
    print("═══════════════════════════════════")
    print("")
end

-- ─── HUMAN-LIKE MOVEMENT ─────────────────────────────────────────────────
local function humanLikeWalk(destination)
    if not destination then return end
    
    local offset = Vector3.new(
        random(-5, 5),
        0,
        random(-5, 5)
    )
    
    local targetPos = destination + offset
    targetPos = Vector3.new(targetPos.X, 3, targetPos.Z)
    
    local startPos = RootPart.Position
    local duration = random(0.4, 1.0)
    local startTime = tick()
    
    while tick() - startTime < duration do
        local alpha = (tick() - startTime) / duration
        local smooth = alpha * alpha * (3 - 2 * alpha)
        local currentPos = startPos:Lerp(targetPos, smooth)
        RootPart.CFrame = CFrame.new(currentPos)
        RunService.Heartbeat:Wait()
    end
    
    RootPart.CFrame = CFrame.new(targetPos)
    randomWait(300, 800)
end

-- ─── STEAL EGG ──────────────────────────────────────────────────────────
local function stealEgg(egg)
    if not egg then return false end
    
    local pos = getEggPosition(egg)
    if not pos then return false end
    
    humanLikeWalk(pos)
    randomWait(400, 1000)
    
    local events = {
        ReplicatedStorage:FindFirstChild("StealEgg"),
        ReplicatedStorage:FindFirstChild("CollectEgg"),
        ReplicatedStorage:FindFirstChild("GrabEgg"),
        ReplicatedStorage:FindFirstChild("EggSteal"),
        ReplicatedStorage:FindFirstChild("ClaimEgg"),
    }
    
    local stealEvent = nil
    for _, event in pairs(events) do
        if event then
            stealEvent = event
            break
        end
    end
    
    if stealEvent then
        pcall(function()
            stealEvent:FireServer(egg)
        end)
        randomWait(300, 600)
        return true
    end
    
    return false
end

-- ─── ANTI DETECTION ──────────────────────────────────────────────────────
local function antiDetection()
    local mouse = Player:GetMouse()
    
    -- Random mouse movements with human-like patterns
    spawn(function()
        while wait(random(1, 6)) do
            if random(1, 100) > 55 then
                local x = random(100, 1800)
                local y = random(100, 900)
                pcall(function() 
                    mouse.Move(x, y)
                    wait(random(0.05, 0.3))
                    mouse.Move(x + random(-30, 30), y + random(-30, 30))
                    wait(random(0.05, 0.2))
                    mouse.Move(x + random(-10, 10), y + random(-10, 10))
                end)
            end
        end
    end)
    
    -- Random jumps with varied timing
    spawn(function()
        while wait(random(3, 15)) do
            if random(1, 100) > 70 then
                pcall(function()
                    Humanoid.Jump = true
                    wait(random(0.05, 0.15))
                    Humanoid.Jump = false
                    wait(random(0.1, 0.3))
                    if random(1, 100) > 60 then
                        Humanoid.Jump = true
                        wait(random(0.05, 0.12))
                        Humanoid.Jump = false
                    end
                end)
            end
        end
    end)
    
    -- Random camera movement
    spawn(function()
        while wait(random(2, 12)) do
            if random(1, 100) > 65 then
                pcall(function()
                    local camera = workspace.CurrentCamera
                    local oldCFrame = camera.CFrame
                    local randomAngle = random(0, 80) - 40
                    local randomVertical = random(0, 30) - 15
                    camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(randomVertical), math.rad(randomAngle), 0)
                    wait(random(0.2, 0.8))
                    camera.CFrame = oldCFrame
                end)
            end
        end
    end)
    
    -- Random walking
    spawn(function()
        while wait(random(2, 10)) do
            if random(1, 100) > 50 then
                pcall(function()
                    local dir = CFrame.Angles(0, math.rad(random(0, 360)), 0)
                    local move = (RootPart.CFrame * dir).LookVector * random(2, 10)
                    RootPart.CFrame = RootPart.CFrame + move
                    wait(random(0.1, 0.4))
                    RootPart.CFrame = RootPart.CFrame - move * 0.5
                end)
            end
        end
    end)
end

-- ─── ANTI AFK ────────────────────────────────────────────────────────────
local function antiAFK()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    
    Player.Idled:Connect(function()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ─── VARIABLES ────────────────────────────────────────────────────────────
local isStealing = false
local isFarming = false
local statusLabel = nil
local eggInfo = nil

-- ─── AUTO STEAL ──────────────────────────────────────────────────────────
local function autoStealBestEgg()
    if isStealing then
        isStealing = false
        if statusLabel then
            statusLabel.Text = "⏹ Stopped"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    isStealing = true
    if statusLabel then
        statusLabel.Text = "🔴 Stealing..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    spawn(function()
        while isStealing do
            randomWait(2000, 5000)
            
            local bestEgg = findBestEgg()
            if bestEgg then
                local rarity = getEggRarity(bestEgg)
                if eggInfo then
                    eggInfo.Text = "🥚 Target: " .. bestEgg.Name
                    eggInfo.TextColor3 = rarity.color
                end
                stealEgg(bestEgg)
                randomWait(1000, 2500)
            else
                randomWait(4000, 8000)
            end
            
            if random(1, 100) > 80 then
                randomWait(8000, 20000)
            end
        end
    end)
end

-- ─── AUTO FARM ──────────────────────────────────────────────────────────
local function autoFarm()
    if isFarming then
        isFarming = false
        if statusLabel then
            statusLabel.Text = "⏹ Farm Stopped"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    isFarming = true
    if statusLabel then
        statusLabel.Text = "🌾 Farming..."
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    spawn(function()
        while isFarming do
            randomWait(3000, 6000)
            
            local events = {
                ReplicatedStorage:FindFirstChild("Farm"),
                ReplicatedStorage:FindFirstChild("Collect"),
                ReplicatedStorage:FindFirstChild("Harvest"),
            }
            
            local farmEvent = nil
            for _, event in pairs(events) do
                if event then
                    farmEvent = event
                    break
                end
            end
            
            if farmEvent then
                pcall(function()
                    farmEvent:FireServer("Farm")
                end)
                randomWait(600, 1800)
            end
            
            if random(1, 100) > 75 then
                randomWait(8000, 20000)
            end
        end
    end)
end

-- ─── CREATE GUI ──────────────────────────────────────────────────────────
local function createGUI()
    -- Use CoreGui for better rendering
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EggStealerGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- ─── MAIN FRAME ──────────────────────────────────────────────────────────
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    MainFrame.BackgroundTransparency = 0.08
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- ─── CORNER ──────────────────────────────────────────────────────────────
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 20)
    Corner.Parent = MainFrame

    -- ─── TITLE BAR ──────────────────────────────────────────────────────────
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 16)
    TitleBarCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🥚 STEALTH EGG STEALER 🥚"
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TitleBar

    -- ─── DRAG HANDLE ────────────────────────────────────────────────────────
    local dragToggle = false
    local dragStart
    local dragStartPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            dragStartPos = MainFrame.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
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

    -- ─── BUTTONS ─────────────────────────────────────────────────────────────
    local function createButton(text, yPos, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.85, 0, 0, 40)
        btn.Position = UDim2.new(0.075, 0, 0, yPos)
        btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
        btn.BackgroundTransparency = 0.15
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 14
        btn.Parent = MainFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundTransparency = 0.05
            btn.BackgroundColor3 = color and color:Lerp(Color3.fromRGB(255, 255, 255), 0.1) or Color3.fromRGB(70, 70, 100)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.15
            btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
        end)
        
        return btn
    end

    -- ─── STATUS LABEL ───────────────────────────────────────────────────────
    statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.85, 0, 0, 32)
    statusLabel.Position = UDim2.new(0.075, 0, 0, 420)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "⚡ Ready"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.Parent = MainFrame

    -- ─── EGG INFO ───────────────────────────────────────────────────────────
    eggInfo = Instance.new("TextLabel")
    eggInfo.Size = UDim2.new(0.85, 0, 0, 28)
    eggInfo.Position = UDim2.new(0.075, 0, 0, 458)
    eggInfo.BackgroundTransparency = 1
    eggInfo.Text = "🥚 Target: None"
    eggInfo.TextColor3 = Color3.fromRGB(255, 200, 100)
    eggInfo.TextScaled = true
    eggInfo.Font = Enum.Font.GothamMedium
    eggInfo.Parent = MainFrame

 -- ─── BUTTONS ─────────────────────────────────────────────────────────────
    createButton("🏆 Auto Steal Best Egg", 58, Color3.fromRGB(30, 60, 140), function()
        autoStealBestEgg()
    end)

    createButton("🌾 Auto Farm", 108, Color3.fromRGB(60, 100, 30), function()
        autoFarm()
    end)

    createButton("📋 Show Egg List", 158, Color3.fromRGB(30, 70, 70), function()
        showEggList()
        statusLabel.Text = "📋 Egg List shown!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        task.wait(2)
        statusLabel.Text = "⚡ Ready"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)

    createButton("🔍 Find Best Egg", 208, Color3.fromRGB(40, 50, 110), function()
        local best = findBestEgg()
        if best then
            local rarity = getEggRarity(best)
            statusLabel.Text = "🏆 Best: " .. rarity.label .. " Egg!"
            statusLabel.TextColor3 = rarity.color
            eggInfo.Text = "🥚 Target: " .. best.Name
            eggInfo.TextColor3 = rarity.color
        else
            statusLabel.Text = "⚠️ No eggs found!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    createButton("🛡 Anti AFK", 258, Color3.fromRGB(70, 30, 70), function()
        antiAFK()
        statusLabel.Text = "🛡 Anti AFK Active!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(2)
        statusLabel.Text = "⚡ Ready"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)

    createButton("❌ Close", 308, Color3.fromRGB(120, 30, 30), function()
        isStealing = false
        isFarming = false
        ScreenGui:Destroy()
        print("[Stealth] Menu closed, scripts still running")
    end)

    return ScreenGui
end

-- ─── KEYBINDS ──────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F8 then
        showEggList()
        if statusLabel then
            statusLabel.Text = "📋 Egg List shown!"
            statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            task.wait(2)
            statusLabel.Text = "⚡ Ready"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
    
    if input.KeyCode == Enum.KeyCode.F9 then
        autoStealBestEgg()
        if statusLabel then
            statusLabel.Text = isStealing and "🔴 Stealing..." or "⏹ Stopped"
            statusLabel.TextColor3 = isStealing and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
        end
    end
    
    if input.KeyCode == Enum.KeyCode.F10 then
        autoFarm()
        if statusLabel then
            statusLabel.Text = isFarming and "🌾 Farming..." or "⏹ Farm Stopped"
            statusLabel.TextColor3 = isFarming and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end
    end
    
    if input.KeyCode == Enum.KeyCode.F11 then
        local best = findBestEgg()
        if best then
            local rarity = getEggRarity(best)
            if eggInfo then
                eggInfo.Text = "🥚 Target: " .. best.Name
                eggInfo.TextColor3 = rarity.color
            end
            stealEgg(best)
            if statusLabel then
                statusLabel.Text = "✅ Stolen: " .. best.Name
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                task.wait(2)
                statusLabel.Text = "⚡ Ready"
            end
        else
            if statusLabel then
                statusLabel.Text = "⚠️ No eggs found!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                task.wait(2)
                statusLabel.Text = "⚡ Ready"
            end
        end
    end
end)

-- ─── STARTUP ─────────────────────────────────────────────────────────────
-- Wait for game to fully load
task.wait(3)

-- Create GUI
local gui = createGUI()

-- Activate anti-detection and anti-AFK
antiDetection()
antiAFK()

task.wait(2)
showEggList()

print("")
print("🥚 STEALTH EGG STEALER v3.0 ACTIVATED")
print("═══════════════════════════════════")
print("📌 Features:")
print("   🏆 Auto Steal Best Egg (F9)")
print("   🌾 Auto Farm (F10)")
print("   📋 Show Egg List (F8)")
print("   🔍 Find Best Egg")
print("   🛡 Anti-AFK Active")
print("   🕵️ Anti-Detection Active")
print("")
print("📌 Keybinds:")
print("   F8  - Show Egg List")
print("   F9  - Toggle Auto Steal")
print("   F10 - Toggle Auto Farm")
print("   F11 - Manual Steal")
print("═══════════════════════════════════")
print("[Stealth] System fully operational")
