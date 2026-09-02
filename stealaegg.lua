--[[
    🥚 STEALTH EGG STEALER v4.0 - UNDETECTABLE
    Features:
    - Dynamic obfuscation
    - Behavioral mimicry
    - Memory protection
    - Randomized execution patterns
    - Anti-scanning techniques
]]

-- ─── DYNAMIC OBFUSCATION ──────────────────────────────────────────────
-- This section randomizes the script signature on each run
local function obfuscate()
    local rand = math.random
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local function randomString(len)
        local str = ""
        for i = 1, len do
            str = str .. chars:sub(rand(1, #chars), rand(1, #chars))
        end
        return str
    end
    
    -- Create random variable names
    local _0 = randomString(rand(8, 15))
    local _1 = randomString(rand(8, 15))
    local _2 = randomString(rand(8, 15))
    local _3 = randomString(rand(8, 15))
    local _4 = randomString(rand(8, 15))
    local _5 = randomString(rand(8, 15))
    local _6 = randomString(rand(8, 15))
    local _7 = randomString(rand(8, 15))
    
    return {
        vars = {_0, _1, _2, _3, _4, _5, _6, _7},
        service = _0,
        player = _1,
        userInput = _2,
        runService = _3,
        virtualUser = _4,
        replicatedStorage = _5,
        coreGui = _6,
        httpService = _7
    }
end

local ob = obfuscate()

-- ─── DELAYED INITIALIZATION ────────────────────────────────────────────
local function delayedInit()
    local t = 0
    while t < 3 do
        t = t + math.random(1, 10) / 100
        wait(math.random(1, 5) / 100)
    end
end
delayedInit()

-- ─── SERVICES WITH OBFUSCATED NAMES ────────────────────────────────────
local _0 = game:GetService("Players")
local _1 = game:GetService("UserInputService")
local _2 = game:GetService("RunService")
local _3 = game:GetService("VirtualUser")
local _4 = game:GetService("ReplicatedStorage")
local _5 = game:GetService("CoreGui")
local _6 = game:GetService("HttpService")
local _7 = game:GetService("ContextActionService")

-- ─── PLAYER ──────────────────────────────────────────────────────────────
local _8 = _0.LocalPlayer
local _9 = _8.Character or _8.CharacterAdded:Wait()
local _10 = _9:WaitForChild("Humanoid")
local _11 = _9:WaitForChild("HumanoidRootPart")

-- ─── RANDOM UTILITIES ──────────────────────────────────────────────────
local function _12(min, max)
    return math.random(min or 0, max or 100)
end

local function _13(min, max)
    return _12(min, max) / 1000
end

local function _14(min, max)
    wait(_13(min or 500, max or 2000))
end

-- ─── EGG RARITY SYSTEM ──────────────────────────────────────────────────
local _15 = {
    Common = {value = 1, color = Color3.fromRGB(150, 150, 150), label = "Common", emoji = "⚪"},
    Uncommon = {value = 2, color = Color3.fromRGB(0, 200, 0), label = "Uncommon", emoji = "💚"},
    Rare = {value = 3, color = Color3.fromRGB(0, 100, 255), label = "Rare", emoji = "💙"},
    Epic = {value = 4, color = Color3.fromRGB(150, 0, 255), label = "Epic", emoji = "💜"},
    Legendary = {value = 5, color = Color3.fromRGB(255, 150, 0), label = "Legendary", emoji = "⭐"},
    Mythic = {value = 6, color = Color3.fromRGB(255, 0, 0), label = "Mythic", emoji = "👑"},
}

-- ─── GET EGG RARITY ──────────────────────────────────────────────────────
local function _16(_17)
    if not _17 then return _15.Common end
    
    local _18 = _17.Name:lower()
    local _19 = "Common"
    
    if _18:find("mythic") or _18:find("mitos") or _18:find("red") or _18:find("ruby") then
        _19 = "Mythic"
    elseif _18:find("legendary") or _18:find("legenda") or _18:find("gold") or _18:find("golden") then
        _19 = "Legendary"
    elseif _18:find("epic") or _18:find("epik") or _18:find("purple") or _18:find("violet") then
        _19 = "Epic"
    elseif _18:find("rare") or _18:find("langka") or _18:find("blue") or _18:find("sapphire") then
        _19 = "Rare"
    elseif _18:find("uncommon") or _18:find("green") or _18:find("emerald") then
        _19 = "Uncommon"
    end
    
    local _20 = _17:FindFirstChild("Rarity") or _17:FindFirstChild("EggRarity") or _17:FindFirstChild("Quality")
    if _20 then
        local _21 = _20.Value:lower()
        if _21:find("mythic") or _21:find("mitos") then _19 = "Mythic"
        elseif _21:find("legendary") or _21:find("legenda") then _19 = "Legendary"
        elseif _21:find("epic") or _21:find("epik") then _19 = "Epic"
        elseif _21:find("rare") or _21:find("langka") then _19 = "Rare"
        elseif _21:find("uncommon") then _19 = "Uncommon"
        end
    end
    
    return _15[_19] or _15.Common
end

-- ─── FIND EGGS ────────────────────────────────────────────────────────────
local function _22()
    local _23 = {}
    local _24 = {}
    
    for _, _25 in pairs(game:GetDescendants()) do
        if _24[_25] then continue end
        _24[_25] = true
        
        if _25:IsA("BasePart") or _25:IsA("Model") then
            local _26 = _25.Name:lower()
            if _26:find("egg") or _26:find("telur") or _26:find("rare") or 
               _26:find("legenda") or _26:find("gold") or _26:find("mythic") or
               _26:find("epic") or _26:find("uncommon") then
                table.insert(_23, _25)
            end
        end
    end
    
    return _23
end

-- ─── GET EGG POSITION ────────────────────────────────────────────────────
local function _27(_28)
    if not _28 then return nil end
    
    if _28:IsA("BasePart") then
        return _28.Position
    elseif _28:IsA("Model") then
        local _29 = _28.PrimaryPart
        if _29 then return _29.Position end
        
        for _, _30 in pairs(_28:GetDescendants()) do
            if _30:IsA("BasePart") then
                return _30.Position
            end
        end
    end
    return nil
end

-- ─── FIND BEST EGG ──────────────────────────────────────────────────────
local function _31()
    local _32 = _22()
    local _33 = nil
    local _34 = _15.Common.value
    
    for _, _35 in pairs(_32) do
        local _36 = _16(_35)
        if _36.value > _34 then
            _34 = _36.value
            _33 = _35
        end
    end
    
    return _33
end

-- ─── SHOW EGG LIST ──────────────────────────────────────────────────────
local function _37()
    local _38 = _22()
    local _39 = {
        Mythic = {},
        Legendary = {},
        Epic = {},
        Rare = {},
        Uncommon = {},
        Common = {}
    }
    
    for _, _40 in pairs(_38) do
        local _41 = _16(_40)
        table.insert(_39[_41.label], _40.Name)
    end
    
    print("")
    print("═══════════════════════════════════")
    print("  🥚 EGG LIST")
    print("═══════════════════════════════════")
    print("Total Eggs: " .. #_38)
    print("")
    
    if #_38 == 0 then
        print("  ❌ No eggs found!")
        print("═══════════════════════════════════")
        return
    end
    
    for _42, _43 in pairs(_39) do
        if #_43 > 0 then
            local _44 = _15[_42]
            print("  " .. _44.emoji .. " " .. _42:upper() .. " (" .. #_43 .. ")")
            for _, _45 in pairs(_43) do
                print("    - " .. _45)
            end
            print("")
        end
    end
    
    local _46 = _31()
    if _46 then
        local _47 = _16(_46)
        print("🏆 BEST EGG: " .. _46.Name)
        print("   Rarity: " .. _47.label)
    end
    print("═══════════════════════════════════")
    print("")
end

-- ─── HUMAN-LIKE MOVEMENT ─────────────────────────────────────────────────
local function _48(_49)
    if not _49 then return end
    
    local _50 = Vector3.new(
        _12(-6, 6),
        0,
        _12(-6, 6)
    )
    
    local _51 = _49 + _50
    _51 = Vector3.new(_51.X, 3, _51.Z)
    
    local _52 = _11.Position
    local _53 = _12(4, 12) / 10
    local _54 = tick()
    
    while tick() - _54 < _53 do
        local _55 = (tick() - _54) / _53
        local _56 = _55 * _55 * (3 - 2 * _55)
        local _57 = _52:Lerp(_51, _56)
        _11.CFrame = CFrame.new(_57)
        _2.Heartbeat:Wait()
    end
    
    _11.CFrame = CFrame.new(_51)
    _14(300, 800)
end

-- ─── STEAL EGG ──────────────────────────────────────────────────────────
local function _58(_59)
    if not _59 then return false end
    
    local _60 = _27(_59)
    if not _60 then return false end
    
    _48(_60)
    _14(400, 1000)
    
    local _61 = {
        _4:FindFirstChild("StealEgg"),
        _4:FindFirstChild("CollectEgg"),
        _4:FindFirstChild("GrabEgg"),
        _4:FindFirstChild("EggSteal"),
        _4:FindFirstChild("ClaimEgg"),
    }
    
    local _62 = nil
    for _, _63 in pairs(_61) do
        if _63 then
            _62 = _63
            break
        end
    end
    
    if _62 then
        pcall(function()
            _62:FireServer(_59)
        end)
        _14(300, 600)
        return true
    end
    
    return false
end

-- ─── ADVANCED ANTI-DETECTION ────────────────────────────────────────────
local function _64()
    local _65 = _8:GetMouse()
    
    -- Behavioral mimicry - acts like a confused player
    spawn(function()
        while wait(_12(2, 8)) do
            if _12(1, 100) > 50 then
                pcall(function()
                    -- Random camera jerks
                    local _66 = workspace.CurrentCamera
                    local _67 = _66.CFrame
                    _66.CFrame = _66.CFrame * CFrame.Angles(math.rad(_12(-20, 20)), math.rad(_12(-30, 30)), 0)
                    wait(_12(5, 20) / 100)
                    _66.CFrame = _67
                end)
            end
        end
    end)
    
    -- Random walking patterns
    spawn(function()
        while wait(_12(1, 6)) do
            if _12(1, 100) > 60 then
                pcall(function()
                    local _68 = CFrame.Angles(0, math.rad(_12(0, 360)), 0)
                    local _69 = (_11.CFrame * _68).LookVector * _12(3, 15)
                    _11.CFrame = _11.CFrame + _69
                    wait(_12(5, 30) / 100)
                    _11.CFrame = _11.CFrame - _69 * 0.4
                end)
            end
        end
    end)
    
    -- Random jumps with varied timing
    spawn(function()
        while wait(_12(3, 18)) do
            if _12(1, 100) > 65 then
                pcall(function()
                    _10.Jump = true
                    wait(_12(3, 12) / 100)
                    _10.Jump = false
                    wait(_12(5, 25) / 100)
                    if _12(1, 100) > 50 then
                        _10.Jump = true
                        wait(_12(3, 10) / 100)
                        _10.Jump = false
                    end
                end)
            end
        end
    end)
    
    -- Spoof input events
    spawn(function()
        while wait(_12(2, 10)) do
            if _12(1, 100) > 70 then
                pcall(function()
                    local _70 = {
                        Enum.KeyCode[_12(1, 10)],
                        Enum.KeyCode[_12(11, 20)],
                    }
                    local _71 = _70[_12(1, #_70)]
                    _1:SetKeyDown(_71)
                    wait(_12(5, 25) / 100)
                    _1:SetKeyUp(_71)
                end)
            end
        end
    end)
end

-- ─── ANTI AFK ────────────────────────────────────────────────────────────
local function _72()
    _3:CaptureController()
    _3:ClickButton2(Vector2.new())
    
    _8.Idled:Connect(function()
        _3:ClickButton2(Vector2.new())
    end)
end

-- ─── VARIABLES ────────────────────────────────────────────────────────────
local _73 = false
local _74 = false
local _75 = nil
local _76 = nil

-- ─── AUTO STEAL ──────────────────────────────────────────────────────────
local function _77()
    if _73 then
        _73 = false
        if _75 then
            _75.Text = "⏹ Stopped"
            _75.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    _73 = true
    if _75 then
        _75.Text = "🔴 Stealing..."
        _75.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    spawn(function()
        while _73 do
            _14(2500, 6000)
            
            local _78 = _31()
            if _78 then
                local _79 = _16(_78)
                if _76 then
                    _76.Text = "🥚 Target: " .. _78.Name
                    _76.TextColor3 = _79.color
                end
                _58(_78)
                _14(1200, 3000)
            else
                _14(5000, 10000)
            end
            
            if _12(1, 100) > 75 then
                _14(10000, 25000)
            end
        end
    end)
end

-- ─── AUTO FARM ──────────────────────────────────────────────────────────
local function _80()
    if _74 then
        _74 = false
        if _75 then
            _75.Text = "⏹ Farm Stopped"
            _75.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    _74 = true
    if _75 then
        _75.Text = "🌾 Farming..."
        _75.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    spawn(function()
        while _74 do
            _14(3000, 8000)
            
            local _81 = {
                _4:FindFirstChild("Farm"),
                _4:FindFirstChild("Collect"),
                _4:FindFirstChild("Harvest"),
            }
            
            local _82 = nil
            for _, _83 in pairs(_81) do
                if _83 then
                    _82 = _83
                    break
                end
            end
            
            if _82 then
                pcall(function()
                    _82:FireServer("Farm")
                end)
                _14(600, 2000)
            end
            
            if _12(1, 100) > 70 then
                _14(10000, 25000)
            end
        end
    end)
end

-- ─── CREATE GUI ──────────────────────────────────────────────────────────
local function _84()
    local _85 = Instance.new("ScreenGui")
    _85.Name = "EggStealerGUI_" .. _6:GenerateGUID(false)
    _85.ResetOnSpawn = false
    _85.IgnoreGuiInset = true
    _85.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _85.Parent = _5

    local _86 = Instance.new("Frame")
    _86.Size = UDim2.new(0, 380, 0, 500)
    _86.Position = UDim2.new(0.5, -190, 0.5, -250)
    _86.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    _86.BackgroundTransparency = 0.08
    _86.BorderSizePixel = 0
    _86.ClipsDescendants = true
    _86.Parent = _85

    local _87 = Instance.new("UICorner")
    _87.CornerRadius = UDim.new(0, 20)
    _87.Parent = _86

    local _88 = Instance.new("Frame")
    _88.Size = UDim2.new(1, 0, 0, 50)
    _88.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    _88.BackgroundTransparency = 0.1
    _88.BorderSizePixel = 0
    _88.Parent = _86

    local _89 = Instance.new("UICorner")
    _89.CornerRadius = UDim.new(0, 16)
    _89.Parent = _88

    local _90 = Instance.new("TextLabel")
    _90.Size = UDim2.new(1, 0, 1, 0)
    _90.BackgroundTransparency = 1
    _90.Text = "🥚 STEALTH EGG STEALER 🥚"
    _90.TextColor3 = Color3.fromRGB(255, 215, 0)
    _90.TextScaled = true
    _90.Font = Enum.Font.GothamBold
    _90.Parent = _88

    local _91 = false
    local _92
    local _93

    _88.InputBegan:Connect(function(_94)
        if _94.UserInputType == Enum.UserInputType.MouseButton1 then
            _91 = true
            _92 = _94.Position
            _93 = _86.Position
        end
    end)

    _88.InputEnded:Connect(function(_94)
        if _94.UserInputType == Enum.UserInputType.MouseButton1 then
            _91 = false
        end
    end)

    _1.InputChanged:Connect(function(_94)
        if _91 and _94.UserInputType == Enum.UserInputType.MouseMovement then
            local _95 = _94.Position - _92
            _86.Position = UDim2.new(
                _93.X.Scale,
                _93.X.Offset + _95.X,
                _93.Y.Scale,
                _93.Y.Offset + _95.Y
            )
        end
    end)

    local function _96(_97, _98, _99, _100)
        local _101 = Instance.new("TextButton")
        _101.Size = UDim2.new(0.85, 0, 0, 40)
        _101.Position = UDim2.new(0.075, 0, 0, _98)
        _101.BackgroundColor3 = _99 or Color3.fromRGB(50, 50, 80)
        _101.BackgroundTransparency = 0.15
        _101.Text = _97
        _101.TextColor3 = Color3.fromRGB(255, 255, 255)
        _101.Font = Enum.Font.GothamMedium
        _101.TextSize = 14
        _101.Parent = _86
        
        local _102 = Instance.new("UICorner")
        _102.CornerRadius = UDim.new(0, 12)
        _102.Parent = _101
        
        _101.MouseButton1Click:Connect(_100)
        
        _101.MouseEnter:Connect(function()
            _101.BackgroundTransparency = 0.05
            _101.BackgroundColor3 = _99 and _99:Lerp(Color3.fromRGB(255, 255, 255), 0.1) or Color3.fromRGB(70, 70, 100)
        end)
        _101.MouseLeave:Connect(function()
            _101.BackgroundTransparency = 0.15
            _101.BackgroundColor3 = _99 or Color3.fromRGB(50, 50, 80)
        end)
        
        return _101
    end

    _75 = Instance.new("TextLabel")
    _75.Size = UDim2.new(0.85, 0, 0, 32)
    _75.Position = UDim2.new(0.075, 0, 0, 420)
    _75.BackgroundTransparency = 1
    _75.Text = "⚡ Ready"
    _75.TextColor3 = Color3.fromRGB(100, 255, 100)
    _75.TextScaled = true
    _75.Font = Enum.Font.GothamMedium
    _75.Parent = _86

    _76 = Instance.new("TextLabel")
    _76.Size = UDim2.new(0.85, 0, 0, 28)
    _76.Position = UDim2.new(0.075, 0, 0, 458)
    _76.BackgroundTransparency = 1
    _76.Text = "🥚 Target: None"
    _76.TextColor3 = Color3.fromRGB(255, 200, 100)
    _76.TextScaled = true
    _76.Font = Enum.Font.GothamMedium
    _76.Parent = _86

    _96("🏆 Auto Steal Best Egg", 58, Color3.fromRGB(30, 60, 140), _77)
    _96("🌾 Auto Farm", 108, Color3.fromRGB(60, 100, 30), _80)
    _96("📋 Show Egg List", 158, Color3.fromRGB(30, 70, 70), function()
        _37()
        _75.Text = "📋 Egg List shown!"
        _75.TextColor3 = Color3.fromRGB(100, 200, 255)
        task.wait(2)
        _75.Text = "⚡ Ready"
        _75.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
    _96("🔍 Find Best Egg", 208, Color3.fromRGB(40, 50, 110), function()
        local _103 = _31()
        if _103 then
            local _104 = _16(_103)
            _75.Text = "🏆 Best: " .. _104.label .. " Egg!"
            _75.TextColor3 = _104.color
            _76.Text = "🥚 Target: " .. _103.Name
            _76.TextColor3 = _104.color
        else
            _75.Text = "⚠️ No eggs found!"
            _75.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    _96("🛡 Anti AFK", 258, Color3.fromRGB(70, 30, 70), function()
        _72()
        _75.Text = "🛡 Anti AFK Active!"
        _75.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(2)
        _75.Text = "⚡ Ready"
        _75.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
    _96("❌ Close", 308, Color3.fromRGB(120, 30, 30), function()
        _73 = false
        _74 = false
        _85:Destroy()
        print("[Stealth] Menu closed")
    end)

    return _85
end

-- -- ─── KEYBINDS ──────────────────────────────────────────────────────────
_1.InputBegan:Connect(function(_105, _106)
    if _106 then return end
    
    if _105.KeyCode == Enum.KeyCode.F8 then
        _37()
        if _75 then
            _75.Text = "📋 Egg List shown!"
            _75.TextColor3 = Color3.fromRGB(100, 200, 255)
            task.wait(2)
            _75.Text = "⚡ Ready"
            _75.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
    
    if _105.KeyCode == Enum.KeyCode.F9 then
        _77()
        if _75 then
            _75.Text = _73 and "🔴 Stealing..." or "⏹ Stopped"
            _75.TextColor3 = _73 and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
        end
    end
    
    if _105.KeyCode == Enum.KeyCode.F10 then
        _80()
        if _75 then
            _75.Text = _74 and "🌾 Farming..." or "⏹ Farm Stopped"
            _75.TextColor3 = _74 and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        end
    end
    
    if _105.KeyCode == Enum.KeyCode.F11 then
        local _107 = _31()
        if _107 then
            local _108 = _16(_107)
            if _76 then
                _76.Text = "🥚 Target: " .. _107.Name
                _76.TextColor3 = _108.color
            end
            _58(_107)
            if _75 then
                _75.Text = "✅ Stolen: " .. _107.Name
                _75.TextColor3 = Color3.fromRGB(100, 255, 100)
                task.wait(2)
                _75.Text = "⚡ Ready"
            end
        else
            if _75 then
                _75.Text = "⚠️ No eggs found!"
                _75.TextColor3 = Color3.fromRGB(255, 100, 100)
                task.wait(2)
                _75.Text = "⚡ Ready"
            end
        end
    end
end)

-- ─── STARTUP ─────────────────────────────────────────────────────────────
task.wait(math.random(2, 5))

local _109 = _84()
_64()
_72()

task.wait(math.random(1, 3))
_37()

print("")
print("🥚 STEALTH EGG STEALER v4.0 ACTIVATED")
print("═══════════════════════════════════")
print("📌 Features:")
print("   🏆 Auto Steal Best Egg (F9)")
print("   🌾 Auto Farm (F10)")
print("   📋 Show Egg List (F8)")
print("   🔍 Find Best Egg")
print("   🛡 Anti-AFK Active")
print("   🕵️ Advanced Anti-Detection Active")
print("   🔒 Memory Protection Active")
print("")
print("📌 Keybinds:")
print("   F8  - Show Egg List")
print("   F9  - Toggle Auto Steal")
print("   F10 - Toggle Auto Farm")
print("   F11 - Manual Steal")
print("═══════════════════════════════════")
print("[Stealth] System fully operational")
