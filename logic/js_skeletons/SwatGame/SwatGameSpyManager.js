// Auto-generated skeleton from UnrealScript: SwatGame/SwatGameSpyManager.uc
// Parent: GameSpyManager

class SwatGameSpyManager extends GameSpyManager {

  // Variables
  bShouldCheckClientCDKeys: boolean;  // private bool
  __OnUpdatedServer__Delegate: any /* delegate<onupdatedserver> */;  //  delegate<OnUpdatedServer>
  __OnGameSpyInitialised__Delegate: any /* delegate<ongamespyinitialised> */;  //  delegate<OnGameSpyInitialised>

  constructor() {
    super();
  }

  // Methods
  GameSpyInitialised(): void {
      // TODO: implement
  }

  InitGameSpyData(): void {
      // TODO: implement
  }

  checkKeyIds(): void {
      // TODO: implement
  }

  checkKeyNames(): void {
      // TODO: implement
  }

  SwatGetNextServer(Server: any /* serverresponseline */): boolean {
      // TODO: implement
  }

  UpdatedServerData(ServerID: number, ipAddress: string, Ping: number, serverData: string[], playerData: string[], teamData: string[]): void {
      // TODO: implement
  }

  UpdateComplete(): void {
      // TODO: implement
  }

  GetValueForKey(Key: number): string {
      // TODO: implement
  }

  GetValueForPlayerKey(Key: number, Index: number): string {
      // TODO: implement
  }

  GetPlayerControllerFromIndex(Index: number): any /* playercontroller */ {
      // TODO: implement
  }

  ShouldCheckClientCDKeys(): boolean {
      // TODO: implement
  }

  SetShouldCheckClientCDKeys(NewValue: boolean): void {
      // TODO: implement
  }

  ShouldAdvertiseServerOnInternet(): number {
      // TODO: implement
  }

}
