// Auto-generated skeleton from UnrealScript: SwatGame/SniperPawn.uc
// Parent: SwatPawn

class SniperPawn extends SwatPawn {

  // Variables
  SniperOverlay: any /* material */;  // private config Material
  SniperRifleClass: any /* class */;  // private config Class<FiredWeapon>
  SniperRifle: any /* firedweapon */;  // private FiredWeapon
  CurrentFOV: number;  // private float
  FOVLevels: number[];  // config array<float>
  NoiseAmplitudeByFOVLevel: number[];  // config array<float>
  FOVIndex: number;  // private int
  RotationOffset: THREE.Euler;  // private Rotator
  ReloadSoundTime: number;  // private config float
  ReloadSoundTimer: any /* timer */;  // private Timer
  ReloadTime: number;  // private config float
  ReloadTimer: any /* timer */;  // private Timer
  bReloading: boolean;  // private bool
  InitialRotation: THREE.Euler;  // private Rotator
  PerlinNoiseYaw: any /* perlinnoise */;  // private PerlinNoise
  PerlinNoisePitch: any /* perlinnoise */;  // private PerlinNoise
  LastDeltaTime: number;  // private float
  kSniperBaseFrequency: number;  // private const config float
  kSniperMovementAddedFrequency: number;  // private const config float
  kSniperBaseAmplitude: number;  // private const config float
  kSniperMovementAmplitude: number;  // private const config float
  kSniperMovementZeroedSpeed: number;  // private const config float
  kSniperHorizontalNoiseDamping: number;  // private const config float
  ScaledMovementAmplitude: number;  // private float
  AddedMovementFrequency: number;  // private float

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  OnReloadSoundTimer(): void {
      // TODO: implement
  }

  OnReloadTimer(): void {
      // TODO: implement
  }

  GetViewportOwner(): any /* actor */ {
      // TODO: implement
  }

  GetViewportType(): string {
      // TODO: implement
  }

  GetViewportName(): string {
      // TODO: implement
  }

  OnMouseAccelerated(MouseAccel: THREE.Vector3): void {
      // TODO: implement
  }

  AdjustMouseAcceleration(MouseAccel: THREE.Vector3): void {
      // TODO: implement
  }

  GetScaledNoiseAmplitude(): number {
      // TODO: implement
  }

  OffsetViewportRotation(ViewportRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetViewportDescription(): string {
      // TODO: implement
  }

  CanIssueCommands(): boolean {
      // TODO: implement
  }

  GetViewportLocation(): THREE.Vector3 {
      // TODO: implement
  }

  GetViewportDirection(): THREE.Euler {
      // TODO: implement
  }

  SetRotationToViewport(inNewRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetViewportPitchClamp(): number {
      // TODO: implement
  }

  GetViewportYawClamp(): number {
      // TODO: implement
  }

  GetViewportOverlay(): any /* material */ {
      // TODO: implement
  }

  ShouldDrawViewport(): boolean {
      // TODO: implement
  }

  ShouldDrawReticle(): boolean {
      // TODO: implement
  }

  GetFOV(): number {
      // TODO: implement
  }

  HandleReload(): void {
      // TODO: implement
  }

  HandleFire(): void {
      // TODO: implement
  }

  HandleAltFire(): void {
      // TODO: implement
  }

  GetOriginalDirection(): THREE.Euler {
      // TODO: implement
  }

  GetViewportPitchSpeed(): number {
      // TODO: implement
  }

  GetViewportYawSpeed(): number {
      // TODO: implement
  }

  OnBeginControlling(): void {
      // TODO: implement
  }

  OnEndControlling(): void {
      // TODO: implement
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

}
