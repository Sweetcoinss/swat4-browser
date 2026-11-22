// Auto-generated skeleton from UnrealScript: SwatAICommon/InitialReactionDefinition.uc
// Parent: Object

class InitialReactionDefinition extends Object {

  // Variables
  ReactionCharacterTypes: any /* initialreactiondefinition.ereactioncharactertype */[];  // config array<InitialReactionDefinition.EReactionCharacterType>
  ReactionPosition: any /* initialreactiondefinition.echaracterreactionposition */;  // config InitialReactionDefinition.ECharacterReactionPosition
  StimuliPosition: any /* initialreactiondefinition.estimuliposition */;  // config InitialReactionDefinition.EStimuliPosition
  AnimationName: string;  // config name
  AnimationTweenTime: number;  // config float

  constructor() {
    super();
  }

  // Methods
  CanUseInitialReactionDefinition(Reactor: any /* pawn */, Stimuli: any /* pawn */): boolean {
      // TODO: implement
  }

  CanUseInitialReactionBasedOnType(Reactor: any /* pawn */): boolean {
      // TODO: implement
  }

  CanUseInitialReactionBasedOnPosition(Reactor: any /* pawn */): boolean {
      // TODO: implement
  }

  CanUseInitialReactionBasedOnStimuliPosition(Reactor: any /* pawn */, Stimuli: any /* pawn */): boolean {
      // TODO: implement
  }

}
