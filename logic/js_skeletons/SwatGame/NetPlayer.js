// Auto-generated skeleton from UnrealScript: SwatGame/NetPlayer.uc
// Parent: SwatPlayer

class NetPlayer extends SwatPlayer {

  // Variables
  DynamicLoadOutSpec: any /* dynamicloadoutspec */;  // private DynamicLoadOutSpec
  bThisPlayerIsTheVIP: boolean;  // private bool
  QualifyTime: number;  // private float
  BeingCuffedTargetLocation: THREE.Vector3;  // private Vector
  BeingCuffedTargetRotation: THREE.Euler;  // private Rotator
  IdealCuffingDistanceBetweenPawns: number;  // private config float
  TeamNumber: number;  // private int
  VIPMesh: any /* mesh */;  //  Mesh
  bLoadOutInitialized: boolean;  // private bool
  LoadOutSpecCount: number;  // private int
  SkinsCount: number;  // private int
  CurrentWeaponPocket: any /* handheldequipment.pocket */;  // private HandheldEquipment.Pocket
  CurrentClip: number;  // private int
  VoiceType: any /* swatguiconfig.evoicetype */;  //  SwatGUIConfig.eVoiceType
  SwatPlayerID: number;  //  int
  ViewportOverlayMaterial: any /* material */;  // private config Material

  constructor() {
    super();
  }

  // Methods
  UniqueID(): string {
      // TODO: implement
  }

  InitializeReplicatedCounts(): void {
      // TODO: implement
  }

  AllVarsHaveReplicated(): boolean {
      // no body (native/abstract)
  }

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  PostReplication(): void {
      // TODO: implement
  }

  GetStandingWalkAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingRunAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetCrouchingAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  MoveIntoBeingCuffedPosition(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  StopMovingIntoBeingCuffedPosition(): void {
      // TODO: implement
  }

  OnArrestBegan(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnArrestedSwatPawn(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnArrestInterrupted(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  CanBeUsedByToolkitNow(): boolean {
      // TODO: implement
  }

  OnUsingByToolkitBegan(Unarrester: any /* pawn */): void {
      // TODO: implement
  }

  OnUsedByToolkit(Unarrester: any /* pawn */): void {
      // TODO: implement
  }

  OnUsingByToolkitInterrupted(Unarrester: any /* pawn */): void {
      // TODO: implement
  }

  GetQualifyTimeForToolkit(): number {
      // TODO: implement
  }

  SetPlayerSkins(inLoadOut: any /* officerloadout */): void {
      // TODO: implement
  }

  PrintLoadOutSpecToMPLog(): void {
      // TODO: implement
  }

  SetPocketItemClass(Pocket: any /* handheldequipment.pocket */, Item: any /* class */): void {
      // TODO: implement
  }

  SetPocketItemClassName(Pocket: any /* handheldequipment.pocket */, ItemClassName: string): void {
      // TODO: implement
  }

  GetPocketItem(Pocket: any /* handheldequipment.pocket */): any /* class */ {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  GetTeamNumber(): number {
      // TODO: implement
  }

  GetNetTeam(): any /* netteam */ {
      // TODO: implement
  }

  SetIsVIP(): void {
      // TODO: implement
  }

  IsTheVIP(): boolean {
      // TODO: implement
  }

  OnDoorUnlocked(TheDoor: any /* swatdoor */): void {
      // TODO: implement
  }

  GetLoadoutSpec(): any /* dynamicloadoutspec */ {
      // TODO: implement
  }

  CopyReplicatedSpecToDynamicSpec(): void {
      // TODO: implement
  }

  TakeDamageEffectsHook(Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  OnEquippingFinished(): void {
      // TODO: implement
  }

  OnUsingFinished(): void {
      // TODO: implement
  }

  OnReloadingFinished(): void {
      // TODO: implement
  }

  UpdateAmmoInfo(): void {
      // TODO: implement
  }

  OnAmmoInfoChanged(): void {
      // TODO: implement
  }

  GetViewportOverlay(): any /* material */ {
      // TODO: implement
  }

  GetViewportDirection(): THREE.Euler {
      // TODO: implement
  }

  UpdateBeingCuffedRotation(): void {
      // TODO: implement
  }

  UpdateBeingCuffedLocation(): void {
      // TODO: implement
  }

}
