// Auto-generated skeleton from UnrealScript: Engine/Hands.uc
// Parent: Actor

class Hands extends Actor {

  // Variables
  PlayerViewOffset: THREE.Vector3;  // config Vector
  AnimationGroups: string[];  // config array<string>
  MinimumLongThrowSpeed: number;  // config float
  ThrowShortAnimation: string;  // config name
  ThrowLongAnimation: string;  // config name
  PreThrowAnimation: string;  // config name
  PreThrowTweenTime: number;  // config float
  PreThrowRootBone: number;  // config float
  bIsLowReady: boolean;  // private bool
  NextIdleTweenTime: number;  // private float

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

  onMessage(M: any /* message */): void {
      // TODO: implement
  }

  UpdateHandsForRendering(): void {
      // TODO: implement
  }

  OnEquipKeyFrame(): void {
      // TODO: implement
  }

  OnUnequipKeyFrame(): void {
      // TODO: implement
  }

  OnUseKeyFrame(): void {
      // TODO: implement
  }

  OnReloadKeyFrame(): void {
      // TODO: implement
  }

  AnimEnd(Channel: number): void {
      // TODO: implement
  }

  IdleHoldingEquipment(): void {
      // TODO: implement
  }

  PlayNewAnim(Sequence: string, Rate: number, TweenTime: number): void {
      // TODO: implement
  }

  SetLowReady(bEnable: boolean): void {
      // TODO: implement
  }

  SetNextIdleTweenTime(inNextIdleTweenTime: number): void {
      // TODO: implement
  }

  GetActiveItem(): any /* handheldequipment */ {
      // TODO: implement
  }

  GetPendingItem(): any /* handheldequipment */ {
      // TODO: implement
  }

  GetThrownProjectileParams(outLocation: THREE.Vector3, outRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetPawnThrowRootBone(): string {
      // TODO: implement
  }

  GetPawnThrowTweenTime(): number {
      // TODO: implement
  }

  GetPreThrowAnimation(): string {
      // TODO: implement
  }

  GetThrowAnimation(ThrowSpeed: number): string {
      // TODO: implement
  }

  SetMaterialForHands(NewMaterial: any /* material */): void {
      // TODO: implement
  }

}
