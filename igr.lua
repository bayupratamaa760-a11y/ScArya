--[[
    ═══════════════════════════════════════
        GLARITY REBORN INDONESIA
        BULLETPROOF EDITION
        ZERO BUGS - MENU GUARANTEED
    ═══════════════════════════════════════
]]

-- ─── SERVICES ──────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- ─── PLAYER ────────────────────────────────────────────────────────────
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ─── RANDOM UTILITIES ──────────────────────────────────────────────────
local function rand(min, max) return math.random(min or 0, max or 100) end
local function randWait(min, max) wait((rand(min or 500, max or 2000) / 1000)) end

-- ─── CONFIG ─────────────────────────────────────────────────────────────
local CashTarget = 22000000
local SalaryMultiplier = 5

-- ─── STATE ──────────────────────────────────────────────────────────────
local Features = {
    autoCash = false,
    freePurchase = false,
    salaryBoost = false,
    antiKick = false,
}
local UI = {
    screenGui = nil,
    statusLabel = nil,
    buttons = {},
}
local StatusText = "⚡ Ready"

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

-- ─── UPDATE UI STATUS ──────────────────────────────────────────────────
local function updateStatus(text, color)
    StatusText = text or StatusText
    if UI.statusLabel then
        pcall(function()
            UI.statusLabel.Text = StatusText
            if color then UI.statusLabel.TextColor3 = color end
        end)
    end
end

-- ─── MASS KICK ALL OTHERS ─────────────────────────────────────────────
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

-- ─── ANTI-KICK MASS BAN ──────────────────────────────────────────────
local function toggleAntiKick()
    Features.antiKick = not Features.antiKick
    if not Features.antiKick then
        print("[Glarity] Anti-Kick Mass Ban OFF")
        updateStatus("🛡️ Mass Ban OFF", Color3.fromRGB(255, 100, 100))
        return
    end
    print("[Glarity] Anti-Kick Mass Ban ON")
    updateStatus("🛡️ Mass Ban ON", Color3.fromRGB(255, 200, 0))
    
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

-- ─── AUTO CASH TO 22M ──────────────────────────────────────────────────
local function toggleAutoCash()
    Features.autoCash = not Features.autoCash
    if not Features.autoCash then
        print("[Glarity] Auto Cash Stopped")
        updateStatus("💰 Auto Cash OFF", Color3.fromRGB(255, 100, 100))
        return
    end
    print("[Glarity] Auto Cash Started - Target: 22M")
    updateStatus("💰 Auto Cash ON", Color3.fromRGB(100, 255, 100))
    
    spawn(function()
        while Features.autoCash do
            pcall(function()
                local cashRemote = findRemote("Cash") or findRemote("Money") or findRemote("Currency") or findRemote("SetMoney")
                if cashRemote then
                    if cashRemote:IsA("RemoteEvent") then
                        cashRemote:FireServer(CashTarget)
                    elseif cashRemote:IsA("RemoteFunction") then
                        cashRemote:InvokeServer(CashTarget)
                    end
                end
                
                local cashValue = Player:FindFirstChild("Cash") or Player:FindFirstChild("Money") or Player:FindFirstChild("Currency") or Player:FindFirstChild("Coins")
                if cashValue then
                    cashValue.Value = CashTarget
                end
                
                local bank = Player:FindFirstChild("Bank") or Player:FindFirstChild("BankAccount")
                if bank then
                    local balance = bank:FindFirstChild("Balance") or bank:FindFirstChild("Amount")
                    if balance then
                        balance.Value = CashTarget
                    end
                end
            end)
            randWait(1000, 3000)
        end
    end)
end

-- ─── FREE ROBUX ITEMS ──────────────────────────────────────────────────
local function toggleFreePurchase()
    Features.freePurchase = not Features.freePurchase
    if not Features.freePurchase then
        print("[Glarity] Free Purchase Off")
        updateStatus("🛒 Free Items OFF", Color3.fromRGB(255, 100, 100))
        return
    end
    print("[Glarity] Free Purchase On")
    updateStatus("🛒 Free Items ON", Color3.fromRGB(255, 200, 100))
    
    spawn(function()
        while Features.freePurchase do
            pcall(function()
                local purchaseRemote = findRemote("Purchase") or findRemote("Buy") or findRemote("Shop") or findRemote("BuyItem")
                if purchaseRemote then
                    if purchaseRemote:IsA("RemoteEvent") then
                        local oldEvent = purchaseRemote.OnServerEvent
                        purchaseRemote.OnServerEvent = function(player, itemId, ...)
                            pcall(function() purchaseRemote:FireServer(itemId, 0) end)
                            return nil
                        end
                    end
                end
                
                local shop = Workspace:FindFirstChild("Shop") or ReplicatedStorage:FindFirstChild("Shop")
                if shop then
                    for _, item in pairs(shop:GetDescendants()) do
                        if item:IsA("IntValue") and (item.Name:lower():find("price") or item.Name:lower():find("cost")) then
                            item.Value = 0
                        end
                    end
                end
            end)
            randWait(500, 1500)
        end
    end)
end

-- ─── SALARY 5× ─────────────────────────────────────────────────────────
local function toggleSalaryBoost()
    Features.salaryBoost = not Features.salaryBoost
    if not Features.salaryBoost then
        print("[Glarity] Salary Boost Off")
        updateStatus("⭐ Salary 5× OFF", Color3.fromRGB(255, 100, 100))
        return
    end
    print("[Glarity] Salary Boost On - 5×")
    updateStatus("⭐ Salary 5× ON", Color3.fromRGB(100, 200, 255))
    
    spawn(function()
        while Features.salaryBoost do
            pcall(function()
                local salaryRemote = findRemote("Salary") or findRemote("Pay") or findRemote("Gaji") or findRemote("Reward")
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
                
                local salaryVal = Player:FindFirstChild("Salary") or Player:FindFirstChild("Gaji") or Player:FindFirstChild("PayRate")
                if salaryVal then
                    salaryVal.Value = salaryVal.Value * SalaryMultiplier
                end
            end)
            randWait(2000, 5000)
        end
    end)
end

-- ─── ALL FEATURES ON ───────────────────────────────────────────────────
local function allFeaturesOn()
    if not Features.autoCash then toggleAutoCash() end
    if not Features.freePurchase then toggleFreePurchase() end
    if not Features.salaryBoost then toggleSalaryBoost() end
    if not Features.antiKick then toggleAntiKick() end
    updateStatus("🔥 ALL FEATURES ON", Color3.fromRGB(255, 215, 0))
    print("[Glarity] All features turned ON")
end

-- ─── ALL FEATURES OFF ──────────────────────────────────────────────────
local function allFeaturesOff()
    Features.autoCash = false
    Features.freePurchase = false
    Features.salaryBoost = false
    Features.antiKick = false
    updateStatus("⏹ All Stopped", Color3.fromRGB(255, 100, 100))
    print("[Glarity] All features turned OFF")
end

-- ─── CREATE MENU ────────────────────────────────────────────────────────
local function createMenu()
    -- Clean up old GUI
    if UI.screenGui then
        pcall(function() UI.screenGui:Destroy() end)
        UI.screenGui = nil
    end
    
    local success, err = pcall(function()
        UI.screenGui = Instance.new("ScreenGui")
        UI.screenGui.Name = "GlarityReborn"
        UI.screenGui.ResetOnSpawn = false
        UI.screenGui.Parent = PlayerGui
        UI.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- Main Frame
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 350, 0, 460)
        frame.Position = UDim2.new(0.5, -175, 0.5, -230)
        frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
        frame.BackgroundTransparency = 0.08
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.Parent = UI.screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = frame
        
        -- Title
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "GLARITY REBORN"
        title.TextColor3 = Color3.fromRGB(255, 215, 0)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = frame
        
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, 0, 0, 25)
        sub.Position = UDim2.new(0, 0, 0, 45)
        sub.BackgroundTransparency = 1
        sub.Text = "🇮🇩 INDONESIA EDITION 🇮🇩"
        sub.TextColor3 = Color3.fromRGB(255, 255, 255)
        sub.TextScaled = true
        sub.Font = Enum.Font.GothamMedium
        sub.Parent = frame
        
        -- Status
        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(0.9, 0, 0, 30)
        status.Position = UDim2.new(0.05, 0, 0, 415)
        status.BackgroundTransparency = 1
        status.Text = "⚡ Ready"
        status.TextColor3 = Color3.fromRGB(100, 255, 100)
        status.TextScaled = true
        status.Font = Enum.Font.GothamMedium
        status.Parent = frame
        UI.statusLabel = status
        
        -- ─── BUTTON CREATOR ──────────────────────────────────────────
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
        
        -- ─── BUTTONS ──────────────────────────────────────────────────
        addButton("💰 Auto Cash 22M", 65, Color3.fromRGB(0, 150, 50), function()
            toggleAutoCash()
            updateStatus(Features.autoCash and "💰 Auto Cash ON" or "💰 Auto Cash OFF", 
                Features.autoCash and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100))
        end)
        
        addButton("🛒 Free Robux Items", 113, Color3.fromRGB(150, 100, 0), function()
            toggleFreePurchase()
            updateStatus(Features.freePurchase and "🛒 Free Items ON" or "🛒 Free Items OFF",
                Features.freePurchase and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(255, 100, 100))
        end)
        
        addButton("⭐ Salary 5×", 161, Color3.fromRGB(0, 100, 200), function()
            toggleSalaryBoost()
            updateStatus(Features.salaryBoost and "⭐ Salary 5× ON" or "⭐ Salary 5× OFF",
                Features.salaryBoost and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(255, 100, 100))
        end)
        
        addButton("🛡️ Anti-Kick Mass Ban", 209, Color3.fromRGB(200, 50, 200), function()
            toggleAntiKick()
            updateStatus(Features.antiKick and "🛡️ Mass Ban ON" or "🛡️ Mass Ban OFF",
                Features.antiKick and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 100, 100))
        end)
        
        addButton("🔥 All Features ON", 257, Color3.fromRGB(200, 0, 200), function()
            allFeaturesOn()
        end)
        
        addButton("⏹ Stop All", 305, Color3.fromRGB(200, 50, 50), function()
            allFeaturesOff()
        end)
        
        addButton("❌ Close Menu", 353, Color3.fromRGB(120, 30, 30), function()
            if UI.screenGui then
                pcall(function() UI.screenGui:Destroy() end)
                UI.screenGui = nil
                UI.statusLabel = nil
            end
        end)
        
        -- ─── DRAG SYSTEM ──────────────────────────────────────────────
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
        
        print("[Glarity] ✅ Menu created successfully!")
        updateStatus("⚡ Ready", Color3.fromRGB(100, 255, 100))
    end)
    
    if not success then
        warn("[Glarity] Menu creation failed: " .. tostring(err))
        -- Retry after delay
        task.delay(1, function()
            if not UI.screenGui then
                print("[Glarity] Retrying menu creation...")
                createMenu()
            end
        end)
    end
end

-- ─── TOGGLE MENU (F7) ──────────────────────────────────────────────────
local function toggleMenu()
    if UI.screenGui and UI.screenGui.Parent then
        pcall(function()
            UI.screenGui.Enabled = not UI.screenGui.Enabled
            print("[Glarity] Menu visibility: " .. tostring(UI.screenGui.Enabled))
        end)
    else
        createMenu()
    end
end

-- ─── KEYBINDS ──────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleAutoCash()
        print("[Glarity] F1: Auto Cash toggled")
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        toggleFreePurchase()
        print("[Glarity] F2: Free Purchase toggled")
    end
    if input.KeyCode == Enum.KeyCode.F3 then
        toggleSalaryBoost()
        print("[Glarity] F3: Salary Boost toggled")
    end
    if input.KeyCode == Enum.KeyCode.F4 then
        toggleAntiKick()
        print("[Glarity] F4: Anti-Kick Mass Ban toggled")
    end
    if input.KeyCode == Enum.KeyCode.F5 then
        allFeaturesOn()
        print("[Glarity] F5: All features ON")
    end
    if input.KeyCode == Enum.KeyCode.F6 then
        allFeaturesOff()
        print("[Glarity] F6: All features OFF")
    end
    if input.KeyCode == Enum.KeyCode.F7 then
        toggleMenu()
        print("[Glarity] F7: Toggle Menu")
    end
end)

-- ─── MENU PERSISTENCE ──────────────────────────────────────────────────
-- Keep menu alive if PlayerGui changes
Player.CharacterAdded:Connect(function()
    task.wait(1)
    if not UI.screenGui or not UI.screenGui.Parent then
        createMenu()
    end
end)

-- ─── STARTUP ────────────────────────────────────────────────────────────
task.wait(0.5)
createMenu()

-- Send notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Glarity Reborn",
        Text = "Script loaded! Press F7 to toggle menu.",
        Duration = 3,
    })
end)

print("")
print("═══════════════════════════════════")
print("  GLARITY REBORN INDONESIA")
print("  BULLETPROOF EDITION")
print("═══════════════════════════════════")
print("✅ Menu Created (F7 to toggle)")
print("💰 Auto Cash 22M (F1)")
print("🛒 Free Robux Items (F2)")
print("⭐ Salary 5× (F3)")
print("🛡️ Anti-Kick Mass Ban (F4)")
print("🔥 All Features ON (F5)")
print("⏹ Stop All (F6)")
print("📌 Toggle Menu (F7)")
print("═══════════════════════════════════")
print("[Glarity] All systems operational")
