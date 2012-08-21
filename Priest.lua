OrlanHeal.Priest = {};

OrlanHeal.Priest.IsSupported = true;
OrlanHeal.Priest.GiftOfTheNaaruSpellId = 59544;

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

function OrlanHeal.Priest.UpdateDefaultChakraAbilityCooldown(orlanHeal, window)
	local chakraSanctuaryName = GetSpellInfo(81206);
	local chakraSerenityName = GetSpellInfo(81208);
	if UnitBuff("player", chakraSanctuaryName) or UnitBuff("player", chakraSerenityName) then
		window:SetReverse(true);
		window.Count:SetText("");

		if not window.Dark then
			window.Dark = true;
			window.Off = 0;
			window:SetCooldown(0, 10);
		end;		
	else
		orlanHeal:UpdateAbilityCooldown(window);
	end;
end;

function OrlanHeal.Priest.UpdateArchangelCooldown(orlanHeal, window)
	local buff2Name = GetSpellInfo(81661); -- Приверженность (2 очка таланта)
	local _, _, _, count2 = UnitBuff("player", buff2Name);
	local count = count2;

	if GetBuildInfo() ~= "5.0.4" then
		local buff1Name = GetSpellInfo(81660); -- Приверженность (1 очко таланта)
		local _, _, _, count1 = UnitBuff("player", buff1Name);
		if count1 then
			count = count1;
		end;
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
	47540, -- Исповедь
	10060, -- Придание сил
	73325 -- Духовное рвение
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
	CircleOfHealing =
	{
		SpellId = 34861,
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
	Penance =
	{
		SpellId = 47540,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PowerInfusion =
	{
		SpellId = 10060,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PowerWordBarrier =
	{
		SpellId = 62618,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	MassDispel =
	{
		SpellId = 32375,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineHymn =
	{
		SpellId = 64843,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LeapOfFaith =
	{
		SpellId = 73325,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Fade =
	{
		SpellId = 586,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyFire =
	{
		SpellId = 14914,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PsychicScream =
	{
		SpellId = 8122,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Purify =
	{
		SpellId = 527,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ArcaneTorrent =
	{
		SpellId = 28730, -- Arcane Torrent
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "BloodElf";
		end
	},
	ShadowWordDeath =
	{
		SpellId = 32379,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

if GetBuildInfo() == "5.0.4" then
	table.insert(
		OrlanHeal.Priest.AvailableSpells, 
		{
			type = "macro",
			caption = "Critical " .. GetSpellInfo(2061), -- Быстрое исцеление
			group = GetSpellInfo(89485), -- Внутреннее сосредоточение
			macrotext = OrlanHeal:BuildCastSequenceMacro(89485, 2061),
			key = "89485,2061"
		});
	table.insert(
		OrlanHeal.Priest.AvailableSpells, 
		{
			type = "macro",
			caption = "Critical " .. GetSpellInfo(2060), -- Великое исцеление
			group = GetSpellInfo(89485), -- Внутреннее сосредоточение
			macrotext = OrlanHeal:BuildCastSequenceMacro(89485, 2060),
			key = "89485,2060"
		});
	table.insert(OrlanHeal.Priest.AvailableSpells, 108968); -- Void Shift
	OrlanHeal.Priest.CooldownOptions.VoidTendrils =
	{
		SpellId = 108920,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.Psyfiend =
	{
		SpellId = 108921,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.DominateMind =
	{
		SpellId = 605,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.AngelicFeather =
	{
		SpellId = 121536,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.SpectralGuise =
	{
		SpellId = 112833,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.Cascade =
	{
		SpellId = 121135,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.DivineStar =
	{
		SpellId = 110744,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.Halo =
	{
		SpellId = 120517,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.Archangel =
	{
		SpellId = 81700,
		Update = OrlanHeal.Priest.UpdateArchangelCooldown
	};
	OrlanHeal.Priest.CooldownOptions.SpiritShell =
	{
		SpellId = 109964,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.VoidShift =
	{
		SpellId = 108968,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.ChakraSerenity =
	{
		SpellId = 81208,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Chakra"
	};
	OrlanHeal.Priest.CooldownOptions.ChakraSanctuary =
	{
		SpellId = 81206,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Chakra"
	};
	OrlanHeal.Priest.CooldownOptions.ChakraChastise =
	{
		SpellId = 81209,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Chakra"
	};
	OrlanHeal.Priest.CooldownOptions.HolyWordSanctuary =
	{
		MacroText = "/cast " .. GetSpellInfo(88685),
		SpellId = 88685,
		ChakraId = 81206,
		Update = OrlanHeal.Priest.UpdateChakraAbilityCooldown,
		Group = "Holy Word"
	};
	OrlanHeal.Priest.CooldownOptions.HolyWordSerenity =
	{
		MacroText = "/cast " .. GetSpellInfo(88684),
		SpellId = 88684,
		ChakraId = 81208,
		Update = OrlanHeal.Priest.UpdateChakraAbilityCooldown,
		Group = "Holy Word"
	};
	OrlanHeal.Priest.CooldownOptions.HolyWordChastise =
	{
		MacroText = "/cast " .. GetSpellInfo(88625),
		SpellId = 88625,
		Update = OrlanHeal.Priest.UpdateDefaultChakraAbilityCooldown,
		Group = "Holy Word"
	};
	OrlanHeal.Priest.CooldownOptions.HolyNova =
	{
		SpellId = 132157,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
else
	table.insert(
		OrlanHeal.Priest.AvailableSpells, 
		{
			type = "macro",
			caption = "Free " .. GetSpellInfo(2061), -- Быстрое исцеление
			group = GetSpellInfo(89485), -- Внутреннее сосредоточение
			macrotext = OrlanHeal:BuildCastSequenceMacro(89485, 2061),
			key = "89485,2061"
		});
	table.insert(
		OrlanHeal.Priest.AvailableSpells, 
		{
			type = "macro",
			caption = "Free " .. GetSpellInfo(32546), -- Связующее исцеление
			group = GetSpellInfo(89485), -- Внутреннее сосредоточение
			macrotext = OrlanHeal:BuildCastSequenceMacro(89485, 32546),
			key = "89485,32546"
		});
	table.insert(
		OrlanHeal.Priest.AvailableSpells, 
		{
			type = "macro",
			caption = "Free " .. GetSpellInfo(2060), -- Великое исцеление
			group = GetSpellInfo(89485), -- Внутреннее сосредоточение
			macrotext = OrlanHeal:BuildCastSequenceMacro(89485, 2060),
			key = "89485,2060"
		});
	table.insert(OrlanHeal.Priest.AvailableSpells, 528); -- Излечение болезни
	OrlanHeal.Priest.CooldownOptions.Chakra =
	{
		SpellId = 14751,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.Archangel =
	{
		SpellId = 87151,
		Update = OrlanHeal.Priest.UpdateArchangelCooldown
	};
	OrlanHeal.Priest.CooldownOptions.HolyWordSanctuary =
	{
		MacroText = "/cast " .. GetSpellInfo(88685),
		SpellId = 88685,
		ChakraId = 81206,
		Update = OrlanHeal.Priest.UpdateChakraAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.HolyWordSerenity =
	{
		MacroText = "/cast " .. GetSpellInfo(88684),
		SpellId = 88684,
		ChakraId = 81585,
		Update = OrlanHeal.Priest.UpdateChakraAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.HolyWordChastise =
	{
		MacroText = "/cast " .. GetSpellInfo(88625),
		SpellId = 88625,
		ChakraId = 81209,
		Update = OrlanHeal.Priest.UpdateChakraAbilityCooldown
	};
	OrlanHeal.Priest.CooldownOptions.HolyNova =
	{
		SpellId = 15237,
		Update = OrlanHeal.UpdateAbilityCooldown
	};
end;

function OrlanHeal.Priest.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();
	config["1"] = 2050; -- Heal
	config["2"] = 2061; -- Flash Heal
	config["3"] = 47788; -- Guardian Spirit
	config["alt1"] = 527; -- Purify
	config["alt2"] = 139; -- Renew
	config["alt3"] = 108968; -- Void Shift
	config["shift2"] = 17; -- Power Word: Shield
	config["shift3"] = 6346; -- Fear Ward
	config["altshift1"] = 73325; -- Leap of Faith
	config["altshift2"] = 2096; -- Min Vision
	config["altshift3"] = 2006; -- Resurrection
	config["control1"] = 2060; -- Greater Heal
	config["control2"] = 88684; -- Holy Word: Serenity
	config["control3"] = 33076; -- Prayer of Mending
	config["controlalt1"] = 10060; -- Power Infusion
	config["controlalt2"] = 1706; -- Levitate
	config["controlalt3"] = 32546; -- Binding Heal
	config["controlaltshift1"] = 34861; -- Circle of Healing

	config["cooldown1"] = "Purify";
	config["cooldown2"] = "PowerWordShield";
	config["cooldown3"] = "Lightwell";
	config["cooldown4"] = "PrayerOfMending";
	config["cooldown5"] = "Shadowfiend";
	config["cooldown6"] = "CircleOfHealing";
	config["cooldown7"] = "PowerInfusion";
	config["cooldown8"] = "LeapOfFaith";
	config["cooldown9"] = "HymnOfHope";
	config["cooldown10"] = "DivineHymn";
	config["cooldown11"] = "ChakraSerenity";
	config["cooldown12"] = "ChakraSanctuary";
	config["cooldown13"] = "ChakraChastise";
	config["cooldown14"] = "HolyWordSerenity";
	config["cooldown15"] = "HolyWordSanctuary";
	config["cooldown16"] = "HolyWordChastise";
	config["cooldown17"] = "DominateMind";
	config["cooldown18"] = "Fade";
	config["cooldown19"] = "FearWard";
	config["cooldown20"] = "GuardianSpirit";
	config["cooldown21"] = "HolyFire";
	config["cooldown22"] = "HolyNova";
	config["cooldown23"] = "PsychicScream";
	config["cooldown24"] = "MassDispel";
	config["cooldown25"] = "ShadowWordDeath";
	config["cooldown26"] = "VoidShift";
	config["cooldown27"] = "AngelicFeather";
	config["cooldown28"] = orlanHeal:GetRacialCooldown();

	return config;
end;

function OrlanHeal.Priest.GetDisciplineDefaultConfig(orlanHeal)
	local config = orlanHeal.Class.GetDefaultConfig(orlanHeal);

	config["3"] = 33206; -- Pain Suppression
	config["control2"] = 47540; -- Penance
	config["controlaltshift1"] = "89485,2060"; -- Critical Greater Heal
	config["controlaltshift2"] = "89485,2061"; -- Critical Flash Heal

	config["cooldown3"] = "Penance";
	config["cooldown6"] = "InnerFocus";
	config["cooldown10"] = "Archangel";
	config["cooldown11"] = "PowerWordBarrier";
	config["cooldown12"] = "SpiritShell";
	config["cooldown13"] = nil;
	config["cooldown14"] = nil;
	config["cooldown15"] = nil;
	config["cooldown16"] = nil;
	config["cooldown20"] = "PainSuppression";


	return config;
end;

function OrlanHeal.Priest.LoadConfig(orlanHeal)
end;

function OrlanHeal.Priest.GetConfigPresets(orlanHeal)
	return
		{
			["Holy Priest Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal),
			["Discipline Priest Default"] = orlanHeal.Class.GetDisciplineDefaultConfig(orlanHeal)
		};
end;

OrlanHeal.Priest.RedRangeSpellId = 2096; -- Внутреннее зрение
OrlanHeal.Priest.OrangeRangeSpellId = 2061; -- Быстрое исцеление
OrlanHeal.Priest.YellowRangeSpellId = 1706; -- Левитация


function OrlanHeal.Priest.UpdateRaidBorder(orlanHeal)
	if GetBuildInfo() == "5.0.4" then
		if UnitBuff("player", GetSpellInfo(114255)) then -- From Darkness, Comes Light
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
		elseif UnitBuff("player", GetSpellInfo(123266)) or UnitBuff("player", GetSpellInfo(123267)) then -- Divine Insight
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
		else
			local hasSanctuary = UnitBuff("player", GetSpellInfo(81206)); -- Chakra: Sanctuary
			local hasSerenity = UnitBuff("player", GetSpellInfo(81208)); -- Chakra: Serenity
			if orlanHeal:IsSpellReady(47540) -- Penance
					or (not hasSerenity and not hasSanctuary and orlanHeal:IsSpellReady(88625)) -- Holy Word: Chastise
					or (hasSanctuary and orlanHeal:IsSpellNotOnCooldown(88685)) -- Holy Word: Sanctuary
					or (hasSerenity and orlanHeal:IsSpellNotOnCooldown(88684)) then -- Holy Word: Serenity
				orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
			else
				orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
			end;
		end;
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Priest.PlayerSpecificBuffCount = 3;

function OrlanHeal.Priest.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 17) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- свой щит
		buffKind = 1;
	elseif (spellId == 139) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- своё восстановление
		buffKind = 2;
	elseif (spellId == 6346) or  -- Защита от страха
			((spellId == 41635) and (caster ~= nil) and (UnitIsUnit(caster, "player"))) then -- своя Молитва восстановления
		buffKind = 3;
	end;

	return buffKind;
end;

OrlanHeal.Priest.PoisonDebuffKind = 3;
OrlanHeal.Priest.DiseaseDebuffKind = 2;
OrlanHeal.Priest.MagicDebuffKind = 2;
OrlanHeal.Priest.CurseDebuffKind = 3;
OrlanHeal.Priest.PlayerDebuffSlots = { 1, 2, 0, 0, 0 };
OrlanHeal.Priest.PetDebuffSlots = { 0, 0 };

function OrlanHeal.Priest.GetSpecificDebuffKind(orlanHeal, spellId)
	local debuffKind;
	if spellId == 6788 then -- Ослабленная душа
		debuffKind = 1;
	end;

	return debuffKind;
end;
