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
	name lastColormappedPowerup;
	Color radsuitColor;
	bool isLastPowerupColomapped;
	bool isKnownColormapActive;
	bool applyColormapToGlow;
	bool blendColormap;
	Vector3 colormapMultRGB;
	Vector3 colormapAddRGB;
	Color combPlayerBlendAndPowerupBlendColor;
	double effectiveBlendAlpha;
	double prevCombinedBrightnessScale;
	double combinedBrightnessScale;
	Vector3 prevCombinedFullColorScale;
	Vector3 combinedFullColorScale;
	bool doingHelmetEquipAnim;
	int swayFlags;
	
	enum UV_MainTogglesFlags
	{
		UV_ShowPieces          = 1 << 0,
		UV_ShowGlow            = 1 << 1,
		UV_ShowGlass		   = 1 << 2,
		UV_ShowTacticalOverlay = 1 << 3,
		UV_ShowTacticalMarks   = 1 << 4,
		UV_ShowArmorGrid       = 1 << 5,
		UV_ShowGlassCracks     = 1 << 6,
		UV_ShowBloodSplashes   = 1 << 7,
		UV_StartupAnimEnabled  = 1 << 8
	}

	enum UV_SwayFlags
	{
		UV_LessIntenseGridSway 	= 1 << 0,
		UV_MovementSway			= 1 << 1,
		UV_CrouchSway			= 1 << 2,
		UV_JumpSway				= 1 << 3,
	}
	
	
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
	
	static const string armorGridShapeTypes[] = 
	{
		"Round_Small",			// 0
		"Round_Big",			// 1
		"Rectangular_Small",	// 2
		"Rectangular_Big",		// 3
		"Rectangular_Biggest"	// 4
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
		ARMOR_GRID,
		SCREEN_WIPER
	};
	
	enum UV_SeparateTogglesFlags
	{
		UV_ShowPartTop		= 1 << 0,
		UV_ShowGlowTop		= 1 << 1,
		UV_ShowGlassTop		= 1 << 2,
		UV_ShowPartBottom	= 1 << 3,
		UV_ShowGlowBottom	= 1 << 4,
		UV_ShowGlassBottom	= 1 << 5,
		UV_ShowGlassSides	= 1 << 6,
		UV_ShowPartCorners	= 1 << 7,
		UV_ShowGlowCorners	= 1 << 8,
		UV_ShowGlassCorners = 1 << 9
	}
	
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
	
	ui int separateTogglesFlags;
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
	ui bool isGL_EnhancedNV;
	
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
	ui double forwardOfsHelmet;
	ui double hudExpansionX;
	ui double hudExpansionY;
	ui double uiScaledMaxSwayX;
	ui double uiScaledMaxSwayY;
	
	
	///// PLAY CONTEXT VARS /////
	
	bool initialPlayInitDone;
	bool wasMenuOpened;
	double scaleFactorWidthPlay;
	double scaleFactorHeightPlay;
	int mainTogglesFlagsPlay;
	bool isGlassDestroyed;
	bool hideGlassIfEmptyArmorPlayContext;
	bool transparencyEffectWhenInvis;
	float dLightsContributionMult;
	int powerupColorsMode;
	double sectorBrightnessContributionMult;
	bool isDemonPlayer;
	name PB_NightVisionClass;
	name NVNightVisionInverseMapClass;
	name PB_HelmetAnimClass;
	name invulnerableClass;
	name nightVisionClass;
	name PB_SpeedPowerupClass;
	name PB_QuadDamagePowerupClass;
	Array<Color> powerupBlendColors;
	static const name isDemonPlayerFlags[] = {
		"isDemonPlayer", // using only this one isn't reliable cause it's not set if two nearby demon powerups picked up very quickly
		"powerTransformBaron",
		"powerTransformRevenant"
	};
	bool wasInVehicle;
	bool inVehicle;
	bool wasInMachineGun;
	bool inMachineGun;
	name heavyMachinegunClass;
	int machineGunEnterLeaveTicker;
	bool alreadyStoredDataInVehicle;
	int storedHealthInsideVehicle; // stored manually, not an inventory item from BD, etc.
	int storedArmorInsideVehicle; // same

	static const name vehicleInvNames[] = {
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
	
	static const name damageTypesNoBlood[] = { // for enemy actor based blood detection
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
	
	static const name bloodBaseTypes[] = {  // for blood actor based blood color detection
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
	
	static const name bdBloodSubtypes[] = {
		"Green_Blood",
		"Blue_Blood",
		"Alien Blood"
	};
	
	static const Color bdBloodSubtypesColors[] = {
		Color(255, 0, 100, 0),
		Color(255, 0, 0, 255),
		Color(255, 147, 112, 219)
	};
	
	static const name pmBloodSubtypes[] = {
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
	
	static const Color pmBloodSubtypesColors[] = {
		Color(0, 100, 0),
		Color(0, 100, 0),
		Color(0, 100, 0),
		Color(0, 0, 255),
		Color(160, 32, 240),
		Color(0, 0, 0),
		Color(0, 100, 0),
		Color(255, 127, 80),
		Color(0, 0, 0),
		Color(0, 0, 139)
	};
	
	static const name shakingDamageTypes[] = {
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
	
	static const name skippableWeaponsForAmmoData[] = {
		"LedgeGrab",
		"LedgeGrabWeapon",
		"BladeWeapon",
		"GloryFist"
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
	bool gridDamageFeedbackEnabled;
	
	const GRID_IDLE_CYCLE_TICKS = 245;
    const GRID_IDLE_FADE_TICKS = 35;
	int gridIdleTimer;
	int gridIdleNextTriggerTick;
	double prevGridIdleAlphaImage_1;
	double gridIdleAlphaImage_1;
	double prevGridIdleAlphaImage_2;
	double gridIdleAlphaImage_2;
	
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
	bool helmetSwayEnabled;
	double MaxSwayX; // Also used for shaking max X offset
	double MaxSwayY; // Also used for shaking max Y offset
	float swaySensitivity;
	float cameraSwayMultX;
	float cameraSwayMultY;
	double MovementSwayMultX;
	double MovementSwayMultY;
	double MovementSwayMultBob;
	int SwayBobMode;
	double SwayBobFreq;
	double CrouchSwayIntensity;
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
	UV_PersistentData pData;
	
	// Helmet shaking vars
	bool helmetShakeEnabled;
	double ShakeSensitivity;
	double ShakeOffsetX;
	double ShakeOffsetY;
	double ShakeIntensity;
	
	// Visor cracks (more data in UV_PersistentData)
	int cracksBasis;
	int prevCracksBasis;
	const CRACKS_MAX_PATTERN_ID = 6;
	int cracksHP_Offset;
	int cracksMaxLevel;
	bool initalCracksUpdateDone; // to prevent crack's sound at level start when small health/armor
	const CRACKS_FADE_TICKS = 5;
	int cracksFadeTicker;
	double prevF_InCracksAlpha;
	double f_InCracksAlpha;
	double prevF_OutCracksAlpha;
	double f_OutCracksAlpha;
	int fOutCracksTexId;
	bool hideFadingOutCracks;
		
	// Blood
	const BLOOD_FADE_IN_TICS = 5;
	const BLOOD_MAX_SPLASHES = 50;
	const BLOOD_MAX_TEXTURE_ID = 30;
	int TexResPlayContext;
	string CommonGraphicsPathPlayContext;
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
	name BD_BLOOD;
	name PM_BLOOD; // Project Malice
	name MD_BLOOD; // Mass Disassembly
	array<UV_BloodColorCacheEntry> enemyBasedBloodColorCache;
	array<UV_BloodColorCacheEntry> bloodBasedBloodColorCache;
	
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
	bool isSmartAmmoWarning;
	double warningVolume;
	int prevWarningSoundChannel;
	int warningSoundChannel;
	bool warningAmmo1Active;
	bool warningAmmo2Active;
	double cracksVolume;
	double hitVolume;
	double armorDepletedVolume;
	bool breathDisableIfNoGlass;
	double prevBreathVolume;
	double breathVolume;
	int prevBreathVoice;
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
	UV_AmmoReaderFactory ammoReaderFactory;
	bool shouldSkipWeaponData; // for ledge grabbing, etc.
	
	// Dynamic lights
	double dLightsBrightnessWeighted;
	Vector3 dLightsFullColorWeighted;
		
	
	
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
		
		if (doingHelmetEquipAnim)
			return;
		
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
			//// prevGametic is incremented in another block later
		}
		
		FracTicGlobal = e.FracTic;

		UpdateUiSwayVars();
		
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
			DrawArmorGridTexture(
				texArmorGrid, (0,0), (Screen.GetWidth(), Screen.GetHeight()), 0, colorArmorGrid, renderStyleArmorGrid
			);
			DrawArmorGridTexture(
				texArmorGridIdleAnim, (0,0), (Screen.GetWidth(), Screen.GetHeight()), 0, colorArmorGrid, renderStyleArmorGrid
			);
			DrawArmorGridTexture(
				texArmorGridDamage, (0,0), (Screen.GetWidth(), Screen.GetHeight()), 0, colorArmorGrid, renderStyleArmorGrid
			);
			DrawArmorGridTexture(
				texArmorGridDamageHeavy, (0,0), (Screen.GetWidth(), Screen.GetHeight()), 0, colorArmorGrid, renderStyleArmorGrid
			);
		}

		if ((mainTogglesFlagsPlay & UV_StartupAnimEnabled) && level.time <= STARTUP_BLACK_TICKS) {
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
				DrawFullScreenTexture(texTacticalOverlay_1, alphaTactical_1, 
					colorTacticalOverlay_1, expandX: hudExpansionX, expandY: hudExpansionY);
			}
			if (styleTacticalOverlay_2 != 0) {
				DrawFullScreenTexture(texTacticalOverlay_2, alphaTactical_2, 
					colorTacticalOverlay_2, expandX: hudExpansionX, expandY: hudExpansionY);
			}
		} else if (needsTextureWarmUp) {
			if (styleTacticalOverlay_1 != 0) {
				DrawFullScreenTexture(texTacticalOverlay_1, 0, colorTacticalOverlay_1);
			}
			if (styleTacticalOverlay_2 != 0) {
				DrawFullScreenTexture(texTacticalOverlay_2, 0, colorTacticalOverlay_2);
			}
		}
		
		if (showGlass && showGlassCracks) {
			DrawGlassCracks();
		} else if (needsTextureWarmup && pData.cracksLevel > 0) {
			TextureID newCracksTex = TexMan.CheckForTexture(
				cracksBasePath .. "Pattern_" .. pData.cracksTexturePatternId .. "/glass_cracks_" .. pData.fInCracksTexId .. ".png"
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
		
		int mainTogglesFlagsUI = Cvar.GetCvar("uvisor_main_toggles_flags", playerinf).GetInt();
		showPieces = mainTogglesFlagsUI & UV_ShowPieces;
		showGlow = mainTogglesFlagsUI & UV_ShowGlow;
		baseShowGlow = showGlow; // used to restore glow if it's hidden when no armor
		showGlass = mainTogglesFlagsUI & UV_ShowGlass;
		baseShowGlass = showGlass;
		showTacticalOverlay = mainTogglesFlagsUI & UV_ShowTacticalOverlay;
		baseShowTacticalOverlay = showTacticalOverlay;
		showTacticalMarks = mainTogglesFlagsUI & UV_ShowTacticalMarks;
		baseShowTacticalMarks = showTacticalMarks;
		showArmorGrid = mainTogglesFlagsUI & UV_ShowArmorGrid;
		showGlassCracks = mainTogglesFlagsUI & UV_ShowGlassCracks;
		showBloodSplashes = mainTogglesFlagsUI & UV_ShowBloodSplashes;
		
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
		
		separateTogglesFlags = Cvar.GetCvar("uvisor_separate_toggles_flags", playerinf).GetInt();
		autoHideCornersMode = Cvar.GetCvar("uvisor_auto_hide_corners_mode", playerinf).GetInt(); 
		autoHideCornersScreenSize = Cvar.GetCvar("uvisor_auto_hide_corners_screensize", playerinf).GetInt(); 

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
		isGL_EnhancedNV = Cvar.GetCvar("gl_enhanced_nightvision", playerinf).GetBool();
		
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
		String tacticalOverlay_1_Name = tacticalOverlayStyles[Clamp(styleTacticalOverlay_1, 0, tacticalOverlayStyles.Size() - 1)];
		String tacticalOverlay_2_Name = tacticalOverlayStyles[Clamp(styleTacticalOverlay_2, 0, tacticalOverlayStyles.Size() - 1)];
 		texTacticalOverlay_1 = TexMan
			.CheckForTexture(commonGraphicsPath .. "Tactical_Lines_Decals/Overlay_" .. tacticalOverlay_1_Name .. ".png");
		texTacticalOverlay_2 = TexMan
			.CheckForTexture(commonGraphicsPath .. "Tactical_Lines_Decals/Overlay_" .. tacticalOverlay_2_Name .. ".png");
		String armorGridTexturesPath = GetArmorGridTexturesPath();
		texArmorGrid = TexMan.CheckForTexture(armorGridTexturesPath .. "/armor_grid.png");
		texArmorGridIdleAnim = TexMan.CheckForTexture(armorGridTexturesPath .. "/armor_grid_idle_anim.png");
		texArmorGridDamage = TexMan.CheckForTexture(armorGridTexturesPath .. "/armor_grid_damage.png");
		texArmorGridDamageHeavy = TexMan.CheckForTexture(armorGridTexturesPath .. "/armor_grid_damage_heavy.png");
		
		String topStylePath = helmetGraphicsPath .. topStyles[Clamp(styleTop, 0, topStyles.Size() - 1)];
		String bottomStylePath = helmetGraphicsPath .. bottomStyles[Clamp(styleBottom, 0, bottomStyles.Size() - 1)];
		String cornersStylePath = helmetGraphicsPath .. cornerStyles[Clamp(styleCorners, 0, cornerStyles.Size() - 1)];
		String sideStylePath = helmetGraphicsPath .. sideGlassStyles[Clamp(styleSideGlass, 0, sideGlassStyles.Size() - 1)];
		
		texPartTop = TexMan.CheckForTexture(topStylePath .. "/Part_Top.png");
		texPartBottom = TexMan.CheckForTexture(bottomStylePath .. "/Part_Bottom.png");
		texPartCornerLeft = TexMan.CheckForTexture(cornersStylePath .. "/Part_Corner_Left.png");
		texPartCornerRight = TexMan.CheckForTexture(cornersStylePath .. "/Part_Corner_Right.png");
			
		texGlowTop = TexMan.CheckForTexture(topStylePath .. "/Glow_Top.png");
		texGlowBottom = TexMan.CheckForTexture(bottomStylePath .. "/Glow_Bottom.png");
		texGlowCornerLeft = TexMan.CheckForTexture(cornersStylePath .. "/Glow_Corner_Left.png");
		texGlowCornerRight = TexMan.CheckForTexture(cornersStylePath .. "/Glow_Corner_Right.png");
		
		texGlassTop = TexMan.CheckForTexture(topStylePath .. "/Glass_Top.png");
		texGlassBottom = TexMan.CheckForTexture(bottomStylePath .. "/Glass_Bottom.png");
		texGlassCornerLeft = TexMan.CheckForTexture(cornersStylePath .. "/Glass_Corner_Left.png");
		texGlassCornerRight = TexMan.CheckForTexture(cornersStylePath .. "/Glass_Corner_Right.png");
		texGlassSideLeft = TexMan.CheckForTexture(sideStylePath .. "/Glass_Side_Left.png");
		texGlassSideRight = TexMan.CheckForTexture(sideStylePath .. "/Glass_Side_Right.png");
		
		texScreenWiper = TexMan.CheckForTexture(commonGraphicsPath .. "screen_wiper.png");
	}
	
	ui String GetArmorGridTexturesPath() {
		int armorGridCellType = Cvar.GetCvar("uvisor_armor_grid_cell_type", playerinf).GetInt();
		int armorGridShapeType = Cvar.GetCvar("uvisor_armor_grid_shape_type", playerinf).GetInt();
		String cellPath = armorGridCellType == 0 ? "Cell_Big/" : "Cell_Small/";
		String shapePath = "Shape_" .. armorGridShapeTypes[Clamp(armorGridShapeType, 0, armorGridShapeTypes.Size() - 1)];
		return commonGraphicsPath .. "Armor_Grid/" .. cellPath .. shapePath;
	}
	
	ui void UpdateUiSwayVars() {
		UV_SwaySourceHolder reg = UV_SwaySourceHolder(StaticEventHandler.Find("UV_SwaySourceHolder"));
		UV_SwaySource src = reg ? reg.source : null;
		if (src && src.isEnabled) { // use swaying data from patch
			uiSwayOffX = InterpolateValue(src.swayOffsetOld.x, src.swayOffset.x, FracTicGlobal);
			uiSwayOffY = InterpolateValue(src.swayOffsetOld.y, src.swayOffset.y, FracTicGlobal);
			hudExpansionX = InterpolateValue(src.hudExpansionOld.x, src.hudExpansion.x, FracTicGlobal);
			hudExpansionY = InterpolateValue(src.hudExpansionOld.y, src.hudExpansion.y, FracTicGlobal);
			forwardOfsHelmet = InterpolateValue(src.forwardOfsOld, src.forwardOfs, FracTicGlobal);
			uiScaledMaxSwayX = src.marginX;
			uiScaledMaxSwayY = src.marginY;
		} else { // use default Mk III swaying (calculated in DoHelmetSwaying)
			uiSwayOffX = InterpolateValue(OldSwayOffX, SwayOffX, FracTicGlobal);
			uiSwayOffY = InterpolateValue(OldSwayOffY, SwayOffY, FracTicGlobal);
			hudExpansionX = 0;
			hudExpansionY = 0;
			uiScaledMaxSwayX = scaledMaxSwayX;
			uiScaledMaxSwayY = scaledMaxSwayY;
		}
		
		if (swayFlags & UV_LessIntenseGridSway) {
			uiSwayOffX_ArmorGrid = uiSwayOffX * 0.7; // to make it feel like an outer shell or something like that
			uiSwayOffY_ArmorGrid = uiSwayOffY * 0.7;
		} else {
			uiSwayOffX_ArmorGrid = uiSwayOffX;
			uiSwayOffY_ArmorGrid = uiSwayOffY;
		}
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
		Color texColor = BlendColorWithEnvironmentAndPowerups(colorArmorGrid, UV_HudVisorDraw.ARMOR_GRID);
		if (armorGridDamageAnimTicker > 0 && gridDamageFeedbackEnabled) {
			// Calc alpha ratio for usual grid (may be a combo of two idle textures) and damage grid 
			double usualGridAlphaInterpolated 
				= alphaArmorGrid * InterpolateValue(prevUsualArmorGridAlpha, usualArmorGridAlpha, FracTicGlobal);
			double damageGridAlphaInterpolated 
				= alphaArmorGrid * InterpolateValue(prevDamageArmorGridAlpha, damageArmorGridAlpha, FracTicGlobal);
			gridImage_1_AlphaInter *= usualGridAlphaInterpolated;
			gridImage_2_AlphaInter *= usualGridAlphaInterpolated;
			// Draw damage grid
			TextureID finalGridDamageTexture = armorGridHeavyDamageTicker > 0 ? texArmorGridDamageHeavy : texArmorGridDamage;
			DrawArmorGridTexture(finalGridDamageTexture, (x,y), (w,h), damageGridAlphaInterpolated,
				texColor, renderStyleArmorGrid); // if damage ticker is active, calc alpha ratio of two idle grid textures (as one) AND damage texture
		}
		// Draw idle grid (two textures if anim enabled)
		DrawArmorGridTexture(texArmorGrid, (x,y), (w,h), 
			gridImage_1_AlphaInter, texColor, renderStyleArmorGrid);
		if (gridIdleAnimEnabled) {
			DrawArmorGridTexture(texArmorGridIdleAnim, (x,y), (w,h), gridImage_2_AlphaInter, 
				texColor, renderStyleArmorGrid);
		}
	}
	
	ui void DrawGlass() {
		Color texColor = BlendColorWithEnvironmentAndPowerups(colorGlass, UV_HudVisorDraw.GLASS);
		double texAlpha = alphaGlass;
		double texAlphaBottom = overrideAlphaBottom ? alphaGlassBottom : alphaGlass;
		if (separateTogglesFlags & UV_ShowGlassSides && styleSideGlass != 0) {
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
		if (separateTogglesFlags & UV_ShowGlassTop && styleTop != 0) {
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLASS,
				texGlassTop,
				UV_HudVisorDraw.TOP_MIDDLE,
				texColor,
				offsetY: offsetTop,
				alphaOverride: texAlpha
			);
		}
		if (separateTogglesFlags & UV_ShowGlassBottom && styleBottom != 0) {
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
		bool showGlassCornersFinal = separateTogglesFlags & UV_ShowGlassCorners && styleCorners != 0
			&& !(autoHideCornersMode == 2 && autoHideCornersScreenSize == screenSize);
		if (showGlassCornersFinal) {
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
		Color texColor = BlendColorWithEnvironmentAndPowerups(colorGlow, UV_HudVisorDraw.GLOW);
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
		if (separateTogglesFlags & UV_ShowGlowTop && styleTop != 9 && styleTop != 0) { // if not Plain_Glass or None
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.GLOW,
				texGlowTop, 
				UV_HudVisorDraw.TOP_MIDDLE, 
				texColor,
				offsetY: offsetTop,
				alphaOverride: texAlpha
			);
		}
		if (separateTogglesFlags & UV_ShowGlowBottom && styleBottom != 7  && styleBottom != 0) { // if not Plain_Glass or None
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
		bool showGlowCornersFinal = (separateTogglesFlags & UV_ShowGlowCorners) && styleCorners != 0
			&& !(autoHideCornersMode > 0 && autoHideCornersScreenSize == screenSize);
		if (showGlowCornersFinal) {
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
		Color texColorTop = BlendColorWithEnvironmentAndPowerups(colorPartTop, UV_HudVisorDraw.PART_TOP);
// 		console.printf("  texColorTop: " .. texColorTop);
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
		if (separateTogglesFlags & UV_ShowPartTop && styleTop != 9 && styleTop != 0) { // if not Plain_Glass or None
			DrawHelmetTextureCustom(
				UV_HudVisorDraw.PART_TOP,
				texPartTop, 
				UV_HudVisorDraw.TOP_MIDDLE,
				texColorTop,
				offsetY: offsetTop
			);
		}
		if (separateTogglesFlags & UV_ShowPartBottom && styleBottom != 7 && styleBottom != 0) { // if not Plain_Glass or None
			Color texColorBottom = BlendColorWithEnvironmentAndPowerups(colorPartBottom, UV_HudVisorDraw.PART_BOTTOM);
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
		if (separateTogglesFlags & UV_ShowPartCorners && styleCorners != 0) {
			Color texColorCorners = BlendColorWithEnvironmentAndPowerups(colorPartCorners, UV_HudVisorDraw.PART_CORNER);
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

		// adjust size and offsets to draw texture a bit outside of screen edges 
		// so that more cracks "start" from visor edges for a bit more realism and to compensate the random rotation
		double sizeMult = styleTop == 5 ? 0.95 : 1.1; // smaller size and coords for Space Marine helmet
		double offsetX = Screen.GetWidth() * (1 - sizeMult) / 2;
		double offsetY = Screen.GetHeight() * (1 - sizeMult) / 2;
		if (cracksFadeTicker > 0) {
			TextureID oldCracksTex = TexMan.CheckForTexture(
				cracksBasePath .. "Pattern_" .. pData.cracksTexturePatternId .. "/glass_cracks_" .. fOutCracksTexId .. ".png"
			);
			double f_OutCracksAlphaInter = alphaCracks * InterpolateValue(prevF_OutCracksAlpha, f_OutCracksAlpha, FracTicGlobal);
			DrawFullScreenTexture(oldCracksTex, f_OutCracksAlphaInter, colorGlassCracks, 
				sizeMult: sizeMult, offsetX: offsetX, offsetY: offsetY, degree: pData.cracksTextureRotationDegrees
			);
			f_InCracksAlphaInter *= InterpolateValue(prevF_InCracksAlpha, f_InCracksAlpha, FracTicGlobal);
		}
		if (pData.cracksLevel > 0) {
			TextureID newCracksTex = TexMan.CheckForTexture(
				cracksBasePath .. "Pattern_" .. pData.cracksTexturePatternId .. "/glass_cracks_" .. pData.fInCracksTexId .. ".png"
			);
			DrawFullScreenTexture(newCracksTex, f_InCracksAlphaInter, colorGlassCracks, 
				sizeMult: sizeMult, offsetX: offsetX, offsetY: offsetY, degree: pData.cracksTextureRotationDegrees
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
		x += uiSwayOffX + ShakeOffsetX;
		Color wiperColor = FULL_WHITE_COLOR;
		wiperColor = BlendColorWithEnvironmentAndPowerups(wiperColor, UV_HudVisorDraw.SCREEN_WIPER);
		Screen.DrawTexture(
			texScreenWiper, false,
			x,
			uiSwayOffY + ShakeOffsetY,
			DTA_DestWidthF, w,
			DTA_DestHeightF, h,
			DTA_Color, wiperColor
		);
		Screen.SetClipRect(0, 0, max(x + w/3, 0), Screen.GetHeight());
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
			Color texColor = BlendColorWithEnvironmentAndPowerups(bs.bColor);			

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
		double diffSwayTex = Screen.GetWidth() + uiScaledMaxSwayX * 2 - texWidth;
		if ((helmetSwayEnabled || helmetShakeEnabled)
				&& diffSwayTex <= uiScaledMaxSwayX * 2 // if scaled texture width equals screenwidth or is a bit bigger (but not bigger than uiScaledMaxSwayX * 2)
				&& diffSwayTex > 0 // and if not already big enough
				&& (anchor == UV_HudVisorDraw.TOP_MIDDLE || anchor == UV_HudVisorDraw.BOTTOM_MIDDLE)) {
			texWidth += diffSwayTex; // increase its width to get extra space for swaying
		}
		double texHeight = ceil(origHeight * scaleFactorHeight);
		texHeight *= optionalHeightScale;
		diffSwayTex = Screen.GetHeight() + uiScaledMaxSwayY * 2 - texHeight;
		if ((helmetSwayEnabled || helmetShakeEnabled) 
				&& diffSwayTex <= uiScaledMaxSwayY * 2
				&& diffSwayTex > 0
				&& (anchor == UV_HudVisorDraw.MIDDLE_LEFT || anchor == UV_HudVisorDraw.MIDDLE_RIGHT)) {
			texHeight += uiScaledMaxSwayY * 2;
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
		
		double anchorOfsX = 0, anchorOfsY = 0;
		double ofs = forwardOfsHelmet;
		if (ofs != 0) {
			switch(anchor) {
				case UV_HudVisorDraw.TOP_LEFT:      anchorOfsX =  ofs; anchorOfsY =  ofs; break;
				case UV_HudVisorDraw.TOP_MIDDLE:    anchorOfsX =  0;   anchorOfsY =  ofs; break;
				case UV_HudVisorDraw.TOP_RIGHT:     anchorOfsX = -ofs; anchorOfsY =  ofs; break;
				case UV_HudVisorDraw.MIDDLE_LEFT:   anchorOfsX =  ofs; anchorOfsY =  0;   break;
				case UV_HudVisorDraw.MIDDLE_RIGHT:  anchorOfsX = -ofs; anchorOfsY =  0;   break;
				case UV_HudVisorDraw.BOTTOM_LEFT:   anchorOfsX =  ofs; anchorOfsY = -ofs; break;
				case UV_HudVisorDraw.BOTTOM_MIDDLE: anchorOfsX =  0;   anchorOfsY = -ofs; break;
				case UV_HudVisorDraw.BOTTOM_RIGHT:  anchorOfsX = -ofs; anchorOfsY = -ofs; break;
			}
		}
		
		Screen.DrawTexture(
			texture, false,
			x + uiSwayOffX + anchorOfsX + ShakeOffsetX, // already scaled
			y + uiSwayOffY + anchorOfsY + ShakeOffsetY,
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
				if (helmetSwayEnabled || helmetShakeEnabled) {
					x -= uiScaledMaxSwayX;
				}
				y = 0 - offsetY;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					y -= uiScaledMaxSwayY;
				}
				break;
			case TOP_MIDDLE:
				x = Screen.GetWidth() / 2.0 - texWidth / 2.0;
				y = 0 - offsetY;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					y -= uiScaledMaxSwayY;
				}
				break;
			case TOP_RIGHT:
				x = Screen.GetWidth() - texWidth + offsetX;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					x += uiScaledMaxSwayX;
				}
				y = 0 - offsetY;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					y -= uiScaledMaxSwayY;
				}
				break;
			case MIDDLE_LEFT:
				x = 0 - offsetX;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					x -= uiScaledMaxSwayX;
				}
				y = Screen.GetHeight() / 2.0 - texHeight / 2.0;
				break;
			case MIDDLE_RIGHT:
				x = Screen.GetWidth() - texWidth + offsetX;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					x += uiScaledMaxSwayX;
				}
				y = Screen.GetHeight() / 2.0 - texHeight / 2.0;
				break;
			case BOTTOM_LEFT:
				x = 0 - offsetX;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					x -= uiScaledMaxSwayX;
				}
				y = Screen.GetHeight() - texHeight + offsetY;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					y += uiScaledMaxSwayY;
				}
				break;
			case BOTTOM_MIDDLE:
				x = Screen.GetWidth() / 2.0 - texWidth / 2.0;
				y = Screen.GetHeight() - texHeight + offsetY;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					y += uiScaledMaxSwayY;
				}
				break;
			case BOTTOM_RIGHT:
				x = Screen.GetWidth() - texWidth + offsetX;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					x += uiScaledMaxSwayX;
				}
				y = Screen.GetHeight() - texHeight + offsetY;
				if (helmetSwayEnabled || helmetShakeEnabled) {
					y += uiScaledMaxSwayY;
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
									double degree = 0,
									double expandX = 0, double expandY = 0) {
		if (invisEffectOn) {
			[texAlpha, texRenderStyle] = GetPartialInvisibilityDrawParams(texAlpha);
		}
		if (ShouldUseStencilStyle()) {
			texRenderStyle = Style_TranslucentStencil;
		}
		texColor = BlendColorWithEnvironmentAndPowerups(texColor);
		Screen.DrawTexture(
			texture, false, 
			offsetX - expandX + uiSwayOffX + ShakeOffsetX - uiScaledMaxSwayX, // move texture (and increase size in DestWidth/DestHeight) not to draw beyond its edges
			offsetY - expandY + uiSwayOffY + ShakeOffsetY - uiScaledMaxSwayY,
			DTA_DestWidthF, (Screen.GetWidth() + expandX * 2 + uiScaledMaxSwayX * 2) * sizeMult, 
			DTA_DestHeightF, (Screen.GetHeight() + expandY * 2 + uiScaledMaxSwayY * 2) * sizeMult, 
			DTA_Alpha, 	texAlpha,
			DTA_Color, texColor,
			DTA_LegacyRenderStyle, texRenderStyle,
			DTA_Rotate, degree
		);
	}
	
	ui void DrawArmorGridTexture(TextureID texture, vector2 coords, vector2 size, 
									double texAlpha, Color texColor, int texRenderStyle) {
		if (invisEffectOn) {
			[texAlpha, texRenderStyle] = GetPartialInvisibilityDrawParams(texAlpha, UV_HudVisorDraw.ARMOR_GRID);
		}
		if (ShouldUseStencilStyle(UV_HudVisorDraw.ARMOR_GRID)) {
			texRenderStyle = Style_TranslucentStencil;
		}

		double newX = coords.x - hudExpansionX;
		double newY = coords.y - hudExpansionY;
		double newW = size.x + hudExpansionX * 2;
		double newH = size.y + hudExpansionY * 2;

		Screen.DrawTexture(
			texture, false, 
			newX + uiSwayOffX_ArmorGrid + ShakeOffsetX - uiScaledMaxSwayX,
			newY + uiSwayOffY_ArmorGrid + ShakeOffsetY - uiScaledMaxSwayY,
			DTA_DestWidthF,  newW + uiScaledMaxSwayX * 2, 
			DTA_DestHeightF, newH + uiScaledMaxSwayY * 2, 
			DTA_Alpha, texAlpha,
			DTA_Color, texColor,
			DTA_LegacyRenderStyle, texRenderStyle
		);
	}
	
	ui bool ShouldUseStencilStyle(UV_TextureTypes texType = -1) {
		return (isVanillaInvulernabilityOn && powerupColorsMode == 0)
			|| 
			(NV_PackInverseMapOn 
				&& !isLastPowerupColomapped 
				&& (texType == -1 || texType == UV_HudVisorDraw.ARMOR_GRID || texType == UV_HudVisorDraw.SCREEN_WIPER) // grid, blood, wiper
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
	
	ui Color BlendColorWithEnvironmentAndPowerups(Color originalColor, UV_TextureTypes texType = -1) {
		Color newColor = Color(255, originalColor.r, originalColor.g, originalColor.b); // might be without 255 at this point which is required here
		if (powerupColorsMode == 2) { // if powerup colors disabled
			return BlendColorWithEnvironment(newColor, texType);
		}
		bool isAffectedByEnvironment = true;
		
		if (ShouldUseStencilStyle(texType) && powerupColorsMode == 0) {
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
				// Light Amplification mode (vanilla / NV Pack DEFAULT-only mode / other mods with bright light amp)
				// Special color is set using UpdateColormappedPowerupState() and BlendColorWithColormappedPowerup()
				newColor = BrightenColor(originalColor, 1.1);
			}
			isAffectedByEnvironment = false;
		}
		
		if (lastColormappedPowerup) { // last name of a powerup with Powerup.Colormap (false if empty string, i.e. no such powerup)
			newColor = BlendColorWithColormappedPowerup(newColor, texType);
			isAffectedByEnvironment = false;
		}
		if (combPlayerBlendAndPowerupBlendColor && effectiveBlendAlpha) { // if Powerup.Color or A_SetBlend()
			newColor = BlendColors(newColor, combPlayerBlendAndPowerupBlendColor, effectiveBlendAlpha);
		}
		if (radsuitOn && radsuitColor && 
			(texType == -1 || texType == UV_HudVisorDraw.ARMOR_GRID || texType == UV_HudVisorDraw.SCREEN_WIPER)) {
			// only blood, armor grid, screen wiper
			newColor = BlendColors(newColor, radsuitColor, double(radsuitColor.a) / 255);
		}
		
		if (!isAffectedByEnvironment) {
			return newColor;
		}

		return BlendColorWithEnvironment(newColor, texType);
	}
	
	ui Color BlendColorWithColormappedPowerup(Color originalColor, UV_TextureTypes texType = -1) {
		if (!isKnownColormapActive
			|| texType == UV_HudVisorDraw.GLOW && !applyColormapToGlow) {
			return originalColor;
		}
		int grayscale = CalculateGrayscaleAmount(originalColor);
		int r = Clamp(int(grayscale * colormapMultRGB.X + colormapAddRGB.X), 0, 255);
		int g = Clamp(int(grayscale * colormapMultRGB.Y + colormapAddRGB.Y), 0, 255);
		int b = Clamp(int(grayscale * colormapMultRGB.Z + colormapAddRGB.Z), 0, 255);
		Color newColor = Color(255, r, g, b);
		// Simulate light reflection for helmet parts except armor grid and wiper (we don't get to this line with glow)
		if (blendColormap && texType > -1
				&& texType != UV_HudVisorDraw.ARMOR_GRID
				&& texType != UV_HudVisorDraw.SCREEN_WIPER) {
			newColor = BlendColors(originalColor, newColor, 0.2);
		}
		return newColor;
	}
	
	ui Color BlendColorWithEnvironment(Color originalColor, UV_TextureTypes texType = -1) {
		double overallEnvInfluence = 1.0;
		if (texType == UV_HudVisorDraw.GLOW || texType == UV_HudVisorDraw.SCREEN_WIPER) {
			overallEnvInfluence = 0.35;
		} else if (texType == UV_HudVisorDraw.ARMOR_GRID) {
			overallEnvInfluence = 0.5;
		} else if (texType > -1) {  // Reduce for helmet pieces and glass too, but not so much
			overallEnvInfluence = 0.85;
		}
		// Dynamic lights (already  calculated in play context)
		double dynScaleR, dynScaleG, dynScaleB;
		if (texType == UV_HudVisorDraw.GLOW || texType == UV_HudVisorDraw.ARMOR_GRID || texType == UV_HudVisorDraw.SCREEN_WIPER) {
			// Only brightness change
			double interBrightnessScale = InterpolateValue(prevCombinedBrightnessScale, combinedBrightnessScale, FracTicGlobal);
			dynScaleR = dynScaleG = dynScaleB = ApplyInfluence(interBrightnessScale, overallEnvInfluence);
		} else {
			// Full color path
			Vector3 interFullColorScale = (
				InterpolateValue(prevCombinedFullColorScale.X, combinedFullColorScale.X, FracTicGlobal),
				InterpolateValue(prevCombinedFullColorScale.Y, combinedFullColorScale.Y, FracTicGlobal),
				InterpolateValue(prevCombinedFullColorScale.Z, combinedFullColorScale.Z, FracTicGlobal)
			);
			double colR = interFullColorScale.X;
			double colG = interFullColorScale.Y;
			double colB = interFullColorScale.Z;
			double rawBrightness = (colR + colG + colB) / 3.0;
			double softenedBrightness = ApplyInfluence(rawBrightness, overallEnvInfluence);
			double colorInfluence = 0.6; // 0.6 seems to be a good balance
			dynScaleR = softenedBrightness + (colR - rawBrightness) * colorInfluence;
			dynScaleG = softenedBrightness + (colG - rawBrightness) * colorInfluence;
			dynScaleB = softenedBrightness + (colB - rawBrightness) * colorInfluence;
		}
		int r = int(originalColor.r * dynScaleR);
		int g = int(originalColor.g * dynScaleG);
		int b = int(originalColor.b * dynScaleB);
		return Color(255, r, g, b);
	}

	// Pulls a value toward neutral 1.0 by influence (1 = full effect, 0 = no change)
	// Simple multiplying would darken low-influence elements instead of leaving them neutral in our case
	ui double ApplyInfluence(double value, double influence) {
		return 1.0 + (value - 1.0) * influence;
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
			if (ammoData.weaponClassName) {
				if (shouldSkipWeaponData) {
					return; // keep color of previous weapon
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
		heavyMachinegunClass = "PowerHeavyMachinegunSwitch";
		PB_NightVisionClass = "PB_PowerLightAmp";
		NVNightVisionInverseMapClass = "NVNightVisionInverseMap";
		PB_HelmetAnimClass = "DoingHelmetAnim";
		PB_SpeedPowerupClass = "PB_PowerSpeed";
		PB_QuadDamagePowerupClass = "PB_PowerDoomDamage";
		startupTicker = STARTUP_TICKS;
		paramsForIsVisible.minDist = 1; // prevent false positives (for our case), which apparently happen when minDist is 0
		globals = UV_HudVisorStaticGlobals.Get();
		if (!ammoReaderFactory) {
            ammoReaderFactory = new("UV_AmmoReaderFactory");
            ammoReaderFactory.readerClassName = "UV_AmmoReader";
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
		
		if (!pData) {
			pData = globals.pData;
		}
		
		if (initialPlayInitDone) { // prevent double call on first tick where we have to call it after InitPlayVars()
			UpdateLightState(playerinf.mo.pos, playerinf.mo.Angle, playerinf.mo.Pitch);
		}
		
		if (wasMenuOpened || globals.isSavegameJustLoaded || !initialPlayInitDone) {
			globals.isSavegameJustLoaded = false;
			wasMenuOpened = false;
			InitPlayVars();
			UpdateLightState(playerinf.mo.pos, playerinf.mo.Angle, playerinf.mo.Pitch);
			prevCombinedBrightnessScale = combinedBrightnessScale;
			prevCombinedFullColorScale = combinedFullColorScale;
			initialPlayInitDone = true;
		}
		
		CheckPowersAndVehicles();
		
		if (doingHelmetEquipAnim) {
			return;
		}
		
		if ((mainTogglesFlagsPlay & UV_StartupAnimEnabled) && startupVolume > 0 && level.time == STARTUP_BLACK_SOLID_TICKS - 8) {
			S_StartSound("uvisor_startup", CHAN_AUTO, volume: startupVolume);
		}
		
		UpdateColormappedPowerupState();
		SetPlayerBlendColorAndAlpha();
		
		SetStoredHealthArmor();
		
		if (mainTogglesFlagsPlay & UV_ShowBloodSplashes) {
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
			isGlassDestroyed = true;
		} else {
			isGlassDestroyed = false;
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
		prevBreathVolume = breathVolume;
		prevBreathVoice = breathVoice;
		
		if (helmetShakeEnabled) {
			DoHelmetShaking();
		} else {
			ShakeIntensity = 0;
			ShakeOffsetX = 0;
			ShakeOffsetY = 0;
		}
		
		if (helmetSwayEnabled) {
			DoHelmetSwaying();
		} else {
			SwayOffX = 0;
			SwayOffY = 0;
			OldSwayOffX = 0;
			OldSwayOffY = 0;
		}
		
		if (pData.cracksLevel > pData.prevCracksLevel && (mainTogglesFlagsPlay & UV_ShowGlassCracks)
				&& cracksVolume > 0 && initalCracksUpdateDone && (prevCracksBasis == cracksBasis)) {
			if (pData.cracksLevel == 5) {
				if (! (cracksBasis == 1 && !hideGlassIfEmptyArmorPlayContext) ) {
					S_StartSound("uvisor_glass_2", CHAN_AUTO, volume: cracksVolume);
				}
			} else {
				string glassSoundName = "uvisor_glass_1_" .. random[UV_VeryRandomIdentifierrr](1, 3);
				S_StartSound(glassSoundName, CHAN_AUTO, volume: cracksVolume);
			}			
		}
		prevCracksBasis = cracksBasis;
		initalCracksUpdateDone = true;
		
		wasInVehicle = inVehicle;
		wasInMachineGun = inMachineGun;
		wasArmorGridShown = isArmorGridShownVar;
		
		if (pulseActive) {
			pulseTime += pulseSpeed * 2; // Needed for color calculation when drawing texture, bigger value for faster pulse
		}
		
		CheckAmmo();

		if (startupTicker > 0) {
			startupTicker--;
		}
	}
	
	void InitPlayVars() {
		mainTogglesFlagsPlay = Cvar.GetCvar("uvisor_main_toggles_flags", playerinf).GetInt();
		helmetSwayEnabled = Cvar.GetCvar("uvisor_swaying", playerinf).GetBool();
		swayFlags = Cvar.GetCvar("uvisor_swaying_flags", playerinf).GetInt();
		MaxSwayX = Clamp(Cvar.GetCVar("uvisor_maxsway_x", playerinf).GetFloat(), 0, 15);
		MaxSwayY = Clamp(Cvar.GetCVar("uvisor_maxsway_y", playerinf).GetFloat(), 0, 15);
		swaySensitivity = Cvar.GetCVar("uvisor_sway_sensitivity", playerinf).GetFloat();
		cameraSwayMultX = Cvar.GetCVar("uvisor_camera_sway_mult_x", playerinf).GetFloat();
		cameraSwayMultY = Cvar.GetCVar("uvisor_camera_sway_mult_y", playerinf).GetFloat();
		MovementSwayMultX = Cvar.GetCVar("uvisor_movement_sway_mult_x", playerinf).GetFloat();
		MovementSwayMultY = Cvar.GetCVar("uvisor_movement_sway_mult_y", playerinf).GetFloat();
		MovementSwayMultBob = Cvar.GetCVar("uvisor_movement_sway_mult_bob", playerinf).GetFloat();
		SwayBobMode = Cvar.GetCVar("uvisor_bob_sway_mode", playerinf).GetInt();
		SwayBobFreq = Cvar.GetCVar("uvisor_bob_sway_freq", playerinf).GetFloat();
		CrouchSwayIntensity = Cvar.GetCVar("uvisor_crouch_sway_intensity", playerinf).GetFloat();
		JumpSwayIntensity = Cvar.GetCVar("uvisor_jump_sway_intensity", playerinf).GetFloat();
		helmetShakeEnabled = Cvar.GetCvar("uvisor_shaking", playerinf).GetBool();
		ShakeSensitivity = Cvar.GetCVar("uvisor_shaking_sensitivity", playerinf).GetFloat();
		scaleFactorWidthPlay = double(Screen.GetWidth()) / BASE_SCREEN_WIDTH;
		scaleFactorHeightPlay = double(Screen.GetHeight()) / BASE_SCREEN_HEIGHT;
		if (helmetSwayEnabled || helmetShakeEnabled) {
			scaledMaxSwayX = MaxSwayX * scaleFactorWidthPlay;
			scaledMaxSwayY = MaxSwayY * scaleFactorHeightPlay;
		} else {
			MaxSwayX = 0;
			MaxSwayY = 0;
			scaledMaxSwayX = 0;
			scaledMaxSwayY = 0;
		}
		
		cracksBasis = Cvar.GetCvar("uvisor_cracks_basis", playerinf).GetInt();
		cracksHP_Offset = Cvar.GetCvar("uvisor_cracks_health_offset", playerinf).GetInt();
		cracksMaxLevel = Cvar.GetCvar("uvisor_cracks_max_level", playerinf).GetInt();
		
		pulseMode = Cvar.GetCvar("uvisor_glow_pulse_mode", playerinf).GetInt();
		pulseSpeed = Cvar.GetCvar("uvisor_glow_pulse_speed", playerinf).GetFloat();
		
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
		
		warningSoundBasis = Cvar.GetCvar("uvisor_warning_sound_mode", playerinf).GetInt();
		isSmartAmmoWarning = Cvar.GetCvar("uvisor_warning_ammo_smart", playerinf).GetBool();
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
		
		gridIdleAnimEnabled = Cvar.GetCvar("uvisor_grid_idle_anim_enabled", playerinf).GetBool();
		armorGridDisplayModePlay = Cvar.GetCvar("uvisor_armor_grid_display_mode", playerinf).GetInt();
		armorGridDisableWhenOtherOverlay = Cvar.GetCVar("uvisor_grid_disable_when_radsuit_nightvis", playerinf).GetBool();
		gridDamageFeedbackEnabled = Cvar.GetCVar("uvisor_grid_damage_feedback", playerinf).GetBool();
		
		sectorBrightnessContributionMult = Cvar.GetCvar("uvisor_sector_br_contrib_mult", playerinf).GetFloat();
		dLightsContributionMult = Cvar.GetCvar("uvisor_d_lights_contrib_mult", playerinf).GetFloat();
		transparencyEffectWhenInvis = Cvar.GetCVar("uvisor_transparency_on_invis", playerinf).GetBool();
		powerupColorsMode = Cvar.GetCvar("uvisor_powerup_colors_mode", playerinf).GetInt();
		
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
				if (machineGunEnterLeaveTicker > 0)
					return; // prevent extreme shaking when entering or leaving machine gun due to health change
				ShakeIntensity = clamp(ShakeIntensity + totalDamage * ShakeSensitivity, 0.0, 24.0);
			}
		} else if ((mainTogglesFlagsPlay & UV_ShowBloodSplashes) && bloodDetectionMode == 0 && e.Thing.bIsMonster) {
			if (!IsActorInLineOfSightAndNear(e.thing)) return;
			if (isGlassDestroyed) return;
			if (inVehicle) return;
			string enemyClassName = e.thing.GetClassName();
			name enemyClassNameN = enemyClassName;
			if (e.thing.bloodColor == UNSET_COLOR && (e.thing.bNOBLOOD || e.thing.bNOBLOODDECALS)) {
				if (!(globals.isDD_Loaded && enemyClassName.IndexOf("CYBORG") != -1) // Don't return if BD64 (except Lost Souls) or some enemies in DD
					&& !(globals.isDD_Loaded && enemyClassNameN == 'HunterKiller')
					&& !(globals.isBD64_Loaded && !(e.thing is 'LostSoul'))
				) {
					return;
				}
			} else if (globals.isXimSW_Loaded && e.thing.bNOBLOOD) {
				return;
			}
			name eDamageType = e.DamageType;
			for (int i = 0; i < damageTypesNoBlood.Size(); i++) {  
				if (eDamageType == damageTypesNoBlood[i]) {
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

			if (random[UV_VeryRandomIdentifierrr](1, 100) > (100 - bloodFreq)) {
				InitBloodSplash(newBloodColor);
			}
			if (bloodFreq > 100 && random[UV_VeryRandomIdentifierrr](1, 100) > (200 - bloodFreq)) { // if frequency > 100 there's a chance for second splash at the same moment
				InitBloodSplash(newBloodColor);
			}
			if (bloodFreq > 200 && random[UV_VeryRandomIdentifierrr](1, 100) > (300 - bloodFreq)) { // third splash
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
			return newBloodColor, true;
		}
		// Not so good: vanilla Doom or mod enemies where color is empty (0, 0, 0, 0) (usually it's not the same as set black)
		// However, check cache first
		name actorClassName = enemyActor.GetClassName();
		for (int i = 0; i < enemyBasedBloodColorCache.Size(); i++) {
			if (enemyBasedBloodColorCache[i].actorClassName == actorClassName) {
				return enemyBasedBloodColorCache[i].col, enemyBasedBloodColorCache[i].valid;
			}
		}
		// Try to find color name in the 3 blood types
		array<string> enemyBloodTypes;
		for (int i = 0; i < 3; i++) {
			if (enemyActor.GetBloodType(i) != null) {
				string enemyBloodType = enemyActor.GetBloodType(i).getClassName();
				enemyBloodType = enemyBloodType.MakeLower();
				enemyBloodTypes.Push(enemyBloodType);
			} 
		}
		if (enemyBloodTypes.Size() == 0) {
			return Color(0,0,0,0), false; // Rare case when enemy doesn't have noblood flags, but has no actual blood and all 3 types are null (because has BloodType "None"?)
					// Example: Blot in Dragon Sector Remake
		}
		if (globals.isDD_Loaded) {
			if (enemyBloodTypes.Size() > 0 && enemyBloodTypes[2].IndexOf("blue") != -1) {
				return Color("3399BF"), true; // light blue
			}
		} else if (globals.isBD64_Loaded) {
			if (enemyBloodTypes.Size() > 0 && enemyBloodTypes[1].IndexOf("blue") != -1) {
				return Color("1A166B"), true; // blue-purple, not just blue
			}
		} else {
			// Try to find color name in type names or use gameinfo default color
			newBloodColor = GetBloodColorFromTypesOrDefault(enemyBloodTypes);
		}
		UV_BloodColorCacheEntry cacheEntry = new("UV_BloodColorCacheEntry");
		cacheEntry.actorClassName = actorClassName;
		cacheEntry.col = newBloodColor;
		cacheEntry.valid = true;
		enemyBasedBloodColorCache.Push(cacheEntry);
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
			if (machineGunEnterLeaveTicker > 0)
					return; // prevent extreme shaking when entering or leaving machine gun due to health change
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
		let armor = playerinf.mo.FindInventory("BasicArmor", true);
		totalArmor = armor ? armor.Amount : 0;
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
		isDemonPlayer = false;
		inMachineGun = false;
		inVehicle = false;
		doingHelmetEquipAnim = false;
		isLastPowerupColomapped = false;
		lastColormappedPowerup = '';
		radsuitColor = UNSET_COLOR;
		powerupBlendColors.Clear();
		effectiveBlendAlpha = 0.0;
		if (globals.isPB_Loaded) {
			invulnerableClass = "PB_PowerInvul"; // check specifically this one to avoid grid highlight when doing melee groly kills
		} else {
			invulnerableClass = "PowerInvulnerable";
		}
		if (globals.isDD_Loaded) {
			nightVisionClass = "PowerNightVisionMode";
		} else {
			nightVisionClass = "PowerLightamp";
		}
		while (invItem != null) {
			name itemClass = invItem.GetClassName();
			if (invItem is "Powerup") {
				isLastPowerupColomapped = false;
				Powerup pow = Powerup(invItem);
				if (globals.isNightVisionPackLoaded && itemClass == NVNightVisionInverseMapClass) {
					NV_PackInverseMapOn = true; 
				} else if (invItem is invulnerableClass && !pow.isBlinking()) {
					invulnerabilityOn = true;
					if (!pow.Colormap && !pow.GetBlend() && !globals.isPB_Loaded) {
						isVanillaInvulernabilityOn = true;
					}
				} else if (invItem is "PowerIronfeet") { // Radsuits
					radSuitOn = true;
				} else if (invItem is "PowerInvisibility") {
					invisEffectOn = true; 
					// for some reason invis isBlinking() isn't really synced with visual blinking, so not using blink check for it
				} else if (invItem is nightVisionClass) { // Night vision
					nightVisionOn = true;
					if (invItem is PB_NightVisionClass) {
						PB_NightVisionOn = true;
					} 
				} else if (invItem is heavyMachinegunClass) { // BD and UMES machine gun
					inMachineGun = true;
				} else if (!inVehicle) {  					// BD and UMES vehicles except machine gun
					for (int i = 0; i < vehicleInvNames.Size(); i++) {
						if (invItem is vehicleInvNames[i]) {
							inVehicle = true;
							break;
						}
					}
				}
				if ((powerupColorsMode == 0 || (powerupColorsMode == 1 && invItem is nightVisionClass)) && !pow.isBlinking()) {
					if (pow.GetBlend()) { // Powerup.Color actor property
						if (invItem is "PowerIronfeet") {
							radsuitColor = pow.GetBlend();
						} else {
							powerupBlendColors.Push(pow.GetBlend());
						}
					}
					if (pow.Colormap && pow.Colormap != -1) { 
						// Based on Powerup.Colormap actor property, but we can get only its dynamic id here (unreliable if multiple mods loaded)
						// So store powerup class name instead
						lastColormappedPowerup = pow.GetClassName();
						isLastPowerupColomapped = true; // gets reset if not last
					} else if (globals.isPB_Loaded) {
						if (itemClass == PB_SpeedPowerupClass) {
							powerupBlendColors.Push(Color(80, 255, 255, 25));
						}  
						if (itemClass == PB_QuadDamagePowerupClass) {
							powerupBlendColors.Push(Color(80, 64, 0, 127));
						}
					}
				}
			} 
			// Non-powerups
			else if (globals.isPB_Loaded && itemClass == PB_HelmetAnimClass) {
				doingHelmetEquipAnim = true;
			}
			// Both powerups and non-powerups
			if (IsDemonPlayerFlag(invItem)) { // BD demon morphs
				isDemonPlayer = true;
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
	}
	
	void UpdateLightState(Vector3 point, double playerViewYaw, double playerViewPitch) {
		prevCombinedBrightnessScale = combinedBrightnessScale;
		prevCombinedFullColorScale = combinedFullColorScale;
		double sectorBrightnessScale = 1.0;
		if (playerinf.mo.cursector) {
			double raw = double(playerinf.mo.cursector.lightlevel) / 255.0;
			double rawAdjustedBySlider = 1.0 - sectorBrightnessContributionMult * 0.7 * (1.0 - raw);
			sectorBrightnessScale = clamp(rawAdjustedBySlider, 0.05, 1.0);
		}
		
		SetDynamicLightContribution(point, playerViewYaw, playerViewPitch);
// 		console.printf("^ playerinf.mo.cursector.lightlevel: %f", playerinf.mo.cursector.lightlevel);
// 		console.printf("  dLightsBrightnessWeighted: %.1f", dLightsBrightnessWeighted);
// 		console.printf("  dLightsFullColorWeighted: (%.1f, %.1f, %.1f)",
// 			dLightsFullColorWeighted.x,
// 			dLightsFullColorWeighted.y,
// 			dLightsFullColorWeighted.z);

		// Brightness-only path for glow, armor grid, wiper
		combinedBrightnessScale = BlendBrightness(sectorBrightnessScale, dLightsBrightnessWeighted);
		
		// Full color change (including brightness) for other textures
		double colR = dLightsFullColorWeighted.X;
		double colG = dLightsFullColorWeighted.Y;
		double colB = dLightsFullColorWeighted.Z;
		combinedFullColorScale.X = BlendBrightness(sectorBrightnessScale, colR);
		combinedFullColorScale.Y = BlendBrightness(sectorBrightnessScale, colG);
		combinedFullColorScale.Z = BlendBrightness(sectorBrightnessScale, colB);
		double colMax = max(colR, max(colG, colB));
		if (colMax > 0.01) {
			double hueR = colR / colMax;
			double hueG = colG / colMax;
			double hueB = colB / colMax;
			double saturation = 1.0 - min(hueR, min(hueG, hueB));
			double tint = sectorBrightnessScale * saturation * 0.25 * colMax;
			combinedFullColorScale.X = TintTowardHue(combinedFullColorScale.X, hueR, tint);
			combinedFullColorScale.Y = TintTowardHue(combinedFullColorScale.Y, hueG, tint);
			combinedFullColorScale.Z = TintTowardHue(combinedFullColorScale.Z, hueB, tint);
		}
	}

	void SetDynamicLightContribution(Vector3 point, double playerViewYaw, double playerViewPitch) {
		if (dLightsContributionMult <= 0) {
			dLightsBrightnessWeighted = 0;
			dLightsFullColorWeighted.x = dLightsFullColorWeighted.y = dLightsFullColorWeighted.z = 0;
			return;
		}
		double totalBrightness = 0.0;
		double rSum = 0.0;
		double gSum = 0.0;
		double bSum = 0.0;
		
		Vector3 playerViewDirection = GetDirectionFromAngles(playerViewYaw, playerViewPitch);
		ThinkerIterator iterator = ThinkerIterator.Create("DynamicLight");
		DynamicLight light;

		while ((light = DynamicLight(iterator.Next())) != null) {
			if (light.bDormant) // if sleeping
				continue;

			// zdoom wiki: max mapunit radius is actually double the size argument
			double effectiveRadius = light.args[DynamicLight.LIGHT_INTENSITY] * 2.0;
			double distanceToLight = (light.pos - point).Length();
			if (effectiveRadius <= 0.0 || distanceToLight >= effectiveRadius)
				continue;

			double distanceAttenuation = 1.0 - (distanceToLight / effectiveRadius);
			double directionAttenuation = 1.0;
			if (light.bSpot) {
				directionAttenuation = SpotlightConeAttenuation(light, point); // fade to 0 outside the cone
			}
			double finalAttenuation = distanceAttenuation * directionAttenuation;

			// How far off the player's view this light is (0 to 180 degrees if strictly behind)
			Vector3 toLight = (light.pos - point).Unit();
			double cosViewAngle = Clamp(playerViewDirection dot toLight, -1.0, 1.0);
			double angleDegrees = acos(cosViewAngle);

			// Full influence up to 65 degrees, then fades to 0 (up to 180 degrees)
			double behindness = Smoothstep(65.0, 180.0, angleDegrees);

			// Soft floor, so HUD never goes fully black
			double brightnessFacing = 0.25 + 0.75 * (1.0 - behindness);
			// Color fades harder, behind the player it's basically gone
			double colorFacing = 0.08 + 0.92 * (1.0 - behindness) ** 1.8;

			double rChannel = light.args[DynamicLight.LIGHT_RED];
			double gChannel = light.args[DynamicLight.LIGHT_GREEN];
			double bChannel = light.args[DynamicLight.LIGHT_BLUE];

			// Average (not max/sum) so colored lights aren't underweighted vs white
			double averageIntensity = (rChannel + gChannel + bChannel) / 3.0;

			// Facing applied per-light - front lights contribute fully, back ones barely
			totalBrightness += averageIntensity * finalAttenuation * brightnessFacing;

			rSum += rChannel * finalAttenuation * colorFacing;
			gSum += gChannel * finalAttenuation * colorFacing;
			bSum += bChannel * finalAttenuation * colorFacing;
		}

		dLightsBrightnessWeighted = Clamp(totalBrightness / 255.0 * 0.5 * dLightsContributionMult, 0.0, 1.0);
		dLightsFullColorWeighted = (
			Clamp(rSum / 255.0 * 0.9 * dLightsContributionMult, 0.0, 1.0),
			Clamp(gSum / 255.0 * 0.9 * dLightsContributionMult, 0.0, 1.0),
			Clamp(bSum / 255.0 * 0.9 * dLightsContributionMult, 0.0, 1.0)
		);
	}
	
	// Combines two brightness values (used for sector brightness and dynamic lights brightness)
	double BlendBrightness(double base, double add) {
		return 1.0 - (1.0 - base) * (1.0 - add);
	}

	// Create visible hue even at full brightness (e.g. when very bright sector, but also a colored dynamic light)
	// So it subtracts from non-dominant channels, but partially, not just channel*hue to keep colored elements
	// if hue=1: no change (already dominant channel), hue=0: reduced by amount
	double TintTowardHue(double channel, double hue, double amount) {
		return channel * (1.0 - amount * (1.0 - hue));
	}
	
	// Get forward vector (player's view or spotlights direction)
	Vector3 GetDirectionFromAngles(double yaw, double pitch) {
		double horizontal = cos(pitch);
		return (
			cos(yaw) * horizontal,
			sin(yaw) * horizontal,
			sin(-pitch) // +pitch = down
		);
	}

	// Smooth 0 to 1 ramp between edges
	double Smoothstep(double edge0, double edge1, double x) {
		double t = Clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
		return t * t * (3.0 - 2.0 * t);
	}

	// 1.0 inside inner cone, 0.0 outside outer cone, linear fade between
	double SpotlightConeAttenuation(DynamicLight light, Vector3 point) {
		Vector3 lightPosition = light.pos;
		// Some spotlights seem to be attached to an actor positioned higher than the actual light
		if (light is "Spotlight") {
			lightPosition.Z -= 16;
		}
		Vector3 spotDirection = GetDirectionFromAngles(light.Angle, light.Pitch);
		Vector3 toPoint = (point - lightPosition).Unit();
		double cosToPoint = spotDirection dot toPoint;
		double cosInner = cos(light.SpotInnerAngle);
		double cosOuter = cos(light.SpotOuterAngle);
		if (cosToPoint <= cosOuter) 
			return 0.0;
		if (cosToPoint >= cosInner) 
			return 1.0;
		return (cosToPoint - cosOuter) / (cosInner - cosOuter);
	}
	
	void SetPlayerBlendColorAndAlpha() {
		if (powerupColorsMode > 0)
			return;
		double combinedA;
		double combinedR;
		double combinedG;
		double combinedB;
		if (playerinf.BlendA) { // When actor has A_SetBlend() and its alpha is > 0
			combinedA += playerinf.BlendA;
			combinedR += playerinf.BlendR * playerinf.BlendA;
			combinedG += playerinf.BlendG * playerinf.BlendA;
			combinedB += playerinf.BlendB * playerinf.BlendA;
// 			Console.Printf("playerinf.Blend: R=%f, G=%f, B=%f, A=%f", playerinf.BlendR, playerinf.BlendG, playerinf.BlendB, playerinf.BlendA);
		}
		for (int i = 0; i < powerupBlendColors.Size(); i++) {
			Color pColor = powerupBlendColors[i];
			double blendColorAlpha = pColor.a / 255.0;
			if (blendColorAlpha <= 0.0) continue;
			combinedA += blendColorAlpha;
			combinedR += (pColor.r / 255.0) * blendColorAlpha;
			combinedG += (pColor.g / 255.0) * blendColorAlpha;
			combinedB += (pColor.b / 255.0) * blendColorAlpha;
// 			Console.Printf("powerupBlendColors[%d]: R=%f, G=%f, B=%f, A=%f",
// 						   i, pColor.r/255.0, pColor.g/255.0, pColor.b/255.0, blendColorAlpha);
		}
		if (combinedA > 0.0) {
			double normR = clamp(combinedR / combinedA, 0.0, 1.0);
			double normG = clamp(combinedG / combinedA, 0.0, 1.0);
			double normB = clamp(combinedB / combinedA, 0.0, 1.0);
			effectiveBlendAlpha = min(combinedA, 1.0);
			combPlayerBlendAndPowerupBlendColor = Color(255, int(normR * 255.0), int(normG * 255.0), int(normB * 255.0));
		} else {
			combPlayerBlendAndPowerupBlendColor = UNSET_COLOR;
		}
	}
	
	// Can't read actual Colormap colors, so hardcode for common powerups with Colormap
	void UpdateColormappedPowerupState() {
		isKnownColormapActive = false;
		applyColormapToGlow = false; // PowerInvulnerable, etc. applies even to glow
		blendColormap = false; // to blend actual helmet metal pieces with night vision colors
		if (!lastColormappedPowerup) { // last name of a powerup with Powerup.Colormap (false if empty string, i.e. no such powerup)
			return;
		}
		
		if (lastColormappedPowerup == 'PowerInvulnerable') {
			if (globals.isBD_Loaded) {
				SetColormapState(1, 1, 1, 0, 0, 0, true, false);
			} else if (globals.isHellriderLoaded) {
				SetColormapState(1.225, 0.875, 3.5, 0, 0, 0, true, false);
			} else if (globals.isHellriderVengefulLoaded) {
				SetColormapState(0, 1, 1, 10, 65, 10, true, false);
			}
			if (isKnownColormapActive) return;
		}

		// Night Vision Pack
		if (globals.isNightVisionPackLoaded && nightVisionOn) {
			if (lastColormappedPowerup == 'NVNightVision') {
				SetColormapState(0, 1, 0, 0, 35, 0, false, true);
			} else if (lastColormappedPowerup == 'NVNightVisionProto') {
				SetColormapState(0, 1, 1, 0, 20, 20, false, true);
			} else if (lastColormappedPowerup == 'NVNightVisionGoldMap') {
				SetColormapState(1, 1, 0, 55, 10, 0, false, true);
			} else if (lastColormappedPowerup == 'NVNightVisionGreenMap') {
				SetColormapState(1, 1, 1, 30, 40, 10, false, true);
			} else if (lastColormappedPowerup == 'NVNightVisionRedMap') {
				SetColormapState(1, 0.3, 0.3, 50, 0, 0, false, true);
			} else if (lastColormappedPowerup == 'NVNightVisionWhite') {
				SetColormapState(1, 1, 1, 20, 20, 20, false, true);
			}
		}

		if (globals.isDD_Loaded && lastColormappedPowerup == 'PowerNightVisionMode') {
			SetColormapState(0, 1, 0, 0, 35, 0, false, true);
		}
	}

	// Still better than comparing colormapped powerup names in ui context
	// Values passed here were mostly found by trial and error and eyes
	void SetColormapState(double mR, double mG, double mB,
						  int aR, int aG, int aB,
						  bool applyToGlow, bool applyBlend) {
		isKnownColormapActive = true;
		applyColormapToGlow = applyToGlow;
		blendColormap = applyBlend;
		colormapMultRGB = (mR, mG, mB);
		colormapAddRGB = (aR, aG, aB);
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
		pData.prevCracksLevel = pData.cracksLevel;
		
		if (machineGunEnterLeaveTicker == 0 || playerinf.health <= 0) { // additional checks, actually we almost always go into this block
			int currentHealthOrArmor = cracksBasis == 0 ? playerinf.health : totalArmor;
			if (inVehicle || (!inVehicle && wasInVehicle)) {
				currentHealthOrArmor = cracksBasis == 0 ? storedHealthInsideVehicle : storedArmorInsideVehicle;
			}
			if (currentHealthOrArmor <= 0 + cracksHP_Offset) {
				pData.cracksLevel = 5;
			} else if (currentHealthOrArmor <= 15 + cracksHP_Offset) {
				pData.cracksLevel = 4;
			} else if (currentHealthOrArmor <= 30 + cracksHP_Offset) {
				pData.cracksLevel = 3;
			} else if (currentHealthOrArmor <= 50 + cracksHP_Offset) {
				pData.cracksLevel = 2;
			} else if (currentHealthOrArmor <= 70 + cracksHP_Offset) {
				pData.cracksLevel = 1;
			} else {
				pData.cracksLevel = 0;
			}
		}
		pData.cracksLevel = min(pData.cracksLevel, cracksMaxLevel);
		if (pData.cracksLevel != pData.prevCracksLevel) {
			if (prevCracksBasis == cracksBasis) { // check prevents fading out 5th level cracks bug if switched cracks basis
				cracksFadeTicker = pData.cracksLevel > pData.prevCracksLevel ? (CRACKS_FADE_TICKS - 2) : CRACKS_FADE_TICKS;
			}
			if (cracksBasis == 1 && pData.prevCracksLevel == 5) { 
				hideFadingOutCracks = true; // prevent fading out 5th level is armor-based cracks as well
				prevF_OutCracksAlpha = 0.0;
				f_OutCracksAlpha = 0.0;
			} else {
				f_OutCracksAlpha = double(cracksFadeTicker) / CRACKS_FADE_TICKS;
				prevF_OutCracksAlpha = 1.0;
			}
			f_InCracksAlpha = 1 - double(cracksFadeTicker) / CRACKS_FADE_TICKS;
			prevF_InCracksAlpha = 0.0;
			pData.fInCracksTexId = pData.cracksLevel;
			if (cracksBasis == 1) {
				pData.fInCracksTexId = clamp(pData.fInCracksTexId, 0, 4); // don't draw the most broken glass (5th level) when armor based
			}
			fOutCracksTexId = pData.prevCracksLevel;
			if (pData.prevCracksLevel == 0) {
				pData.cracksTexturePatternId = random[UV_VeryRandomIdentifierrr](1, CRACKS_MAX_PATTERN_ID);
				pData.cracksTextureRotationDegrees = frandom[UV_VeryRandomIdentifierrr](-7.0, 7.0);
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
		isArmorGridShownVar = (mainTogglesFlagsPlay & UV_ShowArmorGrid) && (
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
			gridIdleNextTriggerTick = 0;
			return;
		}
		gridIdleTimer++;
		prevGridIdleAlphaImage_1 = gridIdleAlphaImage_1;
		prevGridIdleAlphaImage_2 = gridIdleAlphaImage_2;
		// Select tick for the very first time
		if (gridIdleNextTriggerTick <= 0) {
			gridIdleNextTriggerTick = random[UV_VeryRandomIdentifierrr](GRID_IDLE_CYCLE_TICKS, GRID_IDLE_CYCLE_TICKS * 5); // 7-35 sec
		}
        if (gridIdleTimer >= gridIdleNextTriggerTick) {
            gridIdleTimer = 0;
			// Reselect tick
			gridIdleNextTriggerTick = random[UV_VeryRandomIdentifierrr](GRID_IDLE_CYCLE_TICKS, GRID_IDLE_CYCLE_TICKS * 8);
		}
        if (gridIdleTimer < GRID_IDLE_FADE_TICKS) {
            // First fade: image1 to image2
            double tickRatio = double(gridIdleTimer) / GRID_IDLE_FADE_TICKS; // 0 to 1
            gridIdleAlphaImage_1 = 1.0 - tickRatio;
            gridIdleAlphaImage_2 = tickRatio;
        }
        else if (gridIdleTimer < 2 * GRID_IDLE_FADE_TICKS) {
            // Reverse fade: image2 to image1
            double tickRatio = double(gridIdleTimer - GRID_IDLE_FADE_TICKS) / GRID_IDLE_FADE_TICKS; // 0 to 1
            gridIdleAlphaImage_1 = tickRatio;
            gridIdleAlphaImage_2 = 1.0 - tickRatio;
        } else {
			gridIdleAlphaImage_2 = 0.0;
		}
	}
	
	override void WorldThingSpawned(worldEvent e) {
		// Trigger enemy blood splash in based on blood actor mode
		if (Cvar.GetCvar("uvisor_mod_enabled", playerinf).GetBool() == 0) return;
		if (isGlassDestroyed) return;
		if (inVehicle) return;
		if (!(mainTogglesFlagsPlay & UV_ShowBloodSplashes)) return;
		if (bloodDetectionMode != 1 || !e.thing || e.thing.target == playerinf.mo ) return;
		
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
			if (random[UV_VeryRandomIdentifierrr](1, 100) > (100 - bloodFreq)) {
				newBloodColor = bloodRandomColors ? GetRandomBloodColor() : GetBloodColorFromBlood(e.thing);
				InitBloodSplash(newBloodColor);
			}
			if (bloodFreq > 100 && random[UV_VeryRandomIdentifierrr](1, 100) > (200 - bloodFreq)) { // if frequency > 100 there's a chance for second splash at the same moment
				InitBloodSplash(newBloodColor);
			}
			if (bloodFreq > 200 && random[UV_VeryRandomIdentifierrr](1, 100) > (300 - bloodFreq)) { // third splash
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
			string bloodClassName = thing.GetClassName();
			for (int i = 0; i < bloodBasedBloodColorCache.Size(); i++) {
				if (bloodBasedBloodColorCache[i].actorClassName == bloodClassName) {
					return bloodBasedBloodColorCache[i].col;
				}
			}
			if (!(thing is MD_BLOOD)) { // enemies in Mass Disassembly have black blood
				newBloodColor = GetDefaultBloodColor();
			}
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
			UV_BloodColorCacheEntry cacheEntry = new("UV_BloodColorCacheEntry");
			cacheEntry.actorClassName = bloodClassName;
			cacheEntry.col = newBloodColor;
			cacheEntry.valid = true;
			bloodBasedBloodColorCache.Push(cacheEntry);
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
		bs.texIndex = random[UV_VeryRandomIdentifierrr](1, BLOOD_MAX_TEXTURE_ID); // png names
		double w, h;
		TextureID bloodTex = TexMan
			.CheckForTexture(CommonGraphicsPathPlayContext .. "Blood/blood_" .. bs.texIndex .. ".png");
		[w,h] = TexMan.GetSize(bloodTex);
		double randomSizeMult = double(random[UV_VeryRandomIdentifierrr](75, 125)) / 100;
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
		bs.origCoords.x = Screen.GetWidth() - w - random[UV_VeryRandomIdentifierrr](0, Screen.GetWidth() - w);
		bs.origCoords.y = Screen.GetHeight() - h - random[UV_VeryRandomIdentifierrr](0, Screen.GetHeight() - h);
		bs.coordinates.x = bs.origCoords.x + widthDecrease / 2;
		bs.coordinates.y = bs.origCoords.y + heightDecrease / 2;
		bs.prevCoordinates.x = bs.origCoords.x + w / 2;
		bs.prevCoordinates.y = bs.origCoords.y + w / 2;
		
		currentBloodSplashes[newBloodSplashNumber] = bs;
		newBloodSplashNumber = afterNewId;
	}
	
	void UpdateBloodSplashesData() {
		if (isGlassDestroyed) {
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
		if (!isGlassDestroyed) {
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
		int rand = random[UV_VeryRandomIdentifierrr](1, 6);
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
		shouldSkipWeaponData = false;
		ammoData = UV_AmmoReaderFactory.Get().GetAmmoData(playerinf, globals);
		if (!ammoData.ammo1_ClassName && !ammoData.ammo2_ClassName) { // no ammo classes
			name wClass = ammoData.weaponClassName;
			if (wClass) {
				if (IsSkippableWeaponData(wClass)) {
					shouldSkipWeaponData = true;
					return; // if these are found, do nothing, keep previous ammo behaviour
				} else {
					// or if for example chainsaw with infinite ammo is selected, notify to disable both warning types
					StopBothAmmoNotifications();
				}
			}
		}
		
		bool preventedNotifyingBySmartW = false;
		if (isSmartAmmoWarning) {
			if (ammoData.ammo1_ClassName && !ammoData.ammo2_ClassName
					|| !ammoData.ammo1_ClassName && ammoData.ammo2_ClassName) {
				preventedNotifyingBySmartW = true; // weapon doesn't have reloading
			}
			if (warningSoundBasis == 2) { // ammo1
				if (ammoData.am2amt <= 0) { // no ammo for reloading
					preventedNotifyingBySmartW = true;
				}
			} else if (warningSoundBasis == 3) { // ammo2
				if (ammoData.am1amt <= 0) { // no ammo for reloading
					preventedNotifyingBySmartW = true;
				}
			}
		}
		
		if (ammoData.am1max > 0) {
			if (globals.isBD64_Loaded && ammoData.ammo1_ClassName && ammoData.ammo1_ClassName.IndexOf("AltPunch") != -1) {
				NotifyIfLowAmmo(0, 0, 1);
			} else if (!preventedNotifyingBySmartW) {
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
			} else if (!preventedNotifyingBySmartW) {
				NotifyIfLowAmmo(ammoData.am2amt, ammoData.am2max, 2); // Regular case
			}
			mappedCurrentAmmo2 = MapRange(ammoData.am2amt, 0, ammoData.am2max, 0, 200);
		} 
		
		if (preventedNotifyingBySmartW) {
			StopBothAmmoNotifications();
			return;
		}
		
		if (ammoData.ammo1_ClassName && !ammoData.ammo2_ClassName) { 
			// Mod weapons often have two ammo types, for example ammo1 for total and ammo2 for current (mag)
			// But a weapon without mag (like chaingun) in this case will usually have only ammo1 type
			// So in such case if basis is ammo2, check ammo1 and vice versa
			if (!(globals.isBD64_Loaded && ammoData.ammo1_ClassName.IndexOf("AltPunch") != -1)) {
				if (!preventedNotifyingBySmartW) {
					NotifyIfLowAmmo(ammoData.am1amt, ammoData.am1max, 2);	// And notify about ammo1 (like chaingun) as if basis is ammo2 
				}
			} else {
				NotifyIfLowAmmo(0, 0, 2);
			}
		} else if (ammoData.ammo2_ClassName && !ammoData.ammo1_ClassName && !preventedNotifyingBySmartW) {
			NotifyIfLowAmmo(ammoData.am2amt, ammoData.am2max, 1);
		}
	}
	
	void NotifyIfLowAmmo(int currentAmmo, int maxAmmo, int ammoType) {
		bool foundLowAmmo = false;
		if (maxAmmo > 0) {
			if (	   (maxAmmo > 400 && currentAmmo <= 30)
					|| (maxAmmo > 200 && currentAmmo <= 20)
					|| (maxAmmo <= 200 && double(currentAmmo) / maxAmmo <= 0.08)
					|| (maxAmmo <= 12 && maxAmmo >= 2 && currentAmmo < 2)
					) {
				foundLowAmmo = true;
			}
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
	
	void StopBothAmmoNotifications() {
		NotifyIfLowAmmo(0, 0, 1);
		NotifyIfLowAmmo(0, 0, 2);
	}
	
	bool IsSkippableWeaponData(name wClass) {
		for (int i = 0; i < skippableWeaponsForAmmoData.Size(); i++) {
			if (wClass == skippableWeaponsForAmmoData[i]) {
				return true;
			}
		}
		return false;
	}
	
	void DoHelmetShaking() {
		if (ShakeIntensity > 0.01) { // ShakeIntensity is calculated in WorldThingDamaged override
			ShakeOffsetX = frandom[UV_VeryRandomIdentifierrr](-ShakeIntensity, ShakeIntensity);
			ShakeOffsetY = frandom[UV_VeryRandomIdentifierrr](-ShakeIntensity, ShakeIntensity);
	
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
		if (swayFlags & UV_MovementSway) {
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
					BobAmount *= 20; // So that it looks good even without the PB patch. Without multiplier it would be very small
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
		
		if (swayFlags & UV_JumpSway) {
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
		if (swayFlags & UV_CrouchSway) {
			double crouchChange = crouchfactor - PrevCrouchFactor;
			if (abs(crouchChange) > 0.001) {
				double bounceStrength = crouchChange * 60;   // scale
				bounceStrength = clamp(bounceStrength, -20.0, 20.0);
				crouchStartOffset = bounceStrength * CrouchSwayIntensity;
			}
		}
		// Static offset when fully crouched
		double crouchStaticOffset = 0;
		if (swayFlags & UV_CrouchSway) {
			bool isCrouching = (crouchfactor < 0.55);
			crouchStaticOffset = isCrouching ? 5.0 * CrouchSwayIntensity : 0.0;
		}
		
		if (scaledMaxSwayX > 0) {
			rawSwayX = clamp(rawSwayX, -MaxSwayX, MaxSwayX);
			DynSwayX.Update(rawSwayX * 60.0);
			double smoothSwayX = DynSwayX.GetValue() / 60.0;
			SwayOffX = ApplySwaySensitivity(smoothSwayX, MaxSwayX);
			SwayOffX *= scaleFactorWidthPlay;
			SwayOffX = Clamp(SwayOffX, -scaledMaxSwayX, scaledMaxSwayX);
		} else {
			SwayOffX = 0;
		}
		
		if (scaledMaxSwayY > 0) {
			rawSwayY += mJumpOffset;
			rawSwayY += mFallingOffset;
			rawSwayY += mLandingOffset;
			rawSwayY += crouchStartOffset;
			rawSwayY += crouchStaticOffset;
			rawSwayY = clamp(rawSwayY, -MaxSwayY, MaxSwayY);
			DynSwayY.Update(rawSwayY * 60.0);
			double smoothSwayY = DynSwayY.GetValue() / 60.0;
			SwayOffY = ApplySwaySensitivity(smoothSwayY, MaxSwayY);
			SwayOffY *= scaleFactorHeightPlay;
			SwayOffY = Clamp(SwayOffY, -scaledMaxSwayY, scaledMaxSwayY);
		} else {
			SwayOffY = 0;
		}

		if (helmetShakeEnabled) {
			double totalX = SwayOffX + ShakeOffsetX;
			double totalY = SwayOffY + ShakeOffsetY;
			if (abs(totalX) > scaledMaxSwayX && scaledMaxSwayX > 0) {
				// Reduce both sway and shake while keeping their ratio
				double scaleX = scaledMaxSwayX / abs(totalX);
				SwayOffX *= scaleX;
				ShakeOffsetX *= scaleX;
			}
			if (abs(totalY) > scaledMaxSwayY && scaledMaxSwayY > 0) {
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
		}
    }
	
	void SetIsThirdPerson() {
		isThirdPerson = (playerinf && (playerinf.cheats & CF_CHASECAM)) // Vanilla chase cam
			|| (playerinf.camera && playerinf.camera.GetClassName() == "chaseCam2") // LiTDOOM
			|| (playerinf.camera && playerinf.camera.GetClassName() == "ThirdPersonCamera") // ChaseCam++
		;
	}
	
	void DoBreathingSound() {
		if (prevBreathSoundChannel != breathSoundChannel
				|| prevBreathVolume != breathVolume
				|| prevBreathVoice != breathVoice) {
			playerinf.mo.A_StopSound(prevBreathSoundChannel);  // restart to immediately see the difference
		}
		if (breathVolume <= 0
			|| gamestate != GS_LEVEL // Prevent breath in main menu with mods overriding Titlemap
			|| (breathDisableIfNoGlass && isGlassDestroyed)
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
		} else if (inVehicle) {
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

class UV_BloodColorCacheEntry {
	
	name actorClassName;
    Color col;
    bool valid;
}
