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
		macrotext = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(331),
		key = "16188,331"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(8004), -- Исцеляющий всплеск
		group = GetSpellInfo(16188), -- Природная стремительность
		macrotext = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(8004),
		key = "16188,8004"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(1064), -- Цепное исцеление
		group = GetSpellInfo(16188), -- Природная стремительность
		macrotext = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(1064),
		key = "16188,1064"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(77472), -- Великая волна исцеления
		group = GetSpellInfo(16188), -- Природная стремительность
		macrotext = "/cast " .. GetSpellInfo(16188) .. "\n/cast " .. GetSpellInfo(77472),
		key = "16188,77472"
	}
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
		Update = OrlanHeal.UpdateAbilityCooldown
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
	}
};

function OrlanHeal.Shaman.LoadSetup(orlanHeal)
	orlanHeal.Config["1"] = orlanHeal.Config["1"] or 331; -- Волна исцеления
	orlanHeal.Config["2"] = orlanHeal.Config["2"] or 8004; -- Исцеляющий всплеск
	orlanHeal.Config["3"] = orlanHeal.Config["3"] or 73680; -- Высвободить чары стихий
	orlanHeal.Config["shift2"] = orlanHeal.Config["shift2"] or 974; -- Щит земли
	orlanHeal.Config["shift3"] = orlanHeal.Config["shift3"] or 546; -- Хождение по воде
	orlanHeal.Config["control1"] = orlanHeal.Config["control1"] or 77472; -- Великая волна исцеления
	orlanHeal.Config["control2"] = orlanHeal.Config["control2"] or 61295; -- Быстрина
	orlanHeal.Config["control3"] = orlanHeal.Config["control3"] or "16188,77472"; -- Instant Великая волна исцеления
	orlanHeal.Config["alt1"] = orlanHeal.Config["alt1"] or 51886; -- Очищение духа
	orlanHeal.Config["alt2"] = orlanHeal.Config["alt2"] or 1064; -- Цепное исцеление
	orlanHeal.Config["alt3"] = orlanHeal.Config["alt3"] or "16188,1064"; -- Instant Цепное исцеление

	orlanHeal.Config["cooldown1"] = orlanHeal.Config["cooldown1"] or "WaterShield";
	orlanHeal.Config["cooldown2"] = orlanHeal.Config["cooldown2"] or "EarthlivingWeapon";
	orlanHeal.Config["cooldown3"] = orlanHeal.Config["cooldown3"] or "EarthShield";
	orlanHeal.Config["cooldown4"] = orlanHeal.Config["cooldown4"] or "ManaTideTotem";
	orlanHeal.Config["cooldown5"] = orlanHeal.Config["cooldown5"] or "SpiritLinkTotem";
	orlanHeal.Config["cooldown6"] = orlanHeal.Config["cooldown6"] or "HealingRain";
	orlanHeal.Config["cooldown7"] = orlanHeal.Config["cooldown7"] or "UnleashElements";
	orlanHeal.Config["cooldown8"] = orlanHeal.Config["cooldown8"] or "Riptide";
	orlanHeal.Config["cooldown9"] = orlanHeal.Config["cooldown9"] or "SpiritwalkersGrace";
	if UnitFactionGroup("player") == "Alliance" then
		orlanHeal.Config["cooldown10"] = orlanHeal.Config["cooldown10"] or "Heroism";
	else
		orlanHeal.Config["cooldown10"] = orlanHeal.Config["cooldown10"] or "Bloodlust";
	end;
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
	if (spellId == 974) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- свой Щит земли
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
