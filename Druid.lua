OrlanHeal.Druid = {};

OrlanHeal.Druid.AvailableSpells =
{
	2782, -- Снятие порчи
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
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(8936), -- Восстановление
		group = GetSpellInfo(17116), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(17116, 8936),
		key = "17116,8936"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(50464), -- Покровительство природы
		group = GetSpellInfo(17116), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(17116, 50464),
		key = "17116,50464"
	},
	{
		type = "macro",
		caption = "Instant " .. GetSpellInfo(20484), -- Возрождение
		group = GetSpellInfo(17116), -- Природная стремительность
		macrotext = OrlanHeal:BuildCastSequenceMacro(17116, 20484),
		key = "17116,20484"
	}
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
	Thorns =
	{
		SpellId = 467,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	WildGrowth =
	{
		SpellId = 48438,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	NaturesSwiftness =
	{
		SpellId = 17116,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Barkskin =
	{
		SpellId = 22812,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	TreeOfLife =
	{
		SpellId = 33891,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Tranquility =
	{
		SpellId = 740,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Druid.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();
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
OrlanHeal.Druid.YellowRangeSpellId = 467; -- Шипы


function OrlanHeal.Druid.UpdateRaidBorder(orlanHeal)
	local _, swiftmendCooldown = GetSpellCooldown(18562);
	local _, lifebloomExpirationTime = orlanHeal:GetRaidBuffCooldown(33763);
	local isSwiftmendReady = IsSpellKnown(18562) and (swiftmendCooldown < 1.5);
	if lifebloomExpirationTime and (lifebloomExpirationTime - GetTime() < 3) then
		if isSwiftmendReady then
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0.5, 0, orlanHeal.RaidBorderAlpha);
		else
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha);
		end;
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
		buffKind = 1;
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
