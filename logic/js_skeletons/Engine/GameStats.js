// Auto-generated skeleton from UnrealScript: Engine/GameStats.uc
// Parent: Info

class GameStats extends Info {

  // Variables
  TempLog: any /* filelog */;  //  FileLog
  GRI: any /* gamereplicationinfo */;  //  GameReplicationInfo
  bShowBots: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  GetStatsIdentifier(C: any /* controller */): string {
      // no body (native/abstract)
  }

  GetMapFileName(): string {
      // no body (native/abstract)
  }

  Init(): void {
      // TODO: implement
  }

  Shutdown(): void {
      // TODO: implement
  }

  Logf(LogString: string): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  TimeStamp(): string {
      // TODO: implement
  }

  Header(): string {
      // TODO: implement
  }

  FullTimeDate(): string {
      // TODO: implement
  }

  TimeZone(): string {
      // TODO: implement
  }

  MapName(): string {
      // TODO: implement
  }

  NewGame(): void {
      // TODO: implement
  }

  ServerInfo(): void {
      // TODO: implement
  }

  StartGame(): void {
      // TODO: implement
  }

  EndGame(Reason: string): void {
      // TODO: implement
  }

  ConnectEvent(Who: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  DisconnectEvent(Who: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  ScoreEvent(Who: any /* playerreplicationinfo */, Points: number, Desc: string): void {
      // TODO: implement
  }

  TeamScoreEvent(Team: number, Points: number, Desc: string): void {
      // TODO: implement
  }

  KillEvent(KillType: string, Killer: any /* playerreplicationinfo */, Victim: any /* playerreplicationinfo */, Damage: any /* class */): void {
      // TODO: implement
  }

  SpecialEvent(Who: any /* playerreplicationinfo */, Desc: string): void {
      // TODO: implement
  }

  GameEvent(GEvent: string, Desc: string, Who: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

}
