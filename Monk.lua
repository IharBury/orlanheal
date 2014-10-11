OrlanHeal.Monk = {};

OrlanHeal.Monk.IsSupported = true;
OrlanHeal.Monk.GiftOfTheNaaruSpellId = 121093;

function OrlanHeal.Monk.IsTalentConditionSatisfied(orlanHeal, window)
	if window.Cooldown.TalentRow and window.Cooldown.TalentColumn then
		local _, _, _, hasTalent = GetTalentInfo(window.Cooldown.TalentRow, window.Cooldown.TalentColumn, GetActiveSpecGroup());
		return window.Cooldown.TalentCondition == hasTalent;
	else
		return true;
	end;
end;

function OrlanHeal.Monk.UpdateTouchOfDeathCooldown(orlanHeal, window)
	if orlanHeal:HasGlyph(123391) then
		orlanHeal:UpdateAbilityCooldown(window);
	else
		orlanHeal.Monk.UpdateChiAbilityCooldown(orlanHeal, window);
	end
end;

function OrlanHeal.Monk.UpdateChiAbilityCooldown(orlanHeal, window, chiCost)
	local power = UnitPower("player", SPELL_POWER_CHI);
	local cost = chiCost or window.Cooldown.ChiCost;
	local isTalentConditionSatisfied = orlanHeal.Monk.IsTalentConditionSatisfied(orlanHeal, window);
	if not isTalentConditionSatisfied then
		orlanHeal:UpdateCooldown(window, nil, nil, nil, nil, nil, true);
	elseif (not cost) or (cost == 0) then
		orlanHeal:UpdateAbilityCooldown(window);
	else
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
		if power >= cost then
			orlanHeal:UpdateCooldown(window, duration, expirationTime);
		else
			orlanHeal:UpdateCooldown(window, duration, expirationTime, power .. "/" .. cost, true);
		end;
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
	},
	115921, -- Legacy of the Emperor
	{
		type = "macro",
		caption = GetSpellInfo(175693), -- Chi Shaping
		macrotext = OrlanHeal:BuildMouseOverCastMacro(175693),
		key = 175693
	},
	{
		type = "macro",
		caption = GetSpellInfo(175697), -- Disabling Technique
		macrotext = OrlanHeal:BuildMouseOverCastMacro(175697),
		key = 175697
	},
	{
		type = "macro",
		caption = GetSpellInfo(157675), -- Chi Explosion
		macrotext = OrlanHeal:BuildMouseOverCastMacro(157675),
		key = 157675
	},
	115072 -- Expel Harm
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
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ChiBrew =
	{
		SpellId = 115399,
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
		Update = OrlanHeal.UpdateAbilityCooldown
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
		ChiCost = 3,
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
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	TigerPalm =
	{
		SpellId = 100787,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown,
		ChiCost = 1
	},
	TouchOfDeath =
	{
		SpellId = 115080,
		ChiCost = 3,
		Update = OrlanHeal.Monk.UpdateTouchOfDeathCooldown
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
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Jab =
	{
		SpellId = 100780,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LegacyOfTheEmperor =
	{
		SpellId = 115921,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	NimbleBrew =
	{
		SpellId = 137562,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	CracklingJadeLightning =
	{
		SpellId = 117952,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SpinningCraneKick =
	{
		SpellId = 101546,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Transcendence =
	{
		SpellId = 101643,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = GetSpellInfo(101643) -- Transcendence
	},
	TranscendenceTransfer =
	{
		SpellId = 119996,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = GetSpellInfo(101643) -- Transcendence
	},
	RisingSunKick =
	{
		SpellId = 107428,
		ChiCost = 2,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ChiShaping =
	{
		MacroText = "/cast " .. GetSpellInfo(175693),
		SpellId = 175693, -- Chi Shaping
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DisablingTechnique =
	{
		MacroText = "/cast " .. GetSpellInfo(175697),
		SpellId = 175697, -- Disabling Technique
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BlackoutKick =
	{
		SpellId = 100784,
		ChiCost = 2,
		TalentRow = 7,
		TalentColumn = 2,
		TalentCondition = false,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ChiExplosion =
	{
		MacroText = "/cast " .. GetSpellInfo(157675),
		SpellId = 157675, -- Chi Explosion
		ChiCost = 1,
		TalentRow = 7,
		TalentColumn = 2,
		TalentCondition = true,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	BreathOfTheSerpent =
	{
		SpellId = 157535,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Monk.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 115175; -- Soothing Mist
	config["2"] = 116694; -- Surging Mist
	config["3"] = 116849; -- Life Cocoon
	config["shift2"] = 175693; -- Chi Shaping
	config["shift3"] = 157675; -- Chi Explosion
	config["control1"] = 124682; -- Enveloping Mist
	config["control2"] = "116680,116694"; -- Thunder Focus Tea + Surging Mist
	config["control3"] = 116841; -- Tiger's Lust
	config["alt1"] = 115450; -- Detox
	config["alt2"] = 115151; -- Renewing Mist
	config["alt3"] = 175697; -- Disabling Technique
	config["altshift3"] = 115178; -- Resuscitate
	config["controlalt1"] = 115072; -- Expel Harm

	config["cooldown1"] = "Detox";
	config["cooldown2"] = "SpearHandStrike";
	config["cooldown3"] = "SummonJadeSerpentStatue";
	config["cooldown4"] = "RenewingMist";
	config["cooldown5"] = "ExpelHarm";
	config["cooldown6"] = "DetonateChi";
	config["cooldown7"] = "Revival";
	config["cooldown8"] = "ChiExplosion";
	config["cooldown9"] = "BreathOfTheSerpent";
	config["cooldown10"] = "ManaTea";
	config["cooldown11"] = "LifeCocoon";
	config["cooldown12"] = "FortifyingBrew";
	config["cooldown13"] = "DampenHarm";
	config["cooldown14"] = "DiffuseMagic";
	config["cooldown15"] = "Uplift";
	config["cooldown16"] = "SpinningCraneKick";
	config["cooldown17"] = "ThunderFocusTea";
	config["cooldown18"] = "ChiBrew";
	config["cooldown19"] = "EnvelopingMist";
	config["cooldown20"] = "Roll";
	config["cooldown21"] = "TigersLust";
	config["cooldown22"] = "ChiShaping";
	config["cooldown23"] = "TouchOfDeath";
	config["cooldown24"] = "Paralysis";
	config["cooldown25"] = "DisablingTechnique";
	config["cooldown26"] = "SurgingMist";
	config["cooldown27"] = "NimbleBrew";
	config["cooldown28"] = "Transcendence";
	config["cooldown29"] = "TranscendenceTransfer";
	config["cooldown30"] = "InvokeXuenTheWhiteTiger";
	config["cooldown31"] = orlanHeal:GetRacialCooldown();
	config["cooldown32"] = "Trinket0";
	config["cooldown33"] = "Trinket1";

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
