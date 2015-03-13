--[[	$Id: captureBar.lua 3525 2013-08-24 05:34:35Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Reskin capture bar	]]

caelUI.capture = caelUI.createModule("Capture")

local capture = caelUI.capture
local pixelScale = caelUI.scale

local barTex = caelMedia.files.statusBarA

capture:SetSize(pixelScale(130), pixelScale(15))
capture:SetPoint("TOP", 0, pixelScale(-75))

local CaptureUpdate = function()
	if not NUM_EXTENDED_UI_FRAMES then return end

	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local bar = _G["WorldStateCaptureBar"..i]

		if bar and bar:IsVisible() then
			bar:ClearAllPoints()
			if i == 1 then
				bar:SetPoint("TOP", capture, "TOP")
			else
				bar:SetPoint("TOPLEFT", _G["WorldStateCaptureBar"..i - 1], "BOTTOMLEFT", 0, pixelScale(-7))
			end

			if not bar.skinned then
				local name = bar:GetName()

				local left = _G[name.."LeftBar"]
				local right = _G[name.."RightBar"]
				local middle = _G[name.."MiddleBar"]

				left:SetTexture(barTex)
				right:SetTexture(barTex)
				middle:SetTexture(barTex)

				left:SetVertexColor(0.31, 0.45, 0.63)
				right:SetVertexColor(0.69, 0.31, 0.31)
				middle:SetVertexColor(0.84, 0.75, 0.65)

				for _, textures in pairs{
					_G[name.."LeftLine"],
					_G[name.."RightLine"],
					_G[name.."LeftIconHighlight"],
					_G[name.."RightIconHighlight"]
				} do
					textures:SetAlpha(0)
				end

				select(4, bar:GetRegions()):Hide()
				
				bar.bg = caelMedia.createBackdrop(bar)
				bar.bg:SetPoint("TOPLEFT", _G[name.."LeftBar"], pixelScale(-2), pixelScale(2))
				bar.bg:SetPoint("BOTTOMRIGHT", _G[name.."RightBar"], pixelScale(2), pixelScale(-2))

				bar.skinned = true
			end
		end
	end
end

hooksecurefunc("UIParent_ManageFramePositions", CaptureUpdate)