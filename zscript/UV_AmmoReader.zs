class UV_AmmoReader : Object {

	private PlayerInfo playerinf;
	private UV_AmmoData amData;

	virtual UV_AmmoData GetAmmoData(PlayerInfo currentPlayerinf, UV_HudVisorStaticGlobals globals) {
		playerinf = currentPlayerinf;
		Weapon currentWeapon = playerinf.ReadyWeapon;
		amData = new("UV_AmmoData");
		if (!currentWeapon)
			return amData;
		amData.weaponClassName = currentWeapon.GetClassName();
// 		console.printf("weaponClassName: " .. amData.weaponClassName);
		Ammo am1 = Ammo(playerinf.mo.FindInventory(currentWeapon.ammotype1));
		if (am1) {
			amData.ammo1_ClassName = am1.GetClassName();
// 			console.printf(" ammo1_ClassName: " .. amData.ammo1_ClassName);
			amData.am1amt = playerinf.mo.CountInv(currentWeapon.ammotype1);
// 			console.printf(" am1amt: " .. amData.am1amt);
			amData.am1max = am1.maxamount;
// 			console.printf(" am1max: " .. amData.am1max);
		}
		Ammo am2 = Ammo(playerinf.mo.FindInventory(currentWeapon.ammotype2));
		if (am2) {
			amData.ammo2_ClassName = am2.GetClassName();
// 			console.printf(" ammo2_ClassName: " .. amData.ammo2_ClassName);
			amData.am2amt = playerinf.mo.CountInv(currentWeapon.ammotype2);
// 			console.printf(" am2amt: " .. amData.am2amt);
			amData.am2max = am2.maxamount;
// 			console.printf(" am2max: " .. amData.am2max);
		}
		if (amData.weaponClassName) {
			if (am1 || am2) {
				if (IsBeautifulDoomModernWeapons(globals)) {
					SetBeautifulDoomData();
				}
			} else if (globals.isLitDOOM_Loaded) {
				SetLitDoomData();
			}
		}
		return amData;
	}
	
	void SetLitDoomData() {
		if (amData.weaponClassName == "LitRifle") {
			SetAm1DataCustom("minigunammo");
			SetAm2DataCustom("rifleammo");
		} else if (amData.weaponClassName == "shot_gun") {
			SetAm1DataCustom("ammoslug");
			SetAm2DataCustom("shotgunammo");
		} else if (amData.weaponClassName == "GRENADELAUNCHER") {
			string ammo1Name = "flareloaded";
			if (playerinf.mo.FindInventory(ammo1Name)) {
				SetAm1DataCustom("flare");
			}
			ammo1Name = "acidloaded";
			if (playerinf.mo.FindInventory(ammo1Name)) {
				SetAm1DataCustom("acidmistammo");
			}
			ammo1Name = "hellfireloaded";
			if (playerinf.mo.FindInventory(ammo1Name)) {
				SetAm1DataCustom("hellfireammo");
			}
			ammo1Name = "syringeloaded";
			if (playerinf.mo.FindInventory(ammo1Name)) {
				SetAm1DataCustom("pheromones");
			}
			ammo1Name = "metalloaded";
			if (playerinf.mo.FindInventory(ammo1Name)) {
				SetAm1DataCustom("scrapmetal");
			}
			ammo1Name = "grenadeloaded";
			if (playerinf.mo.FindInventory(ammo1Name)) {
				SetAm1DataCustom("grenadeammo");
			}
			ammo1Name = "clusterloaded";
			if (playerinf.mo.FindInventory(ammo1Name)) {
				SetAm1DataCustom("clusterammo");
			}
			ammo1Name = "mineloaded";
			if (playerinf.mo.FindInventory(ammo1Name)) {
				SetAm1DataCustom("PROXBOMBAMMO");
			}
			SetAm2DataCustom("glammo");
		}
	}
	
	bool IsBeautifulDoomModernWeapons(UV_HudVisorStaticGlobals globals) {
		if (globals.isBeautifulDoomLoaded) {
			bool bdoom_replaceweapons_cvar = Cvar.GetCvar("bdoom_replaceweapons", playerinf).GetBool();
			int bdoom_weapons_cvar = Cvar.GetCvar("bdoom_weapons", playerinf).GetInt();
			return bdoom_replaceweapons_cvar && bdoom_weapons_cvar == 2;
		}
		return false;
	}
	
	void SetBeautifulDoomData() {
		if (amData.weaponClassName == "BD_Pistol") {
			SetAm2DataCustom("BD_PistolClip");
		} else  if (amData.weaponClassName == "BD_Shotgun") {
			SetAm2DataCustom("BD_ShotgunClip");
		} else if (amData.weaponClassName == "BD_SuperShotgun") {
			SetAm2DataCustom("BD_SSGClip");
		} else if (amData.weaponClassName == "BD_Chaingun") {
			SetAm2DataCustom("RifleClip"); // not a typo
		} else if (amData.weaponClassName == "BD_RocketLauncher") {
			SetAm2DataCustom("BD_RLClip");
		}
	}
	
	void SetAm1DataCustom(string ammoClassName) {
		Ammo am1 = Ammo(playerinf.mo.FindInventory(ammoClassName));
		if (am1) {
			amData.ammo1_ClassName = am1.GetClassName();
// 			console.printf(" ammo1_ClassName: " .. amData.ammo1_ClassName);
			amData.am1amt = playerinf.mo.CountInv(ammoClassName);
// 			console.printf(" am1amt: " .. amData.am1amt);
			amData.am1max = am1.maxamount;
// 			console.printf(" am1max: " .. amData.am1max);
		}
	}
	
	void SetAm2DataCustom(string ammoClassName) {
		Ammo am2 = Ammo(playerinf.mo.FindInventory(ammoClassName));
		if (am2) {
			amData.ammo2_ClassName = am2.GetClassName();
// 			console.printf(" ammo2_ClassName: " .. amData.ammo2_ClassName);
			amData.am2amt = playerinf.mo.CountInv(ammoClassName);
// 			console.printf(" am2amt: " .. amData.am2amt);
			amData.am2max = am2.maxamount;
// 			console.printf(" am2max: " .. amData.am2max);
		}
	}
}
