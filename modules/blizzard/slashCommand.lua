--[[	$Id: slashCommand.lua 3953 2014-10-28 08:13:46Z sdkyron@gmail.com $	]]

--[[	Some new slash commands	]]

SlashCmdList["FRAMENAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil then FRAME = arg end --Set the global variable FRAME to = whatever we are mousing over to simplify messing with frames that have no name.

	if arg ~= nil and arg:GetName() ~= nil then
		local point, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() and arg:GetParent():GetName() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end
 
		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
		ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
		ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())
 
		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		if relativeTo and relativeTo:GetName() then
			ChatFrame1:AddMessage("Point: |cffFFD100"..point.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end
SlashCmdList["PARENT"] = function() print(GetMouseFocus():GetParent():GetName()) end
SlashCmdList["MASTER"] = function() ToggleHelpFrame() end
SlashCmdList["RELOAD"] = function() ReloadUI() end
SlashCmdList["ENABLE_ADDON"] = function(addon) EnableAddOn(addon) print(addon, format("|cff559655enabled")) end
SlashCmdList["DISABLE_ADDON"] = function(addon) DisableAddOn(addon) print(addon, format("|cffAF5050disabled")) end
SlashCmdList["CLFIX"] = function() CombatLogClearEntries() end
SlashCmdList["READYCHECK"] = function() DoReadyCheck() end
SlashCmdList["GROUPDISBAND"] = function()
	if UnitInRaid("player") then
		SendChatMessage("Disbanding raid.", "RAID")
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= caelUI.playerName then
				UninviteUnit(name)
			end
		end
	else
		SendChatMessage("Disbanding group.", "PARTY")
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if GetPartyMember(i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end

SlashCmdList["AURATEST"] = function()
	for i = 1, 100 do
		local name, _,_,_,_,duration,_,_,_,_, spellID = UnitAura("player", i, "HELPFUL")
--		local name, _,_,_,_,duration,_,_,_,_, spellID = UnitAura("target", i, "HARMFUL")
		if not name then break end

		print(name, spellID)
	end
end

local bossList = {
	"Galleon",32098, "Sha", 32099, "Nalak", 32518, "Oondasta", 32519, "Trove of the Thunder King", 32609, "Key to the Palace of Lei Shen", 32626, "Celestials", 33117, "Ordos" ,33118
}

SlashCmdList["BOSSCHECK"] = function()
	for i = 1, #bossList - 1, 2 do
		DEFAULT_CHAT_FRAME:AddMessage(format("%s %s", bossList[i], IsQuestFlaggedCompleted(bossList[i + 1]) and "\124cff00ff00Yes" or "\124cffff0000No"))
	end
end

SLASH_FRAMENAME1 = "/frame"
SLASH_PARENT1 = "/parent"
SLASH_MASTER1 = "/gm"
SLASH_RELOAD1 = "/rl"
SLASH_ENABLE_ADDON1 = "/en"
SLASH_DISABLE_ADDON1 = "/dis"
SLASH_CLFIX1 = "/clfix"
SLASH_READYCHECK1 = "/rc"
SLASH_GROUPDISBAND1 = "/radisband"
SLASH_AURATEST1 = "/auratest"
SLASH_BOSSCHECK1 = "/bosscheck"