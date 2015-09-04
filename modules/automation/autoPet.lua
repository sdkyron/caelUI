--[[	$Id: autoPet.lua 3975 2014-12-04 23:07:52Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.autopet = caelUI.createModule("AutoPet")

-- Auto summon a mini pet

--[[
	Guardian Cub "BattlePet-0-0000076F4764"
	Harmonious Porcupette "BattlePet-0-0000076F4AE5"
	Fel Pup "BattlePet-0-0000077225C7"
--]]

local petGUID = (caelUI.myChars and GetSpecialization() == 1 and "BattlePet-0-0000076F4AE5") or (caelUI.myChars and GetSpecialization() == 2 and "BattlePet-0-0000076F4764") or "BattlePet-0-0000067DC603"

local Summon = function()
	local _, instanceType = IsInInstance()
	local activePet = C_PetJournal.GetSummonedPetGUID() -- C_PetJournal.FindPetIDByName("Guardian Cub")

	if instanceType == "pvp" or instanceType == "arena" then
		if activePet then
			C_PetJournal.SummonPetByGUID(activePet)
		end

		return
	else
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
end

caelUI.autopet:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
caelUI.autopet:SetScript("OnEvent", function(self, event)
	if event == "PET_JOURNAL_LIST_UPDATE" then
		Summon()
	end
end)

hooksecurefunc("ToggleAutoRun", Summon)
hooksecurefunc("MoveForwardStart", Summon)