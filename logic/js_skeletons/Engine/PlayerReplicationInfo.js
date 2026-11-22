// Auto-generated skeleton from UnrealScript: Engine/PlayerReplicationInfo.uc
// Parent: ReplicationInfo

class PlayerReplicationInfo extends ReplicationInfo {

  // Variables
  Score: number;  //  float
  Deaths: number;  //  float
  Ping: number;  //  int
  PlayerVolume: any /* volume */;  //  Volume
  PlayerZone: any /* zoneinfo */;  //  ZoneInfo
  NumLives: number;  //  int
  PlayerName: string;  //  string
  CharacterName: string;  //  string
  OldCharacterName: string;  //  string
  OldName: string;  //  string
  PreviousName: string;  //  string
  PlayerID: number;  //  int
  Team: any /* teaminfo */;  //  TeamInfo
  TeamID: number;  //  int
  VoiceType: any /* class */;  //  Class<VoicePack>
  bAdmin: boolean;  //  bool
  bIsFemale: boolean;  //  bool
  bIsSpectator: boolean;  //  bool
  bOnlySpectator: boolean;  //  bool
  bWaitingPlayer: boolean;  //  bool
  bReadyToPlay: boolean;  //  bool
  bOutOfLives: boolean;  //  bool
  bBot: boolean;  //  bool
  bWelcomed: boolean;  //  bool
  bReceivedPing: boolean;  //  bool
  bHasFlag: boolean;  //  bool
  StartTime: number;  //  int
  StringDead: string;  // localized string
  StringSpectating: string;  // localized string
  StringUnknown: string;  // localized string
  GoalsScored: number;  //  int
  Kills: number;  //  int

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  SetCharacterName(S: string): void {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  GetLocationName(): string {
      // TODO: implement
  }

  GetPortrait(): any /* material */ {
      // TODO: implement
  }

  UpdateCharacter(): void {
      // TODO: implement
  }

  UpdatePlayerLocation(): void {
      // TODO: implement
  }

  DisplayDebug(Canvas: any /* canvas */, YL: number, YPos: number): void {
      // TODO: implement
  }

  ClientNameChange(): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  SetPlayerName(S: string): void {
      // TODO: implement
  }

  SetWaitingPlayer(B: boolean): void {
      // TODO: implement
  }

}
