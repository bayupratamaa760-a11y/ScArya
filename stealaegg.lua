--[[
    STEAL & EGG SCRIPT - STEALTH MODE + EGG LIST
    Fitur:
    - Auto Steal Egg Terbaik (Rare/Legendary) - HUMAN-LIKE
    - Auto Farm - RANDOMIZED
    - Anti Detection + Anti Ban
    - Auto Activate
    - SHOW ALL EGG NAMES
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

-- ─── ANTI DETECTION ──────────────────────────────────────────────────────
local Anti = {
    Enabled = true,
    HumanLike = true,
    RandomDelay = true,
    StealthMode = true
}

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

-- ─── PLAYER ──────────────────────────────────────────────────────────────
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ─── EGG LIST ────────────────────────────────────────────────────────────
local EggList = {}
local EggCount = 0
local function updateEggList()
    EggList = {}
    EggCount = 0
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local name = v.Name:lower()
            if name:find("egg") or name:find("telur") or name:find("rare") or name:find("legenda") or name:find("gold") or name:find("mythic") then
                table.insert(EggList, {
                    Object = v,
                    Name = v.Name,
                    Rarity = getEggRarity(v)
                })
                EggCount = EggCount + 1
            end
        end
    end
end

-- ─── HIDE UI ─────────────────────────────────────────────────────────────
local function hideUI()
    local playerGui = Player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, v in pairs(playerGui:GetChildren()) do
            if v:IsA("ScreenGui") then
                v.Enabled = false
            end
        end
    end
    
    for _, v in pairs(CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") then
            v.Enabled = false
        end
    end
end

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

-- ─── STEALTH UI (HIDDEN - HANYA UNTUK EGG LIST) ────────────────────────
local function createStealthUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StealthUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Enabled = false
    ScreenGui.Parent = Player.PlayerGui
    
    return ScreenGui
end

local stealthUI = createStealthUI()

-- ─── SHOW EGG LIST (HIDDEN MODE) ───────────────────────────────────────
local function showEggList()
    updateEggList()
    
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
    
    -- Sort by rarity (highest first)
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
            local color = EggRarity[rarity].color
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
    
    -- Cari best egg
    local best = findBestEgg()
    if best then
        local rarity = getEggRarity(best)
        print("🏆 BEST EGG: " .. best.Name)
        print("   Rarity: " .. rarity.label)
        print("═══════════════════════════════════")
    end
end

-- ─── FIND EGGS ────────────────────────────────────────────────────────────
local function findEggs()
    local eggList = {}
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local name = v.Name:lower()
            if name:find("egg") or name:find("telur") or name:find("rare") or name:find("legenda") or name:find("gold") then
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

-- ─── HUMAN-LIKE MOVEMENT ─────────────────────────────────────────────────
local function humanLikeWalk(destination)
    if not destination then return end
    
    local currentPos = RootPart.Position
    local distance = (destination - currentPos).Magnitude
    
    local targetPos = destination + Vector3.new(
        random(-3, 3),
        0,
        random(-3, 3)
    )
    
    RootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
    randomWait(200, 600)
    
    for i = 1, math.random(3, 8) do
        wait(randomDelay(50, 150))
    end
end

-- ─── STEAL EGG ──────────────────────────────────────────────────────────
local function stealEgg(egg)
    if not egg then return false end
    
    local pos = getEggPosition(egg)
    if not pos then return false end
    
    humanLikeWalk(pos)
    randomWait(300, 800)
    
    local stealEvent = ReplicatedStorage:FindFirstChild("StealEgg")
    if not stealEvent then
        stealEvent = game:GetService("ReplicatedStorage"):FindFirstChild("CollectEgg")
    end
    if not stealEvent then
        stealEvent = ReplicatedStorage:FindFirstChild("GrabEgg")
    end
    
    if stealEvent then
        stealEvent:FireServer(egg)
        randomWait(200, 500)
        return true
    end
    
    return false
end

-- ─── AUTO STEAL BEST EGG ─────────────────────────────────────────────────
local isStealing = false

local function autoStealBestEgg()
    if isStealing then
        isStealing = false
        return
    end
    
    isStealing = true
    
    while isStealing do
        randomWait(1500, 4000)
        
        local bestEgg = findBestEgg()
        if bestEgg then
            local rarity = getEggRarity(bestEgg)
            local success = stealEgg(bestEgg)
            
            if success then
                randomWait(800, 2000)
            else
                randomWait(2000, 5000)
            end
        else
            randomWait(3000, 7000)
        end
        
        if random(1, 100) > 85 then
            randomWait(5000, 15000)
        end
    end
end

-- ─── AUTO FARM ──────────────────────────────────────────────────────────
local isFarming = false

local function autoFarm()
    if isFarming then
        isFarming = false
        return
    end
    
    isFarming = true
    
    while isFarming do
        randomWait(2000, 5000)
        
        local farmEvent = ReplicatedStorage:FindFirstChild("Farm")
        if not farmEvent then
            farmEvent = ReplicatedStorage:FindFirstChild("Collect")
        end
        
        if farmEvent then
            farmEvent:FireServer("Farm")
            randomWait(500, 1500)
        end
        
        if random(1, 100) > 80 then
            randomWait(5000, 15000)
        end
    end
end

-- ─── ANTI DETECTION ──────────────────────────────────────────────────────
local function antiDetection()
    spawn(function()
        while Anti.Enabled do
            if random(1, 100) > 70 then
                local x = random(0, 1920)
                local y = random(0, 1080)
                mouse.Move(x, y)
                randomWait(100, 500)
            end
            randomWait(1000, 3000)
        end
    end)
    
    spawn(function()
        while Anti.Enabled do
            if random(1, 100) > 85 then
                local cam = workspace.CurrentCamera
                local targetCFrame = CFrame.new(
                    cam.CFrame.Position + Vector3.new(random(-10, 10), random(-5, 5), random(-10, 10)),
                    cam.CFrame.LookVector + Vector3.new(random(-0.2, 0.2), random(-0.2, 0.2), random(-0.2, 0.2))
                )
                TweenService:Create(cam, TweenInfo.new(random(1, 3)), {
                    CFrame = targetCFrame
                }):Play()
                randomWait(1000, 3000)
            end
            randomWait(5000, 10000)
        end
    end)
    
    spawn(function()
        while Anti.Enabled do
            if random(1, 100) > 90 then
                Humanoid.Jump = true
                randomWait(100, 300)
                Humanoid.Jump = false
            end
            randomWait(3000, 8000)
        end
    end)
end

-- ─── AUTO ACTIVATE ──────────────────────────────────────────────────────
local function autoActivate()
    repeat wait(1) until Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    
    randomWait(3000, 8000)
    
    print("[Stealth] Activating all features...")
    
    antiDetection()
    
    spawn(function()
        randomWait(2000, 5000)
        autoStealBestEgg()
    end)
    
    spawn(function()
        randomWait(4000, 8000)
        autoFarm()
    end)
    
    -- Show egg list after activation
    wait(2)
    showEggList()
    
    print("[Stealth] All features activated")
end

-- ─── MOUSE ──────────────────────────────────────────────────────────────
local mouse = Player:GetMouse()
local function humanLikeMouse()
    spawn(function()
        while Anti.Enabled do
            if random(1, 100) > 80 then
                local dx = random(-30, 30)
                local dy = random(-30, 30)
                mouse.Move(mouse.X + dx, mouse.Y + dy)
                randomWait(50, 200)
            end
            randomWait(500, 2000)
        end
    end)
end

-- ─── ANTI BAN ────────────────────────────────────────────────────────────
local function antiBan()
    local function clearLogs()
        pcall(function()
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Script") and v.Name:lower():find("log") then
                    v.Disabled = true
                end
            end
        end)
    end
    
    spawn(function()
        while Anti.Enabled do
            randomWait(30000, 60000)
            clearLogs()
        end
    end)
end

-- ─── START ──────────────────────────────────────────────────────────────
hideUI()
humanLikeMouse()
antiBan()

-- Show egg list every 5 minutes (randomized)
spawn(function()
    while Anti.Enabled do
        randomWait(300000, 600000) -- 5-10 menit
        showEggList()
    end
end)

autoActivate()

print("🥚 STEALTH EGG STEALER ACTIVATED")
print("📌 All features running in stealth mode")
print("   - Auto Steal Best Egg (Human-like)")
print("   - Auto Farm (Randomized)")
print("   - Anti Detection Active")
print("   - Anti Ban Protection")
print("")
print("📌 EGG LIST will be displayed automatically")
print("   Press F8 to manually show egg list")
print("   Press F9 to toggle Auto Steal")
print("   Press F10 to toggle Auto Farm")
print("   Press F11 for manual steal")

-- ─── KEYBINDS ──────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Show Egg List - F8
    if input.KeyCode == Enum.KeyCode.F8 then
        showEggList()
    end
    
    -- Toggle Auto Steal - F9
    if input.KeyCode == Enum.KeyCode.F9 then
        isStealing = not isStealing
        if isStealing then
            print("[Stealth] Auto Steal: ON")
        else
            print("[Stealth] Auto Steal: OFF")
        end
    end
    
    -- Toggle Auto Farm - F10
    if input.KeyCode == Enum.KeyCode.F10 then
        isFarming = not isFarming
        if isFarming then
            print("[Stealth] Auto Farm: ON")
        else
            print("[Stealth] Auto Farm: OFF")
        end
    end
    
    -- Manual Steal - F11
    if input.KeyCode == Enum.KeyCode.F11 then
        local best = findBestEgg()
        if best then
            stealEgg(best)
            print("[Stealth] Manual steal executed: " .. best.Name)
        end
    end
end)

-- ─── ERROR HANDLING ──────────────────────────────────────────────────────
local oldError = error
error = function(msg, level)
    return
end

print("[Stealth] System fully operational")
print("📌 Press F8 to show all egg names")
