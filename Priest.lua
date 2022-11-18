OrlanHeal.Priest = {};

OrlanHeal.Priest.IsSupported = false;
OrlanHeal.Priest.GiftOfTheNaaruSpellId = 59544;

OrlanHeal.Priest.AvailableSpells =
{
	1706, -- Levitate
	527, -- Purify
	17, -- Power Word: Shield
	2061, -- Flash Heal
	{
		type = "spell",
		spell = 2060, -- Heal
		gpoup = select(2, GetSpecializationInfo(2)) -- Holy
	},
	2006, -- Resurrection
	{
		type = "spell",
		spell = 139, -- Renew
		group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	{
		type = "spell",
		spell = 32546, -- Binding Heal
		group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	{
		type = "spell",
		spell = 33076, -- Prayer of Mending
		group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	73325, -- Leap of Faith
	2096, -- Mind Vision
	{
		type = "spell",
		spell = 47540, -- Penance
		group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	{
		type = "spell",
		spell = 47788, -- Guardian Spirit
		group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	{
		type = "spell",
		spell = 33206, -- Pain Suppression
		group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	59544, -- Gift of the Naaru
	{
		type = "spell",
		spell = 596, -- Prayer of Healing
		group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	{
		type = "spell",
		spell = 2050, -- Holy Word: Serenity
		group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	204263, -- Shining Force
	{
		type = "spell",
		spell = 204883, -- Circle of Healing
		group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	{
		type = "spell",
		spell = 194509, -- Power Word: Radiance
		group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	{
		type = "spell",
		spell = 186263, -- Shadow Mend
		group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	{
		type = "spell",
		spell = 47540, -- Penance
		group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	{
		type = "spell",
		spell = 47536, -- Rapture
		group = select(2, GetSpecializationInfo(1)) -- Discipline
	}
}

OrlanHeal.Priest.CooldownOptions =
{
	PowerWordShield =
	{
		SpellId = 17,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PainSuppression =
	{
		SpellId = 33206,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(1)) -- Discipline
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
	HolyWordSanctify =
	{
		SpellId = 34861, -- Holy Word: Sanctify
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	CircleOfHealing =
	{
		SpellId = 204883, -- Circle of Healing
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	DesperatePrayer =
	{
		SpellId = 19236,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Shadowfiend =
	{
		SpellId = 34433,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	PrayerOfMending =
	{
		SpellId = 33076,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	GuardianSpirit =
	{
		SpellId = 47788,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	Penance =
	{
		SpellId = 47540,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(1)) -- Discipline
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
		Group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	MassDispel =
	{
		SpellId = 32375,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineHymn =
	{
		SpellId = 64843,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
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
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	Purify =
	{
		SpellId = 527,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ArcaneTorrent =
	{
		SpellId = 232633, -- Arcane Torrent
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "BloodElf";
		end
	},
	BagOfTricks =
	{
		SpellId = 312411,
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Vulpera";
		end
	},
	AngelicFeather =
	{
		SpellId = 121536,
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
	HolyWordChastise =
	{
		SpellId = 88625,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
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
	DispelMagic =
	{
		SpellId = 528,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	MindControl =
	{
		SpellId = 605,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PsychicScream =
	{
		SpellId = 8122,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Rapture =
	{
		SpellId = 47536,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	Schism =
	{
		SpellId = 214621,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	ShiningForce =
	{
		SpellId = 204263,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	PowerWordSolace =
	{
		SpellId = 129250,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(1)) -- Discipline
	},
	HolyWordSerenity =
	{
		SpellId = 2050,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	SymbolOfHope =
	{
		SpellId = 64901,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	Apotheosis =
	{
		SpellId = 200183,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(2)) -- Holy
	},
	PowerWordRadiance =
	{
		SpellId = 194509,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = select(2, GetSpecializationInfo(1)) -- Discipline
	}
};

function OrlanHeal.Priest.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();
	config["1"] = 2060; -- Heal -- Holy
	config["2"] = 2061; -- Flash Heal
	config["3"] = 47788; -- Guardian Spirit -- Holy
	config["alt1"] = 527; -- Purify
	config["alt2"] = 139; -- Renew -- Holy
	config["alt3"] = 2050; -- Holy Word: Serenity -- Holy
	config["shift2"] = 17; -- Power Word: Shield
	config["shift3"] = 33076; -- Prayer of Mending -- Holy
	config["altshift1"] = 73325; -- Leap of Faith
	config["altshift2"] = 596; -- Prayer of Healing -- Holy
	config["altshift3"] = 2006; -- Resurrection
	config["control1"] = 204883; -- Circle of Healing -- Holy
	config["control2"] = 32546; -- Binding Heal -- Holy
	config["control3"] = 204263; -- Shining Force
	config["controlalt2"] = 1706; -- Levitate
	config["controlshift1"] = 2096; -- Mind Vision

	config["cooldown1"] = "Purify";
	config["cooldown2"] = "PowerInfusion";
	config["cooldown3"] = "Apotheosis"; -- Holy
	config["cooldown4"] = "PrayerOfMending"; -- Holy
	config["cooldown5"] = "SymbolOfHope"; -- Holy
	config["cooldown6"] = "CircleOfHealing"; -- Holy
	config["cooldown7"] = "HolyNova";
	config["cooldown8"] = "LeapOfFaith";
	config["cooldown9"] = "HolyWordSanctify"; -- Holy
	config["cooldown10"] = "DivineHymn"; -- Holy
	config["cooldown11"] = "HolyFire"; -- Holy
	config["cooldown12"] = "AngelicFeather";
	config["cooldown13"] = "DesperatePrayer";
	config["cooldown14"] = "ShiningForce";
	config["cooldown15"] = "DispelMagic";
	config["cooldown16"] = "HolyWordChastise"; -- Holy
	config["cooldown17"] = "Fade";
	config["cooldown18"] = "DivineStar";
	config["cooldown19"] = "Halo";
	config["cooldown20"] = "PainSuppression";
	config["cooldown21"] = "HolyWordSerenity"; -- Holy
	config["cooldown22"] = "MindControl";
	config["cooldown23"] = "ShackleUndead";
	config["cooldown24"] = "MassDispel";
	config["cooldown25"] = "PsychicScream";
	config["cooldown26"] = "GuardianSpirit"; -- Holy
	config["cooldown27"] = orlanHeal:GetRacialCooldown();
	config["cooldown28"] = "Trinket0";
	config["cooldown29"] = "Trinket1";

	return config;
end;

function OrlanHeal.Priest.GetDisciplineDefaultConfig(orlanHeal)
	local config = orlanHeal.Class.GetDefaultConfig(orlanHeal);

	config["1"] = "";
	config["3"] = 33206; -- Pain Suppression
	config["alt2"] = "";
	config["alt3"] = "";
	config["shift3"] = 47536; -- Rapture
	config["altshift2"] = "";
	config["control1"] = 194509; -- Power Word: Radiance
	config["control2"] = 47540; -- Penance

	config["cooldown3"] = "Penance";
	config["cooldown4"] = "PowerWordRadiance";
	config["cooldown5"] = "Shadowfiend";
	config["cooldown6"] = "PowerWordSolace";
	config["cooldown9"] = "";
	config["cooldown10"] = "Rapture";
	config["cooldown11"] = "Schism";
	config["cooldown16"] = "";
	config["cooldown21"] = "PowerWordBarrier";
	config["cooldown26"] = "";

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
	local isPenanceReady = orlanHeal:IsSpellReady(47540);
	local isRadianceReady = orlanHeal:IsSpellReady(194509);
	if isPenanceReady then
		if isRadianceReady then
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha); -- white
		else
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0.7, 0.7, 0, orlanHeal.RaidBorderAlpha); -- yellow
		end;
	elseif isRadianceReady then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha); -- green
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Priest.PlayerSpecificBuffCount = 2;

function OrlanHeal.Priest.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 17) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Power Word: Shield
		buffKind = 1;
	elseif (spellId == 139) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Renew
		buffKind = 1;
	elseif (spellId == 41635) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Prayer of Mending
		buffKind = 2;
	end;

	return buffKind;
end;

OrlanHeal.Priest.PoisonDebuffKind = 2;
OrlanHeal.Priest.DiseaseDebuffKind = 1;
OrlanHeal.Priest.MagicDebuffKind = 1;
OrlanHeal.Priest.CurseDebuffKind = 2;
OrlanHeal.Priest.PlayerDebuffSlots = { 1, 3, 0, 0, 0 };
OrlanHeal.Priest.PetDebuffSlots = { 3, 0 };

function OrlanHeal.Priest.GetSpecificDebuffKind(orlanHeal, spellId, caster)
	local debuffKind;
	if (spellId == 6788) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Weakened Soul
		debuffKind = 3;
	end
	return debuffKind;
end;
