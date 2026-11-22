// Auto-generated skeleton from UnrealScript: SwatAICommon/HostageReactionToOfficersAction.uc
// Parent: SwatCharacterAction

class HostageReactionToOfficersAction extends SwatCharacterAction {

  // Variables
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  CurrentInitialReactionGoal: any /* initialreactiongoal */;  // private InitialReactionGoal
  DesiredDistanceToOfficer: number;  // config float
  PointToLeftAnimation: string;  // config name
  PointToRightAnimation: string;  // config name
  PointBehindAnimation: string;  // config name
  PointToThreatAnimation: string;  // private name

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  RotateToOfficer(): void {
      // TODO: implement
  }

  PlayReactionAnimation(AnimationName: string): void {
      // TODO: implement
  }

  GetHighestThreat(MinimumValue: number): any /* actor */ {
      // TODO: implement
  }

  GetThreatAnimation(): string {
      // TODO: implement
  }

  PlayInitialReaction(): void {
      // TODO: implement
  }

  TriggerReactionSpeech(): void {
      // TODO: implement
  }

}
