// Auto-generated skeleton from UnrealScript: SwatGame/Spawner.uc
// Parent: SpawnerBase

class Spawner extends SpawnerBase {

  // Variables
  SpawnerGroup: string;  // private name
  SpawnMode: any /* spawner.espawnmode */;  //  Spawner.ESpawnMode
  Archetypes: any /* chancearchetypepair> */;  // editinline array<editinline ChanceArchetypePair>
  Priority: number;  //  int
  ArchetypeClass: any /* class */;  //  Class<Archetype>
  ProfileArrayIndex: number;  //  int
  HasSpawned: boolean;  //  bool
  Spawned: any /* actor */;  // private Actor
  Archetype: any /* archetype */;  // private Archetype
  SpawnedFromRoster: boolean;  // private bool
  SpawnerSprites: any /* texture */[];  //  array<Texture>
  Game: any /* swatgameinfo */;  //  SwatGameInfo
  Disabled: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  SpawnArchetype(ArchetypeName: string, bTesting: boolean, CustomScenario: any /* customscenario */): any /* actor */ {
      // TODO: implement
  }

  SpawnFromLocalProperties(bTesting: boolean): any /* actor */ {
      // TODO: implement
  }

  ValidateSpawningFromLocalProperties(bTesting: boolean): void {
      // TODO: implement
  }

  GetSpawnerGroup(): string {
      // TODO: implement
  }

  SpawnedFromGroup(): string {
      // TODO: implement
  }

  DisableAntiSlaves(): void {
      // TODO: implement
  }

  IsSpawningFromRosters(): boolean {
      // TODO: implement
  }

  ResetForMPQuickRestart(): void {
      // TODO: implement
  }

}
