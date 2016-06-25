OrlanHeal.Paladin = {};

OrlanHeal.Paladin.IsSupported = true;
OrlanHeal.Paladin.GiftOfTheNaaruSpellId = 59542;

OrlanHeal.Paladin.AvailableSpells =
{
	19750, -- Flash of Light
	1022, -- Blessing of Protection
	4987, -- Cleanse
	20473, -- Holy Shock
	633, -- Lay on Hands
	82326, -- Holy Light
	53563, -- Beacon of Light
	156910, -- Beacon of Faith
	6940, -- Blessing of Sacrifice
	1044, -- Blessing of Freedom
	59542, -- Дар наауру
	7328, -- Redemption
	114165, -- Holy Prism
	183998, -- Light of the Martyr
 	223306 -- Bestow Faith
};

OrlanHeal.Paladin.CooldownOptions =
{
	LightOfDawn =
	{
		SpellId = 85222, -- Light of Dawn
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LayOnHands =
	{
		SpellId = 633, -- Lay on Hands
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AvengingWrath =
	{
		SpellId = 31842, -- Avenging Wrath
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AuraMastery =
	{
		SpellId = 31821, -- Devotion Aura
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	GiftOfTheNaaru =
	{
		SpellId = 59542, -- Gift of the Naaru
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Draenei";
		end
	},
	DivineProtection =
	{
		SpellId = 498, -- Divine Protection
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineShield =
	{
		SpellId = 642, -- Divine Shield
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfSacrifice =
	{
		SpellId = 6940, -- Blessing of Sacrifice
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfProtection =
	{
		SpellId = 1022, -- Blessing of Protection
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfFreedom =
	{
		SpellId = 1044, -- Blessing of Freedom
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HammerOfJustice =
	{
		SpellId = 853, -- Hammer of Justice
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyShock =
	{
		SpellId = 20473, -- Holy Shock
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Cleanse =
	{
		SpellId = 4987, -- Cleanse
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	CrusaderStrike =
	{
		SpellId = 35395, -- Crusader Strike
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Judgment =
	{
		SpellId = 20271, -- Judgment
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
	Reckoning =
	{
		SpellId = 62124, -- Hand of Reckoning
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BeaconOfLight =
	{
		SpellId = 53563, -- Beacon of Light
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BeaconOfFaith =
	{
		SpellId = 156910, -- Beacon of Faith
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BlindingLight =
	{
		SpellId = 115750, -- Blinding Light
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Contemplation =
	{
		SpellId = 121183, -- Contemplation
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Repentance =
	{
		SpellId = 20066, -- Repentance
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyAvenger =
	{
		SpellId = 105809, -- Holy Avenger
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BestowFaith =
	{
		SpellId = 223306, -- Bestow Faith
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Consecration =
	{
		SpellId = 26573, -- Consecration
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineSteed =
	{
		SpellId = 205656, -- Divine Steed
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyPrism =
	{
		SpellId = 114165, -- Holy Prism
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	LightsHammer =
	{
		SpellId = 114158, -- Light's Hammer
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	RuleOfLaw =
	{
		SpellId = 214202, -- Rule of Law
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Paladin.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 82326; -- Holy Light
	config["2"] = 19750; -- Flash of Light
	config["3"] = 1022; -- Blessing of Protection
	config["shift2"] = 53563; -- Beacon of Light
	config["shift3"] = 1044; -- Blessing of Freedom
	config["control1"] = 114165; -- Holy Prism
	config["control2"] = 183998; -- Light of the Martyr
	config["control3"] = 6940; -- Blessing of Sacrifice
	config["alt1"] = 4987; -- Cleanse
	config["alt2"] = 20473; -- Holy Shock
	config["alt3"] = 633; -- Lay on Hands
	config["controlalt1"] = 223306; -- Bestow Faith
	config["altshift2"] = 156910; -- Beacon of Faith
	config["altshift3"] = 7328; -- Redemption

	config["cooldown1"] = "Cleanse";
	config["cooldown2"] = "Judgment";
	config["cooldown3"] = "LightOfDawn";
	config["cooldown4"] = "HolyPrism";
	config["cooldown5"] = "LightsHammer";
	config["cooldown6"] = "HolyAvenger";
	config["cooldown7"] = "AvengingWrath"; 
	config["cooldown8"] = "DivineShield"; 
	config["cooldown9"] = "DivineProtection"; 
	config["cooldown10"] = "AuraMastery";
	config["cooldown11"] = "BestowFaith";
	config["cooldown12"] = "HandOfProtection";
	config["cooldown13"] = "HandOfSacrifice";
	config["cooldown14"] = "HandOfFreedom";
	config["cooldown15"] = "HammerOfJustice";
	config["cooldown16"] = "DivineSteed";
	config["cooldown17"] = "Repentance";
	config["cooldown18"] = "BlindingLight";
	config["cooldown19"] = "LayOnHands";
	config["cooldown20"] = "RuleOfLaw";
	config["cooldown21"] = orlanHeal:GetRacialCooldown();
	config["cooldown22"] = "Trinket0";
	config["cooldown23"] = "Trinket1";

	return config;
end;

function OrlanHeal.Paladin.LoadConfig(orlanHeal)
end;

function OrlanHeal.Paladin.GetConfigPresets(orlanHeal)
	return
		{
			["Paladin Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Paladin.HaveHolyShockDivinePurpose()
	local index = 1;
	while true do
		local spellId = select(11, UnitAura("player", index));
		if not spellId then
			break;
		end;

		if spellId == 216411 then
			return true;
		end;

		index = index + 1;
	end;

	return false;
end;

function OrlanHeal.Paladin.HaveLightOfDawnDivinePurpose()
	local index = 1;
	while true do
		local spellId = select(11, UnitAura("player", index));
		if not spellId then
			break;
		end;

		if spellId == 216413 then
			return true;
		end;

		index = index + 1;
	end;

	return false;
end;

function OrlanHeal.Paladin.UpdateRaidBorder(orlanHeal)
	local infusionOfLightSpellName = GetSpellInfo(54149);
	local lightsFavorSpellName = GetSpellInfo(166781);
	local lawfulWordsSpellName = GetSpellInfo(166780);

	if UnitBuff("player", lightsFavorSpellName) and orlanHeal:IsSpellReady(85222) then -- Light of Dawn
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 1, orlanHeal.RaidBorderAlpha); -- magenta
	elseif UnitBuff("player", lawfulWordsSpellName) and orlanHeal:IsSpellReady(19750) then -- Flash of Light
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 1, orlanHeal.RaidBorderAlpha); -- cyan
	elseif orlanHeal.Paladin.HaveLightOfDawnDivinePurpose() then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha); -- green
	elseif UnitBuff("player", infusionOfLightSpellName) then -- Infusion of Light
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha); -- blue
	elseif orlanHeal.Paladin.HaveHolyShockDivinePurpose() then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha); -- white
	elseif orlanHeal:IsSpellReady(20473) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha); -- yellow
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Paladin.PlayerSpecificBuffCount = 2;

function OrlanHeal.Paladin.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 53563) and (caster ~= nil) and UnitIsUnit(caster, "player") or -- своя Частица Света
			(spellId == 156910) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- своя Частица Веры
		buffKind = 1;
	elseif		(spellId == 1022) or -- Blessing of Protection
			(spellId == 6940) then -- Blessing of Sacrifice
		buffKind = 2;
	end;

	return buffKind;
end;

OrlanHeal.Paladin.PoisonDebuffKind = 1;
OrlanHeal.Paladin.DiseaseDebuffKind = 1;
OrlanHeal.Paladin.MagicDebuffKind = 1;
OrlanHeal.Paladin.CurseDebuffKind = 2;
OrlanHeal.Paladin.PlayerDebuffSlots = { 1, 0, 0, 0, 0 };
OrlanHeal.Paladin.PetDebuffSlots = { 1, 0 };

function OrlanHeal.Paladin.GetSpecificDebuffKind(orlanHeal, spellId)
end;
