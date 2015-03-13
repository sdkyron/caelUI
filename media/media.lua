--[[	$Id: media.lua 3951 2014-10-28 08:12:52Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.media = caelUI.createModule("Media")

_G["caelMedia"] = caelUI.media

caelMedia.files = {
	bgFile					= [[Interface\ChatFrame\ChatFrameBackground]],
	edgeFile				= [[Interface\Addons\caelUI\media\borders\glowtex3]],
	partyIcon				= [[Interface\Addons\caelUI\media\miscellaneous\partyicon]],
	raidIcon				= [[Interface\Addons\caelUI\media\miscellaneous\raidicon]],
	raidIcons				= [[Interface\Addons\caelUI\media\miscellaneous\raidicons]],
	lfgIcons				= [[Interface\Addons\caelUI\media\miscellaneous\lfgicons]],
	statusBarA				= [[Interface\Addons\caelUI\media\statusbars\normtexa]],
	statusBarB				= [[Interface\Addons\caelUI\media\statusbars\normtexb]],
	statusBarC				= [[Interface\Addons\caelUI\media\statusbars\normtexca]],
	statusBarCb				= [[Interface\Addons\caelUI\media\statusbars\normtexcb]],
	statusBarD				= [[Interface\Addons\caelUI\media\statusbars\normtexd]],
	statusBarE				= [[Interface\Addons\caelUI\media\statusbars\normtexe]],

	buttonNormal			= [[Interface\Addons\caelUI\media\buttons\buttonnormal]],
	buttonPushed			= [[Interface\Addons\caelUI\media\buttons\buttonpushed]],
	buttonChecked			= [[Interface\Addons\caelUI\media\buttons\buttonchecked]],
	buttonHighlight			= [[Interface\Addons\caelUI\media\buttons\buttonhighlight]],
	buttonFlash				= [[Interface\Addons\caelUI\media\buttons\buttonflash]],
	buttonBackdrop			= [[Interface\Addons\caelUI\media\buttons\buttonbackdrop]],
	buttonGloss				= [[Interface\Addons\caelUI\media\buttons\buttongloss]],

	soundAlarm				= [[Interface\Addons\caelUI\media\sounds\alarm.ogg]],
	soundAlert				= [[Interface\Addons\caelUI\media\sounds\alert.ogg]],
	soundLeavingCombat		= [[Interface\Addons\caelUI\media\sounds\combat-.ogg]],
	soundEnteringCombat		= [[Interface\Addons\caelUI\media\sounds\combat+.ogg]],
	soundEnteringPvPZone	= [[Interface\Addons\caelUI\media\sounds\prepareforbattle.ogg]],
	soundCombo				= [[Interface\Addons\caelUI\media\sounds\combo.ogg]],
	soundComboMax			= [[Interface\Addons\caelUI\media\sounds\finish.ogg]],
	soundGodlike			= [[Interface\Addons\caelUI\media\sounds\godlike.ogg]],
	soundLnLProc			= [[Interface\Addons\caelUI\media\sounds\lnl.ogg]],
	soundWarning			= [[Interface\Addons\caelUI\media\sounds\warning.ogg]],
	soundAggro				= [[Interface\Addons\caelUI\media\sounds\aggro.ogg]],
	soundWhisper			= [[Interface\Addons\caelUI\media\sounds\whisper.ogg]],
	soundFinish				= [[Interface\Addons\caelUI\media\sounds\execute.ogg]],
	soundNotification		= [[Interface\Addons\caelUI\media\sounds\notification.ogg]],

	firstblood				= [[Interface\Addons\caelUI\media\sounds\kills\1_firstblood.ogg]],
	doublekill				= [[Interface\Addons\caelUI\media\sounds\kills\2_doublekill.ogg]],
	multikill				= [[Interface\Addons\caelUI\media\sounds\kills\3_multikill.ogg]],
	dominating				= [[Interface\Addons\caelUI\media\sounds\kills\4_dominating.ogg]],
	rampage					= [[Interface\Addons\caelUI\media\sounds\kills\5_rampage.ogg]],
	megakill				= [[Interface\Addons\caelUI\media\sounds\kills\6_megakill.ogg]],
	unstoppable				= [[Interface\Addons\caelUI\media\sounds\kills\7_unstoppable.ogg]],
	ultrakill				= [[Interface\Addons\caelUI\media\sounds\kills\8_ultrakill.ogg]],
	monsterkill				= [[Interface\Addons\caelUI\media\sounds\kills\9_monsterkill.ogg]],
	godlike					= [[Interface\Addons\caelUI\media\sounds\kills\10_godlike.ogg]],
}

--	caelMedia.fontObject = CreateFont("caelMediaFontObject")
--	caelMedia.fontObject:SetFont(caelMedia.files.fontRg, 10, nil)

caelMedia.insetTable = {
    left = caelUI.scale(2),
    right = caelUI.scale(2),
    top = caelUI.scale(2),
    bottom = caelUI.scale(2)
}

caelMedia.backdropTable = {
    bgFile   = caelMedia.files.bgFile,
    edgeFile = caelMedia.files.edgeFile,
    edgeSize = caelUI.scale(2),
    insets   = caelMedia.insetTable
}

caelMedia.borderTable = {
    bgFile   = nil,
    edgeFile = caelMedia.files.edgeFile,
    edgeSize = caelUI.scale(4),
    insets   = caelMedia.insetTable
}

caelMedia.createBackdrop = function(parent)
	local backdrop = CreateFrame("Frame", nil, parent)
	backdrop:SetPoint("TOPLEFT", caelUI.scale(-2.5), caelUI.scale(2.5))
	backdrop:SetPoint("BOTTOMRIGHT", caelUI.scale(2.5), caelUI.scale(-2.5))
	backdrop:SetFrameLevel(parent:GetFrameLevel() -1 > 0 and parent:GetFrameLevel() -1 or 0)
	backdrop:SetBackdrop(caelMedia.backdropTable)
	backdrop:SetBackdropColor(0, 0, 0, 0.5)
	backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	return backdrop
end