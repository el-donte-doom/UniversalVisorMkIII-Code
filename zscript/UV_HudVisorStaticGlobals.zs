class UV_HudVisorStaticGlobals: StaticEventHandler {

	bool isSavegameJustLoaded;
	
    bool checkedLoadedMod;
	bool isBD_Loaded;
	bool isPB_Loaded;
	bool isBP_Loaded;
	bool isDD_Loaded;
	bool isLitDOOM_Loaded;
	bool isBD64_Loaded;
	bool isHellrider_Loaded;
	bool isHellriderVengeful_Loaded;
	bool isNightVisionPack_Loaded;
	double bloodDefaultSaturationMultiplier;
	
	static UV_HudVisorStaticGlobals Get() {
        let handler = StaticEventHandler.Find("UV_HudVisorStaticGlobals");
        return UV_HudVisorStaticGlobals(handler);
    }
	
	// Called when a savegame is loaded
    override void WorldLoaded(WorldEvent e)
    {
        if (e.IsSaveGame)
        {
			PlayerInfo playerinf = players[consoleplayer];
			if (!playerinf.mo)
				return;
			isSavegameJustLoaded = true;
			EventHandler.SendInterfaceEvent(consoleplayer, "UV_SavegameLoaded");
        }
    }
	
	// Check here to do it only once, not every level start
	void CheckLoadedMod() {
		PlayerInfo playerinf = players[consoleplayer];
		if (!playerinf.mo) {
            return;
		}
		string playerClassName = playerinf.mo.getclassname();
		
		string BP_ActorName = "BP_Pistol";
		Class<Actor> BP_Class = BP_ActorName;
		
		string BD64_ActorName = "64ZombieMan";
		Class<Actor> BD64_ActorClass = BD64_ActorName;
		
		string litDoomActorName = "LiTRifle";
		Class<Actor> lidDoomActorClass = litDoomActorName;
		
		string PB_ActorName = "PB_Shotgun";
		Class<Actor> PB_ActorClass = PB_ActorName;
		
		bloodDefaultSaturationMultiplier = 1.55; 
		if (FindClass("BIG_FUCKING_GUN")) {
			isBD_Loaded = true;
		} else if (playerClassName == "PB_PlayerPrawn" || playerClassName == "PBXCore_Player" || PB_ActorClass) {
			isPB_Loaded = true;
			// PB blood decals seem to be darker than in most mods (but actually more in line with the defaultbloodcolor)
			bloodDefaultSaturationMultiplier = 1.35; 
		} else if (BP_Class) {
			isBP_Loaded = true;
		} else if (playerClassName == "Kiwi") {
			isDD_Loaded = true;
		} else if (lidDoomActorClass) {
			isLitDOOM_Loaded = true;
		} else if (BD64_ActorClass) {
			isBD64_Loaded = true;
		} else if (FindClass("HR_InvulnerabilitySphere")) {
			isHellrider_Loaded = true;
		} else if (FindClass("HR_Maskofliterally")) {
			isHellriderVengeful_Loaded = true;
		}
		if (FindClass("NVNightVision")) {
			isNightVisionPack_Loaded = true;
		}
		console.printf("gameinfo.defaultbloodcolor: " .. gameinfo.defaultbloodcolor);
		console.printf("isPB_Loaded: " .. isPB_Loaded);
		console.printf("bloodDefaultSaturationMultiplier: " .. bloodDefaultSaturationMultiplier);
	}
}