OrlanHeal.Evoker = {};

OrlanHeal.Evoker.IsSupported = true;

OrlanHeal.Evoker.AvailableSpells =
{
	355913, -- Emerald Blossom
	357170, -- Time Dilation
	360995, -- Verdant Embrace
	361227, -- Return
	361469, -- Living Flame
	364343, -- Echo
	365585, -- Expunge
	366155, -- Reversion
	367226, -- Spiritbloom
	374251 -- Cauterizing Flame
};

OrlanHeal.Evoker.CooldownOptions =
{
	DreamBreath =
	{
		SpellId = 355936, -- Dream Breath
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Naturalize =
	{
		SpellId = 365585, -- Expunge
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ObsidianScales =
	{
		SpellId = 363916, -- Obsidian Scales
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	RenewingBlaze =
	{
		SpellId = 374348, -- Renewing Blaze
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Reversion =
	{
		SpellId = 366155, -- Reversion
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Rewind =
	{
		SpellId = 363534, -- Rewind
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Spiritbloom =
	{
		SpellId = 367226, -- Spiritbloom
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	TimeDilation =
	{
		SpellId = 357170, -- Time Dilation
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	VerdantEmbrace =
	{
		SpellId = 360995, -- Verdant Embrace
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Zephyr =
	{
		SpellId = 374227, -- Zephyr
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Evoker.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();

	config["1"] = 367226; -- Spiritbloom
	config["2"] = 361469; -- Living Flame
	config["shift2"] = 364343; -- Echo
	config["shift3"] = 360995; -- Verdant Embrace
	config["control2"] = 355913; -- Emerald Blossom
	config["control3"] = 374251; -- Cauterizing Flame
	config["alt1"] = 365585; -- Naturalize
	config["alt2"] = 366155; -- Reversion
	config["alt3"] = 357170; -- Time Dilation
	config["altshift3"] = 361227; -- Return

	config["cooldown1"] = "VerdantEmbrace";
	config["cooldown2"] = "DreamBreath";
	config["cooldown3"] = "Naturalize";
	config["cooldown4"] = "ObsidianScales";
	config["cooldown5"] = "Zephyr";
	config["cooldown6"] = "RenewingBlaze";
	config["cooldown7"] = "Reversion";
	config["cooldown8"] = "Rewind";
	config["cooldown9"] = "TimeDilation";
	config["cooldown10"] = "Spiritbloom";
	config["cooldown11"] = "Trinket0";
	config["cooldown12"] = "Trinket1";

	return config;
end;

function OrlanHeal.Evoker.LoadConfig(orlanHeal)
end;

function OrlanHeal.Evoker.GetConfigPresets(orlanHeal)
	return
		{
			["Evoker Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Evoker.UpdateRaidBorder(orlanHeal)
	local essence = UnitPower("player", Enum.PowerType.Essence);
	local maxEssence = UnitPowerMax("player", Enum.PowerType.Essence);

	local emeraldBlossomCost = 3;
	local echoCost = 2;

	if (essence == maxEssence) or (orlanHeal:PlayerHasBuff(369299)) then -- Essence Burst
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha); -- white
	elseif essence >= emeraldBlossomCost then
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha); -- green
	elseif essence >= echoCost then
		if orlanHeal:IsSpellReady(366155) then -- Reversion
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0.8, 0.5, orlanHeal.RaidBorderAlpha); -- orange
		else
			orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha); -- red
		end;
	elseif orlanHeal:IsSpellReady(366155) then -- Reversion
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0.7, 0.7, 0, orlanHeal.RaidBorderAlpha); -- yellow
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0); -- black
	end;
end;

OrlanHeal.Evoker.PlayerSpecificBuffCount = 1;
OrlanHeal.Evoker.PlayerSpecificDebuffCount = 0;

function OrlanHeal.Evoker.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 364343) and (caster ~= nil) and UnitIsUnit(caster, "player") then -- own Echo
		buffKind = 1;
	end;

	return buffKind;
end;

OrlanHeal.Evoker.PoisonDebuffKind = 1;
OrlanHeal.Evoker.DiseaseDebuffKind = 2;
OrlanHeal.Evoker.MagicDebuffKind = 1;
OrlanHeal.Evoker.CurseDebuffKind = 2;
OrlanHeal.Evoker.PlayerDebuffSlots = { 1, 2, 0, 0, 0 };
OrlanHeal.Evoker.PetDebuffSlots = { 1, 0 };

function OrlanHeal.Evoker.GetSpecificDebuffKind(orlanHeal, spellId, caster)
	local debuffKind;
	return debuffKind;
end;
