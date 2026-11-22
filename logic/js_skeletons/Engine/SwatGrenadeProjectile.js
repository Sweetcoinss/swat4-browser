// Auto-generated skeleton from UnrealScript: Engine/SwatGrenadeProjectile.uc
// Parent: SwatProjectile

class SwatGrenadeProjectile extends SwatProjectile {

  // Variables
  FuseTime: number;  // private config float
  NotifyAIsTime: number;  // private config float
  NotifyAIsTimer: any /* timer */;  // private Timer
  BounceDampening: number;  // private config float
  BounceCount: number;  // private config int
  InterestedGrenadeRegistrants: any /* iinterestedgrenadethrowing */[];  //  array<IInterestedGrenadeThrowing>
  TimeThrown: number;  // private float
  DebugLastLocation: THREE.Vector3;  // private Vector
  bRenderDebugInfo: boolean;  //  bool
  bShouldSpin: boolean;  // private bool

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  Tick(dTime: number): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  NotifyAIsGrenadeThrown(): void {
      // TODO: implement
  }

  IsAnInterestedGrenadeRegistrant(Registrant: any /* iinterestedgrenadethrowing */): boolean {
      // TODO: implement
  }

  RegisterInterestedGrenadeRegistrant(Registrant: any /* iinterestedgrenadethrowing */): void {
      // TODO: implement
  }

  UnRegisterInterestedGrenadeRegistrant(Registrant: any /* iinterestedgrenadethrowing */): void {
      // TODO: implement
  }

  NotifyRegistrantsGrenadeDetonated(): void {
      // TODO: implement
  }

  HitWall(Normal: THREE.Vector3, Wall: any /* actor */): void {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

  DestroyNotifyAIsTimer(): void {
      // TODO: implement
  }

  Detonated(): void {
      // TODO: implement
  }

  DoPostDetonation(): void {
      // TODO: implement
  }

}
