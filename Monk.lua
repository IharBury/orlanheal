OrlanHeal.Monk = {};

OrlanHeal.Monk.GiftOfTheNaaruSpellId = 121093;

function OrlanHeal.Monk.UpdateChiAbilityCooldown(orlanHeal, window)
	local power = UnitPower("player", SPELL_POWER_LIGHT_FORCE);
	local _, _, _, cost = GetSpellInfo(window.Cooldown.SpellId);
	if power >= cost then
		local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
		local expirationTime;
		if start and duration and (duration ~= 0) and (enabled == 1) then
			expirationTime = start + duration;
		else
			start = nil;
			duration = nil;
			expirationTime = nil;
		end;
		orlanHeal:UpdateCooldown(window, duration, expirationTime, power, true);
	else
		window:SetReverse(true);
		if not window.Dark then
			window:SetCooldown(0, 10);
			window.Dark = true;
		end;
		window.Count:SetText(power);
	end;
end;

OrlanHeal.Monk.AvailableSpells =
{
	121093, -- Gift of the Naaru
	115098 -- Chi Wave
};

OrlanHeal.Monk.CooldownOptions =
{
	GiftOfTheNaaru =
	{
		SpellId = 121093, -- Gift of the Naaru
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Draenei";
		end
	},
	BloodFury =
	{
		SpellId = 33697, -- Blood Fury
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Orc";
		end
	},
	ArcaneTorrent =
	{
		SpellId = 129597, -- Arcane Torrent
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "BloodElf";
		end
	},
	TigersLust =
	{
		SpellId = 116841,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	},
	ChiWave =
	{
		SpellId = 115098,
		Update = OrlanHeal.Monk.UpdateChiAbilityCooldown
	}
};

function OrlanHeal.Monk.GetDefaultConfig(orlanHeal)
	local config = orlanHeal:GetCommonDefaultConfig();
	return config;
end;

OrlanHeal.Monk.PlayerSpecificBuffCount = 0;

OrlanHeal.Monk.PoisonDebuffKind = 1;
OrlanHeal.Monk.DiseaseDebuffKind = 1;
OrlanHeal.Monk.MagicDebuffKind = 1;
OrlanHeal.Monk.CurseDebuffKind = 1;
OrlanHeal.Monk.PlayerDebuffSlots = { 0, 0, 0, 0, 0 };
OrlanHeal.Monk.PetDebuffSlots = { 0, 0 };

OrlanHeal.Monk.RedRangeSpellId = 53563; -- Частица Света
OrlanHeal.Monk.OrangeRangeSpellId = 635; -- Holy Light
OrlanHeal.Monk.YellowRangeSpellId = 20217; -- Blessing of Kings

function OrlanHeal.Monk.GetSpecificDebuffKind(orlanHeal, spellId)
end;

function OrlanHeal.Monk.UpdateRaidBorder(orlanHeal)
	orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
end;

function OrlanHeal.Monk.GetConfigPresets(orlanHeal)
	return
		{
			["Monk Default"] = orlanHeal.Class.GetDefaultConfig(orlanHeal)
		};
end;

function OrlanHeal.Monk.GetSpecificBuffKind(orlanHeal, spellId, caster)
end;
