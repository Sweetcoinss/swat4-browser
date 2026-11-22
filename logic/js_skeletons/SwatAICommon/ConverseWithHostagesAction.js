// Auto-generated skeleton from UnrealScript: SwatAICommon/ConverseWithHostagesAction.uc
// Parent: SwatCharacterAction

class ConverseWithHostagesAction extends SwatCharacterAction {

  // Variables
  ConverseChance: number;  // config float
  SubsequentEnemyResponseChance: number;  // config float
  MinPlayerDistanceForConversation: number;  // config float
  EnemyTalkToHostageTriggerEffectEvent: string;  // config name
  HostageReplyToEnemyTriggerEffectEvent: string;  // config name
  EnemyReplyToHostageTriggerEffectEvent: string;  // config name
  MinSleepTimeBetweenSpeech: number;  // config float
  MaxSleepTimeBetweenSpeech: number;  // config float
  MinTimeBetweenConversing: number;  // config float
  MaxTimeBetweenConversing: number;  // config float
  TargetHostage: any /* pawn */;  // private Pawn
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  FindTargetHostage(): boolean {
      // TODO: implement
  }

  CanPlayerHearConversation(bUsePropogationDistance: boolean): boolean {
      // TODO: implement
  }

  CanEnemiesConverseWithHostages(): boolean {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  RotateToFaceTarget(): void {
      // TODO: implement
  }

  ConverseWithTarget(): void {
      // TODO: implement
  }

}
