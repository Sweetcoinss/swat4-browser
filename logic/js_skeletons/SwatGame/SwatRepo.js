// Auto-generated skeleton from UnrealScript: SwatGame/SwatRepo.uc
// Parent: Repo

class SwatRepo extends Repo {

  // Variables
  GuiConfig: any /* swatguiconfig */;  //  SwatGUIConfig
  PlayerController: any /* swatplayercontroller */;  //  SwatPlayerController
  AnimationSetManager: any /* animationsetmanager */;  // private AnimationSetManager
  SwatPlayerIDCounter: number;  // private int
  PlayerItems: any /* swatrepoplayeritem */[];  //  array<SwatRepoPlayerItem>
  bTravellingToNewRound: boolean;  // private bool
  bFirstRound: boolean;  //  bool
  NetRoundInProgress: boolean;  //  bool
  CumulativeDelta: number;  // private float
  LastServerTime: number;  // private float
  bDelayedFinish: boolean;  // private bool
  CriticalMomentCountdown: number;  // private float
  bFailedServerTransitionEnabled: boolean;  // private bool
  PRECACHING_FUDGE: number;  // const float
  CachedSGRI: any /* swatgamereplicationinfo */;  //  SwatGameReplicationInfo
  bInitAsNetPlayer: boolean;  //  bool
  MissionObjectives: any /* missionobjectives */;  //  MissionObjectives
  Procedures: any /* procedures */;  //  Procedures
  ConversationManager: any /* conversationmanager */;  // private ConversationManager
  TrainingTextManager: any /* trainingtextmanager */;  // private TrainingTextManager
  bShouldPerformQuickRoundReset: boolean;  // private bool

  constructor() {
    super();
  }

  // Methods
  Initialize(): void {
      // TODO: implement
  }

  PostGameEngineInit(): void {
      // TODO: implement
  }

  LoadLevel(MapName: string): void {
      // TODO: implement
  }

  StartServer(AdditionalURLOptions: string): void {
      // TODO: implement
  }

  SetPlayerController(theController: any /* swatplayercontroller */): void {
      // TODO: implement
  }

  Tick(DeltaSeconds: number): void {
      // TODO: implement
  }

  QuickServerRestart(PC: any /* playercontroller */): void {
      // TODO: implement
  }

  PerformQuickRoundReset(): void {
      // TODO: implement
  }

  PreLevelChange(thePlayer: any /* player */, MapName: string): void {
      // TODO: implement
  }

  PostLevelChange(thePlayer: any /* player */, MapName: string): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  PostPlayerLogin(thePC: any /* swatplayercontroller */): void {
      // TODO: implement
  }

  FlushBogusPlayerItems(): void {
      // TODO: implement
  }

  Logout(SGPC: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  OnMissionStarted(): void {
      // TODO: implement
  }

  OnMissionEnded(): void {
      // TODO: implement
  }

  PreClientTravel(): void {
      // TODO: implement
  }

  StateChange(NewState: any /* swatguiconfig.eswatgamestate */): void {
      // TODO: implement
  }

  RoleChange(newRole: any /* swatguiconfig.eswatgamerole */): void {
      // TODO: implement
  }

  OnCriticalMoment(): void {
      // TODO: implement
  }

  OnDelayedCriticalMoment(): void {
      // TODO: implement
  }

  FailedServerConnection(): void {
      // TODO: implement
  }

  FailedConnectionAccepted(): void {
      // TODO: implement
  }

  NetworkClientLoading(): void {
      // TODO: implement
  }

  NetworkHostLoading(): void {
      // TODO: implement
  }

  NetworkPlayerLoading(): void {
      // TODO: implement
  }

  OnDisconnected(): void {
      // TODO: implement
  }

  CheckAllPlayersReady(): void {
      // TODO: implement
  }

  AllPlayersReady(): void {
      // TODO: implement
  }

  SwapServerSettings(): void {
      // TODO: implement
  }

  NetNextRound(): void {
      // TODO: implement
  }

  NetSwitchLevels(bAdvanceToNextMap: boolean): void {
      // TODO: implement
  }

  NetQuickStartNextRound(): void {
      // TODO: implement
  }

  NetRoundStart(): void {
      // TODO: implement
  }

  OnNetRoundFinished(RoundOutcome: any /* swatgameinfo.eswatroundoutcome */): void {
      // TODO: implement
  }

  NetRoundDelayedFinish(): void {
      // TODO: implement
  }

  GetAnimationSetManager(): any /* animationsetmanager */ {
      // TODO: implement
  }

  GetNewSwatPlayerID(): number {
      // TODO: implement
  }

  GetRepoPlayerItem(SwatPlayerID: number): any /* swatrepoplayeritem */ {
      // TODO: implement
  }

  NumberOfRepoPlayerItems(): number {
      // TODO: implement
  }

  NumberOfPlayersWhoShouldReturn(): number {
      // TODO: implement
  }

  SetTravellingToNewRound(): void {
      // TODO: implement
  }

  SetDesiredEntryPoint(EntrySet: any /* swatstartpointbase.eentrytype */): void {
      // TODO: implement
  }

  GetDesiredEntryPoint(): any /* swatstartpointbase.eentrytype */ {
      // TODO: implement
  }

  GetTravellingToNewRound(): boolean {
      // TODO: implement
  }

  IsLANOnlyGame(): boolean {
      // TODO: implement
  }

  SetSGRI(SGRI: any /* swatgamereplicationinfo */): void {
      // TODO: implement
  }

  GetSGRI(): any /* swatgamereplicationinfo */ {
      // TODO: implement
  }

  GetExternalDamageModifier(Damager: any /* actor */, Victim: any /* actor */): number {
      // TODO: implement
  }

  GetFriendlyFireModifier(): number {
      // TODO: implement
  }

  GetEnemyFireModifier(): number {
      // TODO: implement
  }

  GetTrainingTextManager(): any /* trainingtextmanager */ {
      // TODO: implement
  }

  GetConversationManager(): any /* conversationmanager */ {
      // TODO: implement
  }

  NumberOfReturnedPlayers(): number {
      // TODO: implement
  }

  AnyPlayersOnServer(): boolean {
      // TODO: implement
  }

  SetObjectiveVisibility(ObjectiveName: string, Visible: boolean): void {
      // TODO: implement
  }

  ClearRoundsWon(): void {
      // TODO: implement
  }

  IncrementRoundsWon(TeamID: number): void {
      // TODO: implement
  }

  UpdateRoundsWon(TeamID: number): void {
      // TODO: implement
  }

  PreLevelChangeCleanup(): void {
      // TODO: implement
  }

  UpdateGameSpyStats(): void {
      // TODO: implement
  }

  ShouldShowSubtitles(): boolean {
      // TODO: implement
  }

}
