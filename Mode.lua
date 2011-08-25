﻿function OrlanHeal:CreateTankSwitch(raidWindow)
	local button = CreateFrame("Button", nil, raidWindow);
	button:SetPoint(
		"TOPLEFT", 
		raidWindow, 
		"BOTTOMLEFT", 
		8 * (self.GroupCountSwitchWidth + self.GroupCountSwitchHorizontalSpacing), 
		-self.GroupCountSwitchVerticalSpacing);
	button:SetHeight(self.GroupCountSwitchHeight);
	button:SetWidth(self.GroupCountSwitchWidth);
	button:SetNormalFontObject("GameFontNormalSmall");
	button:SetText("MT");
	button:SetAlpha(self.RaidAlpha);

	local normalTexture = button:CreateTexture();
	normalTexture:SetAllPoints();
	normalTexture:SetTexture(0, 0, 0, 1);
	button:SetNormalTexture(normalTexture);

	local orlanHeal = self;
	button:SetScript(
		"OnClick",
		function()
			orlanHeal:ToggleTanks();
		end);

	button:Hide();

	return button;
end;

function OrlanHeal:CreateNameBindingSwitch(raidWindow)
	local button = CreateFrame("Button", nil, raidWindow);
	button:SetPoint(
		"TOPLEFT", 
		raidWindow, 
		"BOTTOMLEFT", 
		8 * (self.GroupCountSwitchWidth + self.GroupCountSwitchHorizontalSpacing), 
		-self.GroupCountSwitchHeight - 2 * self.GroupCountSwitchVerticalSpacing);
	button:SetHeight(self.GroupCountSwitchHeight);
	button:SetWidth(self.GroupCountSwitchWidth);
	button:SetNormalFontObject("GameFontNormalSmall");
	button:SetText("Nm");
	button:SetAlpha(self.RaidAlpha);

	local normalTexture = button:CreateTexture();
	normalTexture:SetAllPoints();
	normalTexture:SetTexture(0, 0, 0, 1);
	button:SetNormalTexture(normalTexture);

	local orlanHeal = self;
	button:SetScript(
		"OnClick",
		function()
			orlanHeal:SetNameBinding();
		end);

	button:Hide();

	return button;
end;

function OrlanHeal:CreateSetupButton(raidWindow)
	local button = CreateFrame("Button", nil, raidWindow);
	button:SetPoint(
		"TOPLEFT", 
		raidWindow, 
		"BOTTOMLEFT", 
		9 * (self.GroupCountSwitchWidth + self.GroupCountSwitchHorizontalSpacing), 
		-self.GroupCountSwitchVerticalSpacing);
	button:SetHeight(self.GroupCountSwitchHeight);
	button:SetWidth(self.GroupCountSwitchWidth);
	button:SetNormalFontObject("GameFontNormalSmall");
	button:SetText("Set");
	button:SetAlpha(self.RaidAlpha);

	local normalTexture = button:CreateTexture();
	normalTexture:SetAllPoints();
	normalTexture:SetTexture(0, 0, 0, 1);
	button:SetNormalTexture(normalTexture);

	local orlanHeal = self;
	button:SetScript(
		"OnClick",
		function()
			orlanHeal:Setup();
		end);

	return button;
end;

function OrlanHeal:CreateGroupCountSwitch(raidWindow, size, index)
	local button = CreateFrame("Button", nil, raidWindow);
	button:SetPoint(
		"TOPLEFT", 
		raidWindow, 
		"BOTTOMLEFT", 
		index * (self.GroupCountSwitchWidth + self.GroupCountSwitchHorizontalSpacing), 
		-self.GroupCountSwitchVerticalSpacing);
	button:SetHeight(self.GroupCountSwitchHeight);
	button:SetWidth(self.GroupCountSwitchWidth);
	button:SetNormalFontObject("GameFontNormalSmall");
	button:SetText(size);
	button:SetAlpha(self.RaidAlpha);

	local normalTexture = button:CreateTexture();
	normalTexture:SetAllPoints();
	normalTexture:SetTexture(0, 0, 0, 1);
	button:SetNormalTexture(normalTexture);

	local orlanHeal = self;
	button:SetScript(
		"OnClick",
		function()
			orlanHeal:SetGroupCount(size / 5);
		end);

	return button;
end;

function OrlanHeal:CreateVisibleGroupCountSwitch(raidWindow, size, index)
	local button = CreateFrame("Button", nil, raidWindow);
	button:SetPoint(
		"TOPLEFT", 
		raidWindow, 
		"BOTTOMLEFT", 
		index * (self.GroupCountSwitchWidth + self.GroupCountSwitchHorizontalSpacing), 
		-self.GroupCountSwitchHeight - 2 * self.GroupCountSwitchVerticalSpacing);
	button:SetHeight(self.GroupCountSwitchHeight);
	button:SetWidth(self.GroupCountSwitchWidth);
	button:SetNormalFontObject("GameFontNormalSmall");
	button:SetText(size);
	button:SetAlpha(self.RaidAlpha);
	button:Hide();

	local normalTexture = button:CreateTexture();
	normalTexture:SetAllPoints();
	normalTexture:SetTexture(0, 0, 0, 1);
	button:SetNormalTexture(normalTexture);

	local orlanHeal = self;
	button:SetScript(
		"OnClick",
		function()
			orlanHeal:SetVisibleGroupCount(size / 5);
		end);

	return button;
end;

function OrlanHeal:UpdateSwitches()
	self:UpdateGroupCountSwitches();
	self:UpdateTankSwitch();
	self:UpdateNameBindingSwitch();
end;

function OrlanHeal:UpdateGroupCountSwitches()
	for size = 5, 40, 5 do
		local groupCountTexture = self.RaidWindow.GroupCountSwitches[size]:GetNormalTexture();
		if self.GroupCount == size / 5 then
			groupCountTexture:SetTexture(0.5, 1, 0.5, 1);
		else
			groupCountTexture:SetTexture(0, 0, 0, 1);
		end;

		if size > self.GroupCount * 5 then
			self.RaidWindow.VisibleGroupCountSwitches[size]:Hide();
		else
			self.RaidWindow.VisibleGroupCountSwitches[size]:Show();

			local visibleGroupCountTexture = self.RaidWindow.VisibleGroupCountSwitches[size]:GetNormalTexture();
			if (self.VisibleGroupCount == size / 5) and not self.IsNameBindingEnabled then
				visibleGroupCountTexture:SetTexture(1, 0.5, 0.5, 1);
			else
				visibleGroupCountTexture:SetTexture(0, 0, 0, 1);
			end;
		end;
	end;
end;

function OrlanHeal:UpdateTankSwitch()
	self.RaidWindow.TankSwitch:Show();

	local texture = self.RaidWindow.TankSwitch:GetNormalTexture();
	if self.IsTankWindowVisible then
		texture:SetTexture(0.5, 1, 0.5, 1);
	else
		texture:SetTexture(0, 0, 0, 1);
	end;
end;

function OrlanHeal:UpdateNameBindingSwitch()
	self.RaidWindow.NameBindingSwitch:Show();

	local texture = self.RaidWindow.NameBindingSwitch:GetNormalTexture();
	if self.IsNameBindingEnabled then
		texture:SetTexture(1, 0.5, 0.5, 1);
	else
		texture:SetTexture(0, 0, 0, 1);
	end;
end;
