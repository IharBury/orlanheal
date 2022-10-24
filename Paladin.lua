OrlanHeal.Paladin = {};

OrlanHeal.Paladin.IsSupported = true;
OrlanHeal.Paladin.GiftOfTheNaaruSpellId = 59542;

OrlanHeal.Paladin.AvailableSpells =
{
	48785, -- Flash of Light
	48782, -- Holy Light
	48788, -- Lay on Hands
	53563, -- Beacon of Light
	1044, -- Hand of Freedom
	10278, -- Hand of Protection
	4987, -- Cleanse
	48825, -- Holy Shock
	6940, -- Hand of Sacrifice
	59542, -- Gift of the Naaru
	48950, -- Redemption
	1038, -- Hand of Salvation
	19752, -- Divine Intervention
	53601, -- Sacred Shield
	31789 -- Righteous Defense
};

OrlanHeal.Paladin.CooldownOptions =
{
	LayOnHands =
	{
		SpellId = 48788, -- Lay on Hands
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
		SpellId = 6940, -- Hand of Sacrifice
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfProtection =
	{
		SpellId = 10278, -- Hand of Protection
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfFreedom =
	{
		SpellId = 1044, -- Hand of Freedom
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HandOfSalvation =
	{
		SpellId = 1038, -- Hand of Salvation
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HammerOfJustice =
	{
		SpellId = 10308, -- Hammer of Justice
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyShock =
	{
		SpellId = 48825, -- Holy Shock
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
	JudgmentOfJustice =
	{
		SpellId = 53407, -- Judgment of Justice
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Judgment =
	{
		SpellId = 20271, -- Judgment of Light
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	JudgmentOfWisdom =
	{
		SpellId = 53408, -- Judgment of Wisdom
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
		Update = OrlanHeal.UpdateRaidBuffCooldown
	},
	Repentance =
	{
		SpellId = 20066, -- Repentance
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Consecration =
	{
		SpellId = 48819, -- Consecration
		Update = OrlanHeal.UpdateTotemCooldown,
		TotemIndex = 1
	},
	HammerOfWrath =
	{
		SpellId = 48806, -- Hammer of Wrath
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAlwaysUsable = true
	},
	TurnEvil =
	{
		SpellId = 10326, -- Turn Evil
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineFavor =
	{
		SpellId = 20216, -- Divine Favor
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivineIntervention = {
		SpellId = 19752, -- Divine Intervention
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	DivinePlea = {
		SpellId = 54428, -- Divine Plea
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	HolyWrath = {
		SpellId = 48817, -- Holy Wrath
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	RighteousDefense = {
		SpellId = 31789, -- RighteousDefense
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ShieldOfRighteousness = {
		SpellId = 61411, -- Shield of Righteousness
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	JudgementsOfThePure = {
		SpellId = 54155, -- Judgements of the Pure
		Update = OrlanHeal.UpdatePlayerBuffCooldown
	},
	DivineIllumination = {
		SpellId = 31842, -- Divine Illumination
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SacredShield = {
		SpellId = 53601, -- Sacred Shield
		Update = OrlanHeal.UpdateRaidBuffCooldown
	}
};

function OrlanHeal.Paladin.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 48782; -- Holy Light
	config["2"] = 48785; -- Flash of Light
	config["3"] = 48788; -- Lay on Hands
	config["shift2"] = 53563; -- Beacon of Light
	config["shift3"] = 1038; -- Hand of Salvation
	config["control2"] = 53601; -- Sacred Shield
	config["control3"] = 10278; -- Hand of Protection
	config["alt1"] = 4987; -- Cleanse
	config["alt2"] = 48825; -- Holy Shock
	config["alt3"] = 6940; -- Hand of Sacrifice
	config["altshift3"] = 48950; -- Redemption

	config["cooldown1"] = "JudgementsOfThePure";
	config["cooldown2"] = "BeaconOfLight";
	config["cooldown3"] = "SacredShield";
	config["cooldown4"] = orlanHeal:GetRacialCooldown();
	config["cooldown5"] = "Trinket0";
	config["cooldown6"] = "Trinket1";

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
	if orlanHeal:IsSpellReady(48825) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha); -- yellow
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0); -- black
	end;
end;

OrlanHeal.Paladin.PlayerSpecificBuffCount = 3;
OrlanHeal.Paladin.PlayerSpecificDebuffCount = 1;

function OrlanHeal.Paladin.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if spellId == 53601 then -- Sacred Shield
		buffKind = 1;
	elseif (spellId == 53563) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Beacon of Light
		buffKind = 2;
	elseif (spellId == 10278) or -- Hand of Protection
	        (spellId == 1038) or -- Hand of Salvation
			(spellId == 6940) then -- Hand of Sacrifice
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

function OrlanHeal.Paladin.GetSpecificDebuffKind(orlanHeal, spellId, caster)
	local debuffKind;
	if spellId == 25771 then -- Forbearance
		debuffKind = 1;
	end;
	return debuffKind;
end;
