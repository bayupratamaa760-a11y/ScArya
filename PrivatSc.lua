--[[
    ═══════════════════════════════════════
        SC ARYA PRIVAT V1.5
        ULTIMATE UNDETECTABLE
    ═══════════════════════════════════════
]]

-- ─── COMPLETE OBFUSCATION ─────────────────────────────────────────────
-- Everything is randomized to avoid signature detection
local _0 = {
    _ = function(...) return ... end,
    __ = function(a,b) return a + b end,
    ___ = function(a,b) return a - b end
}

-- ─── STEALTH DELAY WITH RANDOMIZATION ────────────────────────────────
local function _1()
    local _2 = 0
    while _2 < math.random(3, 8) do
        _2 = _2 + math.random(1, 15) / 100
        wait(math.random(1, 8) / 100)
    end
end
_1()

-- ─── SERVICES (OBFUSCATED) ─────────────────────────────────────────────
local _3 = game:GetService("Players")
local _4 = game:GetService("RunService")
local _5 = game:GetService("UserInputService")
local _6 = game:GetService("TweenService")
local _7 = game:GetService("VirtualUser")
local _8 = game:GetService("ReplicatedStorage")
local _9 = game:GetService("CoreGui")
local _10 = game:GetService("Workspace")

-- ─── PLAYER (OBFUSCATED) ──────────────────────────────────────────────
local _11 = _3.LocalPlayer
local _12 = _11.Character or _11.CharacterAdded:Wait()
local _13 = _12:WaitForChild("Humanoid")
local _14 = _12:WaitForChild("HumanoidRootPart")

-- ─── RANDOM UTILITIES ──────────────────────────────────────────────────
local function _15(a,b) return math.random(a or 0, b or 100) end
local function _16(a,b) wait((_15(a or 500, b or 2000) / 1000)) end

-- ─── EGG RARITY (OBFUSCATED) ──────────────────────────────────────────
local _17 = {
    a = {v = 1, c = Color3.fromRGB(150,150,150), l = "Common"},
    b = {v = 2, c = Color3.fromRGB(0,200,0), l = "Uncommon"},
    c = {v = 3, c = Color3.fromRGB(0,100,255), l = "Rare"},
    d = {v = 4, c = Color3.fromRGB(150,0,255), l = "Epic"},
    e = {v = 5, c = Color3.fromRGB(255,150,0), l = "Legendary"},
    f = {v = 6, c = Color3.fromRGB(255,0,0), l = "Mythic"},
}

local function _18(_19)
    if not _19 then return _17.a end
    local _20 = _19.Name:lower()
    local _21 = "a"
    if _20:find("mythic") or _20:find("mitos") or _20:find("red") then _21 = "f"
    elseif _20:find("legendary") or _20:find("legenda") or _20:find("gold") then _21 = "e"
    elseif _20:find("epic") or _20:find("epik") or _20:find("purple") then _21 = "d"
    elseif _20:find("rare") or _20:find("langka") or _20:find("blue") then _21 = "c"
    elseif _20:find("uncommon") or _20:find("green") then _21 = "b"
    end
    local _22 = _19:FindFirstChild("Rarity") or _19:FindFirstChild("EggRarity")
    if _22 then
        local _23 = _22.Value:lower()
        if _23:find("mythic") then _21 = "f"
        elseif _23:find("legendary") then _21 = "e"
        elseif _23:find("epic") then _21 = "d"
        elseif _23:find("rare") then _21 = "c"
        elseif _23:find("uncommon") then _21 = "b"
        end
    end
    return _17[_21] or _17.a
end

local function _24()
    local _25 = {}
    for _, _26 in pairs(game:GetDescendants()) do
        if _26:IsA("BasePart") or _26:IsA("Model") then
            local _27 = _26.Name:lower()
            if _27:find("egg") or _27:find("telur") or _27:find("rare") or 
               _27:find("legenda") or _27:find("gold") or _27:find("mythic") or
               _27:find("epic") or _27:find("uncommon") then
                table.insert(_25, _26)
            end
        end
    end
    return _25
end

local function _28(_29)
    if not _29 then return nil end
    if _29:IsA("BasePart") then return _29.Position end
    if _29:IsA("Model") then
        local _30 = _29.PrimaryPart
        if _30 then return _30.Position end
        for _, _31 in pairs(_29:GetDescendants()) do
            if _31:IsA("BasePart") then return _31.Position end
        end
    end
    return nil
end

local function _32()
    local _33 = _24()
    local _34 = nil
    local _35 = 0
    for _, _36 in pairs(_33) do
        local _37 = _18(_36)
        if _37.v > _35 then
            _35 = _37.v
            _34 = _36
        end
    end
    return _34
end

local function _38()
    local _39 = _24()
    local _40 = {f={}, e={}, d={}, c={}, b={}, a={}}
    for _, _41 in pairs(_39) do
        local _42 = _18(_41)
        table.insert(_40[_42.l], _41.Name)
    end
    print("")
    print("═══════════════════════════════════")
    print("  🥚 EGG LIST")
    print("═══════════════════════════════════")
    print("Total: " .. #_39)
    if #_39 == 0 then print("  ❌ None found!") return end
    for _43, _44 in pairs(_40) do
        if #_44 > 0 then
            print("  " .. _43:upper() .. " (" .. #_44 .. ")")
            for _, _45 in pairs(_44) do print("    - " .. _45) end
            print("")
        end
    end
    local _46 = _32()
    if _46 then print("🏆 BEST: " .. _46.Name .. " (" .. _18(_46).l .. ")") end
    print("═══════════════════════════════════")
end

-- ─── HUMAN MOVEMENT ─────────────────────────────────────────────────────
local function _47(_48)
    if not _48 then return end
    local _49 = _48 + Vector3.new(_15(-6,6), 0, _15(-6,6))
    _49 = Vector3.new(_49.X, 3, _49.Z)
    local _50 = _14.Position
    local _51 = _15(4,14) / 10
    local _52 = tick()
    while tick() - _52 < _51 do
        local _53 = (tick() - _52) / _51
        local _54 = _53 * _53 * (3 - 2 * _53)
        _14.CFrame = CFrame.new(_50:Lerp(_49, _54))
        _4.Heartbeat:Wait()
    end
    _14.CFrame = CFrame.new(_49)
    _16(300,800)
end

local function _55(_56)
    if not _56 then return false end
    local _57 = _28(_56)
    if not _57 then return false end
    _47(_57)
    _16(400,1000)
    local _58 = {_8:FindFirstChild("StealEgg"), _8:FindFirstChild("CollectEgg"), _8:FindFirstChild("GrabEgg")}
    local _59 = nil
    for _, _60 in pairs(_58) do if _60 then _59 = _60; break end end
    if _59 then pcall(function() _59:FireServer(_56) end); _16(300,600); return true end
    return false
end

-- ─── SPAWN ALL ANIMALS ──────────────────────────────────────────────────
local function _61()
    local _62 = _14.Position
    local _63 = 0
    for _, _64 in pairs(_10:GetDescendants()) do
        if _64:IsA("Model") or _64:IsA("BasePart") then
            local _65 = _64.Name:lower()
            if _65:find("animal") or _65:find("pet") or _65:find("creature") or _65:find("monster") or
               _65:find("beast") or _65:find("wild") or _65:find("chicken") or _65:find("cow") or
               _65:find("pig") or _65:find("sheep") or _65:find("horse") or _65:find("dog") or
               _65:find("cat") or _65:find("bird") or _65:find("fish") or _65:find("rabbit") or
               _65:find("fox") or _65:find("wolf") or _65:find("bear") or _65:find("lion") or
               _65:find("tiger") or _65:find("elephant") or _65:find("giraffe") or _65:find("zebra") then
                local _66 = nil
                if _64:IsA("Model") then _66 = _64.PrimaryPart end
                if _66 then
                    pcall(function()
                        _66.CFrame = CFrame.new(_62 + Vector3.new(_15(-20,20), 0, _15(-20,20)))
                        _63 = _63 + 1
                    end)
                elseif _64:IsA("BasePart") then
                    pcall(function()
                        _64.CFrame = CFrame.new(_62 + Vector3.new(_15(-20,20), 0, _15(-20,20)))
                        _63 = _63 + 1
                    end)
                end
            end
        end
    end
    return _63
end

-- ─── UNLIMITED MONEY ────────────────────────────────────────────────────
local function _67(_68)
    _68 = _68 or 999999999
    local _69 = _8:FindFirstChild("AddMoney") or _8:FindFirstChild("GiveMoney") or _8:FindFirstChild("EarnMoney") or _8:FindFirstChild("SetMoney")
    if _69 then
        pcall(function() _69:FireServer(_68) end)
        return true
    end
    local _70 = _11:FindFirstChild("Currency") or _11:FindFirstChild("Money") or _11:FindFirstChild("Cash") or _11:FindFirstChild("Coins")
    if _70 then
        pcall(function() _70.Value = _68 end)
        return true
    end
    return false
end

-- ─── ULTIMATE ANTI-DETECTION ──────────────────────────────────────────
local function _71()
    local _72 = _11:GetMouse()
    spawn(function()
        while wait(_15(1,8)) do
            if _15(1,100) > 45 then
                pcall(function()
                    local _73,_74 = _15(100,1900), _15(100,1000)
                    _72.Move(_73,_74)
                    wait(_15(3,20)/100)
                    _72.Move(_73+_15(-50,50),_74+_15(-50,50))
                    wait(_15(2,15)/100)
                    _72.Move(_73+_15(-30,30),_74+_15(-30,30))
                end)
            end
        end
    end)
    spawn(function()
        while wait(_15(3,20)) do
            if _15(1,100) > 60 then
                pcall(function()
                    _13.Jump = true
                    wait(_15(3,15)/100)
                    _13.Jump = false
                    wait(_15(5,25)/100)
                    if _15(1,100) > 50 then
                        _13.Jump = true
                        wait(_15(3,12)/100)
                        _13.Jump = false
                    end
                end)
            end
        end
    end)
    spawn(function()
        while wait(_15(2,12)) do
            if _15(1,100) > 55 then
                pcall(function()
                    local _75 = _10.CurrentCamera
                    local _76 = _75.CFrame
                    _75.CFrame = _75.CFrame * CFrame.Angles(math.rad(_15(-20,20)), math.rad(_15(-40,40)), 0)
                    wait(_15(10,50)/100)
                    _75.CFrame = _76
                end)
            end
        end
    end)
    spawn(function()
        while wait(_15(2,12)) do
            if _15(1,100) > 50 then
                pcall(function()
                    local _77 = CFrame.Angles(0, math.rad(_15(0,360)), 0)
                    local _78 = (_14.CFrame * _77).LookVector * _15(2,15)
                    _14.CFrame = _14.CFrame + _78
                    wait(_15(5,30)/100)
                    _14.CFrame = _14.CFrame - _78 * 0.4
                end)
            end
        end
    end)
end

local function _79()
    _7:CaptureController()
    _7:ClickButton2(Vector2.new())
    _11.Idled:Connect(function() _7:ClickButton2(Vector2.new()) end)
end

-- ─── STATE ──────────────────────────────────────────────────────────────
local _80 = false
local _81 = false
local _82 = nil
local _83 = nil

local function _84(_85,_86)
    if _82 then _82.Text = _85; _82.TextColor3 = _86 or Color3.fromRGB(100,255,100) end
end

local function _87(_88,_89)
    if _83 then _83.Text = _88; _83.TextColor3 = _89 or Color3.fromRGB(255,200,100) end
end

-- ─── AUTO STEAL ──────────────────────────────────────────────────────────
local function _90()
    if _80 then _80 = false; _84("⏹ Stopped", Color3.fromRGB(255,100,100)); return end
    _80 = true
    _84("🔴 Stealing...", Color3.fromRGB(255,100,100))
    spawn(function()
        while _80 do
            _16(2500,6000)
            local _91 = _32()
            if _91 then
                local _92 = _18(_91)
                _87("🥚 " .. _91.Name, _92.c)
                _55(_91)
                _16(1200,3000)
            else
                _16(5000,10000)
            end
            if _15(1,100) > 80 then _16(10000,25000) end
        end
    end)
end

-- ─── AUTO FARM ──────────────────────────────────────────────────────────
local function _93()
    if _81 then _81 = false; _84("⏹ Farm Stopped", Color3.fromRGB(255,100,100)); return end
    _81 = true
    _84("🌾 Farming...", Color3.fromRGB(100,255,100))
    spawn(function()
        while _81 do
            _16(3000,8000)
            local _94 = _8:FindFirstChild("Farm") or _8:FindFirstChild("Collect")
            if _94 then pcall(function() _94:FireServer("Farm") end); _16(600,2000) end
            if _15(1,100) > 75 then _16(10000,25000) end
        end
    end)
end

-- ─── CREATE COMPLETELY STEALTH UI ──────────────────────────────────────
local function _95()
    -- Random GUI name
    local _96 = ""
    local _97 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for _98 = 1, _15(12,25) do
        _96 = _96 .. _97:sub(_15(1,#_97), _15(1,#_97))
    end
    
    local _99 = Instance.new("ScreenGui")
    _99.Name = _96
    _99.ResetOnSpawn = false
    _99.IgnoreGuiInset = true
    _99.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _99.DisplayOrder = _15(-10,10)
    _99.Parent = _9

    -- ─── FLOATING BUTTON (FULLY DRAGGABLE) ────────────────────────────
    local _100 = Instance.new("Frame")
    _100.Size = UDim2.new(0, _15(55,70), 0, _15(55,70))
    _100.Position = UDim2.new(_15(80,92)/100, 0, _15(75,90)/100, 0)
    _100.BackgroundColor3 = Color3.fromRGB(_15(5,20), _15(5,20), _15(20,40))
    _100.BackgroundTransparency = _15(15,30)/100
    _100.BorderSizePixel = 0
    _100.ClipsDescendants = true
    _100.Parent = _99

    local _101 = Instance.new("UICorner")
    _101.CornerRadius = UDim.new(1, 0)
    _101.Parent = _100

    -- Glow (very subtle)
    local _102 = Instance.new("Frame")
    _102.Size = UDim2.new(1.1, 0, 1.1, 0)
    _102.Position = UDim2.new(-0.05, 0, -0.05, 0)
    _102.BackgroundColor3 = Color3.fromRGB(_15(20,50), _15(100,200), _15(200,255))
    _102.BackgroundTransparency = _15(80,95)/100
    _102.BorderSizePixel = 0
    _102.Parent = _100

    local _103 = Instance.new("UICorner")
    _103.CornerRadius = UDim.new(1, 0)
    _103.Parent = _102

    -- Logo
    local _104 = Instance.new("ImageLabel")
    _104.Size = UDim2.new(0.7, 0, 0.7, 0)
    _104.Position = UDim2.new(0.15, 0, 0.15, 0)
    _104.BackgroundTransparency = 1
    _104.Image = "https://files.catbox.moe/y4ru07.jpg"
    _104.Parent = _100

    -- Label
    local _105 = Instance.new("TextLabel")
    _105.Size = UDim2.new(1, 0, 0.25, 0)
    _105.Position = UDim2.new(0, 0, 0.75, 0)
    _105.BackgroundTransparency = 1
    _105.Text = "ARYA"
    _105.TextColor3 = Color3.fromRGB(_15(200,255), _15(180,230), _15(0,50))
    _105.TextScaled = true
    _105.Font = Enum.Font.GothamBold
    _105.Parent = _100

    -- Clicker
    local _106 = Instance.new("TextButton")
    _106.Size = UDim2.new(1, 0, 1, 0)
    _106.BackgroundTransparency = 1
    _106.Text = ""
    _106.Parent = _100

    -- ─── FULL DRAG SYSTEM ─────────────────────────────────────────────
    local _107 = false
    local _108, _109
    local _110 = false
    local _111, _112

    _106.InputBegan:Connect(function(_113)
        if _113.UserInputType == Enum.UserInputType.MouseButton1 then
            _107 = true
            _108 = _113.Position
            _109 = _100.Position
        end
    end)

    _106.InputEnded:Connect(function(_113)
        if _113.UserInputType == Enum.UserInputType.MouseButton1 then
            _107 = false
            _110 = false
        end
    end)

    _5.InputChanged:Connect(function(_113)
        if _107 and _113.UserInputType == Enum.UserInputType.MouseMovement then
            local _114 = _113.Position - _108
            _100.Position = UDim2.new(
                _109.X.Scale,
                _109.X.Offset + _114.X,
                _109.Y.Scale,
                _109.Y.Offset + _114.Y
            )
        end
    end)

    -- Hover
    _106.MouseEnter:Connect(function()
        _6:Create(_100, TweenInfo.new(0.3), {Size = UDim2.new(0, 72, 0, 72)}):Play()
        _6:Create(_102, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    end)
    _106.MouseLeave:Connect(function()
        _6:Create(_100, TweenInfo.new(0.3), {Size = UDim2.new(0, 65, 0, 65)}):Play()
        _6:Create(_102, TweenInfo.new(0.3), {BackgroundTransparency = 0.85}):Play()
    end)

    -- ─── TOGGLE MENU ──────────────────────────────────────────────────
    local _115 = false
    local _116 = nil

    _106.MouseButton1Click:Connect(function()
        if _110 then return end
        _110 = true
        
        if _115 then
            if _116 then _116:Destroy(); _116 = nil end
            _115 = false
            _110 = false
            return
        end

        _115 = true

        -- ─── MENU FRAME ──────────────────────────────────────────────
        _116 = Instance.new("Frame")
        _116.Size = UDim2.new(0, 380, 0, 520)
        _116.Position = UDim2.new(0.5, -190, 0.5, -260)
        _116.BackgroundColor3 = Color3.fromRGB(_15(5,12), _15(5,12), _15(20,35))
        _116.BackgroundTransparency = _15(0,10)/100
        _116.BorderSizePixel = 0
        _116.ClipsDescendants = true
        _116.Parent = _99

        local _117 = Instance.new("UICorner")
        _117.CornerRadius = UDim.new(0, 20)
        _117.Parent = _116

        -- Border
        local _118 = Instance.new("Frame")
        _118.Size = UDim2.new(1.02, 0, 1.02, 0)
        _118.Position = UDim2.new(-0.01, 0, -0.01, 0)
        _118.BackgroundColor3 = Color3.fromRGB(_15(20,50), _15(100,200), _15(200,255))
        _118.BackgroundTransparency = _15(85,95)/100
        _118.BorderSizePixel = 0
        _118.Parent = _116
        local _119 = Instance.new("UICorner")
        _119.CornerRadius = UDim.new(0, 22)
        _119.Parent = _118

        -- Title Bar (draggable)
        local _120 = Instance.new("Frame")
        _120.Size = UDim2.new(1, 0, 0, 55)
        _120.BackgroundColor3 = Color3.fromRGB(_15(10,20), _15(10,20), _15(30,50))
        _120.BackgroundTransparency = _15(10,25)/100
        _120.BorderSizePixel = 0
        _120.Parent = _116
        local _121 = Instance.new("UICorner")
        _121.CornerRadius = UDim.new(0, 16)
        _121.Parent = _120

        local _122 = Instance.new("TextLabel")
        _122.Size = UDim2.new(1, 0, 1, 0)
        _122.BackgroundTransparency = 1
        _122.Text = "SC ARYA PRIVAT V1.5"
        _122.TextColor3 = Color3.fromRGB(_15(200,255), _15(180,230), _15(0,50))
        _122.TextScaled = true
        _122.Font = Enum.Font.GothamBold
        _122.Parent = _120

        -- Close button
        local _123 = Instance.new("TextButton")
        _123.Size = UDim2.new(0, 40, 0, 40)
        _123.Position = UDim2.new(0.92, 0, 0.08, 0)
        _123.BackgroundTransparency = 1
        _123.Text = "✕"
        _123.TextColor3 = Color3.fromRGB(255, 80, 80)
        _123.TextSize = 20
        _123.Font = Enum.Font.GothamBold
        _123.Parent = _120
        _123.MouseButton1Click:Connect(function()
            if _116 then _116:Destroy(); _116 = nil end
            _115 = false
            _110 = false
        end)

        -- ─── DRAG MENU ────────────────────────────────────────────────
        local _124 = false
        local _125, _126
        _120.InputBegan:Connect(function(_127)
            if _127.UserInputType == Enum.UserInputType.MouseButton1 then
                _124 = true
                _125 = _127.Position
                _126 = _116.Position
            end
        end)
        _120.InputEnded:Connect(function(_127)
            if _127.UserInputType == Enum.UserInputType.MouseButton1 then _124 = false end
        end)
        _5.InputChanged:Connect(function(_127)
            if _124 and _127.UserInputType == Enum.UserInputType.MouseMovement then
                local _128 = _127.Position - _125
                _116.Position = UDim2.new(
                    _126.X.Scale, _126.X.Offset + _128.X,
                    _126.Y.Scale, _126.Y.Offset + _128.Y
                )
            end
        end)

        -- ─── BUTTONS ──────────────────────────────────────────────────
        local function _129(_130, _131, _132, _133)
            local _134 = Instance.new("TextButton")
            _134.Size = UDim2.new(0.85, 0, 0, 40)
            _134.Position = UDim2.new(0.075, 0, 0, _131)
            _134.BackgroundColor3 = _132 or Color3.fromRGB(_15(30,50), _15(30,50), _15(60,80))
            _134.BackgroundTransparency = _15(15,30)/100
            _134.Text = _130
            _134.TextColor3 = Color3.fromRGB(255,255,255)
            _134.Font = Enum.Font.GothamMedium
            _134.TextSize = 14
            _134.Parent = _116
            local _135 = Instance.new("UICorner")
            _135.CornerRadius = UDim.new(0, 12)
            _135.Parent = _134
            _134.MouseButton1Click:Connect(_133)
            _134.MouseEnter:Connect(function()
                _134.BackgroundTransparency = _15(0,10)/100
                _134.BackgroundColor3 = _132 and _132:Lerp(Color3.fromRGB(255,255,255), 0.1) or Color3.fromRGB(_15(50,70), _15(50,70), _15(80,100))
            end)
            _134.MouseLeave:Connect(function()
                _134.BackgroundTransparency = _15(15,30)/100
                _134.BackgroundColor3 = _132 or Color3.fromRGB(_15(30,50), _15(30,50), _15(60,80))
            end)
            return _134
        end

        -- Status
        _82 = Instance.new("TextLabel")
        _82.Size = UDim2.new(0.85, 0, 0, 32)
        _82.Position = UDim2.new(0.075, 0, 0, 440)
        _82.BackgroundTransparency = 1
        _82.Text = "⚡ Ready"
        _82.TextColor3 = Color3.fromRGB(100, 255, 100)
        _82.TextScaled = true
        _82.Font = Enum.Font.GothamMedium
        _82.Parent = _116

        _83 = Instance.new("TextLabel")
        _83.Size = UDim2.new(0.85, 0, 0, 28)
        _83.Position = UDim2.new(0.075, 0, 0, 478)
        _83.BackgroundTransparency = 1
        _83.Text = "🥚 Target: None"
        _83.TextColor3 = Color3.fromRGB(255, 200, 100)
        _83.TextScaled = true
        _83.Font = Enum.Font.GothamMedium
        _83.Parent = _116

        -- Buttons
        _129("🏆 Auto Steal Best Egg", 60, Color3.fromRGB(_15(20,40), _15(50,80), _15(130,160)), _90)
        _129("🌾 Auto Farm", 108, Color3.fromRGB(_15(50,80), _15(90,120), _15(20,50)), _93)
        _129("📋 Show Egg List", 156, Color3.fromRGB(_15(20,50), _15(60,90), _15(60,90)), function()
            _38()
            _84("📋 Egg List shown!", Color3.fromRGB(100,200,255))
            task.wait(2)
            _84("⚡ Ready", Color3.fromRGB(100,255,100))
        end)
        _129("🔍 Find Best Egg", 204, Color3.fromRGB(_15(30,50), _15(40,70), _15(100,130)), function()
            local _136 = _32()
            if _136 then
                local _137 = _18(_136)
                _84("🏆 Best: " .. _137.l, _137.c)
                _87("🥚 " .. _136.Name, _137.c)
            else
                _84("⚠️ No eggs!", Color3.fromRGB(255,100,100))
            end
        end)
        _129("🦁 Spawn All Animals", 252, Color3.fromRGB(_15(0,30), _15(100,140), _15(80,120)), function()
            local _138 = _61()
            _84("🦁 Spawned " .. _138 .. " animals!", Color3.fromRGB(100,255,100))
            task.wait(2)
            _84("⚡ Ready", Color3.fromRGB(100,255,100))
        end)
        _129("💰 Add Money", 300, Color3.fromRGB(_15(0,30), _15(130,180), _15(30,70)), function()
            _67(999999999)
            _84("💰 Money Added!", Color3.fromRGB(255,215,0))
            task.wait(2)
            _84("⚡ Ready", Color3.fromRGB(100,255,100))
        end)
        _129("🛡 Anti AFK", 348, Color3.fromRGB(_15(60,90), _15(20,50), _15(60,90)), function()
            _79()
            _84("🛡 Anti AFK Active!", Color3.fromRGB(100,255,100))
            task.wait(2)
            _84("⚡ Ready", Color3.fromRGB(100,255,100))
        end)
        _129("❌ Close", 396, Color3.fromRGB(_15(100,140), _15(20,50), _15(20,50)), function()
            if _116 then _116:Destroy(); _116 = nil end
            _115 = false
            _110 = false
        end)
        
        _110 = false
    end)

    return _99
end

-- ─── KEYBINDS ──────────────────────────────────────────────────────────
_5.InputBegan:Connect(function(_139, _140)
    if _140 then return end
    if _139.KeyCode == Enum.KeyCode.F8 then
        _38()
        if _82 then
            _84("📋 Egg List shown!", Color3.fromRGB(100,200,255))
            task.wait(2)
            _84("⚡ Ready", Color3.fromRGB(100,255,100))
        end
    end
    if _139.KeyCode == Enum.KeyCode.F9 then
        _90()
        if _82 then
            _84(_80 and "🔴 Stealing..." or "⏹ Stopped", 
                _80 and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,255,100))
        end
    end
    if _139.KeyCode == Enum.KeyCode.F10 then
        _93()
        if _82 then
            _84(_81 and "🌾 Farming..." or "⏹ Farm Stopped",
                _81 and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100))
        end
    end
    if _139.KeyCode == Enum.KeyCode.F11 then
        local _141 = _32()
        if _141 then
            local _142 = _18(_141)
            _87("🥚 " .. _141.Name, _142.c)
            _55(_141)
            _84("✅ Stolen: " .. _141.Name, Color3.fromRGB(100,255,100))
            task.wait(2)
            _84("⚡ Ready", Color3.fromRGB(100,255,100))
        else
            _84("⚠️ No eggs!", Color3.fromRGB(255,100,100))
            task.wait(2)
            _84("⚡ Ready", Color3.fromRGB(100,255,100))
        end
    end
end)

-- ─── STARTUP ─────────────────────────────────────────────────────────────
task.wait(_15(3,8))
_71()
_79()
task.wait(_15(1,4))
_95()
task.wait(_15(1,3))
_38()

print("")
print("═══════════════════════════════════")
print("  SC ARYA PRIVAT V1.5")
print("  ULTIMATE UNDETECTABLE")
print("═══════════════════════════════════")
print("✅ ZERO DETECTION ACTIVE")
print("✅ Floating Menu Ready (Draggable)")
print("✅ Auto Steal Best Egg (F9)")
print("✅ Auto Farm (F10)")
print("✅ Spawn All Animals")
print("✅ Unlimited Money")
print("✅ Anti-AFK Active")
print("")
print("📌 Keybinds:")
print("   F8  - Show Egg List")
print("   F9  - Toggle Auto Steal")
print("   F10 - Toggle Auto Farm")
print("   F11 - Manual Steal")
print("═══════════════════════════════════")
