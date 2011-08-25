function OrlanHeal:CreateSetupWindow()
	local orlanHeal = self;

	local setupWindow = CreateFrame("Frame", self.SetupWindowName, UIParent);
	setupWindow:SetPoint("CENTER", 0, 0);
	setupWindow:SetFrameStrata("DIALOG");

	local background = setupWindow:CreateTexture();
	background:SetAllPoints();
	background:SetTexture(0, 0, 0, 0.6);

	setupWindow:SetHeight(560);
	setupWindow:SetWidth(450);
	setupWindow:Hide();

	setupWindow.Spell1Window = self:CreateSpellSelectWindow(setupWindow, "Spell1", "1", 0, "LEFT");
	setupWindow.Spell2Window = self:CreateSpellSelectWindow(setupWindow, "Spell2", "2", 1, "RIGHT");
	setupWindow.Spell3Window = self:CreateSpellSelectWindow(setupWindow, "Spell3", "3", 2, "MIDDLE");
	setupWindow.Spell4Window = self:CreateSpellSelectWindow(setupWindow, "Spell4", "4", 3, "BTN4");
	setupWindow.Spell5Window = self:CreateSpellSelectWindow(setupWindow, "Spell5", "5", 4, "BTN5");
	setupWindow.AltSpell1Window = self:CreateSpellSelectWindow(setupWindow, "AltSpell1", "alt1", 5, "ALT LEFT");
	setupWindow.AltSpell2Window = self:CreateSpellSelectWindow(setupWindow, "AltSpell2", "alt2", 6, "ALT RIGHT");
	setupWindow.AltSpell3Window = self:CreateSpellSelectWindow(setupWindow, "AltSpell3", "alt3", 7, "ALT MIDDLE");
	setupWindow.AltSpell4Window = self:CreateSpellSelectWindow(setupWindow, "AltSpell4", "alt4", 8, "ALT BTN4");
	setupWindow.AltSpell5Window = self:CreateSpellSelectWindow(setupWindow, "AltSpell5", "alt5", 9, "ALT BTN5");
	setupWindow.ShiftSpell1Window = self:CreateSpellSelectWindow(setupWindow, "ShiftSpell1", "shift1", 10, "SHIFT LEFT");
	setupWindow.ShiftSpell2Window = self:CreateSpellSelectWindow(setupWindow, "ShiftSpell2", "shift2", 11, "SHIFT RIGHT");
	setupWindow.ShiftSpell3Window = self:CreateSpellSelectWindow(setupWindow, "ShiftSpell3", "shift3", 12, "SHIFT MIDDLE");
	setupWindow.ShiftSpell4Window = self:CreateSpellSelectWindow(setupWindow, "ShiftSpell4", "shift4", 13, "SHIFT BTN4");
	setupWindow.ShiftSpell5Window = self:CreateSpellSelectWindow(setupWindow, "ShiftSpell5", "shift5", 14, "SHIFT BTN5");
	setupWindow.ControlSpell1Window = self:CreateSpellSelectWindow(setupWindow, "ControlSpell1", "control1", 15, "CONTROL LEFT");
	setupWindow.ControlSpell2Window = self:CreateSpellSelectWindow(setupWindow, "ControlSpell2", "control2", 16, "CONTROL RIGHT");
	setupWindow.ControlSpell3Window = self:CreateSpellSelectWindow(setupWindow, "ControlSpell3", "control3", 17, "CONTROL MIDDLE");
	setupWindow.ControlSpell4Window = self:CreateSpellSelectWindow(setupWindow, "ControlSpell4", "control4", 18, "CONTROL BTN4");
	setupWindow.ControlSpell5Window = self:CreateSpellSelectWindow(setupWindow, "ControlSpell5", "control5", 19, "CONTROL BTN5");
	setupWindow.SizeWindow = self:CreateSizeSelectWindow(setupWindow, 20);

	local okButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	okButton:SetText("OK");
	okButton:SetWidth(150);
	okButton:SetHeight(25);
	okButton:SetPoint("TOPLEFT", 50, -530);
	okButton:SetScript(
		"OnClick",
		function()
			orlanHeal:SaveSetup();
		end);

	local cancelButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	cancelButton:SetText("Cancel");
	cancelButton:SetWidth(150);	
	cancelButton:SetHeight(25);
	cancelButton:SetPoint("TOPLEFT", 250, -530);
	cancelButton:SetScript(
		"OnClick",
		function()
			orlanHeal:CancelSetup();
		end);

	return setupWindow;
end;

function OrlanHeal:CreateSpellSelectWindow(parent, nameSuffix, button, index, caption)
	local label = parent:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -8 - index * 25);
	label:SetText(caption);

	local spellSelectWindow = CreateFrame("Frame", self.SetupWindowName .. "_" .. nameSuffix, parent, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(spellSelectWindow, 300);
	spellSelectWindow.OrlanHeal = self;
	spellSelectWindow.button = button;
	spellSelectWindow:SetPoint("TOPLEFT", 100, -index * 25);

	return spellSelectWindow;
end;

function OrlanHeal:CreateSizeSelectWindow(parent, index)
	local label = parent:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPLEFT", 5, -8 - index * 25);
	label:SetText("SIZE");

	local sizeSelectWindow = CreateFrame("Slider", self.SetupWindowName .. "_Size", parent, "OptionsSliderTemplate");
	sizeSelectWindow:SetWidth(300);
	sizeSelectWindow:SetHeight(20);
	sizeSelectWindow:SetOrientation('HORIZONTAL');
	sizeSelectWindow:SetMinMaxValues(500, 2000);
	sizeSelectWindow.OrlanHeal = self;
	sizeSelectWindow:SetPoint("TOPLEFT", 125, -index * 25);

	return sizeSelectWindow;
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
		local spellId = self.OrlanHeal.Class.AvailableSpells[spellIndex];
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
	self.Config["1"] = self.Config["1"] or 635; -- Holy Light
	self.Config["2"] = self.Config["2"] or 19750; -- Flash of Light
	self.Config["3"] = self.Config["3"] or 1022; -- Hand of Protection
	self.Config["4"] = self.Config["4"] or "";
	self.Config["5"] = self.Config["5"] or "";
	self.Config["shift1"] = self.Config["shift1"] or "target";
	self.Config["shift2"] = self.Config["shift2"] or 53563; -- Beacon of Light
	self.Config["shift3"] = self.Config["shift3"] or 1038; -- Hand of Salvation
	self.Config["shift4"] = self.Config["shift4"] or "";
	self.Config["shift5"] = self.Config["shift5"] or "";
	self.Config["control1"] = self.Config["control1"] or 82326; -- Divine Light
	self.Config["control2"] = self.Config["control2"] or 85673; -- Word of Glory
	self.Config["control3"] = self.Config["control3"] or 6940; -- Hand of Sacrifice
	self.Config["control4"] = self.Config["control4"] or "";
	self.Config["control5"] = self.Config["control5"] or "";
	self.Config["alt1"] = self.Config["alt1"] or 4987; -- Cleanse
	self.Config["alt2"] = self.Config["alt2"] or 20473; -- Holy Shock
	self.Config["alt3"] = self.Config["alt3"] or 633; -- Lay on Hands
	self.Config["alt4"] = self.Config["alt4"] or "";
	self.Config["alt5"] = self.Config["alt5"] or "";
	self.Config.Size = self.Config.Size or 1;
end;

function OrlanHeal:Setup()
	self.PendingConfig = {};
	for key, value in pairs(self.Config) do
		self.PendingConfig[key] = value;
	end;

	self:InitializeSpellSelectWindow(self.SetupWindow.Spell1Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.Spell2Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.Spell3Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.Spell4Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.Spell5Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.AltSpell1Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.AltSpell2Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.AltSpell3Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.AltSpell4Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.AltSpell5Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ShiftSpell1Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ShiftSpell2Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ShiftSpell3Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ShiftSpell4Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ShiftSpell5Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ControlSpell1Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ControlSpell2Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ControlSpell3Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ControlSpell4Window);
	self:InitializeSpellSelectWindow(self.SetupWindow.ControlSpell5Window);
	self.SetupWindow.SizeWindow:SetValue(self.RaidWindow:GetScale() / self.Scale * 1000);

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

		self.Config.Size = self.SetupWindow.SizeWindow:GetValue() / 1000;
		self.RaidWindow:SetScale(self.Config.Size * self.Scale);

		self.SetupWindow:Hide();

		self:UpdateSpells();
	end;
end;
