OrlanHeal.Paladin = {};

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
	156910, -- Частица Веры
	157007, -- Beacon of Insight
	6940, -- Hand of Sacrifice
	1044, -- Hand of Freedom
	59542, -- Дар наауру
	20217, -- Blessing of Kings
	7328, -- Redemption
	19740, -- Blessing of Might
	82327, -- Holy Radiance
	20925, -- Sacred Shield
	114039, -- Hand of Purity
	{
		type = "macro",
		caption = GetSpellInfo(175699), -- Weapons of Light
		macrotext = OrlanHeal:BuildMouseOverCastMacro(175699),
		key = 175699
	},
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
		AuraId = 148039, -- Sacred Shield
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	},
	BeaconOfLight =
	{
		SpellId = 53563, -- Beacon of Light
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BeaconOfFaith =
	{
		SpellId = 156910, -- Beacon of Faith
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BeaconOfInsight =
	{
		SpellId = 157007, -- Beacon of Insight
		Update = OrlanHeal.UpdateRaidBuffCooldown
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
	WeaponsOfTheLight =
	{
		MacroText = "/cast " .. GetSpellInfo(175699),
		SpellId = 175699, -- Weapons of the Light
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
	},
	TurnEvil =
	{
		SpellId = 10326, -- Turn Evil
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HammerOfJustice =
	{
		SpellId = 853, -- Hammer of Justice
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Paladin.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 82326; -- Holy Light
	config["2"] = 19750; -- Flash of Light
	config["3"] = 1022; -- Hand of Protection
	config["shift2"] = 53563; -- Beacon of Light
	config["shift3"] = 157007; -- Beacon of Insight
	config["control1"] = 82327; -- Holy Radiance
	config["control2"] = 85673; -- Word of Glory
	config["control3"] = 6940; -- Hand of Sacrifice
	config["alt1"] = 4987; -- Cleanse
	config["alt2"] = 20473; -- Holy Shock
	config["alt3"] = 633; -- Lay on Hands
	config["controlalt1"] = 175699; -- Weapons of Light
	config["controlalt2"] = 20925; -- Sacred Shield
	config["altshift1"] = 114039; -- Hand of Purity
	config["altshift2"] = 156910; -- Beacon of Faith
	config["altshift3"] = 7328; -- Redemption

	config["cooldown1"] = "Cleanse";
	config["cooldown2"] = "BeaconOfInsight";
	config["cooldown3"] = "LightOfDawn";
	config["cooldown4"] = "SpeedOfLight";
	config["cooldown5"] = "SacredShield";
	config["cooldown6"] = "LayOnHands";
	config["cooldown7"] = "AvengingWrath"; 
	config["cooldown8"] = "DivineShield"; 
	config["cooldown9"] = "DivineProtection"; 
	config["cooldown10"] = "AuraMastery";
	config["cooldown11"] = "HandOfProtection";
	config["cooldown12"] = "HandOfPurity";
	config["cooldown13"] = "HandOfSacrifice";
	config["cooldown14"] = "HandOfFreedom";
	config["cooldown15"] = "HammerOfJustice";
	config["cooldown16"] = "WeaponsOfTheLight";
	config["cooldown17"] = "Repentance";
	config["cooldown18"] = "BlindingLight";
	config["cooldown19"] = orlanHeal:GetRacialCooldown();

	return config;
end;

function OrlanHeal.Paladin.LoadConfig(orlanHeal)
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
	local enhancedHolyShockName = GetSpellInfo(160002);
	local power = orlanHeal.Paladin.GetEffectiveHolyPower();

	if orlanHeal.Paladin.IsUrgentToSpendHolyPower() and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0.5, 1, 0.5, orlanHeal.RaidBorderAlpha);
	elseif (power >= 3) and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", infusionOfLightSpellName) then -- Infusion of Light
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
	elseif (UnitBuff("player", daybreakSpellName) -- Daybreak
				or UnitBuff("player", enhancedHolyShockName)) -- Enhanced Holy Shock
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

OrlanHeal.Paladin.PlayerSpecificBuffCount = 3;

function OrlanHeal.Paladin.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 53563) and (caster ~= nil) and UnitIsUnit(caster, "player") or -- своя Частица Света
			(spellId == 156910) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- своя Частица Веры
		buffKind = 1;
	elseif (spellId == 157007) and (caster ~= nil) and UnitIsUnit(caster, "player") or -- own Beacon of Insight
			(spellId == 1022) or -- Длань защиты
			(spellId == 6940) or -- Hand of Sacrifice
			(spellId == 114039) then -- Hand of Purity
		buffKind = 2;
	elseif (spellId == 156322) and (caster ~= nil) and UnitIsUnit(caster, "player") or -- свой Eternal Flame
			(spellId == 20925) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- свой Sacred Shield
		buffKind = 3;
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
