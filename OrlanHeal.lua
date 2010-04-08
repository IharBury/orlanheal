OrlanHeal = {};

function OrlanHeal:Initialize(configName)
	local orlanHeal = self;

	self.ConfigName = configName;
	self.EventFrame = CreateFrame("Frame");

	function self.EventFrame:HandleEvent(event, arg1)
		if (event == "ADDON_LOADED") and (arg1 == "OrlanHeal") then
			orlanHeal:HandleLoaded();
		end;
	end;

	self.EventFrame:RegisterEvent("ADDON_LOADED");
	self.EventFrame:SetScript("OnEvent", self.EventFrame.HandleEvent);

	self.Scale = 0.8;
	self.PetWidth = 81 * self.Scale;
	self.PetHeight = 20 * self.Scale;
	self.PetSpacing = 3 * self.Scale;
	self.PlayerWidth = 130 * self.Scale;
	self.PlayerHeight = 20 * self.Scale;
	self.PlayerOuterSpacing = 2 * self.Scale;
	self.PlayerInnerSpacing = 2 * self.Scale;
	self.GroupWidth = self.PlayerWidth + self.PlayerOuterSpacing * 2;
	self.GroupHeight = self.PlayerHeight * 5 + self.PlayerOuterSpacing * 2 + self.PlayerInnerSpacing * 4;
	self.GroupOuterSpacing = 6 * self.Scale;
	self.GroupInnerSpacing = 4 * self.Scale;
	self.RaidWidth = self.GroupWidth * 2 + self.GroupOuterSpacing * 2 + self.GroupInnerSpacing;
	self.RaidHeight = self.GroupHeight * 4 + self.GroupOuterSpacing * 2 + self.GroupInnerSpacing * 3;

	self.RaidAlpha = 0.2;
	self.GroupAlpha = 0.2;

	self.RaidWindowStrata = "LOW";
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
	raidWindow.Groups[1] = self:CreateGroupWindow(raidWindow, false);
	raidWindow.Groups[1]:SetPoint(
		"TOPLEFT", 
		self.GroupOuterSpacing, 
		-self.GroupOuterSpacing);
	raidWindow.Groups[2] = self:CreateGroupWindow(raidWindow, true);
	raidWindow.Groups[2]:SetPoint(
		"TOPLEFT", 
		self.GroupOuterSpacing + self.GroupWidth + self.GroupInnerSpacing, 
		-self.GroupOuterSpacing);
	raidWindow.Groups[3] = self:CreateGroupWindow(raidWindow, false);
	raidWindow.Groups[3]:SetPoint(
		"TOPLEFT", 
		self.GroupOuterSpacing, 
		-self.GroupOuterSpacing - self.GroupHeight - self.GroupInnerSpacing);
	raidWindow.Groups[4] = self:CreateGroupWindow(raidWindow, true);
	raidWindow.Groups[4]:SetPoint(
		"TOPLEFT", 
		self.GroupOuterSpacing + self.GroupWidth + self.GroupInnerSpacing, 
		-self.GroupOuterSpacing - self.GroupHeight - self.GroupInnerSpacing);
	raidWindow.Groups[5] = self:CreateGroupWindow(raidWindow, false);
	raidWindow.Groups[5]:SetPoint(
		"TOPLEFT", 
		self.GroupOuterSpacing, 
		-self.GroupOuterSpacing - self.GroupHeight * 2 - self.GroupInnerSpacing * 2);
	raidWindow.Groups[6] = self:CreateGroupWindow(raidWindow, true);
	raidWindow.Groups[6]:SetPoint(
		"TOPLEFT", 
		self.GroupOuterSpacing + self.GroupWidth + self.GroupInnerSpacing, 
		-self.GroupOuterSpacing - self.GroupHeight * 2 - self.GroupInnerSpacing * 2);
	raidWindow.Groups[7] = self:CreateGroupWindow(raidWindow, false);
	raidWindow.Groups[7]:SetPoint(
		"TOPLEFT", 
		self.GroupOuterSpacing, 
		-self.GroupOuterSpacing - self.GroupHeight * 3 - self.GroupInnerSpacing * 3);
	raidWindow.Groups[8] = self:CreateGroupWindow(raidWindow, true);
	raidWindow.Groups[8]:SetPoint(
		"TOPLEFT", 
		self.GroupOuterSpacing + self.GroupWidth + self.GroupInnerSpacing, 
		-self.GroupOuterSpacing - self.GroupHeight * 3 - self.GroupInnerSpacing * 3);

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
	groupWindow.Players[1] = self:CreatePlayerWindow(groupWindow, isOnTheRight);
	groupWindow.Players[1]:SetPoint(
		"TOPLEFT", 
		self.PlayerOuterSpacing, 
		-self.PlayerOuterSpacing);
	groupWindow.Players[2] = self:CreatePlayerWindow(groupWindow, isOnTheRight);
	groupWindow.Players[2]:SetPoint(
		"TOPLEFT", 
		self.PlayerOuterSpacing, 
		-self.PlayerOuterSpacing - self.PlayerHeight - self.PlayerInnerSpacing);
	groupWindow.Players[3] = self:CreatePlayerWindow(groupWindow, isOnTheRight);
	groupWindow.Players[3]:SetPoint(
		"TOPLEFT", 
		self.PlayerOuterSpacing, 
		-self.PlayerOuterSpacing - self.PlayerHeight * 2 - self.PlayerInnerSpacing * 2);
	groupWindow.Players[4] = self:CreatePlayerWindow(groupWindow, isOnTheRight);
	groupWindow.Players[4]:SetPoint(
		"TOPLEFT", 
		self.PlayerOuterSpacing, 
		-self.PlayerOuterSpacing - self.PlayerHeight * 3 - self.PlayerInnerSpacing * 3);
	groupWindow.Players[5] = self:CreatePlayerWindow(groupWindow, isOnTheRight);
	groupWindow.Players[5]:SetPoint(
		"TOPLEFT", 
		self.PlayerOuterSpacing, 
		-self.PlayerOuterSpacing - self.PlayerHeight * 4 - self.PlayerInnerSpacing * 4);

	return groupWindow;
end;

function OrlanHeal:CreatePlayerWindow(parent, isOnTheRight)
	local playerWindow = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");

	playerWindow:ClearAllPoints();
	playerWindow:SetFrameStrata(self.RaidWindowStrata);
	playerWindow:SetHeight(self.PlayerHeight);
	playerWindow:SetWidth(self.PlayerWidth);
	playerWindow.BackgroundTexture = playerWindow:CreateTexture(nil, "BACKGROUND");
	playerWindow.BackgroundTexture:SetTexture(0.5, 0.5, 0.5, 1);
	playerWindow.BackgroundTexture:SetHeight(self.PlayerHeight);
	playerWindow.BackgroundTexture:SetWidth(self.PlayerWidth);
	playerWindow.BackgroundTexture:SetPoint("TOPLEFT", 0, 0);

	playerWindow.Pet = self:CreatePetWindow(playerWindow);
	if isOnTheRight then
		playerWindow.Pet:SetPoint(
			"TOPRIGHT",
			self.PetWidth + self.PetSpacing + self.GroupOuterSpacing + self.PlayerOuterSpacing,
			0);
	else
		playerWindow.Pet:SetPoint(
			"TOPLEFT",
			-self.PetWidth - self.PetSpacing - self.GroupOuterSpacing - self.PlayerOuterSpacing,
			0);
	end;

	self:SetupSpells(playerWindow);
	playerWindow:SetAttribute("unit", "player");

	return playerWindow;
end;

function OrlanHeal:CreatePetWindow(parent)
	local petWindow = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");

	petWindow:ClearAllPoints();
	petWindow:SetFrameStrata(self.RaidWindowStrata);
	petWindow:SetHeight(self.PetHeight);
	petWindow:SetWidth(self.PetWidth);

	petWindow.BackgroundTexture = petWindow:CreateTexture(nil, "BACKGROUND");
	petWindow.BackgroundTexture:SetTexture(0.5, 0.5, 0.5, 1);
	petWindow.BackgroundTexture:SetHeight(self.PetHeight);
	petWindow.BackgroundTexture:SetWidth(self.PetWidth);
	petWindow.BackgroundTexture:SetPoint("TOPLEFT", 0, 0);

	self:SetupSpells(petWindow);
	petWindow:SetAttribute("unit", "player");

	return petWindow;
end;

function OrlanHeal:SetupSpells(window)
	window:RegisterForClicks("AnyDown");

	window:SetAttribute("*helpbutton1", "help1");
	window:SetAttribute("*helpbutton2", "help2");
	window:SetAttribute("*helpbutton3", "help3");

	window:SetAttribute("type-help1", "spell");
	window:SetAttribute("spell-help1", "Вспышка Света");

	window:SetAttribute("type-help2", "spell");
	window:SetAttribute("spell-help2", "Свет Небес");

	window:SetAttribute("type-help3", "spell");
	window:SetAttribute("spell-help3", "Длань защиты");

	window:SetAttribute("shift-type1", "target");
	window:SetAttribute("shift-type-help1", "target");

	window:SetAttribute("shift-type-help2", "spell");
	window:SetAttribute("shift-spell-help2", "Частица Света");

	window:SetAttribute("shift-type-help3", "spell");
	window:SetAttribute("shift-spell-help3", "Длань спасения");

	window:SetAttribute("ctrl-type-help1", "spell");
	window:SetAttribute("ctrl-spell-help1", "Длань жертвенности");

	window:SetAttribute("ctrl-type-help2", "spell");
	window:SetAttribute("ctrl-spell-help2", "Возложение рук");

	window:SetAttribute("ctrl-type3", "spell");
	window:SetAttribute("ctrl-type-help3", "spell");
	window:SetAttribute("ctrl-spell3", "Божественное вмешательство");
	window:SetAttribute("ctrl-spell-help3", "Божественное вмешательство");

	window:SetAttribute("alt-type-help1", "spell");
	window:SetAttribute("alt-spell-help1", "Очищение");

	window:SetAttribute("alt-type-help2", "spell");
	window:SetAttribute("alt-spell-help2", "Шок небес");
	
	window:SetAttribute("alt-type-help3", "spell");
	window:SetAttribute("alt-spell-help3", "Священный щит");
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
end;

OrlanHeal:Initialize("OrlanHealConfig");
