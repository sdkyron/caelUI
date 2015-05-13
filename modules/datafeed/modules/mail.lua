--[[	$Id: mail.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

local _, caelDataFeeds = ...

caelDataFeeds.mail = caelDataFeeds.createModule("Mail")

local mail = caelDataFeeds.mail

mail.text:SetPoint("CENTER", caelPanel8)

mail:RegisterEvent("UPDATE_PENDING_MAIL")
mail:RegisterEvent("PLAYER_ENTERING_WORLD")

mail:SetScript("OnEvent", function(self, event)
	if HasNewMail() then
		self.text:SetText("new mail", 1, 1, 1)
	else
		self.text:SetText("")
	end
end)

mail:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, caelUI.scale(4))

	local sender1, sender2, sender3 = GetLatestThreeSenders()
	if sender1 then GameTooltip:AddLine("|cffD7BEA51. |r"..sender1) end
	if sender2 then GameTooltip:AddLine("|cffD7BEA52. |r"..sender2) end
	if sender3 then GameTooltip:AddLine("|cffD7BEA53. |r"..sender3) end	
	GameTooltip:Show()
end)