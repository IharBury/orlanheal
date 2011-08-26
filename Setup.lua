function OrlanHeal:CreateSetupWindow()
	local orlanHeal = self;

	local setupWindow = CreateFrame("Frame", self.SetupWindowName, UIParent);
	setupWindow:SetPoint("CENTER", 0, 0);
	setupWindow:SetFrameStrata("DIALOG");

	local background = setupWindow:CreateTexture();
	background:SetAllPoints();
	background:SetTexture(0, 0, 0, 0.6);

	setupWindow:SetHeight(self.SetupWindowHeight);
	setupWindow:SetWidth(self.SetupWindowWidth);
	setupWindow:Hide();

	local setupScrollWindowContainer = CreateFrame("ScrollFrame", self.SetupWindowName .. "_SCROLL", setupWindow);
	setupScrollWindowContainer:SetPoint("TOPLEFT", 0, 0);
	setupScrollWindowContainer:SetPoint("BOTTOMRIGHT", -18, 40);

	local setupScrollWindow = CreateFrame("Frame");
	setupScrollWindow:SetHeight(1);
	setupScrollWindow:SetWidth(self.SetupWindowWidth - 18);
	setupScrollWindowContainer:SetScrollChild(setupScrollWindow);

	local setupWindowSlider = CreateFrame(
		"Slider", 
		self.SetupWindowName .. "_SLIDER", 
		setupScrollWindowContainer, 
		"UIPanelScrollBarTemplate");
	setupWindowSlider:SetPoint("TOPLEFT", setupScrollWindowContainer, "TOPRIGHT", 0, -16);
	setupWindowSlider:SetPoint("BOTTOMLEFT", setupScrollWindowContainer, "BOTTOMRIGHT", 0, 16);
	setupWindowSlider:SetOrientation("VERTICAL");

	setupScrollWindowContainer:SetScript(
		"OnScrollRangeChanged",
		function()
			setupWindowSlider:SetMinMaxValues(0, setupScrollWindowContainer:GetVerticalScrollRange());
			setupWindowSlider:SetValue(setupScrollWindowContainer:GetVerticalScroll());
		end);

	setupWindow.ControlCount = 0;
	setupWindow.SpellSelectWindows = {};
	setupWindow.CooldownSelectWindows = {};
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "Spell1", "1", "LEFT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "Spell2", "2", "RIGHT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "Spell3", "3", "MIDDLE");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "Spell4", "4", "BUTTON4");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "Spell5", "5", "BUTTON5");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltSpell1", "alt1", "ALT LEFT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltSpell2", "alt2", "ALT RIGHT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltSpell3", "alt3", "ALT MIDDLE");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltSpell4", "alt4", "ALT BUTTON4");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltSpell5", "alt5", "ALT BUTTON5");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ShiftSpell1", "shift1", "SHIFT LEFT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ShiftSpell2", "shift2", "SHIFT RIGHT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ShiftSpell3", "shift3", "SHIFT MIDDLE");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ShiftSpell4", "shift4", "SHIFT BUTTON4");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ShiftSpell5", "shift5", "SHIFT BUTTON5");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlSpell1", "control1", "CONTROL LEFT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlSpell2", "control2", "CONTROL RIGHT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlSpell3", "control3", "CONTROL MIDDLE");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlSpell4", "control4", "CONTROL BUTTON4");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlSpell5", "control5", "CONTROL BUTTON5");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltShiftSpell1", "altshift1", "ALT SHIFT LEFT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltShiftSpell2", "altshift2", "ALT SHIFT RIGHT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltShiftSpell3", "altshift3", "ALT SHIFT MIDDLE");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltShiftSpell4", "altshift4", "ALT SHIFT BUTTON4");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "AltShiftSpell5", "altshift5", "ALT SHIFT BUTTON5");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltSpell1", "controlalt1", "CONTROL ALT LEFT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltSpell2", "controlalt2", "CONTROL ALT RIGHT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltSpell3", "controlalt3", "CONTROL ALT MIDDLE");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltSpell4", "controlalt4", "CONTROL ALT BUTTON4");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltSpell5", "controlalt5", "CONTROL ALT BUTTON5");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlShiftSpell1", "controlshift1", "CONTROL SHIFT LEFT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlShiftSpell2", "controlshift2", "CONTROL SHIFT RIGHT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlShiftSpell3", "controlshift3", "CONTROL SHIFT MIDDLE");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlShiftSpell4", "controlshift4", "CONTROL SHIFT BUTTON4");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlShiftSpell5", "controlshift5", "CONTROL SHIFT BUTTON5");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltShiftSpell1", "controlaltshift1", "CONTROL ALT SHIFT LEFT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltShiftSpell2", "controlaltshift2", "CONTROL ALT SHIFT RIGHT");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltShiftSpell3", "controlaltshift3", "CONTROL ALT SHIFT MIDDLE");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltShiftSpell4", "controlaltshift4", "CONTROL ALT SHIFT BUTTON4");
	self:CreateSpellSelectWindow(setupWindow, setupScrollWindow, "ControlAltShiftSpell5", "controlaltshift5", "CONTROL ALT SHIFT BUTTON5");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown1", "cooldown1", "COOLDOWN 1");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown2", "cooldown2", "COOLDOWN 2");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown3", "cooldown3", "COOLDOWN 3");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown4", "cooldown4", "COOLDOWN 4");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown5", "cooldown5", "COOLDOWN 5");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown6", "cooldown6", "COOLDOWN 6");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown7", "cooldown7", "COOLDOWN 7");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown8", "cooldown8", "COOLDOWN 8");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown9", "cooldown9", "COOLDOWN 9");
	self:CreateCooldownSelectWindow(setupWindow, setupScrollWindow, "Cooldown10", "cooldown10", "COOLDOWN 10");
	setupWindow.SizeWindow = self:CreateSizeSelectWindow(setupWindow, setupScrollWindow);

	local okButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	okButton:SetText("OK");
	okButton:SetWidth(150);
	okButton:SetHeight(25);
	okButton:SetPoint("TOPLEFT", setupWindow, "BOTTOMLEFT", 50, 30);
	okButton:SetScript(
		"OnClick",
		function()
			orlanHeal:SaveSetup();
		end);

	local cancelButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	cancelButton:SetText("Cancel");
	cancelButton:SetWidth(150);	
	cancelButton:SetHeight(25);
	cancelButton:SetPoint("TOPRIGHT", setupWindow, "BOTTOMRIGHT", -50, 30);
	cancelButton:SetScript(
		"OnClick",
		function()
			orlanHeal:CancelSetup();
		end);

	return setupWindow;
end;

function OrlanHeal:CreateSpellSelectWindow(setupWindow, parent, nameSuffix, button, caption)
	local label = parent:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPRIGHT", parent, "TOPLEFT", self.SetupWindowLabelWidth - 5, -8 - setupWindow.ControlCount * 25);
	label:SetText(caption);

	local spellSelectWindow = CreateFrame("Frame", self.SetupWindowName .. "_" .. nameSuffix, parent, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(spellSelectWindow, self.SetupWindowValueWidth - 5);
	spellSelectWindow.OrlanHeal = self;
	spellSelectWindow.button = button;
	spellSelectWindow:SetPoint("TOPLEFT", self.SetupWindowLabelWidth - 20, -setupWindow.ControlCount * 25);

	setupWindow.SpellSelectWindows[setupWindow.ControlCount] = spellSelectWindow;
	setupWindow.ControlCount = setupWindow.ControlCount + 1;
end;

function OrlanHeal:CreateCooldownSelectWindow(setupWindow, parent, nameSuffix, cooldown, caption)
	local label = parent:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPRIGHT", parent, "TOPLEFT", self.SetupWindowLabelWidth - 5, -8 - setupWindow.ControlCount * 25);
	label:SetText(caption);

	local cooldownSelectWindow = CreateFrame("Frame", self.SetupWindowName .. "_" .. nameSuffix, parent, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(cooldownSelectWindow, self.SetupWindowValueWidth - 5);
	cooldownSelectWindow.OrlanHeal = self;
	cooldownSelectWindow.cooldown = cooldown;
	cooldownSelectWindow:SetPoint("TOPLEFT", self.SetupWindowLabelWidth - 20, -setupWindow.ControlCount * 25);

	setupWindow.CooldownSelectWindows[setupWindow.ControlCount] = cooldownSelectWindow;
	setupWindow.ControlCount = setupWindow.ControlCount + 1;
end;

function OrlanHeal:CreateSizeSelectWindow(setupWindow, parent)
	local label = parent:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPRIGHT", parent, "TOPLEFT", self.SetupWindowLabelWidth - 5, -8 - setupWindow.ControlCount * 25);
	label:SetText("SIZE");

	local sizeSelectWindow = CreateFrame("Slider", self.SetupWindowName .. "_Size", parent, "OptionsSliderTemplate");
	sizeSelectWindow:SetWidth(self.SetupWindowValueWidth);
	sizeSelectWindow:SetHeight(20);
	sizeSelectWindow:SetOrientation('HORIZONTAL');
	sizeSelectWindow:SetMinMaxValues(500, 2000);
	sizeSelectWindow.OrlanHeal = self;
	sizeSelectWindow:SetPoint("TOPLEFT", self.SetupWindowLabelWidth, -setupWindow.ControlCount * 25);

	setupWindow.ControlCount = setupWindow.ControlCount + 1;
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

function OrlanHeal:InitializeCooldownSelectWindow(cooldownSelectWindow)
	UIDropDownMenu_Initialize(cooldownSelectWindow, self.HandleCooldownInit);
end;

function OrlanHeal:HandleCooldownInit(level)
	local info = {};
	info["func"] = self.OrlanHeal.HandleCooldownSelect;
	info["arg1"] = self;

	info["text"] = "";
	info["value"] = "";
	info["arg2"] = "";
	UIDropDownMenu_AddButton(info, level);

	for key, cooldown in pairs(self.OrlanHeal.CommonCooldownOptions) do
		self.OrlanHeal:AddCooldownOption(info, level, key, cooldown);
	end;

	if self.OrlanHeal.Class.CooldownOptions then
		for key, cooldown in pairs(self.OrlanHeal.Class.CooldownOptions) do
			self.OrlanHeal:AddCooldownOption(info, level, key, cooldown);
		end;
	end;

	UIDropDownMenu_SetSelectedValue(self, self.OrlanHeal.PendingConfig[self.cooldown]);
end;

function OrlanHeal:AddCooldownOption(info, level, key, cooldown)
	if not cooldown.IsAvailable or cooldown.IsAvailable(self) then
		local spellName = GetSpellInfo(cooldown.AuraId or cooldown.SpellId);
		info["text"] = spellName;
		info["value"] = key;
		info["arg2"] = key;
		UIDropDownMenu_AddButton(info, level);
	end;
end;

function OrlanHeal:HandleCooldownSelect(cooldownWindow, value)
	cooldownWindow.OrlanHeal.PendingConfig[cooldownWindow.cooldown] = value;
	UIDropDownMenu_SetSelectedValue(cooldownWindow, value);	
end;

function OrlanHeal:LoadSetup()
	if self.Class.LoadSetup then
		self.Class.LoadSetup(self);
	end;

	self.Config["1"] = self.Config["1"] or "";
	self.Config["2"] = self.Config["2"] or "";
	self.Config["3"] = self.Config["3"] or "";
	self.Config["4"] = self.Config["4"] or "";
	self.Config["5"] = self.Config["5"] or "";
	self.Config["shift1"] = self.Config["shift1"] or "target";
	self.Config["shift2"] = self.Config["shift2"] or "";
	self.Config["shift3"] = self.Config["shift3"] or "";
	self.Config["shift4"] = self.Config["shift4"] or "";
	self.Config["shift5"] = self.Config["shift5"] or "";
	self.Config["control1"] = self.Config["control1"] or "";
	self.Config["control2"] = self.Config["control2"] or "";
	self.Config["control3"] = self.Config["control3"] or "";
	self.Config["control4"] = self.Config["control4"] or "";
	self.Config["control5"] = self.Config["control5"] or "";
	self.Config["alt1"] = self.Config["alt1"] or "";
	self.Config["alt2"] = self.Config["alt2"] or "";
	self.Config["alt3"] = self.Config["alt3"] or "";
	self.Config["alt4"] = self.Config["alt4"] or "";
	self.Config["alt5"] = self.Config["alt5"] or "";
	self.Config["controlalt1"] = self.Config["controlalt1"] or "";
	self.Config["controlalt2"] = self.Config["controlalt2"] or "";
	self.Config["controlalt3"] = self.Config["controlalt3"] or "";
	self.Config["controlalt4"] = self.Config["controlalt4"] or "";
	self.Config["controlalt5"] = self.Config["controlalt5"] or "";
	self.Config["controlshift1"] = self.Config["controlshift1"] or "";
	self.Config["controlshift2"] = self.Config["controlshift2"] or "";
	self.Config["controlshift3"] = self.Config["controlshift3"] or "";
	self.Config["controlshift4"] = self.Config["controlshift4"] or "";
	self.Config["controlshift5"] = self.Config["controlshift5"] or "";
	self.Config["altshift1"] = self.Config["altshift1"] or "";
	self.Config["altshift2"] = self.Config["altshift2"] or "";
	self.Config["altshift3"] = self.Config["altshift3"] or "";
	self.Config["altshift4"] = self.Config["altshift4"] or "";
	self.Config["altshift5"] = self.Config["altshift5"] or "";
	self.Config["controlaltshift1"] = self.Config["controlaltshift1"] or "";
	self.Config["controlaltshift2"] = self.Config["controlaltshift2"] or "";
	self.Config["controlaltshift3"] = self.Config["controlaltshift3"] or "";
	self.Config["controlaltshift4"] = self.Config["controlaltshift4"] or "";
	self.Config["controlaltshift5"] = self.Config["controlaltshift5"] or "";
	self.Config.Size = self.Config.Size or 1;

	self.Config["cooldown1"] = self.Config["cooldown1"] or "";
	self.Config["cooldown2"] = self.Config["cooldown2"] or "";
	self.Config["cooldown3"] = self.Config["cooldown3"] or "";
	self.Config["cooldown4"] = self.Config["cooldown4"] or "";
	self.Config["cooldown5"] = self.Config["cooldown5"] or "";
	self.Config["cooldown6"] = self.Config["cooldown6"] or "";
	self.Config["cooldown7"] = self.Config["cooldown7"] or "";
	self.Config["cooldown8"] = self.Config["cooldown8"] or "";
	self.Config["cooldown9"] = self.Config["cooldown9"] or "";
	self.Config["cooldown10"] = self.Config["cooldown10"] or "";
end;

function OrlanHeal:Setup()
	self.PendingConfig = {};
	for key, value in pairs(self.Config) do
		self.PendingConfig[key] = value;
	end;

	for spellSelectWindowIndex = 0, self.SetupWindow.ControlCount do
		if self.SetupWindow.SpellSelectWindows[spellSelectWindowIndex] then
			self:InitializeSpellSelectWindow(self.SetupWindow.SpellSelectWindows[spellSelectWindowIndex]);
		end;
	end;
	for cooldownSelectWindowIndex = 0, self.SetupWindow.ControlCount do
		if self.SetupWindow.CooldownSelectWindows[cooldownSelectWindowIndex] then
			self:InitializeCooldownSelectWindow(self.SetupWindow.CooldownSelectWindows[cooldownSelectWindowIndex]);
		end;
	end;
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
		self:SetupCooldowns();
	end;
end;
