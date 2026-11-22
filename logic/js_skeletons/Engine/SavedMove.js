// Auto-generated skeleton from UnrealScript: Engine/SavedMove.uc
// Parent: Info

class SavedMove extends Info {

  // Variables
  NextMove: any /* savedmove */;  //  SavedMove
  TimeStamp: number;  //  float
  Delta: number;  //  float
  bRun: boolean;  //  bool
  bDuck: boolean;  //  bool
  bPressedJump: boolean;  //  bool
  bDoubleJump: boolean;  //  bool
  bLeanLeft: boolean;  //  bool
  bLeanRight: boolean;  //  bool
  DoubleClickMove: any /* actor.edoubleclickdir */;  //  Actor.EDoubleClickDir
  SavedPhysics: any /* actor.ephysics */;  //  Actor.EPhysics
  SavedLocation: THREE.Vector3;  //  Vector
  SavedVelocity: THREE.Vector3;  //  Vector

  constructor() {
    super();
  }

  // Methods
  Clear(): void {
      // TODO: implement
  }

  PostUpdate(P: any /* playercontroller */): void {
      // TODO: implement
  }

  SetMoveFor(LevelTimeseconds: number, P: any /* playercontroller */, DeltaTime: number, newAccel: THREE.Vector3, InDoubleClick: any /* actor.edoubleclickdir */): void {
      // TODO: implement
  }

}
