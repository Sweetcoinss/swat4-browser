// Auto-generated skeleton from UnrealScript: SwatAICommon/HiveBlackboard.uc
// Parent: Object

class HiveBlackboard extends Object {

  // Variables
  PlayerEnemy: any /* pawn */;  //  Pawn
  EncounteredHostages: any /* pawn */[];  //  array<Pawn>
  EncounteredEnemies: any /* pawn */[];  //  array<Pawn>
  AssignedTargets: any /* pawn */[];  //  array<Pawn>
  CompliantAIs: any /* pawn */[];  //  array<Pawn>
  RestrainedAIs: any /* pawn */[];  //  array<Pawn>
  AIsBeingWatched: any /* pawn */[];  //  array<Pawn>
  EngagingPointMap: any /* pawn> */;  // native map<NavigationPoint, Pawn>

  constructor() {
    super();
  }

  // Methods
  UpdateHostage(Hostage: any /* pawn */): void {
      // no body (native/abstract)
  }

  UpdateEnemy(Enemy: any /* pawn */): void {
      // no body (native/abstract)
  }

  HasAIBeenEncountered(TestAI: any /* pawn */): boolean {
      // no body (native/abstract)
  }

  MakePlayerEnemy(Player: any /* pawn */): void {
      // TODO: implement
  }

  IsACompliantAI(AI: any /* pawn */): boolean {
      // TODO: implement
  }

  AddCompliantAI(AI: any /* pawn */): void {
      // TODO: implement
  }

  RemoveCompliantAI(AI: any /* pawn */): void {
      // TODO: implement
  }

  ValidateRestrainedAIs(): void {
      // TODO: implement
  }

  IsARestrainedAI(AI: any /* pawn */): boolean {
      // TODO: implement
  }

  AddRestrainedAI(AI: any /* pawn */): void {
      // TODO: implement
  }

  RemoveRestrainedAI(AI: any /* pawn */): void {
      // TODO: implement
  }

  AddWatchedAI(AI: any /* pawn */): void {
      // TODO: implement
  }

  RemoveWatchedAI(AI: any /* pawn */): void {
      // TODO: implement
  }

  IsAIBeingWatched(AI: any /* pawn */): boolean {
      // TODO: implement
  }

  AddAssignedTarget(AI: any /* pawn */): void {
      // TODO: implement
  }

  AreAnyAssignedTargetsThreatening(): boolean {
      // TODO: implement
  }

  RemoveAssignedTarget(AI: any /* pawn */): void {
      // TODO: implement
  }

  IsAnAssignedTarget(AI: any /* pawn */): boolean {
      // TODO: implement
  }

}
