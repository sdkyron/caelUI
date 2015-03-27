--[[	$Id: autoPet.lua 3975 2014-12-04 23:07:52Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.autopet = caelUI.createModule("AutoPet")

-- Auto summon a mini pet

--[[
	Grommloc "BattlePet-0-0000068DC6F4"
	Xu-Fu, Cub of Xuen "BattlePet-0-00000707FA79"
	Spectral Porcupette "BattlePet-0-000007072473"
	Molten Corgi "BattlePet-0-0000067DC603"
	Crawling Claw "BattlePet-0-0000068DC78F"

	Ethereal Soul-Trader "BattlePet-0-000004861D11"
	Spectral Tiger Cub "BattlePet-0-000004861CE8"
	Unborn Val'kyr "BattlePet-0-000004F859EA"
	Restless Shadeling "0x0000000001DE3744"
	Cinder Kitten "0x0000000001A1413B"
	Spawn of G'nathus "0x0000000001ACA5C6"
	Darkmoon Rabbit "0x0000000001C8A100"
	Aqua Strider "0x0000000001B81C6A"
	Eye of the Legion "0x0000000001A6CA7E"
	Direhorn Runt "BattlePet-0-000004861CE7"
	Mr. Bigglesworth "0x00000000015AFE45"
	Blighthawk "0x00000000012FD1C6"
	Corefire Imp "0x00000000013E0B6F"
	Curious Wolvar Pup "0x00000000005ef593"
	Giant Bone Spider "0x000000000131473E"
	Gilnean Raven "0x0000000001274163"
	Pandaren Monk "0x000000000068D0C0"
	Spirit of Summer  "0x00000000005ef562"
	Whiskers the Rat "0x00000000005EF560"
	Worg Pup "0x0000000000B55771"
--]]

local petGUID = caelUI.myChars and "BattlePet-0-000007072473" or "BattlePet-0-0000067DC603"

local Summon = function()
	local _, instanceType = IsInInstance()
	local activePet = C_PetJournal.GetSummonedPetGUID()

	if instanceType == "pvp" or instanceType == "arena" then
		if activePet then
			C_PetJournal.SummonPetByGUID(activePet)
		end

		return
	end

	if petGUID
		and (not activePet or activePet ~= petGUID)
		and not UnitAffectingCombat("player")
		and not IsMounted() and not IsFlying() and not UnitHasVehicleUI("player")
		and not IsStealthed() and not UnitIsGhost("player")
		and not UnitAura("player", GetSpellInfo(51755), nil, "HELPFUL") -- Camouflage
		and not UnitAura("player", GetSpellInfo(101168), nil, "HELPFUL") -- Haunted
		and not UnitAura("player", GetSpellInfo(32612), nil, "HELPFUL") -- Invisibility
	then
		C_PetJournal.SummonPetByGUID(petGUID)
	end
end

caelUI.autopet:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
caelUI.autopet:SetScript("OnEvent", function(self, event)
	if event == "PET_JOURNAL_LIST_UPDATE" then
		Summon()
	end
end)

hooksecurefunc("ToggleAutoRun", Summon)
hooksecurefunc("MoveForwardStart", Summon)