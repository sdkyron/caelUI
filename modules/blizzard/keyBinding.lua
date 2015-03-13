--[[	$Id: keyBinding.lua 3941 2014-10-19 19:14:48Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

local _, caelUI = ...

caelUI.keybinding = caelUI.createModule("KeyBinding")

local keybinding = caelUI.keybinding

--[[	World Markers	]]

BINDING_HEADER_WORLDMARKER = "World Markers"

BINDING_NAME_WORLDMARKER0 = "Clear All World Markers"
BINDING_NAME_WORLDMARKER1 = "Blue World Marker"
BINDING_NAME_WORLDMARKER2 = "Green World Marker"
BINDING_NAME_WORLDMARKER3 = "Purple World Marker"
BINDING_NAME_WORLDMARKER4 = "Red World Marker"
BINDING_NAME_WORLDMARKER5 = "Yellow World Marker"

_G["BINDING_NAME_CLICK WORLDMARKER1:LEFTBUTTON"] = "Blue Marker"
_G["BINDING_NAME_CLICK WORLDMARKER2:LEFTBUTTON"] = "Green Marker"
_G["BINDING_NAME_CLICK WORLDMARKER3:LEFTBUTTON"] = "Purple Marker"
_G["BINDING_NAME_CLICK WORLDMARKER4:LEFTBUTTON"] = "Red Marker"
_G["BINDING_NAME_CLICK WORLDMARKER5:LEFTBUTTON"] = "Yellow Marker"
_G["BINDING_NAME_CLICK CLEARWORLDMARKERS:LEFTBUTTON"] = "Clear All Markers"

local CreateButton = function(name, command)
	local button = CreateFrame("Button", name, nil, "SecureActionButtonTemplate")
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext", command)
	button:RegisterForClicks("AnyDown")
end

CreateButton("Clearworldmarkers", "/clearworldmarker all")

CreateButton("worldmarker1", "/clearworldmarker 1\n/worldmarker 1")
CreateButton("worldmarker2", "/clearworldmarker 2\n/worldmarker 2")
CreateButton("worldmarker3", "/clearworldmarker 3\n/worldmarker 3")
CreateButton("worldmarker4", "/clearworldmarker 4\n/worldmarker 4")
CreateButton("worldmarker5", "/clearworldmarker 5\n/worldmarker 5")

--[[	Keybindings	]]

local bindings = {
	["Z"] = "MOVEFORWARD",
	["UP"] = "MOVEFORWARD",
	["S"] = "MOVEBACKWARD",
	["DOWN"] = "MOVEBACKWARD",
	["Q"] = "TURNLEFT",
	["LEFT"] = "TURNLEFT",
	["D"] = "TURNRIGHT",
	["RIGHT"] = "TURNRIGHT",
	["A"] = "STRAFELEFT",
	["E"] = "STRAFERIGHT",
	["1"] = "ACTIONBUTTON1",
	["2"] = "ACTIONBUTTON2",
	["3"] = "ACTIONBUTTON3",
	["4"] = "ACTIONBUTTON4",
	["5"] = "ACTIONBUTTON5",
	["6"] = "ACTIONBUTTON6",
	["7"] = "ACTIONBUTTON7",
	["8"] = "ACTIONBUTTON8",
	["9"] = "ACTIONBUTTON9",
	["0"] = "ACTIONBUTTON10",
	[")"] = "ACTIONBUTTON11",
	["="] = "ACTIONBUTTON12",
	["SHIFT-,"] = "MULTIACTIONBAR1BUTTON1",
	["NUMPAD1"] = "SHAPESHIFTBUTTON1",
	["NUMPAD2"] = "SHAPESHIFTBUTTON2",
	["NUMPAD3"] = "SHAPESHIFTBUTTON3",
	["NUMPAD4"] = "SHAPESHIFTBUTTON4",
	["NUMPAD5"] = "SHAPESHIFTBUTTON5",
	["NUMPAD6"] = "SHAPESHIFTBUTTON6",
	["CTRL-NUMPAD0"] = "CLICK ClearWORLDMARKERs:LEFTBUTTON",
	["CTRL-NUMPAD1"] = "CLICK WORLDMARKER1:LEFTBUTTON",
	["CTRL-NUMPAD2"] = "CLICK WORLDMARKER2:LEFTBUTTON",
	["CTRL-NUMPAD3"] = "CLICK WORLDMARKER3:LEFTBUTTON",
	["CTRL-NUMPAD4"] = "CLICK WORLDMARKER4:LEFTBUTTON",
	["CTRL-NUMPAD5"] = "CLICK WORLDMARKER5:LEFTBUTTON",
	["NUMPAD7"] = "INTERACTTARGET",
	["NUMPAD8"] = "INTERACTMOUSEOVER",
	["NUMPAD9"] = "TARGETLASTHOSTILE",
	["BUTTON1"] = "CAMERAORSELECTORMOVE",
	["BUTTON2"] = "TURNORACTION",
	["BUTTON3"] = "MULTIACTIONBAR1BUTTON5",
	["BUTTON4"] = "TOGGLEAUTORUN",
	["BUTTON5"] = "MULTIACTIONBAR1BUTTON6",
	["TAB"] = "TARGETNEARESTENEMY",
	["SHIFT-TAB"] = "TARGETPREVIOUSENEMY",
	["CTRL-TAB"] = "TOGGLEWORLDSTATESCORES",
	["V"] = "NAMEPLATES",
	["SHIFT-V"] = "FRIENDNAMEPLATES",
	["CTRL-V"] = "ALLNAMEPLATES",
	["R"] = "REPLY",
	["G"] = "TOGGLEGUILDTAB",
	["C"] = "TOGGLECHARACTER0",
	["P"] = "TOGGLESPELLBOOK",
	["N"] = "TOGGLETALENTS",
	["O"] = "TOGGLESOCIAL",
	["L"] = "TOGGLEQUESTLOG",
	["I"] = "OPENALLBAGS",
	["J"] = "TOGGLEENCOUNTERJOURNAL",
	["SHIFT-J"] = "TOGGLECOLLECTIONSMOUNTJOURNAL",
	["M"] = "TOGGLEWORLDMAP",
	["SHIFT-M"] = "TOGGLEBATTLEFIELDMINIMAP",
	["X"] = "SITORSTAND",
	["Y"] = "TOGGLEACHIEVEMENT",
	["!"] = "TOGGLECHARACTER4",
	["²"] = "INSPECT",
	["*"] = "TOGGLERUN",
	[":"] = "TOGGLEDUNGEONSANDRAIDS",
	["SPACE"] = "JUMP",
	["ENTER"] = "OPENCHAT",
	["ESCAPE"] = "TOGGLEGAMEMENU",
	["PRINTSCREEN"] = "SCREENSHOT",
	["NUMPADDIVIDE"] = "TOGGLESHEATH",
	["MOUSEWHEELUP"] = "CAMERAZOOMIN",
	["MOUSEWHEELDOWN"] = "CAMERAZOOMOUT"
}

keybinding:RegisterEvent("PLAYER_ENTERING_WORLD")
keybinding:RegisterEvent("ZONE_CHANGED_NEW_AREA")
keybinding:SetScript("OnEvent", function(self, event)
	if InCombatLockdown() then return end

	if event == "PLAYER_ENTERING_WORLD" then
		-- Remove all keybinds
		for i = 1, GetNumBindings() do
			local command = GetBinding(i)
			while GetBindingKey(command) do
				local key = GetBindingKey(command)
				SetBinding(key) -- Clear Keybind
			end
		end

		-- Apply personal keybinds
		for key, bind in pairs(bindings) do
			SetBinding(key, bind)
		end

		-- Save keybinds
		SaveBindings(1)

		-- All done, clean up a bit.
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		bindings = nil	-- Remove table
		self = nil -- Remove frame
	end

	local _, instanceType = IsInInstance()

	if instanceType == "pvp" or instanceType == "arena" or GetZonePVPInfo() == "combat" then
		SetBinding("TAB", "TARGETNEARESTENEMYPLAYER")
		SetBinding("SHIFT-TAB", "TARGETPREVIOUSENEMYPLAYER")
	else
		SetBinding("TAB", "TARGETNEARESTENEMY")
		SetBinding("SHIFT-TAB", "TARGETPREVIOUSENEMY")
	end
end)

--[[	Acceleration	]]
for i = 1, 12 do
	local currentButton = _G["ActionButton"..i]

	currentButton:RegisterForClicks("AnyDown")

--	SetOverrideBindingClick(button, true, KEYBIND, button:GetName(), MOUSEBUTTONTOFAKE)
	SetOverrideBindingClick(currentButton, true, i == 12 and "-" or i == 11 and ")" or i == 10 and "0" or i, currentButton:GetName(), "LEFTBUTTON")
end

local driver = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
-- Create binding map.
driver:Execute([[
	bindings = newtable("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ")", "-")
]])

-- Trigger func when form changes.
driver:SetAttribute("_onstate-form", [=[
	local name
	if newstate == "1" then
		name = "BonusActionButton%d"
	else
		name = "ActionButton%d"
	end
	
	for i = 1, 12 do
			self:ClearBinding(bindings[i])
		self:SetBindingClick(true, bindings[i], name:format(i))
	end
]=])
RegisterStateDriver(driver, "form", "[vehicleui][bonusbar:5][form]1;0")