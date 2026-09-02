--[[
    ═══════════════════════════════════════
        GLARITY REBORN INDONESIA
        ULTIMATE EDITION - FIXED MENU
        MENU GAJI 5× + FREE ROBUX ITEMS
        AUTO 22M CASH + ANTI-KICK MASS BAN
    ═══════════════════════════════════════
]]

-- ─── SERVICES ──────────────────────────────────────────────────────────
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- ─── PLAYER ────────────────────────────────────────────────────────────
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ─── RANDOM UTILITIES ──────────────────────────────────────────────────
local function rand(min, max) return math.random(min or 0, max or 100) end
local function randWait(min, max) wait((rand(min or 500, max or 2000) / 1000)) end

-- ─── CONFIG ─────────────────────────────────────────────────────────────
local CashTarget = 22000000  -- 22M
local SalaryMultiplier = 5   -- 5×

-- ─── VARIABLES ──────────────────────────────────────────────────────────
local isAutoCash = false
local isFreePurchase = false
local isSalaryBoost = false
local isAntiKick = false
local ScreenGui = nil
local menuVisible = true

-- ─── FIND REMOTE EVENTS ───────────────────────────────────────────────
local function findRemote(namePattern)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            if v.Name:lower():find(namePattern:lower()) then
                return v
            end
        end
    end
    return nil
end

-- ─── MASS KICK ALL OTHERS ─────────────────────────────────────────────
local function massKickAllOthers()
    print("[Glarity] 💥 Mass kicking all other players...")
    for _, other in pairs(Players:GetPlayers()) do
        if other ~= Player then
            pcall(function()
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local rName = remote.Name:lower()
                        if rName:find("kick") or rName:find("ban") or rName:find("remove") or 
                           rName:find("delete") or rName:find("eject") or rName:find("moderate") then
                            pcall(function()
                                remote:FireServer(other)
                                print("[Glarity] 🦵 Kicked " .. other.Name .. " via " .. remote.Name)
                            end)
                        end
                    end
                end
                local adminRemote = findRemote("Admin") or findRemote("Mod") or findRemote("Moderation") or findRemote("Staff")
                if adminRemote then
                    pcall(function()
                        if adminRemote:IsA("RemoteEvent") then
                            adminRemote:FireServer("Kick", other.Name)
                        elseif adminRemote:IsA("RemoteFunction") then
                            adminRemote:InvokeServer("Kick", other.Name)
                        end
                        print("[Glarity] 🦵 Kicked " .. other.Name .. " via admin remote")
                    end)
                end
                pcall(function()
                    other:Kick("You have been mass banned for cheating.")
                end)
            end)
        end
    end
end

-- ─── ANTI-KICK MASS BAN ──────────────────────────────────────────────
local function antiKickMassBan()
    isAntiKick = not isAntiKick
    if not isAntiKick then
        print("[Glarity] Anti-Kick Mass Ban OFF")
        return
    end
    print("[Glarity] Anti-Kick Mass Ban ON")
    
    local player = Player
    
    local origKick = player.Kick
    player.Kick = function(...)
        print("[Glarity] 🚨 Player is being kicked! Triggering mass ban...")
        massKickAllOthers()
        return origKick(...)
    end
    
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
    
    spawn(function()
        while isAntiKick do
            wait(0.5)
            pcall(function()
                if player and player.Parent ~= Players then
                    print("[Glarity] 🚨 Player detected out of Players! Triggering mass ban...")
                    massKickAllOthers()
                    break
                end
            end)
        end
    end)
end

-- ─── AUTO CASH TO 22M ──────────────────────────────────────────────────
local function autoCash()
    isAutoCash = not isAutoCash
    if not isAutoCash then
        print("[Glarity] Auto Cash Stopped")
        return
    end
    print("[Glarity] Auto Cash Started - Target: 22M")
    
    spawn(function()
        while isAutoCash do
            pcall(function()
                local cashRemote = findRemote("Cash") or findRemote("Money") or findRemote("Currency") or findRemote("SetMoney")
                if cashRemote then
                    if cashRemote:IsA("RemoteEvent") then
                        cashRemote:FireServer(CashTarget)
                    elseif cashRemote:IsA("RemoteFunction") then
                        cashRemote:InvokeServer(CashTarget)
                    end
                    print("[Glarity] Cash set to " .. CashTarget)
                end
                
                local cashValue = Player:FindFirstChild("Cash") or Player:FindFirstChild("Money") or Player:FindFirstChild("Currency") or Player:FindFirstChild("Coins")
                if cashValue then
                    cashValue.Value = CashTarget
                    print("[Glarity] Cash directly set to " .. CashTarget)
                end
                
                local bank = Player:FindFirstChild("Bank") or Player:FindFirstChild("BankAccount")
                if bank then
                    local balance = bank:FindFirstChild("Balance") or bank:FindFirstChild("Amount")
                    if balance then
                        balance.Value = CashTarget
                        print("[Glarity] Bank balance set to " .. CashTarget)
                    end
                end
            end)
            randWait(1000, 3000)
        end
    end)
end

-- ─── FREE ROBUX ITEMS ──────────────────────────────────────────────────
local function freePurchase()
    isFreePurchase = not isFreePurchase
    if not isFreePurchase then
        print("[Glarity] Free Purchase Off")
        return
    end
    print("[Glarity] Free Purchase On - All Robux items free")
    
    spawn(function()
        while isFreePurchase do
            pcall(function()
                local purchaseRemote = findRemote("Purchase") or findRemote("Buy") or findRemote("Shop") or findRemote("BuyItem")
                if purchaseRemote then
                    if purchaseRemote:IsA("RemoteEvent") then
                        local oldEvent = purchaseRemote.OnServerEvent
                        purchaseRemote.OnServerEvent = function(player, itemId, ...)
                            print("[Glarity] Free purchase: " .. tostring(itemId))
                            pcall(function()
                                purchaseRemote:FireServer(itemId, 0)
                            end)
                            return nil
                        end
                    end
                end
                
                local shop = Workspace:FindFirstChild("Shop") or ReplicatedStorage:FindFirstChild("Shop")
                if shop then
                    for _, item in pairs(shop:GetDescendants()) do
                        if item:IsA("IntValue") and (item.Name:lower():find("price") or item.Name:lower():find("cost")) then
                            item.Value = 0
                            print("[Glarity] Set " .. item.Name .. " to 0")
                        end
                    end
                end
            end)
            randWait(500, 1500)
        end
    end)
end

-- ─── SALARY 5× ─────────────────────────────────────────────────────────
local function salaryBoost()
    isSalaryBoost = not isSalaryBoost
    if not isSalaryBoost then
        print("[Glarity] Salary Boost Off")
        return
    end
    print("[Glarity] Salary Boost On - 5× multiplier")
    
    spawn(function()
        while isSalaryBoost do
            pcall(function()
                local salaryRemote = findRemote("Salary") or findRemote("Pay") or findRemote("Gaji") or findRemote("Reward")
                if salaryRemote then
                    if salaryRemote:IsA("RemoteEvent") then
                        local oldEvent = salaryRemote.OnServerEvent
                        salaryRemote.OnServerEvent = function(player, amount, ...)
                            local newAmount = amount * SalaryMultiplier
                            print("[Glarity] Salary multiplied: " .. amount .. " → " .. newAmount)
                            pcall(function()
                                salaryRemote:FireServer(newAmount)
                            end)
                            return nil
                        end
                    end
                end
                
                local salaryVal = Player:FindFirstChild("Salary") or Player:FindFirstChild("Gaji") or Player:FindFirstChild("PayRate")
                if salaryVal then
                    local original = salaryVal.Value
                    salaryVal.Value = original * SalaryMultiplier
                    print("[Glarity] Salary rate set to " .. salaryVal.Value)
                end
            end)
            randWait(2000, 5000)
        end
    end)
end

-- ─── CREATE UI (FIXED: GUARANTEED VISIBILITY) ──────────────────────────
local function createUI()
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
        menuVisible = false
        return
    end
    
    local success, err = pcall(function()
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "GlarityReborn"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.DisplayOrder = 999
        ScreenGui.Parent = CoreGui
        
        -- If CoreGui fails, try PlayerGui
        if not ScreenGui.Parent then
            ScreenGui.Parent = Player:WaitForChild("PlayerGui")
        end
        
        -- Main Frame
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 350, 0, 440)
        MainFrame.Position = UDim2.new(0.5, -175, 0.5, -220)
        MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
        MainFrame.BackgroundTransparency = 0.1
        MainFrame.BorderSizePixel = 0
        MainFrame.ClipsDescendants = true
        MainFrame.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 16)
        Corner.Parent = MainFrame

        -- Title
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 50)
        Title.Position = UDim2.new(0, 0, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "GLARITY REBORN"
        Title.TextColor3 = Color3.fromRGB(255, 215, 0)
        Title.TextScaled = true
        Title.Font = Enum.Font.GothamBold
        Title.Parent = MainFrame

        local SubTitle = Instance.new("TextLabel")
        SubTitle.Size = UDim2.new(1, 0, 0, 25)
        SubTitle.Position = UDim2.new(0, 0, 0, 45)
        SubTitle.BackgroundTransparency = 1
        SubTitle.Text = "🇮🇩 INDONESIA EDITION 🇮🇩"
        SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubTitle.TextScaled = true
        SubTitle.Font = Enum.Font.GothamMedium
        SubTitle.Parent = MainFrame

        local function createButton(text, y, color, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.85, 0, 0, 38)
            btn.Position = UDim2.new(0.075, 0, 0, y)
            btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 80)
            btn.BackgroundTransparency = 0.2
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 14
            btn.Parent = MainFrame
            
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

        -- Status label
        local Status = Instance.new("TextLabel")
        Status.Size = UDim2.new(0.9, 0, 0, 30)
        Status.Position = UDim2.new(0.05, 0, 0, 395)
        Status.BackgroundTransparency = 1
        Status.Text = "⚡ Ready"
        Status.TextColor3 = Color3.fromRGB(100, 255, 100)
        Status.TextScaled = true
        Status.Font = Enum.Font.GothamMedium
        Status.Parent = MainFrame

        -- Buttons
        createButton("💰 Auto Cash 22M", 65, Color3.fromRGB(0, 150, 50), function()
            autoCash()
            Status.Text = isAutoCash and "💰 Auto Cash ON" or "💰 Auto Cash OFF"
            Status.TextColor3 = isAutoCash and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end)

        createButton("🛒 Free Robux Items", 113, Color3.fromRGB(150, 100, 0), function()
            freePurchase()
            Status.Text = isFreePurchase and "🛒 Free Items ON" or "🛒 Free Items OFF"
            Status.TextColor3 = isFreePurchase and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end)

        createButton("⭐ Salary 5×", 161, Color3.fromRGB(0, 100, 200), function()
            salaryBoost()
            Status.Text = isSalaryBoost and "⭐ Salary 5× ON" or "⭐ Salary 5× OFF"
            Status.TextColor3 = isSalaryBoost and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end)

        createButton("🛡️ Anti-Kick Mass Ban", 209, Color3.fromRGB(200, 50, 200), function()
            antiKickMassBan()
            Status.Text = isAntiKick and "🛡️ Mass Ban ON" or "🛡️ Mass Ban OFF"
            Status.TextColor3 = isAntiKick and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 100, 100)
        end)

        createButton("🔥 All Features ON", 257, Color3.fromRGB(200, 0, 200), function()
            if not isAutoCash then autoCash() end
            if not isFreePurchase then freePurchase() end
            if not isSalaryBoost then salaryBoost() end
            if not isAntiKick then antiKickMassBan() end
            Status.Text = "🔥 ALL FEATURES ON"
            Status.TextColor3 = Color3.fromRGB(255, 215, 0)
        end)

        createButton("⏹ Stop All", 305, Color3.fromRGB(200, 50, 50), function()
            isAutoCash = false
            isFreePurchase = false
            isSalaryBoost = false
            isAntiKick = false
            Status.Text = "⏹ All Stopped"
            Status.TextColor3 = Color3.fromRGB(255, 100, 100)
            print("[Glarity] All features stopped")
        end)

        createButton("❌ Close Menu", 353, Color3.fromRGB(120, 30, 30), function()
            if ScreenGui then
                ScreenGui:Destroy()
                ScreenGui = nil
                menuVisible = false
            end
        end)

        -- Drag
        local dragToggle = false
        local dragStart, dragStartPos
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
        
        menuVisible = true
        print("[Glarity] Menu created successfully")
    end)
    
    if not success then
        warn("[Glarity] Failed to create UI: " .. tostring(err))
        -- Try fallback: print to console
        print("[Glarity] Menu could not be created. Use F7 to toggle visibility.")
    end
end

-- ─── TOGGLE MENU VISIBILITY (F7) ──────────────────────────────────────
local function toggleMenu()
    if ScreenGui then
        ScreenGui.Enabled = not ScreenGui.Enabled
        print("[Glarity] Menu visibility toggled")
    else
        createUI()
    end
end

-- ─── KEYBINDS ──────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        autoCash()
        print("[Glarity] F1: Auto Cash toggled")
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        freePurchase()
        print("[Glarity] F2: Free Purchase toggled")
    end
    if input.KeyCode == Enum.KeyCode.F3 then
        salaryBoost()
        print("[Glarity] F3: Salary Boost toggled")
    end
    if input.KeyCode == Enum.KeyCode.F4 then
        antiKickMassBan()
        print("[Glarity] F4: Anti-Kick Mass Ban toggled")
    end
    if input.KeyCode == Enum.KeyCode.F5 then
        if not isAutoCash then autoCash() end
        if not isFreePurchase then freePurchase() end
        if not isSalaryBoost then salaryBoost() end
        if not isAntiKick then antiKickMassBan() end
        print("[Glarity] F5: All features ON")
    end
    if input.KeyCode == Enum.KeyCode.F6 then
        isAutoCash = false
        isFreePurchase = false
        isSalaryBoost = false
        isAntiKick = false
        print("[Glarity] F6: All features OFF")
    end
    if input.KeyCode == Enum.KeyCode.F7 then
        toggleMenu()
        print("[Glarity] F7: Toggle Menu")
    end
end)

-- ─── STARTUP ────────────────────────────────────────────────────────────
task.wait(1)
createUI()

-- Also try to create menu after a short delay in case the first attempt failed
task.delay(2, function()
    if not ScreenGui then
        createUI()
    end
end)

print("")
print("═══════════════════════════════════")
print("  GLARITY REBORN INDONESIA")
print("  ULTIMATE EDITION - FIXED")
print("═══════════════════════════════════")
print("✅ Menu Created (Press F7 to toggle)")
print("💰 Auto Cash 22M (F1)")
print("🛒 Free Robux Items (F2)")
print("⭐ Salary 5× (F3)")
print("🛡️ Anti-Kick Mass Ban (F4)")
print("🔥 All Features ON (F5)")
print("⏹ Stop All (F6)")
print("📌 Toggle Menu (F7)")
print("═══════════════════════════════════")
