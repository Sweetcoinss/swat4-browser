// Auto-generated skeleton from UnrealScript: SwatObjectives/Do_NeutralizeTargetEnemies.uc
// Parent: Objective_Do

class Do_NeutralizeTargetEnemies extends Objective_Do {

  // Variables
  SpawnerGroup: string;  // config name
  Targets: any /* swatenemy */[];  //  array<SwatEnemy>

  constructor() {
    super();
  }

  // Methods
  Initialize(): void {
      // TODO: implement
  }

  UnRegisterGameEventsHook(): void {
      // TODO: implement
  }

  OnGameStarted(): void {
      // TODO: implement
  }

  OnPawnDied(Pawn: any /* pawn */, Killer: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  OnPawnIncapacitated(Pawn: any /* pawn */, Incapacitator: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  OnPawnArrested(Pawn: any /* pawn */, Arrester: any /* pawn */): void {
      // TODO: implement
  }

  RemoveTarget(Pawn: any /* pawn */, DebugWhy: string): void {
      // TODO: implement
  }

}
