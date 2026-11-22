// Auto-generated skeleton from UnrealScript: SwatGame/SwatRagdollPawn.uc
// Parent: SwatPawn

class SwatRagdollPawn extends SwatPawn {

  // Variables
  BoneName: string;  // config name
  ForceMagnitude: any /* range */;  // config Range
  ForceVector: THREE.Vector3;  //  Vector
  TargetBoneName: string;  // config name
  TargetForceNormal: THREE.Vector3;  // config Vector
  TwitchType: any /* swatragdollpawn.etwitchtype */;  //  SwatRagdollPawn.ETwitchType
  BoneName: string;  //  name
  Damping: number;  //  float
  bHasRagdolledLocally: boolean;  // private bool
  bHasRagdolledOnServer: boolean;  // private bool
  bShouldCheckHasRagdolledOnServer: boolean;  // private bool
  LocationAtRagdollStartOnServer: THREE.Vector3;  // private Vector
  DeadPawnTearOffTimer: any /* timer */;  // private Timer
  bClientsShouldCallPlayDying: boolean;  // private bool
  bIsDisabledRagdoll: boolean;  // private bool
  bRagdollDeathUsesImpactMomentum: boolean;  // private config bool
  bRagdollDeathPushesAwayFromDoor: boolean;  // private config bool
  RagdollPushAwayFromDoorVelocityMagnitude: number;  // private config float
  RagdollSimulationTimeout: number;  // private config float
  LimbTwitchTimer: any /* timer */;  // private Timer
  LimbTwitchTime: number;  // private config float
  LimbIdleTimer: any /* timer */;  // private Timer
  LimbIdleTime: number;  // private config float
  bLimbsAreIdle: boolean;  // private bool
  bRagdollingOnReplication: boolean;  // private bool
  FirstRagdollRenderTime: number;  // private float
  TwitchInfos: any /* twitchingboneinfo */[];  // config array<TwitchingBoneInfo>
  RenderTimeout: number;  // private config float
  InitialRagdollRenderTimeout: number;  // private config float
  BoneLinearDamping: any /* bonedampingsetting */[];  // config array<BoneDampingSetting>
  BoneAngularDamping: any /* bonedampingsetting */[];  // config array<BoneDampingSetting>

  constructor() {
    super();
  }

  // Methods
  PostNetBeginPlay(): void {
      // TODO: implement
  }

  OnMeshChanged(): void {
      // TODO: implement
  }

  GetRagdollSimulationTimeout(): number {
      // TODO: implement
  }

  StartTwitchingLimbs(): void {
      // no body (native/abstract)
  }

  StopTwitchingLimbs(): void {
      // no body (native/abstract)
  }

  StartTwitching(): void {
      // TODO: implement
  }

  StartIdling(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  Died(Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3): void {
      // TODO: implement
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

  ChunkUp(HitRotation: THREE.Euler, TheDamageType: any /* class */): void {
      // TODO: implement
  }

  GetBestVelocityToApplyToPushRagdollAwayFromDoors(): THREE.Vector3 {
      // TODO: implement
  }

  PushAwayFromDoors(): void {
      // TODO: implement
  }

  ApplyDeathHitMomentumToRagdoll(): void {
      // TODO: implement
  }

  BecomeRagdoll(): void {
      // TODO: implement
  }

  NotifyReadyToRagdoll(): void {
      // TODO: implement
  }

  PlayDying(DamageType: any /* class */, HitLoc: THREE.Vector3, HitMomentum: THREE.Vector3, inKillerLocation: THREE.Vector3): void {
      // TODO: implement
  }

  TearOffPawn(): void {
      // TODO: implement
  }

  DisableRagdoll(bKeepHavokPhysics: boolean): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  FellOutOfWorld(KillType: any /* actor.ekillztype */): void {
      // TODO: implement
  }

}
