OrlanHeal.Monk = {};

OrlanHeal.Monk.IsSupported = true;
OrlanHeal.Monk.GiftOfTheNaaruSpellId = 121093;

OrlanHeal.Monk.AvailableSpells =
{
	121093, -- Gift of the Naaru
	115450, -- Detox
	124682, -- Enveloping Mist
	116849, -- Life Cocoon
	115151, -- Renewing Mist
	115178, -- Resuscitate
	116841, -- Tiger's Lust
	{
		type = "macro",
		caption = "No CD " .. GetSpellInfo(115151), -- Renewing Mist
		macrotext = OrlanHeal:BuildCastSequenceMacro(116680, 115151),
		key = "116680,115151",
		group = GetSpellInfo(116680) -- Thunder Focus Tea
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(124682), -- Enveloping Mist
		macrotext = OrlanHeal:BuildCastSequenceMacro(116680, 124682),
		key = "116680,124682",
		group = GetSpellInfo(116680) -- Thunder Focus Tea
	},
	{
		type = "macro",
		caption = "Free " .. GetSpellInfo(116670), -- Vivify
		macrotext = OrlanHeal:BuildCastSequenceMacro(116680, 116670),
		key = "116680,116670",
		group = GetSpellInfo(116680) -- Thunder Focus Tea
	},
	{
		type = "macro",
		caption = GetSpellInfo(175697), -- Disabling Technique
		macrotext = OrlanHeal:BuildMouseOverCastMacro(175697),
		key = 175697
	},
	116670, -- Vivify
	124081, -- Zen Pulse
	197945 -- Mistwalk
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
	LifeCocoon =
	{
		SpellId = 116849,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ManaTea =
	{
		SpellId = 197908,
		Update = OrlanHeal.UpdateAbilityCooldown
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
	SummonJadeSerpentStatue =
	{
		SpellId = 115313,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ThunderFocusTea =
	{
		SpellId = 116680,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ZenPilgrimage =
	{
		MacroText = "/cast " .. GetSpellInfo(126892),
		SpellId = 126892,
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
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EssenceFont =
	{
		SpellId = 191837,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ChiBurst =
	{
		SpellId = 123986, -- Chi Burst
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ZenPulse =
	{
		SpellId = 124081, -- Zen Pulse
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Mistwalk =
	{
		SpellId = 197945, -- Mistwalk
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HealingElixir =
	{
		SpellId = 122281, -- Healing Elixir
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	RefreshingJadeWind =
	{
		SpellId = 196725, -- Refreshing Jade Wind
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	InvokeChiJiTheRedCrane =
	{
		SpellId = 198664, -- Invoke Chi-Ji, the Red Crane
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Monk.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["2"] = 116670; -- Vivify
	config["3"] = 116849; -- Life Cocoon
	config["shift2"] = 124682; -- Enveloping Mist
	config["shift3"] = 124081; -- Zen Pulse
	config["control2"] = "116680,116670"; -- Thunder Focus Tea + Vivify
	config["control3"] = 116841; -- Tiger's Lust
	config["alt1"] = 115450; -- Detox
	config["alt2"] = 115151; -- Renewing Mist
	config["alt3"] = 175697; -- Disabling Technique
	config["altshift3"] = 115178; -- Resuscitate
	config["controlalt1"] = 197945; -- Mistwalk
	config["controlalt2"] = "116680,115151"; -- Thunder Focus Tea + Renewing Mist
	config["controlshift2"] = "116680,124682"; -- Thunder Focus Tea + Enveloping Mist

	config["cooldown1"] = "Detox";
	config["cooldown2"] = "RefreshingJadeWind";
	config["cooldown3"] = "SummonJadeSerpentStatue";
	config["cooldown4"] = "RenewingMist";
	config["cooldown5"] = "Mistwalk";
	config["cooldown6"] = "ZenPulse";
	config["cooldown7"] = "Revival";
	config["cooldown8"] = "ChiBurst";
	config["cooldown9"] = "InvokeChiJiTheRedCrane";
	config["cooldown10"] = "ManaTea";
	config["cooldown11"] = "LifeCocoon";
	config["cooldown12"] = "HealingElixir";
	config["cooldown13"] = "DampenHarm";
	config["cooldown14"] = "DiffuseMagic";
	config["cooldown15"] = "Paralysis";
	config["cooldown16"] = "ThunderFocusTea";
	config["cooldown17"] = "EssenceFont";
	config["cooldown18"] = "DisablingTechnique";
	config["cooldown19"] = "TigersLust";
	config["cooldown20"] = "Roll";
	config["cooldown21"] = "Transcendence";
	config["cooldown22"] = "TranscendenceTransfer";
	config["cooldown23"] = "Trinket0";
	config["cooldown24"] = "Trinket1";
	config["cooldown25"] = orlanHeal:GetRacialCooldown();

	return config;
end;

OrlanHeal.Monk.PlayerSpecificBuffCount = 1;

OrlanHeal.Monk.PoisonDebuffKind = 1;
OrlanHeal.Monk.DiseaseDebuffKind = 1;
OrlanHeal.Monk.MagicDebuffKind = 1;
OrlanHeal.Monk.CurseDebuffKind = 2;
OrlanHeal.Monk.PlayerDebuffSlots = { 1, 0, 0, 0, 0 };
OrlanHeal.Monk.PetDebuffSlots = { 1, 0 };

function OrlanHeal.Monk.GetSpecificDebuffKind(orlanHeal, spellId, caster)
end;

function OrlanHeal.Monk.UpdateRaidBorder(orlanHeal)
	if orlanHeal:PlayerHasBuff(197919) then -- Lifecycles (Enveloping Mist)
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif orlanHeal:PlayerHasBuff(197916) then -- Lifecycles (Vivify)
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
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
	if (spellId == 119611) and caster and UnitIsUnit("player", caster) then -- Renewing Mist
		result = 1;
	end;
	return result;
end;
