local _, caelUI = ...

caelUI.macros = caelUI.createModule("Macros")

-- [[ Config section ]] --
local FavorSpellOverItemIcon = true;
local DefaultStepFunction = "step = step % #macros + 1";

-- [[ End of config section ]] --

caelUI.ActiveMacros = {};
LoadAddOn("Blizzard_MacroUI");
local macros = gM_Macros;

local buttons = {};
local ButtonNamePrefix = "gotMacros_";

local QUESTION_MARK_ICON = "INV_MISC_QUESTIONMARK";
local MACRO_BUTTON_TYPE = 0x1
local SEQUENCER_BUTTON_TYPE = 0x2;

-- [[ Escape sequence support ]] --
local function IsValidForSpec(macroTable, spec)
	if (not spec) then
		spec = GetSpecialization();
	end

	if not macroTable.spec or (spec and macroTable.spec:find(spec)) then
		return true;
	end
end

local function IsValidForClass(macroTable, class)
	if (not class) then
		class = UnitClass("player");
	end

	if (not macroTable.class or macroTable.class == class) then
		return true;
	end
end

local function LevelConditional(wholeMatch)
	local levelComparison, positiveCase, negativeCase = wholeMatch:match("lvl{(.-)%?(.-)|(.+)}");
	if (loadstring("return " .. UnitLevel("player") .. levelComparison)()) then
		return positiveCase;
	else
		return negativeCase;
	end
end

local function TalentConditional(wholeMatch)
	local tier, column, positiveCase, negativeCase = wholeMatch:match("talent{(%d+),(%d+)%?(.-)|(.+)}");
	local talentID, name, texture, selected, available = GetTalentInfo(tier, column, GetActiveSpecGroup());
	if (selected) then
		return positiveCase;
	else
		return negativeCase;
	end
end

local function ParseEscapeSequences(text)
	text = text:gsub("(lvl%b{})", LevelConditional);
	text = text:gsub("(talent%b{})", TalentConditional);
	text = text:gsub("sid{(%d+)}", GetSpellInfo);
	text = text:gsub("iid{(%d+)}", GetItemInfo);
	return text;
end

local function ScrubLeadingWhitespace(text)
	text = text:gsub("\n%s*", "\n");
	text = text:gsub("^%s+", "");
	return text
end

local function SanitizeMacro(Macro)
	if (Macro.show) then
		Macro.show = ScrubLeadingWhitespace(Macro.show):gsub("\n([^#])", "%1"); --Newlines not allowed in show.
	end
	if (Macro.body) then
		Macro.body = ScrubLeadingWhitespace(Macro.body);
	end
	if (Macro.sequence) then
		for Index, Step in ipairs(Macro.sequence) do
			Macro.sequence[Index] = ScrubLeadingWhitespace(Macro.sequence[Index]);
		end

		if (Macro.sequence.PreMacro) then
			Macro.sequence.PreMacro = ScrubLeadingWhitespace(Macro.sequence.PreMacro);
		end
		if (Macro.sequence.PostMacro) then
			Macro.sequence.PostMacro = ScrubLeadingWhitespace(Macro.sequence.PostMacro);
		end
	end
end

local function NoSoundPreClick()
	SetCVar("Sound_EnableSFX", 0);
end

local function NoSoundPostClick()
	SetCVar("Sound_EnableSFX", 1);
end

-- [[ GnomeSequencer support ]] --
-- This implementation is based on Semlar's GnomeSequencer addon version r3.
-- Credits for the original functionality go to Semlar.
-- GnomeSequencer can be found on WoWInterface: www.wowinterface.com/downloads/info23234-GnomeSequencer.html

local function GetSpellOrItemIcon(ActionString, ActionInfo)
	ActionInfo = ActionInfo or {};
	local Action, Target = SecureCmdOptionParse(ActionString);
	ActionInfo.IsSpell = not not GetSpellInfo(Action);
	ActionInfo.Target = Target;
	ActionInfo.Item = not ActionInfo.IsSpell and Action or nil;
	ActionInfo.Spell = ActionInfo.IsSpell and Action or nil;
	return ActionInfo
end

local function GetCastSequenceIcon(ActionString, ActionInfo)
	ActionInfo = ActionInfo or {};
	local CastSequenceString, Target = SecureCmdOptionParse(ActionString);
	if (CastSequenceString) then
		local Index, Item, Spell = QueryCastSequence(CastSequenceString);
		ActionInfo.IsSpell = not Item;
		ActionInfo.Item = Item;
		ActionInfo.Spell = Spell;
		ActionInfo.Target = Target;
	end
	return ActionInfo;
end

local IconCommands = 
{
	show = GetSpellOrItemIcon,
	showtooltip = GetSpellOrItemIcon,
	use = GetSpellOrItemIcon,
	cast = GetSpellOrItemIcon,
	spell = GetSpellOrItemIcon,
	castsequence = GetCastSequenceIcon,
	usesequence = GetCastSequenceIcon
}

local EmptyActionInfo = {}
local TempActionInfo = {};
local function GetActionFromMacro(MacroText)
	local FoundAction = EmptyActionInfo;
	for cmd, etc in gmatch(MacroText or '', '[/#](%w+)%s+([^\n]+)') do
		local Command = strlower(cmd);
		if (IconCommands[Command]) then
			local ActionInfo = IconCommands[Command](etc, TempActionInfo);
			
			if (ActionInfo.IsSpell or not FavorSpellOverItemIcon or Command:find("^show")) then
				FoundAction = ActionInfo;
				break;
			elseif (not FoundAction) then
				FoundAction = ActionInfo;
			end
		end
	end
	return FoundAction;
end

local function SetIconFromAction(SequenceName, Action)
	if (Action.IsSpell) then
		SetMacroSpell("gM_" .. SequenceName, Action.Spell, Action.Target);
	elseif (Action.Item) then
		SetMacroItem("gM_" .. SequenceName, Action.Item, Action.Target);
	end
end

local function GetMacroTextForSequence(Name, Sequence)
	local MacroText = ("#showtooltip %s\n/click %s"):format(Sequence.Show or '', Name);
	return MacroText;
end

local function CopyActionInfo(source, target)
	target.IsSpell = source.IsSpell;
	target.Spell = source.Spell;
	target.Item = source.Item;
	target.Target = source.Target;
end

local function IsActionInfoSimilar(lhs, rhs)
	return lhs and rhs and
		lhs.IsSpell == rhs.IsSpell and
		lhs.Spell == rhs.Spell and
		lhs.Item == rhs.Item and
		lhs.Target == rhs.Target;
end

local function UpdateIcon(self)
	local SequenceName = self:GetName();
	local MacroName = SequenceName:sub(ButtonNamePrefix:len() + 1)
	if (not gM_Macros[MacroName].Show) then
		local step = self:GetAttribute('step') or 1;
		local CurrentAction = GetActionFromMacro(self.Steps[step]);
		if (not IsActionInfoSimilar(CurrentAction, self.CurrentAction)) then
			CopyActionInfo(CurrentAction, self.CurrentAction);
			SetIconFromAction(MacroName, self.CurrentAction);
		end
	end
end

local function UpdateSequencerIcons()
	for name, button in pairs(buttons) do
		if (button.gmType == SEQUENCER_BUTTON_TYPE and not macros[name].Show) then
			button:UpdateIcon();
		end
	end
	C_Timer.After(0.1, UpdateSequencerIcons);
end

local function CreateOnClickFunction(Sequence)
	StepFunction = Sequence.StepFunction or DefaultStepFunction;
	return string.format([=[
		local step = self:GetAttribute('step')
		local repsDone = self:GetAttribute("repsDone")
		self:SetAttribute('macrotext', self:GetAttribute('PreMacro') .. macros[step] .. self:GetAttribute('PostMacro'))
		%s
		if not step or not macros[step] then -- User attempted to write a step method that doesn't work, reset to 1
			print('|cffff0000Invalid step assigned by custom step sequence', self:GetName(), step or 'nil')
			step = 1
		end
		self:SetAttribute('step', step)
		self:SetAttribute('repsDone', repsDone)
		self:CallMethod('UpdateIcon')
	]=], StepFunction);
end

local function CreateSequencerButton(Name, DisableSound)
	if (buttons[Name]) then
		return buttons[Name]
	end
	local Button = CreateFrame("Button", ButtonNamePrefix..Name, nil, "SecureActionButtonTemplate, SecureHandlerBaseTemplate");
	buttons[Name] = Button;

	Button:SetAttribute('type', 'macro')
	--Button:WrapScript(Button, 'OnClick', "self:Execute(self:GetAttribute('OnClickScript'))");
	Button.UpdateIcon = UpdateIcon
	Button.CurrentAction = {};

	if (DisableSound) then
		Button:HookScript("PreClick", NoSoundPreClick);
		Button:HookScript("PostClick", NoSoundPostClick);
	end

	Button.gmType = SEQUENCER_BUTTON_TYPE;
	return Button;
end

local function SetupSequencerButton(Name, Macro)
	local Button = buttons[Name] or CreateSequencerButton(Name, Macro.nosound);
	Button.Steps = {}
	for Index, Step in ipairs(Macro.sequence) do
		Button.Steps[Index] = ParseEscapeSequences(Step);
	end

	Button:Execute('name, macros = self:GetName(), newtable([=======[' .. strjoin(']=======],[=======[', unpack(Button.Steps)) .. ']=======])')
	Button:SetAttribute('step', 1)
	Button:SetAttribute('PreMacro', (Macro.sequence.PreMacro and ParseEscapeSequences(Macro.sequence.PreMacro) or '') .. '\n')
	Button:SetAttribute('PostMacro', '\n' .. (Macro.sequence.PostMacro and ParseEscapeSequences(Macro.sequence.PostMacro) or ''))
	--Button:SetAttribute("OnClickScript", CreateOnClickFunction(Macro.sequence));
	Button:WrapScript(Button, "OnClick", CreateOnClickFunction(Macro.sequence));
	Button:UpdateIcon();
end

local function SetupMacroButton(Name, Macro)
	local btn = buttons[Name];
	if not btn then
		btn = CreateFrame("Button", ButtonNamePrefix..Name, UIParent, "SecureUnitButtonTemplate");
		btn.gmType = MACRO_BUTTON_TYPE;
		buttons[Name] = btn;
	end

	if Macro.nosound then
		btn:SetScript("PreClick", NoSoundPreClick);
		btn:SetScript("PostClick", NoSoundPostClick);
	end

	if Macro.body:len() > 1023 then
		print("Gotai is lazy, no macros longer than 1023 chars plx!");
	end

	btn:SetAttribute("type", "macro");
	btn:SetAttribute("macrotext", ParseEscapeSequences(Macro.body));
end

local function CreateBlizzardMacro(name, perChar, icon)
	if icon then
		icon = icon:match("Interface.Icons.(.+)") or icon;
	end

	local macroname = "gM_"..name:sub(1,13);
	local macrobody = string.format("/click %s", ButtonNamePrefix..name);
	local show = macros[name].show;
	-- Dirty hack, must fix
	if (not show and macros[name].sequence) then
		show = ""
	end
	if show then
		show = string.format("#showtooltip %s\n", ParseEscapeSequences(show));
		
		if show:len() + macrobody:len() <= 255 then
			macrobody = show..macrobody;
		end
	end


	local index = GetMacroIndexByName(macroname)
	if index > 0 then
		EditMacro(index, nil, icon or QUESTION_MARK_ICON, macrobody);
	else
		local Macros, PerCharMacros = GetNumMacros()
		if perChar and PerCharMacros >= MAX_CHARACTER_MACROS then
			perChar = nil;
		end
		if not perChar and Macros >= MAX_ACCOUNT_MACROS then
			return print("Your macro slots are all full, please delete some macros and reload.");
		end
		CreateMacro(macroname, icon or QUESTION_MARK_ICON, macrobody, perChar);
	end
end

local function StripMacroPrefix(Name)
	return Name:match("^gM_(.+)");
end

local function IsGotMacrosMacro(Index)
	return StripMacroPrefix(GetMacroInfo(Index));
end

local function IsRedundantMacro(Index, PlayerClass, CurrentSpec)
	local Name = StripMacroPrefix(GetMacroInfo(Index));
	local IsRedundant = false;
	if (Name) then
		IsRedundant = not macros[Name] or 
			not macros[Name].blizzmacro or 
			not IsValidForClass(macros[Name], PlayerClass) or 
			not IsValidForSpec(macros[Name], CurrentSpec);
	end

	return IsRedundant;
end

local function IsMacroApplicable(Macro, PlayerName, PlayerClass, CurrentSpec)
	local IsValid = (not Macro.char or Macro.char.find(PlayerName)) and
		IsValidForClass(Macro, PlayerClass) and
		IsValidForSpec(Macro, CurrentSpec);

	return IsValid;
end


local function CleanupMacros(PlayerClass, CurrentSpec)
	local NumMacros, NumMacrosPerChar = GetNumMacros();
	for MacroIndex = NumMacros, 1, -1 do
		if (IsRedundantMacro(MacroIndex, PlayerClass, CurrentSpec)) then
			DeleteMacro(MacroIndex);
		end
	end

	for MacroIndex = MAX_ACCOUNT_MACROS + NumMacrosPerChar - 1, MAX_ACCOUNT_MACROS + 1, -1 do
		if (IsRedundantMacro(MacroIndex, PlayerClass, CurrentSpec)) then
			DeleteMacro(MacroIndex);
		end
	end
end

local function UpdateMacros()
	local playerClass = select(2, UnitClass("player"));
	local currentSpec = GetSpecialization();
	local playerName = UnitName("player");
	CleanupMacros(playerClass, currentSpec);

	for Name,Macro in pairs(macros) do
		if (IsMacroApplicable(Macro, playerName, playerClass, currentSpec)) then
			if Macro.blizzmacro then
				CreateBlizzardMacro(Name, Macro.perChar, Macro.icon);
			end

			if (Macro.sequence) then
				SetupSequencerButton(Name, Macro);
			else
				SetupMacroButton(Name, Macro);
			end
		end
	end
end

local OneTimeEvents = {
	PLAYER_REGEN_ENABLED = true,
	PLAYER_ENTERING_WORLD = true
}

caelUI.macros:RegisterEvent("PLAYER_ENTERING_WORLD");
caelUI.macros:SetScript("OnEvent", function(self, event, ...)
	if (OneTimeEvents[event]) then
		self:UnregisterEvent(event);
	end
	
	if InCombatLockdown() then
		return self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		for Name, Macro in pairs(gM_Macros) do
			SanitizeMacro(Macro);
			UpdateSequencerIcons();
		end
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	end
	
	UpdateMacros();
end)
--[[
local _GetActionText = GetActionText
GetActionText = function(action)
   local text = _GetActionText(action)
   if text and text:find("^gM_") then
      return text:sub(4)
   else
      return text
   end
end
--]]