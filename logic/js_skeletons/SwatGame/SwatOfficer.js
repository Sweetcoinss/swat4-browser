// Auto-generated skeleton from UnrealScript: SwatGame/SwatOfficer.uc
// Parent: SwatAI

class SwatOfficer extends SwatAI {

  // Variables
  OfficerLoadOutType: string;  // private string
  LoadOut: any /* officerloadout */;  // private OfficerLoadOut
  CurrentFormation: any /* formation */;  // private Formation
  DoorToBlowC2On: any /* swatdoor */;  // private SwatDoor
  MinTimeToFireFullAuto: number;  // private config float
  MaxTimeToFireFullAuto: number;  // private config float
  ViewportOverlayMaterial: any /* material */;  // private config Material
  NextTimeCanReactToHarmlessShotByPlayer: number;  // private float
  DeltaReactionTimeBetweenHarmlessShot: number;  // private config float
  NotifyStoppedMovingTimer: any /* timer */;  //  Timer

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  EnteredZone(Zone: any /* zoneinfo */): void {
      // TODO: implement
  }

  AddToSquads(): void {
      // TODO: implement
  }

  RemoveFromSquads(): void {
      // TODO: implement
  }

  UpdateOfficerLOD(): void {
      // TODO: implement
  }

  ConstructCharacterAI(): void {
      // TODO: implement
  }

  ConstructMovementAI(): void {
      // TODO: implement
  }

  ConstructWeaponAI(): void {
      // TODO: implement
  }

  GetCurrentAssignment(): any /* pawn */ {
      // TODO: implement
  }

  IsAttackingPlayer(): boolean {
      // TODO: implement
  }

  NotifyHit(Damage: number, HitInstigator: any /* pawn */): void {
      // TODO: implement
  }

  NotifyBecameIncapacitated(Incapacitator: any /* pawn */): void {
      // TODO: implement
  }

  ShouldBecomeIncapacitated(): boolean {
      // TODO: implement
  }

  NotifyStartedMoving(): void {
      // TODO: implement
  }

  NotifyStoppedMoving(): void {
      // TODO: implement
  }

  NotifyStoppedMovingTimerCallback(): void {
      // TODO: implement
  }

  GetViewportOwner(): any /* actor */ {
      // TODO: implement
  }

  OffsetViewportRotation(ViewportRotation: THREE.Euler): void {
      // TODO: implement
  }

  AdjustMouseAcceleration(MouseAccel: THREE.Vector3): void {
      // TODO: implement
  }

  OnMouseAccelerated(MouseAccel: THREE.Vector3): void {
      // TODO: implement
  }

  GetViewportType(): string {
      // TODO: implement
  }

  GetViewportDescription(): string {
      // TODO: implement
  }

  GetViewportName(): string {
      // TODO: implement
  }

  CanIssueCommands(): boolean {
      // TODO: implement
  }

  OnBeginControlling(): void {
      // TODO: implement
  }

  OnEndControlling(): void {
      // TODO: implement
  }

  GetViewportLocation(): THREE.Vector3 {
      // TODO: implement
  }

  GetViewportDirection(): THREE.Euler {
      // TODO: implement
  }

  GetViewportPitchClamp(): number {
      // TODO: implement
  }

  GetViewportYawClamp(): number {
      // TODO: implement
  }

  SetRotationToViewport(inNewRotation: THREE.Euler): void {
      // TODO: implement
  }

  ShouldDrawViewport(): boolean {
      // TODO: implement
  }

  GetViewportOverlay(): any /* material */ {
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

  ShouldDrawReticle(): boolean {
      // TODO: implement
  }

  GetFOV(): number {
      // TODO: implement
  }

  HandleFire(): void {
      // TODO: implement
  }

  HandleAltFire(): void {
      // TODO: implement
  }

  HandleReload(): void {
      // TODO: implement
  }

  PlayTurnAwayAnimation(): void {
      // TODO: implement
  }

  InitLoadOut(LoadOutName: string): void {
      // TODO: implement
  }

  ReceiveLoadOut(): void {
      // TODO: implement
  }

  DestroyEquipment(): void {
      // TODO: implement
  }

  GetAwareness(): any /* awarenessproxy */ {
      // TODO: implement
  }

  DisableAwareness(): void {
      // TODO: implement
  }

  EnableAwareness(): void {
      // TODO: implement
  }

  IgnoresSeenPawnsOfType(SeenType: any /* class */): boolean {
      // TODO: implement
  }

  GetCurrentFormation(): any /* formation */ {
      // TODO: implement
  }

  SetCurrentFormation(Formation: any /* formation */): void {
      // TODO: implement
  }

  ClearFormation(): void {
      // TODO: implement
  }

  ShouldPlayFullBodyHitAnimation(): boolean {
      // TODO: implement
  }

  CanPawnUseLowReady(): boolean {
      // TODO: implement
  }

  GetStandingInjuredAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetCrouchingInjuredAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetMovementUpperBodyAimBehavior(): any /* iswatai.eupperbodyanimbehavior */ {
      // TODO: implement
  }

  GetThrownWeapon(Slot: any /* handheldequipment.equipmentslot */): any /* thrownweapon */ {
      // TODO: implement
  }

  GetItemAtSlot(Slot: any /* handheldequipment.equipmentslot */): any /* handheldequipment */ {
      // TODO: implement
  }

  GetLengthOfTimeToFireFullAuto(): number {
      // TODO: implement
  }

  GetPrimaryWeapon(): any /* firedweapon */ {
      // TODO: implement
  }

  GetBackupWeapon(): any /* firedweapon */ {
      // TODO: implement
  }

  HasUsableWeapon(): boolean {
      // TODO: implement
  }

  GetOfficerCommanderAction(): any /* officercommanderaction */ {
      // no body (native/abstract)
  }

  GetOfficerSpeechManagerAction(): any /* officerspeechmanageraction */ {
      // TODO: implement
  }

  SetDeployedC2Charge(Charge: any /* deployedc2chargebase */): void {
      // TODO: implement
  }

  GetDeployedC2Charge(): any /* deployedc2chargebase */ {
      // TODO: implement
  }

  ReEquipFiredWeapon(): void {
      // TODO: implement
  }

  InstantReEquipFiredWeapon(): void {
      // TODO: implement
  }

  HasTaser(): boolean {
      // TODO: implement
  }

  SetDoorToBlowC2On(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  PlayerBlockingPath(): void {
      // TODO: implement
  }

  GetEffectEventForReportingToTOCWhenDead(): string {
      // TODO: implement
  }

  GetEffectEventForReportingToTOCWhenArrested(): string {
      // TODO: implement
  }

  GetEffectEventForReportResponseFromTOCWhenIncapacitated(): string {
      // TODO: implement
  }

  GetEffectEventForReportResponseFromTOCWhenNotIncapacitated(): string {
      // TODO: implement
  }

  TriggerHarmlessShotSpeech(): void {
      // TODO: implement
  }

  ReactToCSGas(GasContainer: any /* actor */, Duration: number, SPPlayerProtectiveEquipmentDurationScaleFactor: number, MPPlayerProtectiveEquipmentDurationScaleFactor: number): void {
      // TODO: implement
  }

  ReactToBeingPepperSprayed(PepperSpray: any /* actor */, PlayerDuration: number, AIDuration: number, SPPlayerProtectiveEquipmentDurationScaleFactor: number, MPPlayerProtectiveEquipmentDurationScaleFactor: number): void {
      // TODO: implement
  }

  DrawLineToAssignment(DrawTarget: any /* hud */): void {
      // TODO: implement
  }

  ReadyToTriggerEffectEvents(): boolean {
      // TODO: implement
  }

}
