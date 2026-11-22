// Auto-generated skeleton from UnrealScript: SwatAICommon/RegroupAction.uc
// Parent: SwatCharacterAction

class RegroupAction extends SwatCharacterAction {

  // Variables
  MinRequiredRegroupDistanceFromOfficer: number;  // private config float
  CurrentAttackTargetGoal: any /* attacktargetgoal */;  // private AttackTargetGoal
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  LowSkillAttackWhileRegroupingChance: number;  // private config float
  MediumSkillAttackWhileRegroupingChance: number;  // private config float
  HighSkillAttackWhileRegroupingChance: number;  // private config float
  MinPassiveRegroupPercentageChance: number;  // private config float
  MaxPassiveRegroupPercentageChance: number;  // private config float
  MinAggressiveRegroupPercentageChance: number;  // private config float
  MaxAggressiveRegroupPercentageChance: number;  // private config float
  DistanceToOfficersSensor: any /* distancetoofficerssensor */;  // private DistanceToOfficersSensor
  bUseDistanceToOfficersSensor: boolean;  // private bool

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  IsAnotherSwatEnemyAlive(): boolean {
      // TODO: implement
  }

  IsWithinDistanceOfOfficers(): boolean {
      // TODO: implement
  }

  CanGetOutOfRoomSafely(): boolean {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  GetSkillSpecificAttackChance(): number {
      // TODO: implement
  }

  ShouldAttackWhileRegrouping(): boolean {
      // TODO: implement
  }

  AttackWhileRegrouping(): void {
      // TODO: implement
  }

  SwapInFullBodyFleeAnimations(): void {
      // TODO: implement
  }

  ResetFullBodyAnimations(): void {
      // TODO: implement
  }

  FindRegroupDestination(): any /* navigationpoint */ {
      // TODO: implement
  }

  Regroup(): void {
      // TODO: implement
  }

  CallForHelp(): void {
      // TODO: implement
  }

}
