OrlanHeal.Druid = {};

OrlanHeal.Druid.IsSupported = true;

OrlanHeal.Druid.AvailableSpells =
{
	774, -- Омоложение
	8936, -- Восстановление
	18562, -- Быстрое восстановление
	33763, -- Жизнецвет
	5185, -- Целительное прикосновение
	20484, -- Возрождение
	48438, -- Буйный рост
	102342, -- Ironbark
	1126, -- Mark of the Wild
	50769, -- Revive
	88423, -- Nature's Cure
	102401, -- Wild Charge
	145205, -- Wild Mushroom
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(8936), -- Восстановление
		group = GetSpellInfo(132158), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(132158, 8936),
		key = "17116,8936"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(5185), -- Целительное прикосновение
		group = GetSpellInfo(132158), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(132158, 5185),
		key = "17116,5185"
	},
	102351, -- Cenarion Ward
	102693, -- Force of Nature
	145518 -- Genesis
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
	StampedingRoar =
	{
		SpellId = 106898,
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
	NaturesSwiftness =
	{
		SpellId = 132158,
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
	UrsolsPower =
	{
		MacroText = "/cast " .. GetSpellInfo(175683),
		SpellId = 175683, -- Ursol's Power
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HeartOfTheWild =
	{
		SpellId = 108294,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	NaturesVigil =
	{
		SpellId = 124974,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EntanglingRoots =
	{
		SpellId = 339,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	InstantEntanglingRoots =
	{
		MacroText = "/cast " .. GetSpellInfo(132158) .. "\n/cast " .. GetSpellInfo(339),
		Caption = "Instant " .. GetSpellInfo(339),
		SpellId = 339, -- Entangling Roots
		PrefixSpellId = 132158, -- Nature's Swiftness
		Update = OrlanHeal.UpdateAbilitySequenceCooldown,
		Sign = "Inst."
	},
	Genesis =
	{
		SpellId = 145518, -- Genesis
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Incarnation =
	{
		SpellId = 33891, -- Incarnation: Tree of Life
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ForceOfNature =
	{
		SpellId = 102693, -- Force of Nature
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	WildMushroom =
	{
		MacroText = "/cast " .. GetSpellInfo(145205),
		SpellId = 145205, -- Wild Mushroom
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Druid.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 5185; -- Целительное прикосновение
	config["2"] = 8936; -- Восстановление
	config["3"] = 48438; -- Буйный рост
	config["shift2"] = 33763; -- Жизнецвет
	config["shift3"] = 102342; -- Ironbark
	config["control1"] = 145205; -- Wild Mushroom
	config["control2"] = 18562; -- Быстрое восстановление
	config["control3"] = 20484; -- Возрождение
	config["alt1"] = 88423; -- Nature's Cure
	config["alt2"] = 774; -- Омоложение
	config["alt3"] = 102351; -- Cenarion Ward
	config["controlalt1"] = "17116,5185"; -- Instant Целительное прикосновение
	config["controlalt2"] = "17116,8936"; -- Instant Восстановление
	config["controlalt3"] = 145518; -- Genesis
	config["altshift1"] = 102693; -- Force of Nature
	config["altshift2"] = 102401; -- Wild Charge
	config["altshift3"] = 50769; -- Revive

	config["cooldown1"] = "Lifebloom";
	config["cooldown2"] = "Swiftmend";
	config["cooldown3"] = "WildGrowth";
	config["cooldown4"] = "Genesis";
	config["cooldown5"] = "NaturesCure";
	config["cooldown6"] = "Barkskin";
	config["cooldown7"] = "Ironbark";
	config["cooldown8"] = "WildCharge";
	config["cooldown9"] = "UrsolsPower";
	config["cooldown10"] = "Tranquility";
	config["cooldown11"] = "Incarnation";
	config["cooldown12"] = "Dash";
	config["cooldown13"] = "Growl";
	config["cooldown14"] = "NaturesSwiftness";
	config["cooldown15"] = "Rebirth";
	config["cooldown16"] = "HeartOfTheWild";
	config["cooldown17"] = "Prowl";
	config["cooldown18"] = "StampedingRoar";
	config["cooldown19"] = "NaturesControl";
	config["cooldown20"] = "ForceOfNature";
	config["cooldown21"] = "Renewal";
	config["cooldown22"] = "EntanglingRoots";
	config["cooldown23"] = "InstantEntanglingRoots";
	config["cooldown24"] = "DisplacerBeast";
	config["cooldown25"] = "WildMushroom";
	config["cooldown26"] = "NaturesVigil";
	config["cooldown27"] = "CenarionWard";
	config["cooldown28"] = orlanHeal:GetRacialCooldown();

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
			and (lifebloomExpirationTime - GetTime() < 4) 
			and not orlanHeal:HasGlyph(121840) then -- Glyph of Blooming
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
	if (spellId == 774) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- своё Омоложение
		buffKind = 1;
	elseif (spellId == 155777) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Rejuvenation (Germination)
		buffKind = 2;
	elseif spellId == 8936 then -- Восстановление
		buffKind = 3;
	elseif spellId == 33763 and (caster ~= nil) and UnitIsUnit(caster, "player") then -- свой Жизнецвет
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
