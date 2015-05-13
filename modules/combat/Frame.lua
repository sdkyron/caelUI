--[[	$Id: Frame.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.combatlogframe = caelUI.createModule("CombatLogFrame")

local frame = caelUI.combatlogframe

frame:SetWidth(caelUI.scale(311.5))
frame:SetHeight(caelUI.scale(104.5))
frame:SetPoint("BOTTOM", UIParent, "BOTTOM", caelUI.scale(-401), caelUI.scale(43))

RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")

local function ScrollFrame(self, delta)
	if delta > 0 then
		for i = 1, #self:GetParent().collumns do
			if IsShiftKeyDown() then
				self:GetParent().collumns[i]:ScrollToTop()
			else
				self:GetParent().collumns[i]:ScrollUp()
			end
		end
	elseif delta < 0 then
		for i = 1, #self:GetParent().collumns do
			if IsShiftKeyDown() then
				self:GetParent().collumns[i]:ScrollToBottom()
			else
				self:GetParent().collumns[i]:ScrollDown()
			end
		end
	end
end

local function OnHyperlinkEnter(self, data, link)
	local linktype, contents = data:sub(1,4),data:sub(6)
	if linktype == "Clog" and contents ~= "" then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:SetText(data:sub(6))
		GameTooltip:Show()
	end
end

local function OnHyperlinkLeave(self)
	GameTooltip:Hide()
end

local function OnHyperlinkClick(self, data, link)
	local linktype, contents = data:sub(1, 4), data:sub(6)
	if linktype == "Clog" and contents ~= "" and IsShiftKeyDown() then
		local chatType = ChatFrame1EditBox:GetAttribute("chatType")
		local tellTarget = ChatFrame1EditBox:GetAttribute("tellTarget")
		local channelTarget = ChatFrame1EditBox:GetAttribute("channelTarget")
--		ChatFrame1EditBox:Show()
		local from, to, pos
		for i = 1, 5 do
			from, to = string.find(contents, "\n", pos or 1)
			SendChatMessage(string.sub(contents, pos or 1, (from or 0) - 1), chatType, GetDefaultLanguage("player"), tellTarget or channelTarget)
			if not from then return end
			pos = (to or 0) + 1
		end
--	ChatFrame1EditBox:Insert(contents:gsub("\n", " | "))
	end
end

local function OnLeave(self)
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide()
	end
end

frame.collumns = {}
for i = 1, 3 do
   local smf = CreateFrame("ScrollingMessageFrame", nil, frame)
    smf:SetMaxLines(1000)
    smf:SetFont(caelMedia.fonts.ADDON_FONT, 9)
    smf:SetSpacing(2)
    smf:SetFading(true)
	smf:SetFadeDuration(5)
	smf:SetTimeVisible(20)
	smf:SetScript("OnMouseWheel", ScrollFrame)
	smf:EnableMouse(true)
	smf:EnableMouseWheel(true)
	smf:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
	smf:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
	smf:SetScript("OnHyperlinkClick", OnHyperlinkClick)
	smf:SetScript("OnLeave", OnLeave)
	if i == 1 or i == 3 then
		smf:SetWidth(frame:GetWidth()/3 - 45)
	else
		smf:SetWidth(frame:GetWidth()/3 + 82)
	end
	frame.collumns[i] = smf
end

frame.collumns[1]:SetPoint("TOPLEFT")
frame.collumns[1]:SetPoint("BOTTOMLEFT")
frame.collumns[2]:SetPoint("TOP")
frame.collumns[2]:SetPoint("BOTTOM")
frame.collumns[3]:SetPoint("TOPRIGHT")
frame.collumns[3]:SetPoint("BOTTOMRIGHT")

frame.collumns[1]:SetJustifyH("LEFT")
frame.collumns[2]:SetJustifyH("CENTER")
frame.collumns[3]:SetJustifyH("RIGHT")

--local icon = "Interface\\LFGFrame\\LFGRole"
local icon = [[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]]

local tex1 = frame:CreateTexture(nil, "ARTWORK")
tex1:SetSize(caelUI.scale(14), caelUI.scale(14))
tex1:SetTexture(icon)
--tex1:SetTexCoord(1/2, 0, 1/2, 1, 3/4, 0, 3/4, 1)
tex1:SetTexCoord(0, 19/64, 22/64, 41/64)
tex1:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, caelUI.scale(-5))

local tex2 = frame:CreateTexture(nil, "ARTWORK")
tex2:SetSize(caelUI.scale(14), caelUI.scale(14))
tex2:SetTexture(icon)
--tex2:SetTexCoord(3/4, 0, 3/4, 1, 1, 0, 1, 1)
tex2:SetTexCoord(20/64, 39/64, 1/64, 20/64)
tex2:SetPoint("TOP", frame, "BOTTOM", 0, caelUI.scale(-5))

local tex3 = frame:CreateTexture(nil, "ARTWORK")
tex3:SetSize(caelUI.scale(14), caelUI.scale(14))
tex3:SetTexture(icon)
--tex3:SetTexCoord(1/4, 0, 1/4, 1, 1/2, 0, 1/2, 1)
tex3:SetTexCoord(20/64, 39/64, 22/64, 41/64)
tex3:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, caelUI.scale(-5))