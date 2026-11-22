// Auto-generated skeleton from UnrealScript: SwatGame/SpawningManager.uc
// Parent: Object

class SpawningManager extends Object {

  // Variables
  Level: any /* levelinfo */;  // private LevelInfo
  HasSpawned: boolean;  //  bool
  UnallocatedSpawners: any /* spawner */[];  //  array<Spawner>
  CurrentRoster: any /* roster */;  // private Roster

  constructor() {
    super();
  }

  // Methods
  Initialize(inLevel: any /* levelinfo */): void {
      // TODO: implement
  }

  DoSpawning(Game: any /* swatgameinfo */, bTesting: boolean): number[] {
      // TODO: implement
  }

  IsSpawningFromRosters(): boolean {
      // TODO: implement
  }

  DoMPSpawning(Game: any /* swatgameinfo */, MPRosterClassName: string, bTesting: boolean): void {
      // TODO: implement
  }

  SpawnerAllocated(Spawner: any /* actor */): void {
      // TODO: implement
  }

  GetMissionObjectiveForSpawnerGroup(SpawnerGroup: string): any /* objective */ {
      // TODO: implement
  }

  IsMissionObjective(SpawnerGroup: string): boolean {
      // TODO: implement
  }

  TestSpawn(Game: any /* swatgameinfo */, Count: number): void {
      // TODO: implement
  }

  ResetForMPQuickRestart(inLevel: any /* levelinfo */): void {
      // TODO: implement
  }

}
