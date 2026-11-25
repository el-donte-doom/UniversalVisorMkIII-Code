// Export helmet sway (including shake) data if somebody decides to integrate with UV sway
// If UV uses an alternative sway source, like PB, the values here will reflect that
// These values come from UI context and are already interpolated using FracTic
// Example of usage in another mod:
// 		ServiceIterator it = ServiceIterator.Find("UV_SwayExportService");
// 		Service s;
// 		while (s = it.Next()) {
// 			double swayOffsetX = s.GetDoubleUI("swayOffsetX");
// 			break;
// 		}

class UV_SwayExportService : Service {
    
    override double GetDoubleUI(String request, String stringArg, int intArg, double doubleArg, Object objectArg) {
        let UV_Hud = UV_HudVisorDraw(EventHandler.Find("UV_HudVisorDraw"));
        if (!UV_Hud) {
			return 0.0;
		}
		switch (name(request)) {
			case 'swayOffsetX': return UV_Hud.uiSwayOffX;
			case 'swayOffsetY': return UV_Hud.uiSwayOffY;
			
			// max possible horizontal and vertical sway
			// can be used to reserve space for swaying
			case 'marginX': return UV_Hud.swayMarginX;
			case 'marginY': return UV_Hud.swayMarginY;			
			
			// expansion applied to most of UV fullscreen textures
			// similar to pb hud expansion on movement
			// basically used only if UV has PB sway as a source
			case 'hudExpansionX': return UV_Hud.hudExpansionX; 														
			case 'hudExpansionY': return UV_Hud.hudExpansionY;
			case 'forwardOfs': return UV_Hud.forwardOfsHelmet;
			
			default: return 0.0;
		}
    }
	
	override int GetIntUI(String request, String stringArg, int intArg, double doubleArg, Object objectArg) {
		let UV_Hud = UV_HudVisorDraw(EventHandler.Find("UV_HudVisorDraw"));
		if (!UV_Hud) {
			return 0;
		}
		switch (name(request)) {
			// UV has independent toggles for sway and shake, but they both contribute to final sway
			case 'enabled': return (UV_Hud.helmetSwayEnabled || UV_Hud.helmetShakeEnabled) ? 1 : 0;
			default: return 0;
		}
	}
	
	override string GetStringUI(String request, String stringArg, int intArg, double doubleArg, Object objectArg) {
		let UV_Hud = UV_HudVisorDraw(EventHandler.Find("UV_HudVisorDraw"));
		if (!UV_Hud) {
			return "";
		}
		switch (name(request)) {
			case 'sourceName': return UV_Hud.swaySourceName; // default is "UVMkIII"
			default: return "";
		}
	}
}
