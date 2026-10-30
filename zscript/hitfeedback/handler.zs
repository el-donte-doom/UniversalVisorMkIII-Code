// MIT License
// Copyright (c) 2026 El Donte - small adaptation for Universal Visor and texture warmup
// Copyright (c) 2026 generic name guy - original
// The original file is part of "PB Damage Feedback" (addon)

class UV_HitFeedback_Handler : EventHandler
{
    override void PlayerEntered( PlayerEvent e )
	{
		PlayerPawn player = PlayerPawn( players[e.PlayerNumber].mo );

        if( player )
            player.GiveInventoryType( "UV_Hitfeedback_Inventory" );
			
//         S_StartSound("hud/shieldbreak", 0, volume: 0); // Already in UvHudVisorDraw separately
	}

    ui float shakeMagnitude;
    ui double animationProgress[2];
    ui int animationTime;
    const ANIM_DURATION = double( floor( 0.55 * TICRATE ) );
    ui vector2 overlayPos[2];
    ui TextureID cachedOverlays[5];
	ui Color colorGlass;
	ui Color colorGlassCracks;
	ui double alphaGlass;
	ui double alphaCracks;
	ui bool initialUIInitDone;
	ui bool hitAddonEnabled;
	ui bool needsWarmUp;
	ui int prevTexRes;

    override void InterfaceProcess( ConsoleEvent e )
    {
        if( e.name == "UV_hf_ShieldBroken" )
        {
			if (!hitAddonEnabled)
				return;
            shakeMagnitude = 1;
            animationProgress[0] = 0.f;
            animationProgress[1] = 0.f;
            animationTime = ANIM_DURATION;
        }
		if( e.name == "UV_SavegameLoaded" )
        {
			InitUI_Vars();
			needsWarmup = true;
        }
    }

    override void UiTick()
    {
		if (Menu.GetCurrentMenu() != null || consolestate || !initialUIInitDone) {
			initUI_Vars();
		}
		if (!hitAddonEnabled)
			return;
		
        animationProgress[1] = animationProgress[0];
        animationProgress[0] = 1.f - ( animationTime / ANIM_DURATION );

        overlayPos[1] = overlayPos[0];
        overlayPos[0] = ( frandom( -50, 50 ), frandom( -50, 50 ) ) * shakeMagnitude;

        shakeMagnitude *= 0.7;

        if( animationTime > 0 ) animationTime--;

        //console.printf("%i, %f, %f", animationTime, animationProgress[1], animationProgress[0]);
    }
	
	ui void initUI_Vars() {
		bool wasHitAddonEnabled = hitAddonEnabled;
		bool hideGlassIfEmptyArmorCvar = Cvar.GetCvar("uvisor_hide_glass_if_empty_armor", players[consoleplayer]).GetBool();
		bool hitAddonEnabledCvar = Cvar.GetCvar("uvisor_hitfeedback_if_empty_armor", players[consoleplayer]).GetBool();
		hitAddonEnabled = hideGlassIfEmptyArmorCvar && hitAddonEnabledCvar;
		if (!wasHitAddonEnabled && hitAddonEnabled) {
			needsWarmup = true; // always true at first level start (as it should be) because hitAddonEnabled is false at start
		}
		int texRes = Cvar.GetCvar("uvisor_tex_res", players[consoleplayer]).GetInt();
		String texResPath;
		if (texRes == 0) {
			texResPath = "High_Res";
		} else if (texRes == 1) {
			texResPath = "Med_Res";
		} else {
			texResPath = "Low_Res";
		}
		if (texRes != prevTexRes) {
			needsWarmup = true;
		}
		prevTexRes = texRes;
		String graphicsPath = "graphics/" .. texResPath .. "/Common/Glass_Destruction_Feedback/";
		cachedOverlays[0] = TexMan.CheckForTexture( graphicsPath .. "visorcracks1_glass_separate.png" );
		cachedOverlays[1] = TexMan.CheckForTexture( graphicsPath .. "visorcracks1_cracks_separate.png" );
		cachedOverlays[2] = TexMan.CheckForTexture( graphicsPath .. "crackflash1_glass_separate.png" );
		cachedOverlays[3] = TexMan.CheckForTexture( graphicsPath .. "crackflash1_cracks_separate.png" );
		cachedOverlays[4] = TexMan.CheckForTexture( graphicsPath .. "fuckasscircle.png" );
		colorGlass = Cvar.GetCvar("uvisor_color_glass", players[consoleplayer]).GetString();
		colorGlassCracks = Cvar.GetCvar("uvisor_color_glass_cracks", players[consoleplayer]).GetString();
		alphaGlass = Cvar.GetCvar("uvisor_alpha_glass", players[consoleplayer]).GetFloat();
		alphaCracks = Cvar.GetCvar("uvisor_alpha_cracks", players[consoleplayer]).GetFloat();
		initialUIInitDone = true;
	}

    override void RenderUnderlay( RenderEvent e )
    {
		if (needsWarmup) {
			warmUpTextures();
		}
		if (!hitAddonEnabled)
			return;
			
        double i_animationProgress = GetTicFracInterpolation( animationProgress[1], animationProgress[0], e.FracTic );
        // console.printf("%f", i_animationProgress);
        vector2 i_shake = overlayPos[0];
        //( GetTicFracInterpolation( overlayPos[1].x, overlayPos[0].x, e.FracTic ), GetTicFracInterpolation( overlayPos[1].y, overlayPos[0].y, 1 ) );

        double overlayScale, overlay2Scale, overlay3Scale;
        /*if( i_animationProgress < 0.26 )
            overlayScale = UV_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.0, 0.1, 1.1, 1.f, 1.f, 1.1 );
        else*/
            overlayScale = UV_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.26, 1.f, 1.f, 3, 1.f, 3 );

        double overlayAlpha, overlay2Alpha, overlay3Alpha;

        //if( i_animationProgress < 0.5 )
        //    overlayAlpha = UV_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.0, 0.1, 0.f, 1.f, 0.f, 1.f );
        //if( i_animationProgress > 0.5 )
            overlayAlpha = UV_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.26, 1.f, 1.f, 0.f, 0.f, 1.f );

        /*if(i_animationProgress <= 0.07 || ( i_animationProgress >= 0.2 && i_animationProgress <= 0.26 ) || i_animationProgress > 0.3 )
            
        else
            overlay2Alpha = 0;*/

        overlay2Alpha = UV_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.f, 0.57, 1.f, 0.f, 0.f, 1.f );
        overlay2Scale = UV_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.f, 0.57, 1.f, 3, 1.f, 3 );

        overlay3Alpha = UV_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.f, 1, 1.f, 0.f, 0.f, 1.f );
        overlay3Scale = UV_HitFeedback_Math.LinearMapClamped( i_animationProgress, 0.f, 1, 1.f, 4.f, 1.f, 4.f );

        if( animationTime > 0 ) {
			Color colorGlassCurrent = CalculateColorWithBrightness(colorGlass);
			Color colorGlassCracksCurrent = CalculateColorWithBrightness(colorGlassCracks);
			
			// Visorcrack glass
            Screen.DrawTexture(
                cachedOverlays[0], false, 
                Screen.GetWidth() / 2.f + i_shake.x, Screen.GetHeight() / 2.f + i_shake.y,
                DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
                DTA_Alpha, overlayAlpha * alphaGlass,
                DTA_CenterOffset, true, 
                DTA_ScaleX, overlayScale + 0.1, DTA_ScaleY, overlayScale + 0.1,
				DTA_Color, colorGlassCurrent
            );
			// Visorcrack cracks
			Screen.DrawTexture(
                cachedOverlays[1], false,
                Screen.GetWidth() / 2.f + i_shake.x, Screen.GetHeight() / 2.f + i_shake.y,
                DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(),
                DTA_Alpha, overlayAlpha * alphaCracks,
                DTA_CenterOffset, true,
                DTA_ScaleX, overlayScale + 0.1, DTA_ScaleY, overlayScale + 0.1,
				DTA_Color, colorGlassCracksCurrent
            );

			// Crackflash glass
            Screen.DrawTexture(
                cachedOverlays[2], false, 
                Screen.GetWidth() / 2.f, Screen.GetHeight() / 2.f,
                DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
                DTA_Alpha, (overlayAlpha * overlay2Alpha) * alphaGlass,
                DTA_CenterOffset, true, 
                DTA_ScaleX, overlay2Scale + 0.1, DTA_ScaleY, overlay2Scale + 0.1,
                DTA_LegacyRenderStyle, STYLE_Add,
				DTA_Color, colorGlassCurrent
            );
			// Crackflash cracks
			Screen.DrawTexture(
                cachedOverlays[3], false,
                Screen.GetWidth() / 2.f, Screen.GetHeight() / 2.f,
                DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(),
                DTA_Alpha, (overlayAlpha * overlay2Alpha) * alphaCracks,
                DTA_CenterOffset, true,
                DTA_ScaleX, overlay2Scale + 0.1, DTA_ScaleY, overlay2Scale + 0.1,
                DTA_LegacyRenderStyle, STYLE_Add,
				DTA_Color, colorGlassCracksCurrent
            );
			
			// Circle
			Screen.DrawTexture(
                cachedOverlays[4], false,
                Screen.GetWidth() / 2.f, Screen.GetHeight() / 2.f,
                DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetWidth(),
                DTA_Alpha, overlay3Alpha * 0.1,
                DTA_CenterOffset, true,
                DTA_ScaleX, overlay3Scale, DTA_ScaleY, overlay3Scale,
                DTA_LegacyRenderStyle, STYLE_Add,
				DTA_Color, colorGlass
            );
        }
    }
	
	// Draw textures with alpha 0 to force GPU to upload them beforehand
	// Eliminates stutter when they are actually drawn for the first time (happened even after a savegame load)
	ui void warmUpTextures() {
		// Visorcrack glass
		Screen.DrawTexture(
			cachedOverlays[0], false, 
			0, 0,
			DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
			DTA_Alpha, 0.0
		);
		// Visorcrack cracks
		Screen.DrawTexture(
			cachedOverlays[1], false, 
			0, 0,
			DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
			DTA_Alpha, 0.0
		);

		// Crackflash glass
		Screen.DrawTexture(
			cachedOverlays[2], false, 
			0, 0,
			DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
			DTA_Alpha, 0.0
		);
		// Crackflash cracks
		Screen.DrawTexture(
			cachedOverlays[3], false, 
			0, 0,
			DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetHeight(), 
			DTA_Alpha, 0.0
		);
		
		// Circle
		Screen.DrawTexture(
			cachedOverlays[4], false, 
			0, 0,
			DTA_DestWidth, Screen.GetWidth(), DTA_DestHeight, Screen.GetWidth(), 
			DTA_Alpha, 0.0
		);
		
		needsWarmup = false;
	}

    ui double GetTicFracInterpolation( double poll1, double poll2, double ticFrac )
    {
        return poll1 * ( 1.f - ticFrac ) + poll2 * ticFrac;
    }
	
	ui Color CalculateColorWithBrightness(Color originalColor) {
		double brightness = double(players[consoleplayer].mo.cursector.lightlevel) / double(255.0); // lightlevel is 0-255
		brightness *= 1.3;
		brightness = Clamp(brightness, 0.4, 1.0);
		int r, g, b;
		r = int(originalColor.r * brightness);
		g = int(originalColor.g * brightness);
		b = int(originalColor.b * brightness);
		return Color(255, r, g, b);
	}
}