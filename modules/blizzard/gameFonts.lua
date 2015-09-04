--[[	$Id: gameFonts.lua 3813 2013-12-28 10:50:05Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.gameFonts = caelUI.createModule("gameFonts")
gameFonts = caelUI.gameFonts

local fonts = caelMedia.fonts

local SetFont = function(object, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	object:SetFont(font, size, style)
	if sr and sg and sb then
		object:SetShadowColor(sr, sg, sb)
	end

	if sox and soy then
		object:SetShadowOffset(sox, soy)
	end

	if r and g and b then
		object:SetTextColor(r, g, b)
	elseif r then
		object:SetAlpha(r)
	end
end

gameFonts:RegisterEvent("ADDON_LOADED")
gameFonts:SetScript("OnEvent", function(self, event, addon)

	if addon ~= "caelUI" then return end

	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}

	UNIT_NAME_FONT     = fonts.UNIT_NAME_FONT
	NAMEPLATE_FONT     = fonts.NAMEPLATE_FONT
	DAMAGE_TEXT_FONT   = fonts.DAMAGE_TEXT_FONT
--	STANDARD_TEXT_FONT = fonts.STANDARD_TEXT_FONT

	SetFont(AchievementFont_Small,						fonts.BOLD,			9)
	SetFont(BossEmoteNormalHuge,							fonts.BOLDITALIC,	18,	"THICKOUTLINE")
	SetFont(CombatTextFont,									fonts.NORMAL,		18)
	SetFont(CoreAbilityFont,								fonts.BOLD,			15)
	SetFont(DestinyFontLarge,								fonts.BOLD,			15)
	SetFont(DestinyFontHuge,								fonts.BOLD,			18)
	SetFont(ErrorFont,										fonts.ITALIC,		11)
	SetFont(FriendsFont_Normal,							fonts.NORMAL,		11)
	SetFont(FriendsFont_Small,								fonts.NORMAL,		9)
	SetFont(FriendsFont_Large,								fonts.NORMAL,		15)
	SetFont(FriendsFont_UserText,							fonts.NORMAL,		11)
	SetFont(GameFont_Gigantic,								fonts.BOLD,			24)
	SetFont(GameTooltipHeader,								fonts.BOLD,			11,	"OUTLINE")
	SetFont(InvoiceFont_Med,								fonts.ITALIC,		11)
	SetFont(InvoiceFont_Small,								fonts.ITALIC,		9)
	SetFont(MailFont_Large,									fonts.ITALIC,		11)
	SetFont(NumberFont_OutlineThick_Mono_Small,		fonts.NUMBER,		9,		"OUTLINE")
	SetFont(NumberFont_Outline_Med,						fonts.NUMBER,		11,	"OUTLINE")
	SetFont(NumberFont_Outline_Large,					fonts.NUMBER,		15,	"OUTLINE")
	SetFont(NumberFont_Outline_Huge,						fonts.NUMBER,		18,	"THICKOUTLINE")
	SetFont(NumberFont_Shadow_Small,						fonts.NORMAL,		9)
	SetFont(NumberFont_Shadow_Med,						fonts.NORMAL,		11)
	SetFont(QuestFont_Shadow_Small,						fonts.NORMAL,		9)
	SetFont(QuestFontNormalSmall,							fonts.BOLD,			11)
	SetFont(QuestFont_Large,								fonts.NORMAL,		15)
	SetFont(QuestFont_Shadow_Huge,						fonts.BOLD,			18)
	SetFont(QuestFont_Super_Huge,							fonts.BOLD,			21)
	SetFont(ReputationDetailFont,							fonts.BOLD,			9)
	SetFont(SpellFont_Small,								fonts.BOLD,			9)
	SetFont(SystemFont_Tiny,								fonts.NORMAL,		8)
	SetFont(SystemFont_Small,								fonts.NORMAL,		9)
	SetFont(SystemFont_Outline_Small,					fonts.NUMBER,		9,		"OUTLINE")
	SetFont(SystemFont_InverseShadow_Small,			fonts.BOLD,			9)
	SetFont(SystemFont_Med1,								fonts.NORMAL,		11)
	SetFont(SystemFont_Med2,								fonts.ITALIC,		12)
	SetFont(SystemFont_Med3,								fonts.NORMAL,		13)
	SetFont(SystemFont_Large,								fonts.NORMAL,		15)
	SetFont(SystemFont_Outline,							fonts.NORMAL,		11,	"OUTLINE")
	SetFont(SystemFont_Huge1,								fonts.NORMAL,		18)
	SetFont(SystemFont_Shadow_Small,						fonts.BOLD,			9)
	SetFont(SystemFont_Shadow_Med1,						fonts.NORMAL,		11)
	SetFont(SystemFont_Shadow_Med1_Outline,			fonts.NORMAL,		11,	"OUTLINE")
	SetFont(SystemFont_Shadow_Med2,						fonts.NORMAL,		12)
	SetFont(SystemFont_Shadow_Med3,						fonts.NORMAL,		13)
	SetFont(SystemFont_Shadow_Large,						fonts.NORMAL,		15)
	SetFont(SystemFont_Shadow_Large_Outline,			fonts.NORMAL,		15,	"OUTLINE")
	SetFont(SystemFont_Shadow_Huge1,						fonts.BOLD,			18)
	SetFont(SystemFont_Shadow_Huge3,						fonts.BOLD,			18)
	SetFont(SystemFont_OutlineThick_Huge2,				fonts.NORMAL,		18,	"THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_Huge4,				fonts.BOLDITALIC,	18,	"THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_WTF,				fonts.BOLDITALIC,	21, 	"THICKOUTLINE")
	SetFont(SystemFont_Shadow_Outline_Huge2,			fonts.NORMAL,		18,	"OUTLINE")
	SetFont(Tooltip_Small,									fonts.BOLD,			9)
	SetFont(Tooltip_Med,										fonts.NORMAL,		11)
	SetFont(WorldMapTextFont,								fonts.BOLDITALIC,	18,	"THICKOUTLINE")

	for i = 1, NUM_CHAT_WINDOWS do
		local frame =_G[format("ChatFrame%s", i)]
		local _, size = frame:GetFont()
		frame:SetFont(fonts.CHAT_FONT, size)
	end

	for i = 1, MAX_CHANNEL_BUTTONS do
		local frame = _G["ChannelButton"..i.."Text"]
		frame:SetFontObject(GameFontNormalSmallLeft)
	end

	for _,button in pairs(PaperDollTitlesPane.buttons) do button.text:SetFontObject(GameFontHighlightSmallLeft) end

	SetFont = nil
	self:SetScript("OnEvent", nil)
	self:UnregisterAllEvents()
	self = nil
end)