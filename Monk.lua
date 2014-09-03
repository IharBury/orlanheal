OrlanHeal.Monk = {};

OrlanHeal.Monk.IsSupported = true;
OrlanHeal.Monk.GiftOfTheNaaruSpellId = 121093;

function OrlanHeal.Monk.UpdateChiAbilityCooldown(orlanHeal, window)
	local power = UnitPower("player", SPELL_POWER_CHI);
	local cost = window.Cooldown.ChiCost;
	if not cost then
		orlanHeal:UpdateAbilityCooldown(window);
	elseif power >= cost then
		local spellName = GetSpellInfo(window.Cooldown.SpellId);
		local start, duration, enabled = GetSpellCooldown(spellName);
		local expirationTime;
		if start and duration and (duration ~= 0) and (enabled == 1) then
			expirationTime = start + duration;
		else
			start = nil;
			duration = nil;
			expirationTime = nil;
		end;
		orlanHeal:UpdateCooldown(window, duration, expirationTime, power, true);
	else
		orlanHeal:UpdateCooldown(window, nil, nil, power, true);
	end;
end;

function OrlanHeal.Monk.UpdateChiRaidBuffCooldown(orlanHeal, window)
	local power = UnitPower("player", SPELL_POWER_CHI);
	local duration, expirationTime = orlanHeal:GetRaidBuffCooldown(window.Cooldown.AuraId or window.Cooldown.SpellId);
	orlanHeal:UpdateCooldown(window, duration, expirationTime, power, true);
end;

function OrlanHeal.Monk.UpdateManaTeaCooldown(orlanHeal, window)
	local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
	local expirationTime;
	if start and duration and (duration ~= 0) and (enabled == 1) then
		expirationTime = start + duration;
		orlanHeal:UpdateCooldown(window, duration, expirationTime, nil, nil, false);
	else
		local spellName = GetSpellInfo(window.Cooldown.AuraId or window.Cooldown.SpellId);
		if spellName then
			local _, _, _, count, _, duration, expirationTime = UnitBuff("player", spellName);
			orlanHeal:UpdateCooldown(window, duration, expirationTime, count, true, true);
		end;
	end;
end;

OrlanHeal.Monk.AvailableSpells =
{
	121093, -- Gift of the Naaru
	115098, -- Chi Wave
	124081, -- Zen Sphere
	123986, -- Chi Burst
	115450, -- Detox
	124682, -- Enveloping Mist
	116849, -- Life Cocoon
	115151, -- Renewing Mist
	115178, -- Resuscitate
	115175, -- Soothing Mist
	{
		type = "macro",
		caption = GetSpellInfo(116694), -- Surging Mist
		macrotext = "/cast [target=mouseover] " .. GetSpellInfo(116694),
		key = 116694,
		group = GetSpellInfo(116694)
	}, -- Surging Mist
	116841, -- Tiger's Lust
	{
		type = "macro",
		caption = "Double " .. GetSpellInfo(116694), -- Surging Mist
		macrotext = OrlanHeal:BuildCastSequenceMacro(116680, 116694),
		key = "116680,116694",
		group = GetSpellInfo(116694)
	}
};

OrlanHeal.Monk.CooldownOptions =
{
	GiftOfTheNaaru =
	{
		SpellId = 121093, -- Gift of the Naaru
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
	ArcaneTorrent =
	{
		SpellId = 129597, -- Arcane Torrent
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "BloodElf";
		end
	},
	TigersLust =
	{
		SpellId = 116841,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ChiWave =
	{
		SpellId = 115098,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ZenSphere =
	{
		SpellId = 124081,
		Update = OrlanHeal.Monk.UpdateChiRaidBuffCooldown,
		IsReverse = true
	},
	ChiBurst =
	{
		SpellId = 123986,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ChiBrew =
	{
		SpellId = 115399,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ChargingOxWave =
	{
		SpellId = 119392,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LegSweep =
	{
		SpellId = 119381,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DampenHarm =
	{
		SpellId = 122278,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DiffuseMagic =
	{
		SpellId = 122783,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	RushingJadeWind =
	{
		SpellId = 116847,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	InvokeXuenTheWhiteTiger =
	{
		SpellId = 123904,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Roll =
	{
		SpellId = 109132,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Detox =
	{
		SpellId = 115450,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EnvelopingMist =
	{
		SpellId = 124682,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ExpelHarm =
	{
		SpellId = 115072,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	FortifyingBrew =
	{
		SpellId = 115203,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DetonateChi =
	{
		SpellId = 115460,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LifeCocoon =
	{
		SpellId = 116849,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ManaTea =
	{
		SpellId = 115294,
		AuraId = 115867,
		Update = OrlanHeal.Monk.UpdateManaTeaCooldown
	},
	Paralysis =
	{
		SpellId = 115078,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Provoke =
	{
		SpellId = 115546,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	RenewingMist =
	{
		SpellId = 115151,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Revival =
	{
		SpellId = 115310,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SpearHandStrike =
	{
		SpellId = 116705,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SummonJadeSerpentStatue =
	{
		SpellId = 115313,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Uplift =
	{
		SpellId = 116670,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown,
		ChiCost = 2
	},
	ThunderFocusTea =
	{
		SpellId = 116680,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	TigerPalm =
	{
		SpellId = 100787,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	TouchOfDeath =
	{
		SpellId = 115080,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ZenMeditation =
	{
		SpellId = 115176,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ZenPilgrimage =
	{
		MacroText = "/cast " .. GetSpellInfo(126892),
		SpellId = 126892,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SurgingMist =
	{
		MacroText = "/cast " .. GetSpellInfo(116694),
		SpellId = 116694,
		Update = OrlanHeal.Monk.UpdateAbilityCooldown
	},
	Jab =
	{
		SpellId = 100780,
		Update = OrlanHeal.Monk.UpdateAbilityCooldown
	}
};

function OrlanHeal.Monk.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 115175; -- Soothing Mist
	config["2"] = 116694; -- Surging Mist
	config["3"] = 116849; -- Life Cocoon
	config["shift2"] = 115098; -- Chi Wave
	config["control1"] = 124682; -- Enveloping Mist
	config["control2"] = "116680,116694"; -- Thunder Focus Tea + Surging Mist
	config["control3"] = 116841; -- Tiger's Lust
	config["alt1"] = 115450; -- Detox
	config["alt2"] = 115151; -- Renewing Mist
	config["altshift3"] = 115178; -- Resuscitate

	config["cooldown1"] = "Detox";
	config["cooldown2"] = "SpearHandStrike";
	config["cooldown3"] = "SummonJadeSerpentStatue";
	config["cooldown4"] = "RenewingMist";
	config["cooldown5"] = "ExpelHarm";
	config["cooldown6"] = "FortifyingBrew";
	config["cooldown7"] = "LifeCocoon";
	config["cooldown8"] = "Revival";
	config["cooldown9"] = "DampenHarm";
	config["cooldown10"] = "ManaTea";
	config["cooldown11"] = "DetonateChi";
	config["cooldown12"] = "Paralysis";
	config["cooldown13"] = "Provoke"; -- убрать?
	config["cooldown14"] = "ZenMeditation";
	config["cooldown15"] = "Uplift";
	config["cooldown17"] = "ThunderFocusTea";
	config["cooldown18"] = "TigerPalm";
	config["cooldown19"] = "EnvelopingMist";
	config["cooldown20"] = "Roll";
	config["cooldown21"] = "TigersLust";
	config["cooldown22"] = "ChiWave";
	config["cooldown23"] = "TouchOfDeath";
	config["cooldown25"] = "LegSweep";
	config["cooldown26"] = orlanHeal:GetRacialCooldown();

	-- SurgingMist

	return config;
end;

OrlanHeal.Monk.PlayerSpecificBuffCount = 1;

OrlanHeal.Monk.PoisonDebuffKind = 1;
OrlanHeal.Monk.DiseaseDebuffKind = 1;
OrlanHeal.Monk.MagicDebuffKind = 1;
OrlanHeal.Monk.CurseDebuffKind = 2;
OrlanHeal.Monk.PlayerDebuffSlots = { 1, 0, 0, 0, 0 };
OrlanHeal.Monk.PetDebuffSlots = { 1, 0 };

function OrlanHeal.Monk.GetSpecificDebuffKind(orlanHeal, spellId)
end;

function OrlanHeal.Monk.UpdateRaidBorder(orlanHeal)
	local power = UnitPower("player", SPELL_POWER_CHI);
	local maxPower = UnitPowerMax("player", SPELL_POWER_CHI);
	if (power < maxPower) and orlanHeal:IsSpellReady(115151) then -- Renewing Mist
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif power >= 3 then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif power == 2 then	
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif power == 1 then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha);
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

function OrlanHeal.Monk.GetConfigPresets(orlanHeal)
	return
		{
			["Monk Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Monk.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local result;
	if (spellId == 119611) and caster and UnitIsUnit("player", caster) then
		result = 1;
	end;
	return result;
end;
