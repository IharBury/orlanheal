OrlanHeal.Shaman = {};

OrlanHeal.Shaman.AvailableSpells =
{
	331, -- Волна исцеления
	974, -- Щит земли
	51886, -- Очищение духа
	8004, -- Исцеляющий всплеск
	546, -- Хождение по воде
	1064 -- Цепное исцеление
}

function OrlanHeal.Shaman.CreateCooldowns(orlanHeal, cooldowns)
	cooldowns[0] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 0, 52127, 52127, true); -- Водный щит
	cooldowns[1] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 1, 974, 974, true); -- Щит земли
	cooldowns[2] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 2, 16188, 16188, false); -- Природная стремительность
	cooldowns[3] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 3, 26297, 26297, false); -- Берсерк
	cooldowns[4] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 4, 16190, 16190, false); -- Тотем прилива маны
	cooldowns[5] = orlanHeal:CreateCooldown(cooldowns.Frames[1], 0, 51730, 51730, true); -- Оружие жизни земли
end;

function OrlanHeal.Shaman.UpdateCooldowns(orlanHeal)
	orlanHeal:UpdatePlayerBuffCooldown(orlanHeal.RaidWindow.Cooldowns[0], 52127); -- Водный щит
	orlanHeal:UpdateRaidBuffCooldown(orlanHeal.RaidWindow.Cooldowns[1], 974); -- Щит земли
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[2], 16188); -- Природная стремительность
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[3], 26297); -- Берсерк
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[4], 16190); -- Тотем прилива маны
	orlanHeal:UpdateMainHandTemporaryEnchantCooldown(orlanHeal.RaidWindow.Cooldowns[5], 30 * 60); -- Оружие жизни земли
end;

OrlanHeal.Shaman.RedRangeSpellId = 331; -- Волна исцеления
OrlanHeal.Shaman.OrangeRangeSpellId = 331; -- Волна исцеления
OrlanHeal.Shaman.YellowRangeSpellId = 546; -- Хождение по воде


function OrlanHeal.Shaman.UpdateRaidBorder(orlanHeal)
	orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
end;

OrlanHeal.Shaman.PlayerSpecificBuffCount = 1;

function OrlanHeal.Shaman.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 974) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- свой Щит земли
		buffKind = 1;
	end;
	return buffKind;
end;

OrlanHeal.Shaman.PoisonDebuffKind = 4;
OrlanHeal.Shaman.DiseaseDebuffKind = 4;
OrlanHeal.Shaman.MagicDebuffKind = 2;
OrlanHeal.Shaman.CurseDebuffKind = 1;
OrlanHeal.Shaman.PlayerDebuffSlots = { 1, 2, 0, 0, 0 };
OrlanHeal.Shaman.PetDebuffSlots = { 0, 0 };

function OrlanHeal.Shaman.GetSpecificDebuffKind(orlanHeal, spellId)
	local debuffKind;
	return debuffKind;
end;
