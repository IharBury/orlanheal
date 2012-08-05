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
	AuraMastery =
	{
		SpellId = 31821, -- Aura Mastery / Devotion Aura
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
	DivineFavor =
	{
		SpellId = 31842, -- Divine Favor
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
	Reckoning =
	{
		SpellId = 62124, -- Reckoning
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

if GetBuildInfo() == "5.0.4" then
	table.insert(OrlanHeal.Paladin.AvailableSpells, 20925); -- Sacred Shield
	table.insert(OrlanHeal.Paladin.AvailableSpells, 114039); -- Hand of Purity
	table.insert(OrlanHeal.Paladin.AvailableSpells, 114165); -- Holy Prism
	table.insert(OrlanHeal.Paladin.AvailableSpells, 114157); -- Execution Sentence
	table.insert(OrlanHeal.Paladin.AvailableSpells, 110501); -- Symbiosis
	OrlanHeal.Paladin.CooldownOptions["EternalFlame"] =
	{
		SpellId = 85673, -- Word of Glory
		AuraId = 114163, -- Eternal Flame
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["SacredShield"] =
	{
		SpellId = 20925, -- Sacred Shield
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["BeaconOfLight"] =
	{
		SpellId = 53563, -- Beacon of Light
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["SpeedOfLight"] =
	{
		SpellId = 85499, -- Speed of Light
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["HandOfPurity"] =
	{
		SpellId = 114039, -- Hand of Purity
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["HolyPrism"] =
	{
		SpellId = 114165, -- Holy Prism
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["LightsHammer"] =
	{
		SpellId = 114158, -- Light's Hammer
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["ExecutionSentence"] =
	{
		SpellId = 114157, -- Execution Sentence
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["GuardianOfAncientKings"] =
	{
		SpellId = 86669, -- Guardian of Ancient Kings
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["BlindingLight"] =
	{
		SpellId = 115750, -- Blinding Light
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["Contemplation"] =
	{
		SpellId = 121183, -- Contemplation
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["Repentance"] =
	{
		SpellId = 20066, -- Repentance
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["HolyAvenger"] =
	{
		SpellId = 105809, -- Holy Avenger
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions.Symbiosis =
	{
		SpellId = 110501,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
else
	OrlanHeal.Paladin.CooldownOptions["JudgementsOfThePure"] =
	{
		SpellId = 20271, -- Judgement
		AuraId = 53655, -- Judgements of the Pure
		IsReverse = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["GuardianOfAncientKings"] =
	{
		SpellId = 86150, -- Guardian of Ancient Kings
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Paladin.CooldownOptions["BeaconOfLight"] =
	{
		SpellId = 53563, -- Beacon of Light
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	};
end;

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
	config["controlalt2"] = 20925; -- Sacred Shield
	config["controlalt3"] = 110501; -- Symbiosis

	config["cooldown1"] = "Cleanse";
	config["cooldown2"] = "BeaconOfLight";
	config["cooldown3"] = "HolyRadiance";
	config["cooldown4"] = "LightOfDawn";
	config["cooldown5"] = "LayOnHands";
	config["cooldown6"] = "AvengingWrath";
	config["cooldown7"] = "DivineFavor";
	config["cooldown8"] = "GuardianOfAncientKings";
	config["cooldown9"] = "AuraMastery";
	config["cooldown10"] = "DivinePlea";
	config["cooldown11"] = "HandOfProtection";
	config["cooldown12"] = "HandOfPurity";
	config["cooldown13"] = "HandOfSacrifice";
	config["cooldown14"] = "HandOfSalvation";
	config["cooldown15"] = "HandOfFreedom";
	config["cooldown16"] = "HolyPrism";
	config["cooldown17"] = "BlindingLight";
	config["cooldown18"] = "SpeedOfLight";
	config["cooldown19"] = "Repentance";
	config["cooldown20"] = "SacredShield";
	config["cooldown21"] = "Symbiosis";

	config["controlalt1update"] = 1;

	return config;
end;

function OrlanHeal.Paladin.LoadConfig(orlanHeal)
	if (orlanHeal.Config["controlalt1update"] ~= 1) and (orlanHeal.Config["controlalt1"] == "") then
		orlanHeal.Config["controlalt1"] = 82327; -- Holy Radiance
	end;
	orlanHeal.Config["controlalt1update"] = 1;
end;

function OrlanHeal.Paladin.GetConfigPresets(orlanHeal)
	return
		{
			["Paladin Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

OrlanHeal.Paladin.RedRangeSpellId = 53563; -- Частица Света
OrlanHeal.Paladin.OrangeRangeSpellId = 635; -- Holy Light
OrlanHeal.Paladin.YellowRangeSpellId = 20217; -- Blessing of Kings

function OrlanHeal.Paladin.UpdateRaidBorder(orlanHeal)
	local infusionOfLightSpellName = GetSpellInfo(54149);
	local daybreakSpellName = GetSpellInfo(88819);
	local divinePurposeSpellName = GetSpellInfo(90174);

	if (UnitPower("player", SPELL_POWER_HOLY_POWER) == 5)
			and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0.3, 1, 0.3, orlanHeal.RaidBorderAlpha);
	elseif ((UnitPower("player", SPELL_POWER_HOLY_POWER) >= 3)
				or (divinePurposeSpellName and UnitBuff("player", divinePurposeSpellName)))
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

OrlanHeal.Paladin.PlayerSpecificBuffCount = 2;

function OrlanHeal.Paladin.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 53563) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) or -- своя Частица Света
			(spellId == 1022) or -- Длань защиты
			(spellId == 5599) or -- Длань защиты
			(spellId == 10278) or -- Длань защиты
			(spellId == 1038) or  -- Длань спасения
			(spellId == 114039) then -- Hand of Purity
		buffKind = 1;
	elseif (spellId == 114163) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) or -- свой Eternal Flame
			(spellId == 20925) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- свой Sacred Shield
		buffKind = 2;
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
