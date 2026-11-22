// Auto-generated skeleton from UnrealScript: Engine/Engine.uc
// Parent: Subsystem

class Engine extends Subsystem {

  // Variables
  Cylinder: any /* primitive */;  //  Primitive
  Client: any /* client */;  // const Client
  Audio: any /* audiosubsystem */;  // const AudioSubsystem
  GRenDev: any /* renderdevice */;  // const RenderDevice
  Repo: any /* repo */;  //  Repo
  RepoClassName: string;  // config string
  GameExecHook: number;  // const transient int
  bShowFrameRate: number;  //  int
  bShowRenderStats: number;  //  int
  bShowHardwareStats: number;  //  int
  bShowGameStats: number;  //  int
  bShowNetStats: number;  //  int
  bShowAnimStats: number;  //  int
  ShowEngineStats: number;  //  int
  bShowAIStats: number;  //  int
  bShowLIPSincStats: number;  //  int
  bShowHistograph: number;  //  int
  bShowXboxMemStats: number;  //  int
  bShowMatineeStats: number;  //  int
  bShowAudioStats: number;  //  int
  bShowLightStats: number;  //  int
  TickCycles: number;  //  int
  GameCycles: number;  //  int
  ClientCycles: number;  //  int
  ForceActorCleanup: number;  // config int
  ActiveControllerId: number;  //  int

  constructor() {
    super();
  }

  // Methods
  CreateRepo(): void {
      // TODO: implement
  }

  GetRepo(): any /* repo */ {
      // TODO: implement
  }

}
