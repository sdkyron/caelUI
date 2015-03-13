--[[	$Id: caelUI.lua 3534 2013-08-24 06:45:50Z sdkyron@gmail.com $	]]

local addon, caelUI = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame.modules = {}

caelUI.createModule = function(name)

    -- Create module frame.
    local module = CreateFrame("Frame", format("caelUIModule%s", name), UIParent)
    frame.modules[name] = module
	
    return module
end

initSchedule = {}

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		if ... ~= addon then return end
		
		self:UnregisterEvent(event)
	
		if not caelUIDB then
			caelUIDB = {}
		end
		
		caelUI.db = caelUIDB
		
		for name, module in pairs(self.modules) do
			if not caelUI.db[name] then
				caelUI.db[name] = {}
			end
			
			module.db = caelUI.db[name]
			
			if (module.initOn) then
				if (module.initOn == "ADDON_LOADED") then
					module:init()
				elseif (module.initOn) then
					self:RegisterEvent(module.initOn)
					if (not initSchedule[module.initOn]) then
						initSchedule[module.initOn] = {}
					end
					
					table.insert(initSchedule[module.initOn], module)
				end
			end
		end
	elseif (initSchedule[event]) then
		for i, module in ipairs(initSchedule[event]) do
			module:init()
		end
		initSchedule[event] = nil
		self:UnregisterEvent(event)
	end
end)