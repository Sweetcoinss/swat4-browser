// Auto-generated skeleton from UnrealScript: Engine/FiredWeaponModel.uc
// Parent: HandheldEquipmentModel

class FiredWeaponModel extends HandheldEquipmentModel {

  // Variables
  HolderReloadAnimationChannel: number;  //  int
  SelectedReloadAnimation: string;  //  name
  SelectedHolderReloadAnimation: string;  //  name
  ReloadTweenTime: number;  // config float

  constructor() {
    super();
  }

  // Methods
  PostNetBeginPlay(): void {
      // TODO: implement
  }

  SetHandHeldEquipment(HHE: any /* handheldequipment */): void {
      // TODO: implement
  }

  PlayReload(): void {
      // TODO: implement
  }

  FinishReload(): void {
      // TODO: implement
  }

  OnReloadKeyFrame(): void {
      // TODO: implement
  }

  SelectReloadAnimation(): string {
      // TODO: implement
  }

  SelectHolderReloadAnimation(): string {
      // TODO: implement
  }

  SelectUseAnimations(outSelectedUseAnimation: string, outSelectedUseAnimationRate: number, outSelectedHolderUseAnimation: string, outSelectedHolderUseAnimationRate: number, outAnimPlayType: any /* pawn.eanimplaytype */): void {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

}
