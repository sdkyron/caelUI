--[[	$Id: cooldowns.lua 3492 2013-08-17 06:21:20Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.cooldowns = caelUI.createModule("Cooldowns")

caelUI.cooldowns:Hide()

local minScale = 0.5
local minDuration = 1.5

local floor, format, min = math.floor, string.format, math.min

local day, hour, minute = 86400, 3600, 60

local GetFormattedTime = function(time)
	if time >= day then
		return format("%dd", floor(time/day + 0.5)), time % day
	elseif time >= hour then
		return format("%dh", floor(time/hour + 0.5)), time % hour
	elseif time >= minute then
		local result = format("%dm", floor(time / minute + 0.5)), time % minute

		if time <= minute * 5 then
			result = format("%d:%02d", floor(time / 60), time % minute), time - floor(time)
--			result = format("%d.%d", mm, ss), time - floor(time)
		end

		return result
	elseif time >= minute / 12 then
		return floor(time + 0.5), (time * 100 - floor(time * 100))/100
--		return floor(time + 0.5), time - floor(time)
	end

	return format("%.1f", time), (time * 100 - floor(time * 100))/100
--	return floor(time*10)/10, 0.02 -- time-floor(time*10)/20
end

local TimerUpdate = function(self, elapsed)
	if self.text:IsShown() then
		if self.nextUpdate > 0 then
			self.nextUpdate = self.nextUpdate - elapsed
		else
			if (self:GetEffectiveScale() / UIParent:GetEffectiveScale()) < minScale then
				self.text:SetText("")
				self.nextUpdate = 1
			else
				local remain = self.duration - (GetTime() - self.start)

				if floor(remain + 0.5) > 0 then
					local time, nextUpdate = GetFormattedTime(remain)

					self.text:SetText(time)
					self.nextUpdate = nextUpdate or 0
				else
					self.text:Hide()
				end
			end
		end
	end
end

local TimerCreate = function(self)
	local scale = min(self:GetParent():GetWidth() / 32, 1)

	if scale < minScale then
		self.noOCC = true
	else
		local text = self:CreateFontString(nil, "OVERLAY")
		text:SetPoint("CENTER", 2, 0)
		text:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 12 * scale, "OUTLINE")
		text:SetTextColor(0.84, 0.75, 0.65)
--		text:SetTextColor(244 / 255, 250 / 255, 210 / 255) -- Matt's Dead Palette color
		
		self.text = text
		self:HookScript("OnHide", function(self) self.text:Hide() end)
		self:SetScript("OnUpdate", TimerUpdate)

		return text
	end
end

hooksecurefunc(getmetatable(_G["ActionButton1Cooldown"]).__index, "SetCooldown", function(self, start, duration, charges)
	if self.noOCC  or (charges and charges ~= 0) then return end

	if start > 0 and duration > 1.5 then
		local text = self.text or TimerCreate(self)
		self.start = start
		self.duration = duration
		self.nextUpdate = 0

		if text then
			text:Show()
		end
	else
		if text then
			text:Hide()
		end
	end
end)

local hooked = {}
local active = {}

caelUI.cooldowns:SetScript("OnEvent", function(self, event)
	for cooldown in pairs(active) do
		local button = cooldown:GetParent()
		local start, duration, enable, charges, maxCharges = GetActionCooldown(button.action)
		cooldown:SetCooldown(start, duration, charges, maxCharges)
	end
end)

caelUI.cooldowns:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

local function Cooldown_OnShow(self)
	active[self] = true
end

local function Cooldown_OnHide(self)
	active[self] = nil
end

local function ActionButton_Register(frame)
	local cooldown = frame.cooldown

	if not hooked[cooldown] then
		cooldown:HookScript("OnShow", Cooldown_OnShow)
		cooldown:HookScript("OnHide", Cooldown_OnHide)
		hooked[cooldown] = true
	end
end

for _, frame in pairs(_G["ActionBarButtonEventsFrame"].frames) do
	ActionButton_Register(frame)
end

hooksecurefunc("ActionBarButtonEventsFrame_RegisterFrame", ActionButton_Register)
--[[
hooksecurefunc("CooldownFrame_SetTimer", function(self, start, duration, enable)
	if enable > 0 and duration <= minDuration then
		self:SetAlpha(0)
	else
		self:SetAlpha(1)
	end
end)
--]]