OrlanHeal.Shaman = {};

OrlanHeal.Shaman.AvailableSpells =
{
	331, -- Волна исцеления
	974, -- Щит земли
	51886, -- Очищение духа
	8004, -- Исцеляющий всплеск
	546, -- Хождение по воде
	1064, -- Цепное исцеление
	77472, -- Великая волна исцеления
	61295, -- Быстрина
	73680 -- Высвободить чары стихий
};

OrlanHeal.Shaman.CooldownOptions =
{
	WaterShield =
	{
		SpellId = 52127, -- Водный щит
		IsReverse = true,
		Update = OrlanHeal.UpdatePlayerBuffCooldown
	},
	EarthShield =
	{
		SpellId = 974, -- Щит земли
		IsReverse = true,
		Update = OrlanHeal.UpdateRaidBuffCooldown
	},
	NaturesSwiftness =
	{
		SpellId = 16188, -- Природная стремительность
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	ManaTideTotem =
	{
		SpellId = 16190, -- Тотем прилива маны
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	EarthlivingWeapon =
	{
		SpellId = 51730, -- Оружие жизни земли
		IsReverse = true,
		Duration = 30 * 60,
		Update = OrlanHeal.UpdateMainHandTemporaryEnchantCooldown
	},
	Riptide =
	{
		SpellId = 61295,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Bloodlust =
	{
		SpellId = 2825,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	SpiritLinkTotem =
	{
		SpellId = 98008,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	GiftOfTheNaaru =
	{
		SpellId = 59547, -- Gift of the Naaru
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
	UnleashElements =
	{
		SpellId = 73680,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};

function OrlanHeal.Shaman.LoadSetup(orlanHeal)
	orlanHeal.Config["cooldown1"] = orlanHeal.Config["cooldown1"] or "WaterShield";
	orlanHeal.Config["cooldown2"] = orlanHeal.Config["cooldown2"] or "EarthShield";
	orlanHeal.Config["cooldown3"] = orlanHeal.Config["cooldown3"] or "NaturesSwiftness";
	orlanHeal.Config["cooldown4"] = orlanHeal.Config["cooldown4"] or "Berserk";
	orlanHeal.Config["cooldown5"] = orlanHeal.Config["cooldown5"] or "ManaTideTotem";
	orlanHeal.Config["cooldown6"] = orlanHeal.Config["cooldown6"] or "EarthlivingWeapon";
end;

OrlanHeal.Shaman.RedRangeSpellId = 331; -- Волна исцеления
OrlanHeal.Shaman.OrangeRangeSpellId = 331; -- Волна исцеления
OrlanHeal.Shaman.YellowRangeSpellId = 546; -- Хождение по воде

function OrlanHeal.Shaman.UpdateRaidBorder(orlanHeal)
	orlanHeal:SetBorderColor(orlanHeal.RaidWindow, 0, 0, 0, 0);
end;

OrlanHeal.Shaman.PlayerSpecificBuffCount = 2;

function OrlanHeal.Shaman.GetSpecificBuffKind(orlanHeal, spellId, caster)
	local buffKind;
	if (spellId == 974) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- свой Щит земли
		buffKind = 1;
	end;
	if spellId == 61295 then -- Быстрина
		buffKind = 2;
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
