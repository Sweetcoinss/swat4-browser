// Auto-generated skeleton from UnrealScript: SwatGame/GameModeMPBase.uc
// Parent: GameMode

class GameModeMPBase extends GameMode {

  // Variables
  bIsRespawningEnabled: boolean;  // private bool
  Team0StartClusters: any /* swatmpstartcluster */[];  //  array<SwatMPStartCluster>
  Team1StartClusters: any /* swatmpstartcluster */[];  //  array<SwatMPStartCluster>
  DefaultRespawnSecondsRemaining: number;  // config int
  InterestingViewTarget: any /* actor */;  // private Actor
  EndRoundSequenceTimer: any /* timer */;  // private Timer
  NotifiedOneMinuteWarning: boolean;  // private bool
  NotifiedTenSecondsWarning: boolean;  // private bool

  constructor() {
    super();
  }

  // Methods
  OnMissionStarted(): void {
      // TODO: implement
  }

  OnMissionEnded(): void {
      // TODO: implement
  }

  EndGame(): void {
      // TODO: implement
  }

  Initialize(): void {
      // TODO: implement
  }

  ValidSpawnClusterForMode(theCluster: any /* swatmpstartcluster */): boolean {
      // TODO: implement
  }

  AssignPlayerRoles(): void {
      // TODO: implement
  }

  SetStartClustersForRoundStart(): void {
      // TODO: implement
  }

  ClusterPointValidForRoundStart(thePoint: any /* swatmpstartcluster */): boolean {
      // TODO: implement
  }

  SetSpawnClusterEnabled(ClusterName: string, SetEnabled: boolean): void {
      // TODO: implement
  }

  SetSpawnClusterEnabledForArray(TeamStartClusters: any /* swatmpstartcluster */[], ClusterName: string, SetEnabled: boolean): void {
      // TODO: implement
  }

  SetStartClusterForRespawn(TeamID: number): void {
      // TODO: implement
  }

  CalculateBestRespawnCluster(outCluster: any /* swatmpstartcluster */, TeamStartClusters: any /* swatmpstartcluster */[], EnemyTeamID: number): void {
      // TODO: implement
  }

  CalculateClusterDistanceFromEnemyPawns(TeamStartCluster: any /* swatmpstartcluster */, EnemyTeamID: number): number {
      // TODO: implement
  }

  CalculateClusterDistanceFromPawn(FromTeamStartCluster: any /* swatmpstartcluster */, ToPawn: any /* pawn */): number {
      // no body (native/abstract)
  }

  FindNetPlayerStart(Player: any /* controller */): any /* swatmpstartpoint */ {
      // TODO: implement
  }

  SpawnPointCanBeUsed(thePoint: any /* actor */): boolean {
      // TODO: implement
  }

  RespawnReinforcements(TeamID: number): void {
      // TODO: implement
  }

  NetRoundTimeRemaining(TimeRemaining: number): void {
      // TODO: implement
  }

  OnPawnArrested(Player: any /* pawn */, Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnPlayerDied(Player: any /* playercontroller */, Killer: any /* controller */): void {
      // TODO: implement
  }

  OnPawnDied(Pawn: any /* pawn */, Killer: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  PlayerJoinedTeam(Player: any /* swatgameplayercontroller */, Team: number): void {
      // TODO: implement
  }

  RespawnAll(): void {
      // TODO: implement
  }

  IsRespawningEnabled(): boolean {
      // TODO: implement
  }

  DecrementRespawnTimer(Team: number): void {
      // TODO: implement
  }

  UpdatePlayerDeathFlags(Team: number): void {
      // TODO: implement
  }

  OnRespawnTimerAtZero(Team: number): void {
      // TODO: implement
  }

  DisplayRespawnTimer(Team: number): void {
      // TODO: implement
  }

  NetRoundFinished(RoundOutcome: any /* swatgameinfo.eswatroundoutcome */): void {
      // TODO: implement
  }

  SetAllPawnsRelevent(): void {
      // TODO: implement
  }

  StartEndRoundSequence(): void {
      // TODO: implement
  }

  SetEndRoundTarget(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  DestroyAllPawns(): void {
      // TODO: implement
  }

}
