--!nonstrict
--[[
	=====================================================
	  RBX IMPORTER PLUGIN v1.1 (FIXED)
	  Import .rbxm/.rbxmx/.rbxl/.rbxlx from local folder
	=====================================================
	
	INSTALL:
	  1. Save as "ImportRBX.lua" in Roblox plugins folder
	  2. Restart Studio
	  3. Toolbar "RBX Importer" akan muncul
	
	CHANGELOG v1.1:
	  - FIX: StudioService error → pake plugin:PromptImportFile()
	  - FIX: Toolbar error handling
	  - ADD: Fallback kalau service gak available
]]

local Selection         = game:GetService("Selection")
local ChangeHistory     = game:GetService("ChangeHistoryService")
local InsertService     = game:GetService("InsertService")

--==================================================
-- SAFE SERVICE ACCESS
--==================================================

-- StudioService might not exist in older Studio versions
local StudioService = nil
pcall(function()
    StudioService = game:GetService("StudioService")
end)

--==================================================
-- TOOLBAR (SAFE)
--==================================================

local toolbar = nil
local importBtn = nil
local importToSelBtn = nil
local aboutBtn = nil

local ok, err = pcall(function()
    toolbar = plugin:CreateToolbar("RBX Importer")
    
    importBtn = toolbar:CreateButton(
        "📁 Import",
        "Import .rbxm/.rbxmx/.rbxl/.rbxlx from local folder",
        "rbxassetid://6031075931"
    )
    
    importToSelBtn = toolbar:CreateButton(
        "📌 Import to Selected",
        "Import into currently selected instance",
        "rbxassetid://6031091004"
    )
    
    aboutBtn = toolbar:CreateButton(
        "ℹ️ Info",
        "Show plugin info",
        "rbxassetid://6031075929"
    )
end)

if not ok then
    warn("[RBX Importer] Toolbar creation failed: " .. tostring(err))
    warn("[RBX Importer] Make sure this file is in the Studio Plugins folder.")
    return
end

--==================================================
-- CONFIG
--==================================================

local SUPPORTED_MODEL = { rbxm = true, rbxmx = true }
local SUPPORTED_PLACE = { rbxl = true, rbxlx = true }

--==================================================
-- UTIL
--==================================================

local function log(msg: string)
    print("[RBX Importer] " .. msg)
end

local function warnLog(msg: string)
    warn("[RBX Importer] " .. msg)
end

local function getExt(name: string): string
    return (name:match("%.([^%.]+)$") or ""):lower()
end

local function getParent(): Instance
    local sel = Selection:Get()
    if #sel > 0 and typeof(sel[1]) == "Instance" then
        return sel[1]
    end
    return game.Workspace
end

local function notify(title: string, text: string)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3,
        })
    end)
end

--==================================================
-- FILE PICKER (UNIVERSAL)
--==================================================
-- Try plugin:PromptImportFile first, fallback to StudioService

local function pickFiles(): {Instance}
    -- Method 1: plugin:PromptImportFile (modern API)
    local ok1, result1 = pcall(function()
        return plugin:PromptImportFile({})
    end)
    
    if ok1 and result1 then
        return result1
    end
    
    -- Method 2: StudioService:PromptImportFile (legacy)
    if StudioService then
        local ok2, result2 = pcall(function()
            return StudioService:PromptImportFile({})
        end)
        
        if ok2 and result2 then
            return result2
        end
    end
    
    -- Both failed
    warnLog("PromptImportFile gak available di Studio ini")
    return {}
end

--==================================================
-- MODEL IMPORT (.rbxm / .rbxmx)
--==================================================

local function importModelFile(file: Instance, parent: Instance): (boolean, Instance?)
    local tempId: string? = nil
    
    local ok1, err1 = pcall(function()
        tempId = file:GetTemporaryId()
    end)
    
    if not ok1 or not tempId then
        warnLog("Gagal dapetin temp id: " .. tostring(err1))
        return false, nil
    end
    
    local ok2, modelOrErr = pcall(function()
        return InsertService:LoadLocalAsset(tempId)
    end)
    
    if not ok2 or not modelOrErr then
        warnLog("LoadLocalAsset gagal: " .. tostring(modelOrErr))
        return false, nil
    end
    
    local ok3, err3 = pcall(function()
        modelOrErr.Parent = parent
    end)
    
    if not ok3 then
        warnLog("Parent gagal: " .. tostring(err3))
        return false, nil
    end
    
    return true, modelOrErr
end

--==================================================
-- PLACE IMPORT (.rbxl / .rbxlx)
--==================================================

local function importPlaceFile(file: Instance): boolean
    local ok, err = pcall(function()
        local tempId = file:GetTemporaryId()
        log("Place file picked: " .. file.Name .. " (tempId=" .. tostring(tempId) .. ")")
    end)
    
    if not ok then
        warnLog("Place file handling gagal: " .. tostring(err))
        return false
    end
    
    notify(
        "Place Detected",
        "Place file " .. file.Name .. " terdeteksi. Buka manual via File → Open."
    )
    
    return true
end

--==================================================
-- MAIN IMPORT HANDLER
--==================================================

local function runImport()
    log("=== Import started ===")
    
    local files = pickFiles()
    
    if #files == 0 then
        log("User cancel atau gak ada file dipilih")
        return
    end
    
    log("User pilih " .. #files .. " files")
    
    local parent = getParent()
    log("Target parent: " .. parent:GetFullName())
    
    ChangeHistory:SetWaypoint("Before RBX Import")
    
    local modelCount = 0
    local placeCount = 0
    local failCount = 0
    
    for _, file in ipairs(files) do
        local name = file.Name
        local ext = getExt(name)
        
        log("Processing: " .. name .. " (" .. ext .. ")")
        
        if SUPPORTED_MODEL[ext] then
            local success, instance = importModelFile(file, parent)
            if success and instance then
                modelCount = modelCount + 1
                log("  ✅ Imported model: " .. instance.Name)
            else
                failCount = failCount + 1
                warnLog("  ❌ Gagal import model: " .. name)
            end
            
        elseif SUPPORTED_PLACE[ext] then
            local success = importPlaceFile(file)
            if success then
                placeCount = placeCount + 1
                log("  ✅ Place file handled: " .. name)
            else
                failCount = failCount + 1
                warnLog("  ❌ Gagal handle place: " .. name)
            end
            
        else
            if ext == "lua" or ext == "txt" then
                local okScript, scriptObj = pcall(function()
                    local tempId = file:GetTemporaryId()
                    return InsertService:LoadLocalAsset(tempId)
                end)
                
                if okScript and scriptObj then
                    scriptObj.Parent = parent
                    modelCount = modelCount + 1
                    log("  ✅ Imported script: " .. scriptObj.Name)
                else
                    failCount = failCount + 1
                    warnLog("  ❌ Gagal import script: " .. name)
                end
            else
                warnLog("  ⏭ Skip (unsupported): " .. name)
            end
        end
    end
    
    ChangeHistory:SetWaypoint("After RBX Import")
    
    log("=== Import finished ===")
    log("Models: " .. modelCount)
    log("Places: " .. placeCount)
    log("Failed: " .. failCount)
    
    notify(
        "RBX Import Done",
        string.format(
            "Models: %d | Places: %d | Failed: %d",
            modelCount, placeCount, failCount
        )
    )
end

--==================================================
-- BUTTON HANDLERS
--==================================================

importBtn.Click:Connect(function()
    runImport()
end)

importToSelBtn.Click:Connect(function()
    local sel = Selection:Get()
    if #sel == 0 then
        notify("No Selection", "Pilih instance dulu di Explorer")
        return
    end
    runImport()
end)

aboutBtn.Click:Connect(function()
    local msg = table.concat({
        "RBX Importer v1.1\n",
        "Import .rbxm/.rbxmx/.rbxl/.rbxlx",
        "dari folder lokal ke Studio.\n",
        "How to use:",
        "1. Pilih target di Explorer (optional)",
        "2. Klik tombol Import di toolbar",
        "3. Pilih files dari file dialog",
        "4. Done"
    }, "\n")
    
    notify("RBX Importer", "Check Output console")
    log(msg)
end)

--==================================================
-- STARTUP
--==================================================

log("======================================")
log("  RBX IMPORTER v1.1 loaded")
log("  Tombol tersedia di toolbar Studio")
log("======================================")
