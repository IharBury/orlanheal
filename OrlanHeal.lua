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
		OrlanHeal:SetVisibleGroupCount(8);
	elseif message == "v25" then
		OrlanHeal:SetVisibleGroupCount(5);
	elseif message == "v10" then
		OrlanHeal:SetVisibleGroupCount(2);
	elseif message == "v5" then
		OrlanHeal:SetVisibleGroupCount(1);
	elseif message == "setup" then
		OrlanHeal:Setup();
	end;
end;

function OrlanHeal:Initialize(configName)
	local orlanHeal = self;

	local _, _, _, tocversion = GetBuildInfo();
	self.ConfigName = configName;
	self.EventFrame = CreateFrame("Frame");

	self.FrameRate = 10.0;

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
			if orlanHeal.ElapsedAfterUpdate > 1.0 / orlanHeal.FrameRate then
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

	self.GroupCountSwitchHeight = 13;
	self.GroupCountSwitchWidth = 17;
	self.GroupCountSwitchHorizontalSpacing = 3;
	self.GroupCountSwitchVerticalSpacing = 1;

	self.RaidAlpha = 0.2;
	self.GroupAlpha = 0.2;
	self.RaidBorderAlpha = 0.4;

	self.RaidWindowStrata = "LOW";
	self.RaidWindowName = "OrlanHeal_RaidWindow";
	self.SetupWindowName = "OrlanHeal_SetupWindow";

	self.GroupCount = 9;
	self.VisibleGroupCount = 9;
	self.IsInStartUpMode = true;

	self.PlayerSpecificBuffCount = 1;
	self.PlayerOtherBuffCount = 4;

	self.CooldownSize = 32;

	self.RaidRoles = {};

	self.SavingAbilities =
	{
		[498] = true, -- Divine Protection
		[1022] = true, -- Hand of Protection
		[5599] = true, -- Hand of Protection
		[10278] = true, -- Hand of Protection
		[20233] = true, -- Lay on Hands
		[20236] = true, -- Lay on Hands
		[642] = true, -- Divine Shield
		[6940] = true, -- Hand of Sacrifice
		[86657] = true, -- Ancient Guardian
		[33206] = true, -- Pain Suppression
		[47788] = true, -- Guardian Spirit
		[47585] = true, -- Dispersion
		[22812] = true, -- Barkskin
		[22842] = true, -- Frenzied Regeneration
		[61336] = true, -- Survival Instincts
		[30823] = true, -- Shamanistic Rage
		[48792] = true, -- Icebound Fortitude
		[48707] = true, -- Anti-Magic Shell
		[49222] = true, -- Bone Shield
		[81162] = true, -- Will of the Necropolis
		[55233] = true, -- Vampiric Blood
		[81256] = true, -- Dancing Rune Weapon
		[50461] = true, -- Anti-Magic Zone
		[19263] = true, -- Deterrence
		[45438] = true, -- Ice Block
		[5277] = true, -- Evasion
		[74001] = true, -- Combat Readiness
		[31224] = true, -- Cloak of Shadows
		[45182] = true, -- Cheating Death
		[59672] = true, -- Metamorphosis
		[54373] = true, -- Nether Protection (Arcane)
		[54371] = true, -- Nether Protection (Fire)
		[54372] = true, -- Nether Protection (Frost)
		[54370] = true, -- Nether Protection (Holy)
		[54375] = true, -- Nether Protection (Nature)
		[54374] = true, -- Nether Protection (Shadow)
		[2565] = true, -- Shield Block
		[871] = true, -- Shield Wall
		[12975] = true, -- Last Stand
		[46946] = true, -- Safeguard
		[46947] = true -- Safeguard
	};
	self.ShieldAbilities =
	{
		[17] = true, -- Power Word: Shield
		[543] = true, -- Mage Ward (Fire Ward)
		[592] = true, -- Power Word: Shield
		[600] = true, -- Power Word: Shield
		[1463] = true, -- Mana Shield
		[3288] = true, -- Moss Hide
		[3747] = true, -- Power Word: Shield
		[4057] = true, -- Fire Resistance
		[4077] = true, -- Frost Resistance
		[6065] = true, -- Power Word: Shield
		[6066] = true, -- Power Word: Shield
		[6143] = true, -- Frost Ward
		[6229] = true, -- Shadow Ward
		[7230] = true, -- Fire Protection
		[7231] = true, -- Fire Protection
		[7232] = true, -- Fire Protection
		[7233] = true, -- Fire Protection
		[7234] = true, -- Fire Protection
		[7235] = true, -- Shadow Protection
		[7236] = true, -- Frost Protection
		[7237] = true, -- Frost Protection
		[7238] = true, -- Frost Protection
		[7239] = true, -- Frost Protection
		[7240] = true, -- Frost Protection
		[7241] = true, -- Shadow Protection
		[7242] = true, -- Shadow Protection
		[7243] = true, -- Shadow Protection
		[7245] = true, -- Holy Protection
		[7246] = true, -- Holy Protection
		[7247] = true, -- Holy Protection
		[7248] = true, -- Holy Protection
		[7249] = true, -- Holy Protection
		[7250] = true, -- Nature Protection
		[7251] = true, -- Nature Protection
		[7252] = true, -- Nature Protection
		[7253] = true, -- Nature Protection
		[7254] = true, -- Nature Protection
		[7812] = true, -- Sacrifice
		[8457] = true, -- Fire Ward
		[8458] = true, -- Fire Ward
		[8461] = true, -- Frost Ward
		[8462] = true, -- Frost Ward
		[8494] = true, -- Mana Shield
		[8495] = true, -- Mana Shield
		[9800] = true, -- Holy Shield
		[10177] = true, -- Frost Ward
		[10191] = true, -- Mana Shield
		[10192] = true, -- Mana Shield
		[10193] = true, -- Mana Shield
		[10223] = true, -- Fire Ward
		[10225] = true, -- Fire Ward
		[10368] = true, -- Uther's Light Effect
		[10618] = true, -- Elemental Protection
		[10898] = true, -- Power Word: Shield
		[10899] = true, -- Power Word: Shield
		[10900] = true, -- Power Word: Shield
		[10901] = true, -- Power Word: Shield
		[11094] = true, -- Molten Shields
		[11426] = true, -- Ice Barrier
		[11647] = true, -- Power Word: Shield
		[11657] = true, -- Jang'thraze
		[11835] = true, -- Power Word: Shield
		[11974] = true, -- Power Word: Shield
		[12040] = true, -- Shadow Shield
		[12561] = true, -- Fire Protection
		[13031] = true, -- Ice Barrier
		[13032] = true, -- Ice Barrier
		[13033] = true, -- Ice Barrier
		[13043] = true, -- Molten Shields
		[13234] = true, -- Harm Prevention Belt
		[14748] = true, -- Improved Power Word: Shield
		[14768] = true, -- Improved Power Word: Shield
		[15041] = true, -- Fire Ward
		[15044] = true, -- Frost Ward
		[16891] = true, -- Shadow Protection
		[16892] = true, -- Holy Protection
		[16893] = true, -- Nature Protection
		[16894] = true, -- Fire Protection
		[16895] = true, -- Frost Protection
		[17139] = true, -- Power Word: Shield
		[17252] = true, -- Mark of the Dragon Lord
		[17543] = true, -- Fire Protection
		[17544] = true, -- Frost Protection
		[17545] = true, -- Holy Protection
		[17546] = true, -- Nature Protection
		[17548] = true, -- Shadow Protection
		[17740] = true, -- Mana Shield
		[17741] = true, -- Mana Shield
		[18942] = true, -- Fire Protection
		[20620] = true, -- Aegis of Ragnaros
		[20697] = true, -- Power Word: Shield
		[20705] = true, -- Power Shield 500
		[20706] = true, -- Power Word: Shield 500
		[21956] = true, -- Physical Protection
		[22187] = true, -- Power Word: Shield
		[22417] = true, -- Shadow Shield
		[23037] = true, -- Mana Shield Absorb Increase
		[23991] = true, -- Damage Absorb
		[24191] = true, -- Improved Power Word: Shield
		[25217] = true, -- Power Word: Shield
		[25218] = true, -- Power Word: Shield
		[25641] = true, -- Frost Ward
		[25746] = true, -- Damage Absorb
		[25747] = true, -- Damage Absorb
		[25750] = true, -- Damage Absorb
		[26131] = true, -- Trappings of Vaulted Secrets Mana Shield Bonus
		[26467] = true, -- Persistent Shield
		[26470] = true, -- Persistent Shield
		[27128] = true, -- Fire Ward
		[27131] = true, -- Mana Shield
		[27134] = true, -- Ice Barrier
		[27533] = true, -- Fire Resistance
		[27534] = true, -- Frost Resistance
		[27535] = true, -- Shadow Resistance
		[27536] = true, -- Holy Resistance
		[27538] = true, -- Nature Resistance
		[27539] = true, -- Obsidian Armor
		[27607] = true, -- Power Word: Shield
		[27688] = true, -- Bone Shield
		[27759] = true, -- Shield Generator
		[27778] = true, -- Divine Protection
		[28511] = true, -- Fire Protection
		[28512] = true, -- Frost Protection
		[28513] = true, -- Nature Protection
		[28527] = true, -- Fel Blossom
		[28538] = true, -- Holy Protection
		[28609] = true, -- Frost Ward
		[28810] = true, -- Armor of Faith
		[29408] = true, -- Power Word: Shield
		[29432] = true, -- Fire Protection
		[29503] = true, -- Lesser Warding Shield
		[29507] = true, -- Lesser Ward of Shielding
		[29674] = true, -- Lesser Shielding
		[29701] = true, -- Greater Shielding
		[29702] = true, -- Greater Ward of Shielding
		[29719] = true, -- Greater Shielding
		[29720] = true, -- Greater Ward of Shielding
		[29880] = true, -- Mana Shield
		[30456] = true, -- Nigh-Invulnerability
		[30973] = true, -- Mana Shield
		[30994] = true, -- Frost Absorption
		[30997] = true, -- Fire Absorption
		[30999] = true, -- Nature Absorption
		[31000] = true, -- Shadow Absorption
		[31662] = true, -- Anti-Magic Shell
		[31771] = true, -- Shell of Deterrence
		[31976] = true, -- Shadow Shield
		[32278] = true, -- Greater Warding Shield
		[32595] = true, -- Power Word: Shield
		[32796] = true, -- Frost Ward
		[33201] = true, -- Reflective Shield
		[33202] = true, -- Reflective Shield
		[33245] = true, -- Ice Barrier
		[33405] = true, -- Ice Barrier
		[33482] = true, -- Shadow Defense
		[33619] = true, -- Reflective Shield
		[33810] = true, -- Rock Shell
		[34206] = true, -- Physical Protection
		[35064] = true, -- Mana Shield
		[35944] = true, -- Power Word: Shield
		[36052] = true, -- Power Word: Shield
		[36481] = true, -- Arcane Barrier
		[36815] = true, -- Shock Barrier
		[37414] = true, -- Shield Block
		[37416] = true, -- Weapon Deflection
		[37830] = true, -- Repolarized Magneto Sphere
		[37844] = true, -- Fire Ward
		[38151] = true, -- Mana Shield
		[40322] = true, -- Spirit Shield
		[41373] = true, -- Power Word: Shield
		[41431] = true, -- Rune Shield
		[41475] = true, -- Reflective Shield
		[42740] = true, -- Njord's Rune of Protection
		[43010] = true, -- Fire Ward
		[43012] = true, -- Frost Ward
		[43019] = true, -- Mana Shield
		[43020] = true, -- Mana Shield
		[43038] = true, -- Ice Barrier
		[43039] = true, -- Ice Barrier
		[44175] = true, -- Power Word: Shield
		[44291] = true, -- Power Word: Shield
		[44394] = true, -- Incanter's Absorption
		[44395] = true, -- Incanter's Absorption
		[46151] = true, -- Mana Shield
		[46193] = true, -- Power Word: Shield
		[46596] = true, -- Eternal Shield
		[47509] = true, -- Divine Aegis
		[47511] = true, -- Divine Aegis
		[47515] = true, -- Divine Aegis
		[47535] = true, -- Rapture
		[47536] = true, -- Rapture
		[47537] = true, -- Rapture
		[47753] = true, -- Divine Aegis
		[47755] = true, -- Rapture
		[48065] = true, -- Power Word: Shield
		[48066] = true, -- Power Word: Shield
		[50329] = true, -- Shield of Suffering
		[53678] = true, -- Herbalist's Ward
		[53911] = true, -- Fire Protection
		[53913] = true, -- Frost Protection
		[53914] = true, -- Nature Protection
		[54512] = true, -- Plague Shield
		[54704] = true, -- Divine Aegis
		[54808] = true, -- Sonic Shield
		[55019] = true, -- Sonic Shield
		[55277] = true, -- Stoneclaw Totem
		[55283] = true, -- Eternal Shield
		[56778] = true, -- Mana Shield
		[57350] = true, -- Illusionary Barrier
		[57843] = true, -- Mojo Empowered Fire Ward
		[59288] = true, -- Infra-Green Shield
		[59616] = true, -- Njord's Rune of Protection
		[62274] = true, -- Shield of Runes
		[62277] = true, -- Shield of Runes
		[62321] = true, -- Runic Shield
		[62529] = true, -- Runic Shield
		[62618] = true, -- Power Word: Barrier
		[63136] = true, -- Winter's Embrace
		[63298] = true, -- Glyph of Stoneclaw Totem
		[63489] = true, -- Shield of Runes
		[63521] = true, -- Improved Divine Plea
		[63564] = true, -- Winter's Embrace
		[63653] = true, -- Rapture
		[63654] = true, -- Rapture
		[63929] = true, -- Stoneclaw Totem
		[63967] = true, -- Shield of Runes
		[64224] = true, -- Stone Grip Absorb
		[64225] = true, -- Stone Grip Absorb
		[64411] = true, -- Blessing of Ancient Kings
		[64415] = true, -- Val'anyr Hammer of Ancient Kings - Equip Effect
		[64677] = true, -- Shield Generator
		[65858] = true, -- Shield of Lights
		[65874] = true, -- Shield of Darkness
		[66099] = true, -- Power Word: Shield
		[66515] = true, -- Reflective Shield
		[67256] = true, -- Shield of Darkness
		[67257] = true, -- Shield of Darkness
		[67258] = true, -- Shield of Darkness
		[67259] = true, -- Shield of Lights
		[67260] = true, -- Shield of Lights
		[67261] = true, -- Shield of Lights
		[68032] = true, -- Power Word: Shield
		[68033] = true, -- Power Word: Shield
		[68034] = true, -- Power Word: Shield
		[69069] = true, -- Shield of Bones
		[69642] = true, -- Shield of Bones
		[69787] = true, -- Ice Barrier
		[70204] = true, -- Shield of Bones
		[70207] = true, -- Shield of Bones
		[70845] = true, -- Stoicism
		[71299] = true, -- Death's Embrace
		[71300] = true, -- Death's Embrace
		[71548] = true, -- Power Word: Shield
		[71586] = true, -- Hardened Skin
		[71780] = true, -- Power Word: Shield
		[71781] = true, -- Power Word: Shield
		[72055] = true, -- Absorption Shield
		[74133] = true, -- Veil of Sky
		[74372] = true, -- Veil of Sky
		[74373] = true, -- Veil of Sky
		[76307] = true, -- Absorb Magic
		[76308] = true, -- Absorb Magic
		[76669] = true, -- Illuminated Healing
		[77471] = true, -- Shadow Shield
		[77484] = true, -- Shield Discipline
		[77535] = true, -- Blood Shield
		[78646] = true, -- Bone Shield
		[79582] = true, -- Barrier
		[80341] = true, -- Ignite Flesh
		[80342] = true, -- Ignite Flesh
		[80747] = true, -- Shield of Light
		[81782] = true, -- Power Word: Barrier
		[82627] = true, -- Grounded Plasma Shield
		[82631] = true, -- Aegis of Flame
		[83842] = true, -- Power Word: Shield
		[84039] = true, -- Power Word: Shield
		[84427] = true, -- Grounded Plasma Shield
		[84677] = true, -- Sacred Oath
		[84678] = true, -- Sacred Oath
		[84679] = true, -- Sacred Oath
		[85646] = true, -- Guarded by the Light
		[86002] = true, -- Fetid Absorption
		[86273] = true, -- Illuminated Healing
		[86817] = true, -- Spell Ward
		[87191] = true, -- Mana Shield
		[88027] = true, -- Storm Shield
		[88063] = true, -- Guarded by the Light
		[90677] = true, -- Aquatic Shield
		[90760] = true, -- Veil of Sky
		[90761] = true, -- Veil of Sky
		[90762] = true, -- Veil of Sky
		[91296] = true, -- Egg Shell
		[91308] = true, -- Egg Shell
		[91492] = true, -- Absorb Magic
		[91516] = true, -- Barrier
		[91517] = true, -- Barrier
		[91518] = true, -- Barrier
		[91629] = true, -- Shield of Bones
		[91631] = true, -- Shield of Bones
		[91711] = true, -- Nether Ward
		[91894] = true, -- Ignite Flesh
		[92512] = true, -- Aegis of Flame
		[92513] = true, -- Aegis of Flame
		[92514] = true, -- Aegis of Flame
		[93059] = true, -- Storm Shield
		[93335] = true, -- Icy Shroud
		[93561] = true, -- Stone Mantle
		[93745] = true, -- Seed Casing
	};

	self.HealingBuffs = 
	{
		[136] = true, -- Mend Pet
		[139] = true, -- Обновление
		[740] = true, -- Tranquility
		[774] = true, -- Омоложение
		[974] = true, -- Щит земли
		[1058] = true, -- Омоложение
		[1159] = true, -- First Aid
		[1430] = true, -- Омоложение
		[2090] = true, -- Омоложение
		[2091] = true, -- Омоложение
		[3267] = true, -- First Aid
		[3268] = true, -- First Aid
		[3627] = true, -- Омоложение
		[5394] = true, -- Healing Stream Totem
		[6074] = true, -- Обновление
		[6075] = true, -- Обновление
		[6076] = true, -- Обновление
		[6077] = true, -- Обновление
		[6078] = true, -- Обновление
		[6410] = true, -- Food
		[7001] = true, -- Lightwell Renew
		[7144] = true, -- Stone Slumber
		[7331] = true, -- Healing Aura (TEST)
		[7927] = true, -- First Aid
		[7948] = true, -- Wild Regeneration
		[8070] = true, -- Rejuvenation
		[8348] = true, -- Julie's Blessing
		[8362] = true, -- Renew
		[8910] = true, -- Омоложение
		[8936] = true, -- Regrowth
		[9616] = true, -- Wild Regeneration
		[9839] = true, -- Омоложение
		[9840] = true, -- Омоложение
		[9841] = true, -- Омоложение
		[10838] = true, -- First Aid
		[10839] = true, -- First Aid
		[10927] = true, -- Обновление
		[10928] = true, -- Обновление
		[10929] = true, -- Обновление
		[11014] = true, -- Flow of the Northspring
		[11640] = true, -- Renew
		[12160] = true, -- Rejuvenation
		[15229] = true, -- Crystal Restore
		[15981] = true, -- Rejuvenation
		[16561] = true, -- Regrowth
		[17767] = true, -- Consume Shadows
		[18608] = true, -- First Aid
		[18610] = true, -- First Aid
		[20655] = true, -- Barkskin
		[20664] = true, -- Rejuvenation
		[20665] = true, -- Regrowth
		[20701] = true, -- Rejuvenation
		[21791] = true, -- Tranquility
		[22010] = true, -- Greater Heal Renew
		[22168] = true, -- Renew
		[22373] = true, -- Regrowth
		[22695] = true, -- Regrowth
		[23422] = true, -- Corrupted Healing Stream Totem
		[23567] = true, -- First Aid
		[23568] = true, -- First Aid
		[23569] = true, -- First Aid
		[23696] = true, -- First Aid
		[23780] = true, -- Aegis of Preservation
		[23895] = true, -- Renew
		[24412] = true, -- First Aid
		[24413] = true, -- First Aid
		[24414] = true, -- First Aid
		[25058] = true, -- Renew
		[25221] = true, -- Обновление
		[25222] = true, -- Обновление
		[25299] = true, -- Омоложение
		[25315] = true, -- Обновление
		[25817] = true, -- Tranquility
		[26981] = true, -- Омоложение
		[26982] = true, -- Омоложение
		[27030] = true, -- First Aid
		[27031] = true, -- First Aid
		[27532] = true, -- Rejuvenation
		[27606] = true, -- Renew
		[27637] = true, -- Regrowth
		[27811] = true, -- Blessed Recovery
		[27813] = true, -- Blessed Recovery
		[27815] = true, -- Blessed Recovery
		[27816] = true, -- Blessed Recovery
		[27817] = true, -- Blessed Recovery
		[27818] = true, -- Blessed Recovery
		[28880] = true, -- Gift of the Naaru
		[28995] = true, -- Stoneskin
		[29543] = true, -- Shadow Rejuvenation
		[29587] = true, -- Shadow Rejuvenation
		[29841] = true, -- Second Wind
		[29842] = true, -- Second Wind
		[31325] = true, -- Renew
		[31782] = true, -- Rejuvenation
		[32125] = true, -- Medicinal Swamp Moss
		[32131] = true, -- Rejuvenation
		[32135] = true, -- Corrupted Healing Stream Totem
		[32137] = true, -- Corrupted Air Totem
		[32593] = true, -- Щит земли
		[32594] = true, -- Щит земли
		[33763] = true, -- Lifebloom
		[33778] = true, -- Lifebloom
		[34163] = true, -- Fungal Regrowth
		[34254] = true, -- Rejuvenate Plant
		[34361] = true, -- Regrowth
		[34423] = true, -- Renew
		[34619] = true, -- Repair
		[35199] = true, -- Healing Stream Totem
		[35207] = true, -- Bandage
		[36348] = true, -- Bandage
		[36472] = true, -- Consume Shadows
		[36476] = true, -- Blood Heal
		[36679] = true, -- Renew
		[37260] = true, -- Renew
		[37487] = true, -- Blood Heal
		[37709] = true, -- Wild Regeneration
		[37967] = true, -- Fungal Regrowth
		[37978] = true, -- Renew
		[38210] = true, -- Renew
		[38299] = true, -- HoTs on Heals
		[38325] = true, -- Regeneration
		[38657] = true, -- Rejuvenation
		[38659] = true, -- Tranquility
		[38908] = true, -- Fel Regeneration Potion
		[38919] = true, -- Bandage
		[39000] = true, -- Regrowth
		[39125] = true, -- Regrowth
		[39126] = true, -- Rejuvenate Plant
		[40097] = true, -- Restoration
		[40471] = true, -- Enduring Light
		[41635] = true, -- Молитва восстановления
		[41637] = true, -- Молитва восстановления
		[42025] = true, -- Spirit Mend
		[42544] = true, -- Rejuvenation
		[42771] = true, -- Second Wind
		[44174] = true, -- Renew
		[44203] = true, -- Tranquility
		[44586] = true, -- Молитва восстановления
		[45543] = true, -- First Aid
		[45544] = true, -- First Aid
		[46192] = true, -- Renew
		[46563] = true, -- Renew
		[47079] = true, -- Renew
		[47540] = true, -- Исповедь
		[48067] = true, -- Обновление
		[48068] = true, -- Обновление
		[48110] = true, -- Молитва восстановления
		[48111] = true, -- Молитва восстановления
		[48438] = true, -- Wild Growth
		[48440] = true, -- Омоложение
		[48441] = true, -- Омоложение
		[48450] = true, -- Жизнецвет
		[48451] = true, -- Жизнецвет
		[49263] = true, -- Renew
		[49283] = true, -- Щит земли
		[49284] = true, -- Щит земли
		[49739] = true, -- Consume Shadows
		[50750] = true, -- Raven Heal
		[51803] = true, -- First Aid
		[51827] = true, -- First Aid
		[51945] = true, -- Earthliving
		[51972] = true, -- Tranquility
		[52011] = true, -- Renewing Beam
		[52895] = true, -- Bandage
		[52940] = true, -- Sleepy Time
		[53005] = true, -- Исповедь
		[53006] = true, -- Исповедь
		[53007] = true, -- Исповедь
		[53030] = true, -- Leech Poison
		[53248] = true, -- Буйный рост
		[53249] = true, -- Буйный рост
		[53251] = true, -- Буйный рост
		[53350] = true, -- Quenching Mist
		[53426] = true, -- Lick Your Wounds
		[53607] = true, -- Rejuvenation
		[54136] = true, -- Blightblood Infusion
		[54722] = true, -- Stoneskin
		[54957] = true, -- Glyph of Flash of Light
		[55680] = true, -- Glyph of Prayer of Healing
		[56161] = true, -- Glyph of Prayer of Healing
		[56176] = true, -- Prayer of Healing
		[56332] = true, -- Renew
		[57054] = true, -- Tranquility
		[57090] = true, -- Revivify
		[57777] = true, -- Renew
		[59417] = true, -- Leech Poison
		[59542] = true, -- Gift of the Naaru
		[59543] = true, -- Gift of the Naaru
		[59544] = true, -- Gift of the Naaru
		[59545] = true, -- Gift of the Naaru
		[59547] = true, -- Gift of the Naaru
		[59548] = true, -- Gift of the Naaru
		[60004] = true, -- Renew
		[60123] = true, -- Lightwell Renew
		[60530] = true, -- Forethought Talisman
		[61295] = true, -- Riptide
		[61299] = true, -- Быстрина
		[61300] = true, -- Быстрина
		[61301] = true, -- Быстрина
		[61967] = true, -- Renew
		[62209] = true, -- Photosynthesis
		[62328] = true, -- Runic Mending
		[62333] = true, -- Renew
		[62441] = true, -- Renew
		[62446] = true, -- Runic Mending
		[62804] = true, -- Rejuvenation
		[63082] = true, -- Bind Life
		[63241] = true, -- Tranquility
		[63554] = true, -- Tranquility
		[63559] = true, -- Bind Life
		[64372] = true, -- Lifebloom
		[64801] = true, -- Rejuvenation
		[64843] = true, -- Divine Hymn
		[64844] = true, -- Divine Hymn
		[64890] = true, -- Item - Paladin T8 Holy 2P Bonus
		[64891] = true, -- Holy Mending
		[64897] = true, -- Fuse Metal
		[64968] = true, -- Fuse Metal
		[65735] = true, -- Rejuvenation
		[65995] = true, -- Healing Stream Totem
		[66031] = true, -- Bandage
		[66053] = true, -- Riptide
		[66065] = true, -- Rejuvenation
		[66067] = true, -- Regrowth
		[66086] = true, -- Tranquility
		[66177] = true, -- Renew
		[66537] = true, -- Renew
		[66922] = true, -- Вспышка Света
		[67675] = true, -- Renew
		[67968] = true, -- Regrowth
		[67969] = true, -- Regrowth
		[67970] = true, -- Regrowth
		[67971] = true, -- Rejuvenation
		[67972] = true, -- Rejuvenation
		[67973] = true, -- Rejuvenation
		[67974] = true, -- Tranquility
		[67975] = true, -- Tranquility
		[67976] = true, -- Tranquility
		[68035] = true, -- Renew
		[68036] = true, -- Renew
		[68037] = true, -- Renew
		[68118] = true, -- Riptide
		[68119] = true, -- Riptide
		[68120] = true, -- Riptide
		[68864] = true, -- Restitching
		[69382] = true, -- Light's Favor
		[69867] = true, -- Barrens Bloom
		[69882] = true, -- Regrowth
		[69898] = true, -- Rejuvenation
		[70517] = true, -- Healing Stream Totem
		[70691] = true, -- Rejuvenation
		[70772] = true, -- Blessed Healing
		[70809] = true, -- Chained Heal
		[71141] = true, -- Regrowth
		[71142] = true, -- Rejuvenation
		[71864] = true, -- Fountain of Light
		[71866] = true, -- Fountain of Light
		[71932] = true, -- Renew
		[71956] = true, -- Replenishing Rains
		[71984] = true, -- Healing Stream Totem
		[72932] = true, -- Regrowth
		[72996] = true, -- First Aid
		[74553] = true, -- First Aid
		[74554] = true, -- First Aid
		[74555] = true, -- First Aid
		[75011] = true, -- Lunar Blessing
		[75367] = true, -- Riptide
		[75368] = true, -- Healing Stream Totem
		[75493] = true, -- Twilight Renewal
		[75494] = true, -- Twilight Renewal
		[75940] = true, -- Tranquility
		[76314] = true, -- Blazing Twilight Shield
		[77485] = true, -- Echo of Light
		[77489] = true, -- Echo of Light
		[77912] = true, -- Remedy
		[78125] = true, -- Blazing Shield
		[80304] = true, -- Rejuvenation
		[80856] = true, -- Zanzil's Elixir
		[81648] = true, -- Tranquility
		[81211] = true, -- Woodpaw Brand
		[82327] = true, -- Holy Radiance
		[84158] = true, -- Regrowth
		[84472] = true, -- Rejuvenation
		[84824] = true, -- Renew
		[85636] = true, -- Earth Spirit's Repose
		[86452] = true, -- Holy Radiance
		[87279] = true, -- Eric's Pocket Potion
		[87284] = true, -- Eric's Pocket Potion - Player Effect
		[87351] = true, -- Eating
		[87609] = true, -- Amakkar's Pocket Potion
		[87610] = true, -- Amakkar's Pocket Potion - Player Effect
		[88233] = true, -- Crimson Flames
		[88664] = true, -- Holy Word: Aspire
		[88682] = true, -- Holy Word: Aspire
		[89123] = true, -- Energizing Growth
		[89124] = true, -- Energizing Growth
		[89595] = true, -- Tol Barad Bandage
		[90308] = true, -- Blazing Twilight Shield
		[90361] = true, -- Spirit Mend
		[90399] = true, -- Riptide
		[90801] = true, -- Rejuvenation CK Variant
		[90914] = true, -- Riptide
		[92965] = true, -- Remedy
		[92966] = true, -- Remedy
		[92967] = true, -- Remedy
		[93075] = true, -- Whisper of the Djinni
		[93094] = true, -- Renew
		[93349] = true, -- Crimson Flames
		[93466] = true, -- Glyph of the Long Word
		[93705] = true, -- Pity Heal
		[93706] = true, -- Pity Heal
	};

	self.IgnoredDebuffs = 
	{
		[58539] = true, -- Тело наблюдателя
		[69127] = true, -- Холод Трона
		[64816] = true, -- Победа над нежитью
		[64815] = true, -- Победа над тауреном
		[64814] = true, -- Победа над человеком
		[64813] = true, -- Победа над эльфом крови
		[64812] = true, -- Победа над троллем
		[64811] = true, -- Победа над орком
		[64810] = true, -- Победа над дворфом
		[64809] = true, -- Победа над гномом
		[64808] = true, -- Победа над дренеем
		[64805] = true, -- Победа над эльфом
		[72144] = true, -- Шлейф оранжевой заразы
		[72145] = true, -- Шлейф зеленой заразы
		[71041] = true, -- Dungeon Deserter
		[80354] = true, -- Temporal Displacement
		[57723] = true, -- Exhaustion
		[57724] = true, -- Sated
		[28531] = true, -- Frost Aura
		[55799] = true, -- Frost Aura
		[71387] = true, -- Frost Aura
		[71052] = true, -- Frost Aura
		[71051] = true, -- Frost Aura
		[71050] = true, -- Frost Aura
		[70084] = true -- Frost Aura
	};

	self.CriticalDebuffs =
	{
		[74325] = true, -- Harvest Soul
		[74326] = true, -- Harvest Soul
		[74327] = true, -- Harvest Soul
		[68980] = true, -- Harvest Soul
		[67051] = true, -- Incinerate Flesh
		[67050] = true, -- Incinerate Flesh
		[67049] = true, -- Incinerate Flesh
		[66237] = true, -- Incinerate Flesh
		[73787] = true, -- Necrotic Plague
		[73786] = true, -- Necrotic Plague
		[73785] = true, -- Necrotic Plague
		[70338] = true, -- Necrotic Plague
		[73914] = true, -- Necrotic Plague
		[73913] = true, -- Necrotic Plague
		[73912] = true, -- Necrotic Plague
		[70337] = true, -- Necrotic Plague
		[70911] = true, -- Unbound Plague
		[72854] = true, -- Unbound Plague
		[72856] = true, -- Unbound Plague
		[72855] = true, -- Unbound Plague
		[69410] = true, -- Soul Reaper
		[73799] = true, -- Soul Reaper
		[73798] = true, -- Soul Reaper
		[73797] = true, -- Soul Reaper
		[69409] = true, -- Soul Reaper
		[72280] = true, -- Mark of the Fallen Champion
		[72444] = true, -- Mark of the Fallen Champion
		[72445] = true, -- Mark of the Fallen Champion
		[72446] = true, -- Mark of the Fallen Champion
		[72254] = true, -- Mark of the Fallen Champion
		[72279] = true, -- Mark of the Fallen Champion
		[72255] = true, -- Mark of the Fallen Champion
		[72278] = true, -- Mark of the Fallen Champion
		[72256] = true, -- Mark of the Fallen Champion
		[72260] = true, -- Mark of the Fallen Champion
		[72293] = true, -- Mark of the Fallen Champion
		[73143] = true, -- Bone Spike Graveyard
		[73142] = true, -- Bone Spike Graveyard
		[73144] = true, -- Bone Spike Graveyard
		[73145] = true, -- Bone Spike Graveyard
		[72089] = true, -- Bone Spike Graveyard
		[72088] = true, -- Bone Spike Graveyard
		[70826] = true, -- Bone Spike Graveyard
		[69057] = true, -- Bone Spike Graveyard
		[72858] = true, -- Gaseous Bloat
		[72859] = true, -- Gaseous Bloat
		[72860] = true, -- Gaseous Bloat
		[72833] = true, -- Gaseous Bloat
		[70672] = true, -- Gaseous Bloat
		[72455] = true, -- Gaseous Bloat
		[70215] = true, -- Gaseous Bloat
		[72832] = true, -- Gaseous Bloat
		[72838] = true, -- Volatile Ooze Adhesive
		[72837] = true, -- Volatile Ooze Adhesive
		[72836] = true, -- Volatile Ooze Adhesive
		[70447] = true, -- Volatile Ooze Adhesive
		[71224] = true, -- Mutated Infection
		[73022] = true, -- Mutated Infection
		[73023] = true, -- Mutated Infection
		[69674] = true, -- Mutated Infection
		[71264] = true, -- Swarming Shadows
		[72890] = true, -- Swarming Shadows
		[71266] = true, -- Swarming Shadows
		[71265] = true, -- Swarming Shadows
		[72640] = true, -- Swarming Shadows
		[72639] = true, -- Swarming Shadows
		[72638] = true, -- Swarming Shadows
		[71277] = true, -- Swarming Shadows
		[71861] = true, -- Swarming Shadows
		[71336] = true, -- Pact of the Darkfallen
		[71340] = true, -- Pact of the Darkfallen
		[71341] = true, -- Pact of the Darkfallen
		[71390] = true, -- Pact of the Darkfallen
		[74562] = true, -- Fiery Combustion
		[74792] = true, -- Soul Consumption
		[67574] = true, -- Pursued by Anub'arak
		[67614] = true, -- Paralytic Bite
		[67613] = true, -- Paralytic Bite
		[67612] = true, -- Paralytic Bite
		[66824] = true, -- Paralytic Bite
		[67626] = true, -- Burning Bite
		[67625] = true, -- Burning Bite
		[67624] = true, -- Burning Bite
		[66879] = true, -- Burning Bite
		[70126] = true -- Frost Beacon
	};

	self.AvailableSpells =
	{
		635, -- Holy Light
		19750, -- Flash of Light
		1022, -- Hand of Protection
		4987, -- Cleanse
		20473, -- Holy Shock
		633, -- Lay on Hands
		85673, -- Word of Glory
		1038, -- Hand of Salvation
		82326, -- Divine Light
		53563, -- Beacon of Light
		6940, -- Hand of Sacrifice
		1044, -- Hand of Freedom
		59542, -- Дар наауру
		20217, -- Blessing of Kings
		7328, -- Redemption
		31789, -- Righteous Defense
		19740 -- Blessing of Might
	};
end;

function OrlanHeal:CreateSetupWindow()
	local orlanHeal = self;

	local setupWindow = CreateFrame("Frame", self.SetupWindowName, UIParent);
	setupWindow:SetPoint("CENTER", 0, 0);
	setupWindow:SetFrameStrata("DIALOG");

	local background = setupWindow:CreateTexture();
	background:SetAllPoints();
	background:SetTexture(0, 0, 0, 0.6);

	setupWindow:SetHeight(340);
	setupWindow:SetWidth(450);
	setupWindow:Hide();

	setupWindow.Spell1Window = self:CreateSpellSelectWindow(setupWindow, "Spell1", "1", 0, "LEFT");
	setupWindow.Spell2Window = self:CreateSpellSelectWindow(setupWindow, "Spell2", "2", 1, "RIGHT");
	setupWindow.Spell3Window = self:CreateSpellSelectWindow(setupWindow, "Spell3", "3", 2, "MIDDLE");
	setupWindow.AltSpell1Window = self:CreateSpellSelectWindow(setupWindow, "AltSpell1", "alt1", 3, "ALT LEFT");
	setupWindow.AltSpell2Window = self:CreateSpellSelectWindow(setupWindow, "AltSpell2", "alt2", 4, "ALT RIGHT");
	setupWindow.AltSpell3Window = self:CreateSpellSelectWindow(setupWindow, "AltSpell3", "alt3", 5, "ALT MIDDLE");
	setupWindow.ShiftSpell1Window = self:CreateSpellSelectWindow(setupWindow, "ShiftSpell1", "shift1", 6, "SHIFT LEFT");
	setupWindow.ShiftSpell2Window = self:CreateSpellSelectWindow(setupWindow, "ShiftSpell2", "shift2", 7, "SHIFT RIGHT");
	setupWindow.ShiftSpell3Window = self:CreateSpellSelectWindow(setupWindow, "ShiftSpell3", "shift3", 8, "SHIFT MIDDLE");
	setupWindow.ControlSpell1Window = self:CreateSpellSelectWindow(setupWindow, "ControlSpell1", "control1", 9, "CONTROL LEFT");
	setupWindow.ControlSpell2Window = self:CreateSpellSelectWindow(setupWindow, "ControlSpell2", "control2", 10, "CONTROL RIGHT");
	setupWindow.ControlSpell3Window = self:CreateSpellSelectWindow(setupWindow, "ControlSpell3", "control3", 11, "CONTROL MIDDLE");

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
	self.Config["1"] = self.Config["1"] or 635; -- Holy Light
	self.Config["2"] = self.Config["2"] or 19750; -- Flash of Light
	self.Config["3"] = self.Config["3"] or 1022; -- Hand of Protection
	self.Config["shift1"] = self.Config["shift1"] or "target";
	self.Config["shift2"] = self.Config["shift2"] or 53563; -- Beacon of Light
	self.Config["shift3"] = self.Config["shift3"] or 1038; -- Hand of Salvation
	self.Config["control1"] = self.Config["control1"] or 82326; -- Divine Light
	self.Config["control2"] = self.Config["control2"] or 85673; -- Word of Glory
	self.Config["control3"] = self.Config["control3"] or 6940; -- Hand of Sacrifice
	self.Config["alt1"] = self.Config["alt1"] or 4987; -- Cleanse
	self.Config["alt2"] = self.Config["alt2"] or 20473; -- Holy Shock
	self.Config["alt3"] = self.Config["alt3"] or 633; -- Lay on Hands
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

	local background = raidWindow:CreateTexture();
	background:SetPoint("TOPLEFT", 3, -3);
	background:SetPoint("BOTTOMRIGHT", -3, 3);
	background:SetTexture(0, 0, 0, self.RaidAlpha);

	raidWindow:SetPoint("CENTER", 0, 0);
	raidWindow:SetFrameStrata(self.RaidWindowStrata);
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

	self:CreateBorder(raidWindow, 3, 0);

	raidWindow.Cooldowns = self:CreateCooldowns(raidWindow);

	raidWindow.GroupCountSwitches = {};
	raidWindow.VisibleGroupCountSwitches = {};
	local index = 0;
	for size = 5, 40, 5 do
		raidWindow.GroupCountSwitches[size] = self:CreateGroupCountSwitch(raidWindow, size, index);
		raidWindow.VisibleGroupCountSwitches[size] = self:CreateVisibleGroupCountSwitch(raidWindow, size, index);
		index = index + 1;
	end;

	return raidWindow;
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

function OrlanHeal:CreateCooldowns(parent)
	local cooldowns = {};

	cooldowns[0] = self:CreateCooldown(parent, 0, 53655, 20271, true); -- Judgements of the Pure
	cooldowns[1] = self:CreateCooldown(parent, 1, 53563, 53563, true); -- Beacon of Light
	cooldowns[2] = self:CreateCooldown(parent, 2, 82327, 82327, false); -- Holy Radiance
	cooldowns[3] = self:CreateCooldown(parent, 3, 85222, 85222, false); -- Light of Dawn

	return cooldowns;
end;

function OrlanHeal:CreateCooldown(parent, index, imageSpellId, castSpellId, isReverse)
	local cooldown = CreateFrame("Cooldown", nil, parent, "CooldownFrameTemplate");
	cooldown:ClearAllPoints();
	cooldown:SetPoint(
		"BOTTOMLEFT", 
		parent, 
		"TOPLEFT", 
		self.RaidOuterSpacing + self.GroupOuterSpacing + index * self.CooldownSize * (1 + 1 / 8), 
		self.RaidOuterSpacing);
	cooldown:SetHeight(self.CooldownSize);
	cooldown:SetWidth(self.CooldownSize);

	cooldown.Background = parent:CreateTexture(nil, "BACKGROUND");
	cooldown.Background:SetAllPoints(cooldown);
	cooldown.Background:SetAlpha(0.5);

	local _, _, icon = GetSpellInfo(imageSpellId);
	cooldown.Background:SetTexture(icon);
	cooldown:SetReverse(isReverse);

	if castSpellId then
		cooldown.Button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");
		cooldown.Button:SetAllPoints(cooldown);
		cooldown.Button:RegisterForClicks("LeftButtonDown");
		cooldown.Button:SetAttribute("type", "spell");
		cooldown.Button:SetAttribute("spell", castSpellId);
	end;

	return cooldown;
end;

function OrlanHeal:CreateBorder(window, thickness, offset)
	window.TopBorder = window:CreateTexture();
	window.TopBorder:SetPoint("TOPLEFT", -offset, offset);
	window.TopBorder:SetPoint("TOPRIGHT", offset, offset);
	window.TopBorder:SetHeight(thickness);

	window.BottomBorder = window:CreateTexture();
	window.BottomBorder:SetPoint("BOTTOMLEFT", -offset, -offset);
	window.BottomBorder:SetPoint("BOTTOMRIGHT", offset, -offset);
	window.BottomBorder:SetHeight(thickness);

	window.LeftBorder = window:CreateTexture();
	window.LeftBorder:SetPoint("TOPLEFT", -offset, offset - thickness);
	window.LeftBorder:SetPoint("BOTTOMLEFT", -offset, -offset + thickness);
	window.LeftBorder:SetWidth(thickness);

	window.RightBorder = window:CreateTexture();
	window.RightBorder:SetPoint("TOPRIGHT", offset, offset - thickness);
	window.RightBorder:SetPoint("BOTTOMRIGHT", offset, -offset + thickness);
	window.RightBorder:SetWidth(thickness);
end;

function OrlanHeal:SetBorderColor(window, r, g, b, a)
	window.TopBorder:SetTexture(r, g, b, a);
	window.BottomBorder:SetTexture(r, g, b, a);
	window.LeftBorder:SetTexture(r, g, b, a);
	window.RightBorder:SetTexture(r, g, b, a);
end;

function OrlanHeal:CreateGroupWindow(parent, isOnTheRight)
	local groupWindow = CreateFrame("Frame", nil, parent);

	local background = groupWindow:CreateTexture();
	background:SetAllPoints();
	background:SetTexture(0, 0, 0, self.GroupAlpha);

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

	playerWindow:SetHeight(self.PlayerHeight);
	playerWindow:SetWidth(self.PlayerWidth);

	self:CreateUnitButton(playerWindow);
	self:CreateBlankCanvas(playerWindow);
	self:CreateRangeBar(playerWindow.Canvas);
	self:CreateHealthBar(playerWindow.Canvas, self.PlayerStatusWidth);
	self:CreateManaBar(playerWindow.Canvas, self.PlayerStatusWidth);
	self:CreateNameBar(playerWindow.Canvas, self.PlayerStatusWidth);
	self:CreateBuffs(playerWindow.Canvas, self.PlayerSpecificBuffCount, self.PlayerOtherBuffCount, 3, 2);
	self:CreateBorder(playerWindow.Canvas, 1, 1);
	self:CreateRoleIcon(playerWindow.Canvas);
	self:CreateTargetIcon(playerWindow.Canvas, self.PlayerStatusWidth);

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

function OrlanHeal:CreateRoleIcon(canvas)
	canvas.Role = canvas:CreateTexture(nil, "OVERLAY");
	canvas.Role:SetHeight(self.NameHeight);
	canvas.Role:SetWidth(self.NameHeight);
	canvas.Role:SetPoint("TOPLEFT", self.RangeWidth + self.PlayerStatusWidth - self.NameHeight * 2, 0);
end;

function OrlanHeal:CreateTargetIcon(canvas, statusWidth)
	canvas.Target = canvas:CreateTexture(nil, "OVERLAY");
	canvas.Target:SetHeight(self.NameHeight);
	canvas.Target:SetWidth(self.NameHeight);
	canvas.Target:SetPoint("TOPLEFT", self.RangeWidth + statusWidth - self.NameHeight, 0);
end;

function OrlanHeal:CreateBuffs(parent, specificBuffCount, otherBuffCount, specificDebuffCount, otherDebuffCount)
	if specificBuffCount > 0 then
		parent.SpecificBuffs = {};

		for buffIndex = 0, specificBuffCount - 1 do
			parent.SpecificBuffs[buffIndex] = self:CreateBuff(
				parent, 
				"TOPRIGHT", 
				-(otherBuffCount + specificBuffCount - buffIndex) * self.BuffSize,
				0);
		end;
	end;

	parent.OtherBuffs = {};

	for buffIndex = 0, otherBuffCount - 1 do
		parent.OtherBuffs[buffIndex] = self:CreateBuff(
			parent,
			"TOPRIGHT", 
			-(otherBuffCount - buffIndex) * self.BuffSize,
			0);
	end;

	if specificDebuffCount > 0 then
		parent.SpecificDebuffs = {};

		for buffIndex = 0, specificDebuffCount - 1 do
			parent.SpecificDebuffs[buffIndex] = self:CreateBuff(
				parent,
				"BOTTOMRIGHT", 
				-(otherDebuffCount + specificDebuffCount - buffIndex) * self.BuffSize,
				self.BuffSize);
		end;
	end;

	parent.OtherDebuffs = {};

	for buffIndex = 0, otherDebuffCount - 1 do
		parent.OtherDebuffs[buffIndex] = self:CreateBuff(
			parent,
			"BOTTOMRIGHT", 
			-(otherDebuffCount - buffIndex) * self.BuffSize,
			self.BuffSize);
	end;
end;

function OrlanHeal:CreateBuff(parent, point, x, y)
	local buff = {};

	buff.Image = parent:CreateTexture(nil, "BORDER");
	buff.Image:SetHeight(self.BuffSize);
	buff.Image:SetWidth(self.BuffSize);
	buff.Image:SetPoint("TOPLEFT", parent, point, x, y);

	buff.Time = parent:CreateTexture(nil, "OVERLAY");
	buff.Time:SetHeight(self.BuffSize);
	buff.Time:SetWidth(self.BuffSize);
	buff.Time:SetPoint("TOPLEFT", parent, point, x, y);

	local buffCountSize = self.BuffSize;
	buff.Count = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	buff.Count:SetHeight(buffCountSize);
	buff.Count:SetWidth(buffCountSize);
	buff.Count:SetTextColor(1, 1, 1, 1);
	buff.Count:SetShadowColor(0, 0, 0, 1);
	buff.Count:SetShadowOffset(-1, -1);
	buff.Count:SetTextHeight(buffCountSize);
	buff.Count:SetPoint("TOPLEFT", parent, point, x + 2, y - 2);

	return buff;
end;

function OrlanHeal:CreateBlankCanvas(parent)
	parent.Canvas = CreateFrame("Frame", nil, parent);
	parent.Canvas:SetAllPoints();
	parent.Canvas.BackgroundTexture = parent.Canvas:CreateTexture(nil, "BACKGROUND");
	parent.Canvas.BackgroundTexture:SetTexture(0.2, 0.2, 0.2, 1);
	parent.Canvas.BackgroundTexture:SetAllPoints();
end;

function OrlanHeal:CreateRangeBar(parent)
	parent.RangeBar = parent:CreateTexture();
	parent.RangeBar:SetWidth(self.RangeWidth);
	parent.RangeBar:SetPoint("TOPLEFT", 0, 0);
	parent.RangeBar:SetPoint("BOTTOMLEFT", 0, 0);
end;

function OrlanHeal:CreateNameBar(parent, width)
	parent.NameBar = parent:CreateFontString(nil, nil, "GameFontNormal");
	parent.NameBar:SetHeight(self.NameHeight);
	parent.NameBar:SetWidth(width);
	parent.NameBar:SetPoint("TOPLEFT", self.RangeWidth, 0);
	parent.NameBar:SetJustifyH("LEFT");
	parent.NameBar:SetWordWrap(false);
	parent.NameBar:SetTextHeight(self.NameFontHeight);
end;

function OrlanHeal:CreateStatusBar(parent, backgroundColor, currentColor, incomingColor, yourIncomingColor, overincomingColor, overincomingWidth)
	incomingColor = incomingColor or { r = 0, g = 0, b = 0 };
	yourIncomingColor = yourIncomingColor or { r = 0, g = 0, b = 0 };
	overincomingColor = overincomingColor or { r = 0, g = 0, b = 0 };
	overincomingWidth = overincomingWidth or 1;

	local bar = CreateFrame("Frame", nil, parent);

	bar.Background = bar:CreateTexture(nil, "BACKGROUND");
	bar.Background:SetAllPoints();
	bar.Background:SetTexture(backgroundColor.r, backgroundColor.g, backgroundColor.b, 1);

	bar.Current = bar:CreateTexture();
	bar.Current:SetPoint("TOPLEFT", 0, 0);
	bar.Current:SetPoint("BOTTOMLEFT", 0, 0);
	self:SetStatusBarCurrentColor(bar, currentColor);

	bar.Incoming = bar:CreateTexture();
	bar.Incoming:SetTexture(incomingColor.r, incomingColor.g, incomingColor.b, 1);

	bar.YourIncoming = bar:CreateTexture();
	bar.YourIncoming:SetTexture(yourIncomingColor.r, yourIncomingColor.g, yourIncomingColor.b, 1);

	bar.Overincoming = bar:CreateTexture();
	bar.Overincoming:SetPoint("TOPRIGHT", overincomingWidth, 0);
	bar.Overincoming:SetPoint("BOTTOMRIGHT", overincomingWidth, 0);
	bar.Overincoming:SetWidth(overincomingWidth);
	bar.Overincoming:SetTexture(overincomingColor.r, overincomingColor.g, overincomingColor.b, 1);

	return bar;
end;

function OrlanHeal:SetStatusBarCurrentColor(bar, currentColor)
	bar.Current:SetTexture(currentColor.r, currentColor.g, currentColor.b, 1);
end;

function OrlanHeal:UpdateStatusBar(bar, currentValue, maxValue, incomingValue, yourIncomingValue)
	local width = bar:GetWidth();

	currentValue = currentValue or 0;
	maxValue = maxValue or 1;
	incomingValue = incomingValue or 0;
	yourIncomingValue = yourIncomingValue or 0;
	if (currentValue > maxValue) then
		currentValue = maxValue;
	end;
	local isOverincoming = false;
	if (currentValue + incomingValue > maxValue) then
		incomingValue = maxValue - currentValue;
		isOverincoming = true;
	end;
	if yourIncomingValue > incomingValue then
		yourIncomingValue = incomingValue;
	end;

	local currentPosition = currentValue * width / maxValue;
	local incomingPosition = (currentValue + incomingValue - yourIncomingValue) * width / maxValue;
	local yourIncomingPosition = (currentValue + incomingValue) * width / maxValue;
	
	bar.Current:SetWidth(currentPosition);

	bar.Incoming:SetPoint("TOPLEFT", currentPosition, 0);
	bar.Incoming:SetPoint("BOTTOMLEFT", currentPosition, 0);
	bar.Incoming:SetWidth(incomingPosition - currentPosition);
	if (incomingPosition - currentPosition == 0) then
		bar.Incoming:SetVertexColor(1, 1, 1, 0);
	else
		bar.Incoming:SetVertexColor(1, 1, 1, 1);
	end;
	
	bar.YourIncoming:SetPoint("TOPLEFT", incomingPosition, 0);
	bar.YourIncoming:SetPoint("BOTTOMLEFT", incomingPosition, 0);
	bar.YourIncoming:SetWidth(yourIncomingPosition - incomingPosition);
	if (yourIncomingPosition - incomingPosition == 0) then
		bar.YourIncoming:SetVertexColor(1, 1, 1, 0);
	else
		bar.YourIncoming:SetVertexColor(1, 1, 1, 1);
	end;

	if isOverincoming then
		bar.Overincoming:SetVertexColor(1, 1, 1, 1);
	else
		bar.Overincoming:SetVertexColor(1, 1, 1, 0);
	end;
end;

function OrlanHeal:CreateHealthBar(parent, width)
	parent.HealthBar = self:CreateStatusBar(
		parent,
		{ r = 0.4, g = 0.4, b = 0.4 },
		{ r = 0.2, g = 0.75, b = 0.2 },
		{ r = 0.75, g = 0.5, b = 0.2 },
		{ r = 0.75, g = 0.75, b = 0.2 },
		{ r = 1, g = 0.2, b = 0.2 },
		3);
	parent.HealthBar:SetHeight(self.HealthHeight);
	parent.HealthBar:SetWidth(width);
	parent.HealthBar:SetPoint("BOTTOMLEFT", self.RangeWidth, self.ManaHeight);
end;

function OrlanHeal:CreateManaBar(parent, width)
	parent.ManaBar = self:CreateStatusBar(
		parent,
		{ r = 0.4, g = 0.4, b = 0.4 },
		{ r = 0.2, g = 0.2, b = 0.75 });
	parent.ManaBar:SetHeight(self.ManaHeight);
	parent.ManaBar:SetWidth(width);
	parent.ManaBar:SetPoint("BOTTOMLEFT", self.RangeWidth, 0);
end;

function OrlanHeal:CreateUnitButton(parent)
	parent.Button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate");
	parent.Button:SetAllPoints();

	self:SetupSpells(parent.Button);
end;

function OrlanHeal:CreatePetWindow(parent)
	local petWindow = CreateFrame("Frame", nil, parent);

	petWindow:SetHeight(self.PlayerHeight);
	petWindow:SetWidth(self.PetWidth);

	self:CreateUnitButton(petWindow);
	self:CreateBlankCanvas(petWindow);
	self:CreateRangeBar(petWindow.Canvas);
	self:CreateHealthBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateManaBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateNameBar(petWindow.Canvas, self.PetStatusWidth);
	self:CreateBuffs(petWindow.Canvas, 0, 2, 1, 1);
	self:CreateBorder(petWindow.Canvas, 1, 1);
	self:CreateTargetIcon(petWindow.Canvas, self.PetStatusWidth);

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
		print("OrlanHeal: Cannot be done in combat.");
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
		self:UpdateGroupCountSwitches();
	end;
end;

function OrlanHeal:SetVisibleGroupCount(newVisibleGroupCount)
	self.VisibleGroupCount = newVisibleGroupCount;
	self:UpdateGroupCountSwitches();
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
			if self.VisibleGroupCount == size / 5 then
				visibleGroupCountTexture:SetTexture(1, 0.5, 0.5, 1);
			else
				visibleGroupCountTexture:SetTexture(0, 0, 0, 1);
			end;
		end;
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

	self.RaidRoles = {};

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

		local _, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(unitNumber);
		self.RaidRoles["raid" .. unitNumber] = role;
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
			self:UpdatePlayerRoleIcon(player);
		end;
	end;

	self:UpdateRaidBorder();
	self:UpdateCooldowns();
end;

function OrlanHeal:UpdateCooldowns()
	self:UpdatePlayerBuffCooldown(self.RaidWindow.Cooldowns[0], 53655); -- Judgements of the Pure
	self:UpdateRaidBuffCooldown(self.RaidWindow.Cooldowns[1], 53563); -- Beacon of Light
	self:UpdateAbilityCooldown(self.RaidWindow.Cooldowns[2], 82327); -- Holy Radiance
	self:UpdateAbilityCooldown(self.RaidWindow.Cooldowns[3], 85222); -- Light of Dawn
end;

function OrlanHeal:UpdatePlayerBuffCooldown(cooldown, spellId)
	local _, _, _, _, _, duration, expirationTime = UnitBuff("player", GetSpellInfo(spellId));
	self:UpdateCooldown(cooldown, duration, expirationTime);
end;

function OrlanHeal:UpdateAbilityCooldown(cooldown, spellId)
	local start, duration, enabled = GetSpellCooldown(spellId);
	local expirationTime;
	if enabled then
		expirationTime = start + duration;
	else
		start = nil;
		duration = nil;
		expirationTime = nil;
	end;
	self:UpdateCooldown(cooldown, duration, expirationTime);
end;

function OrlanHeal:UpdateRaidBuffCooldown(cooldown, spellId)
	local duration, expirationTime = self:GetRaidBuffCooldown(spellId);
	self:UpdateCooldown(cooldown, duration, expirationTime);
end;

function OrlanHeal:GetRaidBuffCooldown(spellId)
	local duration, expirationTime = self:GetPlayerCastUnitBuffCooldown("player", spellId);
	if duration then
		return duration, expirationTime;
	end;

	duration, expirationTime = self:GetPlayerCastUnitBuffCooldown("pet", spellId);
	if duration then
		return duration, expirationTime;
	end;

	for i = 1, 4 do
		duration, expirationTime = self:GetPlayerCastUnitBuffCooldown("party" .. i, spellId);
		if duration then
			return duration, expirationTime;
		end;

		duration, expirationTime = self:GetPlayerCastUnitBuffCooldown("partypet" .. i, spellId);
		if duration then
			return duration, expirationTime;
		end;
	end;

	for i = 1, 40 do
		duration, expirationTime = self:GetPlayerCastUnitBuffCooldown("raid" .. i, spellId);
		if duration then
			return duration, expirationTime;
		end;

		duration, expirationTime = self:GetPlayerCastUnitBuffCooldown("raidpet" .. i, spellId);
		if duration then
			return duration, expirationTime;
		end;
	end;
end;

function OrlanHeal:GetPlayerCastUnitBuffCooldown(unit, spellId)
	local i = 1;
	while true do
		local _, _, _, _, _, duration, expirationTime, _, _, _, buffId = UnitBuff(unit, i, "PLAYER");
		if not buffId then
			return;
		end;

		if buffId == spellId then
			return duration, expirationTime;
		end;

		i = i + 1;
	end;
end;

function OrlanHeal:UpdateCooldown(cooldown, duration, expirationTime)
	expirationTime = expirationTime or 0;
	if expirationTime ~= cooldown.Off then
		cooldown.Off = expirationTime;
		if duration and expirationTime then
			cooldown:SetCooldown(expirationTime - duration, duration);
		else
			cooldown:SetCooldown(0, 10);
		end;
	end;
end;

function OrlanHeal:UpdatePlayerRoleIcon(player)
	local unit = player.Button:GetAttribute("unit");
	local role = self.RaidRoles[unit];
	if role == "MAINTANK" then
		player.Canvas.Role:SetTexture("Interface\\GroupFrame\\UI-Group-MainTankIcon");
		player.Canvas.Role:SetTexCoord(0, 1, 0, 1);
	elseif role == "MAINASSIST" then
		player.Canvas.Role:SetTexture("Interface\\GroupFrame\\UI-Group-MainAssistIcon");
		player.Canvas.Role:SetTexCoord(0, 1, 0, 1);
	else
		role = UnitGroupRolesAssigned(unit);
		if role == "TANK" then
			player.Canvas.Role:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
			player.Canvas.Role:SetTexCoord(0, 19/64, 22/64, 41/64);
		elseif role == "HEALER" then
			player.Canvas.Role:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
			player.Canvas.Role:SetTexCoord(20/64, 39/64, 1/64, 20/64);
		elseif role == "DAMAGER" then
			player.Canvas.Role:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
			player.Canvas.Role:SetTexCoord(20/64, 39/64, 22/64, 41/64);
		else
			player.Canvas.Role:SetTexture(0, 0, 0, 0);
		end;
	end;
end;

function OrlanHeal:UpdateTargetIcon(canvas, unit)
	local target = GetRaidTargetIndex(unit);
	if target then
		canvas.Target:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcons");
		local left = mod(target - 1, 4) / 4;
		local right = left + 1 / 4;
		local top = floor((target - 1) / 4) / 4;
		local bottom = top + 1 / 4;
		canvas.Target:SetTexCoord(left, right, top, bottom);
	else
		canvas.Target:SetTexture(0, 0, 0, 0);
	end;
end;

function OrlanHeal:IsSpellReady(spellId)
	local result = false;

	if IsUsableSpell(GetSpellInfo(spellId)) then
		local start, duration = GetSpellCooldown(spellId);
		result = not ((start > 0) and (duration > 1.5)); -- cooldowns less than GCD are ignored (latency + queueing)
	end;

	return result;
end;

function OrlanHeal:UpdateRaidBorder()
	if (UnitPower("player", SPELL_POWER_HOLY_POWER) == 3)
			and self:IsSpellReady(85673) then -- Word of Glory
		self:SetBorderColor(self.RaidWindow, 0, 1, 0, self.RaidBorderAlpha);
	elseif UnitBuff("player", GetSpellInfo(54149)) then -- Infusion of Light
		self:SetBorderColor(self.RaidWindow, 0, 0, 1, self.RaidBorderAlpha);
	elseif UnitBuff("player", GetSpellInfo(88819)) -- Daybreak
			and self:IsSpellReady(20473) then -- Holy Shock
		self:SetBorderColor(self.RaidWindow, 1, 1, 1, self.RaidBorderAlpha);
	elseif self:IsSpellReady(20473) then -- Holy Shock
		self:SetBorderColor(self.RaidWindow, 1, 1, 0, self.RaidBorderAlpha);
	elseif (UnitPower("player", SPELL_POWER_HOLY_POWER) == 2)
			and self:IsSpellReady(85673) then -- Word of Glory
		self:SetBorderColor(self.RaidWindow, 1, 0.5, 0, self.RaidBorderAlpha);
	elseif (UnitPower("player", SPELL_POWER_HOLY_POWER) == 1)
			and self:IsSpellReady(85673) then -- Word of Glory
		self:SetBorderColor(self.RaidWindow, 1, 0, 0, self.RaidBorderAlpha);
	else
		self:SetBorderColor(self.RaidWindow, 0, 0, 0, 0);
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
		self:UpdateUnitBorder(window.Canvas, unit);
		self:UpdateTargetIcon(window.Canvas, unit);
	end;
end;

function OrlanHeal:UpdateUnitBorder(canvas, unit)
	local buffIndex = 1;
	local hasCriticalDebuff = false;

	while true do
		local _, _, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, buffIndex, "HARMFUL");
		if spellId == nil then break; end;

		if self.CriticalDebuffs[spellId] then
			hasCriticalDebuff = true;
			break;
		end;

		buffIndex = buffIndex + 1;
	end;

	if hasCriticalDebuff then
		self:SetBorderColor(canvas, 1, 1, 1, 1);
	else
		local situation = UnitThreatSituation(unit)
		if situation == 1 then
			self:SetBorderColor(canvas, 1, 0.6, 0, 1);
		elseif (situation == 2) or (situation == 3) then
			self:SetBorderColor(canvas, 1, 0, 0, 1);
		else
			self:SetBorderColor(canvas, 0, 0, 0, 0);
		end;
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

function OrlanHeal:IsInRedRangeOrCloser(unit)
	return (IsSpellInRange(GetSpellInfo(53563), "player") ~= 1) or (IsSpellInRange(GetSpellInfo(53563), unit) == 1); -- Частица Света
end;

function OrlanHeal:IsInOrangeRangeOrCloser(unit)
	return (IsSpellInRange(GetSpellInfo(635), "player") ~= 1) or (IsSpellInRange(GetSpellInfo(635), unit) == 1); -- Holy Light
end;

function OrlanHeal:IsInYellowRangeOrCloser(unit)
	return (IsSpellInRange(GetSpellInfo(1022), "player") ~= 1) or (IsSpellInRange(GetSpellInfo(1022), unit) == 1); -- Hand of Protection
end;

function OrlanHeal:UpdateRange(rangeBar, unit)
	if UnitIsConnected(unit) ~= 1 then
		rangeBar:SetTexture(0, 0, 0, 1);
	elseif (UnitIsCorpse(unit) == 1) or (UnitIsDeadOrGhost(unit) == 1) then
		rangeBar:SetTexture(0.4, 0.4, 0.4, 1);
	elseif (not self:IsInRedRangeOrCloser(unit)) or (UnitCanAssist("player", unit) ~= 1) then
		rangeBar:SetTexture(0.2, 0.2, 0.75, 1);
	elseif not self:IsInOrangeRangeOrCloser(unit) then
		rangeBar:SetTexture(0.75, 0.2, 0.2, 1);
	elseif not self:IsInYellowRangeOrCloser(unit) then -- Длань Спасения
		rangeBar:SetTexture(0.75, 0.45, 0.2, 1);
	elseif CheckInteractDistance(unit, 2) ~= 1 then
		rangeBar:SetTexture(0.75, 0.75, 0.2, 1);
	else
		rangeBar:SetTexture(0.2, 0.75, 0.2, 1);
	end;
end;

function OrlanHeal:UpdateHealth(healthBar, unit)
	self:UpdateStatusBar(healthBar, UnitHealth(unit), UnitHealthMax(unit), UnitGetIncomingHeals(unit), UnitGetIncomingHeals(unit, "player"));

	if UnitIsConnected(unit) ~= 1 then
		self:SetStatusBarCurrentColor(healthBar, { r = 0, g = 0, b = 0 });
	else
		self:SetStatusBarCurrentColor(healthBar, { r = 0.2, g = 0.75, b = 0.2 });
	end;
end;

function OrlanHeal:UpdateMana(manaBar, unit)
	if (UnitPowerType(unit) == SPELL_POWER_MANA) and (UnitIsConnected(unit) == 1) then
		manaBar:Show();
		self:UpdateStatusBar(manaBar, UnitPower(unit, SPELL_POWER_MANA), UnitPowerMax(unit, SPELL_POWER_MANA));
	else
		manaBar:Hide();
	end;
end;

function OrlanHeal:UpdateName(nameBar, unit, displayedGroup)
	local text = GetUnitName(unit, false);
	
	if UnitIsAFK(unit) then
		text = "afk " .. text;
	end;
	if UnitIsDND(unit) then
		text = "dnd " .. text;
	end;

	if (displayedGroup ~= nil) and (string.sub(unit, 1, 4) == "raid") then
		local _, _, groupNumber = GetRaidRosterInfo(string.sub(unit, 5));
		if displayedGroup ~= groupNumber then
			text = "[" .. groupNumber .. "] " .. text;
		end;
	end;

	nameBar:SetText(text);
	local _, class = UnitClassBase(unit);
	local classColor = RAID_CLASS_COLORS[class];
	if classColor == nil then
		classColor = { r = 0.4, g = 0.4, b = 0.4 };
	end;
	nameBar:SetTextColor(classColor.r, classColor.g, classColor.b, 1);
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
		if (spellId == 53563) and (caster ~= nil) and (UnitIsUnit(caster, "player") == 1) or -- своя Частица Света
				(spellId == 1022) or -- Длань защиты
				(spellId == 5599) or -- Длань защиты
				(spellId == 10278) or -- Длань защиты
				(spellId == 1038) then -- Длань спасения
			buffKind = 1;
		elseif (self.SavingAbilities[spellId]) then
			buffKind = -1;
		elseif (self.ShieldAbilities[spellId]) then
			buffKind = -2;
		elseif (self.HealingBuffs[spellId]) then
			buffKind = -3;
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
		for buffIndex = 0, 4 do
			if canvas.SpecificBuffs[buffIndex] ~= nill then
				self:ShowBuff(canvas.SpecificBuffs[buffIndex], self:GetLastBuffOfKind(goodBuffs, goodBuffCount, buffIndex + 1));
			end;
		end;
	end;

	if canvas.OtherBuffs ~= nil then
		for buffIndex = 0, 4 do
			if canvas.OtherBuffs[buffIndex] ~= nill then
				self:ShowBuff(canvas.OtherBuffs[buffIndex], self:GetLastUsualBuff(goodBuffs, goodBuffCount));
			end;
		end;
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

function OrlanHeal:GetLastUsualBuff(buffs, buffCount)
	local buff = self:GetLastBuffOfKind(buffs, buffCount, -1);
	if not buff then
		buff = self:GetLastBuffOfKind(buffs, buffCount, -2);
	end;
	if not buff then
		buff = self:GetLastBuffOfKind(buffs, buffCount, -3);
	end;
	return buff;
end;

function OrlanHeal:ShowBuff(texture, buff)
	if buff == nil then
		texture.Image:SetTexture(0, 0, 0, 0);
		texture.Time:SetTexture(0, 0, 0, 0);
		texture.Count:SetText("");
	else
		texture.Image:SetTexture(buff.Icon);

		if buff.Expires <= GetTime() + 3 then
			texture.Time:SetTexture(1, 0, 0, 0.3);
		elseif buff.Expires <= GetTime() + 6 then
			texture.Time:SetTexture(1, 1, 0, 0.3);
		else
			texture.Time:SetTexture(0, 0, 0, 0);
		end;

		if (buff.Count > 1) then
			texture.Count:SetText(buff.Count);
		else
			texture.Count:SetText("");
		end;
	end;
end;

OrlanHeal:Initialize("OrlanHealConfig");
