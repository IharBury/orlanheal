﻿OrlanHeal.Shaman = {};

OrlanHeal.Shaman.IsSupported = true;

OrlanHeal.Shaman.AvailableSpells =
{
	331, -- Волна исцеления
	974, -- Щит земли
	51886, -- Очищение духа
	8004, -- Исцеляющий всплеск
	546, -- Хождение по воде
	1064, -- Цепное исцеление
	77472, -- Великая волна исцеления
	61295, -- Быстрина
	73680, -- Высвободить чары стихий
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(331), -- Волна исцеления
		group = GetSpellInfo(16188), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(16188, 331),
		key = "16188,331"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(8004), -- Исцеляющий всплеск
		group = GetSpellInfo(16188), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(16188, 8004),
		key = "16188,8004"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(1064), -- Цепное исцеление
		group = GetSpellInfo(16188), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(16188, 1064),
		key = "16188,1064"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(77472), -- Великая волна исцеления
		group = GetSpellInfo(16188), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(16188, 77472),
		key = "16188,77472"
	},
	2008 -- Ancestral Spirit
};

OrlanHeal.Shaman.CooldownOptions =
{
	WaterShield =
	{
		SpellId = 52127, -- Водный щит
		IsReverse = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown
	},
	EarthShield =
	{
		SpellId = 974, -- Щит земли
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	},
	NaturesSwiftness =
	{
		SpellId = 16188, -- Природная стремительность
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ManaTideTotem =
	{
		SpellId = 16190, -- Тотем прилива маны
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Water Totems"
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
	UnleashElements =
	{
		SpellId = 73680,
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
	EarthShock =
	{
		SpellId = 8042,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Shock"
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
	}
};

if GetBuildInfo() == "5.0.4" then
	OrlanHeal.Shaman.CooldownOptions.CapacitorTotem =
	{
		SpellId = 108269,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Air Totems"
	};
	OrlanHeal.Shaman.CooldownOptions.StormlashTotem =
	{
		SpellId = 120668,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Air Totems"
	};
	OrlanHeal.Shaman.CooldownOptions.WindwalkTotem =
	{
		SpellId = 108273,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Air Totems"
	};
	OrlanHeal.Shaman.CooldownOptions.AstralShift =
	{
		SpellId = 108271,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Shaman.CooldownOptions.TotemicProjection =
	{
		SpellId = 108287,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Shaman.CooldownOptions.EarthlivingWeapon =
	{
		SpellId = 51730, -- Оружие жизни земли
		IsReverse = true,
		Duration = 60 * 60,
		Update = OrlanHeal.UpdateMainHandTemporaryEnchantCooldown
	};
	OrlanHeal.Shaman.CooldownOptions.Ascendance =
	{
		SpellId = 114049,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Shaman.CooldownOptions.StoneBulwarkTotem =
	{
		SpellId = 108270,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Earth Totems"
	};
	OrlanHeal.Shaman.CooldownOptions.CallOfTheElements =
	{
		SpellId = 108285,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Shaman.CooldownOptions.HealingTideTotem =
	{
		SpellId = 108280,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Water Totems"
	};
	OrlanHeal.Shaman.CooldownOptions.AncestralGuidance =
	{
		SpellId = 108281,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
else
	OrlanHeal.Shaman.CooldownOptions.EarthlivingWeapon =
	{
		SpellId = 51730, -- Оружие жизни земли
		IsReverse = true,
		Duration = 30 * 60,
		Update = OrlanHeal.UpdateMainHandTemporaryEnchantCooldown
	};
end;

function OrlanHeal.Shaman.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 331; -- Волна исцеления
	config["2"] = 8004; -- Исцеляющий всплеск
	config["3"] = 73680; -- Высвободить чары стихий
	config["shift2"] = 974; -- Щит земли
	config["shift3"] = 546; -- Хождение по воде
	config["control1"] = 77472; -- Великая волна исцеления
	config["control2"] = 61295; -- Быстрина
	config["control3"] = "16188,77472"; -- Instant Великая волна исцеления
	config["alt1"] = 51886; -- Очищение духа
	config["alt2"] = 1064; -- Цепное исцеление
	config["alt3"] = "16188,1064"; -- Instant Цепное исцеление

	config["cooldown1"] = "WaterShield";
	config["cooldown2"] = "EarthlivingWeapon";
	config["cooldown3"] = "EarthShield";
	config["cooldown4"] = "ManaTideTotem";
	config["cooldown5"] = "SpiritLinkTotem";
	config["cooldown6"] = "HealingRain";
	config["cooldown7"] = "UnleashElements";
	config["cooldown8"] = "Riptide";
	config["cooldown9"] = "SpiritwalkersGrace";
	if UnitFactionGroup("player") == "Alliance" then
		config["cooldown10"] = "Heroism";
	else
		config["cooldown10"] = "Bloodlust";
	end;

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

OrlanHeal.Shaman.RedRangeSpellId = 331; -- Волна исцеления
OrlanHeal.Shaman.OrangeRangeSpellId = 331; -- Волна исцеления
OrlanHeal.Shaman.YellowRangeSpellId = 546; -- Хождение по воде

function OrlanHeal.Shaman.UpdateRaidBorder(orlanHeal)
	local isRiptideReady = orlanHeal:IsSpellReady(61295);
	local isNaturesSwiftnessReady = orlanHeal:IsSpellReady(16188);
	local spiritwalkersGraceSpellName = GetSpellInfo(79206);
	if UnitBuff("player", spiritwalkersGraceSpellName) then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif isRiptideReady then
		if isNaturesSwiftnessReady then
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
		else
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
		end;
	else
		if isNaturesSwiftnessReady then
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

OrlanHeal.Shaman.PoisonDebuffKind = 4;
OrlanHeal.Shaman.DiseaseDebuffKind = 4;
OrlanHeal.Shaman.MagicDebuffKind = 2;
OrlanHeal.Shaman.CurseDebuffKind = 1;
OrlanHeal.Shaman.PlayerDebuffSlots = { 1, 2, 0, 0, 0 };
OrlanHeal.Shaman.PetDebuffSlots = { 0, 0 };

function OrlanHeal.Shaman.GetSpecificDebuffKind(orlanHeal, spellId)
	local debuffKind;
	return debuffKind;
end;
