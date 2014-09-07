OrlanHeal.Priest = {};

OrlanHeal.Priest.IsSupported = true;
OrlanHeal.Priest.GiftOfTheNaaruSpellId = 59544;

function OrlanHeal.Priest.UpdateHolyWordCooldown(orlanHeal, window)
	if not window.LastTextureUpdate or (window.LastTextureUpdate < time() - 5) then
		local _, _, texture = GetSpellInfo(window.Cooldown.SpellId);
		window.Background:SetTexture(texture);
		window.LastTextureUpdate = time();
	end;
	orlanHeal:UpdateAbilityCooldown(window);
end;

function OrlanHeal.Priest.UpdateArchangelCooldown(orlanHeal, window)
	local buffName = GetSpellInfo(81661); -- Приверженность
	local _, _, _, count, _, buffDuration, buffExpires = UnitBuff("player", buffName);

	local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
	local expirationTime, isReverse;
	if start and duration and (duration ~= 0) and (enabled == 1) then
		expirationTime = start + duration;
	elseif buffExpires then
		duration = buffDuration;
		expirationTime = buffExpires;
		isReverse = true;
	else
		duration = nil;
		expirationTime = nil;
	end;
	orlanHeal:UpdateCooldown(window, duration, expirationTime, count, true, isReverse, not count);
end;

OrlanHeal.Priest.AvailableSpells =
{
	1706, -- Левитация
	527, -- Рассеивание заклинаний
	17, -- Слово силы: Щит
	6346, -- Защита от страха
	2061, -- Flash Heal
	2060, -- Heal
	2006, -- Воскрешение
	139, -- Обновление
	32546, -- Связующее исцеление
	33076, -- Молитва восстановления
	73325, -- Духовное рвение
	2096, -- Внутреннее зрение
	47540, -- Исповедь
	47788, -- Оберегающий дух
	33206, -- Подавление боли
	59544, -- Дар Наару
	{
		type = "macro",
		caption = GetSpellInfo(88625), -- Holy Word: Chastise
		macrotext = "/cast [target=mouseover] " .. GetSpellInfo(88625),
		key = 88625
	},
	34861, -- Круг исцеления
	33076, -- Молитва восстановления
	596, -- Prayer of Healing
	21562, -- Power Word: Fortitude
	{
		type = "macro",
		caption = GetSpellInfo(175702), -- Divine Burst
		macrotext = OrlanHeal:BuildMouseOverCastMacro(175702),
		key = 175702
	},
	152118, -- Clarity of Will
	152116, -- Saving Grace
	126123 -- Confession
}

OrlanHeal.Priest.CooldownOptions =
{
	PowerWordShield =
	{
		SpellId = 17,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Power Word"
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
		SpellId = 126135,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PrayerOfHealing =
	{
		SpellId = 596,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Prayer"
	},
	CircleOfHealing =
	{
		SpellId = 34861,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DesperatePrayer =
	{
		SpellId = 19236,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Prayer"
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
		Update = OrlanHeal.UpdateRaidBuffAbilityCooldown,
		Group = "Prayer"
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
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Power Word"
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
	ShadowyGrasp =
	{
		MacroText = "/cast " .. GetSpellInfo(175701),
		SpellId = 175701,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AngelicFeather =
	{
		SpellId = 121536,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SpectralGuise =
	{
		SpellId = 112833,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineBurst =
	{
		MacroText = "/cast " .. GetSpellInfo(175702),
		SpellId = 175702,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineStar =
	{
		SpellId = 110744,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Halo =
	{
		SpellId = 120517,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Archangel =
	{
		SpellId = 81700,
		Update = OrlanHeal.Priest.UpdateArchangelCooldown
	},
	SpiritShell =
	{
		SpellId = 109964,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ChakraSerenity =
	{
		SpellId = 81208,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Chakra"
	},
	ChakraSanctuary =
	{
		SpellId = 81206,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Chakra"
	},
	ChakraChastise =
	{
		SpellId = 81209,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Chakra"
	},
	HolyWordChastise =
	{
		MacroText = "/cast " .. GetSpellInfo(88625),
		SpellId = 88625,
		Update = OrlanHeal.Priest.UpdateHolyWordCooldown
	},
	HolyNova =
	{
		SpellId = 132157,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ShackleUndead = 
	{
		SpellId = 9484,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PowerWordFortitude =
	{
		SpellId = 21562,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Power Word"
	},
	DispelMagic =
	{
		SpellId = 528,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Silence =
	{
		SpellId = 15487,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Priest.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();
	config["1"] = 2060; -- Heal
	config["2"] = 2061; -- Flash Heal
	config["3"] = 47788; -- Guardian Spirit
	config["alt1"] = 527; -- Purify
	config["alt2"] = 139; -- Renew
	config["alt3"] = 175702; -- Divine Burst
	config["shift2"] = 17; -- Power Word: Shield
	config["shift3"] = 6346; -- Fear Ward
	config["altshift1"] = 73325; -- Leap of Faith
	config["altshift2"] = 596; -- Prayer of Healing
	config["altshift3"] = 2006; -- Resurrection
	config["control1"] = 34861; -- Circle of Healing
	config["control2"] = 88625; -- Holy Word: Chastise
	config["control3"] = 33076; -- Prayer of Mending
	config["controlalt1"] = 152116; -- Saving Grace
	config["controlalt2"] = 1706; -- Levitate
	config["controlalt3"] = 32546; -- Binding Heal
	config["controlaltshift2"] = 126123; -- Confession
	config["controlshift1"] = 2096; -- Mind Vision

	config["cooldown1"] = "Purify";
	config["cooldown2"] = "PowerWordShield";
	config["cooldown3"] = "Lightwell";
	config["cooldown4"] = "PrayerOfMending";
	config["cooldown5"] = "Shadowfiend";
	config["cooldown6"] = "CircleOfHealing";
	config["cooldown7"] = "PowerInfusion";
	config["cooldown8"] = "LeapOfFaith";
	config["cooldown9"] = "DivineBurst";
	config["cooldown10"] = "DivineHymn";
	config["cooldown11"] = "HolyFire";
	config["cooldown12"] = "AngelicFeather";
	config["cooldown13"] = "DesperatePrayer";
	config["cooldown14"] = "SpectralGuise";
	config["cooldown15"] = "DispelMagic";
	config["cooldown16"] = "HolyWordChastise";
	config["cooldown17"] = "ShadowyGrasp";
	config["cooldown18"] = "Fade";
	config["cooldown19"] = "FearWard";
	config["cooldown20"] = "GuardianSpirit";
	config["cooldown23"] = "ShackleUndead";
	config["cooldown24"] = "MassDispel";
	config["cooldown25"] = orlanHeal:GetRacialCooldown();
	config["cooldown26"] = "Trinket0";
	config["cooldown27"] = "Trinket1";

	return config;
end;

function OrlanHeal.Priest.GetDisciplineDefaultConfig(orlanHeal)
	local config = orlanHeal.Class.GetDefaultConfig(orlanHeal);

	config["3"] = 33206; -- Pain Suppression
	config["control2"] = 47540; -- Penance
	config["controlalt3"] = "";
	config["control1"] = "";
	config["alt2"] = 152118; -- Clarity of Will

	config["cooldown3"] = "Penance";
	config["cooldown6"] = "HolyNova";
	config["cooldown10"] = "Archangel";
	config["cooldown16"] = "Silence";
	config["cooldown20"] = "PainSuppression";
	config["cooldown21"] = "PowerWordBarrier";
	config["cooldown22"] = "SpiritShell";

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

function OrlanHeal.Priest.UpdateRaidBorder(orlanHeal)
	if UnitBuff("player", GetSpellInfo(114255)) then -- From Darkness, Comes Light
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", GetSpellInfo(123266)) or UnitBuff("player", GetSpellInfo(123267)) then -- Divine Insight
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
	else
		if orlanHeal:IsSpellReady(47540) -- Penance
				or orlanHeal:IsSpellReady(88625) then -- Holy Word: Chastise
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
		else
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
		end;
	end;
end;

OrlanHeal.Priest.PlayerSpecificBuffCount = 3;

function OrlanHeal.Priest.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 17) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- свой щит
		buffKind = 1;
	elseif (spellId == 139) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- своё восстановление
		buffKind = 2;
	elseif (spellId == 6346) or  -- Защита от страха
			((spellId == 41635) and (caster ~= nil) and UnitIsUnit(caster, "player")) then -- своя Молитва восстановления
		buffKind = 3;
	end;

	return buffKind;
end;

OrlanHeal.Priest.PoisonDebuffKind = 3;
OrlanHeal.Priest.DiseaseDebuffKind = 2;
OrlanHeal.Priest.MagicDebuffKind = 2;
OrlanHeal.Priest.CurseDebuffKind = 3;
OrlanHeal.Priest.PlayerDebuffSlots = { 1, 2, 0, 0, 0 };
OrlanHeal.Priest.PetDebuffSlots = { 2, 0 };

function OrlanHeal.Priest.GetSpecificDebuffKind(orlanHeal, spellId)
	local debuffKind;
	if spellId == 6788 then -- Ослабленная душа
		debuffKind = 1;
	end;

	return debuffKind;
end;
