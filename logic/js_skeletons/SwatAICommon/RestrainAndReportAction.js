// Auto-generated skeleton from UnrealScript: SwatAICommon/RestrainAndReportAction.uc
// Parent: SwatCharacterAction

class RestrainAndReportAction extends SwatCharacterAction {

  // Variables
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  Handcuffs: any /* handheldequipment */;  // private HandheldEquipment
  TargetArrestedSensor: any /* arrestedsensor */;  // private ArrestedSensor
  DistanceFromTargetToRestrain: number;  // config float

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  ActivateArrestedSensor(): void {
      // TODO: implement
  }

  DeactivateArrestedSensor(): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  MoveIntoPosition(): void {
      // TODO: implement
  }

  RotateTowardsTarget(): void {
      // TODO: implement
  }

  RestrainTarget(): void {
      // TODO: implement
  }

  TriggerReassuranceSpeech(): void {
      // TODO: implement
  }

  TriggerFinishedArrestSpeech(): void {
      // TODO: implement
  }

  TriggerTargetRestrainedSpeech(): void {
      // TODO: implement
  }

}
