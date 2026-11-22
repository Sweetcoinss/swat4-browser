// Auto-generated skeleton from UnrealScript: SwatGame/SwatPlayerReplicationInfo.uc
// Parent: PlayerReplicationInfo

class SwatPlayerReplicationInfo extends PlayerReplicationInfo {

  // Variables
  NetScoreInfo: any /* netscoreinfo */;  //  NetScoreInfo
  PlayerIsReady: boolean;  // private bool
  bIsTheVIP: boolean;  //  bool
  SwatPlayerID: number;  //  int
  RespawnTime: number;  //  int
  bIsDead: boolean;  //  bool
  bIsAdmin: boolean;  // private bool
  COOPPlayerStatus: any /* swatplayerreplicationinfo.coopstatus */;  //  SwatPlayerReplicationInfo.COOPStatus

  constructor() {
    super();
  }

  // Methods
  SetAdmin(bAdmin: boolean): void {
      // TODO: implement
  }

  IsAdmin(): boolean {
      // TODO: implement
  }

  TogglePlayerIsReady(): void {
      // TODO: implement
  }

  GetPlayerIsReady(): boolean {
      // TODO: implement
  }

  ResetPlayerIsReady(): void {
      // TODO: implement
  }

  OnMissionEnded(): void {
      // TODO: implement
  }

}
