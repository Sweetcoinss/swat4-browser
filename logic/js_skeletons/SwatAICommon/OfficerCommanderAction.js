// Auto-generated skeleton from UnrealScript: SwatAICommon/OfficerCommanderAction.uc
// Parent: CommanderAction

class OfficerCommanderAction extends CommanderAction {

  // Variables
  HiveMind: any /* hive */;  // private Hive
  CurrentAssignment: any /* pawn */;  // private Pawn
  bHasEngaged: boolean;  // private bool
  CurrentEngageForComplianceGoal: any /* engageforcompliancegoal */;  // private EngageForComplianceGoal
  CurrentAttackEnemyGoal: any /* attackenemygoal */;  // private AttackEnemyGoal
  CurrentIdleAimAroundGoal: any /* idleaimaroundgoal */;  // private IdleAimAroundGoal
  CurrentWatchNonHostileTargetGoal: any /* watchnonhostiletargetgoal */;  // private WatchNonHostileTargetGoal
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  MinAimAtNoiseWhileMovingTime: number;  // config float
  MaxAimAtNoiseWhileMovingTime: number;  // config float
  MinFinishedEngagingTimeToAimAround: number;  // config float
  MaxFinishedEngagingTimeToAimAround: number;  // config float

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

  GetHive(): any /* hive */ {
      // TODO: implement
  }

  GetCurrentAssignment(): any /* pawn */ {
      // no body (native/abstract)
  }

  SetupWatchingNonHostileTargets(): void {
      // TODO: implement
  }

  SetupIdleAimAroundGoal(): void {
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

  RotateToFaceNoise(NoisyActor: any /* actor */): void {
      // TODO: implement
  }

  NotifyDoorBlocked(BlockedDoor: any /* door */): void {
      // TODO: implement
  }

  ShouldEngageTarget(Target: any /* pawn */): boolean {
      // TODO: implement
  }

  EngageTarget(Target: any /* pawn */): void {
      // TODO: implement
  }

  ClearAssignment(): void {
      // TODO: implement
  }

  ClearEngageGoals(): void {
      // TODO: implement
  }

  FindBetterEnemy(): void {
      // TODO: implement
  }

  EngageTargetForCompliance(Target: any /* pawn */): void {
      // TODO: implement
  }

  AttackTarget(Target: any /* pawn */): void {
      // TODO: implement
  }

  EngageAssignment(): void {
      // TODO: implement
  }

}
