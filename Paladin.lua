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

function OrlanHeal.Paladin.LoadConfig(orlanHeal)
	orlanHeal.Config["1"] = orlanHeal.Config["1"] or 635; -- Holy Light
	orlanHeal.Config["2"] = orlanHeal.Config["2"] or 19750; -- Flash of Light
	orlanHeal.Config["3"] = orlanHeal.Config["3"] or 1022; -- Hand of Protection
	orlanHeal.Config["shift2"] = orlanHeal.Config["shift2"] or 53563; -- Beacon of Light
	orlanHeal.Config["shift3"] = orlanHeal.Config["shift3"] or 1038; -- Hand of Salvation
	orlanHeal.Config["control1"] = orlanHeal.Config["control1"] or 82326; -- Divine Light
	orlanHeal.Config["control2"] = orlanHeal.Config["control2"] or 85673; -- Word of Glory
	orlanHeal.Config["control3"] = orlanHeal.Config["control3"] or 6940; -- Hand of Sacrifice
	orlanHeal.Config["alt1"] = orlanHeal.Config["alt1"] or 4987; -- Cleanse
	orlanHeal.Config["alt2"] = orlanHeal.Config["alt2"] or 20473; -- Holy Shock
	orlanHeal.Config["alt3"] = orlanHeal.Config["alt3"] or 633; -- Lay on Hands
	orlanHeal.Config["controlalt1"] = orlanHeal.Config["controlalt1"] or 82327; -- Holy Radiance

	orlanHeal.Config["cooldown1"] = orlanHeal.Config["cooldown1"] or "JudgementsOfThePure";
	orlanHeal.Config["cooldown2"] = orlanHeal.Config["cooldown2"] or "BeaconOfLight";
	orlanHeal.Config["cooldown3"] = orlanHeal.Config["cooldown3"] or "HolyRadiance";
	orlanHeal.Config["cooldown4"] = orlanHeal.Config["cooldown4"] or "LightOfDawn";
	orlanHeal.Config["cooldown5"] = orlanHeal.Config["cooldown5"] or "LayOnHands";
	orlanHeal.Config["cooldown6"] = orlanHeal.Config["cooldown6"] or "AvengingWrath";
	orlanHeal.Config["cooldown7"] = orlanHeal.Config["cooldown7"] or "DivineFavor";
	orlanHeal.Config["cooldown8"] = orlanHeal.Config["cooldown8"] or "GuardianOfAncientKings";
	orlanHeal.Config["cooldown9"] = orlanHeal.Config["cooldown9"] or "AuraMastery";
	orlanHeal.Config["cooldown10"] = orlanHeal.Config["cooldown10"] or "DivinePlea";

	if (orlanHeal.Config["controlalt1update"] ~= 1) and (orlanHeal.Config["controlalt1"] == "") then
		orlanHeal.Config["controlalt1"] = 82327; -- Holy Radiance
		orlanHeal.Config["controlalt1update"] = 1;
	end;
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
