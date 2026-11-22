// Auto-generated skeleton from UnrealScript: SwatAICommon/StunnedAction.uc
// Parent: SwatCharacterAction

class StunnedAction extends SwatCharacterAction {

  // Variables
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  MoralePenalty: number;  // private float
  StartTime: number;  // private float
  EndTime: number;  // private float
  bRecovering: boolean;  // private bool
  bPlayedAnimation: boolean;  // private bool

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  GetMoraleModificationAmount(): number {
      // TODO: implement
  }

  AffectMorale(): void {
      // TODO: implement
  }

  ReturnMorale(): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  ShouldAffectMoraleAgain(): boolean {
      // TODO: implement
  }

  AddAdditionalStunnedTime(AdditionalStunnedTime: number): void {
      // TODO: implement
  }

  ExtendBeingStunned(AdditionalStunnedTime: number): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  TriggerStunnedSpeech(): void {
      // TODO: implement
  }

  UnTriggerStunnedSpeech(): void {
      // TODO: implement
  }

  FindRunToPoint(): any /* navigationpoint */ {
      // TODO: implement
  }

  RunFromStunningDevice(): void {
      // TODO: implement
  }

  GetReactionAnimation(): string {
      // TODO: implement
  }

  PlayReactionAnimation(): void {
      // TODO: implement
  }

  GetAffectedAnimation(): string {
      // TODO: implement
  }

  PlayAffectedAnimation(): void {
      // TODO: implement
  }

  GetRecoveryAnimation(): string {
      // TODO: implement
  }

  PlayRecoveryAnimation(): void {
      // TODO: implement
  }

  SetPlayedReaction(inPlayedReaction: boolean): void {
      // TODO: implement
  }

  ShouldDelayReaction(): boolean {
      // TODO: implement
  }

  ShouldTriggerStunnedSpeech(): boolean {
      // TODO: implement
  }

  ShouldReTriggerStunnedSpeech(): boolean {
      // TODO: implement
  }

  NotifyFinishedAffectedAnimation(): void {
      // TODO: implement
  }

}
