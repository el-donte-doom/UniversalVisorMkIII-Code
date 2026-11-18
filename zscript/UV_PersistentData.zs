// To combine with StaticEventHanlder to keep data both on level change and loading different savegames
class UV_PersistentData : Thinker {

	int prevCracksLevel;
	int cracksLevel; // 1-5
	int cracksTexturePatternId;
	int fInCracksTexId; // id of png file, may be different from pattern id in some cases
	double cracksTextureRotationDegrees;
	
	static UV_PersistentData Get() {
		ThinkerIterator tit = ThinkerIterator.Create('UV_PersistentData', STAT_STATIC);
		UV_PersistentData t = null;
		while (t = UV_PersistentData(tit.Next())) {
			return t;
		}
		t = new('UV_PersistentData');
		t.ChangeStatNum(STAT_STATIC);
		return t;
	}
}