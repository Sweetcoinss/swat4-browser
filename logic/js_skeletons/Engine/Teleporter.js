// Auto-generated skeleton from UnrealScript: Engine/Teleporter.uc
// Parent: SmallNavigationPoint

class Teleporter extends SmallNavigationPoint {

  // Variables
  URL: string;  //  string
  ProductRequired: string;  //  name
  bChangesVelocity: boolean;  //  bool
  bChangesYaw: boolean;  //  bool
  bReversesX: boolean;  //  bool
  bReversesY: boolean;  //  bool
  bReversesZ: boolean;  //  bool
  bEnabled: boolean;  //  bool
  TargetVelocity: THREE.Vector3;  //  Vector
  TriggerActor: any /* actor */;  //  Actor
  TriggerActor2: any /* actor */;  //  Actor
  LastFired: number;  //  float

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  FindTriggerActor(): void {
      // TODO: implement
  }

  Accept(Incoming: any /* actor */, Source: any /* actor */): boolean {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

  PostTouch(Other: any /* actor */): void {
      // TODO: implement
  }

  SpecialHandling(Other: any /* pawn */): any /* actor */ {
      // TODO: implement
  }

}
