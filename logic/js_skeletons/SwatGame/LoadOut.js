// Auto-generated skeleton from UnrealScript: SwatGame/LoadOut.uc
// Parent: LoadOutValidationBase

class LoadOut extends LoadOutValidationBase {

  constructor() {
    super();
  }

  // Methods
  Initialize(DynamicSpec: any /* dynamicloadoutspec */): void {
      // TODO: implement
  }

  MutateLoadOutSpec(DynamicSpec: any /* dynamicloadoutspec */): void {
      // TODO: implement
  }

  ValidateLoadOutSpec(): boolean {
      // TODO: implement
  }

  ValidateEquipmentForPocket(pock: any /* handheldequipment.pocket */, CheckClass: any /* class */): boolean {
      // TODO: implement
  }

  DLOClassForPocket(pock: any /* handheldequipment.pocket */, Index: number): any /* class */ {
      // TODO: implement
  }

  CheckValidity(Type: any /* swatguiconfig.enetworkvalidity */): boolean {
      // TODO: implement
  }

  SpawnEquipmentFromLoadOutSpec(): void {
      // TODO: implement
  }

  SpawnEquipmentForPocket(i: any /* handheldequipment.pocket */, EquipmentClass: any /* class */): void {
      // TODO: implement
  }

  AddExistingItemToPocket(i: any /* handheldequipment.pocket */, Item: any /* actor */): void {
      // TODO: implement
  }

  PrintLoadOutToMPLog(): void {
      // TODO: implement
  }

  GetItemAtSlot(Slot: any /* handheldequipment.equipmentslot */): any /* handheldequipment */ {
      // TODO: implement
  }

  GetItemAtPocket(ThePocket: any /* handheldequipment.pocket */): any /* actor */ {
      // TODO: implement
  }

  GetPrimaryWeapon(): any /* firedweapon */ {
      // TODO: implement
  }

  GetBackupWeapon(): any /* firedweapon */ {
      // TODO: implement
  }

  GetMaterial(pock: any /* loadoutvalidationbase.materialpocket */): any /* material */ {
      // TODO: implement
  }

  GetNameMaterial(): any /* material */ {
      // TODO: implement
  }

  GetFaceMaterial(): any /* material */ {
      // TODO: implement
  }

  GetVestMaterial(): any /* material */ {
      // TODO: implement
  }

  GetPantsMaterial(): any /* material */ {
      // TODO: implement
  }

  HasHeavyArmor(): boolean {
      // TODO: implement
  }

  FindItemToReplace(PickedUp: any /* handheldequipment */): any /* handheldequipment */ {
      // TODO: implement
  }

  OnPickedUp(Item: any /* handheldequipment */): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

}
