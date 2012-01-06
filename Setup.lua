function OrlanHeal:CreateSetupWindow()
	local orlanHeal = self;

	local setupWindow = CreateFrame("Frame", self.SetupWindowName, UIParent);
	setupWindow:SetPoint("CENTER", 0, 0);
	setupWindow:SetFrameStrata("DIALOG");

	local background = setupWindow:CreateTexture(nil, "BACKGROUND");
	background:SetAllPoints();
	background:SetTexture(0, 0, 0, 0.6);

	setupWindow:SetHeight(self.SetupWindowHeight);
	setupWindow:SetWidth(self.SetupWindowWidth);
	setupWindow:Hide();

	local configSwitchButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	configSwitchButton:SetText("Switch Config to:");
	configSwitchButton:SetWidth(150);
	configSwitchButton:SetHeight(25);
	configSwitchButton:SetPoint("TOPLEFT", setupWindow, "TOPLEFT", 5, -5);

	local configSelectWindow = CreateFrame(
		"Frame", 
		self.SetupWindowName .. "_ConfigSelect", 
		setupWindow, 
		"UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(configSelectWindow, self.SetupWindowWidth - 205);
	configSelectWindow.OrlanHeal = self;
	configSelectWindow:SetPoint("TOPLEFT", 160, -5);
	setupWindow.ConfigSelectWindow = configSelectWindow;

	configSwitchButton:SetScript(
		"OnClick",
		function()
			if orlanHeal:RequestNonCombat() then
				local talentGroup = GetActiveTalentGroup(false, false);
				orlanHeal.CharacterConfig[talentGroup] = UIDropDownMenu_GetSelectedValue(configSelectWindow);
				orlanHeal:LoadTalentGroupConfig();
				orlanHeal:ApplyConfig();
				orlanHeal:Setup();
			end;
		end);

	local presetLoadButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	presetLoadButton:SetText("Load Preset:");
	presetLoadButton:SetWidth(150);
	presetLoadButton:SetHeight(25);
	presetLoadButton:SetPoint("TOPLEFT", setupWindow, "TOPLEFT", 5, -35);

	local presetSelectWindow = CreateFrame(
		"Frame", 
		self.SetupWindowName .. "_PresetSelect", 
		setupWindow, 
		"UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(presetSelectWindow, self.SetupWindowWidth - 205);
	presetSelectWindow.OrlanHeal = self;
	presetSelectWindow:SetPoint("TOPLEFT", 160, -35);
	setupWindow.PresetSelectWindow = presetSelectWindow;

	presetLoadButton:SetScript(
		"OnClick",
		function()
		end);

	local setupScrollWindowContainer = CreateFrame("ScrollFrame", self.SetupWindowName .. "_SCROLL", setupWindow);
	setupScrollWindowContainer:SetPoint("TOPLEFT", 0, -70);
	setupScrollWindowContainer:SetPoint("BOTTOMRIGHT", -18, 65);

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
	okButton:SetPoint("TOPLEFT", setupWindow, "BOTTOMLEFT", 50, 60);
	okButton:SetScript(
		"OnClick",
		function()
			orlanHeal:SaveSetup();
		end);

	local cancelButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	cancelButton:SetText("Cancel");
	cancelButton:SetWidth(150);	
	cancelButton:SetHeight(25);
	cancelButton:SetPoint("TOPRIGHT", setupWindow, "BOTTOMRIGHT", -50, 60);
	cancelButton:SetScript(
		"OnClick",
		function()
			orlanHeal:CancelSetup();
		end);

	local configSaveButton = CreateFrame("Button", nil, setupWindow, "UIPanelButtonTemplate");
	configSaveButton:SetText("Save Config as:");
	configSaveButton:SetHeight(25);
	configSaveButton:SetWidth(150);
	configSaveButton:SetPoint("TOPLEFT", setupWindow, "BOTTOMLEFT", 5, 30);

	local configSaveNameEditBox = self:CreateEditBox(
		setupWindow, 
		self.SetupWindowName .. "_ConfigSaveName", 
		50,
		self.SetupWindowWidth - 181);
	configSaveNameEditBox:SetPoint("TOPRIGHT", setupWindow, "BOTTOMRIGHT", -13, 27.5);
	setupWindow.ConfigSaveNameEditBox = configSaveNameEditBox;

	configSaveButton:SetScript(
		"OnClick",
		function()
			orlanHeal:SaveSetupAs(strtrim(configSaveNameEditBox:GetText()));
		end);

	return setupWindow;
end;

function OrlanHeal:CreateEditBox(parent, name, maxLetters, width)
	local editBox = CreateFrame("EditBox", name, parent);
	editBox:SetFontObject("GameFontNormal");
	editBox:SetMaxLetters(maxLetters);
	editBox:SetCountInvisibleLetters(true);
	editBox:SetHeight(20);
	editBox:SetWidth(width);

	local leftBorder = editBox:CreateTexture(nil, "BORDER");
	leftBorder:SetTexture("Interface\\Common\\Common-Input-Border");
	leftBorder:SetHeight(20);
	leftBorder:SetWidth(8);
	leftBorder:SetPoint("LEFT", -8, 0);
	leftBorder:SetTexCoord(0, 0.0625, 0, 0.625);

	local rightBorder = editBox:CreateTexture(nil, "BORDER");
	rightBorder:SetTexture("Interface\\Common\\Common-Input-Border");
	rightBorder:SetHeight(20);
	rightBorder:SetWidth(8);
	rightBorder:SetPoint("RIGHT", 8, 0);
	rightBorder:SetTexCoord(0.9375, 1, 0, 0.625);

	local middleBorder = editBox:CreateTexture(nil, "BORDER");
	middleBorder:SetHeight(20);
	middleBorder:SetPoint("LEFT", 0, 0);
	middleBorder:SetPoint("RIGHT", 0, 0);
	middleBorder:SetTexture("Interface\\Common\\Common-Input-Border");
	middleBorder:SetTexCoord(0.0625, 0.9375, 0, 0.625);

	return editBox;
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
	self:SetSpellSelectWindowSelectedValue(
		spellSelectWindow, 
		self:GetSpellByKey(spellSelectWindow.OrlanHeal.PendingConfig[spellSelectWindow.button]));
end;

function OrlanHeal:InitializeConfigSelectWindow(configSelectWindow)
	UIDropDownMenu_Initialize(configSelectWindow, self.HandleConfigInit);
	local talentGroup = GetActiveTalentGroup(false, false);
	self:SetConfigSelectWindowSelectedValue(configSelectWindow, self.CharacterConfig[talentGroup]);
end;

function OrlanHeal.HandleConfigInit(configSelectWindow, level)
	if level == 1 then
		local _, class = UnitClass("player");

		for _, configName, config in 
				configSelectWindow.OrlanHeal:SortedPairs(
					configSelectWindow.OrlanHeal.ConfigSet,
					function(name1, config1, name2, config2)
						return name1 < name2;
					end) do
			if config.class == class then
				local info = UIDropDownMenu_CreateInfo();
				info.text = configName;
				info.value = configName;
				info.func = configSelectWindow.OrlanHeal.HandleConfigSelect;
				info.arg1 = configSelectWindow;
				info.arg2 = configName;
				UIDropDownMenu_AddButton(info, level);
			end;
		end;
	end;
end;

function OrlanHeal.HandleConfigSelect(item, configSelectWindow, value)
	configSelectWindow.OrlanHeal:SetConfigSelectWindowSelectedValue(configSelectWindow, value);
end;

function OrlanHeal:SetConfigSelectWindowSelectedValue(configSelectWindow, value)
	UIDropDownMenu_SetSelectedValue(configSelectWindow, value);
	UIDropDownMenu_SetText(configSelectWindow, value);
end;

function OrlanHeal:InitializePresetSelectWindow(presetSelectWindow)
	UIDropDownMenu_Initialize(presetSelectWindow, self.HandlePresetInit);

	for _, name in 
			self:SortedPairs(
				self.Class.GetConfigPresets(self),
				function(name1, preset1, name2, preset2)
					return name1 < name2;
				end) do
		self:SetPresetSelectWindowSelectedValue(presetSelectWindow, name);
		break;
	end;
end;

function OrlanHeal.HandlePresetInit(presetSelectWindow, level)
	if level == 1 then
		for _, name in 
				presetSelectWindow.OrlanHeal:SortedPairs(
					presetSelectWindow.OrlanHeal.Class.GetConfigPresets(presetSelectWindow.OrlanHeal),
					function(name1, preset1, name2, preset2)
						return name1 < name2;
					end) do
			local info = UIDropDownMenu_CreateInfo();
			info.text = name;
			info.value = name;
			info.func = presetSelectWindow.OrlanHeal.HandlePresetSelect;
			info.arg1 = presetSelectWindow;
			info.arg2 = name;
			UIDropDownMenu_AddButton(info, level);
		end;
	end;
end;

function OrlanHeal.HandlePresetSelect(item, presetSelectWindow, value)
	presetSelectWindow.OrlanHeal:SetPresetSelectWindowSelectedValue(presetSelectWindow, value);
end;

function OrlanHeal:SetPresetSelectWindowSelectedValue(presetSelectWindow, value)
	UIDropDownMenu_SetSelectedValue(presetSelectWindow, value);
	UIDropDownMenu_SetText(presetSelectWindow, value);
end;

function OrlanHeal.HandleSpellInit(spellSelectWindow, level)
	if level == 1 then
		spellSelectWindow.OrlanHeal:AddSpellOption(
			spellSelectWindow, 
			{
				type = "",
				caption = "",
				key = ""
			},
			level);

		spellSelectWindow.OrlanHeal:AddSpellOption(
			spellSelectWindow, 
			{
				type = "target",
				caption = "Set as target"
			},
			level);

		local spells = {};
		for spellIndex, spell in ipairs(spellSelectWindow.OrlanHeal:GetAvailableSpells()) do
			spells[spell] = spellSelectWindow.OrlanHeal:GetSpellCaption(spell);
		end;
		local groups = {};
		for index, spell, spellCaption in 
				spellSelectWindow.OrlanHeal:SortedPairs(
					spells,
					function(spell1, spellCaption1, spell2, spellCaption2)
						return spellCaption1 < spellCaption2;
					end) do
			if (type(spell) == "table") and spell.group then
				if not groups[spell.group] then
					groups[spell.group] = {};
				end;
				groups[spell.group][spell] = spellCaption;
			else
				spellSelectWindow.OrlanHeal:AddSpellOption(spellSelectWindow, spell, level);
			end;
		end;

		for index, key, groupSpells in 
				spellSelectWindow.OrlanHeal:SortedPairs(
					groups,
					function(key1, _, key2, _)
						return key1 < key2;
					end) do
			spellSelectWindow.OrlanHeal:AddSpellGroup(key, groupSpells, level);
		end;
	end;

	if level == 2 then
		for index, spell, spellCaption in 
				spellSelectWindow.OrlanHeal:SortedPairs(
					UIDROPDOWNMENU_MENU_VALUE,
					function(spell1, spellCaption1, spell2, spellCaption2)
						return spellCaption1 < spellCaption2;
					end) do
				spellSelectWindow.OrlanHeal:AddSpellOption(spellSelectWindow, spell, level);
		end;
	end;
end;

function OrlanHeal:AddSpellOption(spellSelectWindow, spell, level)
	local info = UIDropDownMenu_CreateInfo();
	info.func = spellSelectWindow.OrlanHeal.HandleSpellSelect;
	info.arg1 = spellSelectWindow;
	info.text = self:GetSpellCaption(spell);
	info.value = spellSelectWindow.OrlanHeal:GetSpellKey(spell);
	info.arg2 = spell;
	info.keepShownOnClick = true;
	UIDropDownMenu_AddButton(info, level);
end;

function OrlanHeal:AddSpellGroup(name, spells, level)
	local info = UIDropDownMenu_CreateInfo();
	info.hasArrow = true;
	info.notCheckable = true;
	info.text = name;
	info.value = spells;
	info.keepShownOnClick = true;
	UIDropDownMenu_AddButton(info, level);
end;

function OrlanHeal:GetSpellKey(spell)
	local key;
	if type(spell) == "table" then
		if spell.key then
			key = spell.key;
		elseif spell.type == "target" then
			key = spell.type;
		elseif spell.type == "item" then
			key = spell.item;
		else
			key = spell.spell;
		end;
	else
		key = spell;
	end;
	return key;
end;

function OrlanHeal:GetSpellCaption(spell)
	local caption;
	if spell == nil then
		caption = nil;
	elseif type(spell) == "table" then
		if spell.caption then
			caption = spell.caption;
		else
			caption = GetSpellInfo(spell.spell);
		end;
	elseif spell == "target" then
		caption = "Set as target";
	else
		caption = GetSpellInfo(spell);
	end;
	return caption;
end;

function OrlanHeal:GetAvailableSpells()
	local spells = {};
	for index, spell in ipairs(self.CommonAvailableSpells) do
		table.insert(spells, spell);
	end;
	for index, spell in ipairs(self.Class.AvailableSpells) do
		table.insert(spells, spell);
	end;
	return spells;
end;

function OrlanHeal.HandleSpellSelect(item, spellSelectWindow, value)
	spellSelectWindow.OrlanHeal.PendingConfig[spellSelectWindow.button] = 
		spellSelectWindow.OrlanHeal:GetSpellKey(value);
	spellSelectWindow.OrlanHeal:SetSpellSelectWindowSelectedValue(spellSelectWindow, value);
	ToggleDropDownMenu(nil, nil, spellSelectWindow);
end;

function OrlanHeal:InitializeCooldownSelectWindow(cooldownSelectWindow)
	UIDropDownMenu_Initialize(cooldownSelectWindow, self.HandleCooldownInit);
	cooldownSelectWindow.OrlanHeal:SetCooldownSelectWindowSelectedValue(
		cooldownSelectWindow, 
		cooldownSelectWindow.OrlanHeal.PendingConfig[cooldownSelectWindow.cooldown]);
end;

function OrlanHeal:GetSpellByKey(spellKey)
	local spell;
	spell = spellKey;
	if type(spellKey) ~= "table" then
		for index, currentSpell in ipairs(self:GetAvailableSpells()) do
			if self:GetSpellKey(currentSpell) == spellKey then
				spell = currentSpell;
				break;
			end;
		end;
	end;
	return spell;
end;

function OrlanHeal:SetSpellSelectWindowSelectedValue(spellSelectWindow, spell)
	UIDropDownMenu_SetSelectedValue(spellSelectWindow, self:GetSpellKey(spell));
	UIDropDownMenu_SetText(spellSelectWindow, self:GetSpellCaption(spell));
end;

function OrlanHeal:SetCooldownSelectWindowSelectedValue(cooldownSelectWindow, value)
	UIDropDownMenu_SetSelectedValue(cooldownSelectWindow, value);
	local text;
	if value == "" then
		text = "";
	else
		local cooldown = self:GetCooldownOptions()[value];
		if cooldown then
			text = self:GetCooldownCaption(cooldown);
		else
			text = "Custom";
		end;
	end;
	UIDropDownMenu_SetText(cooldownSelectWindow, text);
end;

function OrlanHeal:SortedPairs(tableToSort, comparer)
	local array = {};
	for key, value in pairs(tableToSort) do
		table.insert(array, { key = key, value = value });
	end;
	table.sort(
		array,
		function(item1, item2)
			return comparer(item1.key, item1.value, item2.key, item2.value);
		end);
	return
		function(array, index)
			local nextIndex, nextItem = next(array, index);
			local nextKey, nextValue;
			if nextIndex ~= nil then
				nextKey = nextItem.key;
				nextValue = nextItem.value;
			end;
			return nextIndex, nextKey, nextValue;
		end,
		array,
		nil;
end;

function OrlanHeal.HandleCooldownInit(cooldownSelectWindow, level)
	if level == 1 then
		local info = UIDropDownMenu_CreateInfo();
		info.func = cooldownSelectWindow.OrlanHeal.HandleCooldownSelect;
		info.arg1 = cooldownSelectWindow;
		info.text = "";
		info.value = "";
		info.arg2 = "";
		info.keepShownOnClick = true;
		UIDropDownMenu_AddButton(info, level);

		local groups = {};
		for index, key, cooldown in 
				cooldownSelectWindow.OrlanHeal:SortedPairs(
					cooldownSelectWindow.OrlanHeal:GetCooldownOptions(),
					function(key1, cooldown1, key2, cooldown2)
						return cooldownSelectWindow.OrlanHeal:GetCooldownCaption(cooldown1) <
							cooldownSelectWindow.OrlanHeal:GetCooldownCaption(cooldown2);
					end) do
			if cooldown.Group then
				if not groups[cooldown.Group] then
					groups[cooldown.Group] = {};
				end;
				groups[cooldown.Group][key] = cooldown;
			else
				cooldownSelectWindow.OrlanHeal:AddCooldownOption(level, key, cooldown, cooldownSelectWindow);
			end;
		end;

		for index, key, groupOptions in 
				cooldownSelectWindow.OrlanHeal:SortedPairs(
					groups,
					function(key1, _, key2, _)
						return key1 < key2;
					end) do
			cooldownSelectWindow.OrlanHeal:AddCooldownGroup(key, groupOptions, level);
		end;
	end;

	if level == 2 then
		for index, key, cooldown in 
				cooldownSelectWindow.OrlanHeal:SortedPairs(
					UIDROPDOWNMENU_MENU_VALUE,
					function(key1, cooldown1, key2, cooldown2)
						return cooldownSelectWindow.OrlanHeal:GetCooldownCaption(cooldown1) <
							cooldownSelectWindow.OrlanHeal:GetCooldownCaption(cooldown2);
					end) do
			cooldownSelectWindow.OrlanHeal:AddCooldownOption(level, key, cooldown, cooldownSelectWindow);
		end;
	end;
end;

function OrlanHeal:GetCooldownOptions()
	local options = {};
	for key, cooldown in pairs(self.CommonCooldownOptions) do
		options[key] = cooldown;
	end;
	if self.Class.CooldownOptions then
		for key, cooldown in pairs(self.Class.CooldownOptions) do
			options[key] = cooldown;
		end;
	end;
	return options;
end;

function OrlanHeal:GetCooldownCaption(cooldown)
	local effectId = cooldown.AuraId or cooldown.SpellId;
	local caption;
	if effectId then
		local name, rank = GetSpellInfo(effectId);
		if rank and (rank ~= "") then
			caption = name .. " (" .. rank .. ")";
		else
			caption = name;
		end;
	else
		caption = cooldown.SlotCaption;
	end;
	return caption;
end;

function OrlanHeal:AddCooldownOption(level, key, cooldown, cooldownSelectWindow)
	if not cooldown.IsAvailable or cooldown.IsAvailable(self) then
		local info = UIDropDownMenu_CreateInfo();
		info.func = cooldownSelectWindow.OrlanHeal.HandleCooldownSelect;
		info.arg1 = cooldownSelectWindow;
		info.text = self:GetCooldownCaption(cooldown);
		info.value = key;
		info.arg2 = key;
		info.keepShownOnClick = true;
		UIDropDownMenu_AddButton(info, level);
	end;
end;

function OrlanHeal:AddCooldownGroup(name, options, level)
	local info = UIDropDownMenu_CreateInfo();
	info.hasArrow = true;
	info.notCheckable = true;
	info.text = name;
	info.value = options;
	info.keepShownOnClick = true;
	UIDropDownMenu_AddButton(info, level);
end;

function OrlanHeal.HandleCooldownSelect(item, cooldownWindow, value)
	cooldownWindow.OrlanHeal.PendingConfig[cooldownWindow.cooldown] = value;
	cooldownWindow.OrlanHeal:SetCooldownSelectWindowSelectedValue(cooldownWindow, value);
	ToggleDropDownMenu(nil, nil, cooldownWindow);
end;

function OrlanHeal:GenerateDefaultConfigName()
	local corePrefix = GetUnitName("player") .. "-" .. GetRealmName();
	local index = 1;
	local candidateName = corePrefix;
	while self.ConfigSet[candidateName] do
		index = index + 1;
		candidateName = corePrefix .. " " .. index;
	end;
	return candidateName;
end;

function OrlanHeal:LoadConfigSet()
	_G[self.ConfigVariableName] = _G[self.ConfigVariableName] or {};
	self.ConfigSet = _G[self.ConfigVariableName];

	_G[self.CharacterConfigVariableName] = _G[self.CharacterConfigVariableName] or {};
	self.CharacterConfig = _G[self.CharacterConfigVariableName];

	if not self.CharacterConfig[1] then
		local _, class = UnitClass("player");
		self.CharacterConfig.class = class;

		local configName = self:GenerateDefaultConfigName();
		self.ConfigSet[configName] = self.CharacterConfig;
		self.CharacterConfig = { [1] = configName };
		_G[self.CharacterConfigVariableName] = self.CharacterConfig;
	end;

	self:LoadTalentGroupConfig();
end;

function OrlanHeal:LoadTalentGroupConfig()
	local talentGroup = GetActiveTalentGroup(false, false);
	if not self.CharacterConfig[talentGroup] then
		self.CharacterConfig[talentGroup] = self.CharacterConfig[1];
	end;

	self.Config = self.ConfigSet[self.CharacterConfig[talentGroup]];
	self:LoadConfig();
end;

function OrlanHeal:HandleTalentGroupChanged()
	self:CancelSetup();
	self:LoadTalentGroupConfig();
	self:ApplyConfig();
end;

function OrlanHeal:GetCommonDefaultConfig()
	local config = {};

	for hasControl = 0, 1 do
		for hasShift = 0, 1 do
			for hasAlt = 0, 1 do
				for buttonNumber = 1, 5 do
					local name = self:BuildClickName(hasControl == 1, hasShift == 1, hasAlt == 1, buttonNumber);
					config[name] = "";
				end;
			end;
		end;
	end;

	config["shift1"] = "target";

	for cooldownNumber = 1, self.MaxCooldownCount do
		local key = "cooldown" .. cooldownNumber;
		config[key] = "";
	end;

	return config;
end;

function OrlanHeal:LoadConfig()
	local defaultConfig = self.Class.GetDefaultConfig(self);
	for key, value in pairs(defaultConfig) do
		self.Config[key] = self.Config[key] or value;
	end;

	if self.Class.LoadConfig then
		self.Class.LoadConfig(self);
	end;

	self.Config.Size = self.Config.Size or 1;
end;

function OrlanHeal:Setup()
	self.PendingConfig = {};
	for key, value in pairs(self.Config) do
		self.PendingConfig[key] = value;
	end;

	self:InitializeConfigSelectWindow(self.SetupWindow.ConfigSelectWindow);
	self:InitializePresetSelectWindow(self.SetupWindow.PresetSelectWindow);

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

	self.SetupWindow.ConfigSaveNameEditBox:SetText("");

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
		self:ApplyConfig();
	end;
end;

function OrlanHeal:SaveSetupAs(name)
	if self:RequestNonCombat() then
		if name == "" then
			print("OrlanHeal: Config name missing.");
		elseif self.ConfigSet[name] then
			print("OrlanHeal: Duplicate config name.");
		else
			local talentGroup = GetActiveTalentGroup(false, false);
			self.CharacterConfig[talentGroup] = name;
			self.ConfigSet[name] = self.Config;
			self:SaveSetup();
			self:Setup();
		end;
	end;
end;

function OrlanHeal:ApplyConfig()
		self.RaidWindow:SetScale(self.Config.Size * self.Scale);

		self.SetupWindow:Hide();

		self:UpdateSpells();
		self:SetupCooldowns();
end;
