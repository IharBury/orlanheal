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
	elseif message == "v40" then
		OrlanHeal.VisibleGroupCount = 8;
	elseif message == "v25" then
		OrlanHeal.VisibleGroupCount = 5;
	elseif message == "v10" then
		OrlanHeal.VisibleGroupCount = 2;
	elseif message == "v5" then
		OrlanHeal.VisibleGroupCount = 1;
	elseif message == "setup" then
		OrlanHeal:Setup();
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
		if orlanHeal.RaidWindow:IsShown() then
			orlanHeal.ElapsedAfterUpdate = orlanHeal.ElapsedAfterUpdate + elapsed;
			if orlanHeal.ElapsedAfterUpdate > 0.1 then
				orlanHeal:UpdateStatus();
				orlanHeal.ElapsedAfterUpdate = 0;
			end;
		end;
	end;

	self.EventFrame:RegisterEvent("ADDON_LOADED");
	self.EventFrame:SetScript("OnEvent", self.EventFrame.HandleEvent);
	self.EventFrame:SetScript("OnUpdate", self.EventFrame.HandleUpdate);

	self.MaxGroupCount = 10;
	self.MaxVerticalGroupCount = math.floor((self.MaxGroupCount + 1) / 2);
	if self.MaxGroupCount == 1 then
		self.MaxHorizontalGroupCount = 1;
	else
		self.MaxHorizontalGroupCount = 2;
	end;

	self.Scale = 0.8;
	self.PetWidth = 81 * self.Scale;
	self.PetSpacing = 3 * self.Scale;
	self.PlayerWidth = 130 * self.Scale;
	self.PlayerHeight = 20 * self.Scale;
	self.BuffSize = self.PlayerHeight / 2;
	self.GroupOuterSpacing = 2 * self.Scale;
	self.PlayerInnerSpacing = 2 * self.Scale;
	self.GroupWidth = self.PlayerWidth + self.PetSpacing + self.PetWidth + self.GroupOuterSpacing * 2;
	self.GroupHeight = self.PlayerHeight * 5 + 
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
	self.PlayerStatusWidth = self.PlayerWidth - self.RangeWidth - self.BuffSize * 5;
	self.PetStatusWidth = self.PetWidth - self.RangeWidth - self.BuffSize * 2;
	self.HealthHeight = 4 * self.Scale;
	self.ManaHeight = 4 * self.Scale;
	self.NameHeight = self.PlayerHeight - self.ManaHeight - self.HealthHeight;
	self.NameFontHeight = self.NameHeight * 0.8;

	self.RaidAlpha = 0.2;
	self.GroupAlpha = 0.2;

	self.RaidWindowStrata = "LOW";
	self.RaidWindowName = "OrlanHeal_RaidWindow";
	self.SetupWindowName = "OrlanHeal_SetupWindow";

	self.GroupCount = 9;
	self.VisibleGroupCount = 9;
	self.IsInStartUpMode = true;

	self.HealingBuffs = {};
	self.HealingBuffs[66922] = true; -- чужая Вспышка Света
	self.HealingBuffs[774] = true; -- Омоложение
	self.HealingBuffs[1058] = true; -- Омоложение
	self.HealingBuffs[1430] = true; -- Омоложение
	self.HealingBuffs[2090] = true; -- Омоложение
	self.HealingBuffs[2091] = true; -- Омоложение
	self.HealingBuffs[3627] = true; -- Омоложение
	self.HealingBuffs[8910] = true; -- Омоложение
	self.HealingBuffs[9839] = true; -- Омоложение
	self.HealingBuffs[9840] = true; -- Омоложение
	self.HealingBuffs[9841] = true; -- Омоложение
	self.HealingBuffs[25299] = true; -- Омоложение
	self.HealingBuffs[26981] = true; -- Омоложение
	self.HealingBuffs[26982] = true; -- Омоложение
	self.HealingBuffs[48440] = true; -- Омоложение
	self.HealingBuffs[48441] = true; -- Омоложение
	self.HealingBuffs[33763] = true; -- Жизнецвет
	self.HealingBuffs[48450] = true; -- Жизнецвет
	self.HealingBuffs[48451] = true; -- Жизнецвет
	self.HealingBuffs[48438] = true; -- Буйный рост
	self.HealingBuffs[53248] = true; -- Буйный рост
	self.HealingBuffs[53249] = true; -- Буйный рост
	self.HealingBuffs[53251] = true; -- Буйный рост
	self.HealingBuffs[17] = true; -- Слово силы: Щит
	self.HealingBuffs[592] = true; -- Слово силы: Щит
	self.HealingBuffs[600] = true; -- Слово силы: Щит
	self.HealingBuffs[3747] = true; -- Слово силы: Щит
	self.HealingBuffs[6065] = true; -- Слово силы: Щит
	self.HealingBuffs[6066] = true; -- Слово силы: Щит
	self.HealingBuffs[10898] = true; -- Слово силы: Щит
	self.HealingBuffs[10899] = true; -- Слово силы: Щит
	self.HealingBuffs[10900] = true; -- Слово силы: Щит
	self.HealingBuffs[10901] = true; -- Слово силы: Щит
	self.HealingBuffs[25217] = true; -- Слово силы: Щит
	self.HealingBuffs[25218] = true; -- Слово силы: Щит
	self.HealingBuffs[48065] = true; -- Слово силы: Щит
	self.HealingBuffs[48066] = true; -- Слово силы: Щит
	self.HealingBuffs[47540] = true; -- Исповедь
	self.HealingBuffs[53005] = true; -- Исповедь
	self.HealingBuffs[53006] = true; -- Исповедь
	self.HealingBuffs[53007] = true; -- Исповедь
	self.HealingBuffs[139] = true; -- Обновление
	self.HealingBuffs[6074] = true; -- Обновление
	self.HealingBuffs[6075] = true; -- Обновление
	self.HealingBuffs[6076] = true; -- Обновление
	self.HealingBuffs[6077] = true; -- Обновление
	self.HealingBuffs[6078] = true; -- Обновление
	self.HealingBuffs[10927] = true; -- Обновление
	self.HealingBuffs[10928] = true; -- Обновление
	self.HealingBuffs[10929] = true; -- Обновление
	self.HealingBuffs[25315] = true; -- Обновление
	self.HealingBuffs[25221] = true; -- Обновление
	self.HealingBuffs[25222] = true; -- Обновление
	self.HealingBuffs[48067] = true; -- Обновление
	self.HealingBuffs[48068] = true; -- Обновление
	self.HealingBuffs[70772] = true; -- Благословенное исцеление
	self.HealingBuffs[41637] = true; -- Молитва восстановления
	self.HealingBuffs[41635] = true; -- Молитва восстановления
	self.HealingBuffs[48110] = true; -- Молитва восстановления
	self.HealingBuffs[48111] = true; -- Молитва восстановления
	self.HealingBuffs[44586] = true; -- Молитва восстановления
	self.HealingBuffs[974] = true; -- Щит земли
	self.HealingBuffs[32593] = true; -- Щит земли
	self.HealingBuffs[32594] = true; -- Щит земли
	self.HealingBuffs[49283] = true; -- Щит земли
	self.HealingBuffs[49284] = true; -- Щит земли
	self.HealingBuffs[61295] = true; -- Быстрина
	self.HealingBuffs[61299] = true; -- Быстрина
	self.HealingBuffs[61300] = true; -- Быстрина
	self.HealingBuffs[61301] = true; -- Быстрина
	self.HealingBuffs[28880] = true; -- Дар наару

	self.IgnoredDebuffs = {};
	self.IgnoredDebuffs[58539] = true; -- Тело наблюдателя
	self.IgnoredDebuffs[69127] = true; -- Холод Трона
	self.IgnoredDebuffs[64816] = true; -- Победа над нежитью
	self.IgnoredDebuffs[64815] = true; -- Победа над тауреном
	self.IgnoredDebuffs[64814] = true; -- Победа над человеком
	self.IgnoredDebuffs[64813] = true; -- Победа над эльфом крови
	self.IgnoredDebuffs[64812] = true; -- Победа над троллем
	self.IgnoredDebuffs[64811] = true; -- Победа над орком
	self.IgnoredDebuffs[64810] = true; -- Победа над дворфом
	self.IgnoredDebuffs[64809] = true; -- Победа над гномом
	self.IgnoredDebuffs[64808] = true; -- Победа над дренеем
	self.IgnoredDebuffs[64805] = true; -- Победа над эльфом
	self.IgnoredDebuffs[72144] = true; -- Шлейф оранжевой заразы
	self.IgnoredDebuffs[72145] = true; -- Шлейф зеленой заразы

	self.AvailableSpells = 
	{
		48932, -- Благословение могущества
		48934, -- Великое благословение могущества
		19752, -- Божественное вмешательство
		20217, -- Благословение королей
		25898, -- Великое благословение королей
		6940, -- Длань жертвенности
		10278, -- Длань защиты
		1044, -- Длань свободы
		1038, -- Длань спасения
		31789, -- Праведная защита
		48936, -- Благословение мудрости
		48938, -- Великое благословение мудрости
		48788, -- Возложение рук
		48785, -- Вспышка Света
		48950, -- Искупление
		4987, -- Очищение
		48782, -- Свет Небес
		53601, -- Священный щит
		53563, -- Частица Света
		48825 -- Шок небес
	};
end;

function OrlanHeal:CreateSetupWindow()
	local orlanHeal = self;

	local setupWindow = CreateFrame("Frame", self.SetupWindowName, UIParent);
	setupWindow:ClearAllPoints();
	setupWindow:SetPoint("CENTER", 0, 0);
	setupWindow:SetFrameStrata("DIALOG");
	setupWindow:SetBackdrop(
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
	setupWindow:SetHeight(340);
	setupWindow:SetWidth(450);
	setupWindow:Hide();

	local label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -8);
	label:SetText("LEFT");
	setupWindow.Spell1Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "Spell1", "1");
	setupWindow.Spell1Window:SetPoint("TOPLEFT", 100, 0);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -33);
	label:SetText("RIGHT");
	setupWindow.Spell2Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "Spell2", "2");
	setupWindow.Spell2Window:SetPoint("TOPLEFT", 100, -25);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -58);
	label:SetText("MIDDLE");
	setupWindow.Spell3Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "Spell3", "3");
	setupWindow.Spell3Window:SetPoint("TOPLEFT", 100, -50);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -83);
	label:SetText("ALT LEFT");
	setupWindow.AltSpell1Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "AltSpell1", "alt1");
	setupWindow.AltSpell1Window:SetPoint("TOPLEFT", 100, -75);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -108);
	label:SetText("ALT RIGHT");
	setupWindow.AltSpell2Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "AltSpell2", "alt2");
	setupWindow.AltSpell2Window:SetPoint("TOPLEFT", 100, -100);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -133);
	label:SetText("ALT MIDDLE");
	setupWindow.AltSpell3Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "AltSpell3", "alt3");
	setupWindow.AltSpell3Window:SetPoint("TOPLEFT", 100, -125);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -158);
	label:SetText("SHIFT LEFT");
	setupWindow.ShiftSpell1Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "ShiftSpell1", "shift1");
	setupWindow.ShiftSpell1Window:SetPoint("TOPLEFT", 100, -150);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -183);
	label:SetText("SHIFT RIGHT");
	setupWindow.ShiftSpell2Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "ShiftSpell2", "shift2");
	setupWindow.ShiftSpell2Window:SetPoint("TOPLEFT", 100, -175);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -208);
	label:SetText("SHIFT MIDDLE");
	setupWindow.ShiftSpell3Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "ShiftSpell3", "shift3");
	setupWindow.ShiftSpell3Window:SetPoint("TOPLEFT", 100, -200);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -233);
	label:SetText("CONTROL LEFT");
	setupWindow.ControlSpell1Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "ControlSpell1", "control1");
	setupWindow.ControlSpell1Window:SetPoint("TOPLEFT", 100, -225);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -258);
	label:SetText("CONTROL RIGHT");
	setupWindow.ControlSpell2Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "ControlSpell2", "control2");
	setupWindow.ControlSpell2Window:SetPoint("TOPLEFT", 100, -250);

	label = setupWindow:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -283);
	label:SetText("CONTROL MIDDLE");
	setupWindow.ControlSpell3Window = self:CreateSpellSelectWindow(setupWindow, self.SetupWindowName .. "_" .. "ControlSpell3", "control3");
	setupWindow.ControlSpell3Window:SetPoint("TOPLEFT", 100, -275);

	local okButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	okButton:SetText("OK");
	okButton:SetWidth(150);
	okButton:SetHeight(25);
	okButton:SetPoint("TOPLEFT", 50, -310);
	okButton:SetScript(
		"OnClick",
		function()
			orlanHeal:SaveSetup();
		end);

	local cancelButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	cancelButton:SetText("Cancel");
	cancelButton:SetWidth(150);	
	cancelButton:SetHeight(25);
	cancelButton:SetPoint("TOPLEFT", 250, -310);
	cancelButton:SetScript(
		"OnClick",
		function()
			orlanHeal:CancelSetup();
		end);

	return setupWindow;
end;

function OrlanHeal:CreateSpellSelectWindow(parent, name, button)
	local spellSelectWindow = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(spellSelectWindow, 300);
	spellSelectWindow.OrlanHeal = self;
	spellSelectWindow.button = button;

	return spellSelectWindow;
end;

function OrlanHeal:InitializeSpellSelectWindow(spellSelectWindow)
	UIDropDownMenu_Initialize(spellSelectWindow, self.HandleSpellInit);
end;

function OrlanHeal:HandleSpellInit(level)
	local info = {};
	info["func"] = self.OrlanHeal.HandleSpellSelect;
	info["arg1"] = self;

	info["text"] = "";
	info["value"] = "";
	info["arg2"] = "";
	UIDropDownMenu_AddButton(info, level);

	info["text"] = "Set as target";
	info["value"] = "target";
	info["arg2"] = "target";
	UIDropDownMenu_AddButton(info, level);

	local spellIndex = 1;
	while true do
		local spellId = self.OrlanHeal.AvailableSpells[spellIndex];
		if (not spellId) then
			break;
		end;

		local spellName = GetSpellInfo(spellId);

		info["text"] = spellName;
		info["value"] = spellId;
		info["arg2"] = spellId;

		UIDropDownMenu_AddButton(info, level);

		spellIndex = spellIndex + 1;
	end;

	UIDropDownMenu_SetSelectedValue(self, self.OrlanHeal.PendingConfig[self.button]);
end;

function OrlanHeal:HandleSpellSelect(spellWindow, value)
	spellWindow.OrlanHeal.PendingConfig[spellWindow.button] = value;
	UIDropDownMenu_SetSelectedValue(spellWindow, value);	
end;

function OrlanHeal:LoadSetup()
	self.Config["1"] = self.Config["1"] or 48785; -- Вспышка Света
	self.Config["2"] = self.Config["2"] or 48782; -- Свет Небес
	self.Config["3"] = self.Config["3"] or 10278; -- Длань защиты
	self.Config["shift1"] = self.Config["shift1"] or "target";
	self.Config["shift2"] = self.Config["shift2"] or 53563; -- Частица Света
	self.Config["shift3"] = self.Config["shift3"] or 1038; -- Длань спасения
	self.Config["control1"] = self.Config["control1"] or 6940; -- Длань жертвенности
	self.Config["control2"] = self.Config["control2"] or 48788; -- Возложение рук
	self.Config["control3"] = self.Config["control3"] or 19752; -- Божественное вмешательство
	self.Config["alt1"] = self.Config["alt1"] or 4987; -- Очищение
	self.Config["alt2"] = self.Config["alt2"] or 48825; -- Шок небес
	self.Config["alt3"] = self.Config["alt3"] or 53601; -- Священный щит
end;

function OrlanHeal:Setup()
	self.PendingConfig = {};
	for key, value in pairs(self.Config) do
		self.PendingConfig[key] = value;
	end;

	self:InitializeSpellSelectWindow(self.SetupWindow.Spell1Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.Spell2Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.Spell3Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.AltSpell1Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.AltSpell2Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.AltSpell3Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ShiftSpell1Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ShiftSpell2Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ShiftSpell3Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ControlSpell1Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ControlSpell2Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ControlSpell3Window);

	self.SetupWindow:Show();
end;

function OrlanHeal:CancelSetup()
	self.SetupWindow:Hide();
end;

function OrlanHeal:SaveSetup()
	if self:RequestNonCombat() then
		for key, value in pairs(self.PendingConfig) do
			self.Config[key] = value;
		end;

		self.SetupWindow:Hide();

		self:UpdateSpells();
	end;
end;

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

	function raidWindow:HandleDragStop()
		self:StopMovingOrSizing();
	end;

	raidWindow:ClearAllPoints();
	raidWindow:SetPoint("BOTTOMLEFT", 0, 0);
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
	self:CreateManaBar(playerWindow.Canvas, self.PlayerStatusWidth);
	self:CreateNameBar(playerWindow.Canvas, self.PlayerStatusWidth);
	self:CreateBuffs(playerWindow.Canvas, 4, 1, 3, 2);

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

function OrlanHeal:CreateBuffs(parent, specificBuffCount, otherBuffCount, specificDebuffCount, otherDebuffCount)
	if specificBuffCount > 0 then
		parent.SpecificBuffs = {};

		for buffIndex = 0, specificBuffCount - 1 do
			parent.SpecificBuffs[buffIndex] = self:CreateBuff(
				parent, 
				"TOPRIGHT", 
				-(otherBuffCount + specificBuffCount - 1 - buffIndex) * self.BuffSize);
		end;
	end;

	parent.OtherBuffs = {};

	for buffIndex = 0, otherBuffCount - 1 do
		parent.OtherBuffs[buffIndex] = self:CreateBuff(
			parent, 
			"TOPRIGHT", 
			-(otherBuffCount - 1 - buffIndex) * self.BuffSize);
	end;

	if specificDebuffCount > 0 then
		parent.SpecificDebuffs = {};

		for buffIndex = 0, specificDebuffCount - 1 do
			parent.SpecificDebuffs[buffIndex] = self:CreateBuff(
				parent, 
				"BOTTOMRIGHT", 
				-(otherDebuffCount + specificDebuffCount - 1 - buffIndex) * self.BuffSize);
		end;
	end;

	parent.OtherDebuffs = {};

	for buffIndex = 0, otherDebuffCount - 1 do
		parent.OtherDebuffs[buffIndex] = self:CreateBuff(
			parent, 
			"BOTTOMRIGHT", 
			-(otherDebuffCount - 1 - buffIndex) * self.BuffSize);
	end;
end;

function OrlanHeal:CreateBuff(parent, point, x)
	local buff = CreateFrame("Frame", nil, parent);
	buff:SetHeight(self.BuffSize);
	buff:SetWidth(self.BuffSize);
	buff:SetPoint(point, x, 0);

	buff.Texture = buff:CreateTexture();
	buff.Texture:SetHeight(self.BuffSize);
	buff.Texture:SetWidth(self.BuffSize);
	buff.Texture:SetPoint("TOPLEFT", 0, 0);

	return buff;
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
	rangeBar.BackgroundTexture:SetTexture(0.2, 0.2, 0.75, 1);
	rangeBar.BackgroundTexture:SetHeight(parent:GetHeight());
	rangeBar.BackgroundTexture:SetWidth(self.RangeWidth);
	rangeBar.BackgroundTexture:SetPoint("TOPLEFT", 0, 0);

	parent.RangeBar = rangeBar;
end;

function OrlanHeal:CreateNameBar(parent, width)
	parent.NameBar = CreateFrame("Frame", nil, parent);

	parent.NameBar:SetFrameStrata(self.RaidWindowStrata);
	parent.NameBar:SetHeight(self.NameHeight);
	parent.NameBar:SetWidth(width);
	parent.NameBar:SetPoint("TOPLEFT", self.RangeWidth, 0);

	parent.NameBar.Text = parent.NameBar:CreateFontString(nil, nil, "GameFontNormal");
	parent.NameBar.Text:SetHeight(self.NameHeight);
	parent.NameBar.Text:SetWidth(width);
	parent.NameBar.Text:SetPoint("TOPLEFT", 0, 0);
	parent.NameBar.Text:SetJustifyH("LEFT");
	parent.NameBar.Text:SetWordWrap(false);
	parent.NameBar.Text:SetTextHeight(self.NameFontHeight);
end;

function OrlanHeal:CreateHealthBar(parent, width)
	parent.HealthBar = CreateFrame("StatusBar", nil, parent);

	parent.HealthBar:SetFrameStrata(self.RaidWindowStrata);
	parent.HealthBar:SetHeight(self.HealthHeight);
	parent.HealthBar:SetWidth(width);
	parent.HealthBar:SetPoint("BOTTOMLEFT", self.RangeWidth, self.ManaHeight);
	parent.HealthBar:SetMinMaxValues(0, 100);
	parent.HealthBar:SetValue(100);

	parent.HealthBar.Texture = parent.HealthBar:CreateTexture();
	parent.HealthBar.Texture:SetTexture(0.2, 0.75, 0.2, 1);
	parent.HealthBar:SetStatusBarTexture(parent.HealthBar.Texture, "OVERLAY");

	parent.HealthBar.BackgroundTexture = parent.HealthBar:CreateTexture("BACKGROUND");
	parent.HealthBar.BackgroundTexture:SetTexture(0.4, 0.4, 0.4, 1);
	parent.HealthBar.BackgroundTexture:SetHeight(self.HealthHeight);
	parent.HealthBar.BackgroundTexture:SetWidth(width);
	parent.HealthBar.BackgroundTexture:SetPoint("TOPLEFT", 0, 0);
end;

function OrlanHeal:CreateManaBar(parent, width)
	parent.ManaBar = CreateFrame("StatusBar", nil, parent);

	parent.ManaBar:SetFrameStrata(self.RaidWindowStrata);
	parent.ManaBar:SetHeight(self.ManaHeight);
	parent.ManaBar:SetWidth(width);
	parent.ManaBar:SetPoint("BOTTOMLEFT", self.RangeWidth, 0);
	parent.ManaBar:SetMinMaxValues(0, 100);
	parent.ManaBar:SetValue(100);

	parent.ManaBar.Texture = parent.ManaBar:CreateTexture();
	parent.ManaBar.Texture:SetTexture(0.2, 0.2, 0.75, 1);
	parent.ManaBar:SetStatusBarTexture(parent.ManaBar.Texture, "OVERLAY");

	parent.ManaBar.BackgroundTexture = parent.ManaBar:CreateTexture("BACKGROUND");
	parent.ManaBar.BackgroundTexture:SetTexture(0.4, 0.4, 0.4, 1);
	parent.ManaBar.BackgroundTexture:SetHeight(self.ManaHeight);
	parent.ManaBar.BackgroundTexture:SetWidth(width);
	parent.ManaBar.BackgroundTexture:SetPoint("TOPLEFT", 0, 0);
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
	petWindow:SetHeight(self.PlayerHeight);
	petWindow:SetWidth(self.PetWidth);

	self:CreateUnitButton(petWindow);
	self:CreateBlankCanvas(petWindow);
	self:CreateRangeBar(petWindow.Canvas);
	self:CreateHealthBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateManaBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateNameBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateBuffs(petWindow.Canvas, 0, 2, 1, 1);

	return petWindow;
end;

function OrlanHeal:SetupSpells(button)
	button:RegisterForClicks("AnyDown");

	button:SetAttribute("*helpbutton1", "help1");
	button:SetAttribute("*helpbutton2", "help2");
	button:SetAttribute("*helpbutton3", "help3");

	self:SetAction(button, "", "1", self.Config["1"]);
	self:SetAction(button, "", "2", self.Config["2"]);
	self:SetAction(button, "", "3", self.Config["3"]);
	self:SetAction(button, "alt-", "1", self.Config["alt1"]);
	self:SetAction(button, "alt-", "2", self.Config["alt2"]);
	self:SetAction(button, "alt-", "3", self.Config["alt3"]);
	self:SetAction(button, "shift-", "1", self.Config["shift1"]);
	self:SetAction(button, "shift-", "2", self.Config["shift2"]);
	self:SetAction(button, "shift-", "3", self.Config["shift3"]);
	self:SetAction(button, "ctrl-", "1", self.Config["control1"]);
	self:SetAction(button, "ctrl-", "2", self.Config["control2"]);
	self:SetAction(button, "ctrl-", "3", self.Config["control3"]);
end;

function OrlanHeal:SetAction(button, prefix, mouseButton, action)
	if ((action == "") or (action == "target")) then
		button:SetAttribute(prefix .. "type" .. mouseButton, action);
		button:SetAttribute(prefix .. "type-help" .. mouseButton, action);
	else
		button:SetAttribute(prefix .. "type" .. mouseButton, "");
		button:SetAttribute(prefix .. "type-help" .. mouseButton, "spell");
		button:SetAttribute(prefix .. "spell-help" .. mouseButton, action);
	end;
end;

function OrlanHeal:HandleLoaded()
	_G[self.ConfigName] = _G[self.ConfigName] or {};
	self.Config = _G[self.ConfigName];

	self:LoadSetup();

	self.RaidWindow = self:CreateRaidWindow();
	self.SetupWindow = self:CreateSetupWindow();

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
		print("OrlanHeal: Cannot be done in combat.buff");
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
		self.VisibleGroupCount = newGroupCount;
		self.IsInStartUpMode = false;
		self:UpdateVisibleGroupCount();
		self:UpdateUnits();
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

	if self.IsInStartUpMode then
		for groupNumber = 1, (self.GroupCount - 1) * 5 do
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
		self:SetupParty(1);
		for groupNumber = 2, self.GroupCount do
			self:SetupEmptyGroup(groupNumber);
		end;
	end;
end;

function OrlanHeal:SetupRaidUnit(unitNumber, groupNumber, groupPlayerCounts)
	if (groupNumber ~= nil) and 
			(groupNumber ~= 0) and 
			(groupNumber <= self.GroupCount) and 
			(groupPlayerCounts[groupNumber] < 5) then
		groupPlayerCounts[groupNumber] = groupPlayerCounts[groupNumber] + 1;
		self:SetPlayerTarget(
			groupNumber, 
			groupPlayerCounts[groupNumber], 
			"raid" .. unitNumber, 
			"raidpet" .. unitNumber);
	end;
end;

function OrlanHeal:SetupFreeRaidSlot(unitNumber, groupPlayerCounts)
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

function OrlanHeal:SetupParty(groupNumber)
	self:SetPlayerTarget(groupNumber, 1, "player", "pet");
	for unitNumber = 1, 4 do
		self:SetPlayerTarget(groupNumber, unitNumber + 1, "party" .. unitNumber, "partypet" .. unitNumber);
	end;
end;

function OrlanHeal:SetupEmptyGroup(groupNumber)
	for groupPlayerNumber = 1, 5 do
		self:SetPlayerTarget(groupNumber, groupPlayerNumber, "", "");
	end;
end;

function OrlanHeal:UpdateStatus()
	for groupIndex = 0, self.GroupCount - 1 do
		for groupPlayerIndex = 0, 4 do
			local player = self.RaidWindow.Groups[groupIndex].Players[groupPlayerIndex];
			self:UpdateUnitStatus(player, groupIndex + 1);
			self:UpdateUnitStatus(player.Pet, nil);
		end;
	end;
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

		if UnitInBattleground("player") ~= nil then
	        if (UnitIsConnected(unit) ~= 1) or
                    (UnitIsCorpse(unit) == 1) or 
                    (UnitIsDeadOrGhost(unit) == 1) or
                    (IsSpellInRange(GetSpellInfo(53563), unit) ~= 1) or -- Частица Света
                    (UnitCanAssist("player", unit) ~= 1) then
                window.Canvas:Hide();
                return;
            end;
        end;

		window.Canvas:Show();

		self:UpdateBackground(window.Canvas.BackgroundTexture, unit);
		self:UpdateRange(window.Canvas.RangeBar, unit);
		self:UpdateHealth(window.Canvas.HealthBar, unit);
		self:UpdateMana(window.Canvas.ManaBar, unit);
		self:UpdateName(window.Canvas.NameBar, unit, displayedGroup);
		self:UpdateBuffs(window.Canvas, unit);
		self:UpdateDebuffs(window.Canvas, unit);
	end;
end;

function OrlanHeal:UpdateBackground(background, unit)
	if UnitIsConnected(unit) ~= 1 then
		background:SetTexture(0, 0, 0, 1);
	elseif (UnitIsCorpse(unit) == 1) or (UnitIsDeadOrGhost(unit) == 1) then
		background:SetTexture(0.1, 0.1, 0.1, 1);
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

function OrlanHeal:UpdateRange(rangeBar, unit)
	if UnitIsConnected(unit) ~= 1 then
		rangeBar.BackgroundTexture:SetTexture(0, 0, 0, 1);
	elseif (UnitIsCorpse(unit) == 1) or (UnitIsDeadOrGhost(unit) == 1) then
		rangeBar.BackgroundTexture:SetTexture(0.4, 0.4, 0.4, 1);
	elseif (IsSpellInRange(GetSpellInfo(53563), unit) ~= 1) or (UnitCanAssist("player", unit) ~= 1) then -- Частица Света
		rangeBar.BackgroundTexture:SetTexture(0.2, 0.2, 0.75, 1);
	elseif IsSpellInRange(GetSpellInfo(48785), unit) ~= 1 then -- Вспышка Света
		rangeBar.BackgroundTexture:SetTexture(0.75, 0.2, 0.2, 1);
	elseif IsSpellInRange(GetSpellInfo(1038), unit) ~= 1 then -- Длань Спасения
		rangeBar.BackgroundTexture:SetTexture(0.75, 0.45, 0.2, 1);
	elseif CheckInteractDistance(unit, 2) ~= 1 then
		rangeBar.BackgroundTexture:SetTexture(0.75, 0.75, 0.2, 1);
	else
		rangeBar.BackgroundTexture:SetTexture(0.2, 0.75, 0.2, 1);
	end;
end;

function OrlanHeal:UpdateHealth(healthBar, unit)
	local health = UnitHealth(unit);
	local maxHealth = UnitHealthMax(unit);

	healthBar:SetMinMaxValues(0, maxHealth);
	healthBar:SetValue(health);

	if UnitIsConnected(unit) ~= 1 then
		healthBar.Texture:SetTexture(0, 0, 0, 1);
	else
		healthBar.Texture:SetTexture(0.2, 0.75, 0.2, 1);
	end;
end;

function OrlanHeal:UpdateMana(manaBar, unit)
	if (UnitPowerType(unit) == 0) and (UnitIsConnected(unit) == 1) then
		manaBar:Show();
		manaBar:SetMinMaxValues(0, UnitPowerMax(unit, 0));
		manaBar:SetValue(UnitPower(unit, 0));
	else
		manaBar:Hide();
	end;
end;

function OrlanHeal:UpdateName(nameBar, unit, displayedGroup)
	local text = GetUnitName(unit, false);

	if (displayedGroup ~= nil) and (string.sub(unit, 1, 4) == "raid") then
		local _, _, groupNumber = GetRaidRosterInfo(string.sub(unit, 5));
		if displayedGroup ~= groupNumber then
			text = "[" .. groupNumber .. "] " .. text;
		end;
	end;

	nameBar.Text:SetText(text);
	local _, class = UnitClassBase(unit);
	local classColor = RAID_CLASS_COLORS[class];
	if classColor == nil then
		classColor = { r = 0.4, g = 0.4, b = 0.4 };
	end;
	nameBar.Text:SetTextColor(classColor.r, classColor.g, classColor.b, 1);
end;

function OrlanHeal:UpdateBuffs(canvas, unit)
	local goodBuffCount = 0;
	local goodBuffs = {};
	local buffIndex = 1;
	while true do
		local name, _, icon, count, _, duration, expires, caster, _, shouldConsolidate, spellId = 
			UnitAura(unit, buffIndex, "HELPFUL");
		if name == nil then break; end;

		local buffKind;
		if spellId == 53601 then -- Священный щит
			buffKind = 1;
		elseif (spellId == 66922) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) then -- своя Вспышка Света
			buffKind = 2;
		elseif (self.HealingBuffs[spellId]) then
			buffKind = 3;
		elseif (spellId == 53563) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) or -- своя Частица Света
			(spellId == 1022) or -- Длань защиты
			(spellId == 5599) or -- Длань защиты
			(spellId == 10278) or -- Длань защиты
			(spellId == 1038) then -- Длань спасения
			buffKind = 4;
		elseif (spellId == 53563) then -- чужая Частица Света
			buffKind = 3;
		elseif shouldConsolidate == 1 then
			buffKind = nil;
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
		if canvas.SpecificBuffs[0] ~= nill then
			self:ShowBuff(canvas.SpecificBuffs[0], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, 1));
		end;

		if canvas.SpecificBuffs[1] ~= nill then
			self:ShowBuff(canvas.SpecificBuffs[1], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, 2));
		end;

		if canvas.SpecificBuffs[2] ~= nill then
			self:ShowBuff(canvas.SpecificBuffs[2], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, 3));
		end;

		if canvas.SpecificBuffs[3] ~= nill then
			self:ShowBuff(canvas.SpecificBuffs[3], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, 4));
		end;
	end;

	if canvas.OtherBuffs[0] ~= nill then
		self:ShowBuff(canvas.OtherBuffs[0], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, nil));
	end;

	if canvas.OtherBuffs[1] ~= nill then
		self:ShowBuff(canvas.OtherBuffs[1], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, nil));
	end;
end;

function OrlanHeal:UpdateDebuffs(canvas, unit)
	local goodBuffCount = 0;
	local goodBuffs = {};
	local buffIndex = 1;
	local canAssist = UnitCanAssist("player", unit) == 1;
	while true do
		local name, _, icon, count, dispelType, duration, expires, _, _, _, spellId = UnitAura(unit, buffIndex, "HARMFUL");
		if name == nil then break; end;

		local buffKind;
		if ((dispelType == "Disease") or (dispelType == "Magic") or (dispelType == "Poison")) and canAssist then
			buffKind = 1;
		elseif (dispelType == "Curse") and canAssist then
			buffKind = 2;
		elseif (self.IgnoredDebuffs[spellId]) then
			buffKind = nil;
		elseif canAssist then
			buffKind = 3;
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

	if canvas.SpecificDebuffs ~= nil then
		if canvas.SpecificDebuffs[0] ~= nill then
			self:ShowBuff(canvas.SpecificDebuffs[0], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, 1));
		end;

		if canvas.SpecificDebuffs[1] ~= nill then
			self:ShowBuff(canvas.SpecificDebuffs[1], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, 1));
		end;

		if canvas.SpecificDebuffs[2] ~= nill then
			self:ShowBuff(canvas.SpecificDebuffs[2], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, 2));
		end;
	end;

	if canvas.OtherDebuffs[2] ~= nill then
		self:ShowBuff(canvas.OtherDebuffs[2], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, nil));
	end;

	if canvas.OtherDebuffs[1] ~= nill then
		self:ShowBuff(canvas.OtherDebuffs[1], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, nil));
	end;

	if canvas.OtherDebuffs[0] ~= nill then
		self:ShowBuff(canvas.OtherDebuffs[0], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, nil));
	end;
end;

function OrlanHeal:GetLastBuffOfKind(buffs, buffCount, kind)
	for index = buffCount, 1, -1 do
		if (buffs[index] ~= nil) and ((kind == nil) or (buffs[index].Kind == kind)) then
			local result = buffs[index];
			buffs[index] = nil;
			return result;
		end;
	end;

	return nil;
end;

function OrlanHeal:ShowBuff(window, buff)
	if buff == nil then
		window:Hide();
	else
		window:Show();
		window.Texture:SetTexture(buff.Icon);

        if buff.Expires <= GetTime() + 3 then
            window.Texture:SetVertexColor(1, 0.5, 0.5, 0.5);
        elseif buff.Expires <= GetTime() + 6 then
            window.Texture:SetVertexColor(1, 1, 0.5, 0.75);
        else
            window.Texture:SetVertexColor(1, 1, 1, 1);
        end;
	end;
end;

OrlanHeal:Initialize("OrlanHealConfig");
