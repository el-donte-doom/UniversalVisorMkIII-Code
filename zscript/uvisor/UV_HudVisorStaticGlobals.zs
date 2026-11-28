class UV_HudVisorStaticGlobals: StaticEventHandler {

	bool isSavegameJustLoaded;
	
    bool checkedLoadedMod;
	bool isBDv21v22_Loaded;
	bool isPB_Loaded;
	bool isBP_Loaded;
	bool isDD_Loaded;
	bool isLitDOOM_Loaded;
	bool isBeautifulDoomLoaded;
	bool isBD64_Loaded;
	bool isHellriderLoaded;
	bool isHellriderVengefulLoaded;
	bool isNightVisionPackLoaded;
	double bloodDefaultSaturationMultiplier;
	
	static const name BDv21v22_ActorClassNames[] = {
		'Purist',
		'BDoomer',
		'NukeLauncher',
		'BIG_FUCKING_GUN'
	};
	
	UV_PersistentData pData;
	
	static UV_HudVisorStaticGlobals Get() {
        let handler = StaticEventHandler.Find("UV_HudVisorStaticGlobals");
        return UV_HudVisorStaticGlobals(handler);
    }
	
	// Called when new game or a savegame loaded
    override void WorldLoaded(WorldEvent e) {
        if (e.IsSaveGame) {
			PlayerInfo playerinf = players[consoleplayer];
			if (!playerinf.mo)
				return;
			isSavegameJustLoaded = true;
			EventHandler.SendInterfaceEvent(consoleplayer, "UV_SavegameLoaded");
        }
		if (!pData) {
			pData = UV_PersistentData.Get();
		}
    }
	
	// Check here to do it only once, not every level start
	void CheckLoadedMods() {
		PlayerInfo playerinf = players[consoleplayer];
		if (!playerinf.mo) {
            return;
		}
		
		CheckMainMod(playerinf);

		name NightVisionPackActorName = 'NVNightVision';
		Class<Actor> NightVisionPackActorClass = NightVisionPackActorName;
		if (NightVisionPackActorClass) {
			isNightVisionPackLoaded = true;
		}
// 		console.printf("isBDv21v22_Loaded: " .. isBDv21v22_Loaded);
// 		console.printf("isLitDOOM_Loaded: " .. isLitDOOM_Loaded);
// 		console.printf("isPB_Loaded: " .. isPB_Loaded);
// 		console.printf("isBP_Loaded: " .. isBP_Loaded);
// 		console.printf("isDD_Loaded: " .. isDD_Loaded);
// 		console.printf("isLitDOOM_Loaded: " .. isLitDOOM_Loaded);
// 		console.printf("isBD64_Loaded: " .. isBD64_Loaded);
// 		console.printf("isBeautifulDoomLoaded: " .. isBeautifulDoomLoaded);
// 		console.printf("isHellriderLoaded: " .. isHellriderLoaded);
// 		console.printf("isHellriderVengefulLoaded: " .. isHellriderVengefulLoaded);
	}
	
	void SetDefaultBloodSaturationMultiplier() {
		// PB blood decals seem to be darker than in most mods (but actually more in line with the defaultbloodcolor)
		bloodDefaultSaturationMultiplier = isPB_Loaded ? 1.35 : 1.55;
	}
	
	private void CheckMainMod(PlayerInfo playerinf) {
		name playerClassName = playerinf.mo.GetClassName();
		SetIsBDv21v22_Loaded();
		if (isBDv21v22_Loaded) {
			return;
		} else {
			name BP_ActorName = 'BP_Pistol';
			Class<Actor> BP_ActorClass = BP_ActorName;
			
			name BD64_ActorName = '64ZombieMan';
			Class<Actor> BD64_ActorClass = BD64_ActorName;
			
			name litDoomActorName = 'LiTRifle';
			Class<Actor> lidDoomActorClass = litDoomActorName;
			
			name PB_ActorName = 'PB_Shotgun';
			Class<Actor> PB_ActorClass = PB_ActorName;
			
			name BeautD_ActorName = 'BDoomWeapon';
			Class<Actor> BeautD_ActorClass = BeautD_ActorName;
			
			name HellriderActorName = 'HR_InvulnerabilitySphere';
			Class<Actor> HellriderActorClass = HellriderActorName;
			
			name HellriderVengefulActorName = 'HR_Maskofliterally';
			Class<Actor> HellriderVengefulActorClass = HellriderVengefulActorName;
			
			if (playerClassName == 'PB_PlayerPrawn' || playerClassName == 'PBXCore_Player' || PB_ActorClass) {
				isPB_Loaded = true;
			} else if (BP_ActorClass) {
				isBP_Loaded = true;
			} else if (playerClassName == 'Kiwi') {
				isDD_Loaded = true;
			} else if (lidDoomActorClass) {
				isLitDOOM_Loaded = true;
			} else if (BD64_ActorClass) {
				isBD64_Loaded = true;
			} else if (BeautD_ActorClass) {
				isBeautifulDoomLoaded = true;
			} else if (HellriderActorClass) {
				isHellriderLoaded = true;
			} else if (HellriderVengefulActorClass) {
				isHellriderVengefulLoaded = true;
			}
		}
	}
	
	private void SetIsBDv21v22_Loaded() {
		for (int i = 0; i < BDv21v22_ActorClassNames.Size(); i++) {
			Class<Actor> actorClass = BDv21v22_ActorClassNames[i];
			if (!actorClass) {
				isBDv21v22_Loaded = false;
				return;
			}
		}
		isBDv21v22_Loaded = true;
	}
}