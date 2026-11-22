// Auto-generated skeleton from UnrealScript: Engine/FiredWeapon.uc
// Parent: Weapon

class FiredWeapon extends Weapon {

  // Variables
  AmmoClass: string;  // config string
  Chance: number;  // config int
  LoadedAmmoClass: any /* class */;  //  Class<Ammunition>
  PlayerAmmoOption: string[];  // config array<string>
  EnemyUsesAmmo: any /* enemyammo */[];  // config array<EnemyAmmo>
  AmmoClass: any /* class */;  //  Class<Ammunition>
  Ammo: any /* ammunition */;  //  Ammunition
  ThirdPersonFireOffset: THREE.Vector3;  // config Vector
  MuzzleVelocity: number;  // config float
  bCanShootThroughGlass: boolean;  // config bool
  bAimAtHead: boolean;  // config bool
  NextFireTime: number;  // private float
  ReloadingStatus: any /* handheldequipment.actionstatus */;  // private HandheldEquipment.ActionStatus
  ReloadAnimationRate: number;  // config float
  aimerror: number;  // private float
  PendingAimErrorPenalty: number;  // private float
  MaxAimError: number;  // config float
  SmallAimErrorRecoveryRate: number;  // config float
  LargeAimErrorRecoveryRate: number;  // config float
  AimErrorBreakingPoint: number;  // config float
  LookAimErrorQuantizationFactor: number;  //  float
  LookAimErrorPenaltyFactor: number;  // config float
  MaxLookAimErrorPenalty: number;  // config float
  InjuredAimErrorPenalty: number;  // config float
  MaxInjuredAimErrorPenalty: number;  // config float
  DamagedAimErrorPenalty: number;  // config float
  EquippedAimErrorPenalty: number;  // config float
  FiredAimErrorPenalty: number;  // config float
  WalkToRunAimErrorPenalty: number;  // config float
  StandToWalkAimErrorPenalty: number;  // config float
  StandingAimError: number;  // config float
  WalkingAimError: number;  // config float
  RunningAimError: number;  // config float
  CrouchingAimError: number;  // config float
  RecoilBackDuration: number;  // config float
  RecoilForeDuration: number;  // config float
  RecoilMagnitude: number;  // config float
  AutoFireRecoilMagnitudeIncrement: number;  // config float
  DebugPerfectAim: boolean;  // config bool
  DebugDrawTraceFire: boolean;  // config bool
  DebugDrawAccuracyCone: boolean;  // config bool
  HasAttachedFlashlight: boolean;  // private config bool
  FlashlightPosition_1stPerson: THREE.Vector3;  // private config Vector
  FlashlightRotation_1stPerson: THREE.Euler;  // private config Rotator
  FlashlightPosition_3rdPerson: THREE.Vector3;  // private config Vector
  FlashlightRotation_3rdPerson: THREE.Euler;  // private config Rotator
  FlashlightProjection_IsInitializing: boolean;  // private bool
  FlashlightProjection_StartBoneName: string;  // private name
  FlashlightProjection_LastTestTime: number;  // private float
  FlashlightProjection_LastTestResult: boolean;  // private bool
  FlashlightProjection_LastTestSuccessfulHitLocation: THREE.Vector3;  // private Vector
  FlashlightProjection_LastSuccessfulTestTime: number;  // private float
  FlashlightProjection_CurrentBrightnessAlpha: number;  // private float
  FlashlightSpotLightClass: any /* class */;  // private config Class<Light>
  FlashlightPointLightClass: any /* class */;  // private config Class<Light>
  FlashlightCoronaLightClass: any /* class */;  // private config Class<Light>
  PointLightDistanceFraction: number;  // private config float
  PointLightRadiusScale: number;  // private config float
  PointLightDistanceFadeRate: number;  // private config float
  FlashlightDynamicLight: any /* light */;  // private Light
  FlashlightReferenceActor: any /* actor */;  // private Actor
  DebugDrawFlashlightDir: boolean;  // config bool
  FlashlightUseFancyLights: number;  // config int
  MinFlashlightBrightness: number;  // config float
  MinFlashlightRadius: number;  // config float
  FlashlightFirstPersonDistance: number;  // config float
  MaxFlashlightDistance: number;  // config float
  ThirdPersonFlashlightRadiusPenalty: number;  // config float
  bHighEndGraphicsBoard: boolean;  // private bool
  BaseFlashlightBrightness: number;  // private float
  BaseFlashlightRadius: number;  // private float
  AvailableFireMode: any /* firedweapon.firemode */[];  // config array<FiredWeapon.FireMode>
  CurrentFireMode: any /* firedweapon.firemode */;  //  FiredWeapon.FireMode
  FireModeIndex: number;  //  int
  BurstShotCount: number;  // private config int
  BurstShotsRemaining: number;  // private int
  BurstRateFactor: number;  // config float
  AutoFireShotIndex: number;  // private int
  PerfectAimNextShot: boolean;  // private bool
  RagdollDeathImpactMomentumMultiplier: number;  // private config float
  OverrideArmDamageModifier: number;  // private config float

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  IsHandheldEquipmentIdleHook(): boolean {
      // TODO: implement
  }

  IsFiredWeaponIdleHook(): boolean {
      // TODO: implement
  }

  IsBeingReloaded(): boolean {
      // TODO: implement
  }

  CanReload(): boolean {
      // TODO: implement
  }

  IsEmpty(): boolean {
      // TODO: implement
  }

  IsFull(): boolean {
      // TODO: implement
  }

  NeedsReload(): boolean {
      // TODO: implement
  }

  GetPerfectFireStart(outLocation: THREE.Vector3, outDirection: THREE.Euler): void {
      // TODO: implement
  }

  TraceFire(): void {
      // TODO: implement
  }

  SetPerfectAimNextShot(): void {
      // TODO: implement
  }

  ApplyAimError(FireDirection: THREE.Euler): void {
      // TODO: implement
  }

  ApplyRandomOffsetToRotation(OriginalRotation: THREE.Euler, OffsetHalfAngleRadians: number, NewRotation: THREE.Euler): void {
      // no body (native/abstract)
  }

  BallisticFire(StartTrace: THREE.Vector3, EndTrace: THREE.Vector3): void {
      // TODO: implement
  }

  DealDamage(Victim: any /* actor */, Damage: number, Instigator: any /* pawn */, HitLocation: THREE.Vector3, MomentumVector: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  HandleBallisticImpact(Victim: any /* actor */, HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, NormalizedBulletDirection: THREE.Vector3, HitMaterial: any /* material */, HitRegion: any /* actor.eskeletalregion */, Momentum: number, ExitLocation: THREE.Vector3, ExitNormal: THREE.Vector3, ExitMaterial: any /* material */): boolean {
      // TODO: implement
  }

  ShouldSpawnBloodForVictim(PawnVictim: any /* pawn */, Damage: number): boolean {
      // TODO: implement
  }

  SpawnBloodEffects(Ammo: any /* ammunition */, ExitLocation: THREE.Vector3, Damage: number, direction: THREE.Vector3): boolean {
      // TODO: implement
  }

  HandleProtectiveEquipmentBallisticImpact(Victim: any /* actor */, Protection: any /* protectiveequipment */, HitRegion: any /* actor.eskeletalregion */, HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, NormalizedBulletDirection: THREE.Vector3, Momentum: number): boolean {
      // TODO: implement
  }

  GetDamageType(): any /* class */ {
      // TODO: implement
  }

  OnGivenToOwner(): void {
      // TODO: implement
  }

  SelectAmmoClass(): void {
      // TODO: implement
  }

  Reload(): void {
      // TODO: implement
  }

  PreReload(): void {
      // TODO: implement
  }

  LatentReload(): void {
      // TODO: implement
  }

  NotifyClientsToDoAIReload(): void {
      // TODO: implement
  }

  PrevalidateReload(): boolean {
      // TODO: implement
  }

  ValidateReload(Prevalidate: boolean): boolean {
      // TODO: implement
  }

  HandheldEquipmentStatusString(): string {
      // TODO: implement
  }

  DoReloading(): void {
      // TODO: implement
  }

  OnReloadKeyFrame(): void {
      // TODO: implement
  }

  ReloadedHook(): void {
      // TODO: implement
  }

  PreUse(): void {
      // TODO: implement
  }

  DoUsingHook(): void {
      // TODO: implement
  }

  DoFiring(): void {
      // TODO: implement
  }

  BeginFiring(): void {
      // TODO: implement
  }

  EndFiring(): void {
      // TODO: implement
  }

  NotifyClientsAIBeginFiringWeapon(): void {
      // TODO: implement
  }

  NotifyClientsAIEndFiringWeapon(): void {
      // TODO: implement
  }

  WantsToContinueFiring(): boolean {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  PreRoundUsed(): void {
      // TODO: implement
  }

  PostRoundUsed(): void {
      // TODO: implement
  }

  NextFireMode(): void {
      // TODO: implement
  }

  HasFireMode(TestFireMode: any /* firedweapon.firemode */): boolean {
      // TODO: implement
  }

  SetCurrentFireMode(NewFireMode: any /* firedweapon.firemode */): void {
      // TODO: implement
  }

  GetCurrentFireMode(): any /* firedweapon.firemode */ {
      // TODO: implement
  }

  EquippedHook(): void {
      // TODO: implement
  }

  UnequippedHook(): void {
      // TODO: implement
  }

  GetBaseAimError(): number {
      // no body (native/abstract)
  }

  AddAimError(Penalty: any /* firedweapon.aimpenaltytype */): void {
      // TODO: implement
  }

  GetAimError(): number {
      // TODO: implement
  }

  Tick(dTime: number): void {
      // TODO: implement
  }

  UpdateAimError(dTime: number): void {
      // TODO: implement
  }

  HasFlashlight(): boolean {
      // TODO: implement
  }

  IsFlashlightOn(): boolean {
      // no body (native/abstract)
  }

  OnHolderDesiredFlashlightStateChanged(): void {
      // TODO: implement
  }

  UpdateFlashlightState(): void {
      // TODO: implement
  }

  UpdateFlashlightLighting(dTime: number): void {
      // TODO: implement
  }

  InitFlashlight(): void {
      // TODO: implement
  }

  IsFlashlightInitialized(): boolean {
      // no body (native/abstract)
  }

  IsFlashlightProjectionVisible(): boolean {
      // no body (native/abstract)
  }

  DestroyFlashlight(SecondsBeforeDestroying: number): void {
      // TODO: implement
  }

  OnPlayerViewChanged(): void {
      // TODO: implement
  }

  AIInterruptHandheldEquipmentHook(): void {
      // TODO: implement
  }

  AIInterrupt_Reloading(): void {
      // TODO: implement
  }

  GetRagdollDeathImpactMomentumMultiplier(): number {
      // TODO: implement
  }

  DrawAccuracyCone(SourceLocation: THREE.Vector3, SourceDirection: THREE.Euler): void {
      // TODO: implement
  }

  ApplyPolarOffset(outDirection: THREE.Euler, Rho: number, Theta: number): void {
      // TODO: implement
  }

}
