// Auto-generated skeleton from UnrealScript: Engine/LevelInfo.uc
// Parent: ZoneInfo

class LevelInfo extends ZoneInfo {

  // Variables
  RelevantPawnViewer: any /* pawn */;  //  Pawn
  RelevantActor: any /* actor */;  //  Actor
  bIsRelevant: boolean;  //  bool
  RelevantUpdateTime: number;  //  float
  TimeDilation: number;  //  float
  TimeSeconds: number;  //  float
  Year: number;  // transient int
  Month: number;  // transient int
  Day: number;  // transient int
  DayOfWeek: number;  // transient int
  Hour: number;  // transient int
  Minute: number;  // transient int
  Second: number;  // transient int
  Millisecond: number;  // transient int
  PauseDelay: number;  //  float
  PhysicsDetailLevel: any /* levelinfo.ephysicsdetaillevel */;  // config LevelInfo.EPhysicsDetailLevel
  bKNoInit: boolean;  //  bool
  DecalStayScale: number;  // config float
  LevelEnterText: string;  // localized string
  LocalizedPkg: string;  //  string
  Pauser: any /* playerreplicationinfo */;  //  PlayerReplicationInfo
  Summary: any /* levelsummary */;  //  LevelSummary
  VisibleGroups: string;  //  string
  SelectedGroups: string;  // transient string
  bLonePlayer: boolean;  //  bool
  bBegunPlay: boolean;  //  bool
  bPlayersOnly: boolean;  //  bool
  DetailMode: any /* actor.edetailmode */;  // const Actor.EDetailMode
  bDropDetail: boolean;  //  bool
  bAggressiveLOD: boolean;  //  bool
  bStartup: boolean;  //  bool
  bLowSoundDetail: boolean;  // config bool
  bPathsRebuilt: boolean;  //  bool
  bHasPathNodes: boolean;  //  bool
  bCapFramerate: boolean;  // globalconfig bool
  bLevelChange: boolean;  //  bool
  bNeverPrecache: boolean;  // config bool
  CameraLocationDynamic: THREE.Vector3;  //  Vector
  CameraLocationTop: THREE.Vector3;  //  Vector
  CameraLocationFront: THREE.Vector3;  //  Vector
  CameraLocationSide: THREE.Vector3;  //  Vector
  CameraRotationDynamic: THREE.Euler;  //  Rotator
  Brightness: number;  //  float
  DefaultTexture: any /* texture */;  //  Texture
  WireframeTexture: any /* texture */;  //  Texture
  WhiteSquareTexture: any /* texture */;  //  Texture
  LargeVertex: any /* texture */;  //  Texture
  HubStackLevel: number;  //  int
  LevelAction: any /* levelinfo.elevelaction */;  // transient LevelInfo.ELevelAction
  GRI: any /* gamereplicationinfo */;  // transient GameReplicationInfo
  NetMode: any /* levelinfo.enetmode */;  //  LevelInfo.ENetMode
  ComputerName: string;  //  string
  EngineVersion: string;  //  string
  MinNetVersion: string;  //  string
  BuildVersion: string;  //  string
  ModName: string;  //  string
  RelevancyInformation: any /* relevancyinfo */[];  //  array<RelevancyInfo>
  DefaultGameType: string;  //  string
  PreCacheGame: string;  //  string
  Game: any /* gameinfo */;  //  GameInfo
  DefaultGravity: number;  //  float
  NavigationPointList: any /* navigationpoint */;  // const NavigationPoint
  ControllerList: any /* controller */;  // const Controller
  LocalPlayerController: any /* playercontroller */;  // private PlayerController
  PawnList: any /* pawn */;  // const Pawn
  AwarenessPointList: any /* awarenesspoint */[];  // const array<AwarenessPoint>
  NextURL: string;  //  string
  bNextItems: boolean;  //  bool
  NextSwitchCountdown: number;  //  float
  ObjectPool: any /* objectpool */;  // transient ObjectPool
  PrecacheMaterials: any /* material */[];  // transient array<Material>
  PrecacheStaticMeshes: any /* staticmesh */[];  // transient array<StaticMesh>
  PrecacheMeshes: any /* mesh */[];  // transient array<Mesh>
  Platform: any /* levelinfo.eplatform */;  // config LevelInfo.EPlatform
  EffectsSystem: any /* igeffectssystembase */;  //  IGEffectsSystemBase
  InterestedActorsGameStarted: any /* actor */[];  //  array<Actor>
  MessageDispatcher: any /* messagedispatcher */;  //  MessageDispatcher
  AI_Setup: any /* tyrion_setup */;  //  Tyrion_Setup
  bGameStarted: boolean;  // private bool
  AIRepositoryClassName: string;  // config string
  AIRepo: any /* airepository */;  //  AIRepository
  EnemiesAlwaysTalkToHostages: boolean;  //  bool
  IsCOOPServer: boolean;  //  bool
  IsPlayingCOOP: boolean;  //  bool
  CurrentServerSettings: any /* actor */;  //  Actor
  PendingServerSettings: any /* actor */;  //  Actor
  TickSpecialEnabled: boolean;  //  bool
  SpawningManager: any /* ispawningmanager */;  // editinline ISpawningManager
  AnalyzeBallistics: boolean;  // config bool
  DebugFlag: boolean;  //  bool
  MoveRepSize: number;  //  float
  ReplicationViewer: any /* playercontroller */;  // const PlayerController
  ReplicationViewTarget: any /* actor */;  // const Actor

  constructor() {
    super();
  }

  // Methods
  GetGameSpyManager(): any /* gamespymanager */ {
      // no body (native/abstract)
  }

  HavokSetCollisionLayerEnabled(layerA: number, layerB: number, Enabled: boolean, updateWorldInfo: boolean): void {
      // no body (native/abstract)
  }

  HavokGetNextFreeSystemLayer(systemLayer: number): void {
      // no body (native/abstract)
  }

  DetailChange(NewDetailMode: any /* actor.edetailmode */): void {
      // no body (native/abstract)
  }

  IsEntry(): boolean {
      // no body (native/abstract)
  }

  IsTheEntryLevel(): boolean {
      // no body (native/abstract)
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  CreateEffectsSystem(): void {
      // TODO: implement
  }

  InitializeEffectsSystem(): void {
      // TODO: implement
  }

  CreateAIRepository(): void {
      // TODO: implement
  }

  GetEngine(): any /* engine */ {
      // no body (native/abstract)
  }

  GetRepo(): any /* repo */ {
      // TODO: implement
  }

  UsingCustomScenario(): boolean {
      // TODO: implement
  }

  GetGameClass(): any /* class */ {
      // TODO: implement
  }

  FillRenderPrecacheArrays(): void {
      // TODO: implement
  }

  AddPrecacheMesh(Mesh: any /* mesh */): void {
      // TODO: implement
  }

  AddPrecacheMaterial(Mat: any /* material */): void {
      // TODO: implement
  }

  AddPrecacheStaticMesh(stat: any /* staticmesh */): void {
      // TODO: implement
  }

  GetLocalURL(): string {
      // no body (native/abstract)
  }

  IsDemoBuild(): boolean {
      // no body (native/abstract)
  }

  GetAddressURL(): string {
      // no body (native/abstract)
  }

  ServerTravel(URL: string, bItems: boolean): void {
      // TODO: implement
  }

  ThisIsNeverExecuted(): void {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  InternalRegisterNotifyGameStarted(registeree: any /* actor */): void {
      // TODO: implement
  }

  NotifyGameStarted(): void {
      // TODO: implement
  }

  GuardSlow(GuardString: string): void {
      // TODO: implement
  }

  RegisterNotifyPawnDied(ObjectToNotify: any /* iinterestedpawndied */): void {
      // no body (native/abstract)
  }

  UnRegisterNotifyPawnDied(RegisteredObject: any /* iinterestedpawndied */): void {
      // no body (native/abstract)
  }

  RegisterNotifyActorDestroyed(ObjectToNotify: any /* iinterestedactordestroyed */): void {
      // no body (native/abstract)
  }

  UnRegisterNotifyActorDestroyed(RegisteredObject: any /* iinterestedactordestroyed */): void {
      // no body (native/abstract)
  }

  PreBeginPlay(): void {
      // TODO: implement
  }

  OnGameStarted(): void {
      // TODO: implement
  }

  HasGameStarted(): boolean {
      // TODO: implement
  }

  GetLocalPlayerController(): any /* playercontroller */ {
      // no body (native/abstract)
  }

  GetGameReplicationInfo(): any /* gamereplicationinfo */ {
      // TODO: implement
  }

}
