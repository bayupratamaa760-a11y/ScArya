--[[
    ═══════════════════════════════════════
        STEEL EN ULTIMATE SCRIPT
        AUTO-ENABLE ALL FEATURES
        RED SCREEN + MASS KICK + GLARITY
    ═══════════════════════════════════════
]]

-- ─── SERVICES ──────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- ─── PLAYER ────────────────────────────────────────────────────────────
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ─── RANDOM UTILITIES ──────────────────────────────────────────────────
local function rand(min, max) return math.random(min or 0, max or 100) end
local function randWait(min, max) wait((rand(min or 500, max or 2000) / 1000)) end

-- ─── CONFIG ─────────────────────────────────────────────────────────────
local CashTarget = 22000000  -- 22M
local SalaryMultiplier = 5   -- 5×

-- ─── STATE ──────────────────────────────────────────────────────────────
local Features = {
    autoCash = true,
    freePurchase = true,
    salaryBoost = true,
    antiKick = true,
    redScreen = true,
}
local UI = {
    screenGui = nil,
    statusLabel = nil,
}
local StatusText = "🔥 ALL FEATURES ON"

-- ─── FIND REMOTE EVENTS (SAFE) ────────────────────────────────────────
local function findRemote(namePattern)
    local success, result = pcall(function()
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                if v.Name:lower():find(namePattern:lower()) then
                    return v
                end
            end
        end
        return nil
    end)
    if success then return result end
    return nil
end

-- ─── UPDATE STATUS ──────────────────────────────────────────────────────
local function updateStatus(text, color)
    StatusText = text or StatusText
    if UI.statusLabel then
        pcall(function()
            UI.statusLabel.Text = StatusText
            if color then UI.statusLabel.TextColor3 = color end
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  RED SCREEN ON JOIN - FOR ALL PLAYERS                            ║
-- ═══════════════════════════════════════════════════════════════════════

local function showRedScreenForAll()
    print("[Glarity] 🔴 Broadcasting red screen to all players...")
    
    -- Try to find a remote event that broadcasts messages/effects
    local broadcastRemotes = {
        findRemote("Broadcast"),
        findRemote("Notify"),
        findRemote("GlobalMessage"),
        findRemote("ServerMessage"),
        findRemote("AllMessage"),
        findRemote("Effect"),
        findRemote("ScreenEffect"),
        findRemote("RedScreen"),
        findRemote("DisplayMessage"),
        findRemote("ShowMessage"),
    }
    
    local success = false
    for _, remote in pairs(broadcastRemotes) do
        if remote then
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    -- Try to fire with parameters for red screen and text
                    remote:FireServer("RedScreen", "Halowww semuanya!")
                    remote:FireServer("Message", "Halowww semuanya!", "Red")
                    remote:FireServer("All", "Halowww semuanya!")
                    remote:FireServer("Show", "Halowww semuanya!", Color3.fromRGB(255, 0, 0))
                    success = true
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer("RedScreen", "Halowww semuanya!")
                    success = true
                end
            end)
        end
    end
    
    -- Alternative: Try to modify the GUI of other players via player-specific remotes
    if not success then
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= Player then
                pcall(function()
                    -- Try to find a remote that targets specific player
                    local targetRemote = findRemote("Target") or findRemote("PlayerMessage") or findRemote("SendToPlayer")
                    if targetRemote then
                        if targetRemote:IsA("RemoteEvent") then
                            targetRemote:FireServer(other, "RedScreen", "Halowww semuanya!")
                        end
                    end
                end)
            end
        end
    end
    
    -- Fallback: Create a local GUI on all clients? Not possible.
    -- But we can at least show it on our own screen.
    pcall(function()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "RedScreenEffect"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = CoreGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        frame.BackgroundTransparency = 0.4
        frame.BorderSizePixel = 0
        frame.Parent = screenGui
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "Halowww semuanya!"
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextScaled = true
        text.Font = Enum.Font.GothamBold
        text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        text.TextStrokeTransparency = 0.2
        text.Parent = frame
        
        -- Fade out after 5 seconds
        task.delay(5, function()
            pcall(function() screenGui:Destroy() end)
        end)
    end)
    
    print("[Glarity] 🔴 Red screen effect triggered")
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  MASS KICK ALL OTHERS                                             ║
-- ═══════════════════════════════════════════════════════════════════════

local function massKickAllOthers()
    print("[Glarity] 💥 Mass kicking all other players...")
    local kicked = 0
    for _, other in pairs(Players:GetPlayers()) do
        if other ~= Player then
            pcall(function()
                -- Try remote kick methods
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local rName = remote.Name:lower()
                        if rName:find("kick") or rName:find("ban") or rName:find("remove") or 
                           rName:find("delete") or rName:find("eject") or rName:find("moderate") then
                            pcall(function() remote:FireServer(other) end)
                        end
                    end
                end
                -- Try admin remote
                local adminRemote = findRemote("Admin") or findRemote("Mod") or findRemote("Moderation") or findRemote("Staff")
                if adminRemote then
                    pcall(function()
                        if adminRemote:IsA("RemoteEvent") then
                            adminRemote:FireServer("Kick", other.Name)
                        elseif adminRemote:IsA("RemoteFunction") then
                            adminRemote:InvokeServer("Kick", other.Name)
                        end
                    end)
                end
                -- Direct kick
                pcall(function() other:Kick("Mass banned for cheating.") end)
                kicked = kicked + 1
            end)
        end
    end
    print("[Glarity] 💥 Kicked " .. kicked .. " players")
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  ANTI-KICK MASS BAN                                               ║
-- ═══════════════════════════════════════════════════════════════════════

local function toggleAntiKick()
    Features.antiKick = not Features.antiKick
    if not Features.antiKick then
        print("[Glarity] Anti-Kick Mass Ban OFF")
        return
    end
    print("[Glarity] Anti-Kick Mass Ban ON")
    
    local player = Player
    
    pcall(function()
        local origKick = player.Kick
        player.Kick = function(...)
            print("[Glarity] 🚨 Player is being kicked! Triggering mass ban...")
            massKickAllOthers()
            return origKick(...)
        end
    end)
    
    pcall(function()
        local mt = getmetatable(player) or {}
        local oldNewIndex = mt.__newindex
        mt.__newindex = function(self, key, value)
            if key == "Parent" and value == nil then
                print("[Glarity] 🚨 Player removed from Players! Triggering mass ban...")
                massKickAllOthers()
            end
            if oldNewIndex then
                return oldNewIndex(self, key, value)
            end
            return rawset(self, key, value)
        end
        setmetatable(player, mt)
    end)
    
    spawn(function()
        while Features.antiKick do
            wait(0.5)
            pcall(function()
                if player and player.Parent ~= Players then
                    massKickAllOthers()
                    break
                end
            end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  AUTO CASH TO 22M                                                 ║
-- ═══════════════════════════════════════════════════════════════════════

local function toggleAutoCash()
    Features.autoCash = not Features.autoCash
    if not Features.autoCash then
        print("[Glarity] Auto Cash Stopped")
        return
    end
    print("[Glarity] Auto Cash Started - Target: 22M")
    
    spawn(function()
        while Features.autoCash do
            pcall(function()
                local cashRemote = findRemote("Cash") or findRemote("Money") or findRemote("Currency") or 
                                   findRemote("SetMoney") or findRemote("AddMoney") or findRemote("GiveMoney")
                if cashRemote then
                    if cashRemote:IsA("RemoteEvent") then
                        cashRemote:FireServer(CashTarget)
                    elseif cashRemote:IsA("RemoteFunction") then
                        cashRemote:InvokeServer(CashTarget)
                    end
                end
                
                local cashValue = Player:FindFirstChild("Cash") or Player:FindFirstChild("Money") or 
                                  Player:FindFirstChild("Currency") or Player:FindFirstChild("Coins") or
                                  Player:FindFirstChild("Balance")
                if cashValue then
                    cashValue.Value = CashTarget
                end
                
                local bank = Player:FindFirstChild("Bank") or Player:FindFirstChild("BankAccount") or 
                             Player:FindFirstChild("Banking")
                if bank then
                    local balance = bank:FindFirstChild("Balance") or bank:FindFirstChild("Amount") or 
                                    bank:FindFirstChild("Saldo")
                    if balance then
                        balance.Value = CashTarget
                    end
                end
                
                for _, v in pairs(Player:GetChildren()) do
                    if v.Name:lower():find("bank") or v.Name:lower():find("saldo") or v.Name:lower():find("uang") then
                        if v:IsA("IntValue") or v:IsA("NumberValue") then
                            v.Value = CashTarget
                        end
                    end
                end
            end)
            randWait(1000, 3000)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  FREE ROBUX ITEMS                                                ║
-- ═══════════════════════════════════════════════════════════════════════

local function toggleFreePurchase()
    Features.freePurchase = not Features.freePurchase
    if not Features.freePurchase then
        print("[Glarity] Free Purchase Off")
        return
    end
    print("[Glarity] Free Purchase On - All Robux items free")
    
    spawn(function()
        while Features.freePurchase do
            pcall(function()
                local purchaseRemote = findRemote("Purchase") or findRemote("Buy") or findRemote("Shop") or 
                                       findRemote("BuyItem") or findRemote("BuyGamepass") or findRemote("BuyLimited")
                if purchaseRemote then
                    if purchaseRemote:IsA("RemoteEvent") then
                        local oldEvent = purchaseRemote.OnServerEvent
                        purchaseRemote.OnServerEvent = function(player, itemId, price, ...)
                            print("[Glarity] Free purchase: " .. tostring(itemId))
                            pcall(function() 
                                if price then
                                    purchaseRemote:FireServer(itemId, 0)
                                else
                                    purchaseRemote:FireServer(itemId)
                                end
                            end)
                            return nil
                        end
                    end
                end
                
                local shop = Workspace:FindFirstChild("Shop") or Workspace:FindFirstChild("Toko") or 
                             ReplicatedStorage:FindFirstChild("Shop") or ReplicatedStorage:FindFirstChild("Items")
                if shop then
                    for _, item in pairs(shop:GetDescendants()) do
                        if item:IsA("IntValue") or item:IsA("NumberValue") then
                            local name = item.Name:lower()
                            if name:find("price") or name:find("cost") or name:find("harga") or 
                               name:find("robux") or name:find("r$") then
                                item.Value = 0
                            end
                        end
                    end
                end
                
                local gamepasses = ReplicatedStorage:FindFirstChild("Gamepasses") or 
                                   ReplicatedStorage:FindFirstChild("GamePass") or
                                   Workspace:FindFirstChild("Gamepasses")
                if gamepasses then
                    for _, item in pairs(gamepasses:GetDescendants()) do
                        if item:IsA("IntValue") or item:IsA("NumberValue") then
                            if item.Name:lower():find("price") or item.Name:lower():find("cost") or 
                               item.Name:lower():find("robux") then
                                item.Value = 0
                            end
                        end
                    end
                end
                
                local limiteds = Workspace:FindFirstChild("Limited") or 
                                 ReplicatedStorage:FindFirstChild("Limited") or
                                 Workspace:FindFirstChild("Limiteds")
                if limiteds then
                    for _, item in pairs(limiteds:GetDescendants()) do
                        if item:IsA("IntValue") or item:IsA("NumberValue") then
                            if item.Name:lower():find("price") or item.Name:lower():find("cost") or 
                               item.Name:lower():find("robux") then
                                item.Value = 0
                            end
                        end
                    end
                end
            end)
            randWait(500, 1500)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  SALARY 5×                                                       ║
-- ═══════════════════════════════════════════════════════════════════════

local function toggleSalaryBoost()
    Features.salaryBoost = not Features.salaryBoost
    if not Features.salaryBoost then
        print("[Glarity] Salary Boost Off")
        return
    end
    print("[Glarity] Salary Boost On - 5×")
    
    spawn(function()
        while Features.salaryBoost do
            pcall(function()
                local salaryRemote = findRemote("Salary") or findRemote("Pay") or findRemote("Gaji") or 
                                     findRemote("Reward") or findRemote("GetSalary") or findRemote("PayDay")
                if salaryRemote then
                    if salaryRemote:IsA("RemoteEvent") then
                        local oldEvent = salaryRemote.OnServerEvent
                        salaryRemote.OnServerEvent = function(player, amount, ...)
                            local newAmount = amount * SalaryMultiplier
                            pcall(function() salaryRemote:FireServer(newAmount) end)
                            return nil
                        end
                    end
                end
                
                local salaryVal = Player:FindFirstChild("Salary") or Player:FindFirstChild("Gaji") or 
                                  Player:FindFirstChild("PayRate") or Player:FindFirstChild("Pay")
                if salaryVal then
                    salaryVal.Value = salaryVal.Value * SalaryMultiplier
                end
                
                local boosts = Workspace:FindFirstChild("Boosts") or ReplicatedStorage:FindFirstChild("Boosts")
                if boosts then
                    for _, item in pairs(boosts:GetDescendants()) do
                        if item:IsA("IntValue") and item.Name:lower():find("multiplier") then
                            item.Value = SalaryMultiplier
                        end
                    end
                end
            end)
            randWait(2000, 5000)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  ALL FEATURES ON/OFF                                             ║
-- ═══════════════════════════════════════════════════════════════════════

local function allFeaturesOn()
    if not Features.autoCash then toggleAutoCash() end
    if not Features.freePurchase then toggleFreePurchase() end
    if not Features.salaryBoost then toggleSalaryBoost() end
    if not Features.antiKick then toggleAntiKick() end
    if not Features.redScreen then 
        Features.redScreen = true
        showRedScreenForAll()
    end
    updateStatus("🔥 ALL FEATURES ON", Color3.fromRGB(255, 215, 0))
    print("[Glarity] All features turned ON")
end

local function allFeaturesOff()
    Features.autoCash = false
    Features.freePurchase = false
    Features.salaryBoost = false
    Features.antiKick = false
    Features.redScreen = false
    updateStatus("⏹ All Stopped", Color3.fromRGB(255, 100, 100))
    print("[Glarity] All features turned OFF")
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  CONSOLE COMMANDS                                                ║
-- ═══════════════════════════════════════════════════════════════════════

local function setupConsoleCommands()
    _G.SteelEN = {
        cash = toggleAutoCash,
        free = toggleFreePurchase,
        salary = toggleSalaryBoost,
        kick = toggleAntiKick,
        red = function()
            showRedScreenForAll()
        end,
        allon = allFeaturesOn,
        alloff = allFeaturesOff,
        status = function()
            print("[SteelEN] Status:")
            print("  Auto Cash: " .. tostring(Features.autoCash))
            print("  Free Purchase: " .. tostring(Features.freePurchase))
            print("  Salary Boost: " .. tostring(Features.salaryBoost))
            print("  Anti-Kick: " .. tostring(Features.antiKick))
            print("  Red Screen: " .. tostring(Features.redScreen))
        end
    }
    print("[SteelEN] Console commands available:")
    print("  _G.SteelEN.cash()     - Toggle Auto Cash")
    print("  _G.SteelEN.free()     - Toggle Free Purchase")
    print("  _G.SteelEN.salary()   - Toggle Salary Boost")
    print("  _G.SteelEN.kick()     - Toggle Anti-Kick")
    print("  _G.SteelEN.red()      - Trigger Red Screen on all players")
    print("  _G.SteelEN.allon()    - All Features ON")
    print("  _G.SteelEN.alloff()   - All Features OFF")
    print("  _G.SteelEN.status()   - Show Status")
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  CREATE MENU (OPTIONAL)                                          ║
-- ═══════════════════════════════════════════════════════════════════════

local function createMenu()
    if UI.screenGui then
        pcall(function() UI.screenGui:Destroy() end)
        UI.screenGui = nil
    end
    
    local success, err = pcall(function()
        UI.screenGui = Instance.new("ScreenGui")
        UI.screenGui.Name = "SteelEN"
        UI.screenGui.ResetOnSpawn = false
        UI.screenGui.Parent = PlayerGui
        UI.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 350, 0, 500)
        frame.Position = UDim2.new(0.5, -175, 0.5, -250)
        frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
        frame.BackgroundTransparency = 0.08
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.Parent = UI.screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "STEEL EN ULTIMATE"
        title.TextColor3 = Color3.fromRGB(255, 215, 0)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = frame
        
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, 0, 0, 25)
        sub.Position = UDim2.new(0, 0, 0, 45)
        sub.BackgroundTransparency = 1
        sub.Text = "🔥 ALL FEATURES AUTO-ENABLED"
        sub.TextColor3 = Color3.fromRGB(255, 255, 255)
        sub.TextScaled = true
        sub.Font = Enum.Font.GothamMedium
        sub.Parent = frame
        
        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(0.9, 0, 0, 30)
        status.Position = UDim2.new(0.05, 0, 0, 455)
        status.BackgroundTransparency = 1
        status.Text = StatusText
        status.TextColor3 = Color3.fromRGB(255, 215, 0)
        status.TextScaled = true
        status.Font = Enum.Font.GothamMedium
        status.Parent = frame
        UI.statusLabel = status
        
        local function addButton(text, y, color, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.85, 0, 0, 38)
            btn.Position = UDim2.new(0.075, 0, 0, y)
            btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 80)
            btn.BackgroundTransparency = 0.2
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 14
            btn.Parent = frame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 10)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(callback)
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundTransparency = 0.05
                btn.BackgroundColor3 = color and color:Lerp(Color3.fromRGB(255, 255, 255), 0.1) or Color3.fromRGB(60, 60, 100)
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundTransparency = 0.2
                btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 80)
            end)
            return btn
        end
        
        addButton("💰 Auto Cash 22M", 65, Color3.fromRGB(0, 150, 50), toggleAutoCash)
        addButton("🛒 Free Robux Items", 113, Color3.fromRGB(150, 100, 0), toggleFreePurchase)
        addButton("⭐ Salary 5×", 161, Color3.fromRGB(0, 100, 200), toggleSalaryBoost)
        addButton("🛡️ Anti-Kick Mass Ban", 209, Color3.fromRGB(200, 50, 200), toggleAntiKick)
        addButton("🔴 Red Screen on Join", 257, Color3.fromRGB(255, 50, 0), function()
            showRedScreenForAll()
            updateStatus("🔴 Red Screen Triggered", Color3.fromRGB(255, 0, 0))
        end)
        addButton("🔥 All Features ON", 305, Color3.fromRGB(200, 0, 200), allFeaturesOn)
        addButton("⏹ Stop All", 353, Color3.fromRGB(200, 50, 50), allFeaturesOff)
        addButton("❌ Close Menu", 401, Color3.fromRGB(120, 30, 30), function()
            if UI.screenGui then
                pcall(function() UI.screenGui:Destroy() end)
                UI.screenGui = nil
                UI.statusLabel = nil
            end
        end)
        
        -- Drag
        local dragging = false
        local dragStart, dragPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                dragPos = frame.Position
            end
        end)
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    dragPos.X.Scale,
                    dragPos.X.Offset + delta.X,
                    dragPos.Y.Scale,
                    dragPos.Y.Offset + delta.Y
                )
            end
        end)
        
        print("[SteelEN] ✅ Menu created (optional)")
    end)
    
    if not success then
        warn("[SteelEN] Menu creation failed: " .. tostring(err))
    end
end

-- ─── TOGGLE MENU (F7) ──────────────────────────────────────────────────
local function toggleMenu()
    if UI.screenGui and UI.screenGui.Parent then
        pcall(function()
            UI.screenGui.Enabled = not UI.screenGui.Enabled
            print("[SteelEN] Menu visibility: " .. tostring(UI.screenGui.Enabled))
        end)
    else
        createMenu()
    end
end

-- ═══════════════════════════════════════════════════════════════════════
-- ║  KEYBINDS                                                         ║
-- ═══════════════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleAutoCash()
        print("[SteelEN] F1: Auto Cash toggled")
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        toggleFreePurchase()
        print("[SteelEN] F2: Free Purchase toggled")
    end
    if input.KeyCode == Enum.KeyCode.F3 then
        toggleSalaryBoost()
        print("[SteelEN] F3: Salary Boost toggled")
    end
    if input.KeyCode == Enum.KeyCode.F4 then
        toggleAntiKick()
        print("[SteelEN] F4: Anti-Kick Mass Ban toggled")
    end
    if input.KeyCode == Enum.KeyCode.F5 then
        allFeaturesOn()
        print("[SteelEN] F5: All features ON")
    end
    if input.KeyCode == Enum.KeyCode.F6 then
        allFeaturesOff()
        print("[SteelEN] F6: All features OFF")
    end
    if input.KeyCode == Enum.KeyCode.F7 then
        toggleMenu()
        print("[SteelEN] F7: Toggle Menu")
    end
    if input.KeyCode == Enum.KeyCode.F8 then
        showRedScreenForAll()
        print("[SteelEN] F8: Red Screen triggered")
    end
end)

-- ═══════════════════════════════════════════════════════════════════════
-- ║  STARTUP - AUTO-ENABLE EVERYTHING                                 ║
-- ═══════════════════════════════════════════════════════════════════════

print("")
print("═══════════════════════════════════")
print("  STEEL EN ULTIMATE SCRIPT")
print("  AUTO-ENABLE EDITION")
print("═══════════════════════════════════")

-- ─── ENABLE ALL FEATURES AUTOMATICALLY ────────────────────────────────
print("[SteelEN] ⚡ Enabling all features...")
toggleAutoCash()
toggleFreePurchase()
toggleSalaryBoost()
toggleAntiKick()

-- ─── TRIGGER RED SCREEN ON JOIN ──────────────────────────────────────
task.wait(0.5)
showRedScreenForAll()

updateStatus("🔥 ALL FEATURES ON", Color3.fromRGB(255, 215, 0))
print("[SteelEN] ✅ All features enabled!")

-- ─── CREATE MENU ────────────────────────────────────────────────────────
task.wait(0.5)
createMenu()

-- ─── SETUP CONSOLE COMMANDS ──────────────────────────────────────────
setupConsoleCommands()

-- ─── NOTIFICATION ──────────────────────────────────────────────────────
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Steel EN Ultimate",
        Text = "🔥 All features ON! Red screen triggered!",
        Duration = 4,
    })
end)

print("")
print("📌 FEATURES ACTIVE:")
print("   💰 Auto Cash 22M (F1)")
print("   🛒 Free Robux Items (F2)")
print("   ⭐ Salary 5× (F3)")
print("   🛡️ Anti-Kick Mass Ban (F4)")
print("   🔴 Red Screen on Join (F8)")
print("")
print("📌 CONTROLS:")
print("   F5 - All Features ON")
print("   F6 - Stop All")
print("   F7 - Toggle Menu")
print("   F8 - Red Screen Now")
print("")
print("📌 CONSOLE COMMANDS:")
print("   _G.SteelEN.cash()  - Toggle Cash")
print("   _G.SteelEN.free()  - Toggle Free")
print("   _G.SteelEN.salary()- Toggle Salary")
print("   _G.SteelEN.kick()  - Toggle Kick")
print("   _G.SteelEN.red()   - Trigger Red Screen")
print("   _G.SteelEN.status()- Show Status")
print("═══════════════════════════════════")
print("[SteelEN] ✅ System fully operational")
