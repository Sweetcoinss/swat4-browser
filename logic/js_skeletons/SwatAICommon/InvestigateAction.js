// Auto-generated skeleton from UnrealScript: SwatAICommon/InvestigateAction.uc
// Parent: SuspiciousAction

class InvestigateAction extends SuspiciousAction {

  // Variables
  CurrentAimAroundGoal: any /* aimaroundgoal */;  // private AimAroundGoal
  CurrentAimAtPointGoal: any /* aimatpointgoal */;  // private AimAtPointGoal
  CurrentMoveToLocationGoal: any /* movetolocationgoal */;  // private MoveToLocationGoal
  CurrentRotateTowardPointGoal: any /* rotatetowardpointgoal */;  // private RotateTowardPointGoal
  MinInvestigateDelayTime: number;  // config float
  MaxInvestigateDelayTime: number;  // config float
  ReactionSpeechChance: number;  // config float
  MinInvestigateTime: number;  // config float
  MaxInvestigateTime: number;  // config float
  InvestigateTimeoutTimer: any /* timer */;  // private Timer

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

  goalAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */): void {
      // TODO: implement
  }

  MoveToInvestigationDestination(): void {
      // TODO: implement
  }

  AimAtInvestigationLocation(): void {
      // TODO: implement
  }

  AimAround(InnerFOVDegrees: number, OuterFOVDegrees: number, bOnlyAimIfMoving: boolean): void {
      // TODO: implement
  }

  CanLookAtInvestigateLocation(): boolean {
      // TODO: implement
  }

  StartInvestigateTimeoutTimer(): void {
      // TODO: implement
  }

}
