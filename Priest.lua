OrlanHeal.Priest = {};

OrlanHeal.Priest.AvailableSpells =
{
	1706, -- Левитация
	527, -- Рассеивание заклинаний
	17, -- Слово силы: Щит
	6346, -- Защита от страха
	2061, -- Быстрое исцеление
	2060, -- Великое исцеление
	2006, -- Воскрешение
	528, -- Излечение болезни
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
}

function OrlanHeal.Priest.CreateCooldowns(orlanHeal, cooldowns)
	cooldowns[0] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 0, 89485, 89485, false); -- Внутреннее сосредоточение
	cooldowns[1] = orlanHeal:CreateCooldown(cooldowns.Frames[0], 1, 17, 17, false); -- Слово силы: Щит
end;

function OrlanHeal.Priest.UpdateCooldowns(orlanHeal)
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[0], 89485); -- Внутреннее сосредоточение
	orlanHeal:UpdateAbilityCooldown(orlanHeal.RaidWindow.Cooldowns[1], 17); -- Слово силы: Щит
end;

OrlanHeal.Priest.RedRangeSpellId = 2096; -- Внутреннее зрение
OrlanHeal.Priest.OrangeRangeSpellId = 1706; -- Левитация
OrlanHeal.Priest.YellowRangeSpellId = 2061; -- Быстрое исцеление


function OrlanHeal.Priest.UpdateRaidBorder(orlanHeal)
	orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
end;

OrlanHeal.Priest.PlayerSpecificBuffCount = 2;

function OrlanHeal.Priest.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 17) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- свой щит
		buffKind = 1;
	elseif (spellId == 139) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- своё восстановление
		buffKind = 2;
	end;

	return buffKind;
end;

OrlanHeal.Priest.PoisonDebuffKind = 4;
OrlanHeal.Priest.DiseaseDebuffKind = 2;
OrlanHeal.Priest.MagicDebuffKind = 3;
OrlanHeal.Priest.CurseDebuffKind = 4;
OrlanHeal.Priest.PlayerDebuffSlots = { 1, 2, 3, 4, 0 };
OrlanHeal.Priest.PetDebuffSlots = { 0, 0 };

function OrlanHeal.Priest.GetSpecificDebuffKind(orlanHeal, spellId)
	local debuffKind;
	if spellId == 6788 then -- Ослабленная душа
		debuffKind = 1;
	end;

	return debuffKind;
end;
