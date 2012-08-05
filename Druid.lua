OrlanHeal.Druid = {};

OrlanHeal.Druid.IsSupported = true;

OrlanHeal.Druid.AvailableSpells =
{
	774, -- Омоложение
	8936, -- Восстановление
	50464, -- Покровительство природы
	18562, -- Быстрое восстановление
	33763, -- Жизнецвет
	5185, -- Целительное прикосновение
	20484, -- Возрождение
	29166, -- Озарение
	467, -- Шипы
	48438, -- Буйный рост
	102342, -- Ironbark
	1126, -- Mark of the Wild
	50769 -- Revive
}

OrlanHeal.Druid.CooldownOptions =
{
	Rebirth =
	{
		SpellId = 20484,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Innervate =
	{
		SpellId = 29166,
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
	NaturesGrasp =
	{
		SpellId = 16689,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Prowl =
	{
		SpellId = 5215,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

if GetBuildInfo() == "5.0.4" then
	table.insert(OrlanHeal.Druid.AvailableSpells, 88423); -- Nature's Cure
	table.insert(OrlanHeal.Druid.AvailableSpells, 110309); -- Symbiosis
	table.insert(OrlanHeal.Druid.AvailableSpells, 102401); -- Wild Charge
	table.insert(
		OrlanHeal.Druid.AvailableSpells, 
		{
			type = "macro",
			caption = "Instant " .. GetSpellInfo(8936), -- Восстановление
			group = GetSpellInfo(132158), -- Природная стремительность
			macrotext = OrlanHeal:BuildCastSequenceMacro(132158, 8936),
			key = "17116,8936"
		});
	table.insert(
		OrlanHeal.Druid.AvailableSpells, 
		{
			type = "macro",
			caption = "Instant " .. GetSpellInfo(50464), -- Покровительство природы
			group = GetSpellInfo(132158), -- Природная стремительность
			macrotext = OrlanHeal:BuildCastSequenceMacro(132158, 50464),
			key = "17116,50464"
		});
	table.insert(
		OrlanHeal.Druid.AvailableSpells, 
		{
			type = "macro",
			caption = "Instant " .. GetSpellInfo(20484), -- Возрождение
			group = GetSpellInfo(132158), -- Природная стремительность
			macrotext = OrlanHeal:BuildCastSequenceMacro(132158, 20484),
			key = "17116,20484"
		});
	table.insert(
		OrlanHeal.Druid.AvailableSpells, 
		{
			type = "macro",
			caption = "Instant " .. GetSpellInfo(5185), -- Целительное прикосновение
			group = GetSpellInfo(132158), -- Природная стремительность
			macrotext = OrlanHeal:BuildCastSequenceMacro(132158, 5185),
			key = "17116,5185"
		});
	table.insert(OrlanHeal.Druid.AvailableSpells, 102351); -- Cenarion Ward
	OrlanHeal.Druid.CooldownOptions.Ironbark =
	{
		SpellId = 102342,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.MightOfUrsoc =
	{
		SpellId = 106922,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.NaturesCure =
	{
		SpellId = 88423,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.StampedingRoar =
	{
		SpellId = 106898,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.WildMushroom =
	{
		SpellId = 88747,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.WildMushroomBloom =
	{
		SpellId = 102791,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.Symbiosis =
	{
		SpellId = 110309,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.DisplacerBeast =
	{
		SpellId = 102280,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.WildCharge =
	{
		SpellId = 102401,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.NaturesSwiftness =
	{
		SpellId = 132158,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.Renewal =
	{
		SpellId = 108238,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.CenarionWard =
	{
		SpellId = 102351,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.MassEntanglement =
	{
		SpellId = 102359,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.Typhoon =
	{
		SpellId = 50516,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.Incarnation =
	{
		SpellId = 106731,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.ForceOfNature =
	{
		SpellId = 106737,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.DisorientingRoar =
	{
		SpellId = 99,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.UrsolsVortex =
	{
		SpellId = 102793,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.MightyBash =
	{
		SpellId = 5211,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
else
	table.insert(
		OrlanHeal.Druid.AvailableSpells, 
		{
			type = "macro",
			caption = "Instant " .. GetSpellInfo(8936), -- Восстановление
			group = GetSpellInfo(17116), -- Природная стремительность
			macrotext = OrlanHeal:BuildCastSequenceMacro(17116, 8936),
			key = "17116,8936"
		});
	table.insert(
		OrlanHeal.Druid.AvailableSpells, 
		{
			type = "macro",
			caption = "Instant " .. GetSpellInfo(50464), -- Покровительство природы
			group = GetSpellInfo(17116), -- Природная стремительность
			macrotext = OrlanHeal:BuildCastSequenceMacro(17116, 50464),
			key = "17116,50464"
		});
	table.insert(
		OrlanHeal.Druid.AvailableSpells, 
		{
			type = "macro",
			caption = "Instant " .. GetSpellInfo(20484), -- Возрождение
			group = GetSpellInfo(17116), -- Природная стремительность
			macrotext = OrlanHeal:BuildCastSequenceMacro(17116, 20484),
			key = "17116,20484"
		});
	table.insert(
		OrlanHeal.Druid.AvailableSpells, 
		{
			type = "macro",
			caption = "Instant " .. GetSpellInfo(5185), -- Целительное прикосновение
			group = GetSpellInfo(17116), -- Природная стремительность
			macrotext = OrlanHeal:BuildCastSequenceMacro(17116, 5185),
			key = "17116,5185"
		});
	table.insert(OrlanHeal.Druid.AvailableSpells, 2782); -- Снятие порчи
	OrlanHeal.Druid.CooldownOptions.Thorns =
	{
		SpellId = 467,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.NaturesSwiftness =
	{
		SpellId = 17116,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Druid.CooldownOptions.TreeOfLife =
	{
		SpellId = 33891,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
end;

function OrlanHeal.Druid.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 50464; -- Покровительство природы
	config["2"] = 8936; -- Восстановление
	config["3"] = 48438; -- Буйный рост
	config["shift2"] = 33763; -- Жизнецвет
	config["shift3"] = 467; -- Шипы
	config["control1"] = 5185; -- Целительное прикосновение
	config["control2"] = 18562; -- Быстрое восстановление
	config["control3"] = 20484; -- Возрождение
	config["alt1"] = 2782; -- Снятие порчи
	config["alt2"] = 774; -- Омоложение
	config["alt3"] = 29166; -- Озарение
	config["controlalt1"] = "17116,5185"; -- Instant Целительное прикосновение
	config["controlalt2"] = "17116,8936"; -- Instant Восстановление
	config["controlalt3"] = "17116,20484"; -- Instant Возрождение

	config["cooldown1"] = "Lifebloom";
	config["cooldown2"] = "Swiftmend";
	config["cooldown3"] = "WildGrowth";
	config["cooldown4"] = "Innervate";
	config["cooldown5"] = "NaturesSwiftness";
	config["cooldown6"] = "Barkskin";
	config["cooldown7"] = "Rebirth";
	config["cooldown8"] = "Thorns";
	config["cooldown9"] = "TreeOfLife";
	config["cooldown10"] = "Tranquility";

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

OrlanHeal.Druid.RedRangeSpellId = 774; -- Омоложение
OrlanHeal.Druid.OrangeRangeSpellId = 774; -- Омоложение
OrlanHeal.Druid.YellowRangeSpellId = 1126; -- Mark of the Wild


function OrlanHeal.Druid.UpdateRaidBorder(orlanHeal)
	local _, swiftmendCooldown = GetSpellCooldown(18562);
	local _, lifebloomExpirationTime = orlanHeal:GetRaidBuffCooldown(33763);
	local _, wildGrowthCooldown = GetSpellCooldown(48438);
	local isSwiftmendReady = IsSpellKnown(18562) and (swiftmendCooldown < 1.5);
	local isWildGrowthReady = IsSpellKnown(48438) and (wildGrowthCooldown < 1.5);
	if lifebloomExpirationTime and (lifebloomExpirationTime - GetTime() < 3) then
		if isSwiftmendReady then
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0.5, 0, orlanHeal.RaidBorderAlpha);
		else
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha);
		end;
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

OrlanHeal.Druid.PlayerSpecificBuffCount = 3;

function OrlanHeal.Druid.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if spellId == 774 then -- Омоложение
		if (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- своё
			buffKind = 1;
		else
			buffKind = 4;
		end;
	elseif spellId == 8936 then -- Восстановление
		buffKind = 2;
	elseif spellId == 33763 and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- свой Жизнецвет
		buffKind = 3;
	elseif spellId == 467 then -- Шипы
		buffKind = 4;
	end;
	return buffKind;
end;

OrlanHeal.Druid.PoisonDebuffKind = 2;
OrlanHeal.Druid.DiseaseDebuffKind = 4;
OrlanHeal.Druid.MagicDebuffKind = 3;
OrlanHeal.Druid.CurseDebuffKind = 1;
OrlanHeal.Druid.PlayerDebuffSlots = { 1, 2, 3, 0, 0 };
OrlanHeal.Druid.PetDebuffSlots = { 0, 0 };

function OrlanHeal.Druid.GetSpecificDebuffKind(orlanHeal, spellId)
end;
