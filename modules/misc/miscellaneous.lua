--[[	$Id: miscellaneous.lua 3788 2013-12-12 13:35:35Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.miscellaneous = caelUI.createModule("Miscellaneous")

local miscellaneous = caelUI.miscellaneous

local kill = caelUI.kill
local dummy = caelUI.dummy

--[[	kill default UI stuff we don't need	]]

miscellaneous:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_AchievementUI" then
			hooksecurefunc("AchievementFrameCategories_DisplayButton", function(button) button.showTooltipFunc = nil end)
		end

		if addon ~= "caelUI" then return end

		InterfaceOptionsFrameCategoriesButton11:SetScale(0.01)
		InterfaceOptionsFrameCategoriesButton11:SetAlpha(0)

		CompactRaidFrameManager:SetParent(caelUI.KillFrame)
		CompactUnitFrameProfiles:UnregisterAllEvents()

		CompactUnitFrame_UpdateAll = dummy
		CompactUnitFrameProfiles_ApplyProfile = dummy
		CompactRaidFrameManager_UpdateShown = dummy
		CompactRaidFrameManager_UpdateOptionsFlowContainer = dummy

		for i = 1, MAX_PARTY_MEMBERS do
			local member = "PartyMemberFrame"..i

			_G[member]:UnregisterAllEvents()
			_G[member]:SetParent(caelUI.KillFrame)
			_G[member]:Hide()
			_G[member.."HealthBar"]:UnregisterAllEvents()
			_G[member.."ManaBar"]:UnregisterAllEvents()
			
			local pet = member.."PetFrame"
			
			_G[pet]:UnregisterAllEvents()
			_G[pet]:SetParent(caelUI.KillFrame)
			_G[pet.."HealthBar"]:UnregisterAllEvents()
			
			HidePartyFrame()

			ShowPartyFrame = dummy
			HidePartyFrame = dummy
		end	

		kill(Advanced_UseUIScale)
		kill(Advanced_UIScaleSlider)
		kill(CompanionsMicroButtonAlert)
		kill(GuildChallengeAlertFrame)
		kill(HelpOpenTicketButtonTutorial)
		kill(HelpPlate)
		kill(HelpPlateTooltip)
		kill(PartyMemberBackground)
		kill(StreamingIcon)
		kill(TalentMicroButtonAlert)
		kill(TutorialFrame)
		kill(TutorialFrameAlertButton)

		kill(InterfaceOptionsSocialPanelChatStyle)
		kill(InterfaceOptionsSocialPanelWholeChatWindowClickable)

		InterfaceOptionsFrameCategoriesButton9:SetScale(0.01)
		InterfaceOptionsFrameCategoriesButton9:SetAlpha(0)
		InterfaceOptionsFrameCategoriesButton10:SetScale(0.01)
		InterfaceOptionsFrameCategoriesButton10:SetAlpha(0)
		kill(InterfaceOptionsBuffsPanelCastableBuffs)
		kill(InterfaceOptionsBuffsPanelDispellableDebuffs)
		kill(InterfaceOptionsBuffsPanelShowAllEnemyDebuffs)
		kill(InterfaceOptionsCombatPanelTargetOfTarget)
		kill(InterfaceOptionsCombatPanelEnemyCastBars)
		kill(InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait)

		kill(InterfaceOptionsActionBarsPanelBottomLeft)
		kill(InterfaceOptionsActionBarsPanelBottomRight)
		kill(InterfaceOptionsActionBarsPanelRight)
		kill(InterfaceOptionsActionBarsPanelRightTwo)
		kill(InterfaceOptionsActionBarsPanelAlwaysShowActionBars)

		kill(InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates)
		kill(InterfaceOptionsNamesPanelUnitNameplatesNameplateClassColors)

		kill(InterfaceOptionsDisplayPanelRotateMinimap)

		kill(InterfaceOptionsCombatTextPanelTargetDamage)
		kill(InterfaceOptionsCombatTextPanelPeriodicDamage)
		kill(InterfaceOptionsCombatTextPanelPetDamage)
		kill(InterfaceOptionsCombatTextPanelHealing)

		miscellaneous:SetScript("OnUpdate", function(self, elapsed)
			if LFRBrowseFrame.timeToClear then
				LFRBrowseFrame.timeToClear = nil 
			end 
		end)
	end
end)

--[[	Prevent the /read emote from happening automatically	]]

hooksecurefunc("DoEmote", function(emote)
	if emote == "READ" and (WorldMapFrame:IsShown() or MailFrame:IsShown()) then
		CancelEmote()
	end
end)

--[[	Fix RemoveTalent() taint	]]

FCF_StartAlertFlash = dummy

--[[	Skip replace same enchant warning	]]

miscellaneous:HookScript("OnEvent", function(self, event, old, new)
	if event == "REPLACE_ENCHANT" then
		if old == new then
			ReplaceEnchant()
			StaticPopup_Hide("REPLACE_ENCHANT")
		else
			return
		end
	end
end)

--[[	Force quit	]]

miscellaneous:HookScript("OnEvent", function(self, event, msg)
	if event == "CHAT_MSG_SYSTEM" then
		if msg and msg == IDLE_MESSAGE then
			ForceQuit()
		end
	end
end)

--[[	Auto SetFilter for AchievementUI	]]

miscellaneous:HookScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_AchievementUI" then
		AchievementFrame_SetFilter(3)
	end
end)

--[[	Hide UI during Pet Battle	]]

--FRAMELOCK_STATES.PETBATTLES["ChatButtonBar"] = "hidden"
FRAMELOCK_STATES.PETBATTLES["GeneralDockManager"] = "hidden" -- GeneralDockManagerScrollFrameChild

--[[	Real auto dismount	]]

miscellaneous:HookScript("OnEvent", function(self, event, ...)
	local arg = ...

	if event == "UI_ERROR_MESSAGE" then
		if((arg == SPELL_FAILED_NOT_MOUNTED or arg == ERR_TAXIPLAYERALREADYMOUNTED) and (GetCVarBool("autoDismountFlying") == 1 or IsFlying() == nil)) then
			Dismount()
		end
	end
end)

--[[	Hide the Loss of control frame	]]

LossOfControlFrame:UnregisterAllEvents()
LossOfControlFrame:Hide()

--[[	Auto select current event boss from LFD tool	]]

local firstLFD
LFDParentFrame:HookScript("OnShow", function()
	if not firstLFD then
		firstLFD = 1
		for i = 1, GetNumRandomDungeons() do
			local id = GetLFGRandomDungeonInfo(i)
			local isHoliday = select(14, GetLFGDungeonInfo(id))

			if isHoliday and not GetLFGDungeonRewards(id) then
				LFDQueueFrame_SetType(id)
			end
		end
	end
end)

--[[	Auto screen achievements	]]

miscellaneous:HookScript("OnEvent", function (self, event, ...)
	if event == "ACHIEVEMENT_EARNED" then
		C_Timer.After(1, function() Screenshot() end)
	end
end)
  
--[[	Sound + sheath/unsheath on target change	]]

local SheathUnsheath = function()
	local Sheathed = GetSheathState()

	if UnitAffectingCombat("player") or (UnitExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") and not UnitIsBattlePet("target")) then
		if Sheathed ~= 2 then
			ToggleSheath()
		end
	else
		if Sheathed ~= 1 then
			ToggleSheath()
		end
	end
end

miscellaneous:HookScript("OnEvent", function (self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_TARGET_CHANGED" then
		SheathUnsheath()
	end

	if event == "PLAYER_TARGET_CHANGED" then
		if UnitExists("target") then
			PlaySound("igCreatureAggroSelect")
		else
			PlaySound("igCreatureAggroDeselect")
		end
	end
end)

for _, event in next, {
	"ACHIEVEMENT_EARNED",
	"ADDON_LOADED",
	"CHAT_MSG_SYSTEM",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_TARGET_CHANGED",
	"REPLACE_ENCHANT",
	"UI_ERROR_MESSAGE",
} do
	miscellaneous:RegisterEvent(event)
end