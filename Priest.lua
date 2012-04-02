OrlanHeal.Priest = {};

function OrlanHeal.Priest.UpdateChakraAbilityCooldown(orlanHeal, window)
	local chakraName = GetSpellInfo(window.Cooldown.ChakraId);
	if UnitBuff("player", chakraName) then
		orlanHeal:UpdateAbilityCooldown(window);
	else
		window:SetReverse(true);
		window.Count:SetText("");

		if not window.Dark then
			window.Dark = true;
			window.Off = 0;
			window:SetCooldown(0, 10);
		end;		
	end;
end;

function OrlanHeal.Priest.UpdateArchangelCooldown(orlanHeal, window)
	local buff1Name = GetSpellInfo(81660); -- Приверженность (1 очко таланта)
	local buff2Name = GetSpellInfo(81661); -- Приверженность (2 очка таланта)

	local _, _, _, count1 = UnitBuff("player", buff1Name);
	local _, _, _, count2 = UnitBuff("player", buff2Name);
	local count;
	if count1 then
		count = count1;
	else
		count = count2;
	end;

	if count then
		local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
		local expirationTime;
		if start and duration and (duration ~= 0) and (enabled == 1) then
			expirationTime = start + duration;
		else
			start = nil;
			duration = nil;
			expirationTime = nil;
		end;
		orlanHeal:UpdateCooldown(window, duration, expirationTime, count, true);
	else
		window:SetReverse(true);
		window.Count:SetText("");

		if not window.Dark then
			window.Dark = true;
			window.Off = 0;
			window:SetCooldown(0, 10);
		end;		
	end;
end;

OrlanHeal.Priest.AvailableSpells =
{
	1706, -- Левитация
	527, -- Рассеивание заклинаний
	17, -- Слово силы: Щит
	6346, -- Защита от страха
	2061, -- Быстрое исцеление
	2060, -- Великое исцеление
	2006, -- Воскрешение
	528, -- Излечение болезни
	2050, -- Исцеление
	139, -- Обновление
	32546, -- Связующее исцеление
	33076, -- Молитва восстановления
	73325, -- Духовное рвение
	2096, -- Внутреннее зрение
	47540, -- Исповедь
	47788, -- Оберегающий дух
	10060, -- Придание сил
	33206, -- Подавление боли
	59544, -- Дар Наару
	{
		type = "macro",
		caption = GetSpellInfo(88684), -- Слово Света: Безмятежность
		macrotext = "/cast [target=mouseover] " .. GetSpellInfo(88684),
		key = 88684
	},
	34861, -- Круг исцеления
	33076, -- Молитва восстановления
	47788, -- Оберегающий дух
	{
		type = "macro",
		caption = "Free " .. GetSpellInfo(2061), -- Быстрое исцеление
		group = GetSpellInfo(89485), -- Внутреннее сосредоточение
		macrotext = OrlanHeal:BuildCastSequenceMacro(89485, 2061),
		key = "89485,2061"
	},
	{
		type = "macro",
		caption = "Free " .. GetSpellInfo(32546), -- Связующее исцеление
		group = GetSpellInfo(89485), -- Внутреннее сосредоточение
		macrotext = OrlanHeal:BuildCastSequenceMacro(89485, 32546),
		key = "89485,32546"
	},
	{
		type = "macro",
		caption = "Free " .. GetSpellInfo(2060), -- Великое исцеление
		group = GetSpellInfo(89485), -- Внутреннее сосредоточение
		macrotext = OrlanHeal:BuildCastSequenceMacro(89485, 2060),
		key = "89485,2060"
	},
	47540, -- Исповедь
	10060 -- Придание сил
}

OrlanHeal.Priest.CooldownOptions =
{
	InnerFocus =
	{
		SpellId = 89485,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PowerWordShield =
	{
		SpellId = 17,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PainSuppression =
	{
		SpellId = 33206,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	GiftOfTheNaaru =
	{
		SpellId = 59544, -- Gift of the Naaru
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Draenei";
		end
	},
	FearWard =
	{
		SpellId = 6346,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lightwell =
	{
		SpellId = 724,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PrayerOfHealing =
	{
		SpellId = 596,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Chakra =
	{
		SpellId = 14751,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyWordSanctuary =
	{
		MacroText = "/cast " .. GetSpellInfo(88685),
		SpellId = 88685,
		ChakraId = 81206,
		Update = OrlanHeal.Priest.UpdateChakraAbilityCooldown
	},
	HolyWordSerenity =
	{
		MacroText = "/cast " .. GetSpellInfo(88684),
		SpellId = 88684,
		ChakraId = 81585,
		Update = OrlanHeal.Priest.UpdateChakraAbilityCooldown
	},
	CircleOfHealing =
	{
		SpellId = 34861,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyNova =
	{
		SpellId = 15237,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HymnOfHope =
	{
		SpellId = 64901,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DesperatePrayer =
	{
		SpellId = 19236,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Shadowfiend =
	{
		SpellId = 34433,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PrayerOfMending =
	{
		SpellId = 33076,
		AuraId = 41635,
		Update = OrlanHeal.UpdateRaidBuffAbilityCooldown
	},
	GuardianSpirit =
	{
		SpellId = 47788,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Archangel =
	{
		SpellId = 87151,
		Update = OrlanHeal.Priest.UpdateArchangelCooldown
	},
	Penance =
	{
		SpellId = 47540,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PowerInfusion =
	{
		SpellId = 10060,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Priest.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["cooldown1"] = "InnerFocus";
	config["cooldown2"] = "PowerWordShield";
	config["cooldown3"] = "PainSuppression";

	return config;
end;

function OrlanHeal.Priest.LoadConfig(orlanHeal)
end;

function OrlanHeal.Priest.GetConfigPresets(orlanHeal)
	return
		{
			["Priest Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

OrlanHeal.Priest.RedRangeSpellId = 2096; -- Внутреннее зрение
OrlanHeal.Priest.OrangeRangeSpellId = 1706; -- Левитация
OrlanHeal.Priest.YellowRangeSpellId = 2061; -- Быстрое исцеление


function OrlanHeal.Priest.UpdateRaidBorder(orlanHeal)
	orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
end;

OrlanHeal.Priest.PlayerSpecificBuffCount = 3;

function OrlanHeal.Priest.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 17) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- свой щит
		buffKind = 1;
	elseif (spellId == 139) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- своё восстановление
		buffKind = 2;
	elseif (spellId == 6346) or  -- Защита от страха
			((spellId == 33076) and (caster ~= nil) and (UnitIsUnit(caster, "player"))) then -- своя Молитва восстановления
		buffKind = 3;
	end;

	return buffKind;
end;

OrlanHeal.Priest.PoisonDebuffKind = 4;
OrlanHeal.Priest.DiseaseDebuffKind = 2;
OrlanHeal.Priest.MagicDebuffKind = 3;
OrlanHeal.Priest.CurseDebuffKind = 4;
OrlanHeal.Priest.PlayerDebuffSlots = { 1, 2, 3, 4, 0 };
OrlanHeal.Priest.PetDebuffSlots = { 0, 0 };

function OrlanHeal.Priest.GetSpecificDebuffKind(orlanHeal, spellId)
	local debuffKind;
	if spellId == 6788 then -- Ослабленная душа
		debuffKind = 1;
	end;

	return debuffKind;
end;
