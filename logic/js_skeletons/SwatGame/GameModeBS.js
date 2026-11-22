// Auto-generated skeleton from UnrealScript: SwatGame/GameModeBS.uc
// Parent: GameModeMPBase

class GameModeBS extends GameModeMPBase {

  // Variables
  DefaultNextRespawnTimerDuration: number;  // private int
  DefaultRespawnSecondsPenaltyIncrement: number;  // private int
  respawnTimer: any /* timer */;  // private Timer
  ScoreLimitForRound: number;  // private int

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

  ValidSpawnClusterForMode(theCluster: any /* swatmpstartcluster */): boolean {
      // TODO: implement
  }

  ClusterPointValidForRoundStart(thePoint: any /* swatmpstartcluster */): boolean {
      // TODO: implement
  }

  OnPawnArrested(Player: any /* pawn */, Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnPlayerDied(Player: any /* playercontroller */, Killer: any /* controller */): void {
      // TODO: implement
  }

  CheckIfRespawnIsNecessary(Player: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  IsTeamAllDead(playerWhoDied: any /* swatgameplayercontroller */, i: number): boolean {
      // TODO: implement
  }

  DecrementRespawnTimers(): void {
      // TODO: implement
  }

  NetRoundTimerExpired(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

}
