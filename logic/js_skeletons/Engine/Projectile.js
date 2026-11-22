// Auto-generated skeleton from UnrealScript: Engine/Projectile.uc
// Parent: Actor

class Projectile extends Actor {

  // Variables
  speed: number;  //  float
  MaxSpeed: number;  //  float
  TossZ: number;  //  float
  ZeroCollider: any /* actor */;  //  Actor
  bSwitchToZeroCollision: boolean;  //  bool
  Damage: number;  //  float
  DamageRadius: number;  //  float
  MomentumTransfer: number;  //  float
  MyDamageType: any /* class */;  //  Class<DamageType>
  SpawnSound: any /* sound */;  //  Sound
  ImpactSound: any /* sound */;  //  Sound
  ExplosionDecal: any /* class */;  //  Class<Projector>
  ExploWallOut: number;  //  float

  constructor() {
    super();
  }

  // Methods
  EncroachingOn(Other: any /* actor */): boolean {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

  ClientSideTouch(Other: any /* actor */, HitLocation: THREE.Vector3): void {
      // TODO: implement
  }

  ProcessTouch(Other: any /* actor */, HitLocation: THREE.Vector3): void {
      // TODO: implement
  }

  HitWall(HitNormal: THREE.Vector3, Wall: any /* actor */): void {
      // TODO: implement
  }

  BlowUp(HitLocation: THREE.Vector3): void {
      // TODO: implement
  }

  Explode(HitLocation: THREE.Vector3, HitNormal: THREE.Vector3): void {
      // TODO: implement
  }

  RandSpin(spinRate: number): void {
      // TODO: implement
  }

  GetTossVelocity(P: any /* pawn */, R: THREE.Euler): THREE.Vector3 {
      // TODO: implement
  }

}
