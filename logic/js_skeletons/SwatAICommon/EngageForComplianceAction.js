// Auto-generated skeleton from UnrealScript: SwatAICommon/EngageForComplianceAction.uc
// Parent: SwatCharacterAction

class EngageForComplianceAction extends SwatCharacterAction {

  // Variables
  CurrentOrderComplianceGoal: any /* ordercompliancegoal */;  // private OrderComplianceGoal
  CurrentMoveOfficerToEngageGoal: any /* moveofficertoengagegoal */;  // private MoveOfficerToEngageGoal
  MinComplianceOrderSleepTime: number;  // config float
  MaxComplianceOrderSleepTime: number;  // config float

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  ShouldMoveTowardsComplianceTarget(): boolean {
      // TODO: implement
  }

  MoveTowardsComplianceTarget(): void {
      // TODO: implement
  }

  OrderTargetToComply(): void {
      // TODO: implement
  }

}
