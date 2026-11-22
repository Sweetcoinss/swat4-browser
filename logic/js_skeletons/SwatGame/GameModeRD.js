// Auto-generated skeleton from UnrealScript: SwatGame/GameModeRD.uc
// Parent: GameModeMPBase

class GameModeRD extends GameModeMPBase {

  // Variables
  respawnTimer: any /* timer */;  // private Timer
  BombsInLevel: number;  // private int
  BombsDisabled: number;  // private int

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

  OnPawnArrested(Arrestee: any /* pawn */, Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnPlayerDied(Player: any /* playercontroller */, Killer: any /* controller */): void {
      // TODO: implement
  }

  DecrementRespawnTimers(): void {
      // TODO: implement
  }

  OnBombDisabled(TheBomb: any /* bombbase */, Disarmer: any /* pawn */): void {
      // TODO: implement
  }

  NetRoundTimeRemaining(TimeRemaining: number): void {
      // TODO: implement
  }

  NetRoundTimerExpired(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

}
