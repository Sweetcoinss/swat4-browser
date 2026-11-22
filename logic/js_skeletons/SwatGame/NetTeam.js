// Auto-generated skeleton from UnrealScript: SwatGame/NetTeam.uc
// Parent: TeamInfo

class NetTeam extends TeamInfo {

  // Variables
  NetScoreInfo: any /* netscoreinfo */;  //  NetScoreInfo
  respawnSecondsRemaining: number;  // private int
  PawnsToDestroy: any /* netplayer */[];  //  array<NetPlayer>

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  GetTeamNumber(): number {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  GetRespawnSecondsRemaining(): number {
      // TODO: implement
  }

  SetRespawnSecondsRemaining(Seconds: number): void {
      // TODO: implement
  }

  AddNetPlayerToDestroy(PawnToDestroy: any /* netplayer */): void {
      // TODO: implement
  }

  DestroyPawnsForRespawn(): void {
      // TODO: implement
  }

}
