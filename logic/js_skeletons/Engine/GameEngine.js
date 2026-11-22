// Auto-generated skeleton from UnrealScript: Engine/GameEngine.uc
// Parent: Engine

class GameEngine extends Engine {

  // Variables
  Protocol: string;  //  string
  Host: string;  //  string
  Port: number;  //  int
  Map: string;  //  string
  Op: string[];  //  array<string>
  Portal: string;  //  string
  Valid: number;  //  int
  GLevel: any /* level */;  //  Level
  GEntry: any /* level */;  //  Level
  GPendingLevel: any /* pendinglevel */;  //  PendingLevel
  LevelLoadingTotalActorCount: number;  // private const int
  LevelLoadingActorCount: number;  // private const int
  LastURL: any /* url */;  //  URL
  ServerActors: string[];  // config array<string>
  ServerPackages: string[];  // config array<string>
  DummyArray: any /* object */[];  //  array<Object>
  DummyObject: any /* object */;  //  Object
  bCheatProtection: boolean;  //  bool
  InitialMapLoaded: boolean;  //  bool
  HUDMenuClass: string;  // config string
  InitialMenuClass: string;  // config string
  GameSpyManagerClass: string;  // config string
  GameSpyManager: any /* gamespymanager */;  //  GameSpyManager

  constructor() {
    super();
  }

}
