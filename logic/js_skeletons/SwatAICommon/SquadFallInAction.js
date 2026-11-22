// Auto-generated skeleton from UnrealScript: SwatAICommon/SquadFallInAction.uc
// Parent: OfficerSquadAction

class SquadFallInAction extends OfficerSquadAction {

  // Variables
  FallInFormation: any /* formation */;  // private Formation
  CompletedTimer: any /* timer */;  // private Timer
  CompletedTimerUpdateRate: number;  // config float
  CopyCompletedTimerUpdateRate: number;  // config float
  MinDistanceToTriggerReplySpeech: number;  // config float
  MinDistanceToTriggerCompletedSpeech: number;  // config float

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

  NotifyPawnDied(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  SpawnCompletedTimer(): void {
      // TODO: implement
  }

  ShouldReplyCompleted(): boolean {
      // TODO: implement
  }

  CheckFallInCompleted(): void {
      // TODO: implement
  }

  CleanupCompletedTimer(): void {
      // TODO: implement
  }

  FallInSquad(): void {
      // TODO: implement
  }

  FindOfficerToTriggerFallInSpeech(): any /* pawn */ {
      // TODO: implement
  }

  TriggerFallInSpeech(): void {
      // TODO: implement
  }

}
