--[[	$Id: gmFrame.lua 3525 2013-08-24 05:34:35Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	GM chat frame enhancement	]]

caelUI.gmframe = caelUI.createModule("GMFrame")

local gmframe = caelUI.gmframe

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOP", UIParent, 0, caelUI.scale(-5))

HelpOpenTicketButton:SetParent(Minimap)
HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetPoint("BOTTOMRIGHT")

gmframe:RegisterEvent("ADDON_LOADED")
gmframe:SetScript("OnEvent", function(self, event, name)
	if (event ~= "ADDON_LOADED") or (name ~= "Blizzard_GMChatUI") then return end

	GMChatFrame:EnableMouseWheel()
	GMChatFrame:SetScript("OnMouseWheel", ChatFrame1:GetScript("OnMouseWheel"))
	GMChatFrame:ClearAllPoints()
	GMChatFrame:SetHeight(ChatFrame1:GetHeight())
	GMChatFrame:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, caelUI.scale(38))
	GMChatFrame:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 0, caelUI.scale(38))
	GMChatFrameCloseButton:ClearAllPoints()
	GMChatFrameCloseButton:SetPoint("TOPRIGHT", GMChatFrame, "TOPRIGHT", caelUI.scale(7), caelUI.scale(8))
	GMChatFrameButtonFrame:Hide()
	GMChatFrameEditBox:Hide()
	GMChatFrameResizeButton:Hide()
	GMChatTab:Hide()
	GMChatFrameTop:Hide()
	GMChatFrameTopLeft:Hide()
	GMChatFrameTopRight:Hide()
	GMChatFrameLeft:Hide()
	GMChatFrameRight:Hide()

	enhanceGMFrame = caelUI.dummy
end)