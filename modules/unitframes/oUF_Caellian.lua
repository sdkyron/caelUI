--[[	$Id: oUF_Caellian.lua 3492 2013-08-17 06:21:20Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

oUF = oUF_Caellian.oUF

oUF_Caellian.createModule = function(name)

    -- Create module frame.
	local module = CreateFrame("Frame", format("oUF_CaellianModule%s", name), UIParent)

	return module
end