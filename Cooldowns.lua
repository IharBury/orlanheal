﻿function OrlanHeal:CreateCooldowns(parent)
	local cooldowns = {};

	cooldowns.Frames = {};
	for frameIndex = 0, math.ceil(self.MaxCooldownCount / self.CooldownCountPerFrame) do
		cooldowns.Frames[frameIndex] = self:CreateCooldownFrame(parent);
	end;
	cooldowns.Frames[1] = self:CreateCooldownFrame(parent);

	for cooldownIndex = 0, self.MaxCooldownCount - 1 do
		cooldowns[cooldownIndex] = self:CreateCooldown(
			cooldowns.Frames[math.floor(cooldownIndex / self.CooldownCountPerFrame)], 
			cooldownIndex % self.CooldownCountPerFrame);
	end;

	return cooldowns;
end;

function OrlanHeal:CreateCooldownFrame(parent)
	local frame = CreateFrame("Frame", nil, parent);
	frame:SetHeight(self.CooldownSize);
	frame:SetWidth(self.CooldownSize * (1 + (1 + 1 / 8) * (self.CooldownCountPerFrame - 1)));
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

		window.Cooldown = cooldown;

		local effectId = cooldown.AuraId or cooldown.SpellId;
		local texture;
		if effectId then
			_, _, texture = GetSpellInfo(effectId);
		elseif cooldown.SlotName then
			local slotId;
			slotId, texture = GetInventorySlotInfo(cooldown.SlotName);
			texture = GetInventoryItemTexture("player", slotId) or texture;
		end;
		window.Background:SetTexture(texture);
		window:SetReverse(cooldown.IsReverse);

		if cooldown.SpellId then
			window.Button:SetAttribute("type", "spell");
			window.Button:SetAttribute("spell", cooldown.SpellId);
		elseif cooldown.SlotName then
			window.Button:SetAttribute("type", "item");
			window.Button:SetAttribute("item", GetInventorySlotInfo(cooldown.SlotName));
		else
			window.Button:SetAttribute("type", "spell");
			window.Button:SetAttribute("spell", nil);
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
	for index = 0, self.MaxCooldownCount - 1 do
		self:SetupCooldown(self.RaidWindow.Cooldowns[index], self:GetCooldown(index));
	end;
end;

function OrlanHeal:UpdateCooldowns()
	for index = 0, self.MaxCooldownCount - 1 do
		self:UpdateCooldownWindow(self.RaidWindow.Cooldowns[index]);
	end;
end;

function OrlanHeal:UpdateCooldownWindow(window)
	if window.Cooldown and window.Cooldown.Update then
		window.Cooldown.Update(self, window);
	end;
end;

function OrlanHeal:UpdateCooldownFrames()
	for frameIndex = 0, math.ceil(self.MaxCooldownCount / self.CooldownCountPerFrame) do
		local frame = self.RaidWindow.Cooldowns.Frames[frameIndex];
		frame:ClearAllPoints();
		if self.IsInStartUpMode or (self:GetGroupCountWithTanks() > 1) then
			if frameIndex % 2 == 0 then
				frame:SetPoint(
					"BOTTOMLEFT",
					self.RaidWindow,
					"TOPLEFT",
					self.RaidOuterSpacing,
					self.RaidOuterSpacing + self.CooldownSize * (1 + 1 / 8) * frameIndex / 2);
			else
				frame:SetPoint(
					"BOTTOMLEFT",
					self.RaidWindow,
					"TOPLEFT",
					self.RaidOuterSpacing + self.CooldownCountPerFrame * self.CooldownSize * (1 + 1 / 8),
					self.RaidOuterSpacing + self.CooldownSize * (1 + 1 / 8) * (frameIndex - 1) / 2);
			end;
		else
			frame:SetPoint(
				"BOTTOMLEFT",
				self.RaidWindow,
				"TOPLEFT",
				self.RaidOuterSpacing,
				self.RaidOuterSpacing + self.CooldownSize * (1 + 1 / 8) * frameIndex);
		end;
	end;
end;

function OrlanHeal:UpdatePlayerBuffCooldown(window)
	local spellName = GetSpellInfo(window.Cooldown.AuraId or window.Cooldown.SpellId);
	local _, _, _, count, _, duration, expirationTime = UnitBuff("player", spellName);
	self:UpdateCooldown(window, duration, expirationTime, count);
end;

function OrlanHeal:UpdateMainHandTemporaryEnchantCooldown(window)
	local hasEnchant, timeLeft = GetWeaponEnchantInfo();
	if hasEnchant then
		local expiration = GetTime() + timeLeft / 1000;
		if (window.Off and (expiration > window.Off - 1) and (expiration < window.Off + 1)) then
			expiration = window.Off;
		end;
		self:UpdateCooldown(window, window.Cooldown.Duration, expiration, 1);
	else
		self:UpdateCooldown(window, nil, nil, nil);
	end;
end;

function OrlanHeal:UpdateAbilityCooldown(window)
	local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
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

function OrlanHeal:UpdateItemCooldown(window)
	local start, duration, enabled = GetInventoryItemCooldown("player", GetInventorySlotInfo(window.Cooldown.SlotName));
	local expirationTime;
	if start and duration and (duration ~= 0) and (enabled == 1) then
		expirationTime = start + duration;
	else
		start = nil;
		duration = nil;
		expirationTime = nil;
	end;
	self:UpdateCooldown(window, duration, expirationTime);

	if not window.LastTextureUpdate or (window.LastTextureUpdate < time() - 5) then
		local slotId;
		slotId, texture = GetInventorySlotInfo(window.Cooldown.SlotName);
		texture = GetInventoryItemTexture("player", slotId) or texture;
		window.Background:SetTexture(texture);
		window.LastTextureUpdate = time();
	end;
end;

function OrlanHeal:UpdateRaidBuffCooldown(window)
	local duration, expirationTime, count = self:GetRaidBuffCooldown(window.Cooldown.AuraId or window.Cooldown.SpellId);
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

	if (window.Cooldown.SpellId and FindSpellBookSlotBySpellID(window.Cooldown.SpellId)) or
			(window.Cooldown.SlotName and GetInventoryItemID("player", GetInventorySlotInfo(window.Cooldown.SlotName))) then
		window:SetReverse(window.Cooldown.IsReverse);
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
		SpellId = 81708, -- Lifeblood (Rank 1)
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood2 =
	{
		SpellId = 55428, -- Lifeblood (Rank 2)
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood3 =
	{
		SpellId = 55480, -- Lifeblood (Rank 3)
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood4 =
	{
		SpellId = 55500, -- Lifeblood (Rank 4)
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood5 =
	{
		SpellId = 55501, -- Lifeblood (Rank 5)
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood6 =
	{
		SpellId = 55502, -- Lifeblood (Rank 6)
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood7 =
	{
		SpellId = 55503, -- Lifeblood (Rank 7)
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Lifeblood8 =
	{
		SpellId = 74497, -- Lifeblood (Rank 8)
		Update = OrlanHeal.UpdateAbilityCooldown
	},
	Back =
	{
		SlotName = "BackSlot",
		SlotCaption = BACKSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Chest =
	{
		SlotName = "ChestSlot",
		SlotCaption = CHESTSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Feet =
	{
		SlotName = "FeetSlot",
		SlotCaption = FEETSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Finger0 =
	{
		SlotName = "Finger0Slot",
		SlotCaption = FINGER0SLOT .. " (1)",
		Update = OrlanHeal.UpdateItemCooldown
	},
	Finger1 =
	{
		SlotName = "Finger1Slot",
		SlotCaption = FINGER1SLOT .. " (2)",
		Update = OrlanHeal.UpdateItemCooldown
	},
	Hands =
	{
		SlotName = "HandsSlot",
		SlotCaption = HANDSSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Head = 
	{
		SlotName = "HeadSlot",
		SlotCaption = HEADSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Legs =
	{
		SlotName = "LegsSlot",
		SlotCaption = LEGSSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	MainHand =
	{
		SlotName = "MainHandSlot",
		SlotCaption = MAINHANDSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Neck =
	{
		SlotName = "NeckSlot",
		SlotCaption = NECKSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Ranged =
	{
		SlotName = "RangedSlot",
		SlotCaption = (UnitHasRelicSlot("player") and RELICSLOT) or RANGEDSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	SecondaryHand =
	{
		SlotName = "SecondaryHandSlot",
		SlotCaption = SECONDARYHANDSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Shirt =
	{
		SlotName = "ShirtSlot",
		SlotCaption = SHIRTSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Shoulder =
	{
		SlotName = "ShoulderSlot",
		SlotCaption = SHOULDERSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Tabard =
	{
		SlotName = "TabardSlot",
		SlotCaption = TABARDSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Trinket0 =
	{
		SlotName = "Trinket0Slot",
		SlotCaption = TRINKET0SLOT .. " (1)",
		Update = OrlanHeal.UpdateItemCooldown
	},
	Trinket1 =
	{
		SlotName = "Trinket1Slot",
		SlotCaption = TRINKET1SLOT .. " (2)",
		Update = OrlanHeal.UpdateItemCooldown
	},
	Waist =
	{
		SlotName = "WaistSlot",
		SlotCaption = WAISTSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	},
	Wrist =
	{
		SlotName = "WristSlot",
		SlotCaption = WRISTSLOT,
		Update = OrlanHeal.UpdateItemCooldown
	}
};