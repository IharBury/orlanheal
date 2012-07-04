function OrlanHeal:Initialize(configVariableName, characterConfigVariableName)
	local orlanHeal = self;

	self.ConfigVariableName = configVariableName;
	self.CharacterConfigVariableName = characterConfigVariableName;
	self.EventFrame = CreateFrame("Frame");

	function self.EventFrame:HandleEvent(event, arg1)
		if (event == "ADDON_LOADED") and (arg1 == "OrlanHeal") then
			orlanHeal:HandleLoaded();
		elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
			orlanHeal:HandleTalentGroupChanged();
		elseif (event == "RAID_ROSTER_UPDATE") or
				(event == "PARTY_CONVERTED_TO_RAID") or
				(event == "PARTY_LEADER_CHANGED") or
				(event == "PARTY_MEMBERS_CHANGED") or
				(event == "ZONE_CHANGED_NEW_AREA") or
				(event == "PLAYER_REGEN_ENABLED") or
				(event == "PLAYER_ENTERING_BATTLEGROUND") or
				(event == "PLAYER_ENTERING_WORLD") or
				(event == "LFG_ROLE_UPDATE") or
				(event == "PLAYER_ROLES_ASSIGNED") or
				(event == "ROLE_CHANGED_INFORM") then
			if not InCombatLockdown() then
				orlanHeal:UpdateUnits();
			end;
		end;
	end;

	local className, class = UnitClass("player");
	if class == "PALADIN" then
		self.Class = self.Paladin;
	elseif class == "PRIEST" then
		self.Class = self.Priest;
	elseif class == "SHAMAN" then
		self.Class = self.Shaman;
	elseif class == "DRUID" then
		self.Class = self.Druid;
	else
		self.Class = self.Paladin;
		print("OrlanHeal: " .. className .. " class is not supported.");
	end;

	if not self.Class.IsSupported then
		print("OrlanHeal: " .. className .. " class support in not completely implemented yet.");
	end;

	self.ElapsedAfterUpdate = 0;
	function self.EventFrame:HandleUpdate(elapsed)
		if orlanHeal.RaidWindow:IsShown() then
			orlanHeal.ElapsedAfterUpdate = orlanHeal.ElapsedAfterUpdate + elapsed;
			if orlanHeal.ElapsedAfterUpdate > 1.0 / orlanHeal.FrameRate then
				orlanHeal:UpdateStatus();
				orlanHeal.ElapsedAfterUpdate = 0;
			end;
		end;
	end;

	self.EventFrame:RegisterEvent("ADDON_LOADED");
	self.EventFrame:SetScript("OnEvent", self.EventFrame.HandleEvent);
	self.EventFrame:SetScript("OnUpdate", self.EventFrame.HandleUpdate);

	self.GroupCount = 9;
	self.VisibleGroupCount = 9;
	self.IsInStartUpMode = true;
	self.IsTankWindowVisible = false;
	self.IsNameBindingEnabled = false;
	self.IsUnitUpdateRequired = false;

	self.RaidRoles = {};
end;

function OrlanHeal:HandleLoaded()
	self:LoadConfigSet();

	self.RaidWindow = self:CreateRaidWindow();
	self.SetupWindow = self:CreateSetupWindow();

	self:SetupCooldowns();
	self:UpdateVisibleGroupCount();
	self:UpdateCooldownFrames();
	self:Show();

	self.EventFrame:RegisterEvent("RAID_ROSTER_UPDATE");
	self.EventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self.EventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self.EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	self.EventFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
	self.EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	self.EventFrame:RegisterEvent("PARTY_CONVERTED_TO_RAID");
	self.EventFrame:RegisterEvent("PARTY_LEADER_CHANGED");
	self.EventFrame:RegisterEvent("LFG_ROLE_UPDATE");
	self.EventFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED");
	self.EventFrame:RegisterEvent("ROLE_CHANGED_INFORM");
	self.EventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
end;

OrlanHeal:Initialize("OrlanHealGlobalConfig", "OrlanHealConfig");
