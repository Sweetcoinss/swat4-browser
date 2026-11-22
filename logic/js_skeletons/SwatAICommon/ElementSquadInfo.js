// Auto-generated skeleton from UnrealScript: SwatAICommon/ElementSquadInfo.uc
// Parent: OfficerTeamInfo

class ElementSquadInfo extends OfficerTeamInfo {

  // Variables
  ElementSpeechManagerGoal: any /* elementspeechmanagergoal */;  // private ElementSpeechManagerGoal
  ElementSpeechManager: any /* elementspeechmanageraction */;  // private ElementSpeechManagerAction

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  InitAbilities(): void {
      // TODO: implement
  }

  PostSpeechManagerGoal(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  GetElementSpeechManagerAction(): any /* elementspeechmanageraction */ {
      // TODO: implement
  }

  UnpostCommandGoals(): void {
      // TODO: implement
  }

  RemoveCommandGoalsFor(TeamInfo: any /* officerteaminfo */): void {
      // TODO: implement
  }

  CreateCommandGoalFromTemplate(TeamInfo: any /* officerteaminfo */, CommandGoalTemplate: any /* squadcommandgoal */): any /* squadcommandgoal */ {
      // TODO: implement
  }

  CanSpeak(): boolean {
      // TODO: implement
  }

  TriggerEnemyFleeingSpeech(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  TriggerSuspectDownSpeech(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  TriggerHostageDownSpeech(Hostage: any /* pawn */): void {
      // TODO: implement
  }

  TriggerOfficerDownSpeech(Officer: any /* pawn */): void {
      // TODO: implement
  }

  TriggerLeadDownSpeech(Lead: any /* pawn */): void {
      // TODO: implement
  }

  TriggerSuspectWontComplySpeech(Suspect: any /* pawn */): void {
      // TODO: implement
  }

  TriggerHostageWontComplySpeech(Hostage: any /* pawn */): void {
      // TODO: implement
  }

  TriggerReactedFirstShotSpeech(OfficerShot: any /* pawn */): void {
      // TODO: implement
  }

  TriggerReactedSecondShotSpeech(OfficerShot: any /* pawn */): void {
      // TODO: implement
  }

  TriggerReactedThirdShotSpeech(OfficerShot: any /* pawn */): void {
      // TODO: implement
  }

  TriggerTargetCompliantSpeech(Target: any /* pawn */): void {
      // TODO: implement
  }

  TriggerTeamReportedSpeech(Officer: any /* pawn */): void {
      // TODO: implement
  }

}
