--!nonstrict
--[[
	=====================================================
	  RBX IMPORTER PLUGIN v1.2 (FINAL)
	  Import .rbxm/.rbxmx/.rbxl/.rbxlx from local folder
	=====================================================

	INSTALL:
	  1. Save as "ImportRBX.lua" in Studio Plugins folder
	  2. Restart Studio
	  3. Toolbar "RBX Importer" akan muncul

	PLUGINS FOLDER:
	  Windows: %LOCALAPPDATA%\Roblox\Plugins\
	  Mac:     ~/Documents/Roblox/Plugins/
]]

--==================================================
-- GUARD: PASTIKAN DIJALANIN SEBAGAI PLUGIN
--==================================================
-- Kalau lu jalanin di Command Bar / executor / loadstring,
-- `plugin` bakal nil. Kita stop di sini biar gak crash.

if not plugin then
	warn("[RBX Importer] =================================")
	warn("[RBX Importer] ERROR: 'plugin' is nil!")
	warn("[RBX Importer] Script ini HARUS di-install sebagai")
	warn("[RBX Importer] plugin Studio. Gak bisa pake loadstring.")
	warn("[RBX Importer] =================================")
	return
end

--==================================================
-- SERVICES
--==================================================

local Selection     = game:GetService("Selection")
local ChangeHistory = game:GetService("ChangeHistoryService")
local InsertService = game:GetService("InsertService")

--==================================================
-- TOOLBAR
--==================================================

local toolbar = plugin:CreateToolbar("RBX Importer")

local importBtn = toolbar:CreateButton(
	"📁 Import",
	"Import .rbxm/.rbxmx/.rbxl/.rbxlx from local folder",
	"rbxassetid://6031075931"
)

local importToSelBtn = toolbar:CreateButton(
	"📌 Import to Selected",
	"Import into currently selected instance",
	"rbxassetid://6031091004"
)

local aboutBtn = toolbar:CreateButton(
	"ℹ️ Info",
	"Show plugin info",
	"rbxassetid://6031075929"
)

--==================================================
-- CONFIG
--==================================================

local SUPPORTED_MODEL = { rbxm = true, rbxmx = true }
local SUPPORTED_PLACE = { rbxl = true, rbxlx = true }

--==================================================
-- UTIL
--==================================================

local function log(msg)
	print("[RBX Importer] " .. tostring(msg))
end

local function warnLog(msg)
	warn("[RBX Importer] " .. tostring(msg))
end

local function getExt(name)
	return (name:match("%.([^%.]+)$") or ""):lower()
end

local function getParent()
	local sel = Selection:Get()
	if #sel > 0 and typeof(sel[1]) == "Instance" then
		return sel[1]
	end
	return game.Workspace
end

local function notify(title, text)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 3,
		})
	end)
end

--==================================================
-- FILE PICKER
--==================================================

local function pickFiles()
	local ok, result = pcall(function()
		return plugin:PromptImportFile({})
	end)
	
	if not ok then
		warnLog("PromptImportFile gagal: " .. tostring(result))
		return {}
	end
	
	if not result then
		return {}
	end
	
	return result
end

--==================================================
-- MODEL IMPORT
--==================================================

local function importModelFile(file, parent)
	local tempId = nil
	
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
-- PLACE IMPORT
--==================================================

local function importPlaceFile(file)
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
-- MAIN IMPORT
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
				log("  OK Imported model: " .. instance.Name)
			else
				failCount = failCount + 1
				warnLog("  FAIL Gagal import model: " .. name)
			end
			
		elseif SUPPORTED_PLACE[ext] then
			local success = importPlaceFile(file)
			if success then
				placeCount = placeCount + 1
				log("  OK Place file handled: " .. name)
			else
				failCount = failCount + 1
				warnLog("  FAIL Gagal handle place: " .. name)
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
					log("  OK Imported script: " .. scriptObj.Name)
				else
					failCount = failCount + 1
					warnLog("  FAIL Gagal import script: " .. name)
				end
			else
				warnLog("  SKIP Unsupported: " .. name)
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
	log("======================================")
	log("  RBX IMPORTER v1.2")
	log("  Import .rbxm/.rbxmx/.rbxl/.rbxlx")
	log("  dari folder lokal ke Studio.")
	log("======================================")
	log("How to use:")
	log("1. Pilih target di Explorer (optional)")
	log("2. Klik tombol Import di toolbar")
	log("3. Pilih files dari file dialog")
	log("4. Done")
	log("======================================")
	
	notify("RBX Importer", "Check Output console")
end)

--==================================================
-- STARTUP
--==================================================

log("======================================")
log("  RBX IMPORTER v1.2 loaded")
log("  Toolbar siap di atas Studio")
log("======================================")
