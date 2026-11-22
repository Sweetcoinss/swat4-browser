// Auto-generated skeleton from UnrealScript: SwatGame/SwatGameReplicationInfo.uc
// Parent: GameReplicationInfo

class SwatGameReplicationInfo extends GameReplicationInfo {

  // Variables
  ServerCountdownTime: number;  //  float
  ShowTeammateNames: number;  //  int
  ShowEnemyNames: number;  //  int
  TotalNumberOfBombs: number;  //  int
  DiffusedBombs: number;  //  int
  RoundTime: number;  //  int
  SpecialTime: number;  //  int
  TimedObjectiveIndex: number;  //  int
  bWaitingForPlayers: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  PostNetBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  AddPRI(PRI: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  RemovePRI(PRI: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  NumPlayers(): number {
      // TODO: implement
  }

  SetWaitingForPlayers(WaitingForReconnects: boolean): void {
      // TODO: implement
  }

  AllPlayersAreReady(): boolean {
      // TODO: implement
  }

  ResetPlayerReadyValues(): boolean {
      // TODO: implement
  }

  ResetPlayerScoresForMPQuickRestart(): void {
      // TODO: implement
  }

  LogScoring(Repo: any /* swatrepo */): void {
      // TODO: implement
  }

  ClearScoring(): void {
      // TODO: implement
  }

  NotifyClientsToInterruptAndGotoState(thePlayer: any /* pawn */, Reason: string, NewControllerState: string, NewPawnState: string): void {
      // TODO: implement
  }

  NotifyClientsToInterruptState(thePlayer: any /* pawn */, Reason: string): void {
      // TODO: implement
  }

  ServerTriggerDynamicMusic(): void {
      // TODO: implement
  }

  SetObjectiveVisibility(ObjectiveName: string, Visible: boolean): void {
      // TODO: implement
  }

  OnMissionEnded(): void {
      // TODO: implement
  }

  ServerChooseSoundEffectToPlay(EffectSpecification: string, Source: any /* actor */, Target: any /* actor */, TargetMaterial: any /* material */): number {
      // TODO: implement
  }

}
