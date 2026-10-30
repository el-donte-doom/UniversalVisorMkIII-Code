// Allows to have patches for ammo data when a mod with heavily customized ammo system (requiring its classes) is loaded (probably like Hideous Destructor)
class UV_AmmoReaderFactory : Thinker {

    string readerClassName;
    
    static UV_AmmoReaderFactory Get() {
        ThinkerIterator it = ThinkerIterator.Create("UV_AmmoReaderFactory");
        UV_AmmoReaderFactory factory;
        while (factory = UV_AmmoReaderFactory(it.Next())) {
            return factory;
        }
        // Not found, create one
        factory = new("UV_AmmoReaderFactory");
		if (!factory.readerClassName) {
			// Default reader class
			factory.readerClassName = "UV_AmmoReader";
		}
        factory.ChangeStatNum(STAT_STATIC);
        return factory;
    }
    
    UV_AmmoData GetAmmoData(PlayerInfo playerinf, UV_HudVisorStaticGlobals globals) {
        UV_AmmoReader reader = UV_AmmoReader(new(readerClassName));
        return reader.GetAmmoData(playerinf, globals);
    }
}


//// Example of patch (in separate .pk3):

// class UV_AaaPatchAmmoReader : UV_AmmoReader {
// 	override UV_AmmoData GetAmmoData(PlayerInfo playerinf, UV_HudVisorStaticGlobals globals) {
// 		UV_AmmoData amData = new("UV_AmmoData");
// 		...
// 		return amData;
// 	}
// }

// class UV_AaaaaPatcher : EventHandler {
//     override void WorldLoaded(WorldEvent e) {
//         UV_AmmoReaderFactory.Get().readerClassName = "UV_AaaPatchAmmoReader";
//     }
// }