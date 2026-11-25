class UV_SmallUtils abstract {

	clearscope static double InterpolateValue(double prev, double next, double fracTic) {
		return prev * (1.0 - fracTic) + next * fracTic;
	}
	
	clearscope static int CalculateGrayscaleAmount(Color originalColor) {
		// luminosity method
		return int(0.2126 * originalColor.r + 0.7152 * originalColor.g + 0.0722 * originalColor.b);
	}
	
	clearscope static Color GetColorForStencilStyle(Color originalColor) {
		int grayscale = CalculateGrayscaleAmount(originalColor) + 110;
		return Color(255, grayscale, grayscale, grayscale);
	}
	
	// Brighten / darken
	clearscope static Color ScaleColor(Color originalColor, double multiplier) {
		return Color(255, 
			int(originalColor.r * multiplier), 
			int(originalColor.g * multiplier), 
			int(originalColor.b * multiplier)
		);
	}
	
	clearscope static Color BlendColors(Color base, Color blend, double factor) {
		int r = int(base.r * (1.0 - factor) + blend.r * factor);
		int g = int(base.g * (1.0 - factor) + blend.g * factor); 
		int b = int(base.b * (1.0 - factor) + blend.b * factor); 
		return Color(255, r, g, b);
	}
	
	clearscope static double MapRange(double val, double fromLow, double fromHigh, double toLow, double toHigh) {
		return toLow + (val - fromLow) * (toHigh - toLow) / (fromHigh - fromLow);
	}
	
	// Combines two brightness values (used for sector brightness and dynamic lights brightness)
	clearscope static double BlendBrightness(double base, double add) {
		return 1.0 - (1.0 - base) * (1.0 - add);
	}
	
	// Create visible hue even at full brightness (e.g. when very bright sector, but also a colored dynamic light)
	// So it subtracts from non-dominant channels, but partially, not just channel*hue to keep colored elements
	// if hue=1: no change (already dominant channel), hue=0: reduced by amount
	clearscope static double TintTowardHue(double channel, double hue, double amount) {
		return channel * (1.0 - amount * (1.0 - hue));
	}

	// Smooth 0 to 1 ramp between edges
	clearscope static double Smoothstep(double edge0, double edge1, double x) {
		double t = Clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
		return t * t * (3.0 - 2.0 * t);
	}

	// 1.0 inside inner cone, 0.0 outside outer cone, linear fade between
	clearscope static double SpotlightConeAttenuation(DynamicLight light, Vector3 point) {
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
		if (cosToPoint <= cosOuter) {
			return 0.0;
		}
		if (cosToPoint >= cosInner) {
			return 1.0;
		}
		return (cosToPoint - cosOuter) / (cosInner - cosOuter);
	}
	
	// Get forward vector (player's view or spotlights direction)
	clearscope static Vector3 GetDirectionFromAngles(double yaw, double pitch) {
		double horizontal = cos(pitch);
		return (
			cos(yaw) * horizontal,
			sin(yaw) * horizontal,
			sin(-pitch) // +pitch = down
		);
	}
}