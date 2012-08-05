OrlanHeal.FrameRate = 10.0;

OrlanHeal.MaxGroupCount = 10;
OrlanHeal.MaxVerticalGroupCount = math.floor((OrlanHeal.MaxGroupCount + 1) / 2);
if OrlanHeal.MaxGroupCount == 1 then
	OrlanHeal.MaxHorizontalGroupCount = 1;
else
	OrlanHeal.MaxHorizontalGroupCount = 2;
end;

OrlanHeal.Scale = 0.8;
OrlanHeal.PetWidth = 81;
OrlanHeal.PetSpacing = 3;
OrlanHeal.PlayerWidth = 130;
OrlanHeal.PlayerHeight = 20;
OrlanHeal.BuffSize = OrlanHeal.PlayerHeight / 2;
OrlanHeal.GroupOuterSpacing = 2;
OrlanHeal.PlayerInnerSpacing = 2;
OrlanHeal.GroupWidth = OrlanHeal.PlayerWidth + OrlanHeal.PetSpacing + OrlanHeal.PetWidth + OrlanHeal.GroupOuterSpacing * 2;
OrlanHeal.GroupHeight = OrlanHeal.PlayerHeight * 5 + 
	OrlanHeal.GroupOuterSpacing * 2 + 
	OrlanHeal.PlayerInnerSpacing * 4;
OrlanHeal.RaidOuterSpacing = 6;
OrlanHeal.GroupInnerSpacing = 4;
OrlanHeal.RaidWidth = OrlanHeal.GroupWidth * OrlanHeal.MaxHorizontalGroupCount + 
	OrlanHeal.RaidOuterSpacing * 2 + 
	OrlanHeal.GroupInnerSpacing * (OrlanHeal.MaxHorizontalGroupCount - 1);
OrlanHeal.RaidHeight = OrlanHeal.GroupHeight * OrlanHeal.MaxVerticalGroupCount + 
	OrlanHeal.RaidOuterSpacing * 2 + 
	OrlanHeal.GroupInnerSpacing * (OrlanHeal.MaxVerticalGroupCount - 1);
OrlanHeal.RangeWidth = 5;
OrlanHeal.PlayerStatusWidth = OrlanHeal.PlayerWidth - OrlanHeal.RangeWidth - OrlanHeal.BuffSize * 5;
OrlanHeal.PetStatusWidth = OrlanHeal.PetWidth - OrlanHeal.RangeWidth - OrlanHeal.BuffSize * 2;
OrlanHeal.HealthHeight = 4;
OrlanHeal.ManaHeight = 4;
OrlanHeal.NameHeight = OrlanHeal.PlayerHeight - OrlanHeal.ManaHeight - OrlanHeal.HealthHeight;
OrlanHeal.NameFontHeight = OrlanHeal.NameHeight * 0.8;

OrlanHeal.GroupCountSwitchHeight = 16;
OrlanHeal.GroupCountSwitchWidth = 20;
OrlanHeal.GroupCountSwitchHorizontalSpacing = 3;
OrlanHeal.GroupCountSwitchVerticalSpacing = 2;

OrlanHeal.RaidAlpha = 0.2;
OrlanHeal.GroupAlpha = 0.2;
OrlanHeal.RaidBorderAlpha = 0.4;

OrlanHeal.RaidWindowStrata = "LOW";
OrlanHeal.RaidWindowName = "OrlanHeal_RaidWindow";
OrlanHeal.SetupWindowName = "OrlanHeal_SetupWindow";

OrlanHeal.PlayerBuffCount = 5;

OrlanHeal.CooldownSize = 40;
OrlanHeal.CooldownCountSize = 15;
OrlanHeal.MaxCooldownCount = 30;
OrlanHeal.CooldownCountPerFrame = 5;

OrlanHeal.SetupWindowWidth = 630;
OrlanHeal.SetupWindowHeight = 600;
OrlanHeal.SetupWindowLabelWidth = 230;
OrlanHeal.SetupWindowValueWidth = OrlanHeal.SetupWindowWidth - OrlanHeal.SetupWindowLabelWidth - 18 - 10;

OrlanHeal.ButtonNames =
{
	"LEFT",
	"RIGHT",
	"MIDDLE",
	"BUTTON 4",
	"BUTTON 5",
	["-w1"] = "WHEEL UP",
	["-w2"] = "WHEEL DOWN"
};