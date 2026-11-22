// Auto-generated skeleton from UnrealScript: SwatGame/BombBase.uc
// Parent: ReactiveStaticMesh

class BombBase extends ReactiveStaticMesh {

  // Variables
  TimeToQualify: number;  // config float
  bActive: boolean;  //  bool
  SpawnedFromName: string;  // private name
  Spawner: any /* spawner */;  //  Spawner

  constructor() {
    super();
  }

  // Methods
  PostNetBeginPlay(): void {
      // TODO: implement
  }

  CanBeUsedByToolkitNow(): boolean {
      // TODO: implement
  }

  OnUsingByToolkitBegan(User: any /* pawn */): void {
      // TODO: implement
  }

  OnUsedByToolkit(User: any /* pawn */): void {
      // TODO: implement
  }

  OnUsingByToolkitInterrupted(User: any /* pawn */): void {
      // TODO: implement
  }

  GetQualifyTimeForToolkit(): number {
      // TODO: implement
  }

  InitializeFromSpawner(inSpawner: any /* spawner */): void {
      // TODO: implement
  }

  Internal_InitializeFromArchetypeInstance(Instance: any /* archetypeinstance */): void {
      // TODO: implement
  }

  InitializeFromArchetypeInstance(): void {
      // TODO: implement
  }

  GetSpawner(): any /* spawner */ {
      // TODO: implement
  }

  isActive(): boolean {
      // TODO: implement
  }

  UniqueID(): string {
      // TODO: implement
  }

}
