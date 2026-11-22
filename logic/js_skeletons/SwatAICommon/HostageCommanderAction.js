// Auto-generated skeleton from UnrealScript: SwatAICommon/HostageCommanderAction.uc
// Parent: CommanderAction

class HostageCommanderAction extends CommanderAction {

  // Variables
  CurrentCowerGoal: any /* cowergoal */;  // private CowerGoal
  Rescuer: any /* pawn */;  // private Pawn
  CurrentHostageReactionToOfficersGoal: any /* hostagereactiontoofficersgoal */;  // private HostageReactionToOfficersGoal
  bWasInDanger: boolean;  // private bool
  DangerUpdateTime: number;  // config float
  RescuerUpdateTime: number;  // config float
  FlashbangedMoraleModification: number;  // config float
  GassedMoraleModification: number;  // config float
  PepperSprayedMoraleModification: number;  // config float
  StungMoraleModification: number;  // config float
  TasedMoraleModification: number;  // config float
  StunnedByC2MoraleModification: number;  // config float
  ShotMoraleModification: number;  // config float
  ReactToThrownGrenadeChance: number;  // config float
  ScreamChance: number;  // config float
  PassiveCrouchWhenHearsDeadlyNoiseChance: number;  // config float
  AggressiveCrouchWhenHearsDeadlyNoiseChance: number;  // config float
  bHasHeardFirstDeadlyNoise: boolean;  // private bool
  NextTimeToPlayInDangerSpeech: number;  // private float
  MinDeltaTimeToPlayInDangerSpeech: number;  // config float
  MaxDeltaTimeToPlayInDangerSpeech: number;  // config float

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  RemoveNonDeathGoals(): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  DisableSensingSystems(): void {
      // TODO: implement
  }

  OnPawnEncounteredVisionNotification(): void {
      // TODO: implement
  }

  OnPawnLostVisionNotification(): void {
      // TODO: implement
  }

  GetShotMoraleModification(): number {
      // TODO: implement
  }

  NotifyDoorBlocked(BlockedDoor: any /* door */): void {
      // TODO: implement
  }

  GetFlashbangedMoraleModification(): number {
      // TODO: implement
  }

  GetGassedMoraleModification(): number {
      // TODO: implement
  }

  GetPepperSprayedMoraleModification(): number {
      // TODO: implement
  }

  GetStungMoraleModification(): number {
      // TODO: implement
  }

  GetTasedMoraleModification(): number {
      // TODO: implement
  }

  GetStunnedByC2DetonationMoraleModification(): number {
      // TODO: implement
  }

  PostComplianceCheck(ComplianceIssuer: any /* pawn */, bWillComply: boolean): void {
      // TODO: implement
  }

  NotifyBecameCompliant(): void {
      // TODO: implement
  }

  OnHeardNoise(): void {
      // TODO: implement
  }

  ReactToNearbyGunshot(HeardActor: any /* actor */): void {
      // TODO: implement
  }

  ShouldScream(): boolean {
      // TODO: implement
  }

  GetHeardDeadlyNoiseCrouchChance(): number {
      // TODO: implement
  }

  OnHeardDeadlyNoise(): void {
      // TODO: implement
  }

  RotateToFaceNoise(HeardPawn: any /* pawn */): void {
      // TODO: implement
  }

  WillReactToGrenadeBeingThrown(): boolean {
      // TODO: implement
  }

  OnThreatened(): void {
      // TODO: implement
  }

  IsInDanger(): boolean {
      // TODO: implement
  }

  Cower(): void {
      // TODO: implement
  }

  ReactToRescuer(): void {
      // TODO: implement
  }

}
