// Auto-generated skeleton from UnrealScript: SwatGame/BoobyTrap.uc
// Parent: ReactiveStaticMesh

class BoobyTrap extends ReactiveStaticMesh {

  // Variables
  BoobyTrapDoor: any /* swatdoor */;  //  SwatDoor
  QualifyTime: number;  // config float
  bActive: boolean;  //  bool
  AttachSocket: string;  //  name

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  OnBoobyTrapInitialize(): void {
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

  isActive(): boolean {
      // TODO: implement
  }

  DeActivate(): void {
      // TODO: implement
  }

  ReactToUsed(Other: any /* actor */): void {
      // TODO: implement
  }

  ReactToDamaged(Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  ReactToTriggered(Other: any /* actor */): void {
      // TODO: implement
  }

  OnTriggeredByDoor(): void {
      // TODO: implement
  }

  InitializeFromSpawner(Spawner: any /* spawner */): void {
      // TODO: implement
  }

  Internal_InitializeFromArchetypeInstance(Instance: any /* archetypeinstance */): void {
      // TODO: implement
  }

  InitializeFromArchetypeInstance(): void {
      // TODO: implement
  }

}
