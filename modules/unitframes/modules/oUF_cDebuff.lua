﻿--[[	$Id: oUF_cDebuff.lua 3985 2015-01-26 10:20:20Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

oUF_Caellian.cdebuffs = oUF_Caellian.createModule("cDebuffs")

local playerClass = caelUI.playerClass

local canDispel = {
	DRUID = {Curse = true, Poison = true},
	MAGE = {Curse = true},
	MONK = {Poison = true, Disease = true}, 
	PALADIN = {Poison = true, Disease = true}, 
	PRIEST = {Magic = true},
	SHAMAN = {Curse = true}
}

oUF_Caellian.cdebuffs:RegisterEvent("PLAYER_ENTERING_WORLD")
oUF_Caellian.cdebuffs:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
oUF_Caellian.cdebuffs:SetScript("OnEvent", function()
	local playerSpec = GetSpecialization()

	if (playerClass == "DRUID" and playerSpec == 4) or (playerClass == "MONK" and playerSpec == 2) or (playerClass == "PALADIN" and playerSpec == 1) or (playerClass == "SHAMAN" and playerSpec == 3) then	
		canDispel[playerClass].Magic = true
	end

	if playerClass == "PRIEST" and (playerSpec == 1 or playerSpec == 2) then
		canDispel[playerClass].Disease = true
	end
end)

local dispelList = canDispel[playerClass] or {}

local DebuffTypeColor = {}

for k, v in pairs(_G["DebuffTypeColor"]) do
	DebuffTypeColor[k] = v
end

local backupColor = {r = 0.69, g = 0.31, b = 0.31}

setmetatable(DebuffTypeColor, {__index = function() return backupColor end})

local null = {""}
local spellcache = setmetatable({}, {__index = function(t, spellId) 
	local spell = {GetSpellInfo(spellId)} 

	if GetSpellInfo(spellId) then
	    t[spellId] = spell
	    return spell
	end

        t[spellId] = null
	return null
end
})

local GetSpellName = function(spell)
    return unpack(spellcache[spell])
end

local blackList = {
	[GetSpellName(46392)]	= true,	--	Focused Assault
	[GetSpellName(46393)]	= true,	--	Brutal Assault
}

local whiteList = {
-- "Vault of Archavon"
	--Koralon
	[GetSpellName(67332)]	= true,	--	Flaming Cinder (10, 25)

	--Toravon the Ice Watcher
	[GetSpellName(72004)]	= true,	--	Frostbite

-- "Naxxramas"
	--Trash
	[GetSpellName(55314)]	= true,	--	Strangulate

	--Anub'Rekhan
	[GetSpellName(28786)]	= true,	--	Locust Swarm (N, H)

	--Grand Widow Faerlina
	[GetSpellName(28796)]	= true,	--	Poison Bolt Volley (N, H)
	[GetSpellName(28794)]	= true,	--	Rain of Fire (N, H)

	--Maexxna
	[GetSpellName(28622)]	= true,	--	Web Wrap (NH)
	[GetSpellName(54121)]	= true,	--	Necrotic Poison (N, H)

	--Noth the Plaguebringer
	[GetSpellName(29213)]	= true,	--	Curse of the Plaguebringer (N, H)
	[GetSpellName(29214)]	= true,	--	Wrath of the Plaguebringer (N, H)
	[GetSpellName(29212)]	= true,	--	Cripple (NH)

	--Heigan the Unclean
	[GetSpellName(29998)]	= true,	--	Decrepit Fever (N, H)
	[GetSpellName(29310)]	= true,	--	Spell Disruption (NH)

	--Grobbulus
	[GetSpellName(28169)]	= true,	--	Mutating Injection (NH)

	--Gluth
	[GetSpellName(54378)]	= true,	--	Mortal Wound (NH)
	[GetSpellName(29306)]	= true,	--	Infected Wound (NH)

	--Thaddius
	[GetSpellName(28084)]	= true,	--	Negative Charge (N, H)
	[GetSpellName(28059)]	= true,	--	Positive Charge (N, H)

	--Instructor Razuvious
	[GetSpellName(55550)]	= true,	--	Jagged Knife (NH)

	--Sapphiron
	[GetSpellName(28522)]	= true,	--	Icebolt (NH)
	[GetSpellName(28542)]	= true,	--	Life Drain (N, H)

	--Kel'Thuzad
	[GetSpellName(28410)]	= true,	--	Chains of Kel'Thuzad (H)
	[GetSpellName(27819)]	= true,	--	Detonate Mana (NH)
	[GetSpellName(27808)]	= true,	--	Frost Blast (NH)

-- "The Eye of Eternity"
	--Malygos
	[GetSpellName(56272)]	= true,	--	Arcane Breath (N, H)
	[GetSpellName(57407)]	= true,	--	Surge of Power (N, H)

-- "The Obsidian Sanctum"
	--Trash
	[GetSpellName(39647)]	= true,	--	Curse of Mending
	[GetSpellName(58936)]	= true,	--	Rain of Fire

	--Sartharion
	[GetSpellName(60708)]	= true,	--	Fade Armor (N, H)
	[GetSpellName(57491)]	= true,	--	Flame Tsunami (N, H)

-- "Ulduar"
	--Trash
	[GetSpellName(62310)]	= true,	--	Impale (N, H)
	[GetSpellName(63612)]	= true,	--	Lightning Brand (N, H)
	[GetSpellName(63615)]	= true,	--	Ravage Armor (NH)
	[GetSpellName(62283)]	= true,	--	Iron Roots (N, H)
	[GetSpellName(63169)]	= true,	--	Petrify Joints (N, H)

	--Razorscale
	[GetSpellName(64771)]	= true,	--	Fuse Armor (NH)

	--Ignis the Furnace Master
	[GetSpellName(62548)]	= true,	--	Scorch (N, H)
	[GetSpellName(62680)]	= true,	--	Flame Jet (N, H)
	[GetSpellName(62717)]	= true,	--	Slag Pot (N, H)

	--XT-002
	[GetSpellName(63024)]	= true,	--	Gravity Bomb (N, H)
	[GetSpellName(63018)]	= true,	--	Light Bomb (N, H)

	--The Assembly of Iron
	[GetSpellName(61888)]	= true,	--	Overwhelming Power (N, H)
	[GetSpellName(62269)]	= true,	--	Rune of Death (N, H)
	[GetSpellName(61903)]	= true,	--	Fusion Punch (N, H)
	[GetSpellName(61912)]	= true,	--	Static Disruption(N, H)

	--Kologarn
	[GetSpellName(64290)]	= true,	--	Stone Grip (N, H)
	[GetSpellName(63355)]	= true,	--	Crunch Armor (N, H)
	[GetSpellName(62055)]	= true,	--	Brittle Skin (NH)

	--Hodir
	[GetSpellName(62469)]	= true,	--	Freeze (NH)
	[GetSpellName(61969)]	= true,	--	Flash Freeze (N, H)
	[GetSpellName(62188)]	= true,	--	Biting Cold (NH)

	--Thorim
	[GetSpellName(62042)]	= true,	--	Stormhammer (NH)
	[GetSpellName(62130)]	= true,	--	Unbalancing Strike (NH)
	[GetSpellName(62526)]	= true,	--	Rune Detonation (NH)
	[GetSpellName(62470)]	= true,	--	Deafening Thunder (NH)
	[GetSpellName(62331)]	= true,	--	Impale (N, H)

	--Freya
	[GetSpellName(62532)]	= true,	--	Conservator's Grip (NH)
	[GetSpellName(62589)]	= true,	--	Nature's Fury (N, H)
	[GetSpellName(62861)]	= true,	--	Iron Roots (N, H)

	--Mimiron
	[GetSpellName(63666)]	= true,	--	Napalm Shell (N)
	[GetSpellName(65026)]	= true,	--	Napalm Shell (H)
	[GetSpellName(62997)]	= true,	--	Plasma Blast (N)
	[GetSpellName(64529)]	= true,	--	Plasma Blast (H)
	[GetSpellName(64668)]	= true,	--	Magnetic Field (NH)

	--General Vezax
	[GetSpellName(63276)]	= true,	--	Mark of the Faceless (NH)
	[GetSpellName(63322)]	= true,	--	Saronite Vapors (NH)

	--Yogg-Saron
	[GetSpellName(63147)]	= true,	--	Sara's Anger(NH)
	[GetSpellName(63134)]	= true,	--	Sara's Blessing(NH)
	[GetSpellName(63138)]	= true,	--	Sara's Fervor(NH)
	[GetSpellName(63830)]	= true,	--	Malady of the Mind (H)
	[GetSpellName(63802)]	= true,	--	Brain Link(H)
	[GetSpellName(63042)]	= true,	--	Dominate Mind (H)
	[GetSpellName(64152)]	= true,	--	Draining Poison (H)
	[GetSpellName(64153)]	= true,	--	Black Plague (H)
	[GetSpellName(64125)]	= true,	--	Squeeze (N, H)
	[GetSpellName(64156)]	= true,	--	Apathy (H)
	[GetSpellName(64157)]	= true,	--	Curse of Doom (H)
	--63050)]	= true,	--	Sanity(NH)

	--Algalon
	[GetSpellName(64412)]	= true,	--	Phase Punch

-- "Trial of the Crusader"
	--Gormok the Impaler
	[GetSpellName(66331)]	= true,	--	Impale
	[GetSpellName(66406)]	= true,	--	Snobolled!

	--Acidmaw --Dreadscale
	[GetSpellName(66819)]	= true,	--	Acidic Spew
	[GetSpellName(66821)]	= true,	--	Molten Spew
	[GetSpellName(66823)]	= true,	--	Paralytic Toxin
	[GetSpellName(66869)]	= true,	--	Burning Bile

	--Icehowl
	[GetSpellName(66770)]	= true,	--	Ferocious Butt
	[GetSpellName(66689)]	= true,	--	Arctic Breathe
	[GetSpellName(66683)]	= true,	--	Massive Crash

	--Lord Jaraxxus
	[GetSpellName(66532)]	= true,	--	Fel Fireball 
	[GetSpellName(66237)]	= true,	--	Incinerate Flesh 
	[GetSpellName(66242)]	= true,	--	Burning Inferno
	[GetSpellName(66197)]	= true,	--	Legion Flame
	[GetSpellName(66199)]	= true,	--	Legion Flame
	[GetSpellName(66877)]	= true,	--	Legion Flame
	[GetSpellName(66283)]	= true,	--	Spinning Pain Spike
	[GetSpellName(66209)]	= true,	--	Touch of Jaraxxus(H)
	[GetSpellName(66211)]	= true,	--	Curse of the Nether(H)
	[GetSpellName(66333, 66334, 66335, 66336, 68156)]	= true,	--	Mistress' Kiss (10H, 25H)

	--Faction Champions
	[GetSpellName(65812)]	= true,	--	Unstable Affliction
	[GetSpellName(65801)]	= true,	--	Polymorph
	[GetSpellName(65543)]	= true,	--	Psychic Scream
	[GetSpellName(66054)]	= true,	--	Hex
	[GetSpellName(65809)]	= true,	--	Fear

	--The Twin Val'kyr
	[GetSpellName(67176)]	= true,	--	Dark Essence
	[GetSpellName(67223)]	= true,	--	Light Essence
	[GetSpellName(67282)]	= true,	--	Dark Touch
	[GetSpellName(67297)]	= true,	--	Light Touch
	[GetSpellName(67309)]	= true,	--	Twin Spike

	--Anub'arak
	[GetSpellName(67574)]	= true,	--	Pursued by Anub'arak
	[GetSpellName(66013)]	= true,	--	Penetrating Cold (10, 25, 10H, 25H)
	[GetSpellName(67847)]	= true,	--	Expose Weakness
	[GetSpellName(66012)]	= true,	--	Freezing Slash
	[GetSpellName(67863)]	= true,	--	Acid-Drenched Mandibles(25H)

-- "Icecrown Citadel"
	--Lord Marrowgar
	[GetSpellName(70823)]	= true,	--	Coldflame
	[GetSpellName(69065)]	= true,	--	Impaled
	[GetSpellName(70835)]	= true,	--	Bone Storm

	--Lady Deathwhisper
	[GetSpellName(72109)]	= true,	--	Death and Decay
	[GetSpellName(71289)]	= true,	--	Dominate Mind
	[GetSpellName(71204)]	= true,	--	Touch of Insignificance
	[GetSpellName(67934)]	= true,	--	Frost Fever
	[GetSpellName(71237)]	= true,	--	Curse of Torpor
	[GetSpellName(72491)]	= true,	--	Necrotic Strike

	--Gunship Battle
	[GetSpellName(69651)]	= true,	--	Wounding Strike

	--Deathbringer Saurfang
	[GetSpellName(72293)]	= true,	--	Mark of the Fallen Champion
	[GetSpellName(72442)]	= true,	--	Boiling Blood
	[GetSpellName(72449)]	= true,	--	Rune of Blood
	[GetSpellName(72769)]	= true,	--	Scent of Blood (heroic)

	--Festergut
	[GetSpellName(69290)]	= true,	--	Blighted Spore
	[GetSpellName(69248)]	= true,	--	Vile Gas?
	[GetSpellName(71218)]	= true,	--	Vile Gas?
	[GetSpellName(72219)]	= true,	--	Gastric Bloat
	[GetSpellName(69278)]	= true,	--	Gas Spore

	--Rotface
	[GetSpellName(69674)]	= true,	--	Mutated Infection
	[GetSpellName(69508)]	= true,	--	Slime Spray
	[GetSpellName(69774)]	= true,	--	Sticky Ooze

	--Professor Putricide
	[GetSpellName(70672)]	= true,	--	Gaseous Bloat
	[GetSpellName(72549)]	= true,	--	Malleable Goo
	[GetSpellName(72454)]	= true,	--	Mutated Plague
	[GetSpellName(70341)]	= true,	--	Slime Puddle (Spray)
	[GetSpellName(70342)]	= true,	--	Slime Puddle (Pool)
	[GetSpellName(70911)]	= true,	--	Unbound Plague
	[GetSpellName(69774)]	= true,	--	Volatile Ooze Adhesive

	--Blood Prince Council
	[GetSpellName(71807)]	= true,	--	Glittering Sparks
	[GetSpellName(71911)]	= true,	--	Shadow Resonance

	--Blood-Queen Lana'thel
	[GetSpellName(71623)]	= true,	--	Delirious Slash
	[GetSpellName(70949)]	= true,	--	Essence of the Blood Queen (hand icon)
	[GetSpellName(70867)]	= true,	--	Essence of the Blood Queen (bite icon)
	[GetSpellName(72151)]	= true,	--	Frenzied Bloodthirst (bite icon)
	[GetSpellName(71474)]	= true,	--	Frenzied Bloodthirst (red bite icon)
	[GetSpellName(71340)]	= true,	--	Pact of the Darkfallen
	[GetSpellName(72985)]	= true,	--	Swarming Shadows (pink icon)
	[GetSpellName(71267)]	= true,	--	Swarming Shadows (black purple icon)
	[GetSpellName(71264)]	= true,	--	Swarming Shadows (swirl icon)
	[GetSpellName(70923)]	= true,	--	Uncontrollable Frenzy

	--Valithria Dreamwalker
	[GetSpellName(70873)]	= true,	--	Emerald Vigor
	[GetSpellName(70744)]	= true,	--	Acid Burst
	[GetSpellName(70751)]	= true,	--	Corrosion
	[GetSpellName(70633)]	= true,	--	Gut Spray

	--Sindragosa
	[GetSpellName(70106)]	= true,	--	Chilled to the Bone
	[GetSpellName(69766)]	= true,	--	Instability
	[GetSpellName(69762)]	= true,	--	Unchained Magic
	[GetSpellName(70126)]	= true,	--	Frost Beacon
	[GetSpellName(71665)]	= true,	--	Asphyxiation
	[GetSpellName(70127)]	= true,	--	Mystic Buffet

	--Lich King
	[GetSpellName(70541)]	= true,	--	Infest
	[GetSpellName(70337)]	= true,	--	Necrotic Plague
	[GetSpellName(72133)]	= true,	--	Pain and Suffering
	[GetSpellName(68981)]	= true,	--	Remorseless Winter
	[GetSpellName(69242)]	= true,	--	Soul Shriek

	--Trash
	[GetSpellName(71089)]	= true,	--	Bubbling Pus
	[GetSpellName(69483)]	= true,	--	Dark Reckoning
	[GetSpellName(71163)]	= true,	--	Devour Humanoid
	[GetSpellName(71127)]	= true,	--	Mortal Wound
	[GetSpellName(70435)]	= true,	--	Rend Flesh
	
-- "The Ruby Sanctum"
	--Baltharus the Warborn
	[GetSpellName(74502)]	= true,	--	Enervating Brand

	--General Zarithrian
	[GetSpellName(74367)]	= true,	--	Cleave Armor

	--Saviana Ragefire
	[GetSpellName(74452)]	= true,	--	Conflagration

	--Halion
	[GetSpellName(74562)]	= true,	--	Fiery Combustion
	[GetSpellName(74567)]	= true,	--	Mark of Combustion
	
-- "Blackwing Descent"
	-- Magmaw
	[GetSpellName(89773)]	= true,	--	Mangle
	[GetSpellName(94679)]	= true,	--	Parasitic Infection

	-- Omnitron Defense System
	[GetSpellName(79889)]	= true,	--	Lightning Conductor
	[GetSpellName(80161)]	= true,	--	Chemical Cloud
	[GetSpellName(80011)]	= true,	--	Soaked in Poison
	[GetSpellName(91535)]	= true,	--	Flamethrower
	[GetSpellName(91829)]	= true,	--	Fixate
	[GetSpellName(92035)]	= true,	--	Acquiring Target

	--Maloriak
	[GetSpellName(92991)]	= true,	--	Rend
	[GetSpellName(78225)]	= true,	--	Acid Nova
	[GetSpellName(92910)]	= true,	--	Debilitating Slime
	[GetSpellName(77786)]	= true,	--	Consuming Flames
	[GetSpellName(91829)]	= true,	--	Fixate
	[GetSpellName(77760)]	= true,	--	Biting Chill
	[GetSpellName(77699)]	= true,	--	Flash Freeze

	-- Atramedes
	[GetSpellName(78092)]	= true,	--	Tracking
	[GetSpellName(77840)]	= true,	--	Searing
	[GetSpellName(78353)]	= true,	--	Roaring Flame
	[GetSpellName(78897)]	= true,	--	Noisy

	-- Chimaeron
	[GetSpellName(89084)]	= true,	--	Low Health
	[GetSpellName(82934)]	= true,	--	Mortality
	[GetSpellName(88916)]	= true,	--	Caustic Slime
	[GetSpellName(82881)]	= true,	--	Break

	-- Nefarian
	[GetSpellName(94075)]	= true,	--	Magma
	[GetSpellName(77827)]	= true,	--	Tail Lash

-- "The Bastion of Twilight"
	-- Halfus Wyrmbreaker
	[GetSpellName(83908)]	= true,	--	Malevolent Strike
	[GetSpellName(83603)]	= true,	--	Stone Touch

	-- Valiona & Theralion
	[GetSpellName(86788)]	= true,	--	Blackout
	[GetSpellName(95639)]	= true,	--	Engulfing Magic
	[GetSpellName(86360)]	= true,	--	Twilight Shift

	-- Ascendant Council
	[GetSpellName(82762)]	= true,	--	Waterlogged
	[GetSpellName(83099)]	= true,	--	Lightning Rod
	[GetSpellName(82285)]	= true,	--	Elemental Stasis
	[GetSpellName(82660)]	= true,	--	Burning Blood
	[GetSpellName(82665)]	= true,	--	Heart of Ice

	-- Cho'gall
	[GetSpellName(93187)]	= true,	--	Corrupted Blood
	[GetSpellName(82523)]	= true,	--	Gall's Blast
	[GetSpellName(82518)]	= true,	--	Cho's Blast
	[GetSpellName(93134)]	= true,	--	Debilitating Beam

-- "Throne of the Four Winds"
	-- Conclave of Wind
	[GetSpellName(84645)]	= true,	--	Wind Chill
	[GetSpellName(86107)]	= true,	--	Ice Patch
	[GetSpellName(86082)]	= true,	--	Permafrost
	[GetSpellName(84643)]	= true,	--	Hurricane
	[GetSpellName(86281)]	= true,	--	Toxic Spores
	[GetSpellName(85573)]	= true,	--	Deafening Winds
	[GetSpellName(85576)]	= true,	--	Withering Winds

	-- Al'Akir
	[GetSpellName(88290)]	= true,	--	Acid Rain
	[GetSpellName(87873)]	= true,	--	Static Shock
	[GetSpellName(88427)]	= true,	--	Electrocute
	[GetSpellName(89668)]	= true,	--	Lightning Rod

-- Firelands
	-- Beth'tilac
	[GetSpellName(99506)]	= true,	--	Widows Kiss
	[GetSpellName(97202)]	= true,	--	Fiery Web Spin
	[GetSpellName(49026)]	= true,	--	Fixate
	[GetSpellName(97079)]	= true,	--	Seeping Venom

	-- Lord Rhyolith
	[GetSpellName(98492)]	= true,	--	Eruption

	-- Alysrazor
	[GetSpellName(101296)]	= true,	--	Fieroblast
	[GetSpellName(100723)]	= true,	--	Gushing Wound
	[GetSpellName(99389)]	= true,	--	Imprinted
	[GetSpellName(101729)]	= true,	--	Blazing Claw
	[GetSpellName(100640)]	= true,	--	Harsh Winds
	[GetSpellName(100555)]	= true,	--	Smouldering Roots

	-- Shannox
	[GetSpellName(99837)]	= true,	--	Crystal Prison
	[GetSpellName(99937)]	= true,	--	Jagged Tear

	-- Baleroc
	[GetSpellName(99403)]	= true,	--	Tormented
	[GetSpellName(99256)]	= true,	--	Torment
	[GetSpellName(99252)]	= true,	--	Blaze of Glory
	[GetSpellName(99516)]	= true,	--	Countdown

	-- Majordomo Staghelm
	[GetSpellName(98450)]	= true,	--	Searing Seeds

	-- Ragnaros
	[GetSpellName(99399)]	= true,	--	Burning Wound
	[GetSpellName(100293)]	= true,	--	Lava Wave
	[GetSpellName(98313)]	= true,	--	Magma Blast
	[GetSpellName(100675)]	= true,	--	Dreadflame
	[GetSpellName(99145)]	= true,	--	Blazing Heat
	[GetSpellName(100249)]	= true,	--	Combustion
	[GetSpellName(99613)]	= true,	--	Molten Blast

	-- Trash
	[GetSpellName(99532)]	= true,	--	Melt Armor

-- Other
	[GetSpellName(67479)]	= true,	--	Impale
	[GetSpellName(5782)]	= true,	--	Fear
	[GetSpellName(84853)]	= true,	--	Dark Pool
	[GetSpellName(91325)]	= true,	--	Shadow Vortex

-- Dragon Soul
	-- Morchok
	[GetSpellName(103687)]	= true,	--	Crush Armor

	-- Hagara the Stormbinder
	[GetSpellName(104451)]	= true, --	Ice Tomb
	[GetSpellName(105285)]	= true, --	Target (next Ice Lance)
	[GetSpellName(105316)]	= true, --	Ice Lance
	[GetSpellName(105289)]	= true, --	Shattered Ice
	[GetSpellName(105259)]	= true, --	Watery Entrenchment	
	[GetSpellName(105465)]	= true, --	Lightning Storm
	[GetSpellName(105369)]	= true, --	Lightning Conduit

	-- Warmaster Blackhorn
	[GetSpellName(109204)]	= true,	--	Twilight Barrage
	[GetSpellName(108046)]	= true,	--	Shockwave
	[GetSpellName(108043)]	= true,	--	Devastate
	[GetSpellName(107567)]	= true,	--	Brutal strike
	[GetSpellName(107558)]	= true,	--	Degeneration
	[GetSpellName(110214)]	= true,	--	Consuming Shroud

	-- Ultraxion
	[GetSpellName(110068)]	= true,	--	Fading light 
	[GetSpellName(106108)]	= true,	--	Heroic will
	[GetSpellName(106415)]	= true,	--	Twilight burst
	[GetSpellName(105927)]	= true,	--	Faded Into Twilight
	[GetSpellName(106369)]	= true,	--	Twilight shift

	-- Yor'sahj the Unsleeping
	[GetSpellName(104849)]	= true,	--	Void bolt
	[GetSpellName(109389)]	= true,	--	Deep Corruption

	-- Warlord Zon'ozz
	[GetSpellName(103434)]	= true,	--	Disrupting shadows
	[GetSpellName(110306)]	= true,	--	Black Blood of Go'rath

	-- Spine of Deathwing
	[GetSpellName(105563)]	= true,	--	Grasping Tendrils
	[GetSpellName(105490)]	= true,	--	Fiery Grip
	[GetSpellName(105479)]	= true,	--	Searing Plasma
	[GetSpellName(106199)]	= true,	--	Blood corruption: death
	[GetSpellName(106200)]	= true,	--	Blood corruption: earth
	[GetSpellName(106005)]	= true,	--	Degradation

	-- Madness of Deathwing
	[GetSpellName(109603)]	= true,	--	Tetanus
	[GetSpellName(109632)]	= true,	--	Impale
	[GetSpellName(106794)]	= true,	--	Shrapnel
	[GetSpellName(106385)]	= true,	--	Crush
	[GetSpellName(105841)]	= true,	--	Degenerative bite
	[GetSpellName(105445)]	= true,	--	Blistering heat

-- Mogu'shan Vaults
	-- The Stone Guard
	[GetSpellName(125206)]	= true,	--	Rend Flesh
	[GetSpellName(130395)]	= true,	--	Jasper Chains
	[GetSpellName(116281)]	= true,	--	Cobalt Mine Blast

	-- Feng the Accursed
	[GetSpellName(131788)]	= true,	--	Lightning Lash
	[GetSpellName(116942)]	= true,	--	Flaming Spear
	[GetSpellName(131790)]	= true,	--	Arcane Shock
	[GetSpellName(131792)]	= true,	--	Shadowburn
	[GetSpellName(116374)]	= true,	--	Lightning Charge
	[GetSpellName(116784)]	= true,	--	Wildfire Spark
	[GetSpellName(116417)]	= true,	--	Arcane Resonance

	-- Gara'jal the Spiritbinder
	[GetSpellName(122151)]	= true,	--	Voodoo Doll
	[GetSpellName(116161)]	= true,	--	Crossed Over
	[GetSpellName(117723)]	= true,	--	Frail Soul

	-- The Spirit Kings
	[GetSpellName(117708)]	= true,	--	Maddening Shout
	[GetSpellName(118303)]	= true,	--	Fixate
	[GetSpellName(118048)]	= true,	--	Pillaged
	[GetSpellName(118135)]	= true,	--	Pinned Down
	[GetSpellName(118163)]	= true,	--	Robbed Blind

	-- Elegon
	[GetSpellName(117878)]	= true,	--	Overcharged
	[GetSpellName(117949)]	= true,	--	Closed Circuit
	[GetSpellName(132222)]	= true,	--	Destabilizing Energies

	-- Will of the Emperor
	[GetSpellName(116835)]	= true,	--	Devastating Arc
	[GetSpellName(116778)]	= true,	--	Focused Defense
	[GetSpellName(116525)]	= true,	--	Focused Assault

-- Sha of Anger
	[GetSpellName(119626)]	= true,	--	Aggressive Behavior

-- Heart of Fear
	-- Imperial Vizier Zor'lok
	[GetSpellName(122761)]	= true,	--	Exhale
	[GetSpellName(122740)]	= true,	--	Convert

	-- Blade Lord Ta'yak
	[GetSpellName(123180)]	= true,	--	Wind Step
	[GetSpellName(123474)]	= true,	--	Overwhelming Assault

	-- Garalon
	[GetSpellName(122835)]	= true,	--	Pheromones
	[GetSpellName(123081)]	= true,	--	Pungency

	-- Wind Lord Mel'jarak
	[GetSpellName(129078)]	= true,	--	Amber Prison
	[GetSpellName(122055)]	= true,	--	Residue
	[GetSpellName(122064)]	= true,	--	Corrosive Resin
	[GetSpellName(123963)]	= true,	--	Kor'thik Strike

	-- Amber-Shaper Un'sok
	[GetSpellName(121949)]	= true,	--	Parasitic Growth
	[GetSpellName(122370)]	= true,	--	Reshape Life

	-- Grand Empress Shek'zeer
	[GetSpellName(123707)]	= true,	--	Eyes of the Empress
	[GetSpellName(123713)]	= true,	--	Servant of the Empress
	[GetSpellName(123788)]	= true,	--	Cry of Terror
	[GetSpellName(124849)]	= true,	--	Consuming Terror
	[GetSpellName(124863)]	= true,	--	Visions of Demise

-- Terrace of Endless Spring
	-- Protectors of the Endless
	[GetSpellName(117519)]	= true,	--	Touch of Sha
	[GetSpellName(117436)]	= true,	--	Lightning Prison

	-- Tsulong
	[GetSpellName(122752)]	= true,	--	Shadow Breath
	[GetSpellName(123011)]	= true,	--	Terrorize
	[GetSpellName(122777)]	= true,	--	Nightmares
	[GetSpellName(123036)]	= true,	--	Fright

	-- Lei Shi
	[GetSpellName(123121)]	= true,	--	Spray
	[GetSpellName(123705)]	= true,	--	Scary Fog

	-- Sha of Fear
	[GetSpellName(119086)]	= true,	--	Penetrating Bolt
	[GetSpellName(120669)]	= true,	--	Naked and Afraid
	[GetSpellName(120629)]	= true,	--	Huddle in Terror

-- Throne of Thunder
	-- Jin'rokh the Breaker
	[GetSpellName(137162)]	= true,	--	Static Burst (Tank switch)
	[GetSpellName(138349)]	= true,	--	Static Wound (Tank stacks)
	[GetSpellName(137371)]	= true,	--	Thundering Throw (Tank stun)
	[GetSpellName(138732)]	= true,	--	Ionization (Heroic - Dispel)
	[GetSpellName(137422)]	= true,	--	Focused Lightning (Fixated - Kiting)
	[GetSpellName(138006)]	= true,	--	Electrified Waters (Pool)

	-- Horridon
	[GetSpellName(136767)]	= true,	--	Triple Puncture (Tank stacks)
	[GetSpellName(136708)]	= true,	--	Stone Gaze (Stun - Dispel)
	[GetSpellName(136654)]	= true,	--	Rending Charge (DoT)
	[GetSpellName(136719)]	= true,	--	Blazing Sunlight (Dispel)
	[GetSpellName(136587)]	= true,	--	Venom Bolt Volley (Dispel)
	[GetSpellName(136710)]	= true,	--	Deadly Plague (Dispel)
	[GetSpellName(136512)]	= true,	--	Hex of Confusion (Dispel)

	-- Council of Elders
	[GetSpellName(136903)]	= true,	--	Frigid Assault (Tank stacks)
	[GetSpellName(136922)]	= true,	--	Frostbite (DoT)
	[GetSpellName(136992)]	= true,	--	Biting Cold (DoT)
	[GetSpellName(136857)]	= true,	--	Entrapped (Dispel)
	[GetSpellName(137359)]	= true,	--	Marked Soul (Fixated - Kiting)
	[GetSpellName(137641)]	= true,	--	Soul Fragment (Heroic)

	-- Tortos
	[GetSpellName(136753)]	= true,	--	Slashing Talons (Tank DoT)
	[GetSpellName(137633)]	= true,	--	Crystal Shell (Heroic)
	[GetSpellName(140701)]	= true,	--	Crystal Shell: Full Capacity! (Heroic)

	-- Megaera
	[GetSpellName(137731)]	= true,	--	Ignite Flesh (Tank stacks)
	[GetSpellName(139843)]	= true,	--	Arctic Freeze (Tank stacks)
	[GetSpellName(139840)]	= true,	--	Rot Armor (Tank stacks)
	[GetSpellName(134391)]	= true,	--	Cinder (DoT - Dispell)
	[GetSpellName(139857)]	= true,	--	Torrent of Ice (Fixated - Kiting)
	[GetSpellName(140179)]	= true,	--	Suppression (Heroic - Dispell)

	-- Ji-Kun
	[GetSpellName(134366)]	= true,	--	Talon Rake (Tank stacks)
	[GetSpellName(140092)]	= true,	--	Infected Talons (Tank DoT)
	[GetSpellName(134256)]	= true,	--	Slimed (DoT)

	-- Durumu the Forgotten
	[GetSpellName(133768)]	= true,	--	Arterial Cut (Tank DoT)
	[GetSpellName(133767)]	= true,	--	Serious Wound (Tank stacks)
	[GetSpellName(133798)]	= true,	--	Life Drain (Stun)
	[GetSpellName(133597)]	= true,	--	Dark Parasite (Heroic - Dispel)

	-- Primordius
	[GetSpellName(136050)]	= true,	--	Malformed Blood (Tank stacks)
	[GetSpellName(136228)]	= true,	--	Volatile Pathogen (DoT)

	-- Dark Animus
	[GetSpellName(138569)]	= true,	--	Explosive Slam (Tank stacks)
	[GetSpellName(138609)]	= true,	--	Matter Swap (Dispel)
	[GetSpellName(138659)]	= true,	--	Touch of the Animus (DoT)

	-- Iron Qon
	[GetSpellName(134691)]	= true,	--	Impale (Tank stacks)
	[GetSpellName(136192)]	= true,	--	Lightning Storm (Stun)
	[GetSpellName(136193)]	= true,	--	Arcing Lightning

	-- Twin Consorts
	[GetSpellName(137408)]	= true,	--	Fan of Flames (Tank stacks)
	[GetSpellName(136722)]	= true,	--	Slumber Spores (Dispel)
	[GetSpellName(137341)]	= true,	--	Beast of Nightmares (Fixate)
	[GetSpellName(137360)]	= true,	--	Corrupted Healing (Healer stacks)

	-- Lei Shen
	[GetSpellName(135000)]	= true,	--	Decapitate (Tank only)
	[GetSpellName(136478)]	= true,	--	Fusion Slash (Tank only)
	[GetSpellName(136914)]	= true,	--	Electrical Shock (Tank staks)
	[GetSpellName(135695)]	= true,	--	Static Shock (Damage Split)
	[GetSpellName(136295)]	= true,	-- Overcharged
	[GetSpellName(139011)]	= true,	-- Helm of Command (Heroic)

	-- Ra-den
	[GetSpellName(138297)]	= true,	--	Unstable Vita
	[GetSpellName(138329)]	= true,	--	Unleashed Anima
	[GetSpellName(138372)]	= true,	--	Vita Sensitivity

-- Siege of Orgrimmar
	-- Immerseus
	[GetSpellName(143436)]	= true,	-- Corrosive Blast (Tank switch)
	[GetSpellName(143459)]	= true,	-- Sha Residue

	-- The Fallen Protectors
	[GetSpellName(143434)]	= true,	-- Shadow Word: Bane (Dispel)
	[GetSpellName(143198)]	= true,	-- Garrote (DoT)
	[GetSpellName(143842)]	= true,	-- Mark of Anguish
	[GetSpellName(147383)]	= true,	-- Debilitation

	-- Norushen
	[GetSpellName(146124)]	= true,	-- Self Doubt (Tank switch)
	[GetSpellName(144514)]	= true,	-- Lingering Corruption (Dispel)

	-- Sha of Pride
	[GetSpellName(144358)]	= true,	-- Wounded Pride (Tank switch)
	[GetSpellName(144351)]	= true,	-- Mark of Arrogance (Dispel)
	[GetSpellName(146594)]	= true,	-- Gift of the Titans
	[GetSpellName(147207)]	= true,	-- Weakened Resolve (Heroic)

	-- Galakras
	[GetSpellName(147029)]	= true,	-- Flames of Galakrond (DoT)
	[GetSpellName(146765)]	= true,	-- Flame Arrows (DoT)
	[GetSpellName(146902)]	= true,	-- Poison-Tipped Blades (Poison stacks)

	-- Iron Juggernaut
	[GetSpellName(144467)]	= true,	-- Ignite Armor (Tank stacks)
	[GetSpellName(144459)]	= true,	-- Laser Burn (DoT)

	-- Kor'kron Dark Shaman
	[GetSpellName(144215)]	= true,	-- Froststorm Strike (Tank stacks)
	[GetSpellName(144089)]	= true,	-- Toxic Mist (DoT)
	[GetSpellName(144330)]	= true,	-- Iron Prison (Heroic)

	-- General Nazgrim
	[GetSpellName(143494)]	= true,	-- Sundering Blow (Tank stacks)
	[GetSpellName(143638)]	= true,	-- Bonecracker (DoT)
	[GetSpellName(143431)]	= true,	-- Magistrike (Dispel)

	-- Malkorok
	[GetSpellName(142990)]	= true,	-- Fatal Strike (Tank stacks)
	[GetSpellName(142864)]	= true,	-- Ancient Barrier
	[GetSpellName(142865)]	= true,	-- Strong Ancient Barrier
	[GetSpellName(142913)]	= true,	-- Displaced Energy (Dispel)

	-- Spoils of Pandaria
	[GetSpellName(145218)]	= true,	-- Harden Flesh (Dispel)
	[GetSpellName(146235)]	= true,	-- Breath of Fire (Dispel)

	-- Thok the Bloodthirsty
	[GetSpellName(143766)]	= true,	-- Panic (Tank stacks)
	[GetSpellName(143780)]	= true,	-- Acid Breath (Tank stacks)
	[GetSpellName(143773)]	= true,	-- Freezing Breath (Tank Stacks)
	[GetSpellName(143800)]	= true,	-- Icy Blood (Random Stacks)
	[GetSpellName(143767)]	= true,	-- Scorching Breath (Tank Stacks)
	[GetSpellName(143791)]	= true,	-- Corrosive Blood (Dispel)

	-- Siegecrafter Blackfuse
	[GetSpellName(143385)]	= true,	-- Electrostatic Charge (Tank stacks)
	[GetSpellName(144236)]	= true,	-- Pattern Recognition

	-- Paragons of the Klaxxi
	[GetSpellName(142929)]	= true,	-- Tenderizing Strikes (Tank stacks)
	[GetSpellName(143275)]	= true,	-- Hewn (Tank stacks)
	[GetSpellName(143279)]	= true,	-- Genetic Alteration (Tank stacks)
	[GetSpellName(143974)]	= true,	-- Shield Bash (Tank stun)
	[GetSpellName(142948)]	= true,	-- Aim

	-- Garrosh Hellscream
	[GetSpellName(145183)]	= true,	-- Gripping Despair (Tank stacks)
	[GetSpellName(145195)]	= true,	-- Empowered Gripping Despair (Tank stacks)

-- Highmaul
	-- Kargath Bladefist
	[GetSpellName(159178)]	= true,	-- Open Wounds (Tank switch)
	[GetSpellName(159113)]	= true,	-- Impale (DoT)

	-- The Butcher
	[GetSpellName(156152)]	= true,	-- Gushing Wounds
	[GetSpellName(156147)]	= true,	-- The Cleaver

	-- Brackenspore
	[GetSpellName(163241)]	= true,	-- Rot (Stacks)

	-- Tectus
	[GetSpellName(162892)]	= true,	-- Petrification

	-- Twin Ogron
	[GetSpellName(155569)]	= true,	-- Injured (DoT)
	[GetSpellName(167200)]	= true,	-- Arcane Wound (DoT)

	-- Ko'ragh
	[GetSpellName(161242)]	= true,	-- Caustic Energy (DoT)
	[GetSpellName(162184)]	= true,	-- Expel Magic: Shadow

	-- Imperator Mar'gok
	[GetSpellName(158605)]	= true,	-- Mark of Chaos
	[GetSpellName(164176)]	= true,	-- Mark of Chaos: Displacement
	[GetSpellName(164178)]	= true,	-- Mark of Chaos: Fortification
	[GetSpellName(164191)]	= true,	-- Mark of Chaos: Replication
	[GetSpellName(157763)]	= true,	-- Fixate
	[GetSpellName(158553)]	= true,	-- Crush Armor (Stacks)
}

local function GetDebuffType(unit, filter)
	if not UnitCanAssist("player", unit) then return end

	local dispelType, debuffIcon, stacks

	local i = 1
	local isBlackList, isWhiteList

	while true do
		local name, _, icon, count, debuffType = UnitAura(unit, i, "HARMFUL")

		if not icon then break end

		if (dispelList[debuffType] or (not filter and debuffType) or whiteList[name]) and not blackList[name] then

			dispelType = debuffType
			debuffIcon = icon
			stacks = count

			if blackList[name] then
				isBlackList = true
				break
			end

			if whiteList[name] then
				isWhiteList = true
				break
			end
		end

		i = i + 1
	end

	return dispelType, debuffIcon, isBlackList, isWhiteList, stacks
end

local function Update(self, event, unit)
	if self.unit ~= unit  then return end

	local dispelType, debuffIcon, isBlackList, isWhiteList, stacks = GetDebuffType(unit, self.cDebuffFilter)

	if self.cDebuffBackdrop then
		local color

		if debuffIcon then
			color = DebuffTypeColor[dispelType]
			self.cDebuffBackdrop:SetVertexColor(color.r, color.g, color.b, 1)
		else
			self.cDebuffBackdrop:SetVertexColor(0, 0, 0, 0)
		end
	end

	if self.cDebuff.icon then
		if debuffIcon then
			self.cDebuff.icon:SetTexture(debuffIcon)
			self.cDebuff.border:SetBackdropColor(0.5, 0.5, 0.5, 1)
			self.cDebuff.gloss:SetBackdropColor(0.25, 0.25, 0.25, 0.5)
		else
			self.cDebuff.icon:SetTexture(nil)
			self.cDebuff.border:SetBackdropColor(0.5, 0.5, 0.5, 0)
			self.cDebuff.gloss:SetBackdropColor(0.25, 0.25, 0.25, 0)
		end
	end

	if self.cDebuff.count then
		if stacks then
			self.cDebuff.count:SetText(stacks)
		else
			self.cDebuff.count:SetText("")
		end
	end
end

local function Enable(self)
	if not self.cDebuff then return end

	self:RegisterEvent("UNIT_AURA", Update)

	return true
end

local function Disable(self)
	if self.cDebuffBackdrop or self.cDebuff.icon then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement("cDebuff", Update, Enable, Disable)