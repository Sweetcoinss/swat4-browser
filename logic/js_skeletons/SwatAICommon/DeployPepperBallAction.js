// Auto-generated skeleton from UnrealScript: SwatAICommon/DeployPepperBallAction.uc
// Parent: SwatCharacterAction

class DeployPepperBallAction extends SwatCharacterAction {

  // Variables
  CurrentMoveToOpponentGoal: any /* movetoopponentgoal */;  // private MoveToOpponentGoal
  CurrentAttackTargetGoal: any /* attacktargetgoal */;  // private AttackTargetGoal
  CSBallLauncher: any /* handheldequipment */;  // private HandheldEquipment
  MaxNumberPepperBallsToFire: number;  // config int

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

  EquipCSBallLauncher(): void {
      // TODO: implement
  }

  UnequipCSBallLauncher(): void {
      // TODO: implement
  }

  AttackWithCSBallLauncher(): void {
      // TODO: implement
  }

}
