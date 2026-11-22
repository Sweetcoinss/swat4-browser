// Auto-generated skeleton from UnrealScript: SwatAICommon/MoveToAction.uc
// Parent: SwatCharacterAction

class MoveToAction extends SwatCharacterAction {

  // Variables
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  CurrentAimAroundGoal: any /* aimaroundgoal */;  // private AimAroundGoal
  DistanceFromDestinationToStartWalking: number;  // config float
  MoveToMinAimHoldTime: number;  // config float
  MoveToMaxAimHoldTime: number;  // config float

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

  MoveToDestination(): void {
      // TODO: implement
  }

}
