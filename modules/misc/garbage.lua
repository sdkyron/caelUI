--[[	$Id: garbage.lua 3535 2013-08-24 14:49:27Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.garbage = caelUI.createModule("Garbage")

local eventCount = 0
caelUI.garbage:RegisterAllEvents()
caelUI.garbage:HookScript("OnEvent", function(self, event)
	eventCount = eventCount + 1

	if UnitAffectingCombat("player") then return end

	if eventCount > 10000 or event == "PLAYER_ENTERING_WORLD" then
		collectgarbage("collect")
		eventCount = 0
	end
end)