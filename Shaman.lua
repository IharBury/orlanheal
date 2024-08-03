OrlanHeal.Shaman = {};

OrlanHeal.Shaman.IsSupported = false;
OrlanHeal.Shaman.GiftOfTheNaaruSpellId = 59547;

OrlanHeal.Shaman.AvailableSpells =
{
	{
		type = "macro",
		caption = C_Spell.GetSpellInfo(77130).name, -- Purify Spirit
		macrotext = OrlanHeal:BuildMouseOverCastMacro(77130),
		key = 77130
	},
	8004, -- Healing Surge
	546, -- Water Walking
	1064, -- Chain Heal
	77472, -- Healing Wave
	61295, -- Riptide
	73685, -- Unleash Life
	2008, -- Ancestral Spirit
	59547, -- Gift of the Naaru
	974 -- Earth Shield
};

OrlanHeal.Shaman.CooldownOptions =
{
	HealingStreamTotem =
	{
		SpellId = 5394,
		Update = OrlanHeal.UpdateAbilityCooldown
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
	UnleashLife =
	{
		SpellId = 73685,
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
	},
	AstralRecall =
	{
		SpellId = 556,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	FlameShock =
	{
		SpellId = 188838,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Hex =
	{
		SpellId = 51514,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LavaBurst =
	{
		SpellId = 51505,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	WindShear =
	{
		SpellId = 57994,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AstralShift =
	{
		SpellId = 108271,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Ascendance =
	{
		SpellId = 114049,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HealingTideTotem =
	{
		SpellId = 108280,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	CloudburstTotem =
	{
		SpellId = 157153,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AncestralGuidance =
	{
		SpellId = 108281,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	CleanseSpirit =
	{
		SpellId = 77130, -- Purify Spirit
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Purge =
	{
		SpellId = 370,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	GustOfWind =
	{
		SpellId = 192063,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	WindRushTotem =
	{
		SpellId = 192077,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AncestralProtectionTotem =
	{
		SpellId = 207399,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EarthenShieldTotem =
	{
		SpellId = 198838, -- Earthen Wall Totem
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Wellspring =
	{
		SpellId = 197995,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EarthShield =
	{
		SpellId = 974,
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	}
};

function OrlanHeal.Shaman.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 77472; -- Healing Wave
	config["2"] = 8004; -- Healing Surge
	config["3"] = 73685; -- Unleash Life
	config["shift2"] = 974; -- Earth Shield
	config["shift3"] = 546; -- Water Walking
	config["control2"] = 61295; -- Riptide
	config["alt1"] = 77130; -- Purify Spirit
	config["alt2"] = 1064; -- Chain Heal
	config["altshift3"] = 2008; -- Ancestral Spirit

	config["cooldown1"] = orlanHeal:GetRacialCooldown();
	config["cooldown2"] = "Trinket0";
	config["cooldown3"] = "Trinket1";

	return config;
end;

function OrlanHeal.Shaman.LoadConfig(orlanHeal)
end;

function OrlanHeal.Shaman.GetConfigPresets(orlanHeal)
	return
		{
			["Shaman Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Shaman.UpdateRaidBorder(orlanHeal)
	local isRiptideReady = orlanHeal:IsSpellReady(61295);

	if orlanHeal:PlayerHasBuff(79206) then -- Spiritwalker's Grace
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif isRiptideReady then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif orlanHeal:IsSpellReady(79206) then -- Spiritwalker's Grace
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Shaman.PlayerSpecificBuffCount = 2;

function OrlanHeal.Shaman.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if spellId == 61295 then -- Riptide
		buffKind = 1;
	elseif spellId == 974 -- Earth Shield
		or spellId == 192106 then -- Lightning Shield
		buffKind = 2;
	end;
	return buffKind;
end;

OrlanHeal.Shaman.PoisonDebuffKind = 2;
OrlanHeal.Shaman.DiseaseDebuffKind = 2;
OrlanHeal.Shaman.MagicDebuffKind = 1;
OrlanHeal.Shaman.CurseDebuffKind = 1;
OrlanHeal.Shaman.PlayerDebuffSlots = { 1, 0, 0, 0, 0 };
OrlanHeal.Shaman.PetDebuffSlots = { 1, 0 };

function OrlanHeal.Shaman.GetSpecificDebuffKind(orlanHeal, spellId, caster)
	local debuffKind;
	return debuffKind;
end;
