// Auto-generated skeleton from UnrealScript: Engine/HandheldEquipmentModel.uc
// Parent: Actor

class HandheldEquipmentModel extends Actor {

  // Variables
  IdleChanceSum: number;  //  int
  HolderUnequipFromMPCuffedAnimation: string;  // config name
  EquippedSocket: string;  //  name
  UnequippedSocket: string;  //  name
  HolderEquipAnimationChannel: number;  //  int
  HolderUnEquipAnimationChannel: number;  //  int
  HolderUseAnimationChannel: number;  //  int
  bIsEquipped: boolean;  // private bool
  HandheldEquipment: any /* handheldequipment */;  //  HandheldEquipment
  IsBusy: boolean;  // private bool
  HolderAnimationRootBone: string;  // config name
  SelectedUseAnimation: string;  //  name
  SelectedHolderUseAnimation: string;  //  name
  SelectedUseAnimationRate: number;  //  float
  SelectedHolderUseAnimationRate: number;  //  float
  DroppedStaticMesh: any /* staticmesh */;  //  StaticMesh
  bIsDropped: boolean;  //  bool
  WasPrimary: boolean;  // private bool
  MostRecentLocation: THREE.Vector3;  // private Vector
  bNotifiedOfWeaponAtRest: boolean;  // private bool
  AtRestCountdown: number;  // private int
  AtRestLocation: THREE.Vector3;  // private Vector
  AtRestRotation: THREE.Euler;  // private Rotator
  PrecomputedUniqueID: string;  // private string

  constructor() {
    super();
  }

  // Methods
  PostNetBeginPlay(): void {
      // TODO: implement
  }

  FellOutOfWorld(KillType: any /* actor.ekillztype */): void {
      // TODO: implement
  }

  ProcessAtRestValuesFromServer(ServerLocation: THREE.Vector3, ServerRotation: THREE.Euler): void {
      // TODO: implement
  }

  SetHandHeldEquipment(HHE: any /* handheldequipment */): void {
      // TODO: implement
  }

  IsEquipped(): boolean {
      // TODO: implement
  }

  SetEquipped(Equipped: boolean): void {
      // TODO: implement
  }

  PlayEquip(): void {
      // TODO: implement
  }

  FinishEquip(): void {
      // TODO: implement
  }

  OnEquipKeyFrame(): void {
      // TODO: implement
  }

  PlayUnequip(): void {
      // TODO: implement
  }

  FinishUnequip(): void {
      // TODO: implement
  }

  GetHolderUnequipAnimationForContext(): string {
      // TODO: implement
  }

  OnUnequipKeyFrame(): void {
      // TODO: implement
  }

  PlayUse(TweenTime: number): void {
      // TODO: implement
  }

  FinishUse(): void {
      // TODO: implement
  }

  OnUseKeyFrame(): void {
      // TODO: implement
  }

  SelectUseAnimations(outSelectedUseAnimation: string, outSelectedUseAnimationRate: number, outSelectedHolderUseAnimation: string, outSelectedHolderUseAnimationRate: number, outAnimPlayType: any /* pawn.eanimplaytype */): void {
      // TODO: implement
  }

  OnDropped(bPrimary: boolean): void {
      // TODO: implement
  }

  NotifyClientsDroppedWeaponAtRest(): void {
      // TODO: implement
  }

  NotifyClientsAIDroppedWeapon(ThrowDirectionImpulse: THREE.Vector3): void {
      // TODO: implement
  }

  IsDropped(): boolean {
      // TODO: implement
  }

  OnUsed(SecurerPawn: any /* pawn */): void {
      // TODO: implement
  }

  CanBeUsedNow(): boolean {
      // TODO: implement
  }

  PostUsed(): void {
      // TODO: implement
  }

  SetUniqueID(NewValue: string): void {
      // TODO: implement
  }

  UniqueID(): string {
      // TODO: implement
  }

}
