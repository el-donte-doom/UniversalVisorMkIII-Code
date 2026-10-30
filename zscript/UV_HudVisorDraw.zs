// Credits

// El Donte - total rewrite with much more functionality (Universal Visor Mk III)
// generic name guy, Agent_Ash, CHEEKIBREEKI - original mod (Universal Visor Mk II)

class UV_HudVisorDraw : EventHandler
{	
	///// COMMON VARS /////
	
	PlayerInfo playerinf;
	
	const BASE_SCREEN_WIDTH = 1920;
	const BASE_SCREEN_HEIGHT = 1080;
	
	double scaledMaxSwayX; // Scaled to resolution
	double scaledMaxSwayY; // Same
	
	int previousArmor;
	int totalArmor;
	int previousHealth;
	int bloodMaxCount;

	bool startupAnimEnabled;
	const STARTUP_BLACK_TICKS = 60;
	const STARTUP_BLACK_SOLID_TICKS = 35;
	
	bool hideHelmetInThirdPerson;
	bool isThirdPerson;
	
	bool invisEffectOn;
	bool radSuitOn;
	bool nightVisionOn;
	bool PB_NightVisionOn;
	bool NV_PackInverseMapOn;
	bool invulnerabilityOn;
	bool isVanillaInvulernabilityOn;
	bool isVanillaInvulernabilityBlinking;
	String lastColormappedPowerup;
	bool isLastColormappedPowerupBlinking;
	bool isLastPowerupColomapped;
	Color combPlayerBlendAndPowerupBlendColor;
	double effectiveBlendAlpha;
	
	
	///// UI CONTEXT VARS /////
	
	static const string topStyles[] = 
	{
		"None",					// 0
		"Classic",				// 1
		"MkII",	 		   	  	// 2
		"Dark_Ages",		 	// 3
		"Republic_Commando",	// 4
		"Space_Marine",			// 5
		"Simple",				// 6
		"Simple_No_Top_Middle",	// 7
		"Metroid",				// 8
		"Plain_Glass"	     	// 9
    };
	
	static const string bottomStyles[] =
    {
		"None",						// 0
		"Classic", 			   		// 1
		"MkII",	 			   		// 2
		"Dark_Ages",			   	// 3
		"Space_Marine",				// 4
		"Simple",					// 5
		"Classic_Top_As_Bottom",	// 6
		"Plain_Glass"	   	   		// 7
    };
	
	static const string cornerStyles[] =
    {
		"None",					// 0
		"Classic", 		   		// 1
		"MkII",	 		   		// 2
		"Dark_Ages",		   	// 3
		"Republic_Commando",	// 4
		"Space_Marine",			// 5
		"Simple",				// 6
		"Metroid"				// 7
    };
	
	static const string sideGlassStyles[] = 
	{
		"None",				// 0
		"Plain_Glass"		// 1
	};
	
	static const string tacticalOverlayStyles[] =
    {	
		"None",					// 0
		"Classic", 	  	  		// 1
		"Classic_2", 	  	  	// 2
		"Classic_3", 	  	  	// 3
		"2016",	 	  	  		// 4
		"Master_Chief", 	  	// 5
		"Noble_Six",			// 6
		"Emile",				// 7
		"Mister_Chief",  	 	// 8
		"Republic_Commando",	// 9
		"Sidelines",			// 10	
		"Lost_in_Darkness",		// 11
		"Diamond_Dragon",		// 12
		"Diamond_Dragon_right",	// 13
		"Diamond_Dragon_2",		// 14
		"Metroid",				// 15
		"Dirt",					// 16
		"Dirt_clean",			// 17
		"Corners"				// 18
    };
	
	enum ScreenAnchors
	{
		TOP_LEFT,
		TOP_MIDDLE,
		TOP_RIGHT,
		MIDDLE_LEFT,
		MIDDLE_MIDDLE,
		MIDDLE_RIGHT,
		BOTTOM_LEFT,
		BOTTOM_MIDDLE,
		BOTTOM_RIGHT
	};
	
	enum UV_TextureTypes
	{
		PART_TOP,
		PART_BOTTOM,
		PART_CORNER,
		GLOW,
		GLASS,
		ARMOR_GRID
	};
	
	ui bool initialUIInitDone;
	ui double FracTicGlobal;
	ui int prevGametic;
	ui int screenSize;
	ui bool needsTextureWarmUp;
	ui Color colorHealth;
	ui Color colorArmor;
	ui Color colorAmmo1;
	ui Color colorAmmo2;

	ui double scaleFactorWidth;
	ui double scaleFactorHeight;

	ui bool showPieces;
	ui bool showGlow;
	ui bool baseShowGlow;
	ui bool showGlass;
	ui bool baseShowGlass;
	ui bool showTacticalOverlay;
	ui bool baseShowTacticalOverlay;
	ui bool showTacticalMarks;
	ui bool baseShowTacticalMarks;
	ui bool showArmorGrid;
	ui bool showGlassCracks;
	ui bool showBloodSplashes;
	ui int prevTexRes;
	ui string texResPath;
	
	ui int styleTop;
	ui int styleBottom;
	ui int styleCorners;
	ui int styleSideGlass;
	ui int styleTacticalOverlay_1;
	ui int styleTacticalOverlay_2;

	ui bool translucentGlowStyle;
	ui Color colorPartTop;
	ui bool syncPartColors;
	ui Color colorPartBottom;
	ui Color colorPartCorners;
	ui Color colorGlow;
	ui Color baseColorGlow;
	ui bool syncGlowGlassColors;
	ui Color colorGlass;
	ui bool syncGlassTacticalOverlayColors;
	ui Color colorTacticalOverlay_1;
	ui Color colorTacticalOverlay_2;
	ui Color colorGlassCracks;
	ui Color colorArmorGrid;
	ui Color baseColorArmorGrid;
	ui int renderStyleArmorGrid;
	
	ui float alphaParts;
	ui float baseAlphaParts;
	ui float baseAlphaGlow;
	ui float alphaGlow;
	ui float alphaGlass;
	ui float baseAlphaGlass;
	ui float alphaTactical_1;
	ui float baseAlphaTactical_1;
	ui float alphaTactical_2;
	ui float baseAlphaTactical_2;
	ui float alphaArmorGrid;
	ui float baseAlphaArmorGrid;
	ui float alphaCracks;
	ui float baseAlphaCracks;
	ui float alphaBlood;
	ui bool overrideAlphaBottom;
	ui float alphaPartBottom;
	ui float baseAlphaPartBottom;
	ui float alphaGlowBottom;
	ui float baseAlphaGlowBottom;
	ui float alphaGlassBottom;
	ui float baseAlphaGlassBottom;
	
	ui bool showPartTop;
	ui bool showGlowTop;
	ui bool showGlassTop;
	ui bool showPartBottom;
	ui bool showGlowBottom;
	ui bool showGlassBottom;
	ui bool showPartCorners;
	ui bool showGlowCorners;
	ui bool showGlassCorners;
	ui int autoHideCornersMode;
	ui int autoHideCornersScreenSize;
	ui bool showGlassSides;
	
	ui int offsetTop;
	ui int offsetBottom;
	ui int offsetCornersX;
	ui int offsetCornersY;
	ui int offsetSidesGlass;
	ui int offsetTacticalMarks;
	ui float widthScaleBottom;
	ui float widthScaleCorners;
	
	ui int gameplayColorBasisGlow;
	ui int gameplayColorBasisGlass;
	ui int gameplayColorBasisArmorGrid;
	ui Color gameplayColorStep1;
	ui Color gameplayColorStep2;
	ui Color gameplayColorStep3;
	ui Color gameplayColorStep4;
	ui bool hideGlowIfEmptyArmor;
	ui bool hideGlassIfEmptyArmor;
	
	ui int armorGridDisplayMode;
	ui int alphaBasisArmorGrid;
	ui int powersOverrideGridColorMode;
	const RADSUIT_GRID_COLOR = Color(255, 125, 255, 0);  // lime
	const INVULN_GRID_COLOR = Color(255, 0, 255, 0); 	 // green
	const GODMODE_GRID_COLOR = Color(255, 255, 143, 59); // gold
	const FULL_WHITE_COLOR = Color(255, 255, 255, 255);
	
	ui string cracksBasePath;
	ui string CommonGraphicsPath;
	
	ui TextureID texPartTop;
	ui TextureID texPartBottom;
	ui TextureID texPartCornerLeft;
	ui TextureID texPartCornerRight;
	ui TextureID texPartTacticalMarkLeft;
	ui TextureID texPartTacticalMarkRight;
	ui TextureID texGlowTacticalMarkLeft;
	ui TextureID texGlowTacticalMarkRight;
	ui TextureID texGlowTop;
	ui TextureID texGlowBottom;
	ui TextureID texGlowCornerLeft;
	ui TextureID texGlowCornerRight;
	ui TextureID texGlassTop;
	ui TextureID texGlassBottom;
	ui TextureID texGlassCornerLeft;
	ui TextureID texGlassCornerRight;
	ui TextureID texGlassSideLeft;
	ui TextureID texGlassSideRight;
	ui TextureID texTacticalOverlay_1;
	ui TextureID texTacticalOverlay_2;
	ui TextureID texArmorGrid;
	ui TextureID texArmorGridIdleAnim;
	ui TextureID texArmorGridDamage;
	ui TextureID texArmorGridDamageHeavy;
	ui TextureID texScreenWiper;
	
	ui double prevPulseAlpha;
	ui double prevPulseAlphaBottom;
	ui double targetPulseAlpha;
	ui double targetPulseAlphaBottom;
	
	ui double uiSwayOffX; // Gets interpolated from SwayOffX
	ui double uiSwayOffY; // Gets interpolated from SwayOffY
	ui double uiSwayOffX_ArmorGrid;
	ui double uiSwayOffY_ArmorGrid;
	
	ui int warningSoundBasisUIContext;
	ui bool isGL_EnhancedNV;
	
	
	///// PLAY CONTEXT VARS /////
	
	bool initialPlayInitDone;
	bool wasMenuOpened;
	double scaleFactorWidthPlay;
	double scaleFactorHeightPlay;
	bool showGlassPlayContext;
	bool baseShowGlassPlayContext;
	bool hideGlassIfEmptyArmorPlayContext;
	bool transparencyEffectWhenInvis;
	bool isDemonPlayer;
	String PB_NightVisionStr;
	String NVNightVisionInverseMapStr;
	Array<Color> powerupBlendColors;
	static const string isDemonPlayerFlags[] = {
		"isDemonPlayer", // using only this one isn't reliable cause it's not set if two nearby demon powerups picked up very quickly
		"powerTransformBaron",
		"powerTransformRevenant"
	};
	bool wasInVehicle;
	bool inVehicle;
	bool wasInMachineGun;
	bool inMachineGun;
	string heavyMachinegunStr;
	int machineGunEnterLeaveTicker;
	bool alreadyStoredDataInVehicle;
	int storedHealthInsideVehicle; // stored manually, not an inventory item from BD, etc.
	int storedArmorInsideVehicle; // same

	static const string vehicleInvNames[] = {
			// BD and UMES
		"PowerTankSwitch",
		"PowerArtilleryTankSwitch",
		"PowerBikeSwitch",
		"PowerattackhelicopterSwitch",
			// BD, UMES, Omni Vehicles
		"PowerMechSwitch",
			// Omni Vehicles
		"PowerFlameTankSwitch",
		"PowerDemoMechSwitch"
	};
	
	static const string damageTypesNoBlood[] = { // for enemy actor based blood detection
			// Common
		"Fire",
			// BP, PB
		"Ice",
		"BurnDOT",
		"FlameBelch",
		"FlameBelchChain",
			// PB, BD Cat's Frozen Addon
		"freeze",
		"GloryFire",
			// Abyssal Marine
		"PlayerFire",
			// Clusterfuck
		"PlayerIce",
		"PlayerPyro"
	};
	
	static const string bloodBaseTypes[] = {  // for blood actor based blood color detection
		"Blood",
		"Brutal_Blood", 		// Brutal Doom and forks
		"BD_BloodBase", 		// Beautiful Doom
		"PM_NormalBloodBase",	// Project Malice
		"Bolognese_Blood",
		"BloodSquirt",			// Droplets
		"AM_Blood_Spawner", 	// Abyssal Marine
		"NewBlood",				// Complex Doom, ClusterFuck
		"D4TBlood",				// Death Foretold
		"RLNashGore_Blood",		// DoomRL Arsenal Monster Pack
		"RLSpectreBlood",		// DoomRL Arsenal Monster Pack
		"MDBlood",				// Mass Disassembly
		"NashGoreBloodBase" 	// already extends Blood, but just in case
	};
	
	static const string bdBloodSubtypes[] = {
		"Green_BLood", // not a typo
		"Blue_Blood",
		"Alien Blood"
	};
	
	static const string bdBloodSubtypesColors[] = {
		"00FF00",
		"0000FF",
		"9370DB"
	};
	
	static const string pmBloodSubtypes[] = {
		"PM_GreenBloodBase",
		"PM_DarkGreenBloodBase",
		"PM_DarkGreenCyberBloodBase",
		"PM_BlueBloodBase",
		"PM_PurpleBloodBase",
		"PM_BlackBloodBase",
		"PM_PestilenceBloodBase",
		"PM_LavaBloodBase",
		"PM_DeathBloodBase",
		"PM_SlothBloodBase"
	};
	
	static const string pmBloodSubtypesColors[] = {
		"006400",
		"006400",
		"006400",
		"0000FF",
		"A020F0",
		"000000",
		"006400",
		"FF7F50",
		"000000",
		"00008B"
	};
	
	static const string shakingDamageTypes[] = {
			// Common
		"ExplosiveImpact",
		"GreenFire",
		"Eat",
		"RVFT",
		"Stomp",
		"Extreme",
			// BD
		"Railgun",
			// BP
		"BFGSplash",
		"Plasma",
		"Desintegrate",
		"SFestExplode",
		"blast",
		"EatSFest",
			// PB
		"BHFT",
			// DD
		"Barrel",
		"Chomp",
		"SSG",
		"Dual SSG",
			// PM
		"Explosive",
		"Nobles",
			// LiT
		"Explosives",
		"HKFT",
		"BHFT"
			// EOA
		"Quake"
			// DoomRL
		"Explosion"
	};
	
	// Armor grid
	const ARMOR_GRID_DAMAGE_ANIM_TICKS = 12;
	const ARMOR_GRID_HEAVY_DAMAGE_ANIM_TICKS = 12;
	int armorGridDamageAnimTicker;
	int armorGridHeavyDamageTicker;
	int armorGridDamageHoldTicks;
	double prevUsualArmorGridAlpha;
	double usualArmorGridAlpha;
	double prevDamageArmorGridAlpha;
	double damageArmorGridAlpha;
	bool armorGridDisableWhenOtherOverlay;
	
	const GRID_IDLE_CYCLE_TICKS = 175;
    const GRID_IDLE_FADE_TICKS = 35;
	int gridIdleTimer;
	double prevGridIdleAlphaImage_1;
	double gridIdleAlphaImage_1;
	double prevGridIdleAlphaImage_2;
	double gridIdleAlphaImage_2;
	
	bool showArmorGridPlay;
	bool isArmorGridShownVar;
	bool gridIdleAnimEnabled;
	int armorGridDisplayModePlay;
	bool wasArmorGridShown;
	const ARMOR_GRID_EQUIP_TICKS = 18;
	const ARMOR_GRID_EQUIP_SIZE_MULT = 2.5;
	double armorGridEquipTicker;
	vector2 prevArmorGridSize;
	vector2 prevArmorGridCoords;
	vector2 armorGridSize;
	vector2 armorGridCoords;
	double alphaArmorGridMult;
	
	// Glow pulse
	bool pulseActive;
	int pulseMode;
	double pulseSpeed;
	double pulseTime;
	
	// Sway menu options
	bool helmetSwaying;
	double MaxSwayX; // Also used for shaking max X offset
	double MaxSwayY; // Also used for shaking max Y offset
	float swaySensitivity;
	float cameraSwayMultX;
	float cameraSwayMultY;
	bool MovementSway;
	double MovementSwayMultX;
	double MovementSwayMultY;
	double MovementSwayMultBob;
	int SwayBobMode;
	double SwayBobFreq;
	bool CrouchSway;
	double CrouchSwayIntensity;
	bool JumpSway;
	double JumpSwayIntensity;
	
	// Helper sway vars
	double SwayOffX;
	double SwayOffY;
	double OldSwayOffX;
	double OldSwayOffY;
	UV_DynamicDoubleInterpolator DynSwayX;
	UV_DynamicDoubleInterpolator DynSwayY;
	UV_DynamicDoubleInterpolator DynCrouchAnim;
	Vector2 relVel;
	double PrevPitch;
	double PrevAngle;
	double PrevVelZ;
	double PrevCrouchFactor;
	bool WasGrounded;
	bool wasDoubleJumpDetected;
	double mLandingOffset;
	double mJumpOffset;   
	double mFallingOffset; 
	
	double slowBobTimer;
	double lastBobTime;

	UV_HudVisorStaticGlobals globals;
	
	// Helmet shaking vars
	bool helmetShaking;
	double ShakeSensitivity;
	double ShakeOffsetX;
	double ShakeOffsetY;
	double ShakeIntensity;
	
	// Visor cracks
	int cracksBasis;
	int prevCracksBasis;
	int cracksLevel; // 1-5
	int prevCracksLevel;
	int cracksTexturePatternId;
	const CRACKS_MAX_PATTERN_ID = 6;
	double cracksTextureRotationDegree;
	bool initalCracksUpdateDone; // to prevent crack's sound at level start when small health/armor
	const CRACKS_FADE_TICKS = 5;
	int cracksFadeTicker;
	double prevF_InCracksAlpha;
	double f_InCracksAlpha;
	double prevF_OutCracksAlpha;
	double f_OutCracksAlpha;
	int fInCracksTexId;
	int fOutCracksTexId;
	bool hideFadingOutCracks;
		
	// Blood
	const BLOOD_FADE_IN_TICS = 5;
	const BLOOD_MAX_SPLASHES = 50;
	const BLOOD_MAX_TEXTURE_ID = 30;
	int TexResPlayContext;
	string CommonGraphicsPathPlayContext;
	bool showBloodSplashesPlayContext;
	int bloodFreq;
	int bloodMaxInitDistance;
	float bloodLifetime;
	bool bloodVanishes;
	double bloodSize;
	bool bloodRandomColors;
	int newBloodSplashNumber;
	UV_BloodSplash currentBloodSplashes[BLOOD_MAX_SPLASHES];
	const UNSET_COLOR = Color(0, 0, 0, 0);
	int bloodDefaultSaturationShiftCvar;
	int bloodDetectionMode;
	LookExParams paramsForIsVisible;
	string BD_BLOOD;
	string PM_BLOOD; // Project Malice
	string MD_BLOOD; // Mass Disassembly
	
	// Screen wiper
	const SCREEN_WIPER_TICKS = 40;
	int screenWiperAnimTicker;
	double clipRatio;
	double clipRatioInverted;
	double prevClipRatioInverted;
	int screenWiperMode;
	int timedAutoWiperTics;
	bool timedAutoWiperWasActive;
	
	// Sounds
	int warningSoundBasis;
	double warningVolume;
	int prevWarningSoundChannel;
	int warningSoundChannel;
	bool warningAmmo1Active;
	bool warningAmmo2Active;
	bool showGlassCracksPlayContext;
	double cracksVolume;
	double hitVolume;
	double armorDepletedVolume;
	bool breathDisableIfNoGlass;
	double prevBreathVolume;
	double breathVolume;
	int breathVoice;
	int prevBreathSoundChannel;
	int breathSoundChannel;
	double startupVolume;
	double screenWiperVolume;
	
	// Startup anim
	const STARTUP_TICKS = 120;
	int startupTicker;
	
	
	// Ammo
	UV_AmmoData ammoData;
	int mappedCurrentAmmo1;
	int mappedCurrentAmmo2;
	const LOW_AMMO_NOTIFY_PAUSE_TICS = 70;
	int lowAmmo1Ticker;
	bool lowAmmo1Active;
	int lowAmmo2Ticker;
	bool lowAmmo2Active;
	UV_AmmoReaderFactory Factory;
		
	
	
	//////////////////// UI CONTEXT - handles helmet HUD drawing, FracTic interpolation and few calculations for responsive menu ////////////////////
	
    override void RenderUnderlay(renderEvent e)
    {		
        if (!playerinf.mo) {
            return;
		}
			
		if (Cvar.GetCvar("uvisor_mod_enabled", playerinf).GetBool() == 0) {
			return;
		}
				
		if (gamestate != GS_LEVEL) {
            return; // Prevent drawing helmet in main menu with mods overriding Titlemap
		}
	
		if ((hideHelmetInThirdPerson && isThirdPerson) || isDemonPlayer) {
			return;
		}
		
		if (Menu.GetCurrentMenu() != null || consolestate) {
			EventHandler.SendNetworkEvent("Menu_Opened"); // Notify play context that menu was opened to update some play vars
			// Update these vars only on startup, savegame load or in options menu or console, no need in the actual gameplay
			InitUiVars();
		} else if (!initialUIInitDone) {
			InitUiVars();
			needsTextureWarmUp = true; 
			// needsTextureWarmUp: draw fullscreen textures with alpha 0 to avoid stutter when they're firstly drawn midgame
			// Usually when player firstly gets armor and glass, cracks, grid, tactical lines appear
		}
		
		if (prevGametic != gametic || Menu.GetCurrentMenu() != null || consolestate || !initialUIInitDone) {
			// Calculations which better be in UI context to instantly update hud when changing options in the menu
			// (e.g. gameplay color steps)
			// But for performance do them only each gametic (not FracTic) like in WorldTick
			
			colorHealth = GetIndicatorColor(playerinf.health);
			colorArmor = GetIndicatorColor(totalArmor);
			
			if (ammoData) {
				SetAmmoColors();
			}
			
			colorGlow = baseColorGlow;
									
			if (gameplayColorBasisGlow == 1) {
				colorGlow = colorHealth;
			} else if (gameplayColorBasisGlow == 2) {
				colorGlow = colorArmor;
			} else if (gameplayColorBasisGlow == 3) {
				colorGlow = colorAmmo1;
			} else if (gameplayColorBasisGlow == 4) {
				colorGlow = colorAmmo2;
			}
			if (gameplayColorBasisGlass == 1) {
				colorGlass = colorHealth;
			} else if (gameplayColorBasisGlass == 2) {
				colorGlass = colorArmor;
			} else if (gameplayColorBasisGlass == 3) {
				colorGlass = colorAmmo1;
			} else if (gameplayColorBasisGlass == 4) {
				colorGlass = colorAmmo2;
			} 

			if (syncGlassTacticalOverlayColors) {
				colorTacticalOverlay_1 = colorGlass;
				colorTacticalOverlay_2 = colorGlass;
			} 
			if (hideGlowIfEmptyArmor && totalArmor == 0) {
				showGlow = false;
			} else {
				showGlow = baseShowGlow;
			}
			if (hideGlassIfEmptyArmor && totalArmor == 0) {
				showGlass = false;
				showTacticalOverlay = false;
				showTacticalMarks = false;
			} else {
				showGlass = baseShowGlass;
				showTacticalOverlay = baseShowTacticalOverlay;
				showTacticalMarks = baseShowTacticalMarks;
			}
			
			if (gameplayColorBasisArmorGrid == 1) { 
				colorArmorGrid = colorArmor;
			} else {
				colorArmorGrid = baseColorArmorGrid;
			}
			renderStyleArmorGrid = STYLE_Translucent; // default
			
			if (powersOverrideGridColorMode > 0 && radSuitOn) {
				colorArmorGrid = RADSUIT_GRID_COLOR;
			}
			if (powersOverrideGridColorMode > 1 && invulnerabilityOn) {
				colorArmorGrid = INVULN_GRID_COLOR;
				renderStyleArmorGrid = STYLE_Add;
			}
			if (powersOverrideGridColorMode > 2 && playerinf.cheats & CF_GODMODE) {
				colorArmorGrid = GODMODE_GRID_COLOR;
				renderStyleArmorGrid = STYLE_Add;
			}
			
			initialUIInitDone = true;
			// prevGametic is incremented in another block later
		}
		
		FracTicGlobal = e.FracTic;
		
		uiSwayOffX = InterpolateValue(OldSwayOffX, SwayOffX, e.FracTic);
		uiSwayOffY = InterpolateValue(OldSwayOffY, SwayOffY, e.FracTic);

		if (screenWiperAnimTicker > 0) {
			DrawScreenWiper(); // does Screen.SetClipRect()
		}
		
		if (showBloodSplashes) {
			DrawBloodTextures();
		}
		
		Screen.ClearClipRect();
		
		if (showArmorGrid && isArmorGridShownVar) {
			DrawArmorGrid();
		} else if (needsTextureWarmUp) {
			DrawSimpleTextureCustom(
				texArmorGrid, (0,0), (Screen.GetWidth(), Screen.GetHeight()), 0, colorArmorGrid, renderStyleArmorGrid
			);
			DrawSimpleTextureCustom(
				texArmorGridIdleAnim, (0,0), (Screen.GetWidth(), Screen.GetHeight()), 0, colorArmorGrid, renderStyleArmorGrid
			);
			DrawSimpleTextureCustom(
				texArmorGridDamage, (0,0), (Screen.GetWidth(), Screen.GetHeight()), 0, colorArmorGrid, renderStyleArmorGrid
			);
			DrawSimpleTextureCustom(
				texArmorGridDamageHeavy, (0,0), (Screen.GetWidth(), Screen.GetHeight()), 0, colorArmorGrid, renderStyleArmorGrid
			);
		}

		if (startupAnimEnabled && level.time <= STARTUP_BLACK_TICKS) {
			DrawStartupFade();
		}
	
		if (showGlass) {
			alphaGlass = baseAlphaGlass;
			alphaGlassBottom = baseAlphaGlassBottom;
			DrawGlass();
		} else if (needsTextureWarmUp) {
			alphaGlass = 0;
			alphaGlassBottom = 0;
			DrawGlass();
		}
		
		if (showTacticalOverlay) {
			if (styleTacticalOverlay_1 != 0) {
				DrawTacticalOverlay(texTacticalOverlay_1, alphaTactical_1, colorTacticalOverlay_1);
			}
			if (styleTacticalOverlay_2 != 0) {
				DrawTacticalOverlay(texTacticalOverlay_2, alphaTactical_2, colorTacticalOverlay_2);
			}
		} else if (needsTextureWarmUp) {
			if (styleTacticalOverlay_1 != 0) {
				DrawTacticalOverlay(texTacticalOverlay_1, 0, colorTacticalOverlay_1);
			}
			if (styleTacticalOverlay_2 != 0) {
				DrawTacticalOverlay(texTacticalOverlay_2, 0, colorTacticalOverlay_2);
			}
		}
		
		if (showGlass && showGlassCracks) {
			DrawGlassCracks();
		} else if (needsTextureWarmup && cracksLevel > 0) {
			TextureID newCracksTex = TexMan.CheckForTexture(
				cracksBasePath .. "Pattern_" .. cracksTexturePatternId .. "/glass_cracks_" .. fInCracksTexId .. ".png"
			);
			DrawFullScreenTexture(newCracksTex, 0, colorGlassCracks);
		}
		
		if (showGlow) {
			if (playerinf.health > 0) {
				alphaGlow = baseAlphaGlow;
				alphaGlowBottom = baseAlphaGlowBottom;
			} else {
				// Simulate glow glitches
				if (prevGametic != gametic) {					
					if (level.time % 3 == 0 || level.time % 7 == 0 || level.time % 5 == 0) {
						alphaGlow = 0;
					} else if (level.time % 11 == 0) {
						alphaGlow = baseAlphaGlow;
					}
				}
			}
			DrawGlow();
		} else if (needsTextureWarmUp) {
			alphaGlow = 0;
			alphaGlowBottom = 0;
			DrawGlow();
		}
		
		if (showPieces) {
			alphaParts = baseAlphaParts;
			alphaPartBottom = baseAlphaPartBottom;
			DrawPieces();
		} else if (needsTextureWarmUp) {
			alphaParts = 0;
			alphaPartBottom = 0;
			DrawPieces();
		}
		
		if (prevGametic != gametic) {
			prevGametic = gametic;
		}
		
		screenSize = Cvar.GetCvar("screenblocks", playerinf).GetInt();
		
		needsTextureWarmUp = false;
    }
	
	ui void InitUiVars() {
		scaleFactorWidth = double(Screen.GetWidth()) / BASE_SCREEN_WIDTH;
		// Manual scaling and positioning, because we're not extending BaseStatusBar (to draw along with existing HUDs)
		scaleFactorHeight = double(Screen.GetHeight()) / BASE_SCREEN_HEIGHT;
		
		showPieces = Cvar.GetCvar("uvisor_show_pieces", playerinf).GetBool();
		showGlow = Cvar.GetCvar("uvisor_show_glow", playerinf).GetBool();
		baseShowGlow = showGlow; // used to restore glow if it's hidden when no armor
		showGlass = Cvar.GetCvar("uvisor_show_glass", playerinf).GetBool();
		baseShowGlass = showGlass;
		showTacticalOverlay = Cvar.GetCvar("uvisor_show_tactical_overlay", playerinf).GetBool();
		baseShowTacticalOverlay = showTacticalOverlay;
		showTacticalMarks = Cvar.GetCvar("uvisor_show_tactical_marks", playerinf).GetBool();
		baseShowTacticalMarks = showTacticalMarks;
		showArmorGrid = Cvar.GetCvar("uvisor_show_armor_grid", playerinf).GetBool();
		showGlassCracks = Cvar.GetCvar("uvisor_show_glass_cracks", playerinf).GetBool();
		showBloodSplashes = Cvar.GetCvar("uvisor_show_blood_splashes", playerinf).GetBool();
		
		styleTop = Cvar.GetCvar("uvisor_style_helmet_top", playerinf).GetInt();
		styleBottom = Cvar.GetCvar("uvisor_style_helmet_bottom", playerinf).GetInt();
		styleCorners = Cvar.GetCvar("uvisor_style_helmet_corners", playerinf).GetInt();
		styleSideGlass = Cvar.GetCvar("uvisor_style_side_glass", playerinf).GetInt();
		styleTacticalOverlay_1 = Cvar.GetCvar("uvisor_style_tactical_overlay_1", playerinf).GetInt();
		styleTacticalOverlay_2 = Cvar.GetCvar("uvisor_style_tactical_overlay_2", playerinf).GetInt();

		translucentGlowStyle = Cvar.GetCvar("uvisor_translucent_glow_style", playerinf).GetBool();
		
		colorPartTop = Cvar.GetCvar("uvisor_color_part_top", playerinf).GetString();
		syncPartColors = Cvar.GetCvar("uvisor_sync_part_colors", playerinf).GetBool();
		colorPartBottom;
		colorPartCorners;
		if (syncPartColors) {
			colorPartBottom = colorPartTop;
			colorPartCorners = colorPartTop;
		} else {
			colorPartBottom = Cvar.GetCvar("uvisor_color_part_bottom", playerinf).GetString();
			colorPartCorners = Cvar.GetCvar("uvisor_color_part_corners", playerinf).GetString();
		}
		
		colorGlow = Cvar.GetCvar("uvisor_color_glow", playerinf).GetString();
		baseColorGlow = colorGlow;
		
		syncGlowGlassColors = Cvar.GetCvar("uvisor_sync_glow_glass", playerinf).GetBool();
		colorGlass;
		if (syncGlowGlassColors) {
			colorGlass = colorGlow;
		} else {
			colorGlass = Cvar.GetCvar("uvisor_color_glass", playerinf).GetString();
		}
		colorTacticalOverlay_1 = Cvar.GetCvar("uvisor_color_tactical_overlay_1", playerinf).GetString();
		colorTacticalOverlay_2 = Cvar.GetCvar("uvisor_color_tactical_overlay_2", playerinf).GetString();
		colorGlassCracks =  Cvar.GetCvar("uvisor_color_glass_cracks", playerinf).GetString();
		colorArmorGrid =  Cvar.GetCvar("uvisor_color_armor_grid", playerinf).GetString();
		baseColorArmorGrid = colorArmorGrid;

		alphaParts = Cvar.GetCvar("uvisor_alpha_parts", playerinf).GetFloat();
		baseAlphaParts = alphaParts;
		alphaGlow = Cvar.GetCvar("uvisor_alpha_glow", playerinf).GetFloat();
		baseAlphaGlow = alphaGlow; // used for health < 0 "glitches"
		alphaGlass = Cvar.GetCvar("uvisor_alpha_glass", playerinf).GetFloat();
		baseAlphaGlass = alphaGlass;
		alphaTactical_1 = Cvar.GetCvar("uvisor_alpha_tactical_1", playerinf).GetFloat();
		baseAlphaTactical_1 = alphaTactical_1;
		alphaTactical_2 = Cvar.GetCvar("uvisor_alpha_tactical_2", playerinf).GetFloat();
		baseAlphaTactical_2 = alphaTactical_2;
		alphaArmorGrid = Cvar.GetCvar("uvisor_alpha_armor_grid", playerinf).GetFloat();
		baseAlphaArmorGrid = alphaArmorGrid;
		alphaCracks = Cvar.GetCvar("uvisor_alpha_cracks", playerinf).GetFloat();
		baseAlphaCracks = alphaCracks;
		alphaBlood = Cvar.GetCvar("uvisor_alpha_blood", playerinf).GetFloat();
		overrideAlphaBottom = Cvar.GetCvar("uvisor_override_alpha_bottom", playerinf).GetBool();
		alphaPartBottom = Cvar.GetCvar("uvisor_alpha_part_bottom", playerinf).GetFloat();
		baseAlphaPartBottom = alphaPartBottom;
		alphaGlowBottom = Cvar.GetCvar("uvisor_alpha_glow_bottom", playerinf).GetFloat();
		baseAlphaGlowBottom = alphaGlowBottom;
		alphaGlassBottom = Cvar.GetCvar("uvisor_alpha_glass_bottom", playerinf).GetFloat();
		baseAlphaGlassBottom = alphaGlassBottom;
		
		showPartTop = Cvar.GetCvar("uvisor_show_part_top", playerinf).GetBool();
		showGlowTop = Cvar.GetCvar("uvisor_show_glow_top", playerinf).GetBool();
		showGlassTop = Cvar.GetCvar("uvisor_show_glass_top", playerinf).GetBool();
		showPartBottom = Cvar.GetCvar("uvisor_show_part_bottom", playerinf).GetBool();
		showGlowBottom = Cvar.GetCvar("uvisor_show_glow_bottom", playerinf).GetBool();
		showGlassBottom = Cvar.GetCvar("uvisor_show_glass_bottom", playerinf).GetBool();
		showPartCorners = Cvar.GetCvar("uvisor_show_part_corners", playerinf).GetBool();
		showGlowCorners = Cvar.GetCvar("uvisor_show_glow_corners", playerinf).GetBool();
		showGlassCorners = Cvar.GetCvar("uvisor_show_glass_corners", playerinf).GetBool();
		autoHideCornersMode = Cvar.GetCvar("uvisor_auto_hide_corners_mode", playerinf).GetInt(); 
		autoHideCornersScreenSize = Cvar.GetCvar("uvisor_auto_hide_corners_screensize", playerinf).GetInt(); 
		showGlassSides = Cvar.GetCvar("uvisor_show_glass_sides", playerinf).GetBool();

		offsetTop = Cvar.GetCvar("uvisor_offset_top", playerinf).GetInt();
		offsetBottom = Cvar.GetCvar("uvisor_offset_bottom", playerinf).GetInt();
		offsetCornersX = Cvar.GetCvar("uvisor_offset_corners_x", playerinf).GetInt();
		offsetCornersY = Cvar.GetCvar("uvisor_offset_corners_y", playerinf).GetInt();
		offsetSidesGlass = Cvar.GetCvar("uvisor_offset_sides_glass", playerinf).GetInt();
		offsetTacticalMarks = Cvar.GetCvar("uvisor_offset_tactical_marks", playerinf).GetInt();
		widthScaleBottom = Cvar.GetCvar("uvisor_width_scale_bottom", playerinf).GetFloat();
		widthScaleCorners = Cvar.GetCvar("uvisor_width_scale_corners", playerinf).GetFloat();
		
		gameplayColorBasisGlow = Cvar.GetCvar("uvisor_gameplay_color_basis_glow", playerinf).GetInt();
		gameplayColorBasisGlass = Cvar.GetCvar("uvisor_gameplay_color_basis_glass", playerinf).GetInt();
		gameplayColorBasisArmorGrid = Cvar.GetCvar("uvisor_gameplay_color_basis_armor_grid", playerinf).GetInt();
		gameplayColorStep1 = Cvar.GetCvar("uvisor_gameplay_color_step_1", playerinf).GetString();
		gameplayColorStep2 = Cvar.GetCvar("uvisor_gameplay_color_step_2", playerinf).GetString();
		gameplayColorStep3 = Cvar.GetCvar("uvisor_gameplay_color_step_3", playerinf).GetString();
		gameplayColorStep4 = Cvar.GetCvar("uvisor_gameplay_color_step_4", playerinf).GetString();
		
		syncGlassTacticalOverlayColors = Cvar.GetCvar("uvisor_sync_glass_tactical_overlay", playerinf).GetBool();

		hideGlowIfEmptyArmor = Cvar.GetCvar("uvisor_hide_glow_if_empty_armor", playerinf).GetBool();
		hideGlassIfEmptyArmor = Cvar.GetCvar("uvisor_hide_glass_if_empty_armor", playerinf).GetBool();
		
		armorGridDisplayMode = Cvar.GetCvar("uvisor_armor_grid_display_mode", playerinf).GetInt();
		powersOverrideGridColorMode = Cvar.GetCvar("uvisor_powers_overrides_grid_color_mode", playerinf).GetInt();
		
		alphaBasisArmorGrid = Cvar.GetCvar("uvisor_gameplay_alpha_basis_armor_grid", playerinf).GetInt();
		
		int texRes = Cvar.GetCvar("uvisor_tex_res", playerinf).GetInt();
		if (texRes == 0) {
			texResPath = "High_Res";
		} else if (texRes == 1) {
			texResPath = "Med_Res";
		} else {
			texResPath = "Low_Res";
		}
		if (texRes != prevTexRes) {
			needsTextureWarmup = true;
		}
		prevTexRes = texRes;
		String helmetGraphicsPath = "graphics/" .. texResPath .. "/Helmets/";
		commonGraphicsPath = "graphics/" .. texResPath .. "/Common/";
		cracksBasePath = "graphics/" .. texResPath .. "/Common/Cracks/";
		
		texPartTacticalMarkLeft = TexMan.CheckForTexture(commonGraphicsPath .. "Tactical_Marks/Part_Tactical_Mark_Left.png");
		texPartTacticalMarkRight = TexMan.CheckForTexture(commonGraphicsPath .. "Tactical_Marks/Part_Tactical_Mark_Right.png");
		texGlowTacticalMarkLeft = TexMan.CheckForTexture(commonGraphicsPath .. "Tactical_Marks/Glow_Tactical_Mark_Left.png");
		texGlowTacticalMarkRight = TexMan.CheckForTexture(commonGraphicsPath .. "Tactical_Marks/Glow_Tactical_Mark_Right.png");
 		texTacticalOverlay_1 = TexMan
			.CheckForTexture(commonGraphicsPath .. "Tactical_Lines_Decals/Overlay_" .. tacticalOverlayStyles[styleTacticalOverlay_1] .. ".png");
		texTacticalOverlay_2 = TexMan
			.CheckForTexture(commonGraphicsPath .. "Tactical_Lines_Decals/Overlay_" .. tacticalOverlayStyles[styleTacticalOverlay_2] .. ".png");
		texArmorGrid = TexMan.CheckForTexture(commonGraphicsPath .. "Armor_Grid/" .. "armor_grid.png");
		texArmorGridIdleAnim = TexMan.CheckForTexture(commonGraphicsPath .. "Armor_Grid/" .. "armor_grid_idle_anim.png");
		texArmorGridDamage = TexMan.CheckForTexture(commonGraphicsPath .. "Armor_Grid/" .. "armor_grid_damage.png");
		texArmorGridDamageHeavy = TexMan.CheckForTexture(commonGraphicsPath .. "Armor_Grid/" .. "armor_grid_damage_heavy.png");
		
		texPartTop = TexMan.CheckForTexture(helmetGraphicsPath .. topStyles[styleTop] .. "/Part_Top.png");
		texPartBottom = TexMan.CheckForTexture(helmetGraphicsPath .. bottomStyles[styleBottom] .. "/Part_Bottom.png");
		texPartCornerLeft = TexMan.CheckForTexture(helmetGraphicsPath .. cornerStyles[styleCorners] .. "/Part_Corner_Left.png");
		texPartCornerRight = TexMan.CheckForTexture(helmetGraphicsPath .. cornerStyles[styleCorners] .. "/Part_Corner_Right.png");
			
		texGlowTop = TexMan.CheckForTexture(helmetGraphicsPath .. topStyles[styleTop] .. "/Glow_Top.png");
		texGlowBottom = TexMan.CheckForTexture(helmetGraphicsPath .. bottomStyles[styleBottom] .. "/Glow_Bottom.png");
		texGlowCornerLeft = TexMan.CheckForTexture(helmetGraphicsPath .. cornerStyles[styleCorners] .. "/Glow_Corner_Left.png");
		texGlowCornerRight = TexMan.CheckForTexture(helmetGraphicsPath .. cornerStyles[styleCorners] .. "/Glow_Corner_Right.png");
		
		texGlassTop = TexMan.CheckForTexture(helmetGraphicsPath .. topStyles[styleTop] .. "/Glass_Top.png");
		texGlassBottom = TexMan.CheckForTexture(helmetGraphicsPath .. bottomStyles[styleBottom] .. "/Glass_Bottom.png");
		texGlassCornerLeft = TexMan.CheckForTexture(helmetGraphicsPath .. cornerStyles[styleCorners] .. "/Glass_Corner_Left.png");
		texGlassCornerRight = TexMan.CheckForTexture(helmetGraphicsPath .. cornerStyles[styleCorners] .. "/Glass_Corner_Right.png");
		texGlassSideLeft = TexMan.CheckForTexture(helmetGraphicsPath .. sideGlassStyles[styleSideGlass] .. "/Glass_Side_Left.png");
		texGlassSideRight = TexMan.CheckForTexture(helmetGraphicsPath .. sideGlassStyles[styleSideGlass] .. "/Glass_Side_Right.png");
		
		warningSoundBasisUIContext = Cvar.GetCvar("uvisor_warning_sound_mode", playerinf).GetInt();
		
		isGL_EnhancedNV = Cvar.GetCvar("gl_enhanced_nightvision", playerinf).GetBool();
		
		texScreenWiper = TexMan.CheckForTexture(commonGraphicsPath .. "screen_wiper.png");
	}
	
	ui void DrawStartupFade() {
		TextureID texBlack = TexMan.CheckForTexture("graphics/startup_black.png");
		double alphaBlackInter;
		if (level.time < STARTUP_BLACK_SOLID_TICKS) {
			alphaBlackInter = 1.0;
		} else {
			double alphaBlackPrev = 1 
				- double(level.time - STARTUP_BLACK_SOLID_TICKS - 1) / (STARTUP_BLACK_TICKS - STARTUP_BLACK_SOLID_TICKS);
			double alphaBlack = 1 
				- double(level.time - STARTUP_BLACK_SOLID_TICKS) / (STARTUP_BLACK_TICKS - STARTUP_BLACK_SOLID_TICKS);
			alphaBlackInter = InterpolateValue(alphaBlackPrev, alphaBlack, FracTicGlobal);
		}
		DrawFullScreenTexture(texBlack, alphaBlackInter, FULL_WHITE_COLOR);
	}
	
	ui void DrawArmorGrid() {	
		double x = InterpolateValue(prevArmorGridCoords.x, armorGridCoords.x, FracTicGlobal) * scaleFactorWidth;
		double y = InterpolateValue(prevArmorGridCoords.y, armorGridCoords.y, FracTicGlobal) * scaleFactorHeight;
		double w = InterpolateValue(prevArmorGridSize.x, armorGridSize.x, FracTicGlobal) * scaleFactorWidth;
		double h = InterpolateValue(prevArmorGridSize.y, armorGridSize.y, FracTicGlobal) * scaleFactorHeight;
		double gridImage_1_AlphaInter 
			= alphaArmorGrid * InterpolateValue(prevGridIdleAlphaImage_1, gridIdleAlphaImage_1, FracTicGlobal);
		double gridImage_2_AlphaInter = 0.0;
		if (gridIdleAnimEnabled) {
			gridImage_2_AlphaInter = alphaArmorGrid 
				* InterpolateValue(prevGridIdleAlphaImage_2, gridIdleAlphaImage_2, FracTicGlobal);
		}
		if (alphaBasisArmorGrid == 1 && (armorGridDisplayMode == 2 || armorGridDisplayMode == 0)) {
			gridImage_1_AlphaInter *= alphaArmorGridMult;
			gridImage_2_AlphaInter *= alphaArmorGridMult;
		}
		Color texColor = CalculateColorWithBrightnessAndPowerup(colorArmorGrid, UV_HudVisorDraw.ARMOR_GRID);
		if (armorGridDamageAnimTicker > 0) {
			// Calc alpha ratio for usual grid (may be a combo of two idle textures) and damage grid 
			double usualGridAlphaInterpolated 
				= alphaArmorGrid * InterpolateValue(prevUsualArmorGridAlpha, usualArmorGridAlpha, FracTicGlobal);
			double damageGridAlphaInterpolated 
				= alphaArmorGrid * InterpolateValue(prevDamageArmorGridAlpha, damageArmorGridAlpha, FracTicGlobal);
			gridImage_1_AlphaInter *= usualGridAlphaInterpolated;
			gridImage_2_AlphaInter *= usualGridAlphaInterpolated;
			// Draw damage grid
			TextureID finalGridDamageTexture = armorGridHeavyDamageTicker > 0 ? texArmorGridDamageHeavy : texArmorGridDamage;
			DrawSimpleTextureCustom(finalGridDamageTexture, (x,y), (w,h), damageGridAlphaInterpolated, 
				texColor, renderStyleArmorGrid, UV_HudVisorDraw.ARMOR_GRID); // if damage ticker is active, calc alpha ratio of two idle grid textures (as one) AND damage texture
		}
		// Draw idle grid (two textures if anim enabled)
		DrawSimpleTextureCustom(texArmorGrid, (x,y), (w,h), 
			gridImage_1_AlphaInter, texColor, renderStyleArmorGrid);
		if (gridIdleAnimEnabled) {
			DrawSimpleTextureCustom(texArmorGridIdleAnim, (x,y), (w,h), gridImage_2_AlphaInter, 
				texColor, renderStyleArmorGrid, UV_HudVisorDraw.ARMOR_GRID);
		}
	}
	
	ui void DrawTacticalOverlay(TextureID tex, double overlayAlpha, Color overlayColor) {
		DrawFullScreenTexture(tex, overlayAlpha, overlayColor);
	}
	
	ui void DrawGlass() {
		Color texColor = CalculateColorWithBrightnessAndPowerup(colorGlass, UV_HudVisorDraw.GLASS);
		double texAlpha = alphaGlass;
		double texAlphaBottom = overrideAlphaBottom ? alphaGlassBottom : alphaGlass;
		if (showGlassSides && styleSideGlass != 0) {
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLASS,
				texGlassSideLeft,
				UV_HudVisorDraw.MIDDLE_LEFT,
				texColor,
				offsetX: offsetSidesGlass,
				alphaOverride: texAlpha
			);
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLASS,
				texGlassSideRight,
				UV_HudVisorDraw.MIDDLE_RIGHT,
				texColor,
				offsetX: offsetSidesGlass,
				alphaOverride: texAlpha
			);
		}
		if (showGlassTop && styleTop != 0) {
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLASS,
				texGlassTop,
				UV_HudVisorDraw.TOP_MIDDLE,
				texColor,
				offsetY: offsetTop,
				alphaOverride: texAlpha
			);
		}
		if (showGlassBottom && styleBottom != 0) {
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLASS,
				texGlassBottom,
				UV_HudVisorDraw.BOTTOM_MIDDLE,
				texColor,
				offsetY: offsetBottom,
				optionalWidthScale: widthScaleBottom,
				alphaOverride: texAlphaBottom
			);
		}
		bool showPartCornersGlass = showGlassCorners && styleCorners != 0
			&& !(autoHideCornersMode == 2 && autoHideCornersScreenSize == screenSize);
		if (showPartCornersGlass) {
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLASS,
				texGlassCornerLeft, 
				UV_HudVisorDraw.BOTTOM_LEFT,
				texColor,
				offsetX: offsetCornersX,
				offsetY: offsetCornersY,
				optionalWidthScale: widthScaleCorners,
				alphaOverride: texAlpha
			);
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLASS,
				texGlassCornerRight, 
				UV_HudVisorDraw.BOTTOM_RIGHT,
				texColor,
				offsetX: offsetCornersX,
				offsetY: offsetCornersY,
				optionalWidthScale: widthScaleCorners,
				alphaOverride: texAlpha
			);
		}
	}
	
	ui void DrawGlow() {
		Color texColor = CalculateColorWithBrightnessAndPowerup(colorGlow, UV_HudVisorDraw.GLOW);
		double texAlpha = alphaGlow;
		if (pulseActive) {
			targetPulseAlpha = alphaGlow * (sin(pulseTime) * 0.5 + 0.5);
			texAlpha = InterpolateValue(prevPulseAlpha, targetPulseAlpha, FracTicGlobal);
			prevPulseAlpha = texAlpha;
		}
		double texAlphaBottom;
		if (overrideAlphaBottom) {
			texAlphaBottom = alphaGlowBottom;
			if (pulseActive) {
 				targetPulseAlphaBottom = alphaGlowBottom * (sin(pulseTime) * 0.5 + 0.5);
				texAlphaBottom = InterpolateValue(prevPulseAlphaBottom, targetPulseAlphaBottom, FracTicGlobal);
				prevPulseAlphaBottom = texAlphaBottom;
			}
		} else {
			texAlphaBottom = texAlpha;
		}
		if (showTacticalMarks) {
			int w, h;
			[w, h] = TexMan.getSize(texPartTacticalMarkLeft);
			float widthScaleMarks = scaleFactorHeight / scaleFactorWidth; // to prevent width scale of the marks in DrawHelmetTextureCustom()
			if (showGlow) {
				DrawHelmetTextureCustom(
					UV_HudVisorDraw.GLOW,
					texGlowTacticalMarkLeft,
					UV_HudVisorDraw.TOP_LEFT,
					texColor,
					offsetX: -MaxSwayX,
					offsetY: -offsetTacticalMarks - MaxSwayY,
					optionalWidthScale: widthScaleMarks,
					alphaOverride: texAlpha
				);
				DrawHelmetTextureCustom(
					UV_HudVisorDraw.GLOW,
					texGlowTacticalMarkRight,
					UV_HudVisorDraw.TOP_RIGHT,
					texColor,
					offsetX: -MaxSwayX,
					offsetY: -offsetTacticalMarks - MaxSwayY,
					optionalWidthScale: widthScaleMarks,
					alphaOverride: texAlpha
				);
			}
		}
		if (showGlowTop && styleTop != 9 && styleTop != 0) { // if not Plain_Glass or None
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLOW,
				texGlowTop, 
				UV_HudVisorDraw.TOP_MIDDLE, 
				texColor,
				offsetY: offsetTop,
				alphaOverride: texAlpha
			);
		}
		if (showGlowBottom && styleBottom != 7  && styleBottom != 0) { // if not Plain_Glass or None
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLOW,
				texGlowBottom, 
				UV_HudVisorDraw.BOTTOM_MIDDLE,
				texColor,
				offsetY: offsetBottom,
				optionalWidthScale: widthScaleBottom,
				alphaOverride: texAlphaBottom
			);
		}
		bool showPartCornersGlow = showGlowCorners && styleCorners != 0
			&& !(autoHideCornersMode > 0 && autoHideCornersScreenSize == screenSize);
		if (showPartCornersGlow) {
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLOW,
				texGlowCornerLeft, 
				UV_HudVisorDraw.BOTTOM_LEFT,
				texColor,
				offsetX: offsetCornersX,
				offsetY: offsetCornersY,
				optionalWidthScale: widthScaleCorners,
				alphaOverride: texAlpha
			);
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLOW,
				texGlowCornerRight, 
				UV_HudVisorDraw.BOTTOM_RIGHT,
				texColor,
				offsetX: offsetCornersX,
				offsetY: offsetCornersY,
				optionalWidthScale: widthScaleCorners,
				alphaOverride: texAlpha
			);
		}
	}
	
	ui void DrawPieces() {
		Color texColorTop = CalculateColorWithBrightnessAndPowerup(colorPartTop, UV_HudVisorDraw.PART_TOP);
		if (showTacticalMarks) {
			int w, h;
			[w, h] = TexMan.getSize(texPartTacticalMarkLeft);
			float widthScaleMarks = scaleFactorHeight / scaleFactorWidth; // to prevent width scale of the marks in DrawHelmetTextureCustom()
			if (showPieces) {
				DrawHelmetTextureCustom(
					UV_HudVisorDraw.GLASS,
					texPartTacticalMarkLeft,
					UV_HudVisorDraw.TOP_LEFT,
					texColorTop,
					offsetX: -MaxSwayX, // no need to reposition lines when sway is enabled
					offsetY: -offsetTacticalMarks - MaxSwayY, // minus cause moving downwards from top
					optionalWidthScale: widthScaleMarks
				);
				DrawHelmetTextureCustom(
					UV_HudVisorDraw.GLASS,
					texPartTacticalMarkRight,
					UV_HudVisorDraw.TOP_RIGHT,
					texColorTop,
					offsetX: -MaxSwayX,
					offsetY: -offsetTacticalMarks - MaxSwayY,
					optionalWidthScale: widthScaleMarks
				);
			}
		}
		if (showPartTop && styleTop != 9 && styleTop != 0) { // if not Plain_Glass or None
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.PART_TOP,
				texPartTop, 
				UV_HudVisorDraw.TOP_MIDDLE,
				texColorTop,
				offsetY: offsetTop
			);
		}
		if (showPartBottom && styleBottom != 7 && styleBottom != 0) { // if not Plain_Glass or None
			Color texColorBottom = CalculateColorWithBrightnessAndPowerup(colorPartBottom, UV_HudVisorDraw.PART_BOTTOM);
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.PART_BOTTOM,
				texPartBottom, 
				UV_HudVisorDraw.BOTTOM_MIDDLE,
				texColorBottom,
				offsetY: offsetBottom,
				optionalWidthScale: widthScaleBottom,
				alphaOverride: overrideAlphaBottom ? alphaPartBottom : alphaParts
			);
		}
		if (showPartCorners && styleCorners != 0) {
			Color texColorCorners = CalculateColorWithBrightnessAndPowerup(colorPartCorners, UV_HudVisorDraw.PART_CORNER);
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.PART_CORNER,
				texPartCornerLeft, 
				UV_HudVisorDraw.BOTTOM_LEFT,
				texColorCorners,
				offsetX: offsetCornersX,
				offsetY: offsetCornersY,
				optionalWidthScale: widthScaleCorners
			);
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.PART_CORNER,
				texPartCornerRight, 
				UV_HudVisorDraw.BOTTOM_RIGHT,
				texColorCorners,
				offsetX: offsetCornersX,
				offsetY: offsetCornersY,
				optionalWidthScale: widthScaleCorners
			);
		}
	}
	
	ui void DrawGlassCracks() {
		double f_InCracksAlphaInter = alphaCracks;
		// smaller size and coords for Space Marine helmet
		double sizeMult = styleTop == 5 ? 0.8 : 1.0; 
		double offsetX = styleTop == 5 ? Screen.GetWidth() / 7.0 : 0;
		double offsetY = styleTop == 5 ? Screen.GetHeight() / 7.0 : 0;
		// adjust size and offsets to draw texture a bit outside of screen edges 
		// so that more cracks "start" from visor edges for a bit more realism and to compensate the random rotation
		sizeMult *= 1.2; 
		offsetX -= Screen.GetWidth() * 0.1;
		offsetY -= Screen.GetHeight() * 0.1;
		if (cracksFadeTicker > 0) {
			TextureID oldCracksTex = TexMan.CheckForTexture(
				cracksBasePath .. "Pattern_" .. cracksTexturePatternId .. "/glass_cracks_" .. fOutCracksTexId .. ".png"
			);
			double f_OutCracksAlphaInter = alphaCracks * InterpolateValue(prevF_OutCracksAlpha, f_OutCracksAlpha, FracTicGlobal);
			DrawFullScreenTexture(oldCracksTex, f_OutCracksAlphaInter, colorGlassCracks, 
				sizeMult: sizeMult, offsetX: offsetX, offsetY: offsetY, degree: cracksTextureRotationDegree
			);
			f_InCracksAlphaInter *= InterpolateValue(prevF_InCracksAlpha, f_InCracksAlpha, FracTicGlobal);
		}
		if (cracksLevel > 0) {
			TextureID newCracksTex = TexMan.CheckForTexture(
				cracksBasePath .. "Pattern_" .. cracksTexturePatternId .. "/glass_cracks_" .. fInCracksTexId .. ".png"
			);
			DrawFullScreenTexture(newCracksTex, f_InCracksAlphaInter, colorGlassCracks, 
				sizeMult: sizeMult, offsetX: offsetX, offsetY: offsetY, degree: cracksTextureRotationDegree
			);
		}
	}
	
	ui void DrawScreenWiper() {
		double w, h; 
		[w,h] = TexMan.GetSize(texScreenWiper);
		w *= scaleFactorWidth;
		h *= scaleFactorHeight;
		double ratioInterpolated = InterpolateValue(prevClipRatioInverted, clipRatioInverted, FracTicGlobal);
		double x = Screen.GetWidth() - (Screen.GetWidth() + w) * ratioInterpolated;
		double y = 0;
		Color wiperColor = FULL_WHITE_COLOR;
		wiperColor = CalculateColorWithBrightnessAndPowerup(wiperColor);
		Screen.DrawTexture(
			texScreenWiper, false,
			x + uiSwayOffX + ShakeOffsetX,
			y + uiSwayOffY + ShakeOffsetY,
			DTA_DestWidthF, w,
			DTA_DestHeightF, h,
			DTA_Color, wiperColor
		);
		Screen.SetClipRect(0, 0, Screen.GetWidth() - Screen.GetWidth() * ratioInterpolated, Screen.GetHeight());
	}
	
	ui void DrawBloodTextures() {		
		for (int i = 0; i < bloodMaxCount; i++) {
			UV_BloodSplash bs = currentBloodSplashes[i];
			if (bs == null || bs.fadeOutTicker < 1) continue;
			double texAlpha = InterpolateValue(bs.prevAlpha, bs.alpha, FracTicGlobal);
			texAlpha *= alphaBlood;
			int texRenderStyle = Style_Translucent;
			if (invisEffectOn) {
				[texAlpha, texRenderStyle] = GetPartialInvisibilityDrawParams(texAlpha);
			}
			if (ShouldUseStencilStyle()) {
				texRenderStyle = STYLE_TranslucentStencil;
			}
			Color texColor = CalculateColorWithBrightnessAndPowerup(bs.bColor);			

			double x = InterpolateValue(bs.prevCoordinates.x, bs.coordinates.x, FracTicGlobal);
			double y = InterpolateValue(bs.prevCoordinates.y, bs.coordinates.y, FracTicGlobal);
			double w = InterpolateValue(bs.prevSize.x, bs.size.x, FracTicGlobal);
			double h = InterpolateValue(bs.prevSize.y, bs.size.y, FracTicGlobal);
			
			TextureID bloodTexture = TexMan.CheckForTexture(CommonGraphicsPath .. "Blood/blood_" .. bs.texIndex .. ".png");
			
			Screen.DrawTexture(
				bloodTexture, false, 
				x + uiSwayOffX + ShakeOffsetX,
				y + uiSwayOffY + ShakeOffsetY,
				DTA_DestWidthF, w,
				DTA_DestHeightF, h,
				DTA_Alpha, texAlpha,
				DTA_Color, texColor,
				DTA_LegacyRenderStyle, texRenderStyle
			);
		}
    }
	
	ui void DrawHelmetTextureCustom(
				UV_TextureTypes texType, // part, glow, glass - affects color, alpha, render style
				TextureID texture, 
				ScreenAnchors anchor,
				Color texColor,
				double offsetX = 0, // additional offset defined in UV options menu
				double offsetY = 0, 
				double optionalWidthScale = 1.0, // additional scale defined in UV options menu
				double optionalHeightScale = 1.0,
				float alphaOverride = -1.0) {
				
		int origWidth, origHeight;
		[origWidth, origHeight] = TexMan.GetSize(texture);
		double texWidth = ceil(origWidth * scaleFactorWidth); // without ceil it could be 1559.9996 instead of 1600 which will not pass next check
		texWidth *= optionalWidthScale;
		double diffSwayTex = Screen.GetWidth() + scaledMaxSwayX * 2 - texWidth;
		if ((helmetSwaying || helmetShaking)
				&& diffSwayTex <= scaledMaxSwayX * 2 // if scaled texture width equals screenwidth or is a bit bigger (but not bigger than scaledMaxSwayX * 2)
				&& diffSwayTex > 0 // and if not already big enough
				&& (anchor == UV_HudVisorDraw.TOP_MIDDLE || anchor == UV_HudVisorDraw.BOTTOM_MIDDLE)) {
			texWidth += diffSwayTex; // increase its width to get extra space for swaying
		}
		double texHeight = ceil(origHeight * scaleFactorHeight);
		texHeight *= optionalHeightScale;
		diffSwayTex = Screen.GetHeight() + scaledMaxSwayY * 2 - texHeight;
		if ((helmetSwaying || helmetShaking) 
				&& diffSwayTex <= scaledMaxSwayY * 2
				&& diffSwayTex > 0
				&& (anchor == UV_HudVisorDraw.MIDDLE_LEFT || anchor == UV_HudVisorDraw.MIDDLE_RIGHT)) {
			texHeight += scaledMaxSwayY * 2;
		}
		offsetX *= scaleFactorWidth;
		offsetY *= scaleFactorHeight;
		double x, y;
		[x, y] = CalcTextureCoordinates(anchor, texWidth, texHeight, offsetX, offsetY);
		
		int texRenderStyle = STYLE_Translucent; // Default style to use alpha level
		float texAlpha = 1.0;
		switch (texType) {
			case PART_TOP: // Separate parts with separate colors
				texAlpha = alphaParts;
				break;
			case PART_BOTTOM:
				texAlpha = alphaPartBottom;
				break;
			case PART_CORNER:
				texAlpha = alphaParts;
				break;
			case GLOW:
				texAlpha = alphaGlow;
				if (!translucentGlowStyle) 
					texRenderStyle = STYLE_Add;
				break;
			case GLASS:
				texAlpha = alphaGlass;
				break;
		}
		
		if (alphaOverride >= 0) {
			texAlpha = alphaOverride;
		}
		
		if (invisEffectOn) {
			[texAlpha, texRenderStyle] = GetPartialInvisibilityDrawParams(texAlpha, texType);
		}
		if (ShouldUseStencilStyle(texType)) {
			texRenderStyle = STYLE_TranslucentStencil;
		}
		
		Screen.DrawTexture(
			texture, false,
			x + uiSwayOffX + ShakeOffsetX, // already scaled
			y + uiSwayOffY + ShakeOffsetY,
			DTA_DestWidthF, texWidth,
			DTA_DestHeightF, texHeight,
			DTA_Alpha, texAlpha,
			DTA_Color, texColor,
			DTA_LegacyRenderStyle, texRenderStyle
		);
	}
	
	ui Color BlendColors(Color base, Color blend, double factor) {
		int r = int(base.r * (1.0 - factor) + blend.r * factor);
		int g = int(base.g * (1.0 - factor) + blend.g * factor); 
		int b = int(base.b * (1.0 - factor) + blend.b * factor); 
		return Color(255, r, g, b);
	}
	
	ui double, int GetPartialInvisibilityDrawParams(double baseAlpha, UV_TextureTypes texType = -1) {
		if (texType == UV_HudVisorDraw.GLOW || texType == UV_HudVisorDraw.ARMOR_GRID) {
			baseAlpha *= 0.15;
		} else {
			baseAlpha *= 0.4;
		}
		int texRenderStyle = globals.isPB_Loaded ? STYLE_Subtract : STYLE_Translucent;
		return baseAlpha, texRenderStyle;
	}
	
	ui double, double CalcTextureCoordinates(
									ScreenAnchors anchor, 
									double texWidth,  // params should be already scaled for screen resolution
									double texHeight,
									double offsetX = 0,
									double offsetY = 0) {
		double x = 0, y = 0;
		switch (anchor) {
			case TOP_LEFT:
				x = 0 - offsetX;
				if (helmetSwaying || helmetShaking) {
					x -= scaledMaxSwayX;
				}
				y = 0 - offsetY;
				if (helmetSwaying || helmetShaking) {
					y -= scaledMaxSwayY;
				}
				break;
			case TOP_MIDDLE:
				x = Screen.GetWidth() / 2.0 - texWidth / 2.0;
				y = 0 - offsetY;
				if (helmetSwaying || helmetShaking) {
					y -= scaledMaxSwayY;
				}
				break;
			case TOP_RIGHT:
				x = Screen.GetWidth() - texWidth + offsetX;
				if (helmetSwaying || helmetShaking) {
					x += scaledMaxSwayX;
				}
				y = 0 - offsetY;
				if (helmetSwaying || helmetShaking) {
					y -= scaledMaxSwayY;
				}
				break;
			case MIDDLE_LEFT:
				x = 0 - offsetX;
				if (helmetSwaying || helmetShaking) {
					x -= scaledMaxSwayX;
				}
				y = Screen.GetHeight() / 2.0 - texHeight / 2.0;
				break;
			case MIDDLE_RIGHT:
				x = Screen.GetWidth() - texWidth + offsetX;
				if (helmetSwaying || helmetShaking) {
					x += scaledMaxSwayX;
				}
				y = Screen.GetHeight() / 2.0 - texHeight / 2.0;
				break;
			case BOTTOM_LEFT:
				x = 0 - offsetX;
				if (helmetSwaying || helmetShaking) {
					x -= scaledMaxSwayX;
				}
				y = Screen.GetHeight() - texHeight + offsetY;
				if (helmetSwaying || helmetShaking) {
					y += scaledMaxSwayY;
				}
				break;
			case BOTTOM_MIDDLE:
				x = Screen.GetWidth() / 2.0 - texWidth / 2.0;
				y = Screen.GetHeight() - texHeight + offsetY;
				if (helmetSwaying || helmetShaking) {
					y += scaledMaxSwayY;
				}
				break;
			case BOTTOM_RIGHT:
				x = Screen.GetWidth() - texWidth + offsetX;
				if (helmetSwaying || helmetShaking) {
					x += scaledMaxSwayX;
				}
				y = Screen.GetHeight() - texHeight + offsetY;
				if (helmetSwaying || helmetShaking) {
					y += scaledMaxSwayY;
				}
				break;
		}
		return x, y;
	}
	
	ui void DrawFullScreenTexture(TextureID texture, 
									double texAlpha, 
									Color texColor,
									double sizeMult = 1.0,
									double offsetX = 0,
									double offsetY = 0,
									int texRenderStyle = STYLE_Translucent,
									double degree = 0) {
		if (invisEffectOn) {
			[texAlpha, texRenderStyle] = GetPartialInvisibilityDrawParams(texAlpha);
		}
		if (ShouldUseStencilStyle()) {
			texRenderStyle = Style_TranslucentStencil;
		}
		texColor = CalculateColorWithBrightnessAndPowerup(texColor);
		Screen.DrawTexture(
			texture, false, 
			offsetX + uiSwayOffX + ShakeOffsetX - scaledMaxSwayX, // move texture (and increase size in DestWidth/DestHeight) not to draw beyond its edges
			offsetY + uiSwayOffY + ShakeOffsetY - scaledMaxSwayY,
			DTA_DestWidthF, (Screen.GetWidth() + scaledMaxSwayX * 2) * sizeMult, 
			DTA_DestHeightF, (Screen.GetHeight() + scaledMaxSwayY * 2) * sizeMult, 
			DTA_Alpha, 	texAlpha,
			DTA_Color, texColor,
			DTA_LegacyRenderStyle, texRenderStyle,
			DTA_Rotate, degree
		);
	}
	
	ui void DrawSimpleTextureCustom(TextureID texture, vector2 coords, vector2 size, 
									double texAlpha, Color texColor, int texRenderStyle, UV_TextureTypes texType = -1) {
		if (invisEffectOn) {
			[texAlpha, texRenderStyle] = GetPartialInvisibilityDrawParams(texAlpha, texType);
		}
		if (ShouldUseStencilStyle(texType)) {
			texRenderStyle = Style_TranslucentStencil;
		}
		Screen.DrawTexture(
			texture, false, 
			coords.x + uiSwayOffX + ShakeOffsetX - scaledMaxSwayX, // move texture (and increase size in DestWidth/DestHeight) not to draw beyond its edges
			coords.y + uiSwayOffY + ShakeOffsetY - scaledMaxSwayY,
			DTA_DestWidthF, size.x + scaledMaxSwayX * 2, 
			DTA_DestHeightF, size.y + scaledMaxSwayY * 2, 
			DTA_Alpha, 	texAlpha,
			DTA_Color, texColor,
			DTA_LegacyRenderStyle, texRenderStyle
		);
	}
	
	ui bool ShouldUseStencilStyle(UV_TextureTypes texType = -1) {
		return (isVanillaInvulernabilityOn && !isVanillaInvulernabilityBlinking)
			|| 
			(NV_PackInverseMapOn 
				&& !isLastPowerupColomapped 
				&& (texType == -1 || texType == UV_HudVisorDraw.ARMOR_GRID) // grid, blood, wiper
			);
	}

	// Calculate color for health or armor indication based on their value
	ui Color GetIndicatorColor(int value) {
		double minValue;
		int startR, startG, startB, endR, endG, endB;
		double interpolation;
		if (value <= 15) { // Just red by default without gradation
			startR = gameplayColorStep1.r;
			startG = gameplayColorStep1.g;
			startB = gameplayColorStep1.b;
			endR = gameplayColorStep1.r;
			endG = gameplayColorStep1.g;
			endB = gameplayColorStep1.b;
			interpolation = 1;
		} else if (value <= 40) { // From red to white by default
			minValue = 16;
			startR = gameplayColorStep1.r;
			startG = gameplayColorStep1.g;
			startB = gameplayColorStep1.b;
			endR = gameplayColorStep2.r;
			endG = gameplayColorStep2.g;
			endB = gameplayColorStep2.b;
			interpolation = (value - minValue) / (40 - minValue);
		} else if (value <= 100) { // From white to green by default
			minValue = 41;
			startR = gameplayColorStep2.r;
			startG = gameplayColorStep2.g;
			startB = gameplayColorStep2.b;
			endR = gameplayColorStep3.r;
			endG = gameplayColorStep3.g;
			endB = gameplayColorStep3.b;
			interpolation = (value - minValue) / (100 - minValue);
		} else {
			if (value > 200) {
				value = 200;
			}
			minValue = 101; // From green to bright blue by default
			interpolation = (value - minValue) / (200 - minValue);
			startR = gameplayColorStep3.r;
			startG = gameplayColorStep3.g;
			startB = gameplayColorStep3.b;
			endR = gameplayColorStep4.r;
			endG = gameplayColorStep4.g;
			endB = gameplayColorStep4.b;
		}
		int r = int(startR + (endR - startR) * interpolation);
		int g = int(startG + (endG - startG) * interpolation);
		int b = int(startB + (endB - startB) * interpolation);
		Color interpolatedColor = (r << 16) | (g << 8) | b; // Pack into 24-bit color (RRGGBB format)
		return interpolatedColor;
	}
	
	ui Color CalculateColorWithBrightnessAndPowerup(Color originalColor, UV_TextureTypes texType = -1) {
		Color newColor = Color(255, originalColor.r, originalColor.g, originalColor.b); // 
		bool isAffectedByBrightness = true;
		
		if (ShouldUseStencilStyle(texType)) {
			// default invulnerability, to use with Stencil style. No PB, cause no white effect there
			return GetColorForStencilStyle(originalColor);
		}
		
		if (nightVisionOn && !isLastPowerupColomapped) {
			if (isGL_EnhancedNV) { // Idk why vanilla Enhanced Night Vision doesn't color blood
				int grayscaleAmount = CalculateGrayscaleAmount(originalColor);
				newColor = Color(255, grayscaleAmount - 40, grayscaleAmount + 30, 0);
				if (texType > -1 && texType != UV_HudVisorDraw.ARMOR_GRID) { // Helmet parts except armor grid
					newColor = BlendColors(originalColor, newColor, 0.35);
				}
			} else {
				// Light Amplification mode (vanilla / NV Pack default mode / other mods)
				newColor = BrightenColor(originalColor, 1.1);
			}
			isAffectedByBrightness = false;
		}
		
		if (lastColormappedPowerup && !isLastColormappedPowerupBlinking) { // last name of a powerup with Powerup.Colormap (false if empty string, i.e. no such powerup)
			newColor = CalcColorWithColormappedPowerup(newColor, lastColormappedPowerup, texType);
			isAffectedByBrightness = false;
		}
		if (combPlayerBlendAndPowerupBlendColor && effectiveBlendAlpha) { // if Powerup.Color or A_SetBlend()
			newColor = BlendColors(newColor, combPlayerBlendAndPowerupBlendColor, effectiveBlendAlpha);
		}
		
		if (!isAffectedByBrightness) {
			return newColor;
		}
		double brightness = double(playerinf.mo.cursector.lightlevel) / double(255.0); // lightlevel is 0-255
		brightness *= 1.3;
		brightness = Clamp(brightness, 0.4, 1.0); // So it's never too dark
		double influence = 1.0;
		if (texType == UV_HudVisorDraw.GLOW) { // Reduce brightness influence
			influence = 0.35;
		} else if (texType == UV_HudVisorDraw.ARMOR_GRID) {
			influence = 0.5;
		} else if (texType > -1) { // Reduce for helmet pieces and glass too, but not so much
			influence = 0.85;
		}
		brightness = 1.0 + (brightness - 1.0) * influence;
		int r, g, b;
		r = int(newColor.r * brightness);
		g = int(newColor.g * brightness);
		b = int(newColor.b * brightness);
		
		return Color(255, r, g, b);
	}
	
	ui Color CalcColorWithColormappedPowerup(Color originalColor, String powerupName, UV_TextureTypes texType = -1) {
		// Can't read actual Colormap colors, so hardcode for names
	
		if (powerupName == "PowerInvulnerable") {
			if (globals.isBD_Loaded) {
				int grayscaleAmount = CalculateGrayscaleAmount(originalColor);
				return Color(255, grayscaleAmount, grayscaleAmount, grayscaleAmount);
			} else if (globals.isHellrider_Loaded) {
				int grayscaleAmount = CalculateGrayscaleAmount(originalColor) * 3.5;
				int r = int(grayscaleAmount * 0.35);
				int g = int(grayscaleAmount * 0.25);
				return Color(255, r, g, grayscaleAmount);
			} else if (globals.isHellriderVengeful_Loaded) {
				int grayscaleAmount = CalculateGrayscaleAmount(originalColor);
				return Color(255, 10, grayscaleAmount + 65, grayscaleAmount + 10);
			}
		}
		
		// Night vision mods
		
		if (texType == UV_HudVisorDraw.GLOW) {
			return originalColor;
		}
		bool _nightVisionOn = false;
		Color newColor = originalColor;
		if (globals.isNightVisionPack_Loaded) { 
			// Night Vision Pack
			int grayscaleAmount = CalculateGrayscaleAmount(originalColor);
			
			// Inverse Map mode is handled separately using NV_PackInverseMapOn cause we change render style for it
			
			if (powerupName == "NVNightVision") { // Night Vision (green)
				_nightVisionOn = true;
				newColor = Color(255, 0, grayscaleAmount + 35, 0);
			}
			if (powerupName == "NVNightVisionProto") { // Prototype (blue-green)
				_nightVisionOn = true;
				newColor = Color(255, 0, grayscaleAmount + 20, grayscaleAmount + 20);
			}
			if (powerupName == "NVNightVisionGoldMap") { // GoldMap
				_nightVisionOn = true;
				newColor = Color(255, grayscaleAmount + 55, grayscaleAmount + 10, 0);
			}
			if (powerupName == "NVNightVisionGreenMap") { // GreenMap (yellow-green)
				_nightVisionOn = true;
				newColor = Color(255, grayscaleAmount + 30, grayscaleAmount + 40, grayscaleAmount + 10);
			}
			if (powerupName == "NVNightVisionRedMap") { // RedMap
				_nightVisionOn = true;
				newColor = Color(255, grayscaleAmount + 50, int(grayscaleAmount * 0.3), int(grayscaleAmount * 0.3));
			}
			if (powerupName == "NVNightVisionWhite") { // White (bright grayscale)
				_nightVisionOn = true;
				newColor = Color(255, grayscaleAmount + 20, grayscaleAmount + 20, grayscaleAmount + 20);
			}
		}

		if (globals.isDD_Loaded && powerupName == "PowerNightVisionMode") { // DD goggles (green)
			_nightVisionOn = true;
			newColor = Color(255, 0, CalculateGrayscaleAmount(originalColor), 0);
		}
		if (_nightVisionOn && texType > -1 && texType != UV_HudVisorDraw.ARMOR_GRID) {
			newColor = BlendColors(originalColor, newColor, 0.2); // Simulate light reflection for helmet parts except armor grid
		}
		return newColor;
	}
	
	ui int CalculateGrayscaleAmount(Color originalColor) {
		// luminosity method
		return int(0.2126 * originalColor.r + 0.7152 * originalColor.g + 0.0722 * originalColor.b);
	}
	
	ui Color GetColorForStencilStyle(Color originalColor) {
		int grayscale = CalculateGrayscaleAmount(originalColor) + 110;
		return Color(255, grayscale, grayscale, grayscale);
	}
	
	ui Color BrightenColor(Color originalColor, double multiplier) {
		return Color(255, 
			int(originalColor.r * multiplier), 
			int(originalColor.g * multiplier), 
			int(originalColor.b * multiplier)
		);
	}
	
	// Set ammo colors if glow/glass are ammo-based and notify about low ammo if warning sound or glow pulse are ammo-based
	ui void SetAmmoColors() {
		if (ammoData.am1max > 0) {
			colorAmmo1 = GetIndicatorColor(mappedCurrentAmmo1);
		}
		
		if (ammoData.am2max > 0) {
			colorAmmo2 = GetIndicatorColor(mappedCurrentAmmo2);
		}
		
		if (ammoData.ammo1_ClassName && !ammoData.ammo2_ClassName) {
			colorAmmo2 = colorAmmo1;
		} else if (ammoData.ammo2_ClassName && !ammoData.ammo1_ClassName) {
			colorAmmo1 = colorAmmo2;
		}
		
		if (!ammoData.ammo1_ClassName && !ammoData.ammo2_ClassName) {
			string wClass = ammoData.weaponClassName;
			if (wClass) {
				if (wClass.IndexOf("Ledge") != -1 || wClass.IndexOf("BladeWeapon") != -1
						|| wClass.IndexOf("GloryFist") != -1)
						{
					return; // if these are found, keep color of previous weapon
				} else {
					// or if for example chainsaw with infinite ammo is selected, set max color
					colorAmmo1 = gameplayColorStep4;
					colorAmmo2 = gameplayColorStep4;
				}
			}
		}
	}
	
	ui double InterpolateValue(double prev, double next, double fracTic) {
		return prev * (1.0 - fracTic) + next * fracTic;
	}
	
	ui Color InterpolateColor(Color prev, Color next, double fracTic) {
			int r, g, b;
			r = InterpolateValue(prev.r, next.r, fracTic);
			g = InterpolateValue(prev.g, next.g, fracTic);
			b = InterpolateValue(prev.b, next.b, fracTic);
			return Color(255, r, g, b);
	}
	
	override void InterfaceProcess(ConsoleEvent e) {
        if (e.name == "UV_SavegameLoaded") {
			InitUIVars(); // called only in menu/console or on level start otherwise
			needsTextureWarmUp = true;
        }
    }
	
	
	
	//////////////////// PLAY CONTEXT - handles events, calculations for sway, cracks, grid, blood, etc. ////////////////////
	
	override void OnRegister() {
		// Init helper vars only once
		DynSwayX = UV_DynamicDoubleInterpolator.Create(0, 0.3, 0, 120);
		DynSwayY = UV_DynamicDoubleInterpolator.Create(0, 0.3, 0, 64);
		DynCrouchAnim = UV_DynamicDoubleInterpolator.Create(0, 0.35, 0, 100);
		BD_BLOOD = "Brutal_Blood";
		PM_BLOOD = "PM_NormalBloodBase";
		MD_BLOOD = "MDBlood";
		heavyMachinegunStr = "PowerHeavyMachinegunSwitch";
		PB_NightVisionStr = "PB_PowerLightAmp";
		NVNightVisionInverseMapStr = "NVNightVisionInverseMap";
		startupTicker = STARTUP_TICKS;
		paramsForIsVisible.minDist = 1; // prevent false positives (for our case), which apparently happen when minDist is 0
		globals = UV_HudVisorStaticGlobals.Get();
		if (!Factory) {
            Factory = new("UV_AmmoReaderFactory");
            Factory.readerClassName = "UV_AmmoReader";
        }
	}
	
	override void WorldTick() {
			
		playerinf = players[consoleplayer];
		if (!playerinf.mo)
            return;
			
		if (Cvar.GetCvar("uvisor_mod_enabled", playerinf).GetBool() == 0) {
			return;
		}
		
		if (gamestate != GS_LEVEL) {
            return;  // Prevent drawing helmet in main menu with mods overriding Titlemap
		}
		
		if (wasMenuOpened || globals.isSavegameJustLoaded || !initialPlayInitDone) {
			globals.isSavegameJustLoaded = false;
			wasMenuOpened = false;
			InitPlayVars();
			initialPlayInitDone = true;
		}
		
		if (startupAnimEnabled && startupVolume > 0 && level.time == STARTUP_BLACK_SOLID_TICKS - 8) {
			S_StartSound("uvisor_startup", CHAN_AUTO, volume: startupVolume);
		}
		
		CheckPowersAndVehicles();
		SetBlendColorAndAlpha();
		SetStoredHealthArmor();
		
		if (showBloodSplashesPlayContext) {
			UpdateBloodSplashesData();
		}
		if (screenWiperAnimTicker > 0) {
			UpdateScreenWiperData();
		}
		
		if (isDemonPlayer) {
			return;
		}
		UpdateTotalArmor();
		CheckArmorOnlyDamage();
		
		if (totalArmor < previousArmor && totalArmor <= 0 && machineGunEnterLeaveTicker == 0 && !isDemonPlayer) {
			DoArmorDepletedSound();
		}
		
		if (hideGlassIfEmptyArmorPlayContext && totalArmor == 0) {
			showGlassPlayContext = false;
		} else {
			showGlassPlayContext = baseShowGlassPlayContext;
		}
		
		if (level.time > STARTUP_BLACK_SOLID_TICKS - 5) { // Some mods start up (fade in) a bit late, so show grid after a delay
			SetArmorGridShownVar();
		}
		
		DoArmorGridEquipAnim();
		
		if (isArmorGridShownVar && machineGunEnterLeaveTicker == 0) {
			if ((previousArmor - totalArmor >= 25) || (previousHealth - playerinf.health >= 25)) {
				// Heavy damage, show very thick damage grid
				InitGridDamageAnim();
				armorGridHeavyDamageTicker = ARMOR_GRID_HEAVY_DAMAGE_ANIM_TICKS; 
			} else if ((previousArmor - totalArmor >= 2) || (previousHealth - playerinf.health >= 2)) {
				// Small damage, show a little bit thick damage grid
				InitGridDamageAnim();
			}
		}
		if (armorGridDamageAnimTicker > 0) {
			UpdateGridDamageAnimData();
		}
		UpdateGridIdleAnimData();
		double armorClamped = clamp(totalArmor, 1, 200);
		alphaArmorGridMult = 0.3 + ((armorClamped - 1) / 199.0) * 0.7; // mult between 0.3 and 1.0 so grid isn't almost invisible even at 1 armor
		
		UpdateCracksStatus();
		
		pulseActive = (pulseMode == 1)
			|| (pulseMode == 2 && playerinf.health <= 30)
			|| (pulseMode == 3 && totalArmor <= 30)
			|| (pulseMode == 4 && warningAmmo1Active)
			|| (pulseMode == 5 && warningAmmo2Active);
		
		previousHealth = storedHealthInsideVehicle > -1 ? storedHealthInsideVehicle : playerinf.health;
		previousArmor = totalArmor;
		if (!inVehicle && !wasInVehicle) {
			alreadyStoredDataInVehicle = false;
			storedHealthInsideVehicle = -1;
			storedArmorInsideVehicle = -1;
		}
		
		SetIsThirdPerson();
		DoWarningSound();
		DoBreathingSound();
		prevWarningSoundChannel = warningSoundChannel;
		prevBreathSoundChannel = breathSoundChannel;
		
		if (helmetShaking) {
			DoHelmetShaking();
		} else {
			ShakeOffsetX = 0;
			ShakeOffsetY = 0;
		}
		
		if (helmetSwaying) {
			DoHelmetSwaying();
		} else {
			SwayOffX = 0;
			SwayOffY = 0;
			OldSwayOffX = 0;
			OldSwayOffY = 0;
		}
		
		if (cracksLevel > prevCracksLevel && showGlassCracksPlayContext 
				&& cracksVolume > 0 && initalCracksUpdateDone && (prevCracksBasis == cracksBasis)) {
			if (cracksLevel == 5) {
				if (! (cracksBasis == 1 && !hideGlassIfEmptyArmorPlayContext) ) {
					S_StartSound("uvisor_glass_2", CHAN_AUTO, volume: cracksVolume);
				}
			} else {
				string glassSoundName = "uvisor_glass_1_" .. random(1, 3);
				S_StartSound(glassSoundName, CHAN_AUTO, volume: cracksVolume);
			}			
		}
		prevCracksBasis = cracksBasis;
		initalCracksUpdateDone = true;
		
		wasArmorGridShown = isArmorGridShownVar;
		
		wasInVehicle = inVehicle;
		wasInMachineGun = inMachineGun;
		
		if (pulseActive) {
			pulseTime += pulseSpeed * 2; // Needed for color calculation when drawing texture, bigger value for faster pulse
		}
		
		CheckAmmo();
		
		prevBreathVolume = breathVolume;

		if (startupTicker > 0) {
			startupTicker--;
		}
	}
	
	void InitPlayVars() {
		startupAnimEnabled = Cvar.GetCvar("uvisor_startup_anim_enabled", playerinf).GetBool();
		helmetSwaying = Cvar.GetCvar("uvisor_swaying", playerinf).GetBool();
		MaxSwayX = Clamp(Cvar.GetCVar("uvisor_maxsway_x", playerinf).GetFloat(), 0, 15);
		MaxSwayY = Clamp(Cvar.GetCVar("uvisor_maxsway_y", playerinf).GetFloat(), 0, 15);
		swaySensitivity = Cvar.GetCVar("uvisor_sway_sensitivity", playerinf).GetFloat();
		cameraSwayMultX = Cvar.GetCVar("uvisor_camera_sway_mult_x", playerinf).GetFloat();
		cameraSwayMultY = Cvar.GetCVar("uvisor_camera_sway_mult_y", playerinf).GetFloat();
		MovementSway = Cvar.GetCVar("uvisor_movement_sway", playerinf).GetBool();
		MovementSwayMultX = Cvar.GetCVar("uvisor_movement_sway_mult_x", playerinf).GetFloat();
		MovementSwayMultY = Cvar.GetCVar("uvisor_movement_sway_mult_y", playerinf).GetFloat();
		MovementSwayMultBob = Cvar.GetCVar("uvisor_movement_sway_mult_bob", playerinf).GetFloat();
		SwayBobMode = Cvar.GetCVar("uvisor_bob_sway_mode", playerinf).GetInt();
		SwayBobFreq = Cvar.GetCVar("uvisor_bob_sway_freq", playerinf).GetFloat();
		CrouchSway = Cvar.GetCvar("uvisor_crouch_sway", playerinf).GetBool();
		CrouchSwayIntensity = Cvar.GetCVar("uvisor_crouch_sway_intensity", playerinf).GetFloat();
		JumpSway = Cvar.GetCvar("uvisor_jump_sway", playerinf).GetBool();
		JumpSwayIntensity = Cvar.GetCVar("uvisor_jump_sway_intensity", playerinf).GetFloat();
		helmetShaking = Cvar.GetCvar("uvisor_shaking", playerinf).GetBool();
		ShakeSensitivity = Cvar.GetCVar("uvisor_shaking_sensitivity", playerinf).GetFloat();
		scaleFactorWidthPlay = double(Screen.GetWidth()) / BASE_SCREEN_WIDTH;
		scaleFactorHeightPlay = double(Screen.GetHeight()) / BASE_SCREEN_HEIGHT;
		if (helmetSwaying || helmetShaking) {
			scaledMaxSwayX = MaxSwayX * scaleFactorWidthPlay;
			scaledMaxSwayY = MaxSwayY * scaleFactorHeightPlay;
		} else {
			MaxSwayX = 0;
			MaxSwayY = 0;
			scaledMaxSwayX = 0;
			scaledMaxSwayY = 0;
		}
		
		cracksBasis = Cvar.GetCvar("uvisor_cracks_basis", playerinf).GetInt();
		
		pulseMode = Cvar.GetCvar("uvisor_glow_pulse_mode", playerinf).GetInt();
		pulseSpeed = Cvar.GetCvar("uvisor_glow_pulse_speed", playerinf).GetFloat();
		
		showBloodSplashesPlayContext = Cvar.GetCvar("uvisor_show_blood_splashes", playerinf).GetBool();
		bloodFreq = Cvar.GetCVar("uvisor_blood_freq", playerinf).GetInt();
		bloodMaxInitDistance = Cvar.GetCVar("uvisor_blood_max_init_distance", playerinf).GetInt();
		bloodLifetime = Cvar.GetCVar("uvisor_blood_lifetime", playerinf).GetFloat();
		bloodVanishes = Cvar.GetCvar("uvisor_blood_vanishes", playerinf).GetBool();
		bloodSize = Cvar.GetCVar("uvisor_blood_size", playerinf).GetFloat();
		bloodRandomColors = Cvar.GetCvar("uvisor_blood_family_friendly_colors", playerinf).GetBool();
		bloodMaxCount = min(Cvar.GetCVar("uvisor_blood_max_count", playerinf).GetInt(), BLOOD_MAX_SPLASHES);
		bloodDetectionMode = Cvar.GetCVar("uvisor_blood_detection_mode", playerinf).GetInt();
		bloodDefaultSaturationShiftCvar = Cvar.GetCVar("uvisor_blood_default_saturation_shift", playerinf).GetInt();
		screenWiperMode = Cvar.GetCvar("uvisor_screen_wiper_mode", playerinf).GetInt();
		paramsForIsVisible.Fov = Cvar.GetCvar("fov", playerinf).GetFloat() + 40; // increased to consider enemies near screen edges
		paramsForIsVisible.maxDist = bloodMaxInitDistance + playerinf.mo.Radius;
		
		hideHelmetInThirdPerson = Cvar.GetCvar("uvisor_hide_helmet_in_third_person", playerinf).GetBool();
			
		showGlassCracksPlayContext = Cvar.GetCVar("uvisor_show_glass_cracks", playerinf).GetBool();
		
		warningSoundBasis = Cvar.GetCvar("uvisor_warning_sound_mode", playerinf).GetInt();
		warningVolume = Cvar.GetCVar("uvisor_warning_volume", playerinf).GetFloat();
		warningSoundChannel = Cvar.GetCvar("uvisor_warning_sound_channel", playerinf).GetInt();
		cracksVolume = Cvar.GetCVar("uvisor_cracks_sounds_volume", playerinf).GetFloat();
		hitVolume = Cvar.GetCVar("uvisor_hit_sounds_volume", playerinf).GetFloat();
		armorDepletedVolume = Cvar.GetCVar("uvisor_depleted_sound_volume", playerinf).GetFloat();
		breathDisableIfNoGlass = Cvar.GetCvar("uvisor_breath_disable_if_no_glass", playerinf).GetBool();
		breathVolume = Cvar.GetCvar("uvisor_breath_volume", playerinf).GetFloat();
		breathVoice = Cvar.GetCvar("uvisor_breath_voice", playerinf).GetInt();
		breathSoundChannel = Cvar.GetCvar("uvisor_breath_sound_channel", playerinf).GetInt();
		startupVolume = Cvar.GetCvar("uvisor_startup_volume", playerinf).GetFloat();
		screenWiperVolume = Cvar.GetCvar("uvisor_screen_wiper_volume", playerinf).GetFloat();
		
		hideGlassIfEmptyArmorPlayContext = Cvar.GetCvar("uvisor_hide_glass_if_empty_armor", playerinf).GetBool();
		
		showGlassPlayContext = Cvar.GetCvar("uvisor_show_glass", playerinf).GetBool();
		baseShowGlassPlayContext = showGlassPlayContext;
		
		showArmorGridPlay = Cvar.GetCvar("uvisor_show_armor_grid", playerinf).GetInt();
		gridIdleAnimEnabled = Cvar.GetCvar("uvisor_grid_idle_anim_enabled", playerinf).GetBool();
		armorGridDisplayModePlay = Cvar.GetCvar("uvisor_armor_grid_display_mode", playerinf).GetInt();
		armorGridDisableWhenOtherOverlay = Cvar.GetCVar("uvisor_grid_disable_when_radsuit_nightvis", playerinf).GetBool();
		
		transparencyEffectWhenInvis = Cvar.GetCVar("uvisor_transparency_on_invis", playerinf).GetBool();
		
		int texRes = Cvar.GetCvar("uvisor_tex_res", playerinf).GetInt();
		String texResPath;
		if (texRes == 0) {
			texResPath = "High_Res";
		} else if (texRes == 1) {
			texResPath = "Med_Res";
		} else {
			texResPath = "Low_Res";
		}
		String helmetGraphicsPath = "graphics/" .. texResPath .. "/Helmets/";
		CommonGraphicsPathPlayContext = "graphics/" .. texResPath .. "/Common/";
		
		if (globals && !globals.checkedLoadedMod) {
			globals.checkLoadedMod();
			globals.checkedLoadedMod = true;
		}
	}
	
	override void WorldThingDamaged(WorldEvent e) {
		// Trigger helmet shaking and enemy blood splashes (enemy-based mode)
		if (Cvar.GetCvar("uvisor_mod_enabled", playerinf).GetBool() == 0) {
			return;
		}
		
		if (e.thing == playerinf.mo) {
			UpdateTotalArmor();
			int totalDamage = e.Damage + previousArmor - totalArmor;
			if (hitVolume > 0 && (totalDamage > 5 && IsShakingDamageType(e) || totalDamage > 10)) {
				S_StartSound("uvisor_hit", CHAN_AUTO, volume: hitVolume);
			}
			if (totalDamage > 20 && IsShakingDamageType(e) || totalDamage > 40) {
				ShakeIntensity = clamp(ShakeIntensity + totalDamage * ShakeSensitivity, 0.0, 24.0);
			}
		} else if (showBloodSplashesPlayContext && bloodDetectionMode == 0 && e.Thing.bIsMonster) {
			if (!IsActorInLineOfSightAndNear(e.thing)) return;
			if (!showGlassPlayContext) return;
			string enemyClassName = e.thing.GetClassName();
			if (e.thing.bloodColor == UNSET_COLOR && (e.thing.bNOBLOOD || e.thing.bNOBLOODDECALS)) {
				if (!(globals.isDD_Loaded && enemyClassName.IndexOf("CYBORG") != -1) // Don't return if BD64 (except Lost Souls) or some enemies in DD
					&& !(globals.isDD_Loaded && enemyClassName.IndexOf("HUNTERKILLER") != -1)
					&& !(globals.isBD64_Loaded && !(e.thing is 'LostSoul'))
				) {
					return;
				}
			}
			for (int i = 0; i < damageTypesNoBlood.Size(); i++) {  
				if (e.DamageType == damageTypesNoBlood[i]) {
					return;
				}
			}
			
			Color newBloodColor;
			bool isValidColor;
			if (bloodRandomColors) {
				newBloodColor = GetRandomBloodColor();
			} else {
				[newBloodColor, isValidColor] = GetBloodColorFromEnemy(e.thing);
			}
			if (!isValidColor) return;

			if (random(1, 100) > (100 - bloodFreq)) {
				InitBloodSplash(newBloodColor);
			}
			if (bloodFreq > 100 && random(1, 100) > (200 - bloodFreq)) { // if frequency > 100 there's a chance for second splash at the same moment
				InitBloodSplash(newBloodColor);
			}
			if (bloodFreq > 200 && random(1, 100) > (300 - bloodFreq)) { // third splash
				InitBloodSplash(newBloodColor);
			}
		}
	}
	
	Color, bool GetBloodColorFromEnemy(Actor enemyActor) {
		Color newBloodColor;
		if (enemyActor.bloodColor != UNSET_COLOR) {
			// Good case: enemy has a specified blood color
			newBloodColor = enemyActor.bloodColor;
			if (globals.isPB_Loaded) { // PB blood decals seem to be darker than in most mods (but actually more in line with the defaultbloodcolor)
				newBloodColor = Color(255, 
					int(newBloodColor.r * 0.6), 
					int(newBloodColor.g * 0.6), 
					int(newBloodColor.b * 0.6)
				);
			}
		} else {
			// Not so good: vanilla Doom or mod enemies where color is empty (0, 0, 0, 0) (usually it's not the same as set black)
			// Try to find color name in the 3 blood types
			array<string> enemyBloodTypes;
			string enemyBloodType0 = "";
			if (enemyActor.GetBloodType(0) != null) {
				enemyBloodType0 = enemyActor.GetBloodType(0).getClassName();
				enemyBloodType0 = enemyBloodType0.MakeLower();
				enemyBloodTypes.Push(enemyBloodType0);
			} 
			string enemyBloodType1 = "";
			if (enemyActor.GetBloodType(1) != null) {
				enemyBloodType1 = enemyActor.GetBloodType(1).getClassName();
				enemyBloodType1 = enemyBloodType1.MakeLower();
			} 
			string enemyBloodType2 = "";
			if (enemyActor.GetBloodType(2) != null) {
				enemyBloodType2 = enemyActor.GetBloodType(2).getClassName();
				enemyBloodType2 = enemyBloodType2.MakeLower();
			}
			if (enemyBloodTypes.Size() == 0) {
				return Color(0,0,0,0), false; // Rare case when enemy doesn't have noblood flags, but has no actual blood and all 3 types are null (because has BloodType "None"?)
						// Example: Blot in Dragon Sector Remake
			}
			// Special cases
			if (globals.isDD_Loaded) {
				if (enemyBloodType2.IndexOf("blue") != -1) {
					return Color("3399BF"), true; // light blue
				}
			} else if (globals.isBD64_Loaded) {
				if (enemyBloodType1.IndexOf("blue") != -1) {
					return Color("1A166B"), true; // blue-purple, not just blue
				}
			}
			// Try to find color name in type names or use gameinfo default color
			newBloodColor = GetBloodColorFromTypesOrDefault(enemyBloodTypes);
		}
		return newBloodColor, true;
	}
	
	Color GetBloodColorFromTypesOrDefault(array<string> enemyBloodTypes) {
		int size = enemyBloodTypes.Size();
		for (int i = 0; i < size; i++) {
			if (enemyBloodTypes[i].IndexOf("green") != -1) {
				return Color("006400");
			} else if (enemyBloodTypes[i].IndexOf("blue") != -1) {
				return Color("0000FF");
			} else if (enemyBloodTypes[i].IndexOf("black") != -1) {
				return Color("000000");
			} else if (enemyBloodTypes[i].IndexOf("purple") != -1) {
				return Color("A020F0");
			} else if (enemyBloodTypes[i].IndexOf("orange") != -1) {
				return Color("FF7F50");
			}
		}
		return GetDefaultBloodColor();
	}
	
	Color GetDefaultBloodColor() {
		// If color is unset and we didn't find one of the common colors, use gameinfo default color
		Color defaultColor = gameinfo.defaultbloodcolor;
		// However it's usually quite dark comparing to actual enemies blood 
		// Because UV blood textures aren't completely white and because blood decals/sprites may differ in color
		// So increase brightness
		int red = int(defaultColor.r * globals.bloodDefaultSaturationMultiplier);
		int green = int(defaultColor.g * globals.bloodDefaultSaturationMultiplier);
		int blue = int(defaultColor.b * globals.bloodDefaultSaturationMultiplier);
		// Finally, adjust using cvar if it's set
		if (bloodDefaultSaturationShiftCvar != 0) {
			int shiftMapped = MapRange(bloodDefaultSaturationShiftCvar, -100, 100, -255, 255);
			red = (red > 0) ? (red + shiftMapped) : 0;
			green = (green > 0) ? (green + shiftMapped) : 0;
			blue = (blue > 0) ? (blue + shiftMapped) : 0;
		}
// 		console.printf("Adjusted default blood color: " .. Color(255, red, green, blue));
		return Color(255, red, green, blue);
	}
	
	void CheckArmorOnlyDamage() {
		// Trigger helmet shaking when mod armor fully protects health (like in EOA) and thus WorldThingDamaged isn't triggered
		if (previousHealth > playerinf.health) return; // in this case WorldThingDamaged is triggered, return
		int totalDamage = previousArmor - totalArmor;
		
		if (totalDamage > 30) { // can't check damage type here
			ShakeIntensity = clamp(ShakeIntensity + totalDamage * ShakeSensitivity, 0.0, 24.0);
		}
	}
	
	bool IsShakingDamageType(WorldEvent e) {
		if (e.DamageFlags == DMG_EXPLOSION) {
			return true;
		}
		for (int i = 0; i < shakingDamageTypes.Size(); i++) {
			if (e.DamageType == shakingDamageTypes[i]) {			
				return true;
			}
		}
		return false;
	}
	
	void UpdateTotalArmor() {
		if (storedArmorInsideVehicle > -1) {
			totalArmor = storedArmorInsideVehicle;
			return;
		}
		totalArmor = playerinf.mo.CountInv("BasicArmor");
	}
	
	// Update vars based on inventory items
	void CheckPowersAndVehicles() {
		Inventory invItem = playerinf.mo.Inv;
		invisEffectOn = false;
		radSuitOn = false;
		nightVisionOn = false;
		PB_NightVisionOn = false;
		NV_PackInverseMapOn = false;
		invulnerabilityOn = false;
		isVanillaInvulernabilityOn = false;
		isVanillaInvulernabilityBlinking = false;
		isDemonPlayer = false;
		inMachineGun = false;
		inVehicle = false;
		isLastPowerupColomapped = false;
		lastColormappedPowerup = "";
		powerupBlendColors.Clear();
		combPlayerBlendAndPowerupBlendColor = UNSET_COLOR;
		effectiveBlendAlpha = 0.0;
		string invulnerableStr;
		string nightVisionStr;
		if (globals.isPB_Loaded) {
			invulnerableStr = "PB_PowerInvul"; // check specifically this one to avoid grid highlight when doing melee groly kills
		} 
		else {
			invulnerableStr = "PowerInvulnerable";
		}
		if (globals.isDD_Loaded) {
			nightVisionStr = "NightVision";
		} else {
			nightVisionStr = "PowerLightamp";
		}
		while (invItem != null) {
			if (invItem is "Powerup" && !(invItem is "PowerIronfeet")) { // not radsuit
				isLastPowerupColomapped = false;
				isLastColormappedPowerupBlinking = false;
				Powerup pow = Powerup(invItem);
				if (pow.GetBlend()) { // Powerup.Color actor property
					powerupBlendColors.Push(pow.GetBlend());
				}
				if (pow.Colormap && pow.Colormap != -1) { 
					// Based on Powerup.Colormap actor property, but we can get only its dynamic id here (unreliable if multiple mods loaded)
					// So store powerup class name instead
					lastColormappedPowerup = pow.GetClassName();
					if (pow.isBlinking()) {
						isLastColormappedPowerupBlinking = true;
					}
// 					console.printf("===== pow.Colormap: " .. pow.Colormap);
// 					console.printf("lastColormappedPowerup: " .. lastColormappedPowerup);
					isLastPowerupColomapped = true; // gets reset if not last
				}
				if (globals.isNightVisionPack_Loaded && invItem is NVNightVisionInverseMapStr) {
					NV_PackInverseMapOn = true; 
				}
				if (invItem is invulnerableStr) {
					if (!pow.Colormap && !pow.GetBlend() && !globals.isPB_Loaded) {
						isVanillaInvulernabilityOn = true;
						if (pow.isBlinking()) {
							isVanillaInvulernabilityBlinking = true;
						}
					}
				}
			}
			if (invItem is "PowerInvisibility") { // "is" means items extending this power, so mods are compatible
				invisEffectOn = true;
			} else if (invItem is "PowerIronfeet") { 	// Radsuits
				radSuitOn = true;
			} else if (invItem is nightVisionStr) { 	// Night vision
				nightVisionOn = true;
				if (invItem is PB_NightVisionStr) {
					PB_NightVisionOn = true;
				} 
			} else if (invItem is invulnerableStr) {
				invulnerabilityOn = true;
			} else if (IsDemonPlayerFlag(invItem)) { 	// BD demon morphs
				isDemonPlayer = true;
			} else if (invItem is heavyMachinegunStr) { // BD and UMES machine gun
				inMachineGun = true;
			} else if (!inVehicle) {  					// BD and UMES vehicles except machine gun
				for (int i = 0; i < vehicleInvNames.Size(); i++) {
					if (invItem is vehicleInvNames[i]) {
						inVehicle = true;
						break;
					}
				}
			}
			invItem = invItem.Inv; // Move to the next item
		}
		invisEffectOn = invisEffectOn && transparencyEffectWhenInvis;
		
		if (isEnteringOrLeavingMachineGun()) {
			machineGunEnterLeaveTicker = 8;
		}
		if (machineGunEnterLeaveTicker > 0) {
			machineGunEnterLeaveTicker--;
		}
		
// 		console.printf("invulnerabilityOn: " .. invulnerabilityOn);
// 		console.printf("nightVisionOn: " .. nightVisionOn);
// 		console.printf("^isLastColormappedPowerupBlinking: " .. isLastColormappedPowerupBlinking);
// 		console.printf(" isVanillaInvulernabilityBlinking: " .. isVanillaInvulernabilityBlinking);
	}
	
	Color GetColorFromColormap(int subTableIndex, int originalPaletteIndex)
	{
		int colormapLump = Wads.CheckNumForName("COLORMAP", Wads.GLOBALNAMESPACE);
		int palLump = Wads.CheckNumForName("PLAYPAL", Wads.GLOBALNAMESPACE);
		
		if (colormapLump == -1 || palLump == -1)
			return Color(255, 0, 255);
		
		String colormapData = Wads.ReadLump(colormapLump);
		String palData = Wads.ReadLump(palLump);
		
		// Use ByteAt() instead of getCharAt()
		int startOffset = subTableIndex * 256;
		int remappedIndex = colormapData.ByteAt(startOffset + originalPaletteIndex);
		
		int colorOffset = remappedIndex * 3;
		int r = palData.ByteAt(colorOffset);
		int g = palData.ByteAt(colorOffset + 1);
		int b = palData.ByteAt(colorOffset + 2);
		
		return Color(r, g, b);
	}
	
	void SetBlendColorAndAlpha() {
		double combinedA;
		double combinedR;
		double combinedG;
		double combinedB;
		if (playerinf.BlendA) { // When actor has A_SetBlend() and its alpha is > 0
			combinedA += playerinf.BlendA;
			combinedR += playerinf.BlendR * playerinf.BlendA;
			combinedG += playerinf.BlendG * playerinf.BlendA;
			combinedB += playerinf.BlendB * playerinf.BlendA;
			Console.Printf("playerinf.Blend: R=%f, G=%f, B=%f, A=%f", playerinf.BlendR, playerinf.BlendG, playerinf.BlendB, playerinf.BlendA);
		}
		for (int i = 0; i < powerupBlendColors.Size(); i++) {
			Color pColor = powerupBlendColors[i];
			double blendColorAlpha = pColor.a / 255.0;
			if (blendColorAlpha <= 0.0) continue;
			combinedA += blendColorAlpha;
			combinedR += (pColor.r / 255.0) * blendColorAlpha;
			combinedG += (pColor.g / 255.0) * blendColorAlpha;
			combinedB += (pColor.b / 255.0) * blendColorAlpha;
			Console.Printf("powerupBlendColors[%d]: R=%f, G=%f, B=%f, A=%f",
						   i, pColor.r/255.0, pColor.g/255.0, pColor.b/255.0, blendColorAlpha);
		}
		if (combinedA > 0.0) {
			double normR = clamp(combinedR / combinedA, 0.0, 1.0);
			double normG = clamp(combinedG / combinedA, 0.0, 1.0);
			double normB = clamp(combinedB / combinedA, 0.0, 1.0);
			effectiveBlendAlpha = min(combinedA, 1.0);
			combPlayerBlendAndPowerupBlendColor = Color(255, int(normR * 255.0), int(normG * 255.0), int(normB * 255.0));
		}
	}
	
	bool IsDemonPlayerFlag(Inventory invItem) {
		for (int i = 0; i < isDemonPlayerFlags.Size(); i++) {
			if (invItem is isDemonPlayerFlags[i]) {
				return true;
			}
		}
		return false;
	}
		
	// Used to prevent some cracks/grid bugs when entering or leaving vehicles or machinegun
	void SetStoredHealthArmor() {
		if (inVehicle || (!inVehicle && wasInVehicle) || isEnteringOrLeavingMachineGun()) {
			if (!alreadyStoredDataInVehicle) {
				storedHealthInsideVehicle = previousHealth;
				storedArmorInsideVehicle = previousArmor;
				alreadyStoredDataInVehicle = true;
			}
		} else {
			storedHealthInsideVehicle = -1;
			storedArmorInsideVehicle = -1;
			alreadyStoredDataInVehicle = false;
		}
	}
	
	bool isEnteringOrLeavingMachineGun() {
		return (inMachineGun && !wasInMachineGun) || (!inMachineGun && wasInMachineGun);
	}
	
	void UpdateCracksStatus() {
		prevCracksLevel = cracksLevel;
		
		if (machineGunEnterLeaveTicker == 0 || playerinf.health <= 0) { // additional checks, actually we almost always go into this block
			int currentHealthOrArmor = cracksBasis == 0 ? playerinf.health : totalArmor;
			if (inVehicle || (!inVehicle && wasInVehicle)) {
				currentHealthOrArmor = cracksBasis == 0 ? storedHealthInsideVehicle : storedArmorInsideVehicle;
			}
			if (currentHealthOrArmor <= 0) {
				cracksLevel = 5;
			} else if (currentHealthOrArmor <= 15) {
				cracksLevel = 4;
			} else if (currentHealthOrArmor <= 30) {
				cracksLevel = 3;
			} else if (currentHealthOrArmor <= 50) {
				cracksLevel = 2;
			} else if (currentHealthOrArmor <= 70) {
				cracksLevel = 1;
			} else {
				cracksLevel = 0;
			}
		}
		if (cracksLevel != prevCracksLevel) {
			if (prevCracksBasis == cracksBasis) { // check prevents fading out 5th level cracks bug if switched cracks basis
				cracksFadeTicker = cracksLevel > prevCracksLevel ? (CRACKS_FADE_TICKS - 2) : CRACKS_FADE_TICKS;
			}
			if (cracksBasis == 1 && prevCracksLevel == 5) { 
				hideFadingOutCracks = true; // prevent fading out 5th level is armor-based cracks as well
				prevF_OutCracksAlpha = 0.0;
				f_OutCracksAlpha = 0.0;
			} else {
				f_OutCracksAlpha = double(cracksFadeTicker) / CRACKS_FADE_TICKS;
				prevF_OutCracksAlpha = 1.0;
			}
			f_InCracksAlpha = 1 - double(cracksFadeTicker) / CRACKS_FADE_TICKS;
			prevF_InCracksAlpha = 0.0;
			fInCracksTexId = cracksLevel;
			if (cracksBasis == 1) {
				fInCracksTexId = clamp(fInCracksTexId, 0, 4); // don't draw the most broken glass (5th level) when armor based
			}
			fOutCracksTexId = prevCracksLevel;
			if (prevCracksLevel == 0) {
				cracksTexturePatternId = random(1, CRACKS_MAX_PATTERN_ID);
				cracksTextureRotationDegree = random(-15, 15);
			}
		} else if (cracksFadeTicker > 0) {
			cracksFadeTicker--;
			prevF_OutCracksAlpha = f_OutCracksAlpha;
			f_OutCracksAlpha = hideFadingOutCracks ? 0.0 : double(cracksFadeTicker) / CRACKS_FADE_TICKS;
			prevF_InCracksAlpha = f_InCracksAlpha;
			f_InCracksAlpha = 1 - double(cracksFadeTicker) / CRACKS_FADE_TICKS;
		} else {
			hideFadingOutCracks = false;
		}
	}
	
	void SetArmorGridShownVar() {
		isArmorGridShownVar = showArmorGridPlay && (
					armorGridDisplayModePlay == 3 // "Always" mode
						|| (armorGridDisplayModePlay == 0 && totalArmor > 0) 				// "When Armor > 0"
						|| (armorGridDisplayModePlay == 1 && radSuitOn) 	 				// "When Radiation Suit Is On"
						|| (armorGridDisplayModePlay == 2 && (totalArmor > 0 || radSuitOn))	// "When Armor > 0 or Radiation Suit Is On"
				)
				// disable when "Disable Armor Grid When Radsuit or Nightvision On" and they are on indeed
				&& !(armorGridDisableWhenOtherOverlay && (radSuitOn || PB_NightVisionOn))
		;
		if (!isArmorGridShownVar && (inVehicle || wasInVehicle || machineGunEnterLeaveTicker > 0) && wasArmorGridShown) {
			isArmorGridShownVar = true;
		}
	}
	
	void DoArmorGridEquipAnim() {
		if (isArmorGridShownVar && !wasArmorGridShown) {
			armorGridEquipTicker = ARMOR_GRID_EQUIP_TICKS;
			prevArmorGridSize = (BASE_SCREEN_WIDTH * ARMOR_GRID_EQUIP_SIZE_MULT, BASE_SCREEN_HEIGHT * ARMOR_GRID_EQUIP_SIZE_MULT);
			double additionalWidth = BASE_SCREEN_WIDTH * ARMOR_GRID_EQUIP_SIZE_MULT - BASE_SCREEN_WIDTH;
			double additionalHeight = BASE_SCREEN_HEIGHT * ARMOR_GRID_EQUIP_SIZE_MULT - BASE_SCREEN_HEIGHT;
			prevArmorGridCoords = (
				0 - additionalWidth / 2, 
				0 - additionalHeight / 2
			);
		} else {
			prevArmorGridSize = armorGridSize;
			prevArmorGridCoords = armorGridCoords;
		}
		if (armorGridEquipTicker > 0) {
			armorGridEquipTicker--;
			double tickRatio = armorGridEquipTicker / ARMOR_GRID_EQUIP_TICKS;
			double additionalWidth = BASE_SCREEN_WIDTH * ARMOR_GRID_EQUIP_SIZE_MULT - BASE_SCREEN_WIDTH;
			double additionalHeight = BASE_SCREEN_HEIGHT * ARMOR_GRID_EQUIP_SIZE_MULT - BASE_SCREEN_HEIGHT;
			armorGridSize = (
				BASE_SCREEN_WIDTH + additionalWidth * tickRatio, 
				BASE_SCREEN_HEIGHT + additionalHeight * tickRatio
			);
			armorGridCoords = (
				0 - additionalWidth / 2 * tickRatio, 
				0 - additionalHeight / 2 * tickRatio
			);
		}
	}
	
	void InitGridDamageAnim() {
		if (armorGridDamageAnimTicker > 0 && armorGridDamageAnimTicker <= ARMOR_GRID_DAMAGE_ANIM_TICKS) {
			double half = ARMOR_GRID_DAMAGE_ANIM_TICKS / 2.0;
			double distanceFromPeak = abs(armorGridDamageAnimTicker - half);
			// If within 20% of the peak range, add hold time instead of resetting to hold damage grid texture
			if (distanceFromPeak < half * 0.2) {
				armorGridDamageHoldTicks += 10;    // Add extra hold ticks (e.g., 10 = ~0.3 sec)
				if (armorGridDamageHoldTicks > 30) {
					armorGridDamageHoldTicks = 30; // Clamp not to hold too log
				}
				return;
			}
		}
		// Start new anim if previous is finihsed
		armorGridDamageAnimTicker = ARMOR_GRID_DAMAGE_ANIM_TICKS;
		armorGridDamageHoldTicks = 0;
		usualArmorGridAlpha = 1.0;
		damageArmorGridAlpha = 0.0;
	}
	
	void UpdateGridDamageAnimData() {
		if (armorGridDamageAnimTicker <= 0 && armorGridDamageHoldTicks <= 0) return;
		
		// Store previous values for smooth interpolation
		prevUsualArmorGridAlpha = usualArmorGridAlpha;
		prevDamageArmorGridAlpha = damageArmorGridAlpha;
		
		if (armorGridDamageHoldTicks > 0) {
			armorGridDamageHoldTicks--;
			// During hold, force the ticker to the peak value (half) and keep damage grid texture opaque
			double half = ARMOR_GRID_DAMAGE_ANIM_TICKS / 2.0;
			armorGridDamageAnimTicker = half;
			usualArmorGridAlpha = 0.0;
			damageArmorGridAlpha = 1.0;
			return;
		}
		
		// Normal triangle wave (ticker decreases)
		if (armorGridDamageAnimTicker > 0) {
			armorGridDamageAnimTicker--;
			double half = ARMOR_GRID_DAMAGE_ANIM_TICKS / 2.0;
			usualArmorGridAlpha = abs(armorGridDamageAnimTicker - half) / half;
			damageArmorGridAlpha = 1.0 - usualArmorGridAlpha;
		}
		
		if (armorGridHeavyDamageTicker > 0) {
			armorGridHeavyDamageTicker--;
		}
	}
	
	void UpdateGridIdleAnimData() {
		if (!gridIdleAnimEnabled) {
			prevGridIdleAlphaImage_1 = 1.0;
			gridIdleAlphaImage_1 = 1.0;
			prevGridIdleAlphaImage_2 = 0.0;
			gridIdleAlphaImage_2 = 0.0;
			return;
		}
		gridIdleTimer++;
		prevGridIdleAlphaImage_1 = gridIdleAlphaImage_1;
		prevGridIdleAlphaImage_2 = gridIdleAlphaImage_2;
		// Init idle anim randomly after at least GRID_IDLE_CYCLE_TICKS and up to GRID_IDLE_CYCLE_TICKS * 10
        if (gridIdleTimer >= random(GRID_IDLE_CYCLE_TICKS, GRID_IDLE_CYCLE_TICKS * 10)) {
            gridIdleTimer = 0;
		}
        if (gridIdleTimer < GRID_IDLE_FADE_TICKS)
        {
            // First fade: image1 → image2
            double tickRatio = double(gridIdleTimer) / GRID_IDLE_FADE_TICKS;   // 0 → 1
            gridIdleAlphaImage_1 = 1.0 - tickRatio;
            gridIdleAlphaImage_2 = tickRatio;
        }
        else if (gridIdleTimer < 2 * GRID_IDLE_FADE_TICKS)
        {
            // Second fade: image2 → image1
            double tickRatio = double(gridIdleTimer - GRID_IDLE_FADE_TICKS) / GRID_IDLE_FADE_TICKS; // 0 → 1
            gridIdleAlphaImage_1 = tickRatio;
            gridIdleAlphaImage_2 = 1.0 - tickRatio;
        } else {
			gridIdleAlphaImage_2 = 0.0;
		}
	}
	
	override void WorldThingSpawned(worldEvent e) {
		// Trigger enemy blood splash in based on blood actor mode
		if (Cvar.GetCvar("uvisor_mod_enabled", playerinf).GetBool() == 0) return;
		if (!showGlassPlayContext) return;
		if (!showBloodSplashesPlayContext || bloodDetectionMode != 1 || !e.thing || e.thing.target == playerinf.mo ) return;
		
		bool isBlood = false;
		for (int i = 0; i < bloodBaseTypes.Size(); i++) {
			// Many custom blood types replace Blood instead of extending it, so need additional checks
			if (e.thing is bloodBaseTypes[i]) {
				isBlood = true;
				break;
			}
		}
		if (!isBlood) return;
		if (!IsActorInLineOfSightAndNear(e.thing)) return;
						
		if (e.thing is 'Blood' && e.thing.Distance3D(playerinf.mo) <= (24 + playerinf.mo.Radius)) { 
			return; // in Vanilla Doom e.thing.target is null, so check distance to exclude player's blood (not very reliable)
		}
		
		if (e.thing.Distance3D(playerinf.mo) <= (bloodMaxInitDistance + playerinf.mo.Radius)) {  // playerinf.mo.Radius is usually 16
			Color newBloodColor;
			if (random(1, 100) > (100 - bloodFreq)) {
				newBloodColor = bloodRandomColors ? GetRandomBloodColor() : GetBloodColorFromBlood(e.thing);
				InitBloodSplash(newBloodColor);
			}
			if (bloodFreq > 100 && random(1, 100) > (200 - bloodFreq)) { // if frequency > 100 there's a chance for second splash at the same moment
				InitBloodSplash(newBloodColor);
			}
			if (bloodFreq > 200 && random(1, 100) > (300 - bloodFreq)) { // third splash
				InitBloodSplash(newBloodColor);
			}
		}
	}
	
	Color GetBloodColorFromBlood(Actor thing) {
		Color newBloodColor;
		if (thing.target && thing.target.bISMONSTER) {
			newBloodColor = thing.target.bloodcolor;
		} else {
			newBloodColor = thing.bloodcolor;
		}
		if (newBloodColor == UNSET_COLOR) {
			if (!(thing is MD_BLOOD)) { // enemies in Mass Disassembly have black blood
				newBloodColor = GetDefaultBloodColor();
			}
			string bloodClassName = thing.GetClassName();
			bloodClassName = bloodClassName.MakeLower();
			if (bloodClassName.IndexOf("green") != -1) {
				newBloodColor = "006400";
			} else if (bloodClassName.IndexOf("blue") != -1) {
				newBloodColor = "0000FF";
			} else if (bloodClassName.IndexOf("black") != -1) {
				newBloodColor = "000000";
			} else if (bloodClassName.IndexOf("purple") != -1) {
				newBloodColor = "A020F0";
			} else if (bloodClassName.IndexOf("orange") != -1) {
				newBloodColor = "FF7F50";
			}
			if (thing is BD_BLOOD) { // need to manually check blood names in Brutal Doom blood
				for (int i = 0; i < bdBloodSubtypes.Size(); i++) {  
					if (thing is bdBloodSubtypes[i]) {
						newBloodColor = bdBloodSubtypesColors[i];
						break;
					}
				}
			} else if (thing is PM_BLOOD) { // Project Malice
				for (int i = 0; i < pmBloodSubtypes.Size(); i++) {  
					if (thing is pmBloodSubtypes[i]) {
						newBloodColor = pmBloodSubtypesColors[i];
						break;
					}
				}
			}
		}
		return newBloodColor;
	}
	
	void InitBloodSplash(Color newBloodColor) {
		int afterNewId = (newBloodSplashNumber < bloodMaxCount - 1) ? (newBloodSplashNumber + 1) : 0;
		if (timedAutoWiperTics <= 0 && !timedAutoWiperWasActive && screenWiperMode == 1) {
			if (bloodLifeTime <= 0) {
				timedAutoWiperTics = 1; // kinda instant wipe, 0 would require many changes in logic
			} else if (bloodVanishes) {
				timedAutoWiperTics = bloodLifetime * 35 + BLOOD_FADE_IN_TICS + 20;
													// increase by BLOOD_FADE_IN_TICS as well so that wiper isn't started when there's only one splash which already vanished
													// and additional 20 ticks for case when few splashes appeared in a very short time
			} else {
				timedAutoWiperTics = bloodLifetime * 35;
			}
			timedAutoWiperWasActive = true;
		}
		
		if (currentBloodSplashes[afterNewId] && currentBloodSplashes[afterNewId].fadeOutTicker > 0) {
			if (screenWiperAnimTicker <= 0 && screenWiperMode >= 1) {
				StartScreenWiper();
			}
			return;
		}
		UV_BloodSplash bs = new("UV_BloodSplash");
		bs.fadeInTicker = BLOOD_FADE_IN_TICS - 1; // To have texture's w, h > 0 at the first UI fractic
		if (bloodLifetime > 0) {
			bs.fadeOutTicker = bloodLifetime * 35;
		} else {
			bs.fadeOutTicker = 1;
		}
		bs.texIndex = random(1, BLOOD_MAX_TEXTURE_ID); // png names
		double w, h;
		TextureID bloodTex = TexMan
			.CheckForTexture(CommonGraphicsPathPlayContext .. "Blood/blood_" .. bs.texIndex .. ".png");
		[w,h] = TexMan.GetSize(bloodTex);
		double randomSizeMult = double(random(75, 125)) / 100;
		w *= randomSizeMult * bloodSize * scaleFactorWidthPlay;
		h *= randomSizeMult * bloodSize * scaleFactorHeightPlay;
		bs.fullSize = (w, h);
		double widthDecrease = w * double(bs.fadeInTicker) / BLOOD_FADE_IN_TICS;
		double heightDecrease = h * double(bs.fadeInTicker) / BLOOD_FADE_IN_TICS;
		bs.size = (w - widthDecrease, h - heightDecrease);
		bs.prevSize = (0, 0);
		bs.bColor = newBloodColor;
		bs.prevAlpha = 1.0;
		bs.alpha = 1.0;
		bs.origCoords.x = Screen.GetWidth() - w - random(0, Screen.GetWidth() - w);
		bs.origCoords.y = Screen.GetHeight() - h - random(0, Screen.GetHeight() - h);
		bs.coordinates.x = bs.origCoords.x + widthDecrease / 2;
		bs.coordinates.y = bs.origCoords.y + heightDecrease / 2;
		bs.prevCoordinates.x = bs.origCoords.x + w / 2;
		bs.prevCoordinates.y = bs.origCoords.y + w / 2;
		
		currentBloodSplashes[newBloodSplashNumber] = bs;
		newBloodSplashNumber = afterNewId;
	}
	
	void UpdateBloodSplashesData() {
		if (!showGlassPlayContext) {
			for (int i = 0; i < bloodMaxCount; i++) {
				if (currentBloodSplashes[i]) {
					currentBloodSplashes[i].fadeInTicker = 0;
					currentBloodSplashes[i].fadeOutTicker = 0;
				}
			}
			return;
		}
	
		if (timedAutoWiperTics <= 0 && timedAutoWiperWasActive) {
			timedAutoWiperWasActive = false;
			for (int i = 0; i < bloodMaxCount; i++) {
				UV_BloodSplash bs = currentBloodSplashes[i];
				if (bs != null && bs.fadeOutTicker > 0) {
					StartScreenWiper();
					return;
				}
			}
		}
		if (timedAutoWiperTics > 0) {
			if (screenWiperMode == 1) {
				timedAutoWiperTics--;
			} else {
				timedAutoWiperTics = 0;
				timedAutoWiperWasActive = false;
			}
			
		}
		
		for (int i = 0; i < bloodMaxCount; i++) {
			UV_BloodSplash bs = currentBloodSplashes[i];
			if (bs == null) continue;
			bs.prevAlpha = bs.alpha;
			bs.prevSize = bs.size;
			bs.prevCoordinates = bs.coordinates;
			if (bs.fadeInTicker > 0) {
				bs.fadeInTicker--;
				double widthDecrease = bs.fullSize.x * double(bs.fadeInTicker) / BLOOD_FADE_IN_TICS;
				double heightDecrease = bs.fullSize.y * double(bs.fadeInTicker) / BLOOD_FADE_IN_TICS;
				bs.size.x = bs.fullSize.x - widthDecrease;
				bs.size.y = bs.fullSize.y - heightDecrease;
				bs.coordinates.x = bs.origCoords.x + widthDecrease / 2;
				bs.coordinates.y = bs.origCoords.y + heightDecrease / 2;
			} else if (bs.fadeOutTicker > 0 && bloodVanishes && bloodLifetime > 0) {
				bs.fadeOutTicker--;
				bs.Alpha = double(bs.fadeOutTicker) / double(bloodLifetime * 35);
			}
		}
	}
	
	void UpdateScreenWiperData() {
		if (showGlassPlayContext) {
			if (clipRatio >= 0.8 || clipRatio <= 0.2) {
				screenWiperAnimTicker--;
			} else {
				screenWiperAnimTicker -= 3;
			}
			clipRatio = double(screenWiperAnimTicker) / SCREEN_WIPER_TICKS;
			prevClipRatioInverted = clipRatioInverted;
			clipRatioInverted = 1 - clipRatio;
		} else {
			screenWiperAnimTicker = 0;
		}
		if (screenWiperAnimTicker == 0) {
			prevClipRatioInverted = 0;
			clipRatioInverted = 0;
			for (int i = 0; i < currentBloodSplashes.Size(); i++) {
				if (currentBloodSplashes[i]) {
					currentBloodSplashes[i].fadeOutTicker = 0;
				}
			}
		}
	}
	
	bool IsActorInLineOfSightAndNear(Actor actor) {
		// paramsForIsVisible are filled in OnRegister() and Worldtick()
		return actor.Distance3D(playerinf.mo) <= (bloodMaxInitDistance + playerinf.mo.Radius) 
				&& playerinf.mo.isVisible(actor, false, paramsForIsVisible);
	}
	
	double MapRange(double val, double fromLow, double fromHigh, double toLow, double toHigh) {
		return toLow + (val - fromLow) * (toHigh - toLow) / (fromHigh - fromLow);
	}
	
	Color GetRandomBloodColor() {
		int r, g, b;
		int rand = random(1, 6);
		if (rand == 1) { // green
			r = 0;
			g = 255;
			b = 0;
		} else if (rand == 2) { // blue
			r = 0;
			g = 0;
			b = 255;
		} else if (rand == 3) { // yellow
			r = 255;
			g = 230;
			b = 0;
		} else if (rand == 4) { // purple
			r = 255;
			g = 0;
			b = 255;
		} else if (rand == 5) { // light blue
			r = 0;
			g = 255;
			b = 255;
		} else { // orange
			r = 255;
			g = 130;
			b = 0;
		}
		return Color(255, r, g, b);
	}
	
	void StartScreenWiper() {
		if (screenWiperAnimTicker <= 0) {
			screenWiperAnimTicker = SCREEN_WIPER_TICKS;
			timedAutoWiperTics = 0;
			timedAutoWiperWasActive = false;
			if (screenWiperVolume > 0) {
				S_StartSound("uvisor_wiper", CHAN_AUTO, volume: screenWiperVolume);
			}
		}
	}
	
	void CheckAmmo() {
		ammoData = UV_AmmoReaderFactory.Get().GetAmmoData(playerinf, globals);
		if (ammoData.am1max > 0) {
			if (globals.isBD64_Loaded && ammoData.ammo1_ClassName && ammoData.ammo1_ClassName.IndexOf("AltPunch") != -1) {
				NotifyIfLowAmmo(0, 0, 1);
			} else {
				NotifyIfLowAmmo(ammoData.am1amt, ammoData.am1max, 1); // Regular case
			}
			mappedCurrentAmmo1 = MapRange(ammoData.am1amt, 0, ammoData.am1max, 0, 200);
		}
		
		if (ammoData.am2max > 0) {
			if (globals.isBD64_Loaded 
				&& ammoData.ammo1_ClassName && ammoData.ammo1_ClassName.IndexOf("Saw") != -1 
				&& ammoData.ammo2_ClassName && ammoData.ammo2_ClassName.IndexOf("SSG") != -1) {
				// Chainsaw alt in BD64 is supershotgun, don't notify if its barrels are empty
				NotifyIfLowAmmo(0, 0, 2);
			} else {
				NotifyIfLowAmmo(ammoData.am2amt, ammoData.am2max, 2); // Regular case
			}
			mappedCurrentAmmo2 = MapRange(ammoData.am2amt, 0, ammoData.am2max, 0, 200);
		} 
		
		if (ammoData.ammo1_ClassName && !ammoData.ammo2_ClassName) { 
			// Mod weapons often have two ammo types, for example ammo1 for total and ammo2 for current (mag)
			// But a weapon without mag (like chaingun) in this case will usually have only ammo1 type
			// So in such case if basis is ammo2, check ammo1 and vice versa
			if (!(globals.isBD64_Loaded && ammoData.ammo1_ClassName.IndexOf("AltPunch") != -1)) {
				NotifyIfLowAmmo(ammoData.am1amt, ammoData.am1max, 2);	// And notify about ammo1 (like chaingun) as if basis is ammo2 
			} else {
				NotifyIfLowAmmo(0, 0, 2);
			}
		} else if (ammoData.ammo2_ClassName && !ammoData.ammo1_ClassName) {
			NotifyIfLowAmmo(ammoData.am2amt, ammoData.am2max, 1);
		}
		
		if (!ammoData.ammo1_ClassName && !ammoData.ammo2_ClassName) {
			string wClass = ammoData.weaponClassName;
			if (wClass) {
				if (wClass.IndexOf("Ledge") != -1 || wClass.IndexOf("BladeWeapon") != -1 
						|| wClass.IndexOf("GloryFist") != -1)
						{
					return; // if these are found, do nothing 
				} else {
					// or if for example chainsaw with infinite ammo is selected, notify to disable both warning types
					NotifyIfLowAmmo(0, 0, 1);
					NotifyIfLowAmmo(0, 0, 2);
				}
			}
		}
	}
	
	void NotifyIfLowAmmo(int currentAmmo, int maxAmmo, int ammoType) {
		bool foundLowAmmo;
		if (maxAmmo > 0 && ((maxAmmo <= 200 && double(currentAmmo) / maxAmmo <= 0.095)
				|| (maxAmmo > 200 && double(currentAmmo) / maxAmmo <= 0.05)
				|| (maxAmmo <= 10 && maxAmmo >= 2 && currentAmmo < 2)
				|| (maxAmmo < 2 && currentAmmo < 1)
				)) {
			foundLowAmmo = true;
		}
		if (foundLowAmmo) {
			if (ammoType == 1) {
				if (!lowAmmo1Active) {
					lowAmmo1Active = true;
					lowAmmo1Ticker = 0;
				}
				else {
					lowAmmo1Ticker++;
					if (lowAmmo1Ticker == LOW_AMMO_NOTIFY_PAUSE_TICS) {
						lowAmmo1Ticker = 0;
						lowAmmo1Active = false;
						warningAmmo1Active = true;
					}
				}
			} else {
				if (!lowAmmo2Active) {
					lowAmmo2Active = true;
					lowAmmo2Ticker = 0;
				}
				else {
					lowAmmo2Ticker++;
					if (lowAmmo2Ticker == LOW_AMMO_NOTIFY_PAUSE_TICS) {
						lowAmmo2Ticker = 0;
						lowAmmo2Active = false;
						warningAmmo2Active = true;
					}
				}
			}
		}
		else {
			if (ammoType == 1) {
				lowAmmo1Ticker = 0;
				lowAmmo1Active = false;
				warningAmmo1Active = false;
			} else {
				lowAmmo2Ticker = 0;
				lowAmmo2Active = false;
				warningAmmo2Active = false;
			}
		}
	}
	
	void DoHelmetShaking() {
		if (ShakeIntensity > 0.01) { // ShakeIntensity is calculated in WorldThingDamaged override
			ShakeOffsetX = frandom(-ShakeIntensity, ShakeIntensity);
			ShakeOffsetY = frandom(-ShakeIntensity, ShakeIntensity);
	
			ShakeOffsetX *= scaleFactorWidthPlay;
			ShakeOffsetY *= scaleFactorHeightPlay;
			
			// Safety
			ShakeOffsetX = Clamp(ShakeOffsetX, -scaledMaxSwayX, scaledMaxSwayX);
			ShakeOffsetY = Clamp(ShakeOffsetY, -scaledMaxSwayY, scaledMaxSwayY);
			
			// Decrease shaking gradually (decay)
			ShakeIntensity *= 0.85;
		} else {
			ShakeIntensity = 0;
			ShakeOffsetX = 0;
			ShakeOffsetY = 0;
		}
	}
	
	void DoHelmetSwaying() {
		OldSwayOffX = SwayOffX;
		OldSwayOffY = SwayOffY;
		double rawSwayX = (playerinf.mo.angle - PrevAngle) * 0.6 * cameraSwayMultX;
		double rawSwayY = -(playerinf.mo.pitch - PrevPitch) * 0.8 * cameraSwayMultY;
		bool IsGrounded = playerinf.mo.pos.Z <= playerinf.mo.floorZ + 0.001;
		bool justJumped = wasGrounded && !IsGrounded;
		
		//// Movement offset ////
		if (MovementSway) {
			relVel = Actor.RotateVector(playerinf.mo.vel.xy, -playerinf.mo.angle);
			// Strafe contributes to horizontal sway
			rawSwayX += relVel.y * MovementSwayMultX;
			// Forward/back contributes to vertical sway
			rawSwayY += relVel.x * MovementSwayMultY;
			if (SwayBobMode == 0) {
				/// Simulated bob with controlled frequency
				double now = level.time / 35.0;
				double delta = now - lastBobTime;
				lastBobTime = now;
				slowBobTimer += delta;
				double period = 1 / SwayBobFreq; // cvar?
				double t = slowBobTimer - period * floor(slowBobTimer / period);
				t = t / period;
				// Triangle wave: 0 -> 1 -> 0 -> -1 -> 0
				double triangle;
				if (t < 0.25)
					triangle = t * 4;
				else if (t < 0.75)
					triangle = 1 - (t - 0.25) * 4;
				else
					triangle = 4 * t - 4;
				double amplitude = 0.8;
				
				// -amplitude .. +amplitude
				// Basically it's horizontal sway when moving forwards/backwards and vertical when moving left/right
				double baseBobSway = triangle * amplitude * 0.7;
				baseBobSway *= MovementSwayMultBob;

				// V‑shape: at baseBobSway 0: -0.8, at baseBobSway +-0.8: +0.8
				// Basically it's vertical sway (small) when moving forwards/backwards and horizontal (small) when moving left/right
				double crossBobSway = (2 * abs(baseBobSway) - amplitude) * 0.9;
				crossBobSway *= MovementSwayMultBob;
				
				rawSwayX += baseBobSway * relVel.x;
				rawSwayY += baseBobSway * relVel.y;

				rawSwayY += crossBobSway * relVel.x;
				rawSwayX += crossBobSway * relVel.y;
			} else { 
				/// Vanilla-like Bob Mode (or Helmeter-like)
				double BobAmount = playerinf.ViewZ - (playerinf.mo.pos.Z + playerinf.ViewHeight);
				if (globals.isPB_Loaded) {
					BobAmount *= 20; // Very crude, but I'm too tired to integrate actual PB bob. Without multpilier it would be very small
					if (!wasGrounded && IsGrounded && abs(PrevVelZ) > 1.0 && abs(PrevVelZ) < 7.0) {
						BobAmount = 0; // Prevent swaying on small ledge step
					}
				}
				BobAmount = clamp(BobAmount, -7, 7); // Prevent extreme values, especially in PB 
				BobAmount *= MovementSwayMultBob;
				rawSwayX += BobAmount * relVel.x;
				rawSwayY += BobAmount * relVel.y;
			}
		}
		
		if (JumpSway) {
			//// Jumping start offset ////
			if (justJumped && playerinf.mo.vel.z > 0) {
				mJumpOffset = 8.0 * JumpSwayIntensity;
			} else {
				mJumpOffset *= 0.85;
				if (abs(mJumpOffset) < 0.01) {
					mJumpOffset = 0;
				}
			}
			// Double jump detection, can't detect at the peak of first jump though without access to player input
			if (!IsGrounded) {
				if (PrevVelZ < -1 && playerinf.mo.vel.z > 5 && !wasDoubleJumpDetected) {
					double jumpIntensity = JumpSwayIntensity;
					mJumpOffset = 8.0 * jumpIntensity;   // or a different multiplier for double jumps
					wasDoubleJumpDetected = true;
				}
			} else {
				// Reset the flag when we land
				wasDoubleJumpDetected = false;
			}
			//// Falling from big heights offset (mid-air) ////
			if (!IsGrounded && playerinf.mo.vel.z < 0) {
				double targetFallingOffset = clamp(playerinf.mo.vel.z * 0.3, -4.0, 0.0);
				mFallingOffset = mFallingOffset * 0.9 + targetFallingOffset * 0.1;
			} else {
				mFallingOffset *= 0.85;
				if (abs(mFallingOffset) < 0.01) mFallingOffset = 0;
			}
			//// Landing offset ////
			// Landing detection (when you land, the collision system can push the hitbox slightly into the floor)
			if (!wasGrounded && IsGrounded) {
				double absPrevVelZ = abs(PrevVelZ); 
				if (absPrevVelZ > 7.0 || (globals.isBP_loaded && absPrevVelZ > 5.0)) {  
				// 7.0 - threshold to ignore falling from small steps
				// is BP PrevVelZ is less, so threshold is smaller
					double impact = min(abs(PrevVelZ) / 4.0, 8.0);
					mLandingOffset = impact * 30.0 * JumpSwayIntensity;
				} else {
					mLandingOffset = 0;
				}
			}
			// Decay landing offset while on ground
			if (IsGrounded) {
				mLandingOffset *= 0.75;
				if (abs(mLandingOffset) < 0.01) mLandingOffset = 0;
			}
		}
		
		//// Crouch sway ////
		// Impulse on start
		double crouchStartOffset = 0;
		double crouchfactor = playerinf.crouchfactor;
		if (CrouchSway) {
			double crouchChange = crouchfactor - PrevCrouchFactor;
			if (abs(crouchChange) > 0.001) {
				double bounceStrength = crouchChange * 60;   // scale
				bounceStrength = clamp(bounceStrength, -20.0, 20.0);
				crouchStartOffset = bounceStrength * CrouchSwayIntensity;
			}
		}
		// Static offset when fully crouched
		double crouchStaticOffset = 0;
		if (CrouchSway) {
			bool isCrouching = (crouchfactor < 0.55);
			crouchStaticOffset = isCrouching ? 5.0 * CrouchSwayIntensity : 0.0;
		}
		
		rawSwayY += mJumpOffset;
		rawSwayY += mFallingOffset;
		rawSwayY += mLandingOffset;
		rawSwayY += crouchStartOffset;
		rawSwayY += crouchStaticOffset;
		
		rawSwayX = clamp(rawSwayX, -MaxSwayX, MaxSwayX);
		rawSwayY = clamp(rawSwayY, -MaxSwayY, MaxSwayY);

		DynSwayX.Update(rawSwayX * 60.0);
		DynSwayY.Update(rawSwayY * 60.0);
		
		double smoothSwayX = DynSwayX.GetValue() / 60.0;
		double smoothSwayY = DynSwayY.GetValue() / 60.0;
		
		SwayOffX = ApplySwaySensitivity(smoothSwayX, MaxSwayX);
		SwayOffY = ApplySwaySensitivity(smoothSwayY, MaxSwayY);
		
		SwayOffX *= scaleFactorWidthPlay;
		SwayOffY *= scaleFactorHeightPlay;	
		
		// Safety measures
		SwayOffX = Clamp(SwayOffX, -scaledMaxSwayX, scaledMaxSwayX);
		SwayOffY = Clamp(SwayOffY, -scaledMaxSwayY, scaledMaxSwayY);
		if (helmetShaking) {
			double totalX = SwayOffX + ShakeOffsetX;
			double totalY = SwayOffY + ShakeOffsetY;
			if (abs(totalX) > scaledMaxSwayX) {
				// Reduce both sway and shake while keeping their ratio
				double scaleX = scaledMaxSwayX / abs(totalX);
				SwayOffX *= scaleX;
				ShakeOffsetX *= scaleX;
			}
			if (abs(totalY) > scaledMaxSwayY) {
				double scaleY = scaledMaxSwayY / abs(totalY);
				SwayOffY *= scaleY;
				ShakeOffsetY *= scaleY;
			}
		}
		 
		wasGrounded = IsGrounded;
		PrevVelZ = playerinf.mo.vel.Z;
		PrevAngle = playerinf.mo.angle;
		PrevPitch = playerinf.mo.pitch;
		PrevCrouchFactor = crouchfactor;
	}
	
	// Adjust sway using sensitivity cvar
	double ApplySwaySensitivity(double input, double maxVal) {
		double absInput = abs(input);
		double sign = input > 0 ? 1 : -1;
		
		if (absInput < maxVal * 0.3) {
			// Small movements: amplify more
			return sign * (absInput * (swaySensitivity + 1.0));
		}
		else {
			// Large movements: blend to normal
			double t = (absInput - maxVal * 0.3) / (maxVal * 0.7);
			double blend = (1 - t) * (swaySensitivity + 1.0) + t * 1.0;
			return sign * (absInput * blend);
		}
	}
	
	override void NetworkProcess(ConsoleEvent e)
    {
		// Hotkeys
        if (e.Name == "uvisor_EventEnableDisableMod") {
			CVar modEnabled = CVar.FindCVar("uvisor_mod_enabled");
			if (modEnabled != null) {
				modEnabled.SetBool(!modEnabled.GetBool());
			}
        } else if (e.Name == "uvisor_EventStartScreenWiper") {
			StartScreenWiper();
		
		// Menu was opened 
		} else if (e.Name == "Menu_Opened") {
			wasMenuOpened = true;
		} else if (e.Name == "UV_warning_ammo1_enable") {
			warningAmmo1Active = true;
		} else if (e.Name == "UV_warning_ammo1_disable") {
			warningAmmo1Active = false;
		} else if (e.Name == "UV_warning_ammo2_enable") {
			warningAmmo2Active = true;
		} else if (e.Name == "UV_warning_ammo2_disable") {
			warningAmmo2Active = false;
		}
    }
	
	void SetIsThirdPerson() {
		isThirdPerson = (playerinf && (playerinf.cheats & CF_CHASECAM)) // Vanilla chase cam
			|| (playerinf.camera && playerinf.camera.GetClassName() == "chaseCam2") // LiTDOOM
			|| (playerinf.camera && playerinf.camera.GetClassName() == "ThirdPersonCamera") // ChaseCam++
		;
	}
	
	void DoBreathingSound() {
		if (prevBreathSoundChannel != breathSoundChannel || prevBreathVolume != breathVolume) {
			playerinf.mo.A_StopSound(prevBreathSoundChannel);
		}
		if (breathVolume <= 0
			|| gamestate != GS_LEVEL // Prevent breath in main menu in some mods
			|| (breathDisableIfNoGlass && !showGlassPlayContext)
			|| (level.time < 1)
		) {
            return;
		}
		if (!playerinf.mo.IsActorPlayingSound(breathSoundChannel)) {
			int breathSpeed;
			string breathFileLetter = breathVoice > 0 ? "h" : "l";
			if (playerinf.health > 60) {
				breathSpeed = 1;
			} else if (playerinf.health > 30) {
				breathSpeed = 2;
			} else if (playerinf.health > 0) {
				breathSpeed = 3;
			}
			string breathSound = "uvisor_br_" .. breathFileLetter .. "_" .. breathSpeed;
			playerinf.mo.A_StartSound(breathSound, breathSoundChannel, volume: breathVolume, attenuation: ATTN_STATIC);
		}
	}
	
	void DoWarningSound() {
		if (prevWarningSoundChannel != warningSoundChannel) {
			playerinf.mo.A_StopSound(prevWarningSoundChannel);
		}
		if (warningVolume <= 0 || playerinf.mo.IsActorPlayingSound(warningSoundChannel) || playerinf.health <= 0 || (level.time < 1)) {
			return;
		} else if ((warningSoundBasis == 0 && playerinf.health < 30) 
				|| (warningSoundBasis == 1 && totalArmor < 30)
				|| ((warningSoundBasis == 2 && warningAmmo1Active) || (warningSoundBasis == 3 && warningAmmo2Active))) {
			playerinf.mo.A_StartSound("uvisor_warn", warningSoundChannel, volume: warningVolume, attenuation: ATTN_STATIC);
		}
	}
	
	void DoArmorDepletedSound() {
		if (armorDepletedVolume <= 0 && level.time < 1) {
			return;
		}
		S_StartSound("uvisor_shield_depleted", CHAN_AUTO, volume: armorDepletedVolume);
	}
}

class UV_BloodSplash {

	int fadeInTicker;
	int fadeOutTicker;
	int texIndex;
	Color bColor;
	double alpha;
	double prevAlpha;
	vector2 origCoords;
	vector2 coordinates;
	vector2 prevCoordinates;
	vector2 fullSize;
	vector2 size;
	vector2 prevSize;
}

class UV_AmmoData {
	
	string weaponClassName;
	string ammo1_ClassName;
	string ammo2_ClassName;
	int am1amt;
	int am2amt;
	int am1max;
	int am2max;
}
