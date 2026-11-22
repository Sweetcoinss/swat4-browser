// Auto-generated skeleton from UnrealScript: Engine/GameInfo.uc
// Parent: Info

class GameInfo extends Info {

  // Variables
  Controller: any /* controller */;  //  Controller
  IpAddr: number;  //  int
  Handle: number;  //  int
  bChangingLevels: boolean;  //  bool
  bRestartLevel: boolean;  //  bool
  bPauseable: boolean;  //  bool
  bCanChangeSkin: boolean;  //  bool
  bTeamGame: boolean;  //  bool
  bGameEnded: boolean;  //  bool
  bOverTime: boolean;  //  bool
  bAlternateMode: boolean;  // localized bool
  bCanViewOthers: boolean;  //  bool
  bDelayedStart: boolean;  //  bool
  bWaitingToStartMatch: boolean;  //  bool
  bChangeLevels: boolean;  // globalconfig bool
  bAlreadyChanged: boolean;  //  bool
  bLoggingGame: boolean;  //  bool
  bEnableStatLogging: boolean;  // globalconfig bool
  bAllowWeaponThrowing: boolean;  // config bool
  bAllowBehindView: boolean;  // config bool
  bAdminCanPause: boolean;  // globalconfig bool
  bGameRestarted: boolean;  //  bool
  bKeepSamePlayerStart: boolean;  //  bool
  bPostGameStarted: boolean;  //  bool
  GameDifficulty: number;  // globalconfig float
  GoreLevel: number;  // globalconfig int
  AutoAim: number;  // globalconfig float
  GameSpeed: number;  // globalconfig float
  StartTime: number;  //  float
  DefaultPlayerClassName: string;  //  string
  ScoreBoardType: string;  //  string
  BotMenuType: string;  //  string
  RulesMenuType: string;  //  string
  SettingsMenuType: string;  //  string
  GameUMenuType: string;  //  string
  MultiplayerUMenuType: string;  //  string
  GameOptionsMenuType: string;  //  string
  HUDType: string;  //  string
  MapListType: string;  //  string
  MapPrefix: string;  //  string
  BeaconName: string;  //  string
  MaxSpectators: number;  // globalconfig int
  NumSpectators: number;  //  int
  MaxPlayers: number;  // globalconfig int
  NumPlayers: number;  //  int
  NumBots: number;  //  int
  CurrentID: number;  //  int
  DefaultPlayerName: string;  // localized string
  GameName: string;  // localized string
  GameModeString: string;  //  string
  FearCostFallOff: number;  //  float
  GoalScore: number;  // config int
  MaxLives: number;  // config int
  TimeLimit: number;  // config int
  DeathMessageClass: any /* class */;  //  Class<LocalMessage>
  GameMessageClass: any /* class */;  //  Class<GameMessage>
  OtherMesgGroup: string;  //  name
  MutatorClass: string;  //  string
  BaseMutator: any /* mutator */;  //  Mutator
  AccessControlClass: string;  // globalconfig string
  AccessControl: any /* accesscontrol */;  //  AccessControl
  GameRulesModifiers: any /* gamerules */;  //  GameRules
  BroadcastHandlerClass: string;  //  string
  BroadcastHandler: any /* broadcasthandler */;  //  BroadcastHandler
  PlayerControllerClass: any /* class */;  //  Class<PlayerController>
  PlayerControllerClassName: string;  //  string
  GameReplicationInfoClass: any /* class */;  //  Class<GameReplicationInfo>
  GameReplicationInfo: any /* gamereplicationinfo */;  //  GameReplicationInfo
  bWelcomePending: boolean;  //  bool
  GameStats: any /* gamestats */;  //  GameStats
  GameStatsClass: string;  // globalconfig string
  VoiceChatters: any /* voicechatterinfo */[];  //  array<VoiceChatterInfo>
  SecurityClass: string;  // globalconfig string
  ScreenShotName: string;  //  string
  DecoTextName: string;  //  string
  Acronym: string;  //  string
  bGameStarted: boolean;  // private transient bool

  constructor() {
    super();
  }

  // Methods
  NotifyGameStarted(): void {
      // TODO: implement
  }

  FindOpenSpot(Extent: THREE.Vector3, Location: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  PreBeginPlay(): void {
      // TODO: implement
  }

  GameInfoShouldTick(): boolean {
      // TODO: implement
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

  UpdatePrecacheRenderData(): void {
      // TODO: implement
  }

  PrecacheGameRenderData(myLevel: any /* levelinfo */): void {
      // TODO: implement
  }

  FindPlayerByID(PlayerID: number): string {
      // TODO: implement
  }

  UseLowGore(): boolean {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  InitLogging(): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  GameEnding(): void {
      // TODO: implement
  }

  InitGameReplicationInfo(): void {
      // TODO: implement
  }

  GetNetworkNumber(): string {
      // no body (native/abstract)
  }

  GetServerInfo(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  GetNumPlayers(): number {
      // TODO: implement
  }

  GetServerDetails(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  GetServerPlayers(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  GetServerPort(): number {
      // TODO: implement
  }

  SetPause(bPause: boolean, P: any /* playercontroller */): boolean {
      // TODO: implement
  }

  ChangeVoiceChatter(Client: any /* controller */, IpAddr: number, Handle: number, Add: boolean): void {
      // TODO: implement
  }

  SetGameSpeed(t: number): void {
      // TODO: implement
  }

  DetailChange(): void {
      // TODO: implement
  }

  GrabOption(Options: string, Result: string): boolean {
      // TODO: implement
  }

  GetKeyValue(Pair: string, Key: string, Value: string): void {
      // TODO: implement
  }

  ParseOption(Options: string, InKey: string): string {
      // TODO: implement
  }

  HasOption(Options: string, InKey: string): boolean {
      // TODO: implement
  }

  InitGame(Options: string, Error: string): void {
      // TODO: implement
  }

  AddMutator(mutname: string, bUserAdded: boolean): void {
      // TODO: implement
  }

  GetBeaconText(): string {
      // TODO: implement
  }

  ProcessServerTravel(URL: string, bItems: boolean): void {
      // TODO: implement
  }

  PreLogin(Options: string, Address: string, Error: string, FailCode: string): void {
      // TODO: implement
  }

  GetIntOption(Options: string, ParseString: string, CurrentValue: number): number {
      // TODO: implement
  }

  AtCapacity(bSpectator: boolean): boolean {
      // TODO: implement
  }

  Login(Portal: string, Options: string, Error: string): any /* playercontroller */ {
      // TODO: implement
  }

  StartMatch(): void {
      // TODO: implement
  }

  RestartPlayer(aPlayer: any /* controller */): void {
      // TODO: implement
  }

  SpawnPlayerPawn(aPlayer: any /* controller */, TeamNum: number): any /* navigationpoint */ {
      // TODO: implement
  }

  GetDefaultPlayerClass(C: any /* controller */): any /* class */ {
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

  AcceptInventory(PlayerPawn: any /* pawn */): void {
      // TODO: implement
  }

  AddGameSpecificInventory(P: any /* pawn */): void {
      // TODO: implement
  }

  AddDefaultInventory(PlayerPawn: any /* pawn */): void {
      // TODO: implement
  }

  SetPlayerDefaults(PlayerPawn: any /* pawn */): void {
      // TODO: implement
  }

  NotifyKilled(Killer: any /* controller */, Killed: any /* controller */, KilledPawn: any /* pawn */): void {
      // TODO: implement
  }

  KillEvent(KillType: string, Killer: any /* playerreplicationinfo */, Victim: any /* playerreplicationinfo */, Damage: any /* class */): void {
      // TODO: implement
  }

  Killed(Killer: any /* controller */, Killed: any /* controller */, KilledPawn: any /* pawn */, DamageType: any /* class */): void {
      // TODO: implement
  }

  PreventDeath(Killed: any /* pawn */, Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3): boolean {
      // TODO: implement
  }

  PreventSever(Killed: any /* pawn */, BoneName: string, Damage: number, DamageType: any /* class */): boolean {
      // TODO: implement
  }

  BroadcastDeathMessage(Killer: any /* controller */, Other: any /* controller */, DamageType: any /* class */): void {
      // TODO: implement
  }

  ParseKillMessage(KillerName: string, VictimName: string, DeathMessage: string): string {
      // no body (native/abstract)
  }

  Kick(Kicker: any /* controller */, Kickee: string): void {
      // TODO: implement
  }

  KickBan(Kicker: any /* controller */, Kickee: string): void {
      // TODO: implement
  }

  IsOnTeam(Other: any /* controller */, TeamNum: number): boolean {
      // TODO: implement
  }

  CanSpectate(Viewer: any /* playercontroller */, bOnlySpectator: boolean, ViewTarget: any /* actor */): boolean {
      // TODO: implement
  }

  ReduceDamage(Damage: number, injured: any /* pawn */, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): number {
      // TODO: implement
  }

  DiscardInventory(Other: any /* pawn */): void {
      // TODO: implement
  }

  ChangeName(Other: any /* controller */, S: string, bNameChange: boolean): void {
      // TODO: implement
  }

  ChangeTeam(Other: any /* controller */, n: number, bNewTeam: boolean): boolean {
      // TODO: implement
  }

  PickTeam(Current: number, C: any /* controller */): number {
      // TODO: implement
  }

  SendPlayer(aPlayer: any /* playercontroller */, URL: string): void {
      // TODO: implement
  }

  RestartGame(): void {
      // TODO: implement
  }

  GetMapList(MapListType: string): any /* maplist */ {
      // TODO: implement
  }

  Broadcast(Sender: any /* actor */, msg: string, Type: string): void {
      // TODO: implement
  }

  BroadcastTeam(Sender: any /* controller */, msg: string, Type: string): void {
      // TODO: implement
  }

  BroadcastLocalized(Sender: any /* actor */, Message: any /* class */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): void {
      // TODO: implement
  }

  CheckEndGame(Winner: any /* playerreplicationinfo */, Reason: string): boolean {
      // TODO: implement
  }

  EndGame(Winner: any /* playerreplicationinfo */, Reason: string): void {
      // TODO: implement
  }

  EndLogging(Reason: string): void {
      // TODO: implement
  }

  FindPlayerStart(Player: any /* controller */, InTeam: number, incomingName: string): any /* navigationpoint */ {
      // TODO: implement
  }

  RatePlayerStart(n: any /* navigationpoint */, Team: number, Player: any /* controller */): number {
      // TODO: implement
  }

  ScoreObjective(Scorer: any /* playerreplicationinfo */, Score: number): void {
      // TODO: implement
  }

  CheckScore(Scorer: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  ScoreEvent(Who: any /* playerreplicationinfo */, Points: number, Desc: string): void {
      // TODO: implement
  }

  TeamScoreEvent(Team: number, Points: number, Desc: string): void {
      // TODO: implement
  }

  ScoreKill(Killer: any /* controller */, Other: any /* controller */): void {
      // TODO: implement
  }

  TooManyBots(botToRemove: any /* controller */): boolean {
      // TODO: implement
  }

  FindTeamDesignation(GRI: any /* gamereplicationinfo */, A: any /* actor */): string {
      // TODO: implement
  }

  ParseMessageString(BaseMutator: any /* mutator */, Who: any /* controller */, Message: string): string {
      // TODO: implement
  }

  ReviewJumpSpots(TestLabel: string): void {
      // TODO: implement
  }

  OtherTeam(Requester: any /* teaminfo */): any /* teaminfo */ {
      // TODO: implement
  }

  KillBots(Num: number): void {
      // TODO: implement
  }

  AdminSay(msg: string): void {
      // TODO: implement
  }

  GetNumSpawnedOfficers(): number {
      // TODO: implement
  }

  CampaignObjectivesAreInEffect(): boolean {
      // TODO: implement
  }

  NumberOfPlayersForServerBrowser(): number {
      // TODO: implement
  }

  MaxPlayersForServerBrowser(): number {
      // TODO: implement
  }

  GetGameModeName(): string {
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

  UsingCustomScenario(): boolean {
      // TODO: implement
  }

}
