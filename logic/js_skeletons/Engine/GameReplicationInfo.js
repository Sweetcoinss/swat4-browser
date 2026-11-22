// Auto-generated skeleton from UnrealScript: Engine/GameReplicationInfo.uc
// Parent: ReplicationInfo

class GameReplicationInfo extends ReplicationInfo {

  // Variables
  GameName: string;  //  string
  GameClass: string;  //  string
  bTeamGame: boolean;  //  bool
  bStopCountDown: boolean;  //  bool
  bMatchHasBegun: boolean;  //  bool
  bTeamSymbolsUpdated: boolean;  //  bool
  RemainingTime: number;  //  int
  ElapsedTime: number;  //  int
  RemainingMinute: number;  //  int
  SecondCount: number;  //  float
  GoalScore: number;  //  int
  TimeLimit: number;  //  int
  MaxLives: number;  //  int
  ServerName: string;  // globalconfig string
  ShortName: string;  // globalconfig string
  AdminName: string;  // globalconfig string
  AdminEmail: string;  // globalconfig string
  ServerRegion: number;  // globalconfig int
  MOTDLine1: string;  // globalconfig string
  MOTDLine2: string;  // globalconfig string
  MOTDLine3: string;  // globalconfig string
  MOTDLine4: string;  // globalconfig string
  Winner: any /* actor */;  //  Actor
  PRIArray: any /* playerreplicationinfo */[];  //  array<PlayerReplicationInfo>
  FlagPos: THREE.Vector3;  //  Vector
  MatchID: number;  //  int

  constructor() {
    super();
  }

  // Methods
  SetCarriedObjectState(Team: number, NewState: string): void {
      // TODO: implement
  }

  GetCarriedObjectState(Team: number): string {
      // TODO: implement
  }

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  TeamSymbolNotify(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  AddPRI(PRI: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  RemovePRI(PRI: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  GetPRIArray(pris: any /* playerreplicationinfo */[]): void {
      // TODO: implement
  }

  ServerChooseSoundEffectToPlay(EffectSpecification: string, Source: any /* actor */, Target: any /* actor */, TargetMaterial: any /* material */): number {
      // TODO: implement
  }

  ServerBroadcastSoundEffectSpecification(EffectSpecification: string, Source: any /* actor */, Target: any /* actor */, Material: any /* material */, overrideWorldLocation: THREE.Vector3, overrideWorldRotation: THREE.Euler, Observer: any /* ieffectobserver */, SameOnAllMachines: boolean): void {
      // TODO: implement
  }

  ServerBroadcastEffectEvent(SourceActor: any /* actor */, UniqueIdentifier: string, EffectEvent: string, Other: any /* actor */, TargetMaterial: any /* material */, HitLocation: THREE.Vector3, HitNormal: THREE.Euler, PlayOnOther: boolean, QueryOnly: boolean, Observer: any /* ieffectobserver */, ReferenceTag: string): void {
      // TODO: implement
  }

  ServerBroadcastUnTriggerEffectEvent(SourceActor: any /* actor */, UniqueIdentifier: string, EffectEvent: string, ReferenceTag: string): void {
      // TODO: implement
  }

  ServerBroadcastTrigger(SourceActor: any /* actor */, UniqueIdentifier: string, Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

}
