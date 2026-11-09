class UV_HudVisorStaticGlobals: StaticEventHandler {

	bool isSavegameJustLoaded;
	
    bool checkedLoadedMod;
	bool isBD_Loaded;
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
		
		string BD_ActorName = "BIG_FUCKING_GUN";
		Class<Actor> BD_ActorClass = BD_ActorName;
		
		string BP_ActorName = "BP_Pistol";
		Class<Actor> BP_ActorClass = BP_ActorName;
		
		string BD64_ActorName = "64ZombieMan";
		Class<Actor> BD64_ActorClass = BD64_ActorName;
		
		string litDoomActorName = "LiTRifle";
		Class<Actor> lidDoomActorClass = litDoomActorName;
		
		string PB_ActorName = "PB_Shotgun";
		Class<Actor> PB_ActorClass = PB_ActorName;
		
		string BeautD_ActorName = "BDoomWeapon";
		Class<Actor> BeautD_ActorClass = BeautD_ActorName;
		
		string HellriderActorName = "HR_InvulnerabilitySphere";
		Class<Actor> HellriderActorClass = HellriderActorName;
		
		string HellriderVengefulActorName = "HR_Maskofliterally";
		Class<Actor> HellriderVengefulActorClass = HellriderVengefulActorName;
		
		string NightVisionPackActorName = "NVNightVision";
		Class<Actor> NightVisionPackActorClass = NightVisionPackActorName;
		
		bloodDefaultSaturationMultiplier = 1.55; 
		if (BD_ActorClass) {
			isBD_Loaded = true;
		} else if (playerClassName == "PB_PlayerPrawn" || playerClassName == "PBXCore_Player" || PB_ActorClass) {
			isPB_Loaded = true;
			// PB blood decals seem to be darker than in most mods (but actually more in line with the defaultbloodcolor)
			bloodDefaultSaturationMultiplier = 1.35; 
		} else if (BP_ActorClass) {
			isBP_Loaded = true;
		} else if (playerClassName == "Kiwi") {
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
		if (NightVisionPackActorClass) {
			isNightVisionPackLoaded = true;
		}
	}
}