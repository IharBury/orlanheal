﻿OrlanHeal.Paladin = {};

OrlanHeal.Paladin.IsSupported = true;
OrlanHeal.Paladin.GiftOfTheNaaruSpellId = 59542;

function OrlanHeal.Paladin.GetEffectiveHolyPower()
	local power = UnitPower("player", SPELL_POWER_HOLY_POWER);
	if UnitBuff("player", GetSpellInfo(90174)) then -- Divine Purpose
		power = power + 3;
	end;
	return power;
end;

function OrlanHeal.Paladin.IsUrgentToSpendHolyPower()
	local _, _, _, _, _, _, expiration = UnitBuff("player", GetSpellInfo(90174)); -- Divine Purpose
	local timeLeft;
	if expiration then
		timeLeft = expiration - GetTime();
	end;
	local power = UnitPower("player", SPELL_POWER_HOLY_POWER);
	local maxPower = UnitPowerMax("player", SPELL_POWER_HOLY_POWER);
	return (power == maxPower) or (timeLeft and (timeLeft < 2));
end;

function OrlanHeal.Paladin.UpdateHolyPowerScalingAbilityCooldown(orlanHeal, window)
	local power = orlanHeal.Paladin.GetEffectiveHolyPower();
	if power >= 1 then
		local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
		local expirationTime;
		if start and duration and (duration ~= 0) and (enabled == 1) then
			expirationTime = start + duration;
		else
			start = nil;
			duration = nil;
			expirationTime = nil;
		end;
		local abilityPower = power;
		if power > 3 then
			abilityPower = 3;
		end;
		orlanHeal:UpdateCooldown(window, duration, expirationTime, abilityPower, true);
	else
		window:SetReverse(true);
		if not window.Dark then
			window:SetCooldown(0, 10);
			window.Dark = true;
		end;
		window.Count:SetText(0);
	end;
end;

OrlanHeal.Paladin.AvailableSpells =
{
	19750, -- Flash of Light
	1022, -- Hand of Protection
	4987, -- Cleanse
	20473, -- Holy Shock
	633, -- Lay on Hands
	85673, -- Word of Glory
	82326, -- Holy Light
	53563, -- Beacon of Light
	6940, -- Hand of Sacrifice
	1044, -- Hand of Freedom
	59542, -- Дар наауру
	20217, -- Blessing of Kings
	7328, -- Redemption
	19740, -- Blessing of Might
	82327, -- Holy Radiance
	20925, -- Sacred Shield
	114039, -- Hand of Purity
	114165, -- Holy Prism
	114157 -- Execution Sentence
};

OrlanHeal.Paladin.CooldownOptions =
{
	LightOfDawn =
	{
		SpellId = 85222, -- Light of Dawn
		Update = OrlanHeal.Paladin.UpdateHolyPowerScalingAbilityCooldown
	},
	LayOnHands =
	{
		SpellId = 633, -- Lay on Hands
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AvengingWrath =
	{
		SpellId = 31842, -- Avenging Wrath
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AuraMastery =
	{
		SpellId = 31821, -- Devotion Aura
		Update = OrlanHeal.UpdateAbilityCooldown
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
	HammerOfJustice =
	{
		SpellId = 853, -- Hammer of Justice
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyShock =
	{
		SpellId = 20473, -- Holy Shock
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Cleanse =
	{
		SpellId = 4987, -- Cleanse
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	CrusaderStrike =
	{
		SpellId = 35395, -- Crusader Strike
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HammerOfWrath =
	{
		SpellId = 24275, -- Hammer of Wrath
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Judgment =
	{
		SpellId = 20271, -- Judgment
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ArcaneTorrent =
	{
		SpellId = 28730, -- Arcane Torrent
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "BloodElf";
		end
	},
	Reckoning =
	{
		SpellId = 62124, -- Reckoning
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EternalFlame =
	{
		SpellId = 85673, -- Word of Glory
		AuraId = 156322, -- Eternal Flame
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	},
	SacredShield =
	{
		SpellId = 20925, -- Sacred Shield
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	},
	BeaconOfLight =
	{
		SpellId = 53563, -- Beacon of Light
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SpeedOfLight =
	{
		SpellId = 85499, -- Speed of Light
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfPurity =
	{
		SpellId = 114039, -- Hand of Purity
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyPrism =
	{
		SpellId = 114165, -- Holy Prism
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LightsHammer =
	{
		SpellId = 114158, -- Light's Hammer
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ExecutionSentence =
	{
		SpellId = 114157, -- Execution Sentence
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BlindingLight =
	{
		SpellId = 115750, -- Blinding Light
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Contemplation =
	{
		SpellId = 121183, -- Contemplation
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Repentance =
	{
		SpellId = 20066, -- Repentance
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyAvenger =
	{
		SpellId = 105809, -- Holy Avenger
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Paladin.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 82326; -- Holy Light
	config["2"] = 19750; -- Flash of Light
	config["3"] = 1022; -- Hand of Protection
	config["shift2"] = 53563; -- Beacon of Light
	config["control2"] = 85673; -- Word of Glory
	config["control3"] = 6940; -- Hand of Sacrifice
	config["alt1"] = 4987; -- Cleanse
	config["alt2"] = 20473; -- Holy Shock
	config["alt3"] = 633; -- Lay on Hands
	config["controlalt1"] = 82327; -- Holy Radiance
	config["controlalt2"] = 20925; -- Sacred Shield
	config["altshift1"] = 114039; -- Hand of Purity
	config["altshift3"] = 7328; -- Redemption

	config["cooldown1"] = "Cleanse";
	config["cooldown2"] = "BeaconOfLight";
	config["cooldown4"] = "LightOfDawn";
	config["cooldown5"] = "LayOnHands";
	config["cooldown6"] = "AvengingWrath";
	config["cooldown9"] = "AuraMastery";
	config["cooldown11"] = "HandOfProtection";
	config["cooldown12"] = "HandOfPurity";
	config["cooldown13"] = "HandOfSacrifice";
	config["cooldown15"] = "HandOfFreedom";
	config["cooldown16"] = "HolyPrism";
	config["cooldown17"] = "BlindingLight";
	config["cooldown18"] = "SpeedOfLight";
	config["cooldown19"] = "Repentance";
	config["cooldown20"] = "SacredShield";
	config["cooldown22"] = orlanHeal:GetRacialCooldown();

	config["controlalt1update"] = 1;

	return config;
end;

function OrlanHeal.Paladin.LoadConfig(orlanHeal)
	if (orlanHeal.Config["controlalt1update"] ~= 1) and (orlanHeal.Config["controlalt1"] == "") then
		orlanHeal.Config["controlalt1"] = 82327; -- Holy Radiance
	end;
	if orlanHeal.Config["1"] == 635 then -- legacy Holy Light
		orlanHeal.Config["1"] = 82326; -- Holy Light
	end;
	orlanHeal.Config["controlalt1update"] = 1;
end;

function OrlanHeal.Paladin.GetConfigPresets(orlanHeal)
	return
		{
			["Paladin Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Paladin.UpdateRaidBorder(orlanHeal)
	local infusionOfLightSpellName = GetSpellInfo(54149);
	local daybreakSpellName = GetSpellInfo(88819);
	local power = orlanHeal.Paladin.GetEffectiveHolyPower();

	if orlanHeal.Paladin.IsUrgentToSpendHolyPower() and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0.3, 1, 0.3, orlanHeal.RaidBorderAlpha);
	elseif (power >= 3) and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", infusionOfLightSpellName) then -- Infusion of Light
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", daybreakSpellName) -- Daybreak
			and orlanHeal:IsSpellReady(20473) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif orlanHeal:IsSpellReady(20473) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif (power == 2) and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0.5, 0, orlanHeal.RaidBorderAlpha);
	elseif (power == 1) and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha);
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Paladin.PlayerSpecificBuffCount = 2;

function OrlanHeal.Paladin.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 53563) and (caster ~= nil) and UnitIsUnit(caster, "player") or -- своя Частица Света
			(spellId == 1022) or -- Длань защиты
			(spellId == 6940) or -- Hand of Sacrifice
			(spellId == 114039) then -- Hand of Purity
		buffKind = 1;
	elseif (spellId == 156322) and (caster ~= nil) and UnitIsUnit(caster, "player") or -- свой Eternal Flame
			(spellId == 20925) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- свой Sacred Shield
		buffKind = 2;
	end;

	return buffKind;
end;

OrlanHeal.Paladin.PoisonDebuffKind = 1;
OrlanHeal.Paladin.DiseaseDebuffKind = 1;
OrlanHeal.Paladin.MagicDebuffKind = 1;
OrlanHeal.Paladin.CurseDebuffKind = 2;
OrlanHeal.Paladin.PlayerDebuffSlots = { 1, 0, 0, 0, 0 };
OrlanHeal.Paladin.PetDebuffSlots = { 1, 0 };

function OrlanHeal.Paladin.GetSpecificDebuffKind(orlanHeal, spellId)
end;
