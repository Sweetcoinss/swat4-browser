// Auto-generated skeleton from UnrealScript: SwatGame/SwatGameInfo.uc
// Parent: GameInfo

class SwatGameInfo extends GameInfo {

  // Variables
  PrecacheMeshes: any /* mesh */[];  //  array<Mesh>
  PrecacheStaticMeshes: any /* staticmesh */[];  //  array<StaticMesh>
  PrecacheMaterials: any /* material */[];  //  array<Material>
  LevelHasFemaleCharacters: boolean;  // private bool
  bDebugFrames: boolean;  //  bool
  DebugFrameData: any /* debugframedata */[];  //  array<DebugFrameData>
  CurrentDebugFrameData: any /* debugframedata */;  //  DebugFrameData
  SpawningManager: any /* spawningmanager */;  // private SpawningManager
  Repo: any /* swatrepo */;  // private SwatRepo
  GameEvents: any /* gameeventscontainer */;  //  GameEventsContainer
  ObjectiveTimer: any /* timer */;  // private Timer
  LastPlayerStartSpot: any /* navigationpoint */;  // private NavigationPoint
  LastStartSpot: any /* navigationpoint */;  // private NavigationPoint
  PlayerStartArray: any /* playerstart */[];  //  array<PlayerStart>
  NextPlayerStartPoint: number;  // private int
  GameMode: any /* gamemode */;  // private GameMode
  PreviousNetRoundTimeRemaining: number;  // private int
  SPDamageModifierEasy: number;  // private config float
  SPDamageModifierNormal: number;  // private config float
  SPDamageModifierHard: number;  // private config float
  SPDamageModifierElite: number;  // private config float
  MPDamageModifier: number;  // private config float
  COOPDamageModifier: number;  // private config float
  NumSpawnedOfficers: number;  // private int
  DebugObjectives: boolean;  // config bool
  DebugLeadership: boolean;  // config bool
  DebugLeadershipStatus: boolean;  // config bool
  DebugSpawning: boolean;  // config bool
  bAlreadyCompleted: boolean;  // private bool
  bAlreadyFailed: boolean;  // private bool
  bAlreadyEnded: boolean;  // private bool
  ScoringUpdateInterval: number;  // private config float
  ScoringUpdateTimer: any /* timer */;  // private Timer
  ReconnectionTimer: any /* timer */;  // private Timer
  ReconnectionTime: number;  // private config float
  Admin: any /* swatadmin */;  //  SwatAdmin
  __MissionObjectiveTimeExpired__Delegate: any /* delegate<missionobjectivetimeexpired> */;  //  delegate<MissionObjectiveTimeExpired>

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  ReconnectionTimerExpired(): void {
      // TODO: implement
  }

  TestWaitingForPlayersToReconnect(): void {
      // TODO: implement
  }

  UpdateScoring(): void {
      // TODO: implement
  }

  BombExploded(): void {
      // TODO: implement
  }

  ClearTimedMissionObjective(): void {
      // TODO: implement
  }

  SetTimedMissionObjective(Objective: any /* objective */): void {
      // TODO: implement
  }

  UpdateTimedMissionObjective(): void {
      // TODO: implement
  }

  OnMissionObjectiveCompleted(Objective: any /* objective */): void {
      // TODO: implement
  }

  OnMissionObjectiveFailed(Objective: any /* objective */): void {
      // TODO: implement
  }

  MissionCompleted(): void {
      // TODO: implement
  }

  MissionFailed(): void {
      // TODO: implement
  }

  MissionEnded(): void {
      // TODO: implement
  }

  GameAbort(): void {
      // TODO: implement
  }

  OnCriticalMoment(): void {
      // TODO: implement
  }

  OnEvidenceSecured(Secured: any /* ievidence */): void {
      // TODO: implement
  }

  OnReportableReportedToTOC(ReportableCharacter: any /* iamreportablecharacter */, Reporter: any /* pawn */): void {
      // TODO: implement
  }

  InitGameReplicationInfo(): void {
      // TODO: implement
  }

  InitializeGameMode(): void {
      // TODO: implement
  }

  GetGameMode(): any /* gamemode */ {
      // TODO: implement
  }

  GetGameModeName(): string {
      // TODO: implement
  }

  GetServerInfo(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  GetServerDetails(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  GetServerPlayers(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  GetSpawningManager(): any /* spawningmanager */ {
      // TODO: implement
  }

  GetCustomScenario(): any /* customscenario */ {
      // TODO: implement
  }

  UsingCustomScenario(): boolean {
      // TODO: implement
  }

  CampaignObjectivesAreInEffect(): boolean {
      // TODO: implement
  }

  PostGameStarted(): void {
      // TODO: implement
  }

  OnGameStarted(): void {
      // TODO: implement
  }

  OnMissionStarted(): void {
      // TODO: implement
  }

  GameInfoShouldTick(): boolean {
      // TODO: implement
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

  NetRoundTimeRemaining(TimeRemaining: number): void {
      // TODO: implement
  }

  NetRoundTimerExpired(): void {
      // TODO: implement
  }

  DumpEffects(SystemName: string): void {
      // TODO: implement
  }

  DebugFrames(Option: string, Param: string): void {
      // TODO: implement
  }

  AddDebugFrameData(): void {
      // TODO: implement
  }

  GuardSlow(GuardString: string): void {
      // TODO: implement
  }

  AddDefaultInventory(inPlayerPawn: any /* pawn */): void {
      // TODO: implement
  }

  MissionStatus(): void {
      // TODO: implement
  }

  LeadershipStatus(): number {
      // TODO: implement
  }

  FindPlayerStart(Player: any /* controller */, InTeam: number, incomingName: string): any /* navigationpoint */ {
      // TODO: implement
  }

  RatePlayerStart(n: any /* navigationpoint */, Team: number, Player: any /* controller */): number {
      // TODO: implement
  }

  SetStartClustersForRoundStart(): void {
      // TODO: implement
  }

  AssignPlayerRoles(): void {
      // TODO: implement
  }

  RespawnAll(): void {
      // TODO: implement
  }

  AtCapacity(bSpectator: boolean): boolean {
      // TODO: implement
  }

  Login(Portal: string, Options: string, Error: string): any /* playercontroller */ {
      // TODO: implement
  }

  PostLogin(NewPlayer: any /* playercontroller */): void {
      // TODO: implement
  }

  PlayerLoggedIn(NewPlayer: any /* playercontroller */): void {
      // TODO: implement
  }

  Logout(Exiting: any /* controller */): void {
      // TODO: implement
  }

  ShouldSpawnOfficerRedOne(): boolean {
      // TODO: implement
  }

  ShouldSpawnOfficerRedTwo(): boolean {
      // TODO: implement
  }

  ShouldSpawnOfficerBlueOne(): boolean {
      // TODO: implement
  }

  ShouldSpawnOfficerBlueTwo(): boolean {
      // TODO: implement
  }

  ShouldSpawnOfficerAtStart(OfficerStart: any /* swatofficerstart */, DesiredEntryType: any /* swatstartpointbase.eentrytype */): boolean {
      // TODO: implement
  }

  SpawnOfficers(): void {
      // TODO: implement
  }

  GetNumSpawnedOfficers(): number {
      // TODO: implement
  }

  RestartPlayer(aPlayer: any /* controller */): void {
      // TODO: implement
  }

  SpawnNetPlayerPawn(aPlayer: any /* controller */): any /* swatmpstartpoint */ {
      // TODO: implement
  }

  GetTeamFromID(TeamID: number): any /* netteam */ {
      // TODO: implement
  }

  Broadcast(Sender: any /* actor */, msg: string, Type: string): void {
      // TODO: implement
  }

  BroadcastTeam(Sender: any /* controller */, msg: string, Type: string): void {
      // TODO: implement
  }

  BroadcastObservers(Sender: any /* controller */, msg: string, Type: string): void {
      // TODO: implement
  }

  BroadcastDeathMessage(Killer: any /* controller */, Other: any /* controller */, DamageType: any /* class */): void {
      // TODO: implement
  }

  BroadcastArrestedMessage(Killer: any /* controller */, Other: any /* controller */): void {
      // TODO: implement
  }

  Killed(Killer: any /* controller */, Killed: any /* controller */, KilledPawn: any /* pawn */, DamageType: any /* class */): void {
      // TODO: implement
  }

  SetPlayerTeam(Player: any /* swatgameplayercontroller */, TeamID: number): void {
      // TODO: implement
  }

  AutoSetPlayerTeam(Player: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  GetAutoJoinTeamID(): number {
      // TODO: implement
  }

  ChangePlayerTeam(Player: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  SetPlayerReady(Player: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  SetPlayerNotReady(Player: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  TogglePlayerReady(Player: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  logPlayerReadyValues(): void {
      // TODO: implement
  }

  PlayerLateStart(Player: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  NumberOfPlayersForServerBrowser(): number {
      // TODO: implement
  }

  MaxPlayersForServerBrowser(): number {
      // TODO: implement
  }

  GameIsPasswordProtected(): boolean {
      // TODO: implement
  }

  GetPlayerName(PC: any /* playercontroller */): string {
      // TODO: implement
  }

  GetPlayerScore(PC: any /* playercontroller */): number {
      // TODO: implement
  }

  GetPlayerPing(PC: any /* playercontroller */): number {
      // TODO: implement
  }

  ReduceDamage(Damage: number, injured: any /* pawn */, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): number {
      // TODO: implement
  }

  DetailChange(): void {
      // TODO: implement
  }

  PreQuickRoundRestart(): void {
      // TODO: implement
  }

  OnServerSettingsUpdated(Admin: any /* controller */): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  SetLevelHasFemaleCharacters(): void {
      // TODO: implement
  }

  AddMesh(inMesh: any /* mesh */): void {
      // TODO: implement
  }

  AddMaterial(inMaterial: any /* material */): void {
      // TODO: implement
  }

  AddStaticMesh(inStaticMesh: any /* staticmesh */): void {
      // TODO: implement
  }

  PrecacheOnClient(SGPC: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

}
