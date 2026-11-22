// Auto-generated skeleton from UnrealScript: SwatGame/HighGroundVolume.uc
// Parent: PhysicsVolume

class HighGroundVolume extends PhysicsVolume {

  // Variables
  Instance: string;  //  name
  RoomName: string;  //  name
  Conditions: any /* highgroundcondition */[];  // config array<HighGroundCondition>
  PriorityQueue: any /* highgroundcondition */[];  // transient array<HighGroundCondition>
  NullCondition: any /* highgroundcondition */;  // const HighGroundCondition
  bStillPlaying: boolean;  //  bool
  PlayingCondition: any /* highgroundcondition */;  //  HighGroundCondition
  bGameStarted: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  OnPostGameStarted(): void {
      // TODO: implement
  }

  ConditionToString(inCondition: any /* highgroundcondition */): string {
      // TODO: implement
  }

  QueueEvent(inCondition: any /* highgroundcondition */): void {
      // TODO: implement
  }

  QueueShrinkOnSubject(inSubject: string): void {
      // TODO: implement
  }

  QueueShrinkOnSubjectAndAction(inSubject: string, inAction: string): void {
      // TODO: implement
  }

  SubjectsMatch(inSubject1: string, inSubject2: string): boolean {
      // TODO: implement
  }

  QueueExtract(): any /* highgroundcondition */ {
      // TODO: implement
  }

  FindCondition(inSubject: any /* actor */, inAction: string, inObject: any /* actor */): any /* highgroundcondition */ {
      // TODO: implement
  }

  IsConditionQueued(inSubject: string, inAction: string, inObject: string): boolean {
      // TODO: implement
  }

  PlayCondition(inSubject: any /* actor */, inAction: string, inObject: any /* actor */): void {
      // TODO: implement
  }

  GetEffectName(inCondition: any /* highgroundcondition */): string {
      // TODO: implement
  }

  OnConditionPlayed(): void {
      // TODO: implement
  }

  ShouldRejectCondition(inCondition: any /* highgroundcondition */): boolean {
      // TODO: implement
  }

  PlayConditionEffect(inCondition: any /* highgroundcondition */): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
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

  GetAnySwatPlayer(): any /* swatplayer */ {
      // TODO: implement
  }

  OnPawnDied(Pawn: any /* pawn */, Killer: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  PawnEnteredVolume(Other: any /* pawn */): void {
      // TODO: implement
  }

  PawnLeavingVolume(Other: any /* pawn */): void {
      // TODO: implement
  }

  ActorEnteredVolume(Other: any /* actor */): void {
      // TODO: implement
  }

  ActorLeavingVolume(Other: any /* actor */): void {
      // TODO: implement
  }

  OnPawnArrested(Arrestee: any /* pawn */, Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnPawnIncapacitated(Pawn: any /* pawn */, Incapacitator: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

}
