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
	for hasControl = 0, 1 do
		for hasShift = 0, 1 do
			for hasAlt = 0, 1 do
				for buttonNumber = 1, 5 do
					self:CreateSpellSelectWindow(
						setupWindow, 
						setupScrollWindow, 
						hasControl == 1, 
						hasShift == 1, 
						hasAlt == 1, 
						buttonNumber);
				end;
			end;
		end;
	end;

	for cooldownNumber = 1, self.MaxCooldownCount do
		self:CreateCooldownSelectWindow(
			setupWindow, 
			setupScrollWindow, 
			"Cooldown" .. cooldownNumber, 
			"cooldown" .. cooldownNumber, 
			"COOLDOWN " .. cooldownNumber);
	end;

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

function OrlanHeal:BuildClickCaption(hasControl, hasShift, hasAlt, buttonNumber)
	local caption = "";
	if hasControl then
		caption = caption .. "CONTROL ";
	end;
	if hasAlt then
		caption = caption .. "ALT ";
	end;
	if hasShift then
		caption = caption .. "SHIFT ";
	end;
	caption = caption .. self.ButtonNames[buttonNumber];
	return caption;
end;

function OrlanHeal:CreateSpellSelectWindow(setupWindow, parent, hasControl, hasShift, hasAlt, buttonNumber)
	local name = self:BuildClickName(hasControl, hasShift, hasAlt, buttonNumber);
	local caption = self:BuildClickCaption(hasControl, hasShift, hasAlt, buttonNumber);

	local label = parent:CreateFontString(nil, nil, "GameFontNormal");
	label:SetPoint("TOPRIGHT", parent, "TOPLEFT", self.SetupWindowLabelWidth - 5, -8 - setupWindow.ControlCount * 25);
	label:SetText(caption);

	local spellSelectWindow = CreateFrame("Frame", self.SetupWindowName .. "_Spell_" .. name, parent, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(spellSelectWindow, self.SetupWindowValueWidth - 5);
	spellSelectWindow.OrlanHeal = self;
	spellSelectWindow.button = name;
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

function OrlanHeal.HandleSpellInit(spellSelectWindow, level)
	local info = {};
	info["func"] = spellSelectWindow.OrlanHeal.HandleSpellSelect;
	info["arg1"] = spellSelectWindow;

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
		local spellId = spellSelectWindow.OrlanHeal.Class.AvailableSpells[spellIndex];
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

	UIDropDownMenu_SetSelectedValue(spellSelectWindow, spellSelectWindow.OrlanHeal.PendingConfig[spellSelectWindow.button]);
end;

function OrlanHeal.HandleSpellSelect(item, spellSelectWindow, value)
	spellSelectWindow.OrlanHeal.PendingConfig[spellSelectWindow.button] = value;
	UIDropDownMenu_SetSelectedValue(spellSelectWindow, value);	
end;

function OrlanHeal:InitializeCooldownSelectWindow(cooldownSelectWindow)
	UIDropDownMenu_Initialize(cooldownSelectWindow, self.HandleCooldownInit);
end;

function OrlanHeal.HandleCooldownInit(cooldownSelectWindow, level)
	local info = {};
	info["func"] = cooldownSelectWindow.OrlanHeal.HandleCooldownSelect;
	info["arg1"] = cooldownSelectWindow;

	info["text"] = "";
	info["value"] = "";
	info["arg2"] = "";
	UIDropDownMenu_AddButton(info, level);

	for key, cooldown in pairs(cooldownSelectWindow.OrlanHeal.CommonCooldownOptions) do
		cooldownSelectWindow.OrlanHeal:AddCooldownOption(info, level, key, cooldown);
	end;

	if cooldownSelectWindow.OrlanHeal.Class.CooldownOptions then
		for key, cooldown in pairs(cooldownSelectWindow.OrlanHeal.Class.CooldownOptions) do
			cooldownSelectWindow.OrlanHeal:AddCooldownOption(info, level, key, cooldown);
		end;
	end;

	UIDropDownMenu_SetSelectedValue(
		cooldownSelectWindow, 
		cooldownSelectWindow.OrlanHeal.PendingConfig[cooldownSelectWindow.cooldown]);
end;

function OrlanHeal:AddCooldownOption(info, level, key, cooldown)
	if not cooldown.IsAvailable or cooldown.IsAvailable(self) then
		local effectId = cooldown.AuraId or cooldown.SpellId;
		local name;
		if effectId then
			local rank;
			name, rank = GetSpellInfo(effectId);
			if rank and (rank ~= "") then
				name = name .. " (" .. rank .. ")";
			end;
		else
			name = cooldown.SlotCaption;
		end;
		info["text"] = name;
		info["value"] = key;
		info["arg2"] = key;
		UIDropDownMenu_AddButton(info, level);
	end;
end;

function OrlanHeal.HandleCooldownSelect(item, cooldownWindow, value)
	cooldownWindow.OrlanHeal.PendingConfig[cooldownWindow.cooldown] = value;
	UIDropDownMenu_SetSelectedValue(cooldownWindow, value);	
end;

function OrlanHeal:LoadSetup()
	if self.Class.LoadSetup then
		self.Class.LoadSetup(self);
	end;

	self.Config["shift1"] = self.Config["shift1"] or "target";

	for hasControl = 0, 1 do
		for hasShift = 0, 1 do
			for hasAlt = 0, 1 do
				for buttonNumber = 1, 5 do
					local name = self:BuildClickName(hasControl == 1, hasShift == 1, hasAlt == 1, buttonNumber);
					self.Config[name] = self.Config[name] or "";
				end;
			end;
		end;
	end;
	self.Config.Size = self.Config.Size or 1;

	for cooldownNumber = 1, self.MaxCooldownCount do
		local key = "cooldown" .. cooldownNumber;
		self.Config[key] = self.Config[key] or "";
	end;
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
