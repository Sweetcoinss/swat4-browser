// Auto-generated skeleton from UnrealScript: SwatGame/Conversation.uc
// Parent: Object

class Conversation extends Object {

  // Variables
  Speaker: string;  // config name
  Speech: string;  // config name
  Skippable: boolean;  //  bool
  DelayAfter: number;  // config float
  Line: any /* dialogline */[];  // config array<DialogLine>
  CurrentLineIndex: number;  // private int
  CurrentDelay: number;  // private float
  CurrentSpeaker: any /* actor */;  // private Actor
  bShouldCurrentSpeakerMoveMouth: boolean;  // private bool
  SoundEffectsSubsystem: any /* soundeffectssubsystem */;  // private SoundEffectsSubsystem
  Manager: any /* conversationmanager */;  // private ConversationManager
  __OnConversationEnded__Delegate: any /* delegate<onconversationended> */;  //  delegate<OnConversationEnded>

  constructor() {
    super();
  }

  // Methods
  Start(inManager: any /* conversationmanager */): void {
      // TODO: implement
  }

  StartLine(): void {
      // TODO: implement
  }

  LocateAvailableSpeaker(SpeakerLabel: string): any /* actor */ {
      // TODO: implement
  }

  SubstituteSpeakerAliases(SpeakerLabel: string): void {
      // TODO: implement
  }

  HandleUnavailableSpeaker(): void {
      // TODO: implement
  }

  HandleInterruptedSpeaker(): void {
      // TODO: implement
  }

  GetSoundPropagationDistance(Listener: any /* actor */, SoundLocation: THREE.Vector3): number {
      // no body (native/abstract)
  }

  OnEffectStarted(inStartedEffect: any /* actor */): void {
      // TODO: implement
  }

  OnEffectStopped(inStoppedEffect: any /* actor */, Completed: boolean): void {
      // TODO: implement
  }

  OnEffectInitialized(inInitializedEffect: any /* actor */): void {
      // TODO: implement
  }

  CleanupActorRefs(): void {
      // TODO: implement
  }

}
