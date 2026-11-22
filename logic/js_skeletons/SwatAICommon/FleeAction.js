// Auto-generated skeleton from UnrealScript: SwatAICommon/FleeAction.uc
// Parent: SwatCharacterAction

class FleeAction extends SwatCharacterAction {

  // Variables
  MinRequiredFleeDistanceFromOfficer: number;  // private config float
  CurrentAttackTargetGoal: any /* attacktargetgoal */;  // private AttackTargetGoal
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  FleeDestination: any /* fleepoint */;  // private FleePoint
  LowSkillAttackWhileFleeingChance: number;  // private config float
  MediumSkillAttackWhileFleeingChance: number;  // private config float
  HighSkillAttackWhileFleeingChance: number;  // private config float
  MinPassiveFleePercentageChance: number;  // private config float
  MaxPassiveFleePercentageChance: number;  // private config float
  MinAggressiveFleePercentageChance: number;  // private config float
  MaxAggressiveFleePercentageChance: number;  // private config float
  DistanceToOfficersSensor: any /* distancetoofficerssensor */;  // private DistanceToOfficersSensor
  bUseDistanceToOfficersSensor: boolean;  // private bool

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

  IsWithinDistanceOfOfficers(): boolean {
      // TODO: implement
  }

  FindFleeDestination(): boolean {
      // TODO: implement
  }

  CanGetOutOfRoomSafely(): boolean {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  GetSkillSpecificAttackChance(): number {
      // TODO: implement
  }

  ShouldAttackWhileFleeing(): boolean {
      // TODO: implement
  }

  AttackWhileFleeing(): void {
      // TODO: implement
  }

  SwapInFullBodyFleeAnimations(): void {
      // TODO: implement
  }

  ResetFullBodyAnimations(): void {
      // TODO: implement
  }

  FindFleePointDestination(): any /* fleepoint */ {
      // TODO: implement
  }

  Flee(): void {
      // TODO: implement
  }

}
