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

	self.Class.CreateCooldowns(self, cooldowns);

	return cooldowns;
end;

function OrlanHeal:CreateCooldownFrame(parent)
	local frame = CreateFrame("Frame", nil, parent);
	frame:SetHeight(self.CooldownSize);
	frame:SetWidth(self.CooldownSize * (5 + 1 / 8 * 4));
	return frame;
end;

function OrlanHeal:CreateCooldown(parent, index, imageSpellId, castSpellId, isReverse)
	local cooldown = CreateFrame("Cooldown", nil, parent, "CooldownFrameTemplate");
	cooldown.IsReverse = isReverse;
	cooldown.CastSpellId = castSpellId;

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

	local _, _, icon = GetSpellInfo(imageSpellId);
	cooldown.Background:SetTexture(icon);
	cooldown:SetReverse(isReverse);

	if castSpellId then
		cooldown.Button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");
		cooldown.Button:SetAllPoints(cooldown);
		cooldown.Button:RegisterForClicks("LeftButtonDown");
		cooldown.Button:SetAttribute("type", "spell");
		cooldown.Button:SetAttribute("spell", castSpellId);
	end;

	return cooldown;
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

function OrlanHeal:UpdatePlayerBuffCooldown(cooldown, spellId)
	local spellName = GetSpellInfo(spellId);
	local _, _, _, count, _, duration, expirationTime = UnitBuff("player", spellName);
	self:UpdateCooldown(cooldown, duration, expirationTime, count);
end;

function OrlanHeal:UpdateMainHandTemporaryEnchantCooldown(cooldown, duration)
	local hasEnchant, timeLeft = GetWeaponEnchantInfo();
	if hasEnchant then
		local expiration = GetTime() + timeLeft / 1000;
		if (cooldown.Off and (expiration > cooldown.Off - 1) and (expiration < cooldown.Off + 1)) then
			expiration = cooldown.Off;
		end;
		self:UpdateCooldown(cooldown, duration, expiration, 1);
	else
		self:UpdateCooldown(cooldown, nil, nil, nil);
	end;
end;

function OrlanHeal:UpdateAbilityCooldown(cooldown, spellId)
	local start, duration, enabled = GetSpellCooldown(spellId);
	local expirationTime;
	if start and duration and (duration ~= 0) and (enabled == 1) then
		expirationTime = start + duration;
	else
		start = nil;
		duration = nil;
		expirationTime = nil;
	end;
	self:UpdateCooldown(cooldown, duration, expirationTime);
end;

function OrlanHeal:UpdateRaidBuffCooldown(cooldown, spellId)
	local duration, expirationTime, count = self:GetRaidBuffCooldown(spellId);
	self:UpdateCooldown(cooldown, duration, expirationTime, count);
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

function OrlanHeal:UpdateCooldown(cooldown, duration, expirationTime, count)
	duration = duration or 0;
	expirationTime = expirationTime or 0;
	if expirationTime ~= cooldown.Off then
		cooldown.Off = expirationTime;
		if (duration ~= 0) and (expirationTime ~= 0) then
			cooldown:SetCooldown(expirationTime - duration, duration);
		else
			cooldown:SetCooldown(0, 10);
		end;
	end;

	if FindSpellBookSlotBySpellID(cooldown.CastSpellId) then
		cooldown:SetReverse(cooldown.IsReverse);
	else
		cooldown:SetReverse(true);
	end;

	if count and (count > 1) then
		cooldown.Count:SetText(count);
	else
		cooldown.Count:SetText("");
	end;
end;

