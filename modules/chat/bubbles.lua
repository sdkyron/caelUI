--[[	$Id: bubbles.lua 3536 2013-08-24 16:19:22Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.chatbubbles = caelUI.createModule("ChatBubbles")

--	local bubbles = {}

local SkinBubble = function(frame)
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			frame.text = region
			frame.text:SetFont(caelMedia.fonts.CHAT_FONT, 9)
			frame.text:SetJustifyH("CENTER")
			frame.text:SetShadowColor(0, 0, 0)
			frame.text:SetShadowOffset(0.75, -0.75)
		end
	end

	frame:SetBackdrop(caelMedia.backdropTable)
	frame:SetBackdropBorderColor(0, 0, 0)
	frame:SetBackdropColor(0, 0, 0, 0.33)
	frame:SetClampedToScreen(false)

--	tinsert(bubbles, frame)
end

local numKids = 0
local lastUpdate = 0
caelUI.chatbubbles:SetScript("OnUpdate", function(self, elapsed)
	lastUpdate = lastUpdate + elapsed

	if lastUpdate > 0.1 then
		lastUpdate = 0

		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i = numKids + 1, newNumKids do
				local frame = select(i, WorldFrame:GetChildren())
				local backdrop = frame:GetBackdrop()

				if backdrop and backdrop.bgFile == [[Interface\Tooltips\ChatBubble-Background]] then
					SkinBubble(frame)
				end
			end
			numKids = newNumKids
		end
--[[
		for i, frame in next, bubbles do
			local r, g, b = frame.text:GetTextColor()
			frame:SetBackdropBorderColor(r, g, b)
		end
--]]
	end
end)