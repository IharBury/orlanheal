OrlanHeal.Paladin = {};

OrlanHeal.Paladin.AvailableSpells =
{
	635, -- Holy Light
	19750, -- Flash of Light
	1022, -- Hand of Protection
	4987, -- Cleanse
	20473, -- Holy Shock
	633, -- Lay on Hands
	85673, -- Word of Glory
	1038, -- Hand of Salvation
	82326, -- Divine Light
	53563, -- Beacon of Light
	6940, -- Hand of Sacrifice
	1044, -- Hand of Freedom
	59542, -- Дар наауру
	20217, -- Blessing of Kings
	7328, -- Redemption
	31789, -- Righteous Defense
	19740 -- Blessing of Might
};

function OrlanHeal.Paladin.CreateCooldowns(orlanHeal, cooldowns)
	cooldowns[0] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 0, 53655, 20271, true); -- Judgements of the Pure
	cooldowns[1] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 1, 53563, 53563, true); -- Beacon of Light
	cooldowns[2] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 2, 82327, 82327, false); -- Holy Radiance
	cooldowns[3] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 3, 85222, 85222, false); -- Light of Dawn
	cooldowns[4] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 4, 633, 633, false); -- Lay on Hands
	cooldowns[5] = orlanHeal:CreateCooldown(cooldowns.Frames[1], 0, 31884, 31884, false); -- Avenging Wrath
	cooldowns[6] = orlanHeal:CreateCooldown(cooldowns.Frames[1], 1, 31842, 31842, false); -- Divine Favor
	cooldowns[7] = orlanHeal:CreateCooldown(cooldowns.Frames[1], 2, 86150, 86150, false); -- Guardian of Ancient Kings
	cooldowns[8] = orlanHeal:CreateCooldown(cooldowns.Frames[1], 3, 31821, 31821, false); -- Aura Mastery
	cooldowns[9] = orlanHeal:CreateCooldown(cooldowns.Frames[1], 4, 54428, 54428, false); -- Divine Plea
end;

function OrlanHeal.Paladin.UpdateCooldowns(orlanHeal)
	orlanHeal:UpdatePlayerBuffCooldown(orlanHeal.RaidWindow.Cooldowns[0], 53655); -- Judgements of the Pure
	orlanHeal:UpdateRaidBuffCooldown(orlanHeal.RaidWindow.Cooldowns[1], 53563); -- Beacon of Light
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[2], 82327); -- Holy Radiance
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[3], 85222); -- Light of Dawn
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[4], 633); -- Lay on Hands
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[5], 31884); -- Avenging Wrath
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[6], 31842); -- Divine Favor
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[7], 86150); -- Guardian of Ancient Kings
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[8], 31821); -- Aura Mastery
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[9], 54428); -- Divine Plea
end;

OrlanHeal.Paladin.RedRangeSpellId = 53563; -- Частица Света
OrlanHeal.Paladin.OrangeRangeSpellId = 635; -- Holy Light
OrlanHeal.Paladin.YellowRangeSpellId = 1022; -- Hand of Protection

function OrlanHeal.Paladin.UpdateRaidBorder(orlanHeal)
	local infusionOfLightSpellName = GetSpellInfo(54149);
	local daybreakSpellName = GetSpellInfo(88819);

	if (UnitPower("player", SPELL_POWER_HOLY_POWER) == 3)
			and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", infusionOfLightSpellName) then -- Infusion of Light
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 1, orlanHeal.RaidBorderAlpha);
	elseif UnitBuff("player", daybreakSpellName) -- Daybreak
			and orlanHeal:IsSpellReady(20473) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 1, orlanHeal.RaidBorderAlpha);
	elseif orlanHeal:IsSpellReady(20473) then -- Holy Shock
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 1, 0, orlanHeal.RaidBorderAlpha);
	elseif (UnitPower("player", SPELL_POWER_HOLY_POWER) == 2)
			and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0.5, 0, orlanHeal.RaidBorderAlpha);
	elseif (UnitPower("player", SPELL_POWER_HOLY_POWER) == 1)
			and orlanHeal:IsSpellReady(85673) then -- Word of Glory
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 1, 0, 0, orlanHeal.RaidBorderAlpha);
	else
		orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
	end;
end;

OrlanHeal.Paladin.PlayerSpecificBuffCount = 1;

function OrlanHeal.Paladin.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 53563) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) or -- своя Частица Света
			(spellId == 1022) or -- Длань защиты
			(spellId == 5599) or -- Длань защиты
			(spellId == 10278) or -- Длань защиты
			(spellId == 1038) then -- Длань спасения
		buffKind = 1;
	end;

	return buffKind;
end;

OrlanHeal.Paladin.PoisonDebuffKind = 1;
OrlanHeal.Paladin.DiseaseDebuffKind = 1;
OrlanHeal.Paladin.MagicDebuffKind = 1;
OrlanHeal.Paladin.CurseDebuffKind = 2;
OrlanHeal.Paladin.PlayerDebuffSlots = { 1, 1, 2, 0, 0 };
OrlanHeal.Paladin.PetDebuffSlots = { 0, 0 };

function OrlanHeal.Paladin.GetSpecificDebuffKind(orlanHeal, spellId)
end;
