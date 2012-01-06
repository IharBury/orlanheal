OrlanHeal.Paladin = {};

OrlanHeal.Paladin.IsSupported = true;

OrlanHeal.Paladin.AvailableSpells =
{
	635, -- Holy Light
	19750, -- Flash of Light
	1022, -- Hand of Protection
	4987, -- Cleanse
	20473, -- Holy Shock
	633, -- Lay on Hands
	85673, -- Word of Glory
	1038, -- Hand of Salvation
	82326, -- Divine Light
	53563, -- Beacon of Light
	6940, -- Hand of Sacrifice
	1044, -- Hand of Freedom
	59542, -- Дар наауру
	20217, -- Blessing of Kings
	7328, -- Redemption
	31789, -- Righteous Defense
	19740, -- Blessing of Might
	82327 -- Holy Radiance
};

OrlanHeal.Paladin.CooldownOptions =
{
	JudgementsOfThePure =
	{
		SpellId = 20271, -- Judgement
		AuraId = 53655, -- Judgements of the Pure
		IsReverse = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown
	},
	BeaconOfLight =
	{
		SpellId = 53563, -- Beacon of Light
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	},
	HolyRadiance =
	{
		SpellId = 82327, -- Holy Radiance
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LightOfDawn =
	{
		SpellId = 85222 -- Light of Dawn
	},
	LayOnHands =
	{
		SpellId = 633, -- Lay on Hands
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AvengingWrath =
	{
		SpellId = 31884, -- Avenging Wrath
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineFavor =
	{
		SpellId = 31842, -- Divine Favor
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	GuardianOfAncientKings =
	{
		SpellId = 86150, -- Guardian of Ancient Kings
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AuraMastery =
	{
		SpellId = 31821, -- Aura Mastery
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivinePlea =
	{
		SpellId = 54428, -- Divine Plea
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SealOfInsight =
	{
		SpellId = 20165, -- Seal of Insight
		IsReverse = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown
	},
	GiftOfTheNaaru =
	{
		SpellId = 59542, -- Gift of the Naaru
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Draenei";
		end
	},
	Rebuke =
	{
		SpellId = 96231, -- Rebuke
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineProtection =
	{
		SpellId = 498, -- Divine Protection
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineShield =
	{
		SpellId = 642, -- Divine Shield
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfSacrifice =
	{
		SpellId = 6940, -- Hand of Sacrifice
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfProtection =
	{
		SpellId = 1022, -- Hand of Protection
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfFreedom =
	{
		SpellId = 1044, -- Hand of Freedom
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfSalvation =
	{
		SpellId = 1038, -- Hand of Salvation
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HammerOfJustice =
	{
		SpellId = 853, -- Hammer of Justice
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyShock =
	{
		SpellId = 20473, -- Holy Shock
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Paladin.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 635; -- Holy Light
	config["2"] = 19750; -- Flash of Light
	config["3"] = 1022; -- Hand of Protection
	config["shift2"] = 53563; -- Beacon of Light
	config["shift3"] = 1038; -- Hand of Salvation
	config["control1"] = 82326; -- Divine Light
	config["control2"] = 85673; -- Word of Glory
	config["control3"] = 6940; -- Hand of Sacrifice
	config["alt1"] = 4987; -- Cleanse
	config["alt2"] = 20473; -- Holy Shock
	config["alt3"] = 633; -- Lay on Hands
	config["controlalt1"] = 82327; -- Holy Radiance

	config["cooldown1"] = "JudgementsOfThePure";
	config["cooldown2"] = "BeaconOfLight";
	config["cooldown3"] = "HolyRadiance";
	config["cooldown4"] = "LightOfDawn";
	config["cooldown5"] = "LayOnHands";
	config["cooldown6"] = "AvengingWrath";
	config["cooldown7"] = "DivineFavor";
	config["cooldown8"] = "GuardianOfAncientKings";
	config["cooldown9"] = "AuraMastery";
	config["cooldown10"] = "DivinePlea";

	config["controlalt1update"] = 1;

	return config;
end;

function OrlanHeal.Paladin.LoadConfig(orlanHeal)
	if (orlanHeal.Config["controlalt1update"] ~= 1) and (orlanHeal.Config["controlalt1"] == "") then
		orlanHeal.Config["controlalt1"] = 82327; -- Holy Radiance
	end;
	orlanHeal.Config["controlalt1update"] = 1;
end;

OrlanHeal.Paladin.RedRangeSpellId = 53563; -- Частица Света
OrlanHeal.Paladin.OrangeRangeSpellId = 635; -- Holy Light
OrlanHeal.Paladin.YellowRangeSpellId = 1022; -- Hand of Protection

function OrlanHeal.Paladin.UpdateRaidBorder(orlanHeal)
	local infusionOfLightSpellName = GetSpellInfo(54149);
	local daybreakSpellName = GetSpellInfo(88819);

	if (UnitPower("player", SPELL_POWER_HOLY_POWER) == 3)
			and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", infusionOfLightSpellName) then -- Infusion of Light
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", daybreakSpellName) -- Daybreak
			and orlanHeal:IsSpellReady(20473) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif orlanHeal:IsSpellReady(20473) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif (UnitPower("player", SPELL_POWER_HOLY_POWER) == 2)
			and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0.5, 0, orlanHeal.RaidBorderAlpha);
	elseif (UnitPower("player", SPELL_POWER_HOLY_POWER) == 1)
			and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha);
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Paladin.PlayerSpecificBuffCount = 1;

function OrlanHeal.Paladin.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 53563) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) or -- своя Частица Света
			(spellId == 1022) or -- Длань защиты
			(spellId == 5599) or -- Длань защиты
			(spellId == 10278) or -- Длань защиты
			(spellId == 1038) then -- Длань спасения
		buffKind = 1;
	end;

	return buffKind;
end;

OrlanHeal.Paladin.PoisonDebuffKind = 1;
OrlanHeal.Paladin.DiseaseDebuffKind = 1;
OrlanHeal.Paladin.MagicDebuffKind = 1;
OrlanHeal.Paladin.CurseDebuffKind = 2;
OrlanHeal.Paladin.PlayerDebuffSlots = { 1, 1, 2, 0, 0 };
OrlanHeal.Paladin.PetDebuffSlots = { 0, 0 };

function OrlanHeal.Paladin.GetSpecificDebuffKind(orlanHeal, spellId)
end;
