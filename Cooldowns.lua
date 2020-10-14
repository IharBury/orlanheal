function OrlanHeal:CreateCooldowns(parent)
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

	cooldown.Button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");
	cooldown.Button:SetAllPoints(cooldown);
	cooldown.Button:RegisterForClicks("LeftButtonDown");
	cooldown.Button:SetAttribute("type", "spell");

	local countSize = self.CooldownCountSize;
	cooldown.Count = cooldown.Button:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	cooldown.Count:SetHeight(countSize);
	cooldown.Count:SetTextColor(1, 1, 1, 1);
	cooldown.Count:SetShadowColor(0, 0, 0, 1);
	cooldown.Count:SetShadowOffset(-1, -1);
	cooldown.Count:SetTextHeight(countSize);
	cooldown.Count:SetPoint("BOTTOMRIGHT", cooldown, "BOTTOMRIGHT", -2, 0);
	cooldown.Count:SetPoint("BOTTOMLEFT", cooldown, "BOTTOMLEFT", 2, 0);
	cooldown.Count:SetJustifyH("RIGHT");

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
			texture = GetSpellTexture(effectId);
		elseif cooldown.SlotName then
			local slotId;
			slotId, texture = GetInventorySlotInfo(cooldown.SlotName);
			texture = GetInventoryItemTexture("player", slotId) or texture;
		end;
		window.Background:SetTexture(texture);
		window:SetReverse(cooldown.IsReverse);
		window.Off = nil;
		window.Dark = nil;

		if cooldown.MacroText then
			window.Button:SetAttribute("type", "macro");
			window.Button:SetAttribute("macrotext", cooldown.MacroText);
		elseif cooldown.SpellId then
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
		window.Cooldown = nil;
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
	if spellName then
		local _, _, _, count, _, duration, expirationTime = UnitBuff("player", spellName);
		self:UpdateCooldown(window, duration, expirationTime, count, window.Cooldown.AlwaysShowCount);
	end;
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
	if not IsSpellKnown(window.Cooldown.SpellId) then
		self:UpdateCooldown(window);
		return;
	end;

	local spellName = GetSpellInfo(window.Cooldown.SpellId);
	local start, duration, enabled = GetSpellCooldown(spellName);
	local currentCharges, maxCharges = GetSpellCharges(spellName);
	local displayedCharges;
	if (maxCharges and (maxCharges > 1)) then
		displayedCharges = currentCharges;
	end;
	local expirationTime;
	if start and (start ~= 0) and duration and (duration ~= 0) and (enabled == 1) then
		expirationTime = start + duration;
	else
		start = nil;
		duration = nil;
		expirationTime = nil;
	end;
	self:UpdateCooldown(window, duration, expirationTime, displayedCharges, displayedCharges);
end;

function OrlanHeal:UpdateAbilitySequenceCooldown(window)
	local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
	local expirationTime;
	if start and (start ~= 0) and duration and (duration ~= 0) and (enabled == 1) then
		expirationTime = start + duration;
	else
		start = nil;
		duration = nil;
		expirationTime = nil;
	end;

	local prefixStart, prefixDuration, prefixEnabled = GetSpellCooldown(window.Cooldown.PrefixSpellId);
	local prefixExpirationTime;
	if prefixStart and (prefixStart ~= 0) and prefixDuration and (prefixDuration ~= 0) and (prefixEnabled == 1) then
		prefixExpirationTime = prefixStart + prefixDuration;
	else
		prefixStart = nil;
		prefixDuration = nil;
		prefixExpirationTime = nil;
	end;

	if prefixExpirationTime and ((not expirationTime) or (expirationTime < prefixExpirationTime)) then
		start = prefixStart;
		duration = prefixDuration;
		expirationTime = prefixExpirationTime;
	end;

	self:UpdateCooldown(window, duration, expirationTime, window.Cooldown.Sign, true);
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
	self:UpdateCooldown(window, duration, expirationTime, nil, nil, nil, enabled == 0);

	if not window.LastTextureUpdate or (window.LastTextureUpdate < time() - 5) then
		local slotId, texture = GetInventorySlotInfo(window.Cooldown.SlotName);
		texture = GetInventoryItemTexture("player", slotId) or texture;
		window.Background:SetTexture(texture);
		window.LastTextureUpdate = time();
	end;
end;

function OrlanHeal:UpdateRaidBuffCooldown(window)
	local duration, expirationTime, count = self:GetRaidBuffCooldown(window.Cooldown.AuraId or window.Cooldown.SpellId);
	self:UpdateCooldown(window, duration, expirationTime, count);
end;

function OrlanHeal:UpdateRaidBuffAbilityCooldown(window)
	local _, _, count = self:GetRaidBuffCooldown(window.Cooldown.AuraId or window.Cooldown.SpellId);
	local start, duration, enabled = GetSpellCooldown(window.Cooldown.SpellId);
	local expirationTime;
	if start and (start ~= 0) and duration and (duration ~= 0) and (enabled == 1) then
		expirationTime = start + duration;
	else
		start = nil;
		duration = nil;
		expirationTime = nil;
	end;
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

function OrlanHeal:GetRacialCooldown()
	local _, race = UnitRace("player");
	local cooldown;
	if race == "Human" then
		cooldown = "EveryManForHimself";
	elseif race == "Dwarf" then
		cooldown = "Stoneform";
	elseif race == "NightElf" then
		cooldown = "Shadowmeld";
	elseif race == "Gnome" then
		cooldown = "EscapeArtist";
	elseif race == "Draenei" then
		cooldown = "GiftOfTheNaaru";
	elseif race == "Worgen" then
		cooldown = "Darkflight";
	elseif race == "Orc" then
		cooldown = "BloodFury";
	elseif (race == "Undead") or (race == "Scourge") then
		cooldown = "WillOfTheForsaken";
	elseif race == "Tauren" then
		cooldown = "WarStomp";
	elseif race == "Troll" then
		cooldown = "Berserk";
	elseif race == "BloodElf" then
		cooldown = "ArcaneTorrent";
	elseif race == "Goblin" then
		cooldown = "RocketJump";
	elseif race == "Pandaren" then
		cooldown = "QuakingPalm";
	end;
	return cooldown;
end;

function OrlanHeal:UpdateCooldown(window, duration, expirationTime, count, alwaysDisplayCount, isReverse, isOff)
--	if not window:CanChangeProtectedState() then
--		return;
--	end;

	if isReverse == nil then
		isReverse = window.Cooldown.IsReverse;
	end;
	duration = duration or 0;
	expirationTime = expirationTime or 0;

	local isPotentiallyUsableSpell = window.Cooldown.SpellId and
		IsSpellKnown(window.Cooldown.SpellId) and 
		((duration ~= 0) or 
			window.Cooldown.IsReverse or 
			IsUsableSpell(window.Cooldown.SpellId));
	local isUsableItem = window.Cooldown.SlotName and 
		GetInventoryItemID("player", GetInventorySlotInfo(window.Cooldown.SlotName));
	if (not isOff) and (isPotentiallyUsableSpell or isUsableItem or window.Cooldown.MacroText) then
		window.Dark = false;
		window:SetReverse(isReverse);
		window:SetHideCountdownNumbers(false);

		if expirationTime ~= window.Off then
			window.Off = expirationTime;
			if (duration ~= 0) and (expirationTime ~= 0) then
				window:SetCooldown(expirationTime - duration, duration);
			else
				window:SetCooldown(GetTime() - 1, 1);
			end;
		end;
	else
		window:SetReverse(false);
		if not window.Dark 
				or not window:GetCooldownDuration()
				or window:GetCooldownDuration() == 0 then
			local time = GetTime();
			window.Off = time + 10000000;
			window:SetCooldown(time, 10000000);
			window:SetHideCountdownNumbers(true);
			window.Dark = true;
		end;
	end;

	if count and (((type(count) == "number") and (count > 1)) or alwaysDisplayCount) then
		window.Count:SetText(count);
	else
		window.Count:SetText("");
	end;
end;

OrlanHeal.CommonCooldownOptions =
{
	Back =
	{
		SlotName = "BackSlot",
		SlotCaption = BACKSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Chest =
	{
		SlotName = "ChestSlot",
		SlotCaption = CHESTSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Feet =
	{
		SlotName = "FeetSlot",
		SlotCaption = FEETSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Finger0 =
	{
		SlotName = "Finger0Slot",
		SlotCaption = FINGER0SLOT .. " (1)",
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Finger1 =
	{
		SlotName = "Finger1Slot",
		SlotCaption = FINGER1SLOT .. " (2)",
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Hands =
	{
		SlotName = "HandsSlot",
		SlotCaption = HANDSSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Head = 
	{
		SlotName = "HeadSlot",
		SlotCaption = HEADSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Legs =
	{
		SlotName = "LegsSlot",
		SlotCaption = LEGSSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	MainHand =
	{
		SlotName = "MainHandSlot",
		SlotCaption = MAINHANDSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Neck =
	{
		SlotName = "NeckSlot",
		SlotCaption = NECKSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	SecondaryHand =
	{
		SlotName = "SecondaryHandSlot",
		SlotCaption = SECONDARYHANDSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Shirt =
	{
		SlotName = "ShirtSlot",
		SlotCaption = SHIRTSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Shoulder =
	{
		SlotName = "ShoulderSlot",
		SlotCaption = SHOULDERSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Tabard =
	{
		SlotName = "TabardSlot",
		SlotCaption = TABARDSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Trinket0 =
	{
		SlotName = "Trinket0Slot",
		SlotCaption = TRINKET0SLOT .. " (1)",
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Trinket1 =
	{
		SlotName = "Trinket1Slot",
		SlotCaption = TRINKET1SLOT .. " (2)",
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Waist =
	{
		SlotName = "WaistSlot",
		SlotCaption = WAISTSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Wrist =
	{
		SlotName = "WristSlot",
		SlotCaption = WRISTSLOT,
		Update = OrlanHeal.UpdateItemCooldown,
		Group = "Use"
	},
	Darkflight =
	{
		SpellId = 68992, -- Darkflight
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Worgen";
		end
	},
	EscapeArtist =
	{
		SpellId = 20589, -- Escape Artist
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Gnome";
		end
	},
	Stoneform =
	{
		SpellId = 20594, -- Stoneform
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Dwarf";
		end
	},
	Shadowmeld =
	{
		SpellId = 58984, -- Shadowmeld
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "NightElf";
		end
	},
	EveryManForHimself =
	{
		SpellId = 59752, -- Every Man for Himself
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Human";
		end
	},
	RocketJump =
	{
		SpellId = 69070, -- Rocket Jump
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Goblin";
		end
	},
	RocketBarrage =
	{
		SpellId = 69041,
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Goblin";
		end
	},
	PackHobgoblin =
	{
		SpellId = 69046,
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Goblin";
		end
	},
	WillOfTheForsaken =
	{
		SpellId = 7744, -- Will of the Forsaken
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return (race == "Undead") or (race == "Scourge");
		end
	},
	WarStomp =
	{
		SpellId = 20549, -- War Stomp
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Tauren";
		end
	},
	Berserk =
	{
		SpellId = 26297, -- Берсерк
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Troll";
		end
	},
	QuakingPalm =
	{
		SpellId = 107079,
		Update = OrlanHeal.UpdateAbilityCooldown,
		IsAvailable = function()
			local _, race = UnitRace("player");
			return race == "Pandaren";
		end
	},
	SpiritOfPreservation =
	{
		SpellId = 297375,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Azerite Essence"
	},
	ConcentratedFlame =
	{
		SpellId = 299353,
		Update = OrlanHeal.UpdateAbilityCooldown,
		Group = "Azerite Essence"
	}
};