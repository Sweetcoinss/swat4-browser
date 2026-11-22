// Auto-generated skeleton from UnrealScript: SwatAICommon/FallInAction.uc
// Parent: SwatCharacterAction

class FallInAction extends SwatCharacterAction {

  // Variables
  CurrentMoveInFormationGoal: any /* moveinformationgoal */;  // private MoveInFormationGoal
  CurrentAimAroundGoal: any /* aimaroundgoal */;  // private AimAroundGoal
  FallInMinAimHoldTime: number;  // config float
  FallInMaxAimHoldTime: number;  // config float
  bIsLowReady: boolean;  // private bool

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

  AimAround(): void {
      // TODO: implement
  }

  FollowPlayer(): void {
      // TODO: implement
  }

}
