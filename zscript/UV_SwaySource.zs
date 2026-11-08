class UV_SwaySource : Object {
    bool isEnabled;
	name sourceName; // just in case
    Vector2 swayOffsetOld, swayOffset;
    Vector2 hudExpansionOld, hudExpansion; // expansion applied to fullscreen textures (armor grid, tactical overlay), 
										   // similar to pb hud expansion on movement
	double forwardOfsOld, forwardOfs; // for smaller textures like top/bottom helmet pieces which can't just expand
    double marginX, marginY; // how much helmet space to reserve for swaying
}

class UV_SwaySourceHolder : StaticEventHandler {  // EventHandler can be found in both contexts (we need ui)
    UV_SwaySource source;						  // Static to not store in savegame (so removing the patch won't break it)
}