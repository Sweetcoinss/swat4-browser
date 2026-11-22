// Auto-generated skeleton from UnrealScript: Engine/GameSpyManager.uc
// Parent: Object

class GameSpyManager extends Object {

  // Variables
  Engine: any /* gameengine */;  //  GameEngine
  bAvailable: boolean;  // const bool
  bFailedAvailabilityCheck: boolean;  // const bool
  bInitAsServer: boolean;  // const bool
  bInitAsClient: boolean;  // const bool
  bInitialised: boolean;  // const bool
  bFailedInitialisation: boolean;  // const bool
  bServer: boolean;  //  bool
  bTrackingStats: boolean;  // const bool
  bStatsInitalised: boolean;  // const bool
  bUsingPresence: boolean;  // const bool
  bPresenceInitalised: boolean;  // const bool
  bServerUpdateFinished: boolean;  // const bool
  currentServerIndex: number;  // const int
  ServerKeyIds: number[];  //  array<byte>
  ServerKeyNames: string[];  //  array<string>
  PlayerKeyIds: number[];  //  array<byte>
  PlayerKeyNames: string[];  //  array<string>
  TeamKeyIds: number[];  //  array<byte>
  TeamKeyNames: string[];  //  array<string>
  CustomServerKeyIds: number[];  //  array<byte>
  CustomServerKeyNames: string[];  //  array<string>
  CustomPlayerKeyIds: number[];  //  array<byte>
  CustomPlayerKeyNames: string[];  //  array<string>
  CustomTeamKeyIds: number[];  //  array<byte>
  CustomTeamKeyNames: string[];  //  array<string>

  constructor() {
    super();
  }

  // Methods
  InitGameSpyClient(): void {
      // no body (native/abstract)
  }

  GameSpyInitialised(): void {
      // TODO: implement
  }

  InitGameSpyData(): void {
      // TODO: implement
  }

  GetLevelInfo(): any /* levelinfo */ {
      // no body (native/abstract)
  }

  GetPlayerObject(): any /* player */ {
      // no body (native/abstract)
  }

  UpdateServerList(filter: string): void {
      // no body (native/abstract)
  }

  LANUpdateServerList(): void {
      // no body (native/abstract)
  }

  UpdateServer(ServerID: number, Refresh: boolean): void {
      // no body (native/abstract)
  }

  CancelUpdate(): void {
      // no body (native/abstract)
  }

  GetServerIpAddress(ServerID: number): string {
      // no body (native/abstract)
  }

  GetServerPort(ServerID: number): string {
      // no body (native/abstract)
  }

  GetNextServer(ServerID: number, ipAddress: string, serverData: string[]): boolean {
      // no body (native/abstract)
  }

  StatsNewGameStarted(): void {
      // no body (native/abstract)
  }

  StatsHasPIDAndResponse(PC: any /* playercontroller */): boolean {
      // no body (native/abstract)
  }

  StatsGetPID(PC: any /* playercontroller */): string {
      // no body (native/abstract)
  }

  StatsGetStatResponse(PC: any /* playercontroller */): string {
      // no body (native/abstract)
  }

  StatsNewPlayer(PlayerID: number, PlayerName: string): void {
      // no body (native/abstract)
  }

  StatsNewTeam(TeamID: number, TeamName: string): void {
      // no body (native/abstract)
  }

  StatsRemovePlayer(PlayerID: number): void {
      // no body (native/abstract)
  }

  StatsRemoveTeam(TeamID: number): void {
      // no body (native/abstract)
  }

  SetServerStat(statName: string, statValue: string): void {
      // no body (native/abstract)
  }

  SetPlayerStat(statName: string, statValue: string, PlayerID: number): void {
      // no body (native/abstract)
  }

  SetTeamStat(statName: string, statValue: string, TeamID: number): void {
      // no body (native/abstract)
  }

  SendStatSnapshot(finalSnapshot: boolean): void {
      // no body (native/abstract)
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

  GetValueForTeamKey(Key: number, Index: number): string {
      // TODO: implement
  }

  GetNumTeams(): number {
      // TODO: implement
  }

  GetGameSpyProfileId(): string {
      // TODO: implement
  }

  GetGameSpyPassword(): string {
      // TODO: implement
  }

  EmailAlreadyTaken(): void {
      // TODO: implement
  }

  ProfileCreateResult(Result: any /* gamespymanager.egsprofileresult */, profileId: number): void {
      // TODO: implement
  }

  ProfileCheckResult(Result: any /* gamespymanager.egsprofileresult */, profileId: number): void {
      // TODO: implement
  }

  ShouldCheckClientCDKeys(): boolean {
      // TODO: implement
  }

  CleanUpGameSpy(): void {
      // no body (native/abstract)
  }

  ShouldAdvertiseServerOnInternet(): number {
      // TODO: implement
  }

  SendServerStateChanged(): void {
      // no body (native/abstract)
  }

  IsHostCDKeyValid(): boolean {
      // no body (native/abstract)
  }

}
