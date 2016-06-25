OrlanHeal.Druid = {};

OrlanHeal.Druid.IsSupported = true;

OrlanHeal.Druid.AvailableSpells =
{
	774, -- Rejuvenation
	8936, -- Regrowth
	18562, -- Swiftmend
	33763, -- Lifebloom
	5185, -- Healing Touch
	20484, -- Rebirth
	48438, -- Wild Growth
	102342, -- Ironbark
	50769, -- Revive
	88423, -- Nature's Cure
	102401, -- Wild Charge
	102351, -- Cenarion Ward
	29166 -- Innervate
}

OrlanHeal.Druid.CooldownOptions =
{
	Rebirth =
	{
		SpellId = 20484,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifebloom =
	{
		SpellId = 33763,
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	},
	Swiftmend =
	{
		SpellId = 18562,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	WildGrowth =
	{
		SpellId = 48438,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Barkskin =
	{
		SpellId = 22812,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Tranquility =
	{
		SpellId = 740,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Dash =
	{
		SpellId = 1850,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Growl =
	{
		SpellId = 6795,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Prowl =
	{
		SpellId = 5215,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Ironbark =
	{
		SpellId = 102342,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	NaturesCure =
	{
		SpellId = 88423,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DisplacerBeast =
	{
		SpellId = 102280,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	WildCharge =
	{
		SpellId = 102401,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Renewal =
	{
		SpellId = 108238,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	CenarionWard =
	{
		SpellId = 102351,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	NaturesControl =
	{
		MacroText = "/cast " .. GetSpellInfo(175682),
		SpellId = 175682, -- Nature's Control
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EntanglingRoots =
	{
		SpellId = 339,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Incarnation =
	{
		SpellId = 33891, -- Incarnation: Tree of Life
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Efflorescence =
	{
		SpellId = 145205, -- Efflorescence
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	FrenziedRegeneration =
	{
		SpellId = 22842, -- Frenzied Regeneration
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Innervate =
	{
		SpellId = 29166, -- Innervate
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Mangle =
	{
		SpellId = 33917, -- Mangle
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	UrsolsVortex =
	{
		SpellId = 102793, -- Ursol's Vortex
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Starsurge =
	{
		SpellId = 197626, -- Starsurge
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Flourish =
	{
		SpellId = 197721, -- Flourish
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Druid.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 5185; -- Healing Touch
	config["2"] = 8936; -- Regrowth
	config["3"] = 48438; -- Wild Growth
	config["shift2"] = 33763; -- Lifebloom
	config["shift3"] = 102342; -- Ironbark
	config["control1"] = 29166; -- Innervate
	config["control2"] = 18562; -- Swiftmend
	config["control3"] = 20484; -- Rebirth
	config["alt1"] = 88423; -- Nature's Cure
	config["alt2"] = 774; -- Rejuvenation
	config["alt3"] = 102351; -- Cenarion Ward
	config["altshift2"] = 102401; -- Wild Charge
	config["altshift3"] = 50769; -- Revive

	config["cooldown1"] = "Lifebloom";
	config["cooldown2"] = "Swiftmend";
	config["cooldown3"] = "WildGrowth";
	config["cooldown4"] = "Flourish";
	config["cooldown5"] = "NaturesCure";
	config["cooldown6"] = "Barkskin";
	config["cooldown7"] = "Ironbark";
	config["cooldown8"] = "WildCharge";
	config["cooldown9"] = "Innervate";
	config["cooldown10"] = "Tranquility";
	config["cooldown11"] = "Incarnation";
	config["cooldown12"] = "Dash";
	config["cooldown13"] = "Growl";
	config["cooldown14"] = "FrenziedRegeneration";
	config["cooldown15"] = "Rebirth";
	config["cooldown16"] = "Prowl";
	config["cooldown17"] = "UrsolsVortex";
	config["cooldown18"] = "NaturesControl";
	config["cooldown19"] = "Mangle";
	config["cooldown20"] = "Starsurge";
	config["cooldown21"] = "Renewal";
	config["cooldown22"] = "EntanglingRoots";
	config["cooldown23"] = "CenarionWard";
	config["cooldown24"] = "DisplacerBeast";
	config["cooldown25"] = "Efflorescence";
	config["cooldown26"] = orlanHeal:GetRacialCooldown();
	config["cooldown27"] = "Trinket0";
	config["cooldown28"] = "Trinket1";

	return config;
end;

function OrlanHeal.Druid.LoadConfig(orlanHeal)
end;

function OrlanHeal.Druid.GetConfigPresets(orlanHeal)
	return
		{
			["Druid Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Druid.UpdateRaidBorder(orlanHeal)
	local _, swiftmendCooldown = GetSpellCooldown(18562);
	local _, lifebloomExpirationTime = orlanHeal:GetRaidBuffCooldown(33763);
	local _, wildGrowthCooldown = GetSpellCooldown(48438);
	local isSwiftmendReady = IsSpellKnown(18562) and (swiftmendCooldown < 1.5);
	local isWildGrowthReady = IsSpellKnown(48438) and (wildGrowthCooldown < 1.5);
	local clearcastingSpellName = GetSpellInfo(16870);
	if lifebloomExpirationTime 
			and (lifebloomExpirationTime - GetTime() < 4) then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", clearcastingSpellName) then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif isSwiftmendReady and isWildGrowthReady then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif isWildGrowthReady then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
	elseif isSwiftmendReady then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Druid.PlayerSpecificBuffCount = 4;

function OrlanHeal.Druid.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 774) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Rejuvenation
		buffKind = 1;
	elseif (spellId == 155777) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Rejuvenation (Germination)
		buffKind = 2;
	elseif spellId == 8936 then -- Regrowth
		buffKind = 3;
	elseif spellId == 33763 and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Lifebloom
		buffKind = 4;
	end;
	return buffKind;
end;

OrlanHeal.Druid.PoisonDebuffKind = 1;
OrlanHeal.Druid.DiseaseDebuffKind = 2;
OrlanHeal.Druid.MagicDebuffKind = 1;
OrlanHeal.Druid.CurseDebuffKind = 1;
OrlanHeal.Druid.PlayerDebuffSlots = { 1, 0, 0, 0, 0 };
OrlanHeal.Druid.PetDebuffSlots = { 1, 0 };

function OrlanHeal.Druid.GetSpecificDebuffKind(orlanHeal, spellId)
end;
