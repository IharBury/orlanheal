OrlanHeal.Paladin = {};

OrlanHeal.Paladin.IsSupported = true;
OrlanHeal.Paladin.GiftOfTheNaaruSpellId = 59542;

OrlanHeal.Paladin.AvailableSpells =
{
	19750, -- Flash of Light
	82326, -- Holy Light
	633, -- Lay on Hands
	53563, -- Beacon of Light
	1044, -- Blessing of Freedom
	183998, -- Light of the Martyr
	85673, -- Word of Glory
	1022, -- Blessing of Protection
	4987, -- Cleanse
	20473, -- Holy Shock
	6940, -- Blessing of Sacrifice
	156910, -- Beacon of Faith
	59542, -- Gift of the Naaru
	7328, -- Redemption
	114165, -- Holy Prism
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
		SpellId = 31884, -- Avenging Wrath
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AuraMastery =
	{
		SpellId = 31821, -- Aura Mastery
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
		SpellId = 190784, -- Divine Steed
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
	},
	HammerOfWrath =
	{
		SpellId = 24275, -- Hammer of Wrath
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	TurnEvil =
	{
		SpellId = 10326, -- Turn Evil
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Seraphim =
	{
		SpellId = 152262, -- Seraphim
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	AvengingCrusader =
	{
		SpellId = 216331, -- Avenging Crusader
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	BeaconOfVirtue =
	{
		SpellId = 200025, -- Beacon of Virtue
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineFavor =
	{
		SpellId = 210294, -- Divine Favor
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Paladin.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 82326; -- Holy Light
	config["2"] = 19750; -- Flash of Light
	config["3"] = 633; -- Lay on Hands
	config["shift2"] = 53563; -- Beacon of Light
	config["shift3"] = 1044; -- Blessing of Freedom
	config["control1"] = 183998; -- Light of the Martyr
	config["control2"] = 85673; -- Word of Glory
	config["control3"] = 1022; -- Blessing of Protection
	config["alt1"] = 4987; -- Cleanse
	config["alt2"] = 20473; -- Holy Shock
	config["alt3"] = 6940; -- Blessing of Sacrifice
	config["controlalt1"] = 223306; -- Bestow Faith
	config["controlalt2"] = 114165; -- Holy Prism
	config["altshift2"] = 156910; -- Beacon of Faith
	config["altshift3"] = 7328; -- Redemption

	config["cooldown1"] = "Cleanse";
	config["cooldown2"] = "Judgment";
	config["cooldown3"] = "HolyPrism";
	config["cooldown4"] = "LightsHammer";
	config["cooldown5"] = "HolyAvenger";
	config["cooldown6"] = "AvengingWrath"; 
	config["cooldown7"] = "Seraphim";
	config["cooldown8"] = "AvengingCrusader";
	config["cooldown9"] = "DivineShield"; 
	config["cooldown10"] = "DivineProtection"; 
	config["cooldown11"] = "AuraMastery";
	config["cooldown12"] = "BestowFaith";
	config["cooldown13"] = "HandOfProtection";
	config["cooldown14"] = "HandOfSacrifice";
	config["cooldown15"] = "HandOfFreedom";
	config["cooldown16"] = "HammerOfJustice";
	config["cooldown17"] = "DivineSteed";
	config["cooldown18"] = "Repentance";
	config["cooldown19"] = "BlindingLight";
	config["cooldown20"] = "TurnEvil";
	config["cooldown21"] = "LayOnHands";
	config["cooldown22"] = "RuleOfLaw";
	config["cooldown23"] = "HammerOfWrath";
	config["cooldown24"] = "BeaconOfVirtue";
	config["cooldown25"] = orlanHeal:GetRacialCooldown();
	config["cooldown26"] = "Trinket0";
	config["cooldown27"] = "Trinket1";
	config["cooldown28"] = "DivineFavor";

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

function OrlanHeal.Paladin.UpdateRaidBorder(orlanHeal)
	local holyPower = UnitPower("player", Enum.PowerType.HolyPower);
	local maxHolyPower = UnitPowerMax("player", Enum.PowerType.HolyPower);

	if orlanHeal:PlayerHasBuff(54149) then -- Infusion of Light
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0.5, 0.5, 0.5, orlanHeal.RaidBorderAlpha); -- grey
	elseif (holyPower == maxHolyPower) or orlanHeal:PlayerHasBuff(223817) then -- Divine Purpose
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha); -- white
	elseif holyPower >= 3 then
		if orlanHeal.Paladin:CanUseHolyPowerGenerator(20473) then -- Holy Shock
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0.5, orlanHeal.RaidBorderAlpha); -- light yellow
		elseif orlanHeal.Paladin:CanUseTargetedHolyPowerGenerator(24275) then -- Hammer of Wrath
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0.5, 0.5, 1, orlanHeal.RaidBorderAlpha); -- light blue
		elseif orlanHeal.Paladin:CanUseTargetedHolyPowerGenerator(35395) then -- Crusader Strike
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0.5, 0.5, orlanHeal.RaidBorderAlpha); -- light red
		else
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha); -- green
		end;
	elseif orlanHeal.Paladin:CanUseHolyPowerGenerator(20473) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0.7, 0.7, 0, orlanHeal.RaidBorderAlpha); -- yellow
	elseif orlanHeal.Paladin:CanUseTargetedHolyPowerGenerator(24275) then -- Hammer of Wrath
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha); -- blue
	elseif orlanHeal.Paladin:CanUseTargetedHolyPowerGenerator(35395) then -- Crusader Strike
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha); -- red
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Paladin.PlayerSpecificBuffCount = 3;
OrlanHeal.Paladin.PlayerSpecificDebuffCount = 1;

function OrlanHeal.Paladin.CanUseHolyPowerGenerator(self, id)
	local usable, noMana = IsUsableSpell(id);
	if (not usable) or noMana then
		return false;
	end;
	local cooldownStart = GetSpellCooldown(id);
	return cooldownStart == 0;
end;

function OrlanHeal.Paladin.CanUseTargetedHolyPowerGenerator(self, id)
	if not self:CanUseHolyPowerGenerator(id) then
		return false;
	end;
	local name = GetSpellInfo(id);
	if not name then
		return false;
	end;
	local inRange = IsSpellInRange(name, "target");
	return inRange == 1;
end;

function OrlanHeal.Paladin.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 53563) and (caster ~= nil) and UnitIsUnit(caster, "player") or -- own Beacon of Light
			(spellId == 156910) and (caster ~= nil) and UnitIsUnit(caster, "player") or -- own Beacon of Faith
			(spellId == 200025) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Beacon of Virtue
		buffKind = 1;
	elseif spellId == 287280 then -- Glimmer of Light
		buffKind = 2;
	elseif (spellId == 1022) or -- Blessing of Protection
			(spellId == 6940) then -- Blessing of Sacrifice
		buffKind = 3;
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
	local debuffKind;
	if spellId == 25771 then
		debuffKind = 1;
	end;
	return debuffKind;
end;
