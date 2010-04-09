OrlanHeal = {};

SLASH_ORLANHEAL1 = "/orlanheal";
SLASH_ORLANHEAL2 = "/oh";
function SlashCmdList.ORLANHEAL(message, editbox)
	if message == "show" then
		OrlanHeal:Show();
	elseif message == "hide" then
		OrlanHeal:Hide();
	elseif message == "40" then
		OrlanHeal:SetGroupCount(8);
	elseif message == "25" then
		OrlanHeal:SetGroupCount(5);
	elseif message == "10" then
		OrlanHeal:SetGroupCount(2);
	elseif message == "5" then
		OrlanHeal:SetGroupCount(1);
	end;
end;

function OrlanHeal:Initialize(configName)
	local orlanHeal = self;

	self.ConfigName = configName;
	self.EventFrame = CreateFrame("Frame");

	function self.EventFrame:HandleEvent(event, arg1)
		if (event == "ADDON_LOADED") and (arg1 == "OrlanHeal") then
			orlanHeal:HandleLoaded();
		elseif (event == "RAID_ROSTER_UPDATE") or
			(event == "PARTY_MEMBERS_CHANGED") or
			(event == "ZONE_CHANGED_NEW_AREA") or
			(event == "PLAYER_REGEN_ENABLED") or
			(event == "PLAYER_ENTERING_BATTLEGROUND") or
			(event == "PLAYER_ENTERING_WORLD") then
			if not InCombatLockdown() then
				orlanHeal:UpdateUnits();
			end;
		end;
	end;

	self.ElapsedAfterUpdate = 0;
	function self.EventFrame:HandleUpdate(elapsed)
		orlanHeal.ElapsedAfterUpdate = orlanHeal.ElapsedAfterUpdate + elapsed;
		if orlanHeal.ElapsedAfterUpdate > 0.1 then
			orlanHeal:UpdateStatus();
			orlanHeal.ElapsedAfterUpdate = 0;
		end;
	end;

	self.EventFrame:RegisterEvent("ADDON_LOADED");
	self.EventFrame:SetScript("OnEvent", self.EventFrame.HandleEvent);
	self.EventFrame:SetScript("OnUpdate", self.EventFrame.HandleUpdate);

	self.MaxGroupCount = 8;
	self.MaxVerticalGroupCount = math.floor((self.MaxGroupCount + 1) / 2);
	if self.MaxGroupCount == 1 then
		self.MaxHorizontalGroupCount = 1;
	else
		self.MaxHorizontalGroupCount = 2;
	end;

	self.Scale = 0.8;
	self.PetWidth = 81 * self.Scale;
	self.PetHeight = 20 * self.Scale;
	self.PetSpacing = 3 * self.Scale;
	self.PlayerWidth = 130 * self.Scale;
	self.PlayerHeight = 20 * self.Scale;
	self.GroupOuterSpacing = 2 * self.Scale;
	self.PlayerInnerSpacing = 2 * self.Scale;
	self.GroupWidth = self.PlayerWidth + self.PetSpacing + self.PetWidth + self.GroupOuterSpacing * 2;
	self.GroupHeight = math.max(self.PlayerHeight, self.PetHeight) * 5 + 
		self.GroupOuterSpacing * 2 + 
		self.PlayerInnerSpacing * 4;
	self.RaidOuterSpacing = 6 * self.Scale;
	self.GroupInnerSpacing = 4 * self.Scale;
	self.RaidWidth = self.GroupWidth * self.MaxHorizontalGroupCount + 
		self.RaidOuterSpacing * 2 + 
		self.GroupInnerSpacing * (self.MaxHorizontalGroupCount - 1);
	self.RaidHeight = self.GroupHeight * self.MaxVerticalGroupCount + 
		self.RaidOuterSpacing * 2 + 
		self.GroupInnerSpacing * (self.MaxVerticalGroupCount - 1);
	self.RangeWidth = 5 * self.Scale;
	self.PlayerStatusWidth = 80 * self.Scale;
	self.PetStatusWidth = 50 * self.Scale;
	self.HealthHeight = 4 * self.Scale;
	self.ManaHeight = 4 * self.Scale;

	self.RaidAlpha = 0.2;
	self.GroupAlpha = 0.2;

	self.RaidWindowStrata = "LOW";
	self.RaidWindowName = "OrlanHeal_RaidWindow";

	self.GroupCount = 8;
end;

function OrlanHeal:CreateRaidWindow()
	local orlanHeal = self;
	local raidWindow = CreateFrame("Frame", nil, UIParent);

	function raidWindow:HandleDragStop()
		orlanHeal.Config.RaidWindowPosition =
		{
			x = self:GetLeft(),
			y = self:GetBottom()
		};
		self:StopMovingOrSizing();
	end;

	raidWindow:ClearAllPoints();
	raidWindow:SetPoint("BOTTOMLEFT", orlanHeal.Config.RaidWindowPosition.x, orlanHeal.Config.RaidWindowPosition.y);
	raidWindow:SetFrameStrata(self.RaidWindowStrata);
	raidWindow:SetBackdrop(
	{
		bgFile = "Interface\\Tooltips\\ChatBubble-Background",
		edgeFile = "Interface\Tooltips\UI-Tooltip-Border",
		tile = false,
		tileSize = 0,
		edgeSize = 5,
		insets =
		{
			left = 1,
			right = 1,
			top = 1,
			bottom = 1
		}
	});
	raidWindow:SetBackdropColor(1, 1, 1, self.RaidAlpha);
	raidWindow:SetHeight(self.RaidHeight);
	raidWindow:SetWidth(self.RaidWidth);
	raidWindow:EnableMouse(true);
	raidWindow:EnableKeyboard(true);
	raidWindow:SetMovable(true);
	raidWindow:RegisterForDrag("LeftButton");
	raidWindow:SetScript("OnDragStart", raidWindow.StartMoving);
	raidWindow:SetScript("OnDragStop", raidWindow.HandleDragStop);

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

	return raidWindow;
end;

function OrlanHeal:CreateGroupWindow(parent, isOnTheRight)
	local groupWindow = CreateFrame("Frame", nil, parent);

	groupWindow:ClearAllPoints();
	groupWindow:SetFrameStrata(self.RaidWindowStrata);
	groupWindow:SetBackdrop(
	{
		bgFile = "Interface\\Tooltips\\ChatBubble-Background",
		edgeFile = "Interface\Tooltips\UI-Tooltip-Border",
		tile = false,
		tileSize = 0,
		edgeSize = 10,
		insets =
		{
			left = 0,
			right = 0,
			top = 0,
			bottom = 0
		}
	});
	groupWindow:SetBackdropColor(1, 1, 1, self.GroupAlpha);
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

	playerWindow:SetFrameStrata(self.RaidWindowStrata);
	playerWindow:SetHeight(self.PlayerHeight);
	playerWindow:SetWidth(self.PlayerWidth);

	self:CreateUnitButton(playerWindow);
	self:CreateBlankCanvas(playerWindow);
	self:CreateRangeBar(playerWindow.Canvas);
	self:CreateHealthBar(playerWindow.Canvas, self.PlayerStatusWidth);

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

function OrlanHeal:CreateBlankCanvas(parent)
	local canvas = CreateFrame("Frame", nil, parent);

	canvas:SetFrameStrata(self.RaidWindowStrata);
	canvas:SetHeight(parent:GetHeight());
	canvas:SetWidth(parent:GetWidth());
	canvas:SetPoint("TOPLEFT", 0, 0);

	canvas.BackgroundTexture = canvas:CreateTexture(nil, "BACKGROUND");
	canvas.BackgroundTexture:SetTexture(0.2, 0.2, 0.2, 1);
	canvas.BackgroundTexture:SetHeight(parent:GetHeight());
	canvas.BackgroundTexture:SetWidth(parent:GetWidth());
	canvas.BackgroundTexture:SetPoint("TOPLEFT", 0, 0);

	parent.Canvas = canvas;
end;

function OrlanHeal:CreateRangeBar(parent)
	local rangeBar = CreateFrame("Frame", nil, parent);

	rangeBar:SetFrameStrata(self.RaidWindowStrata);
	rangeBar:SetHeight(parent:GetHeight());
	rangeBar:SetWidth(self.RangeWidth);
	rangeBar:SetPoint("TOPLEFT", 0, 0);

	rangeBar.BackgroundTexture = rangeBar:CreateTexture();
	rangeBar.BackgroundTexture:SetTexture(0, 0, 1, 1);
	rangeBar.BackgroundTexture:SetHeight(parent:GetHeight());
	rangeBar.BackgroundTexture:SetWidth(self.RangeWidth);
	rangeBar.BackgroundTexture:SetPoint("TOPLEFT", 0, 0);

	parent.RangeBar = rangeBar;
end;

function OrlanHeal:CreateHealthBar(parent, width)
	parent.HealthBar = CreateFrame("StatusBar", nil, parent);

	parent.HealthBar:SetFrameStrata(self.RaidWindowStrata);
	parent.HealthBar:SetHeight(self.HealthHeight);
	parent.HealthBar:SetWidth(width);
	parent.HealthBar:SetPoint("BOTTOMLEFT", self.RangeWidth, self.ManaHeight);
	parent.HealthBar:SetMinMaxValues(0, 100);
	parent.HealthBar:SetValue(100);
end;

function OrlanHeal:CreateUnitButton(parent)
	parent.Button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");
	parent.Button:SetFrameStrata(self.RaidWindowStrata);
	parent.Button:SetHeight(parent:GetHeight());
	parent.Button:SetWidth(parent:GetWidth());
	parent.Button:SetPoint("TOPLEFT", 0, 0);

	self:SetupSpells(parent.Button);
end;

function OrlanHeal:CreatePetWindow(parent)
	local petWindow = CreateFrame("Frame", nil, parent);

	petWindow:SetFrameStrata(self.RaidWindowStrata);
	petWindow:SetHeight(self.PetHeight);
	petWindow:SetWidth(self.PetWidth);

	self:CreateUnitButton(petWindow);
	self:CreateBlankCanvas(petWindow);
	self:CreateRangeBar(petWindow.Canvas);
	self:CreateHealthBar(petWindow.Canvas, self.PetStatusWidth);

	return petWindow;
end;

function OrlanHeal:SetupSpells(button)
	button:RegisterForClicks("AnyDown");

	button:SetAttribute("*helpbutton1", "help1");
	button:SetAttribute("*helpbutton2", "help2");
	button:SetAttribute("*helpbutton3", "help3");

	button:SetAttribute("type-help1", "spell");
	button:SetAttribute("spell-help1", "Вспышка Света");

	button:SetAttribute("type-help2", "spell");
	button:SetAttribute("spell-help2", "Свет Небес");

	button:SetAttribute("type-help3", "spell");
	button:SetAttribute("spell-help3", "Длань защиты");

	button:SetAttribute("shift-type1", "target");
	button:SetAttribute("shift-type-help1", "target");

	button:SetAttribute("shift-type-help2", "spell");
	button:SetAttribute("shift-spell-help2", "Частица Света");

	button:SetAttribute("shift-type-help3", "spell");
	button:SetAttribute("shift-spell-help3", "Длань спасения");

	button:SetAttribute("ctrl-type-help1", "spell");
	button:SetAttribute("ctrl-spell-help1", "Длань жертвенности");

	button:SetAttribute("ctrl-type-help2", "spell");
	button:SetAttribute("ctrl-spell-help2", "Возложение рук");

	button:SetAttribute("ctrl-type3", "spell");
	button:SetAttribute("ctrl-type-help3", "spell");
	button:SetAttribute("ctrl-spell3", "Божественное вмешательство");
	button:SetAttribute("ctrl-spell-help3", "Божественное вмешательство");

	button:SetAttribute("alt-type-help1", "spell");
	button:SetAttribute("alt-spell-help1", "Очищение");

	button:SetAttribute("alt-type-help2", "spell");
	button:SetAttribute("alt-spell-help2", "Шок небес");
	
	button:SetAttribute("alt-type-help3", "spell");
	button:SetAttribute("alt-spell-help3", "Священный щит");
end;

function OrlanHeal:HandleLoaded()
	_G[self.ConfigName] = _G[self.ConfigName] or {};
	self.Config = _G[self.ConfigName];

	self.Config.RaidWindowPosition = self.Config.RaidWindowPosition or
	{
		x = 0,
		y = 0
	};

	self.RaidWindow = self:CreateRaidWindow();

	self:UpdateVisibleGroupCount();
	self:Show();

	self.EventFrame:RegisterEvent("RAID_ROSTER_UPDATE");
	self.EventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self.EventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self.EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	self.EventFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
	self.EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
end;

function OrlanHeal:Show()
	if self:RequestNonCombat() then
		self.RaidWindow:Show();
		self:UpdateUnits();
	end;
end;

function OrlanHeal:Hide()
	if self:RequestNonCombat() then
		self.RaidWindow:Hide();
	end;
end;

function OrlanHeal:RequestNonCombat()
	if InCombatLockdown() then
		print("OrlanHeal: Невозможно выполнить в бою");
		return false;
	else
		return true;
	end;
end;

function OrlanHeal:UpdateVisibleGroupCount()
	for groupIndex = 0, self.MaxGroupCount - 1 do
		if groupIndex < self.GroupCount then
			self.RaidWindow.Groups[groupIndex]:Show();
		else
			self.RaidWindow.Groups[groupIndex]:Hide();
		end;
	end;

	local verticalGroupCount = math.floor((self.GroupCount + 1) / 2);
	self.RaidWindow:SetHeight(
		self.GroupHeight * verticalGroupCount + 
		self.RaidOuterSpacing * 2 + 
		self.GroupInnerSpacing * (verticalGroupCount - 1));

	local horizontalGroupCount;
	if self.GroupCount == 1 then
		horizontalGroupCount = 1;
	else
		horizontalGroupCount = 2;
	end;
	self.RaidWindow:SetWidth(
		self.GroupWidth * horizontalGroupCount + 
		self.RaidOuterSpacing * 2 + 
		self.GroupInnerSpacing * (horizontalGroupCount - 1));
end;

function OrlanHeal:SetGroupCount(newGroupCount)
	if self:RequestNonCombat() then
		self.GroupCount = newGroupCount;
		self:UpdateVisibleGroupCount();
	end;
end;

function OrlanHeal:SetPlayerTarget(groupNumber, groupPlayerNumber, playerUnit, petUnit)
	self.RaidWindow.Groups[groupNumber - 1].Players[groupPlayerNumber - 1].Button:SetAttribute("unit", playerUnit);
	self.RaidWindow.Groups[groupNumber - 1].Players[groupPlayerNumber - 1].Pet.Button:SetAttribute("unit", petUnit);
end;

function OrlanHeal:UpdateUnits()
	local groupPlayerCounts = {};
	for groupNumber = 1, self.GroupCount do
		groupPlayerCounts[groupNumber] = 0;
	end;

	if UnitInRaid("player") ~= nil then
		for unitNumber = 1, self.GroupCount * 5 do
			if unitNumber <= GetNumRaidMembers() then
				local _, _, groupNumber = GetRaidRosterInfo(unitNumber);
				groupPlayerCounts[groupNumber] = groupPlayerCounts[groupNumber] + 1;
				self:SetPlayerTarget(
					groupNumber, 
					groupPlayerCounts[groupNumber], 
					"raid" .. unitNumber, 
					"raidpet" .. unitNumber);
			else
				for groupNumber = 1, self.GroupCount do
					if groupPlayerCounts[groupNumber] < 5 then
						groupPlayerCounts[groupNumber] = groupPlayerCounts[groupNumber] + 1;
						self:SetPlayerTarget(
							groupNumber, 
							groupPlayerCounts[groupNumber], 
							"raid" .. unitNumber, 
							"raidpet" .. unitNumber);
						break;
					end;
				end;
			end;
		end;
	elseif UnitInParty("player") ~= nil then
		self:SetPlayerTarget(1, 1, "player", "pet");
		for unitNumber = 1, 4 do
			self:SetPlayerTarget(1, unitNumber + 1, "party" .. unitNumber, "partypet" .. unitNumber);
		end;
		for groupNumber = 2, self.GroupCount do
			for groupPlayerNumber = 1, 5 do
				self:SetPlayerTarget(groupNumber, groupPlayerNumber, "", "");
			end;
		end;
	else
		self:SetPlayerTarget(1, 1, "player", "pet");
		for groupPlayerNumber = 2, 5 do
			self:SetPlayerTarget(1, groupPlayerNumber, "", "");
		end;
		for groupNumber = 2, self.GroupCount do
			for groupPlayerNumber = 1, 5 do
				self:SetPlayerTarget(groupNumber, groupPlayerNumber, "", "");
			end;
		end;
	end;
end;

function OrlanHeal:UpdateStatus()
	for groupIndex = 0, self.GroupCount - 1 do
		for groupPlayerIndex = 0, 4 do
			local player = self.RaidWindow.Groups[groupIndex].Players[groupPlayerIndex];
			self:UpdateUnitStatus(player);
			self:UpdateUnitStatus(player.Pet);
		end;
	end;
end;

function OrlanHeal:UpdateUnitStatus(window)
	local unit = window.Button:GetAttribute("unit");
	if (unit == nil) or (unit == "") or not UnitExists(unit) then
		window.Canvas:Hide();
	else
		window.Canvas:Show();

		self:UpdateRange(window.Canvas.RangeBar, unit);
	end;
end;

function OrlanHeal:UpdateRange(rangeBar, unit)
	if UnitIsConnected(unit) ~= 1 then
		rangeBar.BackgroundTexture:SetTexture(0, 0, 0, 1);
	elseif (UnitIsCorpse(unit) == 1) or (UnitIsDeadOrGhost(unit) == 1) then
		rangeBar.BackgroundTexture:SetTexture(0.4, 0.4, 0.4, 1);
	elseif IsSpellInRange("Частица Света", unit) ~= 1 then
		rangeBar.BackgroundTexture:SetTexture(0.2, 0.2, 0.75, 1);
	elseif IsSpellInRange("Вспышка Света", unit) ~= 1 then
		rangeBar.BackgroundTexture:SetTexture(0.75, 0.2, 0.2, 1);
	elseif IsSpellInRange("Длань Спасения", unit) ~= 1 then
		rangeBar.BackgroundTexture:SetTexture(0.75, 0.45, 0.2, 1);
	elseif CheckInteractDistance(unit, 2) ~= 1 then
		rangeBar.BackgroundTexture:SetTexture(0.75, 0.75, 0.2, 1);
	else
		rangeBar.BackgroundTexture:SetTexture(0.2, 0.75, 0.2, 1);
	end;
end;

OrlanHeal:Initialize("OrlanHealConfig");
