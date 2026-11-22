// Auto-generated skeleton from UnrealScript: SwatAICommon/SquadSecureAction.uc
// Parent: OfficerSquadAction

class SquadSecureAction extends OfficerSquadAction {

  // Variables
  AvailableOfficers: any /* pawn */[];  //  array<Pawn>
  CurrentRestrainAndReportGoals: any /* restrainandreportgoal */[];  //  array<RestrainAndReportGoal>
  CurrentSecureEvidenceGoals: any /* secureevidencegoal */[];  //  array<SecureEvidenceGoal>
  TargetsBeingSecured: any /* actor */[];  //  array<Actor>

  constructor() {
    super();
  }

  // Methods
  NotifyPawnDied(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  ClearOutRestrainAndReportGoals(): void {
      // TODO: implement
  }

  ClearOutSecureEvidenceGoals(): void {
      // TODO: implement
  }

  CopyTargetsBeingSecuredToGoal(): void {
      // TODO: implement
  }

  AddSecureTarget(SecureTarget: any /* actor */): void {
      // TODO: implement
  }

  GetNumSecureTargets(): number {
      // TODO: implement
  }

  GetSecureTarget(SecureTargetIndex: number): any /* actor */ {
      // TODO: implement
  }

  RemoveSecureTarget(SecureTarget: any /* actor */): void {
      // TODO: implement
  }

  AddTargetBeingSecured(SecureTarget: any /* actor */): void {
      // TODO: implement
  }

  RemoveTargetBeingSecured(SecureTarget: any /* actor */): void {
      // TODO: implement
  }

  IsTargetBeingSecured(SecureTarget: any /* actor */): boolean {
      // TODO: implement
  }

  NotifyNewSecureTarget(): void {
      // TODO: implement
  }

  goalAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  RemoveRestrainAndReportGoal(Goal: any /* restrainandreportgoal */): void {
      // TODO: implement
  }

  RemoveSecureEvidenceGoal(Goal: any /* secureevidencegoal */): void {
      // TODO: implement
  }

  PopulateAvailableOfficers(): void {
      // TODO: implement
  }

  MakeOfficerAvailable(Officer: any /* pawn */): void {
      // TODO: implement
  }

  MakeOfficerUnavailable(Officer: any /* pawn */): void {
      // TODO: implement
  }

  AreAnyOfficersAvailable(): boolean {
      // TODO: implement
  }

  ValidateAvailableOfficers(): void {
      // TODO: implement
  }

  GetClosestAvailableOfficerToTarget(Target: any /* actor */): any /* pawn */ {
      // TODO: implement
  }

  RestrainAndReportOnTarget(RestrainTarget: any /* pawn */): void {
      // TODO: implement
  }

  SecureEvidence(SecureEvidenceTarget: any /* ievidence */): void {
      // TODO: implement
  }

  SecureCurrentTargets(): void {
      // TODO: implement
  }

  TriggerReplyToOrderSpeech(): void {
      // TODO: implement
  }

}
