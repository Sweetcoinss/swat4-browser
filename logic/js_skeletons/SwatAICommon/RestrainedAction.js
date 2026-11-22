// Auto-generated skeleton from UnrealScript: SwatAICommon/RestrainedAction.uc
// Parent: LookAtOfficersActionBase

class RestrainedAction extends LookAtOfficersActionBase {

  // Variables
  Cuffs: any /* handheldequipment */;  // private HandheldEquipment
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  MinSleepTimeBeforeLookingAtOfficers: number;  // config float
  MaxSleepTimeBeforeLookingAtOfficers: number;  // config float

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

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  RotateToRestrainablePosition(): void {
      // TODO: implement
  }

  Restrain(): void {
      // TODO: implement
  }

  RestrainInterrupted(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

}
