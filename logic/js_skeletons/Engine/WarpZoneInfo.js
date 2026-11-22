// Auto-generated skeleton from UnrealScript: Engine/WarpZoneInfo.uc
// Parent: ZoneInfo

class WarpZoneInfo extends ZoneInfo {

  // Variables
  OtherSideURL: string;  //  string
  ThisTag: string;  //  name
  bNoTeleFrag: boolean;  //  bool
  iWarpZone: number;  // const int
  WarpCoords: any /* coords */;  // const Coords
  OtherSideActor: any /* warpzoneinfo */;  // transient WarpZoneInfo
  OtherSideLevel: any /* object */;  // transient Object
  numDestinations: number;  //  int

  constructor() {
    super();
  }

  // Methods
  Warp(Loc: THREE.Vector3, Vel: THREE.Vector3, R: THREE.Euler): void {
      // no body (native/abstract)
  }

  UnWarp(Loc: THREE.Vector3, Vel: THREE.Vector3, R: THREE.Euler): void {
      // no body (native/abstract)
  }

  PreBeginPlay(): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  Generate(): void {
      // TODO: implement
  }

  ForceGenerate(): void {
      // TODO: implement
  }

  ActorEntered(Other: any /* actor */): void {
      // TODO: implement
  }

  ActorLeaving(Other: any /* actor */): void {
      // TODO: implement
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

}
