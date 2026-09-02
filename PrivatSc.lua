--[[
    ═══════════════════════════════════════
        SC ARYA PRIVAT V1.4
        STEALTH EDITION - FIXED
    ═══════════════════════════════════════
]]

-- ─── STEALTH INIT ──────────────────────────────────────────────────────
-- Randomized delay to avoid pattern detection
local function stealthWait()
    local t = 0
    while t < math.random(2, 5) do
        t = t + math.random(1, 10) / 100
        wait(math.random(1, 5) / 100)
    end
end
stealthWait()

-- ─── SERVICES ─────────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- ─── PLAYER ──────────────────────────────────────────────────────────────
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ─── RANDOM UTILITIES ──────────────────────────────────────────────────
local function rand(min, max) return math.random(min or 0, max or 100) end
local function randWait(min, max) wait((rand(min or 500, max or 2000) / 1000)) end

-- ─── EGG RARITY ──────────────────────────────────────────────────────────
local EggRarity = {
    Common = {value = 1, color = Color3.fromRGB(150, 150, 150), label = "Common"},
    Uncommon = {value = 2, color = Color3.fromRGB(0, 200, 0), label = "Uncommon"},
    Rare = {value = 3, color = Color3.fromRGB(0, 100, 255), label = "Rare"},
    Epic = {value = 4, color = Color3.fromRGB(150, 0, 255), label = "Epic"},
    Legendary = {value = 5, color = Color3.fromRGB(255, 150, 0), label = "Legendary"},
    Mythic = {value = 6, color = Color3.fromRGB(255, 0, 0), label = "Mythic"},
}

local function getRarity(egg)
    if not egg then return EggRarity.Common end
    local name = egg.Name:lower()
    local r = "Common"
    if name:find("mythic") or name:find("mitos") or name:find("red") then r = "Mythic"
    elseif name:find("legendary") or name:find("legenda") or name:find("gold") then r = "Legendary"
    elseif name:find("epic") or name:find("epik") or name:find("purple") then r = "Epic"
    elseif name:find("rare") or name:find("langka") or name:find("blue") then r = "Rare"
    elseif name:find("uncommon") or name:find("green") then r = "Uncommon"
    end
    local attr = egg:FindFirstChild("Rarity") or egg:FindFirstChild("EggRarity")
    if attr then
        local val = attr.Value:lower()
        if val:find("mythic") then r = "Mythic"
        elseif val:find("legendary") then r = "Legendary"
        elseif val:find("epic") then r = "Epic"
        elseif val:find("rare") then r = "Rare"
        elseif val:find("uncommon") then r = "Uncommon"
        end
    end
    return EggRarity[r] or EggRarity.Common
end

local function findEggs()
    local list = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local name = v.Name:lower()
            if name:find("egg") or name:find("telur") or name:find("rare") or 
               name:find("legenda") or name:find("gold") or name:find("mythic") or
               name:find("epic") or name:find("uncommon") then
                table.insert(list, v)
            end
        end
    end
    return list
end

local function getEggPos(egg)
    if not egg then return nil end
    if egg:IsA("BasePart") then return egg.Position end
    if egg:IsA("Model") then
        local p = egg.PrimaryPart
        if p then return p.Position end
        for _, v in pairs(egg:GetDescendants()) do
            if v:IsA("BasePart") then return v.Position end
        end
    end
    return nil
end

local function findBestEgg()
    local eggs = findEggs()
    local best = nil
    local bestVal = 0
    for _, egg in pairs(eggs) do
        local r = getRarity(egg)
        if r.value > bestVal then
            bestVal = r.value
            best = egg
        end
    end
    return best
end

local function showEggList()
    local eggs = findEggs()
    local cats = {Mythic = {}, Legendary = {}, Epic = {}, Rare = {}, Uncommon = {}, Common = {}}
    for _, egg in pairs(eggs) do
        local r = getRarity(egg)
        table.insert(cats[r.label], egg.Name)
    end
    print("")
    print("═══════════════════════════════════")
    print("  🥚 EGG LIST")
    print("═══════════════════════════════════")
    print("Total: " .. #eggs)
    if #eggs == 0 then print("  ❌ None found!") return end
    for r, list in pairs(cats) do
        if #list > 0 then
            print("  " .. r:upper() .. " (" .. #list .. ")")
            for _, n in pairs(list) do print("    - " .. n) end
            print("")
        end
    end
    local best = findBestEgg()
    if best then print("🏆 BEST: " .. best.Name .. " (" .. getRarity(best).label .. ")") end
    print("═══════════════════════════════════")
end

-- ─── HUMAN MOVEMENT ─────────────────────────────────────────────────────
local function walkTo(pos)
    if not pos then return end
    local target = pos + Vector3.new(rand(-5, 5), 0, rand(-5, 5))
    target = Vector3.new(target.X, 3, target.Z)
    local start = RootPart.Position
    local dur = rand(4, 12) / 10
    local t = tick()
    while tick() - t < dur do
        local a = (tick() - t) / dur
        local s = a * a * (3 - 2 * a)
        RootPart.CFrame = CFrame.new(start:Lerp(target, s))
        RunService.Heartbeat:Wait()
    end
    RootPart.CFrame = CFrame.new(target)
    randWait(300, 800)
end

local function stealEgg(egg)
    if not egg then return false end
    local pos = getEggPos(egg)
    if not pos then return false end
    walkTo(pos)
    randWait(400, 1000)
    local events = {ReplicatedStorage:FindFirstChild("StealEgg"), ReplicatedStorage:FindFirstChild("CollectEgg"), ReplicatedStorage:FindFirstChild("GrabEgg")}
    local ev = nil
    for _, e in pairs(events) do if e then ev = e; break end end
    if ev then pcall(function() ev:FireServer(egg) end); randWait(300, 600); return true end
    return false
end

-- ─── SPAWN ALL ANIMALS ──────────────────────────────────────────────────
local function spawnAnimals()
    local base = RootPart.Position
    local count = 0
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("BasePart") then
            local n = v.Name:lower()
            if n:find("animal") or n:find("pet") or n:find("creature") or n:find("monster") or
               n:find("beast") or n:find("wild") or n:find("chicken") or n:find("cow") or
               n:find("pig") or n:find("sheep") or n:find("horse") or n:find("dog") or
               n:find("cat") or n:find("bird") or n:find("fish") or n:find("rabbit") or
               n:find("fox") or n:find("wolf") or n:find("bear") or n:find("lion") or
               n:find("tiger") or n:find("elephant") or n:find("giraffe") or n:find("zebra") then
                local p = nil
                if v:IsA("Model") then p = v.PrimaryPart end
                if p then
                    pcall(function()
                        p.CFrame = CFrame.new(base + Vector3.new(rand(-15, 15), 0, rand(-15, 15)))
                        count = count + 1
                    end)
                elseif v:IsA("BasePart") then
                    pcall(function()
                        v.CFrame = CFrame.new(base + Vector3.new(rand(-15, 15), 0, rand(-15, 15)))
                        count = count + 1
                    end)
                end
            end
        end
    end
    print("[SC ARYA] Spawned " .. count .. " animals at base!")
    return count
end

-- ─── UNLIMITED MONEY ────────────────────────────────────────────────────
local function addMoney(amount)
    amount = amount or 999999999
    local ev = ReplicatedStorage:FindFirstChild("AddMoney") or
               ReplicatedStorage:FindFirstChild("GiveMoney") or
               ReplicatedStorage:FindFirstChild("EarnMoney") or
               ReplicatedStorage:FindFirstChild("SetMoney")
    if ev then
        pcall(function() ev:FireServer(amount) end)
        print("[SC ARYA] Added $" .. amount)
        return true
    end
    local currency = Player:FindFirstChild("Currency") or Player:FindFirstChild("Money") or 
                     Player:FindFirstChild("Cash") or Player:FindFirstChild("Coins")
    if currency then
        pcall(function() currency.Value = amount end)
        print("[SC ARYA] Set $" .. amount)
        return true
    end
    return false
end

-- ─── ENHANCED ANTI DETECTION ──────────────────────────────────────────
local function antiDetection()
    local mouse = Player:GetMouse()
    
    -- Random mouse movements with human-like patterns
    spawn(function()
        while wait(rand(1, 6)) do
            if rand(1, 100) > 50 then
                pcall(function()
                    local x, y = rand(100, 1800), rand(100, 900)
                    mouse.Move(x, y)
                    wait(rand(3, 15) / 100)
                    mouse.Move(x + rand(-40, 40), y + rand(-40, 40))
                    wait(rand(2, 10) / 100)
                    mouse.Move(x + rand(-20, 20), y + rand(-20, 20))
                end)
            end
        end
    end)
    
    -- Random jumps with varied timing
    spawn(function()
        while wait(rand(3, 18)) do
            if rand(1, 100) > 65 then
                pcall(function()
                    Humanoid.Jump = true
                    wait(rand(3, 12) / 100)
                    Humanoid.Jump = false
                    wait(rand(5, 20) / 100)
                    if rand(1, 100) > 50 then
                        Humanoid.Jump = true
                        wait(rand(3, 10) / 100)
                        Humanoid.Jump = false
                    end
                end)
            end
        end
    end)
    
    -- Random camera movements
    spawn(function()
        while wait(rand(2, 10)) do
            if rand(1, 100) > 60 then
                pcall(function()
                    local camera = workspace.CurrentCamera
                    local old = camera.CFrame
                    camera.CFrame = camera.CFrame * CFrame.Angles(
                        math.rad(rand(-15, 15)),
                        math.rad(rand(-30, 30)),
                        0
                    )
                    wait(rand(10, 40) / 100)
                    camera.CFrame = old
                end)
            end
        end
    end)
    
    -- Random walking
    spawn(function()
        while wait(rand(2, 10)) do
            if rand(1, 100) > 55 then
                pcall(function()
                    local dir = CFrame.Angles(0, math.rad(rand(0, 360)), 0)
                    local move = (RootPart.CFrame * dir).LookVector * rand(2, 12)
                    RootPart.CFrame = RootPart.CFrame + move
                    wait(rand(5, 25) / 100)
                    RootPart.CFrame = RootPart.CFrame - move * 0.4
                end)
            end
        end
    end)
end

local function antiAFK()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    Player.Idled:Connect(function() VirtualUser:ClickButton2(Vector2.new()) end)
end

-- ─── STATE ──────────────────────────────────────────────────────────────
local isStealing = false
local isFarming = false
local menuOpen = false
local statusLabel = nil
local eggInfoLabel = nil

local function updateStatus(txt, col)
    if statusLabel then statusLabel.Text = txt; statusLabel.TextColor3 = col or Color3.fromRGB(100, 255, 100) end
end

local function updateEggInfo(txt, col)
    if eggInfoLabel then eggInfoLabel.Text = txt; eggInfoLabel.TextColor3 = col or Color3.fromRGB(255, 200, 100) end
end

-- ─── AUTO STEAL ──────────────────────────────────────────────────────────
local function autoSteal()
    if isStealing then isStealing = false; updateStatus("⏹ Stopped", Color3.fromRGB(255, 100, 100)); return end
    isStealing = true
    updateStatus("🔴 Stealing...", Color3.fromRGB(255, 100, 100))
    spawn(function()
        while isStealing do
            randWait(2500, 6000)
            local best = findBestEgg()
            if best then
                local r = getRarity(best)
                updateEggInfo("🥚 " .. best.Name, r.color)
                stealEgg(best)
                randWait(1200, 3000)
            else
                randWait(5000, 10000)
            end
            if rand(1, 100) > 80 then randWait(10000, 25000) end
        end
    end)
end

-- ─── AUTO FARM ──────────────────────────────────────────────────────────
local function autoFarm()
    if isFarming then isFarming = false; updateStatus("⏹ Farm Stopped", Color3.fromRGB(255, 100, 100)); return end
    isFarming = true
    updateStatus("🌾 Farming...", Color3.fromRGB(100, 255, 100))
    spawn(function()
        while isFarming do
            randWait(3000, 8000)
            local ev = ReplicatedStorage:FindFirstChild("Farm") or ReplicatedStorage:FindFirstChild("Collect")
            if ev then pcall(function() ev:FireServer("Farm") end); randWait(600, 2000) end
            if rand(1, 100) > 75 then randWait(10000, 25000) end
        end
    end)
end

-- ─── CREATE STEALTH UI ──────────────────────────────────────────────────
local function createUI()
    -- Random name for the ScreenGui to avoid detection
    local guiName = ""
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for i = 1, math.random(8, 15) do
        guiName = guiName .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    
    local sg = Instance.new("ScreenGui")
    sg.Name = guiName
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 0
    sg.Parent = CoreGui

    -- ─── FLOATING BUTTON ──────────────────────────────────────────────
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0, 65, 0, 65)
    btnFrame.Position = UDim2.new(0.92, 0, 0.82, 0)
    btnFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    btnFrame.BackgroundTransparency = 0.2
    btnFrame.BorderSizePixel = 0
    btnFrame.ClipsDescendants = true
    btnFrame.Parent = sg

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btnFrame

    -- Glow (subtle)
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1.1, 0, 1.1, 0)
    glow.Position = UDim2.new(-0.05, 0, -0.05, 0)
    glow.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    glow.BackgroundTransparency = 0.85
    glow.BorderSizePixel = 0
    glow.Parent = btnFrame

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glow

    -- Logo
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0.7, 0, 0.7, 0)
    logo.Position = UDim2.new(0.15, 0, 0.15, 0)
    logo.BackgroundTransparency = 1
    logo.Image = "https://files.catbox.moe/y4ru07.jpg"
    logo.Parent = btnFrame

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0.25, 0)
    lbl.Position = UDim2.new(0, 0, 0.75, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "ARYA"
    lbl.TextColor3 = Color3.fromRGB(255, 215, 0)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = btnFrame

    -- Clicker
    local clicker = Instance.new("TextButton")
    clicker.Size = UDim2.new(1, 0, 1, 0)
    clicker.BackgroundTransparency = 1
    clicker.Text = ""
    clicker.Parent = btnFrame

    -- Hover
    clicker.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 72, 0, 72)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.3), {BackgroundTransparency = 0.6}):Play()
    end)
    clicker.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 65, 0, 65)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.3), {BackgroundTransparency = 0.85}):Play()
    end)

    -- ─── DRAG ──────────────────────────────────────────────────────────
    local dragging = false
    local dragStart, dragPos
    clicker.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            dragPos = btnFrame.Position
        end
    end)
    clicker.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            btnFrame.Position = UDim2.new(
                dragPos.X.Scale, dragPos.X.Offset + delta.X,
                dragPos.Y.Scale, dragPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ─── TOGGLE MENU ──────────────────────────────────────────────────
    local menuVisible = false
    local menuFrame = nil

    clicker.MouseButton1Click:Connect(function()
        if menuVisible then
            if menuFrame then menuFrame:Destroy(); menuFrame = nil end
            menuVisible = false
            return
        end

        menuVisible = true

        -- ─── MENU FRAME ──────────────────────────────────────────────
        menuFrame = Instance.new("Frame")
        menuFrame.Size = UDim2.new(0, 380, 0, 520)
        menuFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
        menuFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 28)
        menuFrame.BackgroundTransparency = 0.05
        menuFrame.BorderSizePixel = 0
        menuFrame.ClipsDescendants = true
        menuFrame.Parent = sg

        local mCorner = Instance.new("UICorner")
        mCorner.CornerRadius = UDim.new(0, 20)
        mCorner.Parent = menuFrame

        -- Border glow (subtle)
        local border = Instance.new("Frame")
        border.Size = UDim2.new(1.02, 0, 1.02, 0)
        border.Position = UDim2.new(-0.01, 0, -0.01, 0)
        border.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
        border.BackgroundTransparency = 0.9
        border.BorderSizePixel = 0
        border.Parent = menuFrame
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 22)
        bCorner.Parent = border

        -- Title Bar
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 55)
        titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
        titleBar.BackgroundTransparency = 0.15
        titleBar.BorderSizePixel = 0
        titleBar.Parent = menuFrame
        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(0, 16)
        tCorner.Parent = titleBar

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = "SC ARYA PRIVAT V1.4"
        title.TextColor3 = Color3.fromRGB(255, 215, 0)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = titleBar

        -- Close button
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 40, 0, 40)
        closeBtn.Position = UDim2.new(0.92, 0, 0.08, 0)
        closeBtn.BackgroundTransparency = 1
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        closeBtn.TextSize = 20
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Parent = titleBar
        closeBtn.MouseButton1Click:Connect(function()
            if menuFrame then menuFrame:Destroy(); menuFrame = nil end
            menuVisible = false
        end)

        -- ─── DRAG MENU ────────────────────────────────────────────────
        local mDrag = false
        local mDragStart, mDragPos
        titleBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                mDrag = true
                mDragStart = i.Position
                mDragPos = menuFrame.Position
            end
        end)
        titleBar.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then mDrag = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if mDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - mDragStart
                menuFrame.Position = UDim2.new(
                    mDragPos.X.Scale, mDragPos.X.Offset + delta.X,
                    mDragPos.Y.Scale, mDragPos.Y.Offset + delta.Y
                )
            end
        end)

        -- ─── BUTTONS ──────────────────────────────────────────────────
        local function makeBtn(text, y, color, cb)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.85, 0, 0, 40)
            b.Position = UDim2.new(0.075, 0, 0, y)
            b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 70)
            b.BackgroundTransparency = 0.2
            b.Text = text
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 14
            b.Parent = menuFrame
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = b
            b.MouseButton1Click:Connect(cb)
            b.MouseEnter:Connect(function()
                b.BackgroundTransparency = 0.05
                b.BackgroundColor3 = color and color:Lerp(Color3.fromRGB(255, 255, 255), 0.1) or Color3.fromRGB(60, 60, 90)
            end)
            b.MouseLeave:Connect(function()
                b.BackgroundTransparency = 0.2
                b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 70)
            end)
            return b
        end

        -- Status
        statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(0.85, 0, 0, 32)
        statusLabel.Position = UDim2.new(0.075, 0, 0, 440)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "⚡ Ready"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusLabel.TextScaled = true
        statusLabel.Font = Enum.Font.GothamMedium
        statusLabel.Parent = menuFrame

        eggInfoLabel = Instance.new("TextLabel")
        eggInfoLabel.Size = UDim2.new(0.85, 0, 0, 28)
        eggInfoLabel.Position = UDim2.new(0.075, 0, 0, 478)
        eggInfoLabel.BackgroundTransparency = 1
        eggInfoLabel.Text = "🥚 Target: None"
        eggInfoLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        eggInfoLabel.TextScaled = true
        eggInfoLabel.Font = Enum.Font.GothamMedium
        eggInfoLabel.Parent = menuFrame

        -- Buttons
        makeBtn("🏆 Auto Steal Best Egg", 60, Color3.fromRGB(30, 60, 140), autoSteal)
        makeBtn("🌾 Auto Farm", 108, Color3.fromRGB(60, 100, 30), autoFarm)
        makeBtn("📋 Show Egg List", 156, Color3.fromRGB(30, 70, 70), function()
            showEggList()
            updateStatus("📋 Egg List shown!", Color3.fromRGB(100, 200, 255))
            task.wait(2)
            updateStatus("⚡ Ready", Color3.fromRGB(100, 255, 100))
        end)
        makeBtn("🔍 Find Best Egg", 204, Color3.fromRGB(40, 50, 110), function()
            local best = findBestEgg()
            if best then
                local r = getRarity(best)
                updateStatus("🏆 Best: " .. r.label, r.color)
                updateEggInfo("🥚 " .. best.Name, r.color)
            else
                updateStatus("⚠️ No eggs!", Color3.fromRGB(255, 100, 100))
            end
        end)
        makeBtn("🦁 Spawn All Animals", 252, Color3.fromRGB(0, 120, 100), function()
            local c = spawnAnimals()
            updateStatus("🦁 Spawned " .. c .. " animals!", Color3.fromRGB(100, 255, 100))
            task.wait(2)
            updateStatus("⚡ Ready", Color3.fromRGB(100, 255, 100))
        end)
        makeBtn("💰 Add Money (Unlimited)", 300, Color3.fromRGB(0, 150, 50), function()
            addMoney(999999999)
            updateStatus("💰 Money Added!", Color3.fromRGB(255, 215, 0))
            task.wait(2)
            updateStatus("⚡ Ready", Color3.fromRGB(100, 255, 100))
        end)
        makeBtn("🛡 Anti AFK", 348, Color3.fromRGB(70, 30, 70), function()
            antiAFK()
            updateStatus("🛡 Anti AFK Active!", Color3.fromRGB(100, 255, 100))
            task.wait(2)
            updateStatus("⚡ Ready", Color3.fromRGB(100, 255, 100))
        end)
        makeBtn("❌ Close Menu", 396, Color3.fromRGB(120, 30, 30), function()
            if menuFrame then menuFrame:Destroy(); menuFrame = nil end
            menuVisible = false
        end)
    end)

    return sg
end

-- ─── KEYBINDS ──────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.F8 then
        showEggList()
        if statusLabel then
            updateStatus("📋 Egg List shown!", Color3.fromRGB(100, 200, 255))
            task.wait(2)
            updateStatus("⚡ Ready", Color3.fromRGB(100, 255, 100))
        end
    end
    if i.KeyCode == Enum.KeyCode.F9 then
        autoSteal()
        if statusLabel then
            updateStatus(isStealing and "🔴 Stealing..." or "⏹ Stopped", 
                isStealing and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100))
        end
    end
    if i.KeyCode == Enum.KeyCode.F10 then
        autoFarm()
        if statusLabel then
            updateStatus(isFarming and "🌾 Farming..." or "⏹ Farm Stopped",
                isFarming and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100))
        end
    end
    if i.KeyCode == Enum.KeyCode.F11 then
        local best = findBestEgg()
        if best then
            local r = getRarity(best)
            updateEggInfo("🥚 " .. best.Name, r.color)
            stealEgg(best)
            updateStatus("✅ Stolen: " .. best.Name, Color3.fromRGB(100, 255, 100))
            task.wait(2)
            updateStatus("⚡ Ready", Color3.fromRGB(100, 255, 100))
        else
            updateStatus("⚠️ No eggs!", Color3.fromRGB(255, 100, 100))
            task.wait(2)
            updateStatus("⚡ Ready", Color3.fromRGB(100, 255, 100))
        end
    end
end)

-- ─── STARTUP ─────────────────────────────────────────────────────────────
task.wait(math.random(2, 5))
antiDetection()
antiAFK()
task.wait(math.random(1, 3))
createUI()
task.wait(math.random(1, 2))
showEggList()

print("")
print("═══════════════════════════════════")
print("  SC ARYA PRIVAT V1.4")
print("  STEALTH EDITION")
print("═══════════════════════════════════")
print("✅ Stealth Mode Active")
print("✅ Floating Menu Button Ready")
print("✅ Auto Steal Best Egg (F9)")
print("✅ Auto Farm (F10)")
print("✅ Spawn All Animals")
print("✅ Unlimited Money")
print("✅ Enhanced Anti-Detection")
print("✅ Anti-AFK Active")
print("")
print("📌 Keybinds:")
print("   F8  - Show Egg List")
print("   F9  - Toggle Auto Steal")
print("   F10 - Toggle Auto Farm")
print("   F11 - Manual Steal")
print("═══════════════════════════════════")
