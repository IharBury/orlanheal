OrlanHeal.Shaman = {};

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
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EarthlivingWeapon =
	{
		SpellId = 51730, -- Оружие жизни земли
		IsReverse = true,
		Duration = 30 * 60,
		Update = OrlanHeal.UpdateMainHandTemporaryEnchantCooldown
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
