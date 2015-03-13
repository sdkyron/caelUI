--[[	$Id: fonts.lua 3902 2014-03-11 15:35:22Z sdkyron@gmail.com $	]]

local _, caelUI = ...

local originalFonts = {
	NORMAL					=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Medium.ttf]],
	BOLD						=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Bold.ttf]],
	BOLDITALIC				=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Bold Italic.ttf]],
	ITALIC					=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Medium Italic.ttf]],
	NUMBER					=	[[Interface\Addons\caelUI\media\fonts\russel square lt.ttf]],

	UNIT_NAME_FONT			=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Medium.ttf]],
--	NAMEPLATE_FONT			=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Medium.ttf]],
	DAMAGE_TEXT_FONT		=	[[Interface\Addons\caelUI\media\fonts\BlankSerif.ttf]],
	STANDARD_TEXT_FONT	=	[[Interface\Addons\caelUI\media\fonts\BlankSerif.ttf]],

	-- Addon related stuff.
	INTERNATIONAL_FONT	=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Medium.ttf]],
	CUSTOM_NUMBERFONT		=	[[Interface\Addons\caelUI\media\fonts\russel square lt.ttf]],
	SCROLLFRAME_NORMAL	=	[[Interface\Addons\caelUI\media\fonts\neuropol nova cd rg.ttf]],
	SCROLLFRAME_BOLD		=	[[Interface\Addons\caelUI\media\fonts\neuropol nova cd bd.ttf]],
	ADDON_FONT				=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Medium.ttf]],
	NAMEPLATE_FONT	=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Medium.ttf]],
	CHAT_FONT				=	[[Interface\Addons\caelUI\media\fonts\ParaType - Magistral Medium.ttf]],
}

local fonts

if caelMedia.customFonts then
	fonts = setmetatable(caelMedia.customFonts, {__index = originalFonts})
else
	fonts = originalFonts
end

caelMedia.fonts = fonts

--	ADDON_FONT			=	[[Interface\Addons\caelUI\media\fonts\DigitalEF-Medium.ttf]],
--	CAELNAMEPLATE_FONT	=	[[Interface\Addons\caelUI\media\fonts\xenara rg.ttf]],
--	CHAT_FONT	 		=	[[Interface\Addons\caelUI\media\fonts\xenara rg.ttf]],