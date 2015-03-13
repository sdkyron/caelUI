--[[	$Id: mirrorBar.lua 3762 2013-12-01 10:50:24Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.mirror = caelUI.createModule("Mirror")

local mirror = caelUI.mirror
local pixelScale = caelUI.scale


local position = {
	["BREATH"] = "TOP#UIParent#TOP#0#-96";
	["EXHAUSTION"] = "TOP#UIParent#TOP#0#-116";
	["FEIGNDEATH"] = "TOP#UIParent#TOP#0#-142";
}

local colors = {
	EXHAUSTION	= {0.69, 0.31, 00.31},
	BREATH		= {0.31, 0.45, 0.63},
	DEATH			= {0.69, 0.31, 00.31},
	FEIGNDEATH	= {0.69, 0.31, 00.31},
}

local Spawn, PauseAll

do
	local barPool = {}

	local loadPosition = function(self)
		local pos = position[self.type]
		local p1, frame, p2, x, y = strsplit("#", pos)

		return self:SetPoint(p1, frame, p2, pixelScale(x), pixelScale(y))
	end

	local OnUpdate = function(self, elapsed)
		if self.paused then return end

		self:SetValue(GetMirrorTimerProgress(self.type) / 1e3)
	end

	local Start = function(self, value, maxvalue, scale, paused, text)
		if paused > 0 then
			self.paused = 1
		elseif self.paused then
			self.paused = nil
		end

		self.text:SetText(text)

		self:SetMinMaxValues(0, maxvalue / 1e3)
		self:SetValue(value / 1e3)

		if not self:IsShown() then self:Show() end
	end

	function Spawn(type)
		if barPool[type] then return barPool[type] end
		local frame = CreateFrame("StatusBar", nil, UIParent)

		frame:SetScript("OnUpdate", OnUpdate)

		local r, g, b = unpack(colors[type])

		local bg = caelMedia.createBackdrop(frame)

		local text = frame:CreateFontString(nil, "OVERLAY")
		text:SetFont(caelMedia.fonts.ADDON_FONT, 9)
		text:SetPoint("CENTER", frame)
		text:SetJustifyH("CENTER")
		text:SetShadowOffset(0, 0)

		frame:SetSize(pixelScale(266), pixelScale(12))

		frame:SetStatusBarTexture(caelMedia.files.statusBarA)
		frame:SetStatusBarColor(r, g, b)

		frame.type = type
		frame.text = text

		frame.Start = Start
		frame.Stop = Stop

		loadPosition(frame)

		barPool[type] = frame
		return frame
	end

	function PauseAll(val)
		for _, bar in next, barPool do
			bar.paused = val
		end
	end
end

mirror:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

function mirror:ADDON_LOADED(addon)
	if addon == "caelUI" then
		UIParent:UnregisterEvent("MIRROR_TIMER_START")

		self:UnregisterEvent("ADDON_LOADED")
		self.ADDON_LOADED = nil
	end
end

function mirror:PLAYER_ENTERING_WORLD()
	for i = 1, MIRRORTIMER_NUMTIMERS do
		local type, value, maxvalue, scale, paused, text = GetMirrorTimerInfo(i)
		if type ~= "UNKNOWN" then
			Spawn(type):Start(value, maxvalue, scale, paused, text)
		end
	end
end

function mirror:MIRROR_TIMER_START(type, value, maxvalue, scale, paused, text)
	return Spawn(type):Start(value, maxvalue, scale, paused, text)
end

function mirror:MIRROR_TIMER_STOP(type)
	return Spawn(type):Hide()
end

function mirror:MIRROR_TIMER_PAUSE(duration)
	return PauseAll((duration > 0 and duration) or nil)
end

for _, event in next, {
	"ADDON_LOADED",
	"MIRROR_TIMER_PAUSE",
	"MIRROR_TIMER_START",
	"MIRROR_TIMER_STOP",
	"PLAYER_ENTERING_WORLD",
} do
	mirror:RegisterEvent(event)
end