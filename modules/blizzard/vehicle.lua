--------------------------------------------------------------------------
-- move vehicle indicator
--------------------------------------------------------------------------

hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(_,_,parent)
	if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:SetPoint("BOTTOM", caelPanel12, "TOP", 0, caelUI.scale(15))
	end
end)

--[[
--------------------------------------------------------------------------
-- vehicule on mouseover because this shit take too much space on screen
--------------------------------------------------------------------------

local numSeat

local VehicleNumSeatIndicator = function()
	if VehicleSeatIndicatorButton1 then
		numSeat = 1
	elseif VehicleSeatIndicatorButton2 then
		numSeat = 2
	elseif VehicleSeatIndicatorButton3 then
		numSeat = 3
	elseif VehicleSeatIndicatorButton4 then
		numSeat = 4
	elseif VehicleSeatIndicatorButton5 then
		numSeat = 5
	elseif VehicleSeatIndicatorButton6 then
		numSeat = 6
	end
end

local VehicleButton = function(alpha)
	for i = 1, numSeat do
	local button = _G["VehicleSeatIndicatorButton"..i]
		button:SetAlpha(alpha)
	end
end

local vehicleMouse = function()
	if VehicleSeatIndicator:IsShown() then
		VehicleSeatIndicator:SetAlpha(0)
		VehicleSeatIndicator:EnableMouse(true)
		
		VehicleNumSeatIndicator()
		
		VehicleSeatIndicator:HookScript("OnEnter", function() VehicleSeatIndicator:SetAlpha(1) VehicleButton(1) end)
		VehicleSeatIndicator:HookScript("OnLeave", function() VehicleSeatIndicator:SetAlpha(0) VehicleButton(0) end)

		for i = 1, numSeat do
			local button = _G["VehicleSeatIndicatorButton"..i]
			button:SetAlpha(0)
			button:HookScript("OnEnter", function(self) VehicleSeatIndicator:SetAlpha(1) VehicleButton(1) end)
			button:HookScript("OnLeave", function(self) VehicleSeatIndicator:SetAlpha(0) VehicleButton(0) end)
		end
	end
end

hooksecurefunc("VehicleSeatIndicator_Update", vehicleMouse)
--]]