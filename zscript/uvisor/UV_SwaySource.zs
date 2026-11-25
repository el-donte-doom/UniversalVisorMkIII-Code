class UV_SwaySource : Object {

    bool isEnabled;
	string sourceName;
    Vector2 swayOffsetOld, swayOffset;
	
	// max possible horizontal and vertical sway
	// used to reserve space for swaying
	double marginY;
	double marginX;
	
	// expansion applied to most of UV fullscreen textures 
	// similar to pb hud expansion on movement
	// basically used only if UV has PB sway as a source
    Vector2 hudExpansionOld, hudExpansion; 
	double forwardOfsOld, forwardOfs; // for smaller textures like top/bottom helmet pieces which can't just expand
}

class UV_SwaySourceHolder : StaticEventHandler {  // EventHandler can be found in both contexts (we need ui)
    UV_SwaySource source;						  // Static to not store in savegame (so removing the patch won't break it)
}