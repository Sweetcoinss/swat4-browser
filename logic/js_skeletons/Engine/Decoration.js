// Auto-generated skeleton from UnrealScript: Engine/Decoration.uc
// Parent: Actor

class Decoration extends Actor {

  // Variables
  EffectWhenDestroyed: any /* class */;  //  Class<Actor>
  bPushable: boolean;  //  bool
  bDamageable: boolean;  //  bool
  bPushSoundPlaying: boolean;  //  bool
  bSplash: boolean;  //  bool
  PushSound: any /* sound */;  //  Sound
  EndPushSound: any /* sound */;  //  Sound
  numLandings: number;  // const int
  contents: any /* class */;  //  Class<Inventory>
  NumFrags: number;  //  int
  FragSkin: any /* texture */;  //  Texture
  FragType: any /* class */;  //  Class<Fragment>
  FragMomentum: THREE.Vector3;  //  Vector
  Health: number;  //  int
  SplashTime: number;  //  float

  constructor() {
    super();
  }

  // Methods
  CanSplash(): boolean {
      // TODO: implement
  }

  Drop(newVel: THREE.Vector3): void {
      // TODO: implement
  }

  Landed(HitNormal: THREE.Vector3): void {
      // TODO: implement
  }

  HitWall(HitNormal: THREE.Vector3, Wall: any /* actor */): void {
      // TODO: implement
  }

  PostTakeDamage(NDamage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  PhysicsVolumeChange(NewVolume: any /* physicsvolume */): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  BaseChange(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  PostBump(Other: any /* actor */): void {
      // TODO: implement
  }

}
