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
		OrlanHeal:SetVisibleGroupCount(8);
	elseif message == "v25" then
		OrlanHeal:SetVisibleGroupCount(5);
	elseif message == "v10" then
		OrlanHeal:SetVisibleGroupCount(2);
	elseif message == "v5" then
		OrlanHeal:SetVisibleGroupCount(1);
	elseif message == "tanks" then
		OrlanHeal:ToggleTanks();
	elseif message == "bosses" then
		OrlanHeal:ToggleBosses();
	elseif message == "byname" then
		OrlanHeal:SetNameBinding();
	elseif message == "setup" then
		OrlanHeal:Setup();
	else
		print("OrlanHeal: Unknown command");
	end;
end;

function OrlanHeal:ToggleTanks()
	if self.IsTankWindowVisible then
		self:HideTanks();
	else
		self:ShowTanks();
	end;
end;

function OrlanHeal:ToggleBosses()
	if self.IsBossWindowVisible then
		self:HideBosses();
	else
		self:ShowBosses();
	end;
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

function OrlanHeal:UpdateVisibleGroupCount()
	for groupIndex = 0, self.MaxGroupCount - 1 do
		if groupIndex < self:GetGroupCountWithTanks() then
			self.RaidWindow.Groups[groupIndex]:Show();
		else
			self.RaidWindow.Groups[groupIndex]:Hide();
		end;
	end;

	local verticalGroupCount = math.floor((self:GetGroupCountWithTanks() + 1) / 2);
	self.RaidWindow:SetHeight(
		self.GroupHeight * verticalGroupCount + 
		self.RaidOuterSpacing * 2 + 
		self.GroupInnerSpacing * (verticalGroupCount - 1));

	local horizontalGroupCount;
	if self:GetGroupCountWithTanks() == 1 then
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
		if self.IsInStartUpMode then
			self.IsInStartUpMode = false;
			self.IsBossWindowVisible = false;
		end;

		self.GroupCount = newGroupCount;
		self.VisibleGroupCount = newGroupCount;
		self.IsNameBindingEnabled = false;
		self:UpdateVisibleGroupCount();
		self:UpdateUnits();
		self:UpdateSwitches();
		self:UpdateCooldownFrames();
	end;
end;

function OrlanHeal:ShowTanks()
	if self:RequestNonCombat() then
		self.IsTankWindowVisible = true;
		self:UpdateVisibleGroupCount();
		self:UpdateUnits();
		self:UpdateTankSwitch();
		self:UpdateCooldownFrames();
	end;
end;

function OrlanHeal:HideTanks()
	if self:RequestNonCombat() then
		self.IsTankWindowVisible = false;
		self:UpdateVisibleGroupCount();
		self:UpdateUnits();
		self:UpdateTankSwitch();
		self:UpdateCooldownFrames();
	end;
end;

function OrlanHeal:ShowBosses()
	if self:RequestNonCombat() then
		self.IsBossWindowVisible = true;
		self:UpdateVisibleGroupCount();
		self:UpdateUnits();
		self:UpdateBossSwitch();
		self:UpdateCooldownFrames();
	end;
end;

function OrlanHeal:HideBosses()
	if self:RequestNonCombat() then
		self.IsBossWindowVisible = false;
		self:UpdateVisibleGroupCount();
		self:UpdateUnits();
		self:UpdateBossSwitch();
		self:UpdateCooldownFrames();
	end;
end;

function OrlanHeal:SetVisibleGroupCount(newVisibleGroupCount)
	if self:RequestNonCombat() then
		self.VisibleGroupCount = newVisibleGroupCount;
		self.IsNameBindingEnabled = false;
		self:UpdateUnits();
		self:UpdateSwitches();
	end;
end;

function OrlanHeal:SetNameBinding()
	if self:RequestNonCombat() then
		self.VisibleGroupCount = self.GroupCount;
		self.IsNameBindingEnabled = true;
		self:UpdateUnits();
		self:UpdateSwitches();
	end;
end;
