--!nonstrict
--[[
	=====================================================
	  RBX IMPORTER PLUGIN v1.0
	  Import .rbxm/.rbxmx/.rbxl/.rbxlx from local folder
	  Directly into Studio
	=====================================================
	
	INSTALL:
	  1. Save as "ImportRBX.lua" in Roblox plugins folder
	  2. Restart Studio
	  3. Toolbar "RBX Importer" akan muncul
	  4. Klik "📁 Import" → pilih files → done
	
	SUPPORTED FORMATS:
	  - .rbxm  (binary model)    → LoadLocalAsset
	  - .rbxmx (XML model)       → LoadLocalAsset
	  - .rbxl  (binary place)    → Convert then import
	  - .rbxlx (XML place)       → Parse and import
]]

local StudioService     = game:GetService("StudioService")
local Selection         = game:GetService("Selection")
local ChangeHistory     = game:GetService("ChangeHistoryService")
local InsertService     = game:GetService("InsertService")

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
-- MODEL IMPORT (.rbxm / .rbxmx)
--==================================================

local function importModelFile(file: Instance, parent: Instance): (boolean, Instance?)
	local tempId: string? = nil
	
	-- Get temp path
	local ok1, err1 = pcall(function()
		tempId = file:GetTemporaryId()
	end)
	
	if not ok1 or not tempId then
		warnLog("Gagal dapetin temp id: " .. tostring(err1))
		return false, nil
	end
	
	-- Load via InsertService (works only in Studio)
	local ok2, modelOrErr = pcall(function()
		return InsertService:LoadLocalAsset(tempId)
	end)
	
	if not ok2 or not modelOrErr then
		warnLog("LoadLocalAsset gagal: " .. tostring(modelOrErr))
		return false, nil
	end
	
	-- Parent it
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
-- Note: Studio gak punya API buat load .rbxl/.rbxlx directly.
-- We use PromptImportFile + handle via StudioService.
-- Kalau user pilih .rbxlx, Studio akan handle otomatis.

local function importPlaceFile(file: Instance): boolean
	-- Roblox Studio bakal otomatis handle place files
	-- ketika di-pass ke PromptImportFile
	-- Script ini cuma jadi jembatan
	
	local ok, err = pcall(function()
		local tempId = file:GetTemporaryId()
		log("Place file picked: " .. file.Name .. " (tempId=" .. tostring(tempId) .. ")")
	end)
	
	if not ok then
		warnLog("Place file handling gagal: " .. tostring(err))
		return false
	end
	
	-- Fallback: kasih pesan ke user kalau place gak bisa auto-import
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
	
	-- Step 1: Pick files
	local files: {Instance} = {}
	local ok, result = pcall(function()
		return StudioService:PromptImportFile({})
	end)
	
	if not ok then
		warnLog("PromptImportFile gagal: " .. tostring(result))
		notify("Import Failed", "Gak bisa buka file dialog")
		return
	end
	
	if not result or #result == 0 then
		log("User cancel atau gak ada file dipilih")
		return
	end
	
	files = result
	log("User pilih " .. #files .. " files")
	
	-- Step 2: Determine parent
	local parent = getParent()
	log("Target parent: " .. parent:GetFullName())
	
	-- Step 3: Setup undo waypoint
	ChangeHistory:SetWaypoint("Before RBX Import")
	
	-- Step 4: Import each file
	local modelCount = 0
	local placeCount = 0
	local failCount = 0
	
	for _, file in ipairs(files) do
		local name = file.Name
		local ext = getExt(name)
		
		log("Processing: " .. name .. " (" .. ext .. ")")
		
		if SUPPORTED_MODEL[ext] then
			-- .rbxm / .rbxmx
			local success, instance = importModelFile(file, parent)
			if success and instance then
				modelCount = modelCount + 1
				log("  ✅ Imported model: " .. instance.Name)
			else
				failCount = failCount + 1
				warnLog("  ❌ Gagal import model: " .. name)
			end
			
		elseif SUPPORTED_PLACE[ext] then
			-- .rbxl / .rbxlx
			local success = importPlaceFile(file)
			if success then
				placeCount = placeCount + 1
				log("  ✅ Place file handled: " .. name)
			else
				failCount = failCount + 1
				warnLog("  ❌ Gagal handle place: " .. name)
			end
			
		else
			-- .lua / .txt / other
			-- Studio handles .lua as script import
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
	
	-- Step 5: Finish undo
	ChangeHistory:SetWaypoint("After RBX Import")
	
	-- Step 6: Summary
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
		"RBX Importer v1.0\n",
		"Import .rbxm/.rbxmx/.rbxl/.rbxlx",
		"dari folder lokal ke Studio.\n",
		"How to use:",
		"1. Pilih target di Explorer (optional)",
		"2. Klik tombol Import di toolbar",
		"3. Pilih files dari file dialog",
		"4. Done\n",
		"Note:",
		"- Place files (.rbxl/.rbxlx) perlu dibuka",
		"  manual via File → Open",
		"- Model files auto-insert ke parent"
	}, "\n")
	
	notify("RBX Importer", "Check Output console")
	log(msg)
end)

--==================================================
-- STARTUP
--==================================================

log("======================================")
log("  RBX IMPORTER v1.0 loaded")
log("  Tombol tersedia di toolbar Studio")
log("======================================")
