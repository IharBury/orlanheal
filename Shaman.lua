OrlanHeal.Shaman = {};

OrlanHeal.Shaman.IsSupported = true;
OrlanHeal.Shaman.GiftOfTheNaaruSpellId = 59547;

OrlanHeal.Shaman.AvailableSpells =
{
	974, -- Щит земли
	51886, -- Очищение духа
	8004, -- Исцеляющий всплеск
	546, -- Хождение по воде
	1064, -- Цепное исцеление
	77472, -- Healing Wave
	61295, -- Быстрина
	73685, -- Высвободить чары жизни
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(8004), -- Исцеляющий всплеск
		group = GetSpellInfo(16188), -- Ancestral Swiftness
		macrotext = OrlanHeal:BuildCastSequenceMacro(16188, 8004),
		key = "16188,8004"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(1064), -- Цепное исцеление
		group = GetSpellInfo(16188), -- Ancestral Swiftness
		macrotext = OrlanHeal:BuildCastSequenceMacro(16188, 1064),
		key = "16188,1064"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(77472), -- Healing Wave
		group = GetSpellInfo(16188), -- Ancestral Swiftness
		macrotext = OrlanHeal:BuildCastSequenceMacro(16188, 77472),
		key = "16188,77472"
	},
	2008, -- Ancestral Spirit
	59547 -- Gift of the Naaru
};

OrlanHeal.Shaman.CooldownOptions =
{
	InstantChainLightning =
	{
		MacroText = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(421),
		Caption = "Instant " .. GetSpellInfo(421),
		SpellId = 421, -- Chain Lightning
		PrefixSpellId = 16188, -- Ancestral Swiftness
		Update = OrlanHeal.UpdateAbilitySequenceCooldown,
		Sign = "I",
		Group = GetSpellInfo(16188)
	},
	InstantLightningBolt =
	{
		MacroText = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(403),
		Caption = "Instant " .. GetSpellInfo(403),
		SpellId = 403, -- Lightning Bolt
		PrefixSpellId = 16188, -- Ancestral Swiftness
		Update = OrlanHeal.UpdateAbilitySequenceCooldown,
		Sign = "I",
		Group = GetSpellInfo(16188)
	},
	InstantHealingRain =
	{
		MacroText = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(73920),
		Caption = "Instant " .. GetSpellInfo(73920),
		SpellId = 73920, -- Healing Rain
		PrefixSpellId = 16188, -- Ancestral Swiftness
		Update = OrlanHeal.UpdateAbilitySequenceCooldown,
		Sign = "I",
		Group = GetSpellInfo(16188)
	},
	InstantHealingSurge =
	{
		MacroText = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(8004),
		Caption = "Instant " .. GetSpellInfo(8004),
		SpellId = 8004, -- Healing Surge
		PrefixSpellId = 16188, -- Ancestral Swiftness
		Update = OrlanHeal.UpdateAbilitySequenceCooldown,
		Sign = "I",
		Group = GetSpellInfo(16188)
	},
	InstantElementalBlast =
	{
		MacroText = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(117014),
		Caption = "Instant " .. GetSpellInfo(117014),
		SpellId = 117014, -- Elemental Blast
		PrefixSpellId = 16188, -- Ancestral Swiftness
		Update = OrlanHeal.UpdateAbilitySequenceCooldown,
		Sign = "I",
		Group = GetSpellInfo(16188)
	},
	InstantChainHeal =
	{
		MacroText = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(1064),
		Caption = "Instant " .. GetSpellInfo(1064),
		SpellId = 1064, -- Chain Heal
		PrefixSpellId = 16188, -- Ancestral Swiftness
		Update = OrlanHeal.UpdateAbilitySequenceCooldown,
		Sign = "I",
		Group = GetSpellInfo(16188)
	},
	InstantHealingWave =
	{
		MacroText = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(77472),
		Caption = "Instant " .. GetSpellInfo(77472),
		SpellId = 77472, -- Healing Wave
		PrefixSpellId = 16188, -- Ancestral Swiftness
		Update = OrlanHeal.UpdateAbilitySequenceCooldown,
		Sign = "I",
		Group = GetSpellInfo(16188)
	},
	LightningShield =
	{
		SpellId = 324, -- Lightning Shield
		IsReverse = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown,
		Group = "Shield"
	},
	WaterShield =
	{
		SpellId = 324, -- Lightning Shield
		AuraId = 52127, -- Water Shield
		IsReverse = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown,
		Group = "Shield"
	},
	EarthShield =
	{
		SpellId = 974, -- Щит земли
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown,
		Group = "Shield"
	},
	AncestralSwiftness =
	{
		SpellId = 16188, -- Ancestral Swiftness
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = GetSpellInfo(16188)
	},
	HealingStreamTotem =
	{
		SpellId = 5394,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Water Totems"
	},
	Riptide =
	{
		SpellId = 61295,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Bloodlust =
	{
		SpellId = 2825,
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			return UnitFactionGroup("player") == "Horde";
		end
	},
	Heroism =
	{
		SpellId = 32182,
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			return UnitFactionGroup("player") == "Alliance";
		end
	},
	SpiritLinkTotem =
	{
		SpellId = 98008,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Air Totems"
	},
	GiftOfTheNaaru =
	{
		SpellId = 59547, -- Gift of the Naaru
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Draenei";
		end
	},
	BloodFury =
	{
		SpellId = 33697, -- Blood Fury
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Orc";
		end
	},
	UnleashLife =
	{
		SpellId = 73685,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HealingRain =
	{
		SpellId = 73920,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SpiritwalkersGrace =
	{
		SpellId = 79206,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	GroundingTotem =
	{
		SpellId = 8177,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Air Totems"
	},
	AstralRecall =
	{
		SpellId = 556,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	FlameShock =
	{
		SpellId = 8050,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Shock"
	},
	FrostShock =
	{
		SpellId = 8056,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Shock"
	},
	EarthbindTotem =
	{
		SpellId = 2484,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Earth Totems"
	},
	TremorTotem =
	{
		SpellId = 8143,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Earth Totems"
	},
	EarthElementalTotem =
	{
		SpellId = 2062,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Earth Totems"
	},
	ElementalMastery =
	{
		SpellId = 16166,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	FireElementalTotem =
	{
		SpellId = 2894,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Fire Totems"
	},
	MagmaTotem =
	{
		SpellId = 8190,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Fire Totems"
	},
	SearingTotem =
	{
		SpellId = 3599,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Fire Totems"
	},
	Hex =
	{
		SpellId = 51514,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LavaBurst =
	{
		SpellId = 51505,
		MacroText = "/cast " .. GetSpellInfo(51505),
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PrimalStrike =
	{
		SpellId = 73899,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	WindShear =
	{
		SpellId = 57994,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ChainHeal =
	{
		SpellId = 1064,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	CapacitorTotem =
	{
		SpellId = 108269,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Air Totems"
	},
	WindwalkTotem =
	{
		SpellId = 108273,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Air Totems"
	},
	AstralShift =
	{
		SpellId = 108271,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	TotemicProjection =
	{
		SpellId = 108287,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Ascendance =
	{
		SpellId = 114049,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	StoneBulwarkTotem =
	{
		SpellId = 108270,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Earth Totems"
	},
	CallOfTheElements =
	{
		SpellId = 108285,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HealingTideTotem =
	{
		SpellId = 108280,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Water Totems"
	},
	CloudburstTotem =
	{
		SpellId = 157153,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Water Totems"
	},
	StormElementalTotem =
	{
		SpellId = 152256,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Air Totems"
	},
	AncestralGuidance =
	{
		SpellId = 108281,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ElementalBlast =
	{
		SpellId = 117014,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	CleanseSpirit =
	{
		SpellId = 51886,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	TotemicRecall =
	{
		SpellId = 36936,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Purge =
	{
		SpellId = 370,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	RainOfFrogs =
	{
		SpellId = 147709,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SummonElementalFamiliar =
	{
		SpellId = 148118,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Shaman.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 77472; -- Healing Wave
	config["2"] = 8004; -- Исцеляющий всплеск
	config["3"] = 73685; -- Высвободить чары жизни
	config["shift2"] = 974; -- Щит земли
	config["shift3"] = 546; -- Хождение по воде
	config["control1"] = "16188,77472"; -- Instant Healing Wave
	config["control2"] = 61295; -- Быстрина
	config["alt1"] = 51886; -- Очищение духа
	config["alt2"] = 1064; -- Цепное исцеление
	config["alt3"] = "16188,1064"; -- Instant Цепное исцеление
	config["altshift3"] = 2008; -- Ancestral Spirit

	config["cooldown1"] = "WaterShield";
	config["cooldown2"] = "WindShear";
	config["cooldown3"] = "EarthShield";
	config["cooldown4"] = "CleanseSpirit";
	config["cooldown5"] = "SpiritLinkTotem";
	config["cooldown6"] = "HealingRain";
	config["cooldown7"] = "UnleashLife";
	config["cooldown8"] = "Riptide";
	config["cooldown9"] = "SpiritwalkersGrace";
	if UnitFactionGroup("player") == "Alliance" then
		config["cooldown10"] = "Heroism";
	else
		config["cooldown10"] = "Bloodlust";
	end;
	config["cooldown11"] = "TotemicProjection";
	config["cooldown12"] = "Ascendance";
	config["cooldown13"] = "AstralShift";
	config["cooldown14"] = "ElementalMastery";
	config["cooldown15"] = "HealingStreamTotem";
	config["cooldown16"] = "GroundingTotem";
	config["cooldown17"] = "CallOfTheElements";
	config["cooldown18"] = "EarthbindTotem";
	config["cooldown19"] = "TremorTotem";
	config["cooldown20"] = "CloudburstTotem";
	config["cooldown21"] = "StormElementalTotem";
	config["cooldown22"] = "EarthElementalTotem";
	config["cooldown23"] = "FireElementalTotem";
	config["cooldown24"] = "HealingTideTotem";
	config["cooldown25"] = "TotemicRecall";
	config["cooldown26"] = "Purge";
	config["cooldown27"] = "Hex";
	config["cooldown28"] = "StoneBulwarkTotem";
	config["cooldown29"] = "WindwalkTotem";
	config["cooldown30"] = "AncestralGuidance";
	config["cooldown31"] = "ChainHeal";
	config["cooldown32"] = "ElementalBlast";
	config["cooldown33"] = "InstantElementalBlast";
	config["cooldown34"] = "InstantHealingRain";
	config["cooldown35"] = "AncestralSwiftness";
	config["cooldown36"] = orlanHeal:GetRacialCooldown();
	config["cooldown37"] = "Trinket0";
	config["cooldown38"] = "Trinket1";

	return config;
end;

function OrlanHeal.Shaman.LoadConfig(orlanHeal)
end;

function OrlanHeal.Shaman.GetConfigPresets(orlanHeal)
	return
		{
			["Shaman Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Shaman.UpdateRaidBorder(orlanHeal)
	local isRiptideReady = orlanHeal:IsSpellReady(61295);
	local isAncestralSwiftnessReady = orlanHeal:IsSpellReady(16188);
	local spiritwalkersGraceSpellName = GetSpellInfo(79206);
	if UnitBuff("player", spiritwalkersGraceSpellName) then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif isRiptideReady then
		if isAncestralSwiftnessReady then
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
		else
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
		end;
	else
		if isAncestralSwiftnessReady then
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha);
		else
			if orlanHeal:IsSpellReady(79206) then -- Spiritwalker's Grace
				orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
			else
				orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
			end;
		end;
	end;
end;

OrlanHeal.Shaman.PlayerSpecificBuffCount = 2;

function OrlanHeal.Shaman.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if spellId == 974 then -- Щит земли
		buffKind = 1;
	end;
	if spellId == 61295 then -- Быстрина
		buffKind = 2;
	end;
	return buffKind;
end;

OrlanHeal.Shaman.PoisonDebuffKind = 2;
OrlanHeal.Shaman.DiseaseDebuffKind = 2;
OrlanHeal.Shaman.MagicDebuffKind = 1;
OrlanHeal.Shaman.CurseDebuffKind = 1;
OrlanHeal.Shaman.PlayerDebuffSlots = { 1, 0, 0, 0, 0 };
OrlanHeal.Shaman.PetDebuffSlots = { 1, 0 };

function OrlanHeal.Shaman.GetSpecificDebuffKind(orlanHeal, spellId)
	local debuffKind;
	return debuffKind;
end;
