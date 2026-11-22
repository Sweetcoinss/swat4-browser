// Auto-generated skeleton from UnrealScript: Engine/Inventory.uc
// Parent: Actor

class Inventory extends Actor {

  // Variables
  InventoryGroup: number;  //  byte
  GroupOffset: number;  //  byte
  bDisplayableInv: boolean;  //  bool
  bDrawingFirstPerson: boolean;  //  bool
  BobDamping: number;  //  float
  ItemName: string;  // localized string

  constructor() {
    super();
  }

  // Methods
  updaterelative(Pitch: number, Yaw: number, Roll: number): void {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  RecommendWeapon(rating: number): any /* weapon */ {
      // TODO: implement
  }

  TravelPreAccept(): void {
      // TODO: implement
  }

  TravelPostAccept(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  GiveTo(Other: any /* pawn */): void {
      // TODO: implement
  }

  Use(Value: number): void {
      // TODO: implement
  }

  WeaponChange(F: number, bSilent: boolean): any /* weapon */ {
      // TODO: implement
  }

  PrevWeapon(CurrentChoice: any /* weapon */, CurrentWeapon: any /* weapon */): any /* weapon */ {
      // TODO: implement
  }

  NextWeapon(CurrentChoice: any /* weapon */, CurrentWeapon: any /* weapon */): any /* weapon */ {
      // TODO: implement
  }

  OwnerEvent(EventName: string): void {
      // TODO: implement
  }

  SetOwnerDisplay(): void {
      // TODO: implement
  }

  StaticItemName(): string {
      // TODO: implement
  }

}
