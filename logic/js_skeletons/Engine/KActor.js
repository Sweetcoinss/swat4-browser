// Auto-generated skeleton from UnrealScript: Engine/KActor.uc
// Parent: Actor

class KActor extends Actor {

  // Variables
  ImpactSounds: any /* sound */[];  //  array<Sound>
  ImpactVolume: number;  //  float
  ImpactEffect: any /* class */;  //  Class<Actor>
  bOrientImpactEffect: boolean;  //  bool
  ImpactInterval: number;  //  float
  LastImpactTime: number;  // transient float
  MomentumToKarmaImpulseConversionFactor: number;  // config float

  constructor() {
    super();
  }

  // Methods
  GetMomentumToPenetrate(HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, MaterialHit: any /* material */): number {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  KImpact(Other: any /* actor */, pos: THREE.Vector3, impactVel: THREE.Vector3, impactNorm: THREE.Vector3): void {
      // TODO: implement
  }

}
