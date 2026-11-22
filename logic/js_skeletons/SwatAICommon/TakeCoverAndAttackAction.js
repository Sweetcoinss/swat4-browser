// Auto-generated skeleton from UnrealScript: SwatAICommon/TakeCoverAndAttackAction.uc
// Parent: TakeCoverAction

class TakeCoverAndAttackAction extends TakeCoverAction {

  // Variables
  CurrentAttackTargetGoal: any /* attacktargetgoal */;  // private AttackTargetGoal
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  CurrentMoveToOpponentGoal: any /* movetoopponentgoal */;  // private MoveToOpponentGoal
  CurrentAimAroundGoal: any /* aimaroundgoal */;  // private AimAroundGoal
  LowSkillAttackWhileTakingCoverChance: number;  // private config float
  MediumSkillAttackWhileTakingCoverChance: number;  // private config float
  HighSkillAttackWhileTakingCoverChance: number;  // private config float
  MinCrouchTime: number;  // private config float
  MaxCrouchTime: number;  // private config float
  MinStandTime: number;  // private config float
  MaxStandTime: number;  // private config float
  MinLeanTime: number;  // private config float
  MaxLeanTime: number;  // private config float
  MinPassiveTakeCoverAndAttackPercentageChance: number;  // private config float
  MaxPassiveTakeCoverAndAttackPercentageChance: number;  // private config float
  MinAggressiveTakeCoverAndAttackPercentageChance: number;  // private config float
  MaxAggressiveTakeCoverAndAttackPercentageChance: number;  // private config float
  LowSkillSuccessAfterFiringChance: number;  // private config float
  MediumSkillSuccessAfterFiringChance: number;  // private config float
  HighSkillSuccessAfterFiringChance: number;  // private config float
  AttackRotation: THREE.Euler;  // private Rotator
  AttackLeanState: any /* pawn.eleanstate */;  // private Pawn.ELeanState
  AttackCoverLocationType: any /* aicoverfinder.eaicoverlocationtype */;  // private AICoverFinder.EAICoverLocationType
  CachedSeenPawns: any /* pawn */[];  //  array<Pawn>
  DistanceToOfficersSensor: any /* distancetoofficerssensor */;  // private DistanceToOfficersSensor
  MinDistanceToOfficersWhileTakingCover: number;  // private config float
  MoveBrieflyChance: number;  // private float
  MoveBrieflyChanceIncrement: number;  // private config float
  AimAroundInnerFovDegrees: number;  // private config float
  AimAroundOuterFovDegrees: number;  // private config float
  AimAroundMinAimTime: number;  // private config float
  AimAroundMaxAimTime: number;  // private config float

  constructor() {
    super();
  }

  // Methods
  CanTakeCoverAndAttack(): boolean {
      // TODO: implement
  }

  CoverIsInBadPosition(): boolean {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  goalAchievedCB(Goal: any /* ai_goal */, Action: any /* ai_action */): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  GetSkillSpecificSuccessAfterFiringChance(): number {
      // TODO: implement
  }

  GetSkillSpecificAttackChance(): number {
      // TODO: implement
  }

  ShouldAttackWhileTakingCover(): boolean {
      // TODO: implement
  }

  GetEnemy(): any /* pawn */ {
      // TODO: implement
  }

  StopAttacking(): void {
      // TODO: implement
  }

  Attack(Enemy: any /* pawn */, bCanSucceedAfterFiring: boolean): void {
      // TODO: implement
  }

  IsRotatedToAttackRotation(): boolean {
      // TODO: implement
  }

  RotateToAttackRotation(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  CanLeanAtCoverResult(): boolean {
      // TODO: implement
  }

  CanUseCover(): boolean {
      // TODO: implement
  }

  FindBestCoverToAttackFrom(): boolean {
      // TODO: implement
  }

  TakeCoverAtInitialCoverLocation(): void {
      // TODO: implement
  }

  TakeCover(): void {
      // TODO: implement
  }

  MoveTowardEnemyBriefly(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  AimAroundBriefly(): void {
      // TODO: implement
  }

  AttackWhileCrouchingBehindCover(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  Lean(): void {
      // TODO: implement
  }

  StopLeaning(): void {
      // TODO: implement
  }

  ReEvaluateCover(): void {
      // TODO: implement
  }

  AttackWhileLeaningBehindCover(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  AttackFromBehindCover(): void {
      // TODO: implement
  }

}
