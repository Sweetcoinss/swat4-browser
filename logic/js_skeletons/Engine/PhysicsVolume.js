// Auto-generated skeleton from UnrealScript: Engine/PhysicsVolume.uc
// Parent: Volume

class PhysicsVolume extends Volume {

  // Variables
  bPainCausing: boolean;  //  bool
  ZoneVelocity: THREE.Vector3;  //  Vector
  Gravity: THREE.Vector3;  //  Vector
  GroundFriction: number;  //  float
  TerminalVelocity: number;  //  float
  DamagePerSec: number;  //  float
  DamageType: any /* class */;  //  Class<DamageType>
  Priority: number;  //  int
  EntrySound: any /* sound */;  //  Sound
  ExitSound: any /* sound */;  //  Sound
  EntryActor: any /* class */;  //  Class<Actor>
  ExitActor: any /* class */;  //  Class<Actor>
  FluidFriction: number;  //  float
  ViewFlash: THREE.Vector3;  //  Vector
  ViewFog: THREE.Vector3;  //  Vector
  bDestructive: boolean;  //  bool
  bNoInventory: boolean;  //  bool
  bMoveProjectiles: boolean;  //  bool
  bBounceVelocity: boolean;  //  bool
  bNeutralZone: boolean;  //  bool
  bWaterVolume: boolean;  //  bool
  PainTimer: any /* info */;  //  Info
  NextPhysicsVolume: any /* physicsvolume */;  //  PhysicsVolume

  constructor() {
    super();
  }

  // Methods
  PhysicsChangedFor(Other: any /* actor */): void {
      // TODO: implement
  }

  ActorEnteredVolume(Other: any /* actor */): void {
      // TODO: implement
  }

  ActorLeavingVolume(Other: any /* actor */): void {
      // TODO: implement
  }

  PawnEnteredVolume(Other: any /* pawn */): void {
      // TODO: implement
  }

  PawnLeavingVolume(Other: any /* pawn */): void {
      // TODO: implement
  }

  TimerPop(t: any /* volumetimer */): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

  PlayEntrySplash(Other: any /* actor */): void {
      // TODO: implement
  }

  UnTouch(Other: any /* actor */): void {
      // TODO: implement
  }

  PlayExitSplash(Other: any /* actor */): void {
      // TODO: implement
  }

  CausePainTo(Other: any /* actor */): void {
      // TODO: implement
  }

}
