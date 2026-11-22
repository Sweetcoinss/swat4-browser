// Auto-generated skeleton from UnrealScript: SwatAICommon/WatchNonHostileTargetAction.uc
// Parent: SwatCharacterAction

class WatchNonHostileTargetAction extends SwatCharacterAction {

  // Variables
  CurrentWatchTarget: any /* pawn */;  // private Pawn
  CurrentAimAtTargetGoal: any /* aimattargetgoal */;  // private AimAtTargetGoal
  CurrentRotateTowardActorGoal: any /* rotatetowardactorgoal */;  // private RotateTowardActorGoal
  MinWatchTargetTime: number;  // config float
  MaxWatchTargetTime: number;  // config float
  MinDistanceToAimGun: number;  // config float
  MinDeltaTimeBetweenSpeakingToTarget: number;  // config float
  MaxDeltaTimeBetweenSpeakingToTarget: number;  // config float
  LastSpokenToWatchTarget: any /* pawn */;  // private Pawn
  NextSpokenToWatchTargetTime: number;  // private float

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

  GetPotentialWatchTarget(): any /* pawn */ {
      // TODO: implement
  }

  FindInitialWatchTarget(): void {
      // TODO: implement
  }

  FindNewWatchTarget(): boolean {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  AimAtWatchTarget(): void {
      // TODO: implement
  }

  SpeakToCompliantTarget(): void {
      // TODO: implement
  }

}
