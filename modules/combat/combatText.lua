--[[	$Id: combatText.lua 3536 2013-08-24 16:19:22Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.combattext = caelUI.createModule("CombatText")

local combattext = caelUI.combattext

local blinkId, lastUse = 0, 0

local animStrings, emptyIcons, emptyStrings, emptyTables, scrollFrames = {}, {}, {}, {}, {}

local config = {
	fontNormal		=	caelMedia.fonts.SCROLLFRAME_NORMAL,
	fontSticky		=	caelMedia.fonts.SCROLLFRAME_BOLD,
	flagsNormal		=	"OUTLINE",	-- Some text can be hard to read without it.
	flagsSticky		=	"OUTLINE",
	sizeNormal		=	9,
	sizeSticky		=	12,

	iconSizeNormal	=	16,
	iconSizeSticky	=	24,

	blinkSpeed		=	0.5,
	fadeInTime		=	0.2,	-- Percentage of the animation start spent fading in.
	fadeOutTime		=	0.8,	-- At what percentage should we begin fading out.
	durationNormal	=	5,		-- Time it takes for an animation to complete. (in seconds)
	durationSticky	=	2.5,	-- Time it takes for a sticky animation to complete. (in seconds)
	animPerFrame	=	15,		-- Maximum number of displayed animations in each scrollframe.
	ySpacing		=	10,		-- Minimum spacing between animations.
	speed			=	1,		-- Modifies durationNormal.  1 = 100%
	delay			=	0.015,	-- Frequency of animation updates. (in seconds)
}

local caelCombatTextCreateArea = function(id, height, xOffset, yOffset, textalign, direction, fontNormal, sizeNormal, flagsNormal, fontSticky, sizeSticky, flagsSticky, durationNormal, durationSticky, iconSizeNormal, iconSizeSticky)
	scrollFrames[id] = CreateFrame("Frame", nil, UIParent)
	scrollFrames[id.."sticky"] = CreateFrame("Frame", nil, UIParent)
	-- Enable these two lines to see the scroll area on the screen for more accurate placement, etc
	-- scrollFrames[id]:SetBackdrop({ bgFile = [[Interface\ChatFrame\ChatFrameBackground]], edgeFile = nil, edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0} })
	-- scrollFrames[id]:SetBackdropColor(0, 0, 0, 1)

	-- Set frame width
	scrollFrames[id]:SetWidth(caelUI.scale(1))
	scrollFrames[id.."sticky"]:SetWidth(caelUI.scale(1))

	-- Set frame height
	scrollFrames[id]:SetHeight(caelUI.scale(height))
	scrollFrames[id.."sticky"]:SetHeight(caelUI.scale(height))

	-- Position frame
	scrollFrames[id]:SetPoint("BOTTOM", UIParent, "BOTTOM", caelUI.scale(xOffset), caelUI.scale(yOffset))
	scrollFrames[id.."sticky"]:SetPoint("BOTTOM", UIParent, "BOTTOM", caelUI.scale(xOffset), caelUI.scale(yOffset))

	-- Text alignment
	scrollFrames[id].textalign = textalign
	scrollFrames[id.."sticky"].textalign = textalign

	-- Scroll direction
	scrollFrames[id].direction = direction or "up"
	scrollFrames[id.."sticky"].direction = direction or "up"

	-- Font face
	scrollFrames[id].fontNormal = fontNormal or config.fontNormal
	scrollFrames[id.."sticky"].fontNormal = fontSticky or config.fontSticky

	-- Font size
	scrollFrames[id].sizeNormal = sizeNormal or config.sizeNormal
	scrollFrames[id.."sticky"].sizeNormal = sizeSticky or config.sizeSticky
	
	-- Icon size
	scrollFrames[id].iconSizeNormal = iconSizeNormal or config.iconSizeNormal
	scrollFrames[id.."sticky"].iconSizeNormal = iconSizeSticky or config.iconSizeSticky

	-- Font flags
	scrollFrames[id].flagsNormal = flagsNormal or config.flagsNormal
	scrollFrames[id.."sticky"].flagsNormal = flagsSticky or config.flagsSticky

	-- Create anim_string table
	animStrings[id] = {}
	animStrings[id.."sticky"] = {}

	-- Set movement speed
	scrollFrames[id].moveSpeed = (durationNormal or config.durationNormal) / caelUI.scale(height)
	scrollFrames[id.."sticky"].moveSpeed = (durationSticky or config.durationSticky) / caelUI.scale(height)

	-- Set animation duration
	scrollFrames[id].durationNormal = durationNormal or config.durationNormal
	scrollFrames[id.."sticky"].durationNormal = durationSticky or config.durationSticky
end

local CollisionCheck = function(newtext)
	local destinationScrollArea = animStrings[newtext.scrollarea]
	local currentAnims = #destinationScrollArea
	if currentAnims > 0 then -- Only if there are already animations running

		-- Scale the per pixel time based on the animation speed.
		local perPixelTime = scrollFrames[newtext.scrollarea].moveSpeed / newtext.animationSpeed
		local curtext = newtext -- start with our new string
		local previoustext, previoustime

		-- cycle backwards through the table of fontstrings since our newest ones have the highest index
		for x = currentAnims, 1, -1 do
			previoustext = destinationScrollArea[x]

			if not newtext.sticky then
				-- Calculate the elapsed time for the top point of the previous display event.
				-- TODO: Does this need to be changed since we anchor LEFT and not TOPLEFT?
				previoustime = previoustext.totaltime - (previoustext.fontSize + config.ySpacing) * perPixelTime

				--[[If there is a collision, then we set the older fontstring to a higher animation time
					Which 'pushes' it upward to make room for the new one--]]
				if (previoustime <= curtext.totaltime) then
					previoustext.totaltime = curtext.totaltime + (previoustext.fontSize + config.ySpacing) * perPixelTime
				else
					return -- If there was no collision, then we can safely stop checking for more of them
				end
			else
				previoustext.curpos = previoustext.curpos + (previoustext.fontSize + config.ySpacing)
			end

			-- Check the next one against the current one
			curtext = previoustext
		end
	end
end

local CreateBlinkGroup = function(self) 
	blinkId = blinkId + 1
    self.anim = self:CreateAnimationGroup("Blink"..blinkId) 
    self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn") 
    self.anim.fadein:SetChange(1) 
    self.anim.fadein:SetOrder(2) 
 
    self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut") 
    self.anim.fadeout:SetChange(-1) 
    self.anim.fadeout:SetOrder(1) 
end 
 
local StartBlink = function(self, duration) 
    if not self.anim then 
        CreateBlinkGroup(self) 
    end 
 
    self.anim.fadein:SetDuration(duration) 
    self.anim.fadeout:SetDuration(duration) 
    self.anim:Play() 
end 
 
local StopBlink = function(self) 
    if self.anim then 
        self.anim:Finish() 
    end 
end 

local Move = function(self, elapsed)
	local t
	-- Loop through all active fontstrings
	for k,v in pairs(animStrings) do

		for l,u in pairs(animStrings[k]) do
			t = animStrings[k][l]

			if t and t.inuse then
				--increment it's timer until the animation delay is fulfilled
				t.timer = (t.timer or 0) + elapsed
				if t.timer >= config.delay then

					--[[we store it's elapsed time separately so we can continue to delay
						its animation (so we're not updating every onupdate, but can still
						tell what its full animation duration is)--]]
					t.totaltime = t.totaltime + t.timer

					--[[If the animation is not complete, then we need to animate it by moving
						its Y coord (in our sample scrollarea) the proper amount.  If it is complete,
						then we hide it and flag it for recycling --]]
					local percentDone = t.totaltime / scrollFrames[t.scrollarea].durationNormal
					if (percentDone <= 1) then
						t.text:ClearAllPoints()
						local areaHeight = scrollFrames[t.scrollarea]:GetHeight()
						if not t.sticky then
							-- Scroll the text
							if scrollFrames[t.scrollarea].direction == "up" then
								t.curpos = areaHeight * percentDone -- move up
							else
								t.curpos = areaHeight - (areaHeight * percentDone)
							end
							t.text:SetPoint(scrollFrames[t.scrollarea].textalign, scrollFrames[t.scrollarea], "BOTTOMLEFT", 0, t.curpos)
						else
							-- Static text
							if t.curpos > areaHeight/2 then t.totaltime = 99 end
							t.text:SetPoint(scrollFrames[t.scrollarea].textalign, scrollFrames[t.scrollarea], scrollFrames[t.scrollarea].textalign, 0, t.curpos)
						end

						-- Blink text
						if t.sticky and t.blink then
							if not t.blinking then
								t.text:SetAlpha(1)
								t.icon:SetAlpha(1)
								t.iconOverlay:SetAlpha(1)
								t.blinking = true
							end
							StartBlink(t.text, config.blinkSpeed)
						elseif (percentDone <= config.fadeInTime) then
						-- Fade in
						--if (percentDone <= config.fadeInTime) then
							t.text:SetAlpha(1 * (percentDone / config.fadeInTime))
							if t.icon then
								t.icon:SetAlpha(1 * (percentDone / config.fadeInTime))
								t.iconOverlay:SetAlpha(1 * (percentDone / config.fadeInTime))
							end
						-- Fade out
						elseif (percentDone >= config.fadeOutTime) then
							t.text:SetAlpha(1 * (1 - percentDone) / (1 - config.fadeOutTime))
							if t.icon then
								t.icon:SetAlpha(1 * (1 - percentDone) / (1 - config.fadeOutTime))
								t.iconOverlay:SetAlpha(1 * (1 - percentDone) / (1 - config.fadeOutTime))
							end
						-- Full vis for times inbetween
						else
							t.text:SetAlpha(1)
							if t.icon then
								t.icon:SetAlpha(1)
								t.iconOverlay:SetAlpha(1)
							end
						end
					else
						if t.blink then
							StopBlink(t.text)
							t.blink  = false
							t.blinking = false
						end
						t.text:Hide()
						if t.icon then
							t.icon:Hide()
							t.iconOverlay:Hide()
						end
						t.inuse = false
					end

					t.timer = 0		--reset our animation delay timer
				end
			end

			--Now, we loop backwards through the fontstrings to determine which ones can be recycled
			for j = #animStrings[k], 1, -1 do
				t = animStrings[k][j]
				if not t.inuse then
					table.remove(animStrings[k], j)
					-- Place the used frame into our recycled cache
					emptyStrings[(#emptyStrings or 0) + 1] = t.text
					emptyIcons[(#emptyIcons or 0) + 1] = t.icon
					emptyIcons[(#emptyIcons or 0) + 1] = t.iconOverlay
					for key in next, t do t[key] = nil end
					emptyTables[(#emptyTables or 0)+1] = t
				end
			end
		end
	end
end

caelCombatTextAddText = function(text, icon, isPrefix, sticky, scrollarea, blink)
	if not text or not scrollarea then return end
	local destinationArea
	if not sticky then
		destinationArea = animStrings[scrollarea]
	else
		destinationArea = animStrings[scrollarea.."sticky"]
	end
	if not destinationArea then return end
	local t
	-- If there are too many frames in the animation area, steal one of them first
	if (destinationArea and (#destinationArea or 0) >= config.animPerFrame) then
		t = table.remove(destinationArea, 1)

	-- If there are frames in the recycle bin, then snatch one of them!
	elseif (#emptyTables or 0) > 0 then
		t = table.remove(emptyTables, 1)

	-- If we still don't have a frame, then we'll just have to create a brand new one
	else
		t = {}
	end
	if not t.text then
		t.text = table.remove(emptyStrings, 1) or combattext:CreateFontString(nil, "BORDER")
	end
	
	t.sticky = sticky
	
	-- Set up the icon if needed.
	if icon then
		if not t.icon then
			t.icon = table.remove(emptyIcons, 1) or combattext:CreateTexture(nil, "ARTWORK")
			t.iconOverlay = table.remove(emptyIcons, 1) or combattext:CreateTexture(nil, "OVERLAY")
		end
		
		t.icon:SetTexture(icon)
		t.iconOverlay:SetTexture(caelMedia.files.buttonNormal)
		if isPrefix then
			t.icon:ClearAllPoints()
			t.icon:SetPoint("RIGHT", t.text, "LEFT", t.sticky and -1 or -5, 0)
		else
			t.icon:ClearAllPoints()
			t.icon:SetPoint("LEFT", t.text, "RIGHT", t.sticky and 1 or 5, 0)
		end
		
		t.icon:SetAlpha(1)
		t.icon:Show()
		t.iconOverlay:SetPoint("TOPLEFT", t.icon, -2, 2)
		t.iconOverlay:SetPoint("BOTTOMRIGHT", t.icon, 2, -2)
		t.iconOverlay:SetAlpha(1)
		t.iconOverlay:Show()
		
		if t.sticky then
			t.icon:SetDrawLayer("ARTWORK")
			t.iconOverlay:SetDrawLayer("OVERLAY")
			t.icon:SetSize(scrollFrames[scrollarea.."sticky"].iconSizeNormal, scrollFrames[scrollarea.."sticky"].iconSizeNormal)
		else
			t.icon:SetDrawLayer("BACKGROUND")
			t.iconOverlay:SetDrawLayer("BORDER")
			t.icon:SetSize(scrollFrames[scrollarea].iconSizeNormal, scrollFrames[scrollarea].iconSizeNormal)
		end
	end

	if t.sticky then
		t.fontSize = scrollFrames[scrollarea.."sticky"].sizeNormal
	else
		t.fontSize = scrollFrames[scrollarea].sizeNormal
	end
	if blink then
		t.blink = true
		t.blinking = false
	else
		t.blink = false
		t.blinking = false
	end
	t.text:SetFont(sticky and scrollFrames[scrollarea.."sticky"].fontNormal or scrollFrames[scrollarea].fontNormal, t.fontSize, sticky and scrollFrames[scrollarea.."sticky"].flagsNormal or scrollFrames[scrollarea].flagsNormal)
	t.text:SetText(text)
	t.direction = destinationArea.direction
	t.inuse = true
	t.timer = 0
	t.totaltime = 0
	t.curpos = 0
	t.text:ClearAllPoints()
	if t.sticky then
		t.text:SetPoint(scrollFrames[scrollarea.."sticky"].textalign, scrollFrames[scrollarea.."sticky"], scrollFrames[scrollarea.."sticky"].textalign, 0, 0)
		t.text:SetDrawLayer("OVERLAY") -- on top of normal texts.
	else
		t.text:SetPoint(scrollFrames[scrollarea].textalign, scrollFrames[scrollarea], "BOTTOMLEFT", 0, 0)
		t.text:SetDrawLayer("ARTWORK")
	end
	t.text:SetAlpha(0)
	t.text:Show()
	t.animationSpeed = config.speed
	t.scrollarea = t.sticky and scrollarea.."sticky" or scrollarea

	-- Make sure that adding this fontstring will not collide with anything!
	CollisionCheck(t)

	-- Add the fontstring into our table which gets looped through during the OnUpdate
	destinationArea[#destinationArea+1] = t
	lastUse = 0
end

combattext:SetScript("OnUpdate", function(self, elapsed)
	Move(self, elapsed)
	-- Keep footprint down by releasing stored tables and strings after we've been idle for a bit.
	lastUse = lastUse + elapsed
	if lastUse > 30 then
		if #emptyTables and #emptyTables > 0 then
			emptyTables = {}
		end
		if #emptyStrings and #emptyStrings > 0 then
			emptyStrings = {}
		end
		if #emptyIcons and #emptyIcons > 0 then
			emptyIcons = {}
		end
		lastUse = 0
	end
end)

-- Make your scroll areas
-- Format: caelCombatTextCreateArea(identifier, height, xOffset, yOffset, textalign, direction[, fontNormal][, sizeNormal][, flagsNormal][, fontSticky][, sizeSticky][, flagsSticky][, durationNormal][, durationSticky])
-- Frames are relative to BOTTOM UIParent BOTTOM
--
-- Then you can pipe input into each scroll area using:
-- caelCombatTextAddText(text_to_show, icon_to_show, isPrefix, sticky_style, scroll_area_identifer, is_blinking)
--
caelCombatTextCreateArea("Error", 75, 0, 750, "CENTER", "up", nil, nil, nil, nil, nil, nil, 2.5, 2.5)
caelCombatTextCreateArea("Notification", 110, 0, 585, "CENTER", "down", nil, nil, nil, nil, nil, nil, 3.5, 3.5)
caelCombatTextCreateArea("Information", 100, 0, 160, "CENTER", "down", nil, nil, nil, nil, nil, nil, 2.5, 1.25)
caelCombatTextCreateArea("Outgoing", 150, 162.5, 385, "LEFT", "up")
caelCombatTextCreateArea("Incoming", 150, -162.5, 385, "RIGHT", "down")
caelCombatTextCreateArea("Warning", 50, 0, 435, "CENTER", "up", nil, 15, nil, nil, 15, nil)