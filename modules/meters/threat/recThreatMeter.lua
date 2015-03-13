--[[	$Id: recThreatMeter.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

group_threat = {}

local display_frame = CreateFrame("Frame", "recThreatMeter", UIParent)

RegisterStateDriver(display_frame, "visibility", "[petbattle] hide; show")

local table_sort, string_format = table.sort, string.format
local math_floor, tonumber = math.floor, tonumber
local UnitName = UnitName
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local need_reset = true
local warning_played, i_am_tank, target_okay
local top_threat, overtake_threat, my_threat = 0, -1, -1
local HIDDEN, TANKING, BLANK = "* %s", ">>> %s <<<", " "
local WARNING		= caelMedia.files.soundWarning
local AGGRO			= caelMedia.files.sounsAggro

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local recycle_bin = {}
local function Recycler(trash_table)
	if trash_table then
		-- Recycle trash_table
		for k,v in pairs(trash_table) do
			if type(v) == "table" then
				Recycler(v)
			end
			trash_table[k] = nil
		end
		recycle_bin[(#recycle_bin or 0) + 1] = trash_table
	else
		-- Return recycled table, or new table if there are no used ones to give.
		if #recycle_bin and #recycle_bin > 0 then
			return table.remove(recycle_bin, 1)
		else
			return {}
		end
	end
end

-- Sorting functions
local function sortfunc(a,b) return (a.threat or 0) > (b.threat or 0) end
local function SortThreat()
	if #group_threat and #group_threat > 0 then
		table_sort(group_threat, sortfunc)
	end
end

local smooth_bars = Recycler()
local smooth_update = CreateFrame("Frame")
local function SmoothUpdate()
        local rate = GetFramerate()
        local limit = 30/rate
        for index, data in pairs(smooth_bars) do
                local cur = display_frame.bars[index]:GetValue()
                local new = cur + min((data.value-cur)/3, max(data.value-cur, limit))
                if new ~= new then
                        -- Mad hax to prevent QNAN.
                        new = data.value
                end
                display_frame.bars[index]:SetValue(new)
				display_frame.bars[index].lefttext:SetText(data.left or " ")
				display_frame.bars[index].righttext:SetText(data.right or " ")
                if cur == data.value or abs(new - data.value) < 2 then
                        display_frame.bars[index]:SetValue(data.value)
						display_frame.bars[index].lefttext:SetText(data.left or " ")
						display_frame.bars[index].righttext:SetText(data.right or " ")
                        local temp = smooth_bars[index]
						smooth_bars[index] = nil
						Recycler(temp)
                end
        end
		if not smooth_bars or #smooth_bars == 0 then
			smooth_update:SetScript('OnUpdate', nil)
		end
end
local function SetBarValues(index, value, left, right)
	if value ~= display_frame.bars[index]:GetValue() or value == 0 then
		smooth_bars[index] = smooth_bars[index] or Recycler()
		smooth_bars[index].value = value or 0
		smooth_bars[index].left = left or " "
		smooth_bars[index].right = right or " "
		smooth_update:SetScript('OnUpdate', SmoothUpdate)
	else
		local temp = smooth_bars[index]
		smooth_bars[index] = nil
		Recycler(temp)
	end
	
	-- Simply leave out value, left and/or right to reset the value(s) to a zeroed state.
	--display_frame.bars[index]:SetValue(value or 0)
	--display_frame.bars[index].lefttext:SetText(left or " ")
	--display_frame.bars[index].righttext:SetText(right or " ")
end

-- Determines unit's position in our threat table, or adds them if they are not present
-- Then updates their threat data.
local function UpdateUnitThreat(unit_id)
	local unit_name = UnitName(unit_id)
	local updated = false
	if unit_name then
		for i, data in pairs(group_threat) do
			if data.name == unit_name then

				-- Sometimes names get set as 'Unknown'.  This should resolve that issue.
				if group_threat[i].name == "Unknown" then group_threat[i].name = unit_name end

				-- We use this as a flag to determine that we had this unit in our threat table.
				updated = true

				-- Obtain threat info about this unit.
				local tanking, state, scaled_percent, raw_percent, threat = UnitDetailedThreatSituation(unit_id, "target")

				if threat then

					-- Compensate for Mirror Images, Fade
					if threat < 0 then
						threat = threat + 410065408
						group_threat[i].threat_hidden = true
					else
						group_threat[i].threat_hidden = false
					end

					-- If threat level is zero at this point, then we're just going to hide the user's threat by setting it to -1
					if threat == 0 then threat = -1 end

					-- Save the highest threat value for later (TODO: Use this instead of 1.3 below to provide overtake bar)
					if threat > top_threat then top_threat = threat end

					if tanking then

						-- Save the threat needed to overtake this unit if they are tanking.
						overtake_threat = threat * 1.1
						if not(group_threat[i].tanking) and warning_played then

							-- If we were not tanking before, and we were warned, then play aggro sound.
--							PlaySoundFile(AGGRO)
						end

						-- Flag this unit as tanking, for special formatting on the bars.
						group_threat[i].tanking = true
					else

						-- Flag this unit as not tanking.
						group_threat[i].tanking = false
					end

					-- Deposit this unit's threat into our table
					group_threat[i].threat = threat

					-- If this is the player, then we save some special flags
					if data.name == UnitName("player") then
						my_threat = threat
						i_am_tank = group_threat[i].tanking
					end
				else
					-- unit is not on target's threat table.
					group_threat[i].threat = -1
					group_threat[i].tanking = false
					group_threat[i].threat_hidden = false
				end
			end
		end

		-- If we haven't updated, then we don't have this unit in our threat table, so we'll add them, and then check them again.
		if not updated then
			group_threat[(#group_threat or 0)+1] = { name = unit_name, threat = -1, threat_hidden = false, tanking = false }
			UpdateUnitThreat(unit_id)
		end
	end
end

local function UpdateDisplay()
	-- If we have no data, then, zero out everything.
	if not(#group_threat) or #group_threat < 1 or not(UnitName("target")) then
		for i = 1, 10 do
			display_frame.bars[i]:SetMinMaxValues(0, 1)
			SetBarValues(i)
		end
		return
	end

	-- Whether to sound a warning for the user or not, and resets our warning played
	-- flag if the user slips back under 80% threat.
	if not(i_am_tank) and my_threat >= (top_threat * 0.8) and not(warning_played) then
--		PlaySoundFile(WARNING)
		warning_played = true
	elseif my_threat < (top_threat * 0.8) then
		warning_played = false
	end

	for i = 1, 10 do

		-- Set the bar's max value to the take aggro level, if present.
		display_frame.bars[i]:SetMinMaxValues(0, group_threat[1] and group_threat[1].threat > -1 and (tonumber(group_threat[1].threat)) or 1)
		if i == 1 then
			display_frame.bars[i]:SetValue(tonumber(group_threat[i].threat) or 0,
				string_format(group_threat[i].threat_hidden and HIDDEN or group_threat[i].tanking and TANKING or "%s", group_threat[i].name),
				ShortValue(tonumber(group_threat[i].threat)) or 0
			)
		end

		if group_threat[i] and group_threat[i].threat > -1 then
			SetBarValues(i,
				tonumber(group_threat[i].threat) or 0,
				string_format(group_threat[i].threat_hidden and HIDDEN or group_threat[i].tanking and TANKING or "%s", group_threat[i].name),
				ShortValue(tonumber(group_threat[i].threat)) or 0
			)

			-- Color bar by class if we can obtain the info.
			local _, class = UnitClass(group_threat[i].name)
			if class then
				display_frame.bars[i]:SetStatusBarColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b, 0.8) -- by class
			elseif group_threat[i].name == "Aggro" then
				display_frame.bars[i]:SetStatusBarColor(1, 0, 0, 0.8)
			else
				display_frame.bars[i]:SetStatusBarColor(1, 1, 1, 0.8)
			end
		else
			SetBarValues(i)
		end
	end
end

local function UpdateThreat()
	if not target_okay then
		UpdateDisplay()
	end

	if IsInGroup() or IsInRaid() then
		if IsInRaid() then
			for i = 1, GetNumGroupMembers() do
				UpdateUnitThreat(string_format("raid%d", i))
				UpdateUnitThreat(string_format("raidpet%d", i))
			end
		else
			for i = 1, GetNumGroupMembers() do
				UpdateUnitThreat(string_format("party%d", i))
				UpdateUnitThreat(string_format("partypet%d", i))
			end
		end
	end

	if not IsInRaid() then
		UpdateUnitThreat("player")
		UpdateUnitThreat("pet")
	end
	
	UpdateUnitThreat("targettarget")

	-- Add in our overtake threat line
	local overtake_set
	for k,v in pairs(group_threat) do
		if v.name == "Aggro" then
			v.threat = overtake_threat or -1
			overtake_set = true
		end
	end
	if not overtake_set then
		group_threat[(#group_threat or 0)+1] = { name = "Aggro", threat = overtake_threat or -1, threat_hidden = false, tanking = false }
	end

	SortThreat()
	UpdateDisplay()
end

local function MakeDisplay()
	local f = display_frame
	f:SetWidth(caelUI.scale(159))
	f:SetHeight(caelUI.scale(134))
	f:SetPoint("BOTTOM", UIParent, "BOTTOM", caelUI.scale(647), caelUI.scale(23))

	f.texture = f:CreateTexture()
	f.texture:SetAllPoints()
	f.texture:SetTexture(0,0,0,0)
	f.texture:SetDrawLayer("BACKGROUND")

	f.titletext = f:CreateFontString(nil, "ARTWORK")
	f.titletext:SetFont(caelMedia.fonts.ADDON_FONT, 9)
	f.titletext:SetText("Threat")
	f.titletext:SetPoint("TOP", f, "TOP", 0, 0)

	-- Add some bars!
	f.bars = Recycler()
	for i = 1, 10 do
		f.bars[i] = CreateFrame("StatusBar", nil, f)
		f.bars[i]:SetWidth(caelUI.scale(159))
		f.bars[i]:SetHeight(12.35)
		f.bars[i]:SetMinMaxValues(0, 1)
		f.bars[i]:SetOrientation("HORIZONTAL")
		f.bars[i]:SetStatusBarColor(1, 1, 1, 0.8)
		f.bars[i]:SetStatusBarTexture(caelMedia.files.statusBarC)
		f.bars[i]:SetPoint("TOPLEFT", i == 1 and f or f.bars[i-1], i == 1 and "TOPLEFT" or "BOTTOMLEFT", caelUI.scale(i == 1 and 2 or 0), caelUI.scale(i == 1 and -10 or -1))
		f.bars[i]:SetPoint("TOPRIGHT", i == 1 and f or f.bars[i-1], i == 1 and "TOPRIGHT" or "BOTTOMRIGHT", caelUI.scale(i == 1 and -2 or 0), caelUI.scale(i == 1 and -10 or -1))
		f.bars[i].lefttext = f.bars[i]:CreateFontString(nil, "ARTWORK")
		f.bars[i].lefttext:SetFont(caelMedia.fonts.ADDON_FONT, 9)
		f.bars[i].lefttext:SetPoint("LEFT", f.bars[i], "LEFT", 0, caelUI.scale(1))
		f.bars[i].lefttext:Show()
		f.bars[i].righttext = f.bars[i]:CreateFontString(nil, "ARTWORK")
		f.bars[i].righttext:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 9)
		f.bars[i].righttext:SetPoint("RIGHT", f.bars[i], "RIGHT", 0, caelUI.scale(1))
		SetBarValues(i)
	end

	display_frame:HookScript("OnSizeChanged", function(frame, ...)
		-- Truncate bars
		local bar_room
		bar_room = caelUI.scale(floor((recThreatMeter:GetHeight()-40)/10))
		for i = 1, 10 do
			recThreatMeter.bars[i]:Hide()
		end
		if bar_room > 0 then
			for i = 1, bar_room do
				recThreatMeter.bars[i]:Show()
			end
		end
	end)
end

local update_delay = 0.5
local function OnUpdate(self, elapsed)
	update_delay = update_delay - elapsed
	if update_delay <= 0 then
		UpdateThreat()
		update_delay = 0.5
	end
end

local function OnEvent(self, event,...)
	if event == "PLAYER_TARGET_CHANGED" then
		display_frame.titletext:SetText(UnitName("target") or "Threat")
		overtake_threat = -1
		for i = 1, 10 do
			display_frame.bars[i]:SetMinMaxValues(0, 1)
			SetBarValues(i)
		end
		if not UnitIsPlayer("target") and UnitCanAttack("player", "target") and UnitHealth("target") > 0 then
			target_okay = true
		else
			target_okay = false
		end
		UpdateThreat()
		return
	end

	if event == "PLAYER_REGEN_ENABLED" then
		display_frame:SetScript("OnUpdate", nil)
		Recycler(group_threat)
		group_threat = Recycler()
		collectgarbage("collect")
		overtake_threat = -1
		top_threat = -1
		warning_played = false
		my_threat = -1
		i_am_tank = false
		for i=1,10 do
			display_frame.bars[i]:SetMinMaxValues(0, 1)
			SetBarValues(i)
		end
		return
	end

	if event == "PLAYER_REGEN_DISABLED" then
		display_frame:SetScript("OnUpdate", OnUpdate)
		return
	end
end

MakeDisplay()

display_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
display_frame:RegisterEvent("PLAYER_REGEN_DISABLED")
display_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
display_frame:SetScript("OnEvent", OnEvent)