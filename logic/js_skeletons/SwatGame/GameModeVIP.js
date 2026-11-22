// Auto-generated skeleton from UnrealScript: SwatGame/GameModeVIP.uc
// Parent: GameModeMPBase

class GameModeVIP extends GameModeMPBase {

  // Variables
  respawnTimer: any /* timer */;  // private Timer
  VIPVestMaterial: any /* material */;  // private Material
  DefaultVIPArrestedCountdown: number;  // private int
  VIPArrestedCountdown: number;  // private int
  VIPArrestedTimer: any /* timer */;  // private Timer
  VIPArrestedTimerExpired: boolean;  // private bool
  VIPGoals: any /* vipgoalbase */[];  //  array<VIPGoalBase>
  bHasRoundEnded: boolean;  // private bool
  PlayersOnSWATTeam: any /* swatgameplayercontroller */[];  //  array<SwatGamePlayerController>
  PlayersOnSuspectsTeam: any /* swatgameplayercontroller */[];  //  array<SwatGamePlayerController>

  constructor() {
    super();
  }

  // Methods
  OnMissionEnded(): void {
      // TODO: implement
  }

  Initialize(): void {
      // TODO: implement
  }

  OnMissionStarted(): void {
      // TODO: implement
  }

  AssignPlayerRoles(): void {
      // TODO: implement
  }

  ValidSpawnClusterForMode(theCluster: any /* swatmpstartcluster */): boolean {
      // TODO: implement
  }

  ClusterPointValidForRoundStart(thePoint: any /* swatmpstartcluster */): boolean {
      // TODO: implement
  }

  OnPawnArrested(Arrestee: any /* pawn */, Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnPlayerDied(Player: any /* playercontroller */, Killer: any /* controller */): void {
      // TODO: implement
  }

  OnPawnUnarrestBegan(Arrester: any /* pawn */, Arrestee: any /* pawn */): void {
      // TODO: implement
  }

  OnPawnUnarrested(Arrester: any /* pawn */, Arrestee: any /* pawn */): void {
      // TODO: implement
  }

  VIPIsInGoal(VIPPawn: any /* pawn */, TheGoal: any /* vipgoalbase */): boolean {
      // TODO: implement
  }

  OnVIPReachedGoal(triggerer: any /* swatplayer */): void {
      // TODO: implement
  }

  HandleSWATWonRound(VIPPlayer: any /* swatplayer */): void {
      // TODO: implement
  }

  DecrementRespawnTimers(): void {
      // TODO: implement
  }

  NetRoundTimerExpired(): void {
      // TODO: implement
  }

  DecrementVIPArrestedTimer(): void {
      // TODO: implement
  }

  DisplayBroadcastMessage(Message: string, Event: string): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

}
