// Auto-generated skeleton from UnrealScript: SwatAICommon/CommanderAction.uc
// Parent: SwatCharacterAction

class CommanderAction extends SwatCharacterAction {

  // Variables
  ChangeAmount: number;  //  float
  ReasonForChange: string;  //  string
  CurrentRestrainedGoal: any /* restrainedgoal */;  // private RestrainedGoal
  CurrentFlashbangedGoal: any /* flashbangedgoal */;  // private FlashbangedGoal
  CurrentGassedGoal: any /* gassedgoal */;  // private GassedGoal
  CurrentPepperSprayedGoal: any /* peppersprayedgoal */;  // private PepperSprayedGoal
  CurrentPatrolGoal: any /* patrolgoal */;  // private PatrolGoal
  CurrentIncapacitatedGoal: any /* incapacitatedgoal */;  // private IncapacitatedGoal
  CurrentIdleGoal: any /* idlegoal */;  // private IdleGoal
  CurrentReactToBeingShotGoal: any /* reacttobeingshotgoal */;  // private ReactToBeingShotGoal
  CurrentTasedGoal: any /* tasedgoal */;  // private TasedGoal
  CurrentStunnedByC2Goal: any /* stunnedbyc2goal */;  // private StunnedByC2Goal
  CurrentStungGoal: any /* stunggoal */;  // private StungGoal
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  CurrentRotateTowardActorGoal: any /* rotatetowardactorgoal */;  // private RotateTowardActorGoal
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  CurrentAimAtTargetGoal: any /* aimattargetgoal */;  // private AimAtTargetGoal
  CurrentAvoidLocationGoal: any /* avoidlocationgoal */;  // private AvoidLocationGoal
  HearingSensor: any /* hearingsensor */;  // private HearingSensor
  VisionSensor: any /* visionsensor */;  // private VisionSensor
  ThreatenedSensor: any /* threatenedsensor */;  // private ThreatenedSensor
  ComplySensor: any /* complysensor */;  // private ComplySensor
  MoraleHistory: any /* moralehistoryentry */[];  //  array<MoraleHistoryEntry>
  CurrentMorale: number;  // private float
  CurrentComplianceGoal: any /* compliancegoal */;  // private ComplianceGoal
  bListeningForCompliance: boolean;  // private bool
  ComplianceOrdersIgnored: number;  // private int
  MaxComplianceOrdersToIgnore: number;  // config int
  MaxMorale: number;  // config float
  ScreamTimer: any /* timer */;  // private Timer
  MinScreamTime: number;  // config float
  MaxScreamTime: number;  // config float
  MinReactToGunshotDistance: number;  // config float

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  ActivateVisionSensor(): void {
      // TODO: implement
  }

  ActivateHearingSensor(): void {
      // TODO: implement
  }

  ActivateThreatenedSensor(): void {
      // TODO: implement
  }

  ActivateComplySensor(): void {
      // TODO: implement
  }

  InitializeMorale(): void {
      // TODO: implement
  }

  FindIdleGoal(): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  ShouldRemoveFailedPatrolGoal(): boolean {
      // TODO: implement
  }

  goalAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */): void {
      // TODO: implement
  }

  IsDeadlyNoise(SoundCategory: string): boolean {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  OnPawnEncounteredVisionNotification(): void {
      // TODO: implement
  }

  OnPawnLostVisionNotification(): void {
      // TODO: implement
  }

  OnHeardNoise(): void {
      // TODO: implement
  }

  OnThreatened(): void {
      // TODO: implement
  }

  OnNoLongerThreatened(): void {
      // TODO: implement
  }

  HasLineOfSightToDoor(TestDoor: any /* door */): boolean {
      // TODO: implement
  }

  OnComplianceIssued(ComplianceIssuer: any /* pawn */): void {
      // TODO: implement
  }

  PreComplianceCheck(ComplianceIssuer: any /* pawn */): void {
      // TODO: implement
  }

  PostComplianceCheck(ComplianceIssuer: any /* pawn */, bWillComply: boolean): void {
      // TODO: implement
  }

  IsIgnoringComplianceOrders(): boolean {
      // no body (native/abstract)
  }

  IsListeningForCompliance(): boolean {
      // TODO: implement
  }

  DisableSensingSystems(): void {
      // TODO: implement
  }

  PostComplianceGoal(): void {
      // TODO: implement
  }

  NotifyBecameCompliant(): void {
      // TODO: implement
  }

  RemoveComplianceGoal(): void {
      // TODO: implement
  }

  NotifyBeginArrest(inRestrainer: any /* pawn */): void {
      // TODO: implement
  }

  NotifyArrestInterrupted(): void {
      // TODO: implement
  }

  NotifyRestrained(): void {
      // TODO: implement
  }

  IsRestrainedGoalRunning(): boolean {
      // TODO: implement
  }

  ResetIdling(): void {
      // TODO: implement
  }

  StartPatrolling(): void {
      // TODO: implement
  }

  BecomeIncapacitated(IncapaciatedIdleCategoryOverride: string): void {
      // TODO: implement
  }

  RemoveIdleGoal(): void {
      // TODO: implement
  }

  RemoveNonDeathGoals(): void {
      // TODO: implement
  }

  RemoveGoalsToDie(): void {
      // TODO: implement
  }

  OnSkeletalRegionHit(RegionHit: any /* actor.eskeletalregion */, HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, Damage: number, DamageType: any /* class */): void {
      // TODO: implement
  }

  NotifyTookHit(): void {
      // TODO: implement
  }

  GetShotMoraleModification(): number {
      // TODO: implement
  }

  Scream(): void {
      // TODO: implement
  }

  TriggerScreamSpeech(): void {
      // TODO: implement
  }

  ShouldScream(): boolean {
      // TODO: implement
  }

  PlayFlinch(): void {
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

  ShouldRunWhenFlashBanged(): boolean {
      // TODO: implement
  }

  ShouldRunWhenGassed(): boolean {
      // TODO: implement
  }

  ShouldRunWhenPepperSprayed(): boolean {
      // TODO: implement
  }

  ShouldRunWhenStung(): boolean {
      // TODO: implement
  }

  ShouldRunWhenTased(): boolean {
      // TODO: implement
  }

  ShouldRunWhenStunnedByC2(): boolean {
      // TODO: implement
  }

  NotifyFlashbanged(FlashbangLocation: THREE.Vector3, StunnedDuration: number): void {
      // TODO: implement
  }

  NotifyGassed(GasContainerLocation: THREE.Vector3, StunnedDuration: number): void {
      // TODO: implement
  }

  NotifyPepperSprayed(PepperSprayLocation: THREE.Vector3, StunnedDuration: number): void {
      // TODO: implement
  }

  IsAffectedByPepperSpray(): boolean {
      // TODO: implement
  }

  NotifyTased(TaserLocation: THREE.Vector3, StunnedDuration: number): void {
      // TODO: implement
  }

  NotifyStunnedByC2Detonation(C2ChargeLocation: THREE.Vector3, StunnedDuration: number): void {
      // TODO: implement
  }

  NotifyStung(Grenade: any /* actor */, StungGrenadeLocation: THREE.Vector3, StunnedDuration: number): void {
      // TODO: implement
  }

  WillReactToGrenadeBeingThrown(): boolean {
      // TODO: implement
  }

  NotifyGrenadeThrown(ThrownGrenade: any /* swatgrenadeprojectile */): void {
      // TODO: implement
  }

  GetCurrentMorale(): number {
      // TODO: implement
  }

  ChangeMorale(inChangeAmount: number, inReasonForChange: string, bDoNotStartListeningForCompliance: boolean): void {
      // TODO: implement
  }

  GetMoraleHistoryCount(): number {
      // TODO: implement
  }

  GetMoraleHistoryEntrySummary(Index: number): string {
      // TODO: implement
  }

  RotateToFace(Target: any /* actor */, BehaviorPriority: number): void {
      // TODO: implement
  }

  RotateToRotation(Rotation: THREE.Euler, BehaviorPriority: number): void {
      // TODO: implement
  }

  AimAtTarget(Target: any /* actor */, BehaviorPriority: number, bAimWeapon: boolean, MinAimAtTargetTime: number, MaxAimAtTargetTime: number): void {
      // TODO: implement
  }

  NotifyBlockingDoorClose(BlockedDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyBlockingDoorOpen(BlockedDoor: any /* door */): void {
      // TODO: implement
  }

  CanMoveToActor(): boolean {
      // TODO: implement
  }

  MoveToActor(Destination: any /* actor */, MovementBehaviorPriority: number, bZeroWalkThreshold: boolean): boolean {
      // TODO: implement
  }

  MoveMinimumDistanceAwayFromLocation(Location: THREE.Vector3, MinimumDistance: number): void {
      // TODO: implement
  }

  NotifyDoorWedged(WedgedDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyDoorLocked(LockedDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyDoorBlocked(LockedDoor: any /* door */): void {
      // TODO: implement
  }

  FindBetterEnemy(): void {
      // TODO: implement
  }

  SetDebugMoraleHistoryInfo(): void {
      // TODO: implement
  }

  SetDebugBlackboardInfo(): void {
      // TODO: implement
  }

  SetSpecificDebugInfo(): void {
      // TODO: implement
  }

}
