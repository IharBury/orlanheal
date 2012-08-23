OrlanHeal.Monk = {};

OrlanHeal.Monk.GiftOfTheNaaruSpellId = 121093;

function OrlanHeal.Monk.GetChiCost(spellId)
	local _, _, _, cost = GetSpellInfo(spellId);
	return cost;
end;

function OrlanHeal.Monk.UpdateChiAbilityCooldown(orlanHeal, window)
	local power = UnitPower("player", SPELL_POWER_LIGHT_FORCE);
	local cost = window.Cooldown.ChiCost or orlanHeal.Monk.GetChiCost(window.Cooldown.SpellId);
	if power >= cost then
		local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
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
		window:SetReverse(true);
		if not window.Dark then
			window:SetCooldown(0, 10);
			window.Dark = true;
		end;
		window.Count:SetText(power);
	end;
end;

function OrlanHeal.Monk.UpdateChiRaidBuffCooldown(orlanHeal, window)
	local power = UnitPower("player", SPELL_POWER_LIGHT_FORCE);
	local duration, expirationTime = orlanHeal:GetRaidBuffCooldown(window.Cooldown.AuraId or window.Cooldown.SpellId);
	orlanHeal:UpdateCooldown(window, duration, expirationTime, power, true);
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
	116694, -- Surging Mist
	{
		type = "macro",
		caption = "Double " .. GetSpellInfo(116694), -- Surging Mist
		macrotext = OrlanHeal:BuildCastSequenceMacro(116680, 116694),
		key = "116680,116694"
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
	GrappleWeapon =
	{
		SpellId = 117368,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HealingSphere =
	{
		SpellId = 115460,
		AuraId = 124458,
		AlwaysShowCount = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown
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
		AlwaysShowCount = true,
		IsReverse = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown
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
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ThunderFocusTea =
	{
		SpellId = 116680,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown,
		Group = GetSpellInfo(116680) -- Thunder Focus Tea
	},
	RefreshingUplift =
	{
		MacroText = OrlanHeal:BuildCastSequenceMacro(116680, 116670), -- Thunder Focus Tea + Uplift
		SpellId = 119607, -- Different visual for Renewing Mist
		ChiCost = OrlanHeal.Monk.GetChiCost(116680) + OrlanHeal.Monk.GetChiCost(116670),
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown,
		Group = GetSpellInfo(116680), -- Thunder Focus Tea
		Caption = "Refreshing " .. GetSpellInfo(116670) -- Uplift
	},
	TigerPalm =
	{
		SpellId = 100787,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	}
};

function OrlanHeal.Monk.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();
	return config;
end;

OrlanHeal.Monk.PlayerSpecificBuffCount = 1;

OrlanHeal.Monk.PoisonDebuffKind = 1;
OrlanHeal.Monk.DiseaseDebuffKind = 1;
OrlanHeal.Monk.MagicDebuffKind = 1;
OrlanHeal.Monk.CurseDebuffKind = 2;
OrlanHeal.Monk.PlayerDebuffSlots = { 1, 0, 0, 0, 0 };
OrlanHeal.Monk.PetDebuffSlots = { 1, 0 };

OrlanHeal.Monk.RedRangeSpellId = 53563; -- Частица Света
OrlanHeal.Monk.OrangeRangeSpellId = 635; -- Holy Light
OrlanHeal.Monk.YellowRangeSpellId = 20217; -- Blessing of Kings

function OrlanHeal.Monk.GetSpecificDebuffKind(orlanHeal, spellId)
end;

function OrlanHeal.Monk.UpdateRaidBorder(orlanHeal)
	orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
end;

function OrlanHeal.Monk.GetConfigPresets(orlanHeal)
	return
		{
			["Monk Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Monk.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local result;
	if (spellId == 119611) and UnitIsUnit("player", caster) then
		result = 1;
	end;
	return result;
end;
