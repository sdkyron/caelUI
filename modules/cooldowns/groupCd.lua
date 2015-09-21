--[[	$Id: groupCd.lua 3652 2013-10-21 06:47:02Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.groupcd = caelUI.createModule("GroupCD")

local pixelScale = caelUI.scale

local show = {
	raid = true,
	party = true,
	arena = true,
}

local spells = {
	[20484]		= 600,	-- Rebirth
	[61999]		= 600,	-- Raise Ally
	[20707]		= 600,	-- Soulstone
	[126393]		= 600,	-- Eternal Guardian (Quilen)
	[159956]		= 600,	-- Dust of Life (Moth)
	[159931]		= 600,	-- Gift of Chi-Ji (Crane)

	[740]			= 180,	-- Tranquility
	[115310]		= 180,	-- Revival
	[64843]		= 180,	-- Divine Hymn
	[108280]		= 180,	-- Healing Tide Totem
	[157535]		= 90,		-- Breath of the Serpent
	[15286]		= 180,	-- Vampiric Embrace
	[108281]		= 120,	-- Ancestral Guidance

	[62618]		= 180,	-- Power Word: Barrier
	[98008]		= 180,	-- Spirit Link Totem
	[31821]		= 180,	-- Devotion Aura
	[51052]		= 120,	-- Anti-Magic Zone
	[97462]		= 180,	-- Rallying Cry
	[88611]		= 180,	-- Smoke Bomb

	[102342]		= 60,		-- Ironbark
	[116849]		= 120,	-- Life Cocoon
	[6940]		= 120,	-- Hand of Sacrifice
	[33206]		= 180,	-- Pain Suppression
	[47788]		= 180,	-- Guardian Spirit
	[114030]		= 120,	-- Vigilance
	[633]			= 600,	-- Lay on Hands
	[114039]		= 600,	-- Hand of Purity

	[32182]		= 300,	-- Heroism
	[2825]		= 300,	-- Bloodlust
	[80353]		= 300,	-- Time Warp
	[90355]		= 300,	-- Ancient Hysteria
	[159916]		= 120,	-- Amplify Magic
	[106898]		= 120,	-- Stampeding Roar
	[172106]		= 180,	-- Aspect of the Fox
}

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local floor, format, gsub = math.floor, string.format, string.gsub

local bars = {}
local timer = 0
local inEncounter

local anchorframe = CreateFrame("Frame", nil, UIParent)
anchorframe:SetSize(143, 14)
anchorframe:SetPoint("TOPLEFT", pixelScale(24), pixelScale(-243))
if UIMovableFrames then table.insert(UIMovableFrames, anchorframe) end

local FormatTime = function(t)
	local day, hour, minute = 86400, 3600, 60
	if t >= day then
		return format("%dd", floor(t/day + 0.5)), t % day
	elseif t >= hour then
		return format("%dh", floor(t/hour + 0.5)), t % hour
	elseif t >= minute then
		if t <= minute * 5 then
			return format("%d:%02d", floor(t/60), t % minute), t - floor(t)
		end
		return format("%dm", floor(t/minute + 0.5)), t % minute
	elseif t >= minute / 12 then
		return floor(t + 0.5), (t * 100 - floor(t * 100))/100
	end
	return format("%.1f", t), (t * 100 - floor(t * 100))/100
end

local SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(0.75, -0.75)

	return fs
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetSize(pixelScale(143), pixelScale(14))
	bar:SetStatusBarTexture(caelMedia.files.statusBarC)
	bar:SetMinMaxValues(0, 100)
	bar.bg = caelMedia.createBackdrop(bar)
	bar.left = SetFontString(bar, caelMedia.fonts.ADDON_FONT, 9, "")
	bar.left:SetPoint("LEFT", pixelScale(2), pixelScale(1))
	bar.left:SetJustifyH("LEFT")
	bar.right = SetFontString(bar, caelMedia.fonts.CUSTOM_NUMBERFONT, 9, "")
	bar.right:SetPoint("RIGHT", pixelScale(-2), pixelScale(1))
	bar.right:SetJustifyH("RIGHT")
	bar.icon = CreateFrame("button", nil, bar)
	bar.icon:SetSize(pixelScale(14), pixelScale(14))
	bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", pixelScale(-5), 0)
	bar.icon.bg = caelMedia.createBackdrop(bar.icon)

	return bar
end

local UpdatePosition = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("TOPLEFT", anchorframe, 0, 0)
		else
			bars[i]:SetPoint("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, pixelScale(-5))
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()

	table.remove(bars, bar.id)
	UpdatePosition()
end

local StartTimer = function(unit, spellId)
	local spell, _, icon = GetSpellInfo(spellId)

	for _, v in pairs(bars) do
		if v.name == name and v.spell == spell then
			return
		end
	end

	local bar = CreateBar()

	bar.startTime = GetTime()
	bar.endTime = GetTime() + spells[spellId]
	bar.left:SetText(gsub(unit, "%s*%-.*", " (*)"))
	bar.right:SetText(FormatTime(spells[spellId]))

	if icon then
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end

	bar.spell = spell
	bar.spellId = spellId

	bar:Show()

	local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]

	bar:SetStatusBarColor(color.r, color.g, color.b)

	bar:SetScript("OnUpdate", function(self, elapsed)
		local curTime = GetTime()

		if self.endTime < curTime then
			StopTimer(self)
			return
		end

		self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
		self.right:SetText(FormatTime(self.endTime - curTime))
	end)

	bar:EnableMouse(true)

	bar:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("RIGHT", self, "LEFT", pixelScale(-23), 0)
		GameTooltip:SetHyperlink(GetSpellLink(spellId))
		GameTooltip:Show()
	end)

	bar:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	bar:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			SendChatMessage(format("Cooldown %s %s: %s", self.left:GetText(), self.spell, self.right:GetText()), GetNumGroupMembers() > 0 and "RAID" or GetNumSubgroupMembers() > 0 and "PARTY" or "SAY")
		elseif button == "RightButton" then
			StopTimer(self)
		end
	end)

	table.insert(bars, bar)

	UpdatePosition()
end

caelUI.groupcd:RegisterEvent("ZONE_CHANGED_NEW_AREA")
caelUI.groupcd:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
caelUI.groupcd:SetScript("OnEvent", function(_, event, _, subEvent, _, _, sourceName, sourceFlags, _, _, _, _, _, spellId)
	local inInstance, instanceType = IsInInstance()

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if bit.band(sourceFlags, filter) == 0 then return end

		if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_CAST_SUCCESS" or subEvent == "SPELL_RESURRECT" then
			if spells[spellId] then
				StartTimer(sourceName, spellId)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and ((UnitIsGhost("player") and instanceType == "raid") or instanceType == "arena" or not IsInGroup()) then
		for k, v in pairs(bars) do
			v.endTime = 0
		end
	end

	if not inEncounter and IsEncounterInProgress() then
		inEncounter = true
	elseif inEncounter and not IsEncounterInProgress() then
		inEncounter = nil
		for k, v in pairs(bars) do
			v.endTime = 0
		end
	end
end)

SlashCmdList["GroupCD"]		= function() 
	StartTimer(UnitName("player"), 20484)	-- Rebirth
	StartTimer(UnitName("player"), 20707)	-- Soulstone
end

SLASH_GroupCD1 = "/groupcd"