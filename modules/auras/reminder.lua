--[[	$Id: reminder.lua 3967 2014-12-02 08:31:31Z sdkyron@gmail.com $	]]

local _, caelUI = ...

local pixelScale = caelUI.scale

--[[
	Spell Reminder Arguments

	Type of Check:
		spells - List of spells in a group, if you have anyone of these spells the icon will hide.
		weapon - Run a weapon enchant check instead of a spell check

	Spells only Requirements:
		negate_spells - List of spells in a group, if you have anyone of these spells the icon will immediately hide and stop running the spell check (these should be other peoples spells)
		reversecheck - only works if you provide a role or a spec, instead of hiding the frame when you have the buff, it shows the frame when you have the buff, doesn't work with weapons
		negate_reversecheck - if reversecheck is set you can set a spec to not follow the reverse check, doesn't work with weapons

	Requirements: (These work for both spell and weapon checks)
		role - you must be a certain role for it to display (Tank, Melee, Caster)
		spec - you must be active in a specific spec for it to display (1, 2, 3) note: spec order can be viewed from top to bottom when you open your talent panel
		level - the minimum level you must be (most of the time we don't need to use this because it will register the spell learned event if you don't know the spell, but in the case of weapon enchants this is useful)
		personal - aura must come from the player

	Additional Checks: (Note we always run a check when gaining/losing an aura)
		instance - check when entering a party/raid instance
		pvp - check when entering a bg/arena
		combat - check when entering combat

	For every group created a new frame is created, it's a lot easier this way.
--]]

ReminderBuffs = {
	DEATHKNIGHT = {
		[1] = {	-- Horn of Winter group
			["spells"] = {
				57330,	-- Horn of Winter
			},
			["negate_spells"] = {
				6673,	-- Battle Shout
				19506,	-- Trueshot Aura
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
		[2] = {	-- Blood Presence group
			["spells"] = {
				48263,	-- Blood Presence
			},
			["role"] = "Tank",
			["instance"] = true,
		},
	},
	DRUID = {
		[1] = {	-- Mark of the Wild group
			["spells"] = {
				1126,	-- Mark of the Wild
			},
			["negate_spells"] = {
				159988,	-- Bark of the Wild (Dog)
				160017,	-- Blessing of Kongs (Gorilla)
				90363,	-- Embrace of the Shale Spider
				160077,	-- Strength of the Earth (Worm)
				115921,	-- Legacy of the Emperor
				116781,	-- Legacy of the White Tiger
				20217,	-- Blessing of Kings
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
	HUNTER = {
		[1] = {
			["spells"] = {
				162536,	-- Incendiary Ammo
			},
			["negate_spells"] = {
				162537,	-- Poisoned Ammo
				162539,	-- Frozen Ammo
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
	MAGE = {
		[1] = {	-- Brilliance group
			["spells"] = {
				1459,	-- Arcane Brilliance
				61316,	-- Dalaran Brilliance
			},
			["negate_spells"] = {
				126309,	-- Still Water (Water Strider)
				128433,	-- Serpent's Cunning (Serpent)
				90364,	-- Qiraji Fortitude (Silithid)
				109773,	-- Dark Intent
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
	MONK = {
		[1] = {	-- Legacy of the Emperor group
			["spells"] = {
				115921,	-- Legacy of the Emperor
			},
			["negate_spells"] = {
				1126,	-- Mark of the Wild
				159988,	-- Bark of the Wild (Dog)
				160017,	-- Blessing of Kongs (Gorilla)
				90363,	-- Embrace of the Shale Spider
				160077,	-- Strength of the Earth (Worm)
				116781,	-- Legacy of the White Tiger
				20217,	-- Blessing of Kings
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
		[2] = {	-- Legacy of the White Tiger group
			["spells"] = {
				116781,	-- Legacy of the White Tiger
			},
			["negate_spells"] = {
				91126,	-- Mark of the Wild
				159988,	-- Bark of the Wild (Dog)
				160017,	-- Blessing of Kongs (Gorilla)
				90363,	-- Embrace of the Shale Spider
				160077,	-- Strength of the Earth (Worm)
				115921,	-- Legacy of the Emperor
				20217,	-- Blessing of Kings
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
	PALADIN = {
		[1] = {	-- Righteous Fury group
			["spells"] = {
				25780,	-- Righteous Fury
			},
			["role"] = "Tank",
			["instance"] = true,
		},
		[2] = {	-- Blessing of Kings group
			["spells"] = {
				20217,	-- Blessing of Kings
			}, 
			["negate_spells"] = {
				1126,		-- Mark of the Wild
				160017,	-- Blessing of Kongs (Gorilla)
				90363,	-- Embrace of the Shale Spider
				160077,	-- Strength of the Earth (Worm)
				115921,	-- Legacy of the Emperor
				116781,	-- Legacy of the White Tiger
				19740,	-- Blessing of Might
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
		[3] = {	-- Blessing of Might group
			["spells"] = {
				19740,	-- Blessing of Might
			},
			["negate_spells"] = {
				155522,	-- Power of the Grave
				24907,	-- Moonkin Aura
				93435,	-- Roar of Courage (Cat)
				160039,	-- Keen Senses (Hydra)
				160073,	-- Plainswalking (Tallstrider)
				128997,	-- Spirit Beast Blessing
				116956,	-- Grace of Air
				20217,	-- Blessing of Kings
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
	PRIEST = {
		[1] = {	-- Stamina group
			["spells"] = {
				21562,	-- Power Word: Fortitude
			},
			["negate_spells"] = {
				90364,	-- Qiraji Fortitude (Silithid)
				160003,	-- Savage Vigor (Rylak)
				160014,	-- Sturdiness (Goat)
				166928,	-- Blood Pact
				469,	-- Commanding Shout
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true
		},
	},
	ROGUE = {
		[1] = {	-- Lethal Poisons group
			["spells"] = {
				2823,	-- Deadly Poison
				8679,	-- Wound Poison
				157584,	-- Instant Poison
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
		[2] = {	-- Non-Lethal Poisons group
			["spells"] = {
				3408,	-- Crippling Poison
				108211,	-- Leeching Poison
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
	SHAMAN = {
		[1] = {	-- Shields group
			["spells"] = {
				52127,	-- Water Shield
				324,	-- Lightning Shield
				974,	-- Earth Shield
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
	WARLOCK = {
		[1] = {	-- Dark Intent group
			["spells"] = {
				109773,	-- Dark Intent
			},
			["negate_spells"] = {
				1459,	-- Arcane Brilliance
				61316,	-- Dalaran Brilliance
				126309,	-- Still Water (Water Strider)
				128433,	-- Serpent's Cunning (Serpent)
				90364,	-- Qiraji Fortitude (Silithid)
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
	WARRIOR = {
		[1] = {	-- Commanding Shout group
			["spells"] = {
				469,	-- Commanding Shout
			},
			["negate_spells"] = {
				90364,	-- Qiraji Fortitude (Silithid)
				160003,	-- Savage Vigor (Rylak)
				160014,	-- Sturdiness (Goat)
				21562,	-- Power Word: Fortitude
				166928,	-- Blood Pact
				6673,		-- Battle Shout
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
		[2] = {	-- Battle Shout group
			["spells"] = {
				6673,	-- Battle Shout
			},
			["negate_spells"] = {
				19506,	-- Trueshot Aura
				57330,	-- Horn of Winter
				469,		-- Commanding Shout
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
	},
}

local tab = ReminderBuffs[caelUI.playerClass]

if not tab then return end

local OnEvent = function(self, event, arg1, arg2)
	local group = tab[self.id]

	if not group.spells and not group.weapon then return end
	if not GetActiveSpecGroup() then return end
	if event == "UNIT_AURA" and arg1 ~= "player" then return end
	if group.level and UnitLevel("player") < group.level then return end

	self.icon:SetTexture(nil)
	self:Hide()

	if group.negate_spells then
		for _, buff in pairs(group.negate_spells) do
			local name = GetSpellInfo(buff)
			if (name and UnitBuff("player", name)) then
				return
			end
		end
	end

	local hasOffhandWeapon = OffhandHasWeapon()
	local hasMainHandEnchant, _, _, hasOffHandEnchant = GetWeaponEnchantInfo()

	if not group.weapon then
		for _, buff in pairs(group.spells) do
			local name, _, icon = GetSpellInfo(buff)
			local usable, nomana = IsUsableSpell(name)
			if usable or nomana then
				self.icon:SetTexture(icon)

				break
			end
		end

		if not self.icon:GetTexture() and event == "PLAYER_LOGIN" then
			self:UnregisterAllEvents()
			self:RegisterEvent("LEARNED_SPELL_IN_TAB")

			return
		elseif self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB" then
			self:UnregisterAllEvents()
			self:RegisterEvent("UNIT_AURA")

			if group.combat and group.combat == true then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				self:RegisterEvent("PLAYER_REGEN_DISABLED")
			end

			if (group.instance and group.instance == true) or (group.pvp and group.pvp == true) then
				self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			end

			if group.role and group.role == true then
				self:RegisterEvent("UNIT_INVENTORY_CHANGED")
			end
		end
	else
		self:UnregisterAllEvents()
		self:RegisterEvent("UNIT_INVENTORY_CHANGED")

		if hasOffhandWeapon == nil then
			if hasMainHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			end
		else
			if hasOffHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 17))
			end

			if hasMainHandEnchant == nil then
				self.icon:SetTexture(GetInventoryItemTexture("player", 16))
			end
		end

		if group.combat and group.combat == true then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end

		if (group.instance and group.instance == true) or (group.pvp and group.pvp == true) then
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end

		if group.role and group.role == true then
			self:RegisterEvent("UNIT_INVENTORY_CHANGED")
		end
	end

	local role = group.role
	local spec = group.spec
	local combat = group.combat
	local personal = group.personal
	local instance = group.instance
	local pvp = group.pvp
	local reversecheck = group.reversecheck
	local negate_reversecheck = group.negate_reversecheck
--	local canplaysound = false
	local rolepass = false
	local specpass = false
	local _, instanceType, difficultyID = GetInstanceInfo()

	if role ~= nil then
		if role == UnitGroupRolesAssigned("player") then
			rolepass = true
		else
			rolepass = false
		end
	else
		rolepass = true
	end

	if spec ~= nil then
		if spec == GetSpecialization() then
			specpass = true
		else
			specpass = false
		end
	else
		specpass = true
	end

	-- Prevent user error
	if reversecheck ~= nil and (role == nil and spec == nil) then reversecheck = nil end

	-- Only time we allow it to play a sound
--	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_REGEN_DISABLED" then canplaysound = true end

	if not group.weapon then
		if ((combat and UnitAffectingCombat("player")) or (instance and difficultyID ~= 0) or (pvp and (instanceType == "arena" or instanceType == "pvp"))) and
		specpass == true and rolepass == true and not (UnitInVehicle("player") and self.icon:GetTexture()) then
			for _, buff in pairs(group.spells) do
				local name = GetSpellInfo(buff)
				local _, _, icon, _, _, _, _, unitCaster = UnitBuff("player", name)

				if personal and personal == true then
					if name and icon and unitCaster == "player" then
						self:Hide()

						return
					end
				else
					if name and icon then
						self:Hide()

						return
					end
				end
			end
			self:Show()

--			if canplaysound == true then PlaySoundFile(caelMedia.files.soundWarning) end
		elseif ((combat and UnitAffectingCombat("player")) or (instance and difficultyID ~= 0)) and
		reversecheck == true and not (UnitInVehicle("player") and self.icon:GetTexture()) then
			if negate_reversecheck and negate_reversecheck == GetSpecialization() then self:Hide() return end

			for _, buff in pairs(group.spells) do
				local name = GetSpellInfo(buff)
				local _, _, icon, _, _, _, _, unitCaster = UnitBuff("player", name)

				if name and icon and unitCaster == "player" then
					self:Show()

--					if canplaysound == true then PlaySoundFile(caelMedia.files.soundWarning) end

					return
				end
			end
		else
			self:Hide()
		end
	else
		if ((combat and UnitAffectingCombat("player")) or (instance and difficultyID ~= 0) or (pvp and (instanceType == "arena" or instanceType == "pvp"))) and
		specpass == true and rolepass == true and not (UnitInVehicle("player") and self.icon:GetTexture()) then
			if hasOffhandWeapon == nil then
				if hasMainHandEnchant == nil then
					self:Show()
					self.icon:SetTexture(GetInventoryItemTexture("player", 16))

--					if canplaysound == true then PlaySoundFile(caelMedia.files.soundWarning) end

					return
				end
			else
				if hasMainHandEnchant == nil or hasOffHandEnchant == nil then
					self:Show()

					if hasMainHandEnchant == nil then
						self.icon:SetTexture(GetInventoryItemTexture("player", 16))
					else
						self.icon:SetTexture(GetInventoryItemTexture("player", 17))
					end

--					if canplaysound == true then PlaySoundFile(caelMedia.files.soundWarning) end

					return
				end
			end
			self:Hide()

			return
		else
			self:Hide()

			return
		end
	end
end

for i = 1, #tab do
	caelUI.reminder = caelUI.createModule("Reminder"..i)

	local reminder = caelUI.reminder

	reminder:SetSize(pixelScale(38), pixelScale(38))
	reminder:SetPoint("BOTTOM", Minimap, "TOP", 0, pixelScale(200))

	reminder.id = i

	reminder.border = CreateFrame("Frame", nil, reminder)
	reminder.border:SetPoint("TOPLEFT", pixelScale(-1.5), pixelScale(1.5))
	reminder.border:SetPoint("BOTTOMRIGHT", pixelScale(1.5), pixelScale(-1.5))
	reminder.border:SetBackdrop({
		bgFile = caelMedia.files.buttonNormal,
		insets = {top = pixelScale(-2.5), left = pixelScale(-2.5), bottom = pixelScale(-2.5), right = pixelScale(-2.5)},
	})

	reminder.icon = reminder:CreateTexture(nil, "OVERLAY")
	reminder.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	reminder.icon:SetPoint("TOPLEFT", pixelScale(2.5), pixelScale(-2.5))
	reminder.icon:SetPoint("BOTTOMRIGHT", pixelScale(-2.5), pixelScale(2.5))

	reminder.gloss = CreateFrame("Frame", nil, reminder)
	reminder.gloss:SetAllPoints()
	reminder.gloss:SetBackdrop({
		bgFile = caelMedia.files.buttonGloss,
		insets = {top = pixelScale(-5), left = pixelScale(-5), bottom = pixelScale(-5), right = pixelScale(-5)},
	})
	reminder.gloss:SetBackdropColor(1, 1, 1, 0.5)

	reminder:Hide()

	for _, event in next, {
		"PLAYER_ENTERING_WORLD",
		"PLAYER_LOGIN",
		"PLAYER_REGEN_DISABLED",
		"PLAYER_REGEN_ENABLED",
		"UNIT_AURA",
		"UNIT_ENTERED_VEHICLE",
		"UNIT_ENTERING_VEHICLE",
		"UNIT_EXITED_VEHICLE",
		"UNIT_EXITING_VEHICLE",
		"UNIT_INVENTORY_CHANGED",
		"ZONE_CHANGED_NEW_AREA",
	} do
		reminder:RegisterEvent(event)
	end

	reminder:SetScript("OnEvent", OnEvent)
	reminder:SetScript("OnUpdate", function(self, elapsed)
		if not self.icon:GetTexture() then
			self:Hide()
		end
	end)
	reminder:SetScript("OnShow", function(self)
		if not self.icon:GetTexture() then
			self:Hide()
		end
	end)
end