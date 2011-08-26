function OrlanHeal:CreateCooldowns(parent)
	local cooldowns = {};

	cooldowns.Frames = {};
	cooldowns.Frames[0] = self:CreateCooldownFrame(parent);
	cooldowns.Frames[0]:SetPoint(
		"BOTTOMLEFT",
		parent,
		"TOPLEFT",
		self.RaidOuterSpacing,
		self.RaidOuterSpacing);
	cooldowns.Frames[1] = self:CreateCooldownFrame(parent);

	cooldowns[0] = self:CreateCooldown(cooldowns.Frames[0], 0);
	cooldowns[1] = self:CreateCooldown(cooldowns.Frames[0], 1);
	cooldowns[2] = self:CreateCooldown(cooldowns.Frames[0], 2);
	cooldowns[3] = self:CreateCooldown(cooldowns.Frames[0], 3);
	cooldowns[4] = self:CreateCooldown(cooldowns.Frames[0], 4);
	cooldowns[5] = self:CreateCooldown(cooldowns.Frames[1], 0);
	cooldowns[6] = self:CreateCooldown(cooldowns.Frames[1], 1);
	cooldowns[7] = self:CreateCooldown(cooldowns.Frames[1], 2);
	cooldowns[8] = self:CreateCooldown(cooldowns.Frames[1], 3);
	cooldowns[9] = self:CreateCooldown(cooldowns.Frames[1], 4);

	return cooldowns;
end;

function OrlanHeal:CreateCooldownFrame(parent)
	local frame = CreateFrame("Frame", nil, parent);
	frame:SetHeight(self.CooldownSize);
	frame:SetWidth(self.CooldownSize * (5 + 1 / 8 * 4));
	return frame;
end;

function OrlanHeal:CreateCooldown(parent, index)
	local cooldown = CreateFrame("Cooldown", nil, parent, "CooldownFrameTemplate");

	cooldown:ClearAllPoints();
	cooldown:SetPoint("TOPLEFT", index * self.CooldownSize * (1 + 1 / 8), 0);
	cooldown:SetHeight(self.CooldownSize);
	cooldown:SetWidth(self.CooldownSize);

	cooldown.Background = parent:CreateTexture(nil, "BACKGROUND");
	cooldown.Background:SetAllPoints(cooldown);
	cooldown.Background:SetAlpha(0.5);

	local countSize = self.CooldownCountSize;
	cooldown.Count = cooldown:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	cooldown.Count:SetHeight(countSize);
	cooldown.Count:SetWidth(countSize);
	cooldown.Count:SetTextColor(1, 1, 1, 1);
	cooldown.Count:SetShadowColor(0, 0, 0, 1);
	cooldown.Count:SetShadowOffset(-1, -1);
	cooldown.Count:SetTextHeight(countSize);
	cooldown.Count:SetPoint("BOTTOMRIGHT", cooldown, "BOTTOMRIGHT", 0, 0);

	cooldown.Button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");
	cooldown.Button:SetAllPoints(cooldown);
	cooldown.Button:RegisterForClicks("LeftButtonDown");
	cooldown.Button:SetAttribute("type", "spell");

	return cooldown;
end;

function OrlanHeal:SetupCooldown(window, cooldown)
	if cooldown then
		window:Show();
		window.Background:Show();
		window.Button:Show();

		window.IsReverse = cooldown.IsReverse or false;
		window.CastSpellId = cooldown.SpellId;

		local _, _, icon = GetSpellInfo(cooldown.AuraId or cooldown.SpellId);
		window.Background:SetTexture(icon);
		window:SetReverse(window.IsReverse);

		if cooldown.SpellId then
			window.Button:SetAttribute("spell", cooldown.SpellId);
		end;
	else
		window:Hide();
		window.Background:Hide();
		window.Button:Hide();
	end;
end;

function OrlanHeal:GetCooldown(index)
	local name = self.Config["cooldown" .. (index + 1)];
	local cooldown;
	if self.CommonCooldownOptions[name] then
		cooldown = self.CommonCooldownOptions[name];
	elseif self.Class.CooldownOptions and self.Class.CooldownOptions[name] then
		cooldown = self.Class.CooldownOptions[name];
	end;
	return cooldown;
end;

function OrlanHeal:SetupCooldowns()
	for index = 0, 9 do
		self:SetupCooldown(self.RaidWindow.Cooldowns[index], self:GetCooldown(index));
	end;
end;

function OrlanHeal:UpdateCooldowns()
	for index = 0, 9 do
		self:UpdateCooldownWindow(self.RaidWindow.Cooldowns[index], self:GetCooldown(index));
	end;
end;

function OrlanHeal:UpdateCooldownWindow(window, cooldown)
	if cooldown and cooldown.Update then
		cooldown.Update(self, window, cooldown);
	end;
end;

function OrlanHeal:UpdateCooldownFrames()
	self.RaidWindow.Cooldowns.Frames[1]:ClearAllPoints();
	if self.IsInStartUpMode or (self:GetGroupCountWithTanks() > 1) then
		self.RaidWindow.Cooldowns.Frames[1]:SetPoint(
			"BOTTOMLEFT",
			self.RaidWindow,
			"TOPLEFT",
			self.RaidOuterSpacing + 5 * self.CooldownSize * (1 + 1 / 8),
			self.RaidOuterSpacing);
	else
		self.RaidWindow.Cooldowns.Frames[1]:SetPoint(
			"BOTTOMLEFT",
			self.RaidWindow,
			"TOPLEFT",
			self.RaidOuterSpacing,
			self.RaidOuterSpacing + self.CooldownSize * (1 + 1 / 8));
	end;
end;

function OrlanHeal:UpdatePlayerBuffCooldown(window, cooldown)
	local spellName = GetSpellInfo(cooldown.AuraId or cooldown.SpellId);
	local _, _, _, count, _, duration, expirationTime = UnitBuff("player", spellName);
	self:UpdateCooldown(window, duration, expirationTime, count);
end;

function OrlanHeal:UpdateMainHandTemporaryEnchantCooldown(window, cooldown)
	local hasEnchant, timeLeft = GetWeaponEnchantInfo();
	if hasEnchant then
		local expiration = GetTime() + timeLeft / 1000;
		if (window.Off and (expiration > window.Off - 1) and (expiration < window.Off + 1)) then
			expiration = window.Off;
		end;
		self:UpdateCooldown(window, cooldown.Duration, expiration, 1);
	else
		self:UpdateCooldown(window, nil, nil, nil);
	end;
end;

function OrlanHeal:UpdateAbilityCooldown(window, cooldown)
	local start, duration, enabled = GetSpellCooldown(cooldown.SpellId);
	local expirationTime;
	if start and duration and (duration ~= 0) and (enabled == 1) then
		expirationTime = start + duration;
	else
		start = nil;
		duration = nil;
		expirationTime = nil;
	end;
	self:UpdateCooldown(window, duration, expirationTime);
end;

function OrlanHeal:UpdateRaidBuffCooldown(window, cooldown)
	local duration, expirationTime, count = self:GetRaidBuffCooldown(cooldown.AuraId or cooldown.SpellId);
	self:UpdateCooldown(window, duration, expirationTime, count);
end;

function OrlanHeal:GetRaidBuffCooldown(spellId)
	local duration, expirationTime, count = self:GetPlayerCastUnitBuffCooldown("player", spellId);
	if duration then
		return duration, expirationTime, count;
	end;

	duration, expirationTime, count = self:GetPlayerCastUnitBuffCooldown("pet", spellId);
	if duration then
		return duration, expirationTime, count;
	end;

	for i = 1, 4 do
		duration, expirationTime, count = self:GetPlayerCastUnitBuffCooldown("party" .. i, spellId);
		if duration then
			return duration, expirationTime, count;
		end;

		duration, expirationTime, count = self:GetPlayerCastUnitBuffCooldown("partypet" .. i, spellId);
		if duration then
			return duration, expirationTime, count;
		end;
	end;

	for i = 1, 40 do
		duration, expirationTime, count = self:GetPlayerCastUnitBuffCooldown("raid" .. i, spellId);
		if duration then
			return duration, expirationTime, count;
		end;

		duration, expirationTime, count = self:GetPlayerCastUnitBuffCooldown("raidpet" .. i, spellId);
		if duration then
			return duration, expirationTime, count;
		end;
	end;
end;

function OrlanHeal:GetPlayerCastUnitBuffCooldown(unit, spellId)
	local i = 1;
	while true do
		local _, _, _, count, _, duration, expirationTime, _, _, _, buffId = UnitBuff(unit, i, "PLAYER");
		if not buffId then
			return;
		end;

		if buffId == spellId then
			return duration, expirationTime, count;
		end;

		i = i + 1;
	end;
end;

function OrlanHeal:UpdateCooldown(window, duration, expirationTime, count)
	duration = duration or 0;
	expirationTime = expirationTime or 0;
	if expirationTime ~= window.Off then
		window.Off = expirationTime;
		if (duration ~= 0) and (expirationTime ~= 0) then
			window:SetCooldown(expirationTime - duration, duration);
		else
			window:SetCooldown(0, 10);
		end;
	end;

	if FindSpellBookSlotBySpellID(window.CastSpellId) then
		window:SetReverse(window.IsReverse);
	else
		window:SetReverse(true);
	end;

	if count and (count > 1) then
		window.Count:SetText(count);
	else
		window.Count:SetText("");
	end;
end;

OrlanHeal.CommonCooldownOptions =
{
	Berserk =
	{
		SpellId = 26297, -- Берсерк
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Troll";
		end;
	},
	Lifeblood1 =
	{
		SpellId = 81708,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood2 =
	{
		SpellId = 55428,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood3 =
	{
		SpellId = 55480,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood4 =
	{
		SpellId = 55500,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood5 =
	{
		SpellId = 55501,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood6 =
	{
		SpellId = 55502,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood7 =
	{
		SpellId = 55503,
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood8 =
	{
		SpellId = 74497,
		Update = OrlanHeal.UpdateAbilityCooldown
	}
};