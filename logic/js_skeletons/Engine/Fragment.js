// Auto-generated skeleton from UnrealScript: Engine/Fragment.uc
// Parent: Effects

class Fragment extends Effects {

  // Variables
  numFragmentTypes: number;  //  int
  bFirstHit: boolean;  //  bool
  ImpactSound: any /* sound */;  //  Sound
  AltImpactSound: any /* sound */;  //  Sound
  SplashTime: number;  //  float

  constructor() {
    super();
  }

  // Methods
  CanSplash(): boolean {
      // TODO: implement
  }

  CalcVelocity(Momentum: THREE.Vector3): void {
      // TODO: implement
  }

  HitWall(HitNormal: THREE.Vector3, HitWall: any /* actor */): void {
      // TODO: implement
  }

  RandSpin(spinRate: number): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  PhysicsVolumeChange(NewVolume: any /* physicsvolume */): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  PostTakeDamage(Dam: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

}
