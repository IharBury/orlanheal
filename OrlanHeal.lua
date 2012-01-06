OrlanHeal = {};

function OrlanHeal:UpdateSpells()
	for groupIndex = 0, self.MaxGroupCount - 1 do
		for playerIndex = 0, 4 do
			self:SetupSpells(self.RaidWindow.Groups[groupIndex].Players[playerIndex].Button);
			self:SetupSpells(self.RaidWindow.Groups[groupIndex].Players[playerIndex].Pet.Button);
		end;
	end;
end;

function OrlanHeal:CreateRaidWindow()
	local orlanHeal = self;
	local raidWindow = CreateFrame("Frame", self.RaidWindowName, UIParent);
	raidWindow:SetScale(self.Config.Size * self.Scale);

	function raidWindow:HandleDragStop()
		self:StopMovingOrSizing();
	end;

	local background = raidWindow:CreateTexture();
	background:SetPoint("TOPLEFT", 3, -3);
	background:SetPoint("BOTTOMRIGHT", -3, 3);
	background:SetTexture(0, 0, 0, self.RaidAlpha);

	raidWindow:SetPoint("CENTER", 0, 0);
	raidWindow:SetFrameStrata(self.RaidWindowStrata);
	raidWindow:SetHeight(self.RaidHeight);
	raidWindow:SetWidth(self.RaidWidth);
	raidWindow:EnableMouse(true);
	raidWindow:EnableKeyboard(true);
	raidWindow:SetMovable(true);
	raidWindow:RegisterForDrag("LeftButton");
	raidWindow:SetScript("OnDragStart", raidWindow.StartMoving);
	raidWindow:SetScript("OnDragStop", raidWindow.HandleDragStop);
	raidWindow:SetUserPlaced(true);

	raidWindow.Groups = {};

	for groupIndex = 0, self.MaxGroupCount - 1, 2 do
		raidWindow.Groups[groupIndex] = self:CreateGroupWindow(raidWindow, false);
		raidWindow.Groups[groupIndex]:SetPoint(
			"TOPLEFT", 
			self.RaidOuterSpacing, 
			-self.RaidOuterSpacing - (self.GroupHeight + self.GroupInnerSpacing) * groupIndex / 2);
	end;
	for groupIndex = 1, self.MaxGroupCount - 1, 2 do
		raidWindow.Groups[groupIndex] = self:CreateGroupWindow(raidWindow, true);
		raidWindow.Groups[groupIndex]:SetPoint(
			"TOPLEFT", 
			self.RaidOuterSpacing + self.GroupWidth + self.GroupInnerSpacing, 
			-self.RaidOuterSpacing - (self.GroupHeight + self.GroupInnerSpacing) * (groupIndex - 1) / 2);
	end;

	self:CreateBorder(raidWindow, 3, 0);

	raidWindow.Cooldowns = self:CreateCooldowns(raidWindow);

	raidWindow.GroupCountSwitches = {};
	raidWindow.VisibleGroupCountSwitches = {};
	local index = 0;
	for size = 5, 40, 5 do
		raidWindow.GroupCountSwitches[size] = self:CreateGroupCountSwitch(raidWindow, size, index);
		raidWindow.VisibleGroupCountSwitches[size] = self:CreateVisibleGroupCountSwitch(raidWindow, size, index);
		index = index + 1;
	end;

	raidWindow.TankSwitch = self:CreateTankSwitch(raidWindow);
	raidWindow.NameBindingSwitch = self:CreateNameBindingSwitch(raidWindow);
	raidWindow.SetupButton = self:CreateSetupButton(raidWindow);

	return raidWindow;
end;

function OrlanHeal:CreateBorder(window, thickness, offset)
	window.TopBorder = window:CreateTexture();
	window.TopBorder:SetPoint("TOPLEFT", -offset, offset);
	window.TopBorder:SetPoint("TOPRIGHT", offset, offset);
	window.TopBorder:SetHeight(thickness);

	window.BottomBorder = window:CreateTexture();
	window.BottomBorder:SetPoint("BOTTOMLEFT", -offset, -offset);
	window.BottomBorder:SetPoint("BOTTOMRIGHT", offset, -offset);
	window.BottomBorder:SetHeight(thickness);

	window.LeftBorder = window:CreateTexture();
	window.LeftBorder:SetPoint("TOPLEFT", -offset, offset - thickness);
	window.LeftBorder:SetPoint("BOTTOMLEFT", -offset, -offset + thickness);
	window.LeftBorder:SetWidth(thickness);

	window.RightBorder = window:CreateTexture();
	window.RightBorder:SetPoint("TOPRIGHT", offset, offset - thickness);
	window.RightBorder:SetPoint("BOTTOMRIGHT", offset, -offset + thickness);
	window.RightBorder:SetWidth(thickness);
end;

function OrlanHeal:SetBorderColor(window, r, g, b, a)
	window.TopBorder:SetTexture(r, g, b, a);
	window.BottomBorder:SetTexture(r, g, b, a);
	window.LeftBorder:SetTexture(r, g, b, a);
	window.RightBorder:SetTexture(r, g, b, a);
end;

function OrlanHeal:CreateGroupWindow(parent, isOnTheRight)
	local groupWindow = CreateFrame("Frame", nil, parent);

	local background = groupWindow:CreateTexture();
	background:SetAllPoints();
	background:SetTexture(0, 0, 0, self.GroupAlpha);

	groupWindow:SetHeight(self.GroupHeight);
	groupWindow:SetWidth(self.GroupWidth);
	groupWindow:EnableKeyboard(true);

	groupWindow.Players = {};
	for playerIndex = 0, 4 do
		groupWindow.Players[playerIndex] = self:CreatePlayerWindow(groupWindow, isOnTheRight);
		if isOnTheRight then
			groupWindow.Players[playerIndex]:SetPoint(
				"TOPLEFT", 
				self.GroupOuterSpacing, 
				-self.GroupOuterSpacing - (self.PlayerHeight + self.PlayerInnerSpacing) * playerIndex);
		else
			groupWindow.Players[playerIndex]:SetPoint(
				"TOPLEFT", 
				self.GroupOuterSpacing + self.PetWidth + self.PetSpacing, 
				-self.GroupOuterSpacing - (self.PlayerHeight + self.PlayerInnerSpacing) * playerIndex);
		end;
	end;

	return groupWindow;
end;

function OrlanHeal:CreatePlayerWindow(parent, isOnTheRight)
	local playerWindow = CreateFrame("Frame", nil, parent);

	playerWindow:SetHeight(self.PlayerHeight);
	playerWindow:SetWidth(self.PlayerWidth);

	self:CreateUnitButton(playerWindow);
	self:CreateBlankCanvas(playerWindow);
	self:CreateRangeBar(playerWindow.Canvas);
	self:CreateHealthBar(playerWindow.Canvas, self.PlayerStatusWidth);
	self:CreateManaBar(playerWindow.Canvas, self.PlayerStatusWidth);
	self:CreateNameBar(playerWindow.Canvas, self.PlayerStatusWidth);
	self:CreateBuffs(
		playerWindow.Canvas, 
		self.Class.PlayerSpecificBuffCount, 
		self.PlayerBuffCount - self.Class.PlayerSpecificBuffCount,
		self.Class.PlayerDebuffSlots);
	self:CreateBorder(playerWindow.Canvas, 1, 1);
	self:CreateRoleIcon(playerWindow.Canvas);
	self:CreateTargetIcon(playerWindow.Canvas, self.PlayerStatusWidth);

	playerWindow.Pet = self:CreatePetWindow(playerWindow);
	if isOnTheRight then
		playerWindow.Pet:SetPoint(
			"TOPRIGHT",
			self.PetWidth + self.PetSpacing,
			0);
	else
		playerWindow.Pet:SetPoint(
			"TOPLEFT",
			-self.PetWidth - self.PetSpacing,
			0);
	end;

	return playerWindow;
end;

function OrlanHeal:CreateRoleIcon(canvas)
	canvas.Role = canvas:CreateTexture(nil, "OVERLAY");
	canvas.Role:SetHeight(self.NameHeight);
	canvas.Role:SetWidth(self.NameHeight);
	canvas.Role:SetPoint("TOPLEFT", self.RangeWidth + self.PlayerStatusWidth - self.NameHeight * 2, 0);
end;

function OrlanHeal:CreateTargetIcon(canvas, statusWidth)
	canvas.Target = canvas:CreateTexture(nil, "OVERLAY");
	canvas.Target:SetHeight(self.NameHeight);
	canvas.Target:SetWidth(self.NameHeight);
	canvas.Target:SetPoint("TOPLEFT", self.RangeWidth + statusWidth - self.NameHeight, 0);
end;

function OrlanHeal:CreateBuffs(parent, specificBuffCount, otherBuffCount, debuffSlots)
	if specificBuffCount > 0 then
		parent.SpecificBuffs = {};

		for buffIndex = 0, specificBuffCount - 1 do
			parent.SpecificBuffs[buffIndex] = self:CreateBuff(
				parent, 
				"TOPRIGHT", 
				-(otherBuffCount + specificBuffCount - buffIndex) * self.BuffSize,
				0);
		end;
	end;

	parent.OtherBuffs = {};

	for buffIndex = 0, otherBuffCount - 1 do
		parent.OtherBuffs[buffIndex] = self:CreateBuff(
			parent,
			"TOPRIGHT", 
			-(otherBuffCount - buffIndex) * self.BuffSize,
			0);
	end;

	local debuffIndex = 0;
	parent.Debuffs = {};
	parent.Debuffs.Slots = debuffSlots;
	while debuffSlots[debuffIndex + 1] do
		parent.Debuffs[debuffIndex] = self:CreateBuff(
			parent,
			"BOTTOMRIGHT", 
			-(otherBuffCount + specificBuffCount - debuffIndex) * self.BuffSize,
			self.BuffSize);

		debuffIndex = debuffIndex + 1;
	end;
end;

function OrlanHeal:CreateBuff(parent, point, x, y)
	local buff = {};

	buff.Image = parent:CreateTexture(nil, "BORDER");
	buff.Image:SetHeight(self.BuffSize);
	buff.Image:SetWidth(self.BuffSize);
	buff.Image:SetPoint("TOPLEFT", parent, point, x, y);

	buff.Time = parent:CreateTexture(nil, "OVERLAY");
	buff.Time:SetHeight(self.BuffSize);
	buff.Time:SetWidth(self.BuffSize);
	buff.Time:SetPoint("TOPLEFT", parent, point, x, y);

	local buffCountSize = self.BuffSize;
	buff.Count = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	buff.Count:SetHeight(buffCountSize);
	buff.Count:SetWidth(buffCountSize);
	buff.Count:SetTextColor(1, 1, 1, 1);
	buff.Count:SetShadowColor(0, 0, 0, 1);
	buff.Count:SetShadowOffset(-1, -1);
	buff.Count:SetTextHeight(buffCountSize);
	buff.Count:SetPoint("TOPLEFT", parent, point, x + 2, y - 2);

	return buff;
end;

function OrlanHeal:CreateBlankCanvas(parent)
	parent.Canvas = CreateFrame("Frame", nil, parent);
	parent.Canvas:SetAllPoints();
	parent.Canvas.BackgroundTexture = parent.Canvas:CreateTexture(nil, "BACKGROUND");
	parent.Canvas.BackgroundTexture:SetTexture(0.2, 0.2, 0.2, 1);
	parent.Canvas.BackgroundTexture:SetAllPoints();
end;

function OrlanHeal:CreateRangeBar(parent)
	parent.RangeBar = parent:CreateTexture();
	parent.RangeBar:SetWidth(self.RangeWidth);
	parent.RangeBar:SetPoint("TOPLEFT", 0, 0);
	parent.RangeBar:SetPoint("BOTTOMLEFT", 0, 0);
end;

function OrlanHeal:CreateNameBar(parent, width)
	parent.NameBar = parent:CreateFontString(nil, nil, "GameFontNormal");
	parent.NameBar:SetHeight(self.NameHeight);
	parent.NameBar:SetWidth(width);
	parent.NameBar:SetPoint("TOPLEFT", self.RangeWidth, 0);
	parent.NameBar:SetJustifyH("LEFT");
	parent.NameBar:SetWordWrap(false);
	parent.NameBar:SetTextHeight(self.NameFontHeight);
end;

function OrlanHeal:CreateStatusBar(parent, backgroundColor, currentColor, incomingColor, yourIncomingColor, overincomingColor, overincomingWidth)
	incomingColor = incomingColor or { r = 0, g = 0, b = 0 };
	yourIncomingColor = yourIncomingColor or { r = 0, g = 0, b = 0 };
	overincomingColor = overincomingColor or { r = 0, g = 0, b = 0 };
	overincomingWidth = overincomingWidth or 1;

	local bar = CreateFrame("Frame", nil, parent);

	bar.Background = bar:CreateTexture(nil, "BACKGROUND");
	bar.Background:SetAllPoints();
	bar.Background:SetTexture(backgroundColor.r, backgroundColor.g, backgroundColor.b, 1);

	bar.Current = bar:CreateTexture();
	bar.Current:SetPoint("TOPLEFT", 0, 0);
	bar.Current:SetPoint("BOTTOMLEFT", 0, 0);
	self:SetStatusBarCurrentColor(bar, currentColor);

	bar.Incoming = bar:CreateTexture();
	bar.Incoming:SetTexture(incomingColor.r, incomingColor.g, incomingColor.b, 1);

	bar.YourIncoming = bar:CreateTexture();
	bar.YourIncoming:SetTexture(yourIncomingColor.r, yourIncomingColor.g, yourIncomingColor.b, 1);

	bar.Overincoming = bar:CreateTexture();
	bar.Overincoming:SetPoint("TOPRIGHT", overincomingWidth, 0);
	bar.Overincoming:SetPoint("BOTTOMRIGHT", overincomingWidth, 0);
	bar.Overincoming:SetWidth(overincomingWidth);
	bar.Overincoming:SetTexture(overincomingColor.r, overincomingColor.g, overincomingColor.b, 1);

	return bar;
end;

function OrlanHeal:SetStatusBarCurrentColor(bar, currentColor)
	bar.Current:SetTexture(currentColor.r, currentColor.g, currentColor.b, 1);
end;

function OrlanHeal:UpdateStatusBar(bar, currentValue, maxValue, incomingValue, yourIncomingValue)
	local width = bar:GetWidth();

	currentValue = currentValue or 0;
	maxValue = maxValue or 1;
	if maxValue == 0 then
		maxValue = 1;
	end;
	incomingValue = incomingValue or 0;
	yourIncomingValue = yourIncomingValue or 0;
	if (currentValue > maxValue) then
		currentValue = maxValue;
	end;
	local isOverincoming = false;
	if (currentValue + incomingValue > maxValue) then
		incomingValue = maxValue - currentValue;
		isOverincoming = true;
	end;
	if yourIncomingValue > incomingValue then
		yourIncomingValue = incomingValue;
	end;

	local currentPosition = currentValue * width / maxValue;
	local incomingPosition = (currentValue + incomingValue - yourIncomingValue) * width / maxValue;
	local yourIncomingPosition = (currentValue + incomingValue) * width / maxValue;
	
	bar.Current:SetWidth(currentPosition);

	bar.Incoming:SetPoint("TOPLEFT", currentPosition, 0);
	bar.Incoming:SetPoint("BOTTOMLEFT", currentPosition, 0);
	bar.Incoming:SetWidth(incomingPosition - currentPosition);
	if (incomingPosition - currentPosition == 0) then
		bar.Incoming:SetVertexColor(1, 1, 1, 0);
	else
		bar.Incoming:SetVertexColor(1, 1, 1, 1);
	end;
	
	bar.YourIncoming:SetPoint("TOPLEFT", incomingPosition, 0);
	bar.YourIncoming:SetPoint("BOTTOMLEFT", incomingPosition, 0);
	bar.YourIncoming:SetWidth(yourIncomingPosition - incomingPosition);
	if (yourIncomingPosition - incomingPosition == 0) then
		bar.YourIncoming:SetVertexColor(1, 1, 1, 0);
	else
		bar.YourIncoming:SetVertexColor(1, 1, 1, 1);
	end;

	if isOverincoming then
		bar.Overincoming:SetVertexColor(1, 1, 1, 1);
	else
		bar.Overincoming:SetVertexColor(1, 1, 1, 0);
	end;
end;

function OrlanHeal:CreateHealthBar(parent, width)
	parent.HealthBar = self:CreateStatusBar(
		parent,
		{ r = 0.4, g = 0.4, b = 0.4 },
		{ r = 0.2, g = 0.75, b = 0.2 },
		{ r = 0.75, g = 0.5, b = 0.2 },
		{ r = 0.75, g = 0.75, b = 0.2 },
		{ r = 1, g = 0.2, b = 0.2 },
		3);
	parent.HealthBar:SetHeight(self.HealthHeight);
	parent.HealthBar:SetWidth(width);
	parent.HealthBar:SetPoint("BOTTOMLEFT", self.RangeWidth, self.ManaHeight);
end;

function OrlanHeal:CreateManaBar(parent, width)
	parent.ManaBar = self:CreateStatusBar(
		parent,
		{ r = 0.4, g = 0.4, b = 0.4 },
		{ r = 0.2, g = 0.2, b = 0.75 });
	parent.ManaBar:SetHeight(self.ManaHeight);
	parent.ManaBar:SetWidth(width);
	parent.ManaBar:SetPoint("BOTTOMLEFT", self.RangeWidth, 0);
end;

function OrlanHeal:CreateUnitButton(parent)
	parent.Button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");
	parent.Button:SetAllPoints();

	self:SetupSpells(parent.Button);
end;

function OrlanHeal:CreatePetWindow(parent)
	local petWindow = CreateFrame("Frame", nil, parent);

	petWindow:SetHeight(self.PlayerHeight);
	petWindow:SetWidth(self.PetWidth);

	self:CreateUnitButton(petWindow);
	self:CreateBlankCanvas(petWindow);
	self:CreateRangeBar(petWindow.Canvas);
	self:CreateHealthBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateManaBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateNameBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateBuffs(petWindow.Canvas, 0, 2, self.Class.PetDebuffSlots);
	self:CreateBorder(petWindow.Canvas, 1, 1);
	self:CreateTargetIcon(petWindow.Canvas, self.PetStatusWidth);

	return petWindow;
end;

function OrlanHeal:SetupSpells(button)
	button:RegisterForClicks("AnyDown");

	button:SetAttribute("*helpbutton1", "help1");
	button:SetAttribute("*helpbutton2", "help2");
	button:SetAttribute("*helpbutton3", "help3");

	for hasControl = 0, 1 do
		for hasShift = 0, 1 do
			for hasAlt = 0, 1 do
				for buttonNumber = 1, 5 do
					self:SetAction(button, hasControl == 1, hasShift == 1, hasAlt == 1, buttonNumber);
				end;
			end;
		end;
	end;
end;

function OrlanHeal:SetAction(button, hasControl, hasShift, hasAlt, buttonNumber)
	local name = self:BuildClickName(hasControl, hasShift, hasAlt, buttonNumber);
	local action = self:GetSpellByKey(self.Config[name]);
	local prefix = "";
	if hasAlt then
		prefix = prefix .. "alt-";
	end;
	if hasControl then
		prefix = prefix .. "ctrl-";
	end;
	if hasShift then
		prefix = prefix .. "shift-";
	end;

	if type(action) == "table" then
		if action.type == "target" then
			button:SetAttribute(prefix .. "type" .. buttonNumber, action.type);
		else
			button:SetAttribute(prefix .. "type" .. buttonNumber, "");
		end;
		button:SetAttribute(prefix .. "type-help" .. buttonNumber, action.type);
		button:SetAttribute(prefix .. "spell-help" .. buttonNumber, action.spell);
		button:SetAttribute(prefix .. "macrotext-help" .. buttonNumber, action.macrotext);
		if action.item then
			button:SetAttribute(
				prefix .. "item-help" .. buttonNumber, 
				GetInventorySlotInfo(action.item));
		end;
	elseif ((action == "") or (action == "target")) then
		button:SetAttribute(prefix .. "type" .. buttonNumber, action);
		button:SetAttribute(prefix .. "type-help" .. buttonNumber, action);
	else
		button:SetAttribute(prefix .. "type" .. buttonNumber, "");
		button:SetAttribute(prefix .. "type-help" .. buttonNumber, "spell");
		button:SetAttribute(prefix .. "spell-help" .. buttonNumber, action);
	end;
end;

function OrlanHeal:RequestNonCombat()
	if InCombatLockdown() then
		print("OrlanHeal: Cannot be done in combat.");
		return false;
	else
		return true;
	end;
end;

function OrlanHeal:GetGroupCountWithTanks()
	local groupCountWithTanks;
	if self.IsTankWindowVisible then
		groupCountWithTanks = self.GroupCount + 1;
	else
		groupCountWithTanks = self.GroupCount;
	end;
	return groupCountWithTanks;
end;

function OrlanHeal:GetExtraGroupAtStartCount()
	local extraGroupAtStartCount;
	if self.IsTankWindowVisible then
		extraGroupAtStartCount = 1;
	else
		extraGroupAtStartCount = 0;
	end;
	return extraGroupAtStartCount;
end;

function OrlanHeal:SetPlayerTarget(groupNumber, groupPlayerNumber, playerUnit, petUnit)
	local visibleGroupIndex = groupNumber + self:GetExtraGroupAtStartCount() - 1;
	self.RaidWindow.Groups[visibleGroupIndex].Players[groupPlayerNumber - 1].Button:SetAttribute("unit", playerUnit);
	self.RaidWindow.Groups[visibleGroupIndex].Players[groupPlayerNumber - 1].Pet.Button:SetAttribute("unit", petUnit);
end;

function OrlanHeal:UpdateUnits()
	local groupPlayerCounts = {};
	for groupNumber = 1, self.GroupCount do
		groupPlayerCounts[groupNumber] = 0;
	end;

	self.RaidRoles = {};
	self.DisplayedTankCount = 0;
	self.DisplayedTanks = {};
	self.IsUnitUpdateRequired = false;
	self.UpdateUnitsAt = time() + 3;

	if self.IsInStartUpMode then
		for groupNumber = 1, self.GroupCount - 1 do
			for unitNumber = (groupNumber - 1) * 5 + 1, (groupNumber - 1) * 5 + 5 do
				self:SetupRaidUnit(unitNumber, groupNumber, groupPlayerCounts);
			end;
		end;
		self:SetupParty(self.GroupCount);
	elseif UnitInRaid("player") ~= nil then
		for unitNumber = 1, self.GroupCount * 5 do
			if unitNumber <= GetNumRaidMembers() then
				local _, _, groupNumber = GetRaidRosterInfo(unitNumber);
				self:SetupRaidUnit(unitNumber, groupNumber, groupPlayerCounts);
			else
				self:SetupFreeRaidSlot(unitNumber, groupPlayerCounts);
			end;
		end;
	else
		self:SetupParty(1);
		for groupNumber = 2, self.GroupCount do
			self:SetupEmptyGroup(groupNumber);
		end;
	end;

	if self.IsTankWindowVisible then
		self:FinishTankSetup();
	end;
end;

function OrlanHeal:SetupTank(unitBinding)
	if self.DisplayedTankCount < 5 then
		self.RaidWindow.Groups[0].Players[self.DisplayedTankCount].Button:SetAttribute("unit", unitBinding);
		self.RaidWindow.Groups[0].Players[self.DisplayedTankCount].Pet.Button:SetAttribute("unit", unitBinding .. "-pet");
		self.DisplayedTanks[unitBinding] = true;
		self.DisplayedTankCount = self.DisplayedTankCount + 1;
	end;
end;

function OrlanHeal:FinishTankSetup()
	for playerIndex = self.DisplayedTankCount, 4 do
		self.RaidWindow.Groups[0].Players[playerIndex].Button:SetAttribute("unit", "");
		self.RaidWindow.Groups[0].Players[playerIndex].Pet.Button:SetAttribute("unit", "");
	end;
end;

function OrlanHeal:SetupRaidUnit(unitNumber, groupNumber, groupPlayerCounts)
	if (groupNumber ~= nil) and 
			(groupNumber ~= 0) and 
			(groupNumber <= self.GroupCount) and 
			(groupPlayerCounts[groupNumber] < 5) then
		local unit = "raid" .. unitNumber;
		local pet = "raidpet" .. unitNumber;
		local unitBinding = unit;
		local petBinding = pet;
		local name, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(unitNumber);

		if UnitExists(unit) and not name then
			self.IsUnitUpdateRequired = true;
		end;

		if name and self.IsNameBindingEnabled then
			unitBinding = name;
			petBinding = name .. "-pet";
		end;

		groupPlayerCounts[groupNumber] = groupPlayerCounts[groupNumber] + 1;
		self:SetPlayerTarget(
			groupNumber, 
			groupPlayerCounts[groupNumber], 
			unitBinding, 
			petBinding);

		if name and self:IsOraMainTank(name) then
			role = "MAINTANK";
		end;
		self.RaidRoles[unit] = role;
		if name then
			self.RaidRoles[name] = role;
		end;
		if self.IsTankWindowVisible then
			local role2 = UnitGroupRolesAssigned(unit);
			if (role == "MAINTANK") or (role2 == "TANK") then
				self:SetupTank(name or unit);
			end;
		end;
	end;
end;

function OrlanHeal:IsOraMainTank(name)
	local isMainTank = false;
	if oRA and oRA.maintanktable then
		for _, tank in pairs(oRA.maintanktable) do
			if tank == name then
				isMainTank = true;
				break;
			end;
		end;
	end;
	return isMainTank;
end;

function OrlanHeal:SetupFreeRaidSlot(unitNumber, groupPlayerCounts)
	for groupNumber = 1, self.GroupCount do
		if groupPlayerCounts[groupNumber] < 5 then
			groupPlayerCounts[groupNumber] = groupPlayerCounts[groupNumber] + 1;
			local unit = "raid" .. unitNumber;
			local pet = "raidpet" .. unitNumber;
			if self.IsNameBindingEnabled then
				unit = "";
				pet = "";
			end;
			self:SetPlayerTarget(
				groupNumber, 
				groupPlayerCounts[groupNumber], 
				unit, 
				pet);
			break;
		end;
	end;
end;

function OrlanHeal:SetupParty(groupNumber)
	self:SetPlayerTarget(groupNumber, 1, "player", "pet");

	if self.IsTankWindowVisible then
		local playerRole = UnitGroupRolesAssigned("player");
		local name = self:GetUnitNameAndRealm("player");
		if not name then
			self.IsUnitUpdateRequired = true;
		end;
		if playerRole == "TANK" then
			self:SetupTank(name or "player");
		end;
	end;

	for unitNumber = 1, 4 do
		local unit = "party" .. unitNumber;
		local pet = "partypet" .. unitNumber;
		local unitBinding = unit;
		local petBinding = pet;
		local name = self:GetUnitNameAndRealm(unit);

		if UnitExists(unit) and not name then
			self.IsUnitUpdateRequired = true;
		end;

		if name and self.IsNameBindingEnabled then
			unitBinding = name;
			petBinding = name .. "-pet";
		end;

		self:SetPlayerTarget(groupNumber, unitNumber + 1, unitBinding, petBinding);
		if self.IsTankWindowVisible then
			local role = UnitGroupRolesAssigned(unit);
			if role == "TANK" then
				self:SetupTank(name or unit);
			end;
		end;
	end;
end;

function OrlanHeal:GetUnitNameAndRealm(unit)
	local name, realm = UnitName(unit);
	local fullName;
	if realm and (realm ~= "") then
		fullName = name .. "-" .. realm;
	else
		fullName = name;
	end;
	return fullName;
end;

function OrlanHeal:SetupEmptyGroup(groupNumber)
	for groupPlayerNumber = 1, 5 do
		self:SetPlayerTarget(groupNumber, groupPlayerNumber, "", "");
	end;
end;

function OrlanHeal:UpdateStatus()
	for groupIndex = 0, self:GetGroupCountWithTanks() - 1 do
		for groupPlayerIndex = 0, 4 do
			local player = self.RaidWindow.Groups[groupIndex].Players[groupPlayerIndex];
			local raidGroupNumber;
			if groupIndex >= self:GetExtraGroupAtStartCount() then
				raidGroupNumber = groupIndex - self:GetExtraGroupAtStartCount() + 1;
			end;
			self:UpdateUnitStatus(player, raidGroupNumber);
			self:UpdateUnitStatus(player.Pet, nil);
			self:UpdatePlayerRoleIcon(player);
		end;
	end;

	self.Class.UpdateRaidBorder(self);
	self:UpdateCooldowns();

	if self.IsUnitUpdateRequired and (time() > self.UpdateUnitsAt) and not InCombatLockdown() then
		self:UpdateUnits();
	end;
end;

function OrlanHeal:UpdatePlayerRoleIcon(player)
	local unit = player.Button:GetAttribute("unit");
	local role = self.RaidRoles[unit];
	if role == "MAINTANK" then
		player.Canvas.Role:SetTexture("Interface\\GroupFrame\\UI-Group-MainTankIcon");
		player.Canvas.Role:SetTexCoord(0, 1, 0, 1);
	elseif role == "MAINASSIST" then
		player.Canvas.Role:SetTexture("Interface\\GroupFrame\\UI-Group-MainAssistIcon");
		player.Canvas.Role:SetTexCoord(0, 1, 0, 1);
	else
		role = UnitGroupRolesAssigned(unit);
		if role == "TANK" then
			player.Canvas.Role:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
			player.Canvas.Role:SetTexCoord(0, 19/64, 22/64, 41/64);
		elseif role == "HEALER" then
			player.Canvas.Role:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
			player.Canvas.Role:SetTexCoord(20/64, 39/64, 1/64, 20/64);
		elseif role == "DAMAGER" then
			player.Canvas.Role:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
			player.Canvas.Role:SetTexCoord(20/64, 39/64, 22/64, 41/64);
		else
			player.Canvas.Role:SetTexture(0, 0, 0, 0);
		end;
	end;
end;

function OrlanHeal:UpdateTargetIcon(canvas, unit)
	local target = GetRaidTargetIndex(unit);
	if target then
		canvas.Target:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons");
		local left = mod(target - 1, 4) / 4;
		local right = left + 1 / 4;
		local top = floor((target - 1) / 4) / 4;
		local bottom = top + 1 / 4;
		canvas.Target:SetTexCoord(left, right, top, bottom);
	else
		canvas.Target:SetTexture(0, 0, 0, 0);
	end;
end;

function OrlanHeal:IsSpellReady(spellId)
	local result = false;

	local spellName = GetSpellInfo(spellId);
	if IsUsableSpell(spellName) then
		local start, duration = GetSpellCooldown(spellId);
		result = not ((start > 0) and (duration > 1.5)); -- cooldowns less than GCD are ignored (latency + queueing)
	end;

	return result;
end;

function OrlanHeal:UpdateUnitStatus(window, displayedGroup)
	local unit = window.Button:GetAttribute("unit");
	if (unit == nil) or (unit == "") or not UnitExists(unit) then
		window.Canvas:Hide();
	else
		if (displayedGroup ~= nil) and (string.sub(unit, 1, 4) == "raid") then
			local _, _, groupNumber = GetRaidRosterInfo(string.sub(unit, 5));
			if groupNumber > self.VisibleGroupCount then
				window.Canvas:Hide();
				return;
			end;
		elseif (string.sub(unit, 1, 7) == "raidpet") then
			local _, _, groupNumber = GetRaidRosterInfo(string.sub(unit, 8));
			if groupNumber > self.VisibleGroupCount then
				window.Canvas:Hide();
				return;
			end;
	        end;

		local redRangeSpellName = GetSpellInfo(self.Class.RedRangeSpellId);
		if UnitInBattleground("player") ~= nil then
			if (UnitIsConnected(unit) ~= 1) or
					(UnitIsCorpse(unit) == 1) or 
					(UnitIsDeadOrGhost(unit) == 1) or
					(IsSpellInRange(redRangeSpellName, unit) ~= 1) or
					(UnitCanAssist("player", unit) ~= 1) then
		                window.Canvas:Hide();
        		        return;
			end;
		end;

		window.Canvas:Show();

		self:UpdateUnitAlpha(window.Canvas, unit, displayedGroup);
		self:UpdateBackground(window.Canvas.BackgroundTexture, unit);
		self:UpdateRange(window.Canvas.RangeBar, unit);
		self:UpdateHealth(window.Canvas.HealthBar, unit);
		self:UpdateMana(window.Canvas.ManaBar, unit);
		self:UpdateName(window.Canvas.NameBar, unit, displayedGroup);
		self:UpdateBuffs(window.Canvas, unit);
		self:UpdateDebuffs(window.Canvas, unit);
		self:UpdateUnitBorder(window.Canvas, unit);
		self:UpdateTargetIcon(window.Canvas, unit);
	end;
end;

function OrlanHeal:UpdateUnitAlpha(canvas, unit, displayedGroup)
	if displayedGroup and self.DisplayedTanks[self:GetUnitNameAndRealm(unit)] then
		canvas:SetAlpha(0.25);
	else
		canvas:SetAlpha(1);
	end;
end;

function OrlanHeal:UpdateUnitBorder(canvas, unit)
	local situation = UnitThreatSituation(unit)
	if situation == 1 then
		self:SetBorderColor(canvas, 1, 0.6, 0, 1);
	elseif (situation == 2) or (situation == 3) then
		self:SetBorderColor(canvas, 1, 0, 0, 1);
	else
		self:SetBorderColor(canvas, 0, 0, 0, 0);
	end;
end;

function OrlanHeal:UnitHasCriticalDebuff(unit)
	local buffIndex = 1;
	local hasCriticalDebuff = false;

	while true do
		local _, _, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, buffIndex, "HARMFUL");
		if spellId == nil then break; end;

		if self.CriticalDebuffs[spellId] then
			hasCriticalDebuff = true;
			break;
		end;

		buffIndex = buffIndex + 1;
	end;

	return hasCriticalDebuff;
end;

function OrlanHeal:UnitCriticalDebuffDuration(unit)
	local buffIndex = 1;
	local maxTimeSpent;

	while true do
		local _, _, _, _, _, duration, expiration, _, _, _, spellId = UnitAura(unit, buffIndex, "HARMFUL");
		if spellId == nil then break; end;

		if self.CriticalDebuffs[spellId] then
			local timeSpent = duration - expiration + GetTime();
			if timeSpent > 100 then
				timeSpent = nil;
			end;
			if (not maxTimeSpent) or (timeSpent and (timeSpent > maxTimeSpent)) then
				maxTimeSpent = timeSpent;
			end;
		end;

		buffIndex = buffIndex + 1;
	end;

	return maxTimeSpent;
end;

function OrlanHeal:UpdateBackground(background, unit)
	if UnitIsConnected(unit) ~= 1 then
		background:SetTexture(0, 0, 0, 1);
	elseif (UnitIsCorpse(unit) == 1) or (UnitIsDeadOrGhost(unit) == 1) then
		background:SetTexture(0.1, 0.1, 0.1, 1);
	elseif self:UnitHasCriticalDebuff(unit) then
		background:SetTexture(0.8, 0.8, 0.8, 1);
	else
		local health = UnitHealth(unit);
		local maxHealth = UnitHealthMax(unit);

		if health / maxHealth < 0.5 then
			background:SetTexture(0.6, 0.2, 0.2, 1);
		elseif health / maxHealth < 0.75 then
			background:SetTexture(0.6, 0.4, 0.2, 1);
		elseif health / maxHealth < 0.9 then
			background:SetTexture(0.4, 0.4, 0.2, 1);
		else
			background:SetTexture(0.2, 0.2, 0.2, 1);
		end;
	end;
end;

function OrlanHeal:IsSpellInRangeById(unit, spellId)
	local spellName = GetSpellInfo(spellId);
	return (IsSpellInRange(spellName, "player") ~= 1) or (IsSpellInRange(spellName, unit) == 1);
end;

function OrlanHeal:UpdateRange(rangeBar, unit)
	if UnitIsConnected(unit) ~= 1 then
		rangeBar:SetTexture(0, 0, 0, 1);
	elseif (UnitIsCorpse(unit) == 1) or (UnitIsDeadOrGhost(unit) == 1) then
		rangeBar:SetTexture(0.4, 0.4, 0.4, 1);
	elseif (not self:IsSpellInRangeById(unit, self.Class.RedRangeSpellId)) or (UnitCanAssist("player", unit) ~= 1) then
		rangeBar:SetTexture(0.2, 0.2, 0.75, 1);
	elseif not self:IsSpellInRangeById(unit, self.Class.OrangeRangeSpellId) then
		rangeBar:SetTexture(0.75, 0.2, 0.2, 1);
	elseif not self:IsSpellInRangeById(unit, self.Class.YellowRangeSpellId) then
		rangeBar:SetTexture(0.75, 0.45, 0.2, 1);
	elseif CheckInteractDistance(unit, 2) ~= 1 then
		rangeBar:SetTexture(0.75, 0.75, 0.2, 1);
	else
		rangeBar:SetTexture(0.2, 0.75, 0.2, 1);
	end;
end;

function OrlanHeal:UpdateHealth(healthBar, unit)
	self:UpdateStatusBar(healthBar, UnitHealth(unit), UnitHealthMax(unit), UnitGetIncomingHeals(unit), UnitGetIncomingHeals(unit, "player"));

	if UnitIsConnected(unit) ~= 1 then
		self:SetStatusBarCurrentColor(healthBar, { r = 0, g = 0, b = 0 });
	else
		self:SetStatusBarCurrentColor(healthBar, { r = 0.2, g = 0.75, b = 0.2 });
	end;
end;

function OrlanHeal:UpdateMana(manaBar, unit)
	if (UnitPowerType(unit) == SPELL_POWER_MANA) and (UnitIsConnected(unit) == 1) then
		manaBar:Show();
		self:UpdateStatusBar(manaBar, UnitPower(unit, SPELL_POWER_MANA), UnitPowerMax(unit, SPELL_POWER_MANA));
	else
		manaBar:Hide();
	end;
end;

function OrlanHeal:UpdateName(nameBar, unit, displayedGroup)
	local text = GetUnitName(unit, false);
	
	if UnitIsAFK(unit) then
		text = "afk " .. text;
	end;
	if UnitIsDND(unit) then
		text = "dnd " .. text;
	end;

	local criticalDuration = self:UnitCriticalDebuffDuration(unit);
	if criticalDuration then
		text = floor(criticalDuration) .. " " .. text;
	end;

	if (displayedGroup ~= nil) and (string.sub(unit, 1, 4) == "raid") then
		local _, _, groupNumber = GetRaidRosterInfo(string.sub(unit, 5));
		if displayedGroup ~= groupNumber then
			text = "[" .. groupNumber .. "] " .. text;
		end;
	end;

	nameBar:SetText(text);
	local _, class = UnitClassBase(unit);
	local classColor = RAID_CLASS_COLORS[class];
	if classColor == nil then
		classColor = { r = 0.4, g = 0.4, b = 0.4 };
	end;
	nameBar:SetTextColor(classColor.r, classColor.g, classColor.b, 1);
end;

function OrlanHeal:UpdateBuffs(canvas, unit)
	local goodBuffCount = 0;
	local goodBuffs = {};
	local buffIndex = 1;
	while true do
		local name, _, icon, count, _, duration, expires, caster, _, shouldConsolidate, spellId = 
			UnitAura(unit, buffIndex, "HELPFUL");
		if name == nil then break; end;

		local buffKind = self.Class.GetSpecificBuffKind(self, spellId, caster);
		if not buffKind then
			if (self.SavingAbilities[spellId]) then
				buffKind = -1;
			elseif (self.ShieldAbilities[spellId]) then
				buffKind = -2;
			elseif (self.HealingBuffs[spellId]) then
				buffKind = -3;
			end;
		end;

		if buffKind ~= nil then
			goodBuffCount = goodBuffCount + 1;
			goodBuffs[goodBuffCount] =
			{
				Icon = icon,
				Count = count,
				Duration = duration,
				Expires = expires,
				Kind = buffKind
			};
		end;

		buffIndex = buffIndex + 1;
	end;

	if canvas.SpecificBuffs ~= nil then
		for buffIndex = 0, 4 do
			if canvas.SpecificBuffs[buffIndex] ~= nill then
				self:ShowBuff(canvas.SpecificBuffs[buffIndex], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, buffIndex + 1));
			end;
		end;
	end;

	if canvas.OtherBuffs ~= nil then
		for buffIndex = 0, 4 do
			if canvas.OtherBuffs[buffIndex] ~= nill then
				self:ShowBuff(canvas.OtherBuffs[buffIndex], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, 0));
			end;
		end;
	end;
end;

function OrlanHeal:UpdateDebuffs(canvas, unit)
	local specialDebuffCount = 0;
	local specialDebuffs = {};
	local buffIndex = 1;
	local canAssist = UnitCanAssist("player", unit) == 1;
	while true do
		local name, _, icon, count, dispelType, duration, expires, _, _, _, spellId = UnitAura(unit, buffIndex, "HARMFUL");
		if name == nil then break; end;

		local buffKind = self.Class.GetSpecificDebuffKind(self, spellId);
		if not buffKind then
			if (dispelType == "Disease") and canAssist then
				buffKind = self.Class.DiseaseDebuffKind;
			elseif (dispelType == "Magic") and canAssist then
				buffKind = self.Class.MagicDebuffKind;
			elseif (dispelType == "Poison") and canAssist then
				buffKind = self.Class.PoisonDebuffKind;
			elseif (dispelType == "Curse") and canAssist then
				buffKind = self.Class.CurseDebuffKind;
			elseif (self.IgnoredDebuffs[spellId]) then
				buffKind = nil;
			elseif canAssist then
				buffKind = -1;
			end;
		end;

		if buffKind ~= nil then
			specialDebuffCount = specialDebuffCount + 1;
			specialDebuffs[specialDebuffCount] =
			{
				Icon = icon,
				Count = count,
				Duration = duration,
				Expires = expires,
				Kind = buffKind
			};
		end;

		buffIndex = buffIndex + 1;
	end;

	local slotIndex = 0;
	while canvas.Debuffs.Slots[slotIndex + 1] do
		self:ShowBuff(
			canvas.Debuffs[slotIndex], 
			self:GetLastBuffOfKind(specialDebuffs, specialDebuffCount, canvas.Debuffs.Slots[slotIndex + 1]));

		slotIndex = slotIndex + 1;
	end;
end;

function OrlanHeal:GetLastBuffOfKind(buffs, buffCount, kind)
	for index = buffCount, 1, -1 do
		if (buffs[index] ~= nil) and ((kind == nil) or (kind == 0) or (buffs[index].Kind == kind)) then
			local result = buffs[index];
			buffs[index] = nil;
			return result;
		end;
	end;

	return nil;
end;

function OrlanHeal:ShowBuff(texture, buff)
	if buff == nil then
		texture.Image:SetTexture(0, 0, 0, 0);
		texture.Time:SetTexture(0, 0, 0, 0);
		texture.Count:SetText("");
	else
		texture.Image:SetTexture(buff.Icon);

		if buff.Expires <= GetTime() + 3 then
			texture.Time:SetTexture(1, 0, 0, 0.3);
		elseif buff.Expires <= GetTime() + 6 then
			texture.Time:SetTexture(1, 1, 0, 0.3);
		else
			texture.Time:SetTexture(0, 0, 0, 0);
		end;

		if (buff.Count > 1) then
			texture.Count:SetText(buff.Count);
		else
			texture.Count:SetText("");
		end;
	end;
end;

function OrlanHeal:BuildClickName(hasControl, hasShift, hasAlt, buttonNumber)
	local name = "";
	if hasControl then
		name = name .. "control";
	end;
	if hasAlt then
		name = name .. "alt";
	end;
	if hasShift then
		name = name .. "shift";
	end;
	name = name .. buttonNumber;
	return name;
end;

function OrlanHeal:BuildCastSequenceMacro(spellId1, spellId2)
	return "/cast " .. GetSpellInfo(spellId1) .. "\n/cast " .. GetSpellInfo(spellId2);
end;