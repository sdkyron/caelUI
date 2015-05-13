--[[	$Id: oUF_cSpawn.lua 3521 2013-08-23 11:14:00Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

local kill, pixelScale = caelUI.kill, caelUI.scale

--[[
List of the various configuration attributes
======================================================
showRaid = [BOOLEAN] -- true if the header should be shown while in a raid
showParty = [BOOLEAN] -- true if the header should be shown while in a party and not in a raid
showPlayer = [BOOLEAN] -- true if the header should show the player when not in a raid
showSolo = [BOOLEAN] -- true if the header should be shown while not in a group (implies showPlayer)
nameList = [STRING] -- a comma separated list of player names (not used if "groupFilter" is set)
groupFilter = [1-8, STRING] -- a comma seperated list of raid group numbers and/or uppercase class names and/or uppercase roles
strictFiltering = [BOOLEAN] - if true, then characters must match both a group and a class from the groupFilter list
point = [STRING] -- a valid XML anchoring point (Default: "TOP")
xOffset = [NUMBER] -- the x-Offset to use when anchoring the unit buttons (Default: 0)
yOffset = [NUMBER] -- the y-Offset to use when anchoring the unit buttons (Default: 0)
sortMethod = ["INDEX", "NAME"] -- defines how the group is sorted (Default: "INDEX")
sortDir = ["ASC", "DESC"] -- defines the sort order (Default: "ASC")
template = [STRING] -- the XML template to use for the unit buttons
templateType = [STRING] - specifies the frame type of the managed subframes (Default: "Button")
groupBy = [nil, "GROUP", "CLASS", "ROLE"] - specifies a "grouping" type to apply before regular sorting (Default: nil)
groupingOrder = [STRING] - specifies the order of the groupings (ie. "1,2,3,4,5,6,7,8")
maxColumns = [NUMBER] - maximum number of columns the header will create (Default: 1)
unitsPerColumn = [NUMBER or nil] - maximum units that will be displayed in a singe column, nil is infinate (Default: nil)
startingIndex = [NUMBER] - the index in the final sorted unit list at which to start displaying units (Default: 1)
columnSpacing = [NUMBER] - the ammount of space between the rows/columns (Default: 0)
columnAnchorPoint = [STRING] - the anchor point of each new column (ie. use LEFT for the columns to grow to the right)
--]]

oUF:RegisterStyle("Caellian", oUF_Caellian.SetStyle)

oUF:Factory(function(self)

	local spellName = GetSpellInfo(oUF_Caellian.config.clickSpell[caelUI.playerClass] or 6603)	-- 6603 Auto Attack

	if not spellName then
		spellName = GetSpellInfo(6603)
	end

	self:SetActiveStyle("Caellian")

	self:Spawn("player", "oUF_Caellian_Player"):SetPoint("BOTTOM", UIParent, pixelScale(oUF_Caellian.config.coords.playerX), pixelScale(oUF_Caellian.config.coords.playerY))
	self:Spawn("target", "oUF_Caellian_Target"):SetPoint("BOTTOM", UIParent, pixelScale(oUF_Caellian.config.coords.targetX), pixelScale(oUF_Caellian.config.coords.targetY))

	self:Spawn("pet", "oUF_Caellian_Pet"):SetPoint("BOTTOMLEFT", oUF_Caellian_Player, "TOPLEFT", 0, pixelScale(10))
	self:Spawn("focus", "oUF_Caellian_Focus"):SetPoint("BOTTOMRIGHT", oUF_Caellian_Player, "TOPRIGHT", 0, pixelScale(10))
	self:Spawn("focustarget", "oUF_Caellian_FocusTarget"):SetPoint("BOTTOMLEFT", oUF_Caellian_Target, "TOPLEFT", 0, pixelScale(10))
	self:Spawn("targettarget", "oUF_Caellian_TargetTarget"):SetPoint("BOTTOMRIGHT", oUF_Caellian_Target, "TOPRIGHT", 0, pixelScale(10))

	if not oUF_Caellian.config.noParty then
		local party = self:SpawnHeader("oUF_Caellian_Party", nil, "custom [@raid6,exists] hide; show",
			"showParty", true,
			"yOffset", pixelScale(-27.5),
			"oUF-initialConfigFunction", ([[
				self:SetWidth(112)
				self:SetHeight(22)
				self:SetScale(%f)
				self:SetAttribute("type3", "spell")
				self:SetAttribute("spell3", "%s")
			]]):format(oUF_Caellian.config.scale, spellName)
		)
		party:SetPoint("TOPLEFT", UIParent, pixelScale(oUF_Caellian.config.coords.partyX), pixelScale(oUF_Caellian.config.coords.partyY))

		local partyPets = self:SpawnHeader("oUF_Caellian_PartyPets", nil, "custom [@raid6,exists] hide; show",
			"showParty", true,
			"yOffset", pixelScale(-39.5),
			"oUF-initialConfigFunction", ([[
				self:SetWidth(112)
				self:SetHeight(10)
				self:SetScale(%f)
				self:SetAttribute("unitsuffix", "pet")
				self:SetAttribute("type3", "spell")
				self:SetAttribute("spell3", "%s")
			]]):format(oUF_Caellian.config.scale, spellName)
		)
		partyPets:SetPoint("TOPLEFT", oUF_Caellian_Party, 0, pixelScale(-29.5 * oUF_Caellian.config.scale))

		local partyTargets = self:SpawnHeader(
			"oUF_Caellian_PartyTargets", nil, "custom [@raid6,exists] hide; show",
			"showParty", true,
			"yOffset", -27.5,
			"oUF-initialConfigFunction", ([[
				self:SetWidth(112)
				self:SetHeight(22)
				self:SetScale(%f)
				self:SetAttribute("unitsuffix", "target")
			]]):format(oUF_Caellian.config.scale)
		)
		partyTargets:SetPoint("TOPLEFT", oUF_Caellian_Party, "TOPRIGHT", pixelScale(112 * oUF_Caellian.config.scale - 112) + pixelScale(7.5), 0)
	end

	if not oUF_Caellian.config.noRaid then
		local raid = {}

		for i = 1, NUM_RAID_GROUPS do
			local raidgroup = self:SpawnHeader("oUF_Caellian_Raid"..i, nil, "custom [@raid6,exists] show; hide",
				"groupFilter", tostring(i),
				"showRaid", true,
				"yOffSet", pixelScale(-3.5),
				"oUF-initialConfigFunction", ([[
					self:SetWidth(64)
					self:SetHeight(43)
					self:SetScale(%f)
					self:SetAttribute("type3", "spell")
					self:SetAttribute("spell3", "%s")
				]]):format(oUF_Caellian.config.scale, spellName)
			)
			table.insert(raid, raidgroup)

			if i == 1 then
				raidgroup:SetPoint("TOPLEFT", UIParent, pixelScale(oUF_Caellian.config.coords.raidX), pixelScale(oUF_Caellian.config.coords.raidY))
			else
				raidgroup:SetPoint("TOPLEFT", raid[i-1], "TOPRIGHT", pixelScale(64 * oUF_Caellian.config.scale - 64) + pixelScale(3.5), 0)
			end
		end
	end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = self:Spawn("boss"..i, "oUF_Boss"..i)

		if i == 1 then
			boss[i]:SetPoint("TOPRIGHT", UIParent, "RIGHT", pixelScale(oUF_Caellian.config.coords.bossX), pixelScale(oUF_Caellian.config.coords.bossY))
		else
			boss[i]:SetPoint("TOP", boss[i-1], "BOTTOM", 0, pixelScale(-26.5 * oUF_Caellian.config.scale))
		end

		local blizzBoss = _G["Boss"..i.."TargetFrame"]
		blizzBoss:UnregisterAllEvents()
		blizzBoss:Hide()
	end

	for i, v in ipairs(boss) do v:Show() end

	if not oUF_Caellian.config.noArena then
		local arena = {}
		for i = 1, 5 do
			arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)

			if i == 1 then
				arena[i]:SetPoint("TOPRIGHT", UIParent, "RIGHT", pixelScale(oUF_Caellian.config.coords.arenaX), pixelScale(oUF_Caellian.config.coords.arenaY))
			else
				arena[i]:SetPoint("TOP", arena[i-1], "BOTTOM", 0, pixelScale(-26.5 * oUF_Caellian.config.scale))
			end
		end

		for i, v in ipairs(arena) do v:Show() end

		local arenatarget = {}
		for i = 1, 5 do
			arenatarget[i] = self:Spawn("arena"..i.."target", "oUF_Arena"..i.."Target")
			if i == 1 then
				arenatarget[i]:SetPoint("TOPRIGHT", arena[i], "TOPLEFT", pixelScale(112 * oUF_Caellian.config.scale - 112) - pixelScale(7.5), 0)
			else
				arenatarget[i]:SetPoint("TOP", arenatarget[i-1], "BOTTOM", 0, pixelScale(-26.5 * oUF_Caellian.config.scale))
			end
		end

		for i, v in ipairs(arenatarget) do v:Show() end

		local arenaprep = {}
		for i = 1, 5 do
			arenaprep[i] = CreateFrame("Frame", "oUF_Caellian_ArenaPrep"..i, UIParent)
--			arenaprep[i] = self:Spawn("arena"..i, "oUF_Caellian_ArenaPrep"..i)
			arenaprep[i]:SetAllPoints(_G["oUF_Arena"..i])

			arenaprep[i].Health = CreateFrame("StatusBar", nil, arenaprep[i])
			arenaprep[i].Health:SetAllPoints()
			arenaprep[i].Health:SetStatusBarTexture(caelMedia.files.statusBarCb)

			arenaprep[i].Spec = oUF_Caellian.SetFontString(arenaprep[i].Health, oUF_Caellian.config.font, 9)
			arenaprep[i].Spec:SetPoint("CENTER")

			arenaprep[i].FrameBackdrop = CreateFrame("Frame", nil, arenaprep[i])
			arenaprep[i].FrameBackdrop:SetFrameLevel(arenaprep[i]:GetFrameLevel() - 1)
			arenaprep[i].FrameBackdrop:SetPoint("TOPLEFT", pixelScale(-3), pixelScale(3))
			arenaprep[i].FrameBackdrop:SetPoint("BOTTOMRIGHT", pixelScale(3), pixelScale(-3))
			arenaprep[i].FrameBackdrop:SetFrameStrata("MEDIUM")
			arenaprep[i].FrameBackdrop:SetBackdrop(caelMedia.backdropTable)
			arenaprep[i].FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
			arenaprep[i].FrameBackdrop:SetBackdropBorderColor(0, 0, 0)

			arenaprep[i]:Hide()
		end

		local arenaprepupdate = oUF_Caellian.createModule("ArenaPrepUpdate")
		arenaprepupdate:RegisterEvent("PLAYER_LOGIN")
		arenaprepupdate:RegisterEvent("PLAYER_ENTERING_WORLD")
		arenaprepupdate:RegisterEvent("ARENA_OPPONENT_UPDATE")
		arenaprepupdate:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		arenaprepupdate:SetScript("OnEvent", function(self, event)
			if event == "PLAYER_LOGIN" then
				for i = 1, 5 do
					arenaprep[i]:SetAllPoints(_G["oUF_Arena"..i])
				end
			elseif event == "ARENA_OPPONENT_UPDATE" then
				for i = 1, 5 do
					arenaprep[i]:Hide()
				end
			else
				local numOpps = GetNumArenaOpponentSpecs()

				if numOpps > 0 then
					for i = 1, 5 do
						local frame = arenaprep[i]

						if i <= numOpps then
							local opponentSpec = GetArenaOpponentSpec(i)
							local _, spec, class = nil, "UNKNOWN", "UNKNOWN"

							if opponentSpec and opponentSpec > 0 then
								_, spec, _, _, _, _, class = GetSpecializationInfoByID(opponentSpec)
							end

							frame.Health:SetStatusBarColor(0.17, 0.17, 0.24)

							if class and spec then
								local color = RAID_CLASS_COLORS[class]

								if color then
									frame.Spec:SetFormattedText("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, LOCALIZED_CLASS_NAMES_MALE[class].."  -  "..spec)
								else
									frame.Spec:SetText(spec.."  -  "..LOCALIZED_CLASS_NAMES_MALE[class])
								end

								frame:Show()
							end
						else
							frame:Hide()
						end
					end
				else
					for i = 1, 5 do
						arenaprep[i]:Hide()
					end
				end
			end
		end)
	end
end)

SlashCmdList.TEST_UI = function(msg)
	if msg == "hide" then
		for _, frames in pairs({"oUF_Caellian_Target", "oUF_Caellian_TargetTarget", "oUF_Caellian_Pet", "oUF_Caellian_Focus", "oUF_Caellian_FocusTarget"}) do
			_G[frames].Hide = nil
		end

		for i = 1, 5 do
			_G["oUF_Arena"..i].Hide = nil
			_G["oUF_Arena"..i.."Target"].Hide = nil
			_G["oUF_Caellian_ArenaPrep"..i].Hide = nil -- Not hiding why ?
		end

		for i = 1, MAX_BOSS_FRAMES do
			_G["oUF_Boss"..i].Hide = nil
		end
	else
		for _, frames in pairs({"oUF_Caellian_Target", "oUF_Caellian_TargetTarget", "oUF_Caellian_Pet", "oUF_Caellian_Focus", "oUF_Caellian_FocusTarget"}) do
			_G[frames].Hide = function() end
			_G[frames].unit = "player"
			_G[frames]:Show()
		end

		for i = 1, 5 do
			_G["oUF_Arena"..i].Hide = function() end
			_G["oUF_Arena"..i].unit = "player"
			_G["oUF_Arena"..i]:Show()
			_G["oUF_Arena"..i]:UpdateAllElements()

			_G["oUF_Caellian_ArenaPrep"..i].Hide = function() end
			_G["oUF_Caellian_ArenaPrep"..i].unit = "player"
			_G["oUF_Caellian_ArenaPrep"..i]:Show()
--			_G["oUF_Caellian_ArenaPrep"..i]:UpdateAllElements()

			_G["oUF_Arena"..i.."Target"].Hide = function() end
			_G["oUF_Arena"..i.."Target"].unit = "player"
			_G["oUF_Arena"..i.."Target"]:Show()
			_G["oUF_Arena"..i.."Target"]:UpdateAllElements()
		end

		for i = 1, MAX_BOSS_FRAMES do
			_G["oUF_Boss"..i].Hide = function() end
			_G["oUF_Boss"..i].unit = "player"
			_G["oUF_Boss"..i]:Show()
			_G["oUF_Boss"..i]:UpdateAllElements()
		end

	end
end

SLASH_TEST_UI1 = "/testui"