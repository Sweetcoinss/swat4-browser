// Auto-generated skeleton from UnrealScript: Engine/HandheldEquipment.uc
// Parent: Equipment

class HandheldEquipment extends Equipment {

  // Variables
  Range: number;  // config int
  FirstPersonModelClass: any /* class */;  // config Class<HandheldEquipmentModel>
  ThirdPersonModelClass: any /* class */;  // config Class<HandheldEquipmentModel>
  MPFirstPersonModelClass: any /* class */;  // config Class<HandheldEquipmentModel>
  MPThirdPersonModelClass: any /* class */;  // config Class<HandheldEquipmentModel>
  Description: string;  // config localized string
  FriendlyName: string;  // config localized string
  GUIImage: any /* material */;  // config Material
  ShouldLowReady: boolean;  //  bool
  ZoomedFOV: number;  // config float
  ZoomTime: number;  // config float
  ZoomBlurOverlay: any /* material */;  // config Material
  Slot: any /* handheldequipment.equipmentslot */;  // private HandheldEquipment.EquipmentSlot
  ThePocket: any /* handheldequipment.pocket */;  // private HandheldEquipment.Pocket
  FirstPersonModel: any /* handheldequipmentmodel */;  //  HandheldEquipmentModel
  ThirdPersonModel: any /* handheldequipmentmodel */;  //  HandheldEquipmentModel
  EquippingStatus: any /* handheldequipment.actionstatus */;  // private HandheldEquipment.ActionStatus
  UnequippingStatus: any /* handheldequipment.actionstatus */;  // private HandheldEquipment.ActionStatus
  UsingStatus: any /* handheldequipment.actionstatus */;  // private HandheldEquipment.ActionStatus
  EquipAnimationRate: number;  // config float
  UnequipAnimationRate: number;  // config float
  UseAnimationRate: number;  // config float
  Available: boolean;  // private bool
  UnavailableAfterUsed: boolean;  //  bool
  EquipOtherAfterUsed: boolean;  //  bool
  PlayerCanUnequip: boolean;  //  bool
  ShouldHaveFirstPersonModel: boolean;  // config bool
  ShouldHaveThirdPersonModel: boolean;  // config bool
  FramerateCompensationDelay: number;  //  float
  Pickup: any /* handheldequipmentpickup */;  //  HandheldEquipmentPickup

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  CreateModels(): void {
      // TODO: implement
  }

  SelectModelClasses(SelectedFirstPersonModelClass: any /* class */, SelectedThirdPersonModelClass: any /* class */): void {
      // TODO: implement
  }

  InFirstPersonView(): boolean {
      // no body (native/abstract)
  }

  GetHands(): any /* hands */ {
      // TODO: implement
  }

  GetSlot(): any /* handheldequipment.equipmentslot */ {
      // TODO: implement
  }

  SetSlot(NewSlot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  GetDefaultSlot(): any /* handheldequipment.equipmentslot */ {
      // TODO: implement
  }

  GetPocket(): any /* handheldequipment.pocket */ {
      // TODO: implement
  }

  SetPocket(NewPocket: any /* handheldequipment.pocket */): void {
      // TODO: implement
  }

  GetFirstPersonModel(): any /* handheldequipmentmodel */ {
      // no body (native/abstract)
  }

  GetThirdPersonModel(): any /* handheldequipmentmodel */ {
      // no body (native/abstract)
  }

  IsEquipped(): boolean {
      // TODO: implement
  }

  IsBeingUsed(): boolean {
      // TODO: implement
  }

  IsBeingEquipped(): boolean {
      // TODO: implement
  }

  IsBeingUnequipped(): boolean {
      // TODO: implement
  }

  IsIdle(): boolean {
      // TODO: implement
  }

  IsHandheldEquipmentIdleHook(): boolean {
      // TODO: implement
  }

  LogIdleInfo(): void {
      // TODO: implement
  }

  Equip(): void {
      // TODO: implement
  }

  PreEquip(): void {
      // TODO: implement
  }

  LatentEquip(): void {
      // TODO: implement
  }

  LatentWaitForIdleAndEquip(): void {
      // TODO: implement
  }

  AIInstantEquip(): void {
      // TODO: implement
  }

  ValidateEquip(): void {
      // TODO: implement
  }

  DoEquipping(): void {
      // TODO: implement
  }

  OnPreEquipped(): void {
      // TODO: implement
  }

  OnEquipKeyFrame(): void {
      // TODO: implement
  }

  EquippedHook(): void {
      // TODO: implement
  }

  UnEquip(): void {
      // TODO: implement
  }

  OnUnequipKeyFrame(): void {
      // TODO: implement
  }

  UnequippedHook(): void {
      // TODO: implement
  }

  HACK_QuickUnequipForAIDropWeapon(): void {
      // TODO: implement
  }

  OnPlayerViewChanged(): void {
      // TODO: implement
  }

  OnPlayerUse(): void {
      // TODO: implement
  }

  ShouldUseWhileLowReady(): boolean {
      // TODO: implement
  }

  ShouldLowReadyOnOfficers(): boolean {
      // TODO: implement
  }

  ShouldLowReadyOnArrestable(): boolean {
      // TODO: implement
  }

  HandleMultiplayerUse(): boolean {
      // TODO: implement
  }

  Use(): void {
      // TODO: implement
  }

  PreUse(): void {
      // TODO: implement
  }

  LatentUse(): void {
      // TODO: implement
  }

  PrevalidateUse(): boolean {
      // TODO: implement
  }

  ValidateUse(Prevalidate: boolean): boolean {
      // TODO: implement
  }

  DoUsing(): void {
      // TODO: implement
  }

  PreUsed(): void {
      // TODO: implement
  }

  DoUsingHook(): void {
      // TODO: implement
  }

  OnUsingBegan(): void {
      // TODO: implement
  }

  OnUseKeyFrame(ForceUse: boolean): void {
      // TODO: implement
  }

  UsedHook(): void {
      // TODO: implement
  }

  UpdateAvailability(): void {
      // TODO: implement
  }

  OnUsingFinished(): void {
      // TODO: implement
  }

  OnUsingFinishedHook(): void {
      // TODO: implement
  }

  IsAvailable(): boolean {
      // TODO: implement
  }

  SetAvailable(inAvailable: boolean): void {
      // TODO: implement
  }

  OnForgotten(): void {
      // TODO: implement
  }

  HandheldEquipmentStatusString(): string {
      // TODO: implement
  }

  DisplayDebug(Canvas: any /* canvas */, YL: number, YPos: number): void {
      // TODO: implement
  }

  GetDescription(): string {
      // TODO: implement
  }

  GetFriendlyName(): string {
      // TODO: implement
  }

  GetGUIImage(): any /* material */ {
      // TODO: implement
  }

  GetRenderableActorClass(): any /* class */ {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  GetSlotForReequip(): any /* handheldequipment.equipmentslot */ {
      // TODO: implement
  }

  AIInterrupt(): void {
      // TODO: implement
  }

  AIInterruptHandheldEquipmentHook(): void {
      // TODO: implement
  }

  AIInterrupt_Equipping(): void {
      // TODO: implement
  }

  AIInterrupt_Unequipping(): void {
      // TODO: implement
  }

  AIInterrupt_Using(): void {
      // TODO: implement
  }

  InterruptUsing(): void {
      // TODO: implement
  }

  UniqueID(): string {
      // TODO: implement
  }

}
