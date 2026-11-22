// Auto-generated skeleton from UnrealScript: SwatGame/SwatPlayer.uc
// Parent: SwatRagdollPawn

class SwatPlayer extends SwatRagdollPawn {

  // Variables
  LoadOut: any /* officerloadout */;  // private OfficerLoadOut
  ThrownProjectilePitch: number;  // config int
  MinimumLongThrowSpeed: number;  // config float
  PreThrowAnimation: string;  // config name
  ThrowShortAnimation: string;  // config name
  ThrowLongAnimation: string;  // config name
  ThrowAnimationRootBone: string;  // config name
  ThrowAnimationTweenTime: number;  // config float
  ThrowSpeedTimeFactor: number;  // config float
  ThrowSpeedRange: any /* range */;  // config Range
  SuspectHandsMaterial: any /* material */;  // private Material
  VIPHandsMaterial: any /* material */;  // private Material
  bTestingCameraEffects: boolean;  // config bool
  StungTimer: any /* timer */;  // private Timer
  FlashbangedTimer: any /* timer */;  // private Timer
  GassedTimer: any /* timer */;  // private Timer
  PepperSprayedTimer: any /* timer */;  // private Timer
  TasedTimer: any /* timer */;  // private Timer
  LastStingWeapon: any /* swatplayer.elaststingweapon */;  //  SwatPlayer.ELastStingWeapon
  LastStungTime: number;  //  float
  LastStungDuration: number;  //  float
  LastFlashbangedTime: number;  //  float
  LastGassedTime: number;  //  float
  LastGassedDuration: number;  //  float
  LastPepperedTime: number;  //  float
  LastPepperedDuration: number;  //  float
  LastTasedTime: number;  //  float
  LastTasedDuration: number;  //  float
  bIsTriggered_ReactedBang: number;  // private byte
  bIsTriggered_ReactedGas: number;  // private byte
  bIsTriggered_ReactedPepper: number;  // private byte
  bIsTriggered_ReactedSting: number;  // private byte
  bIsTriggered_ReactedTaser: number;  // private byte
  PerlinNoiseAxisA: any /* perlinnoise */;  // private PerlinNoise
  PerlinNoiseAxisB: any /* perlinnoise */;  // private PerlinNoise
  StingEffectDropOffTimePercent: number;  // config float
  StingEffectFrequency: number;  // config float
  StingViewEffectAmplitude: THREE.Euler;  // config Rotator
  StingInputEffectMagnitude: number;  // config float
  TasedViewEffectAmplitude: number;  // config float
  TasedViewEffectFrequency: number;  // config float
  EquipOtherAfterUsed: boolean;  //  bool
  SlotForReequip: any /* handheldequipment.equipmentslot */;  //  HandheldEquipment.EquipmentSlot
  DoneThrowing: boolean;  //  bool
  ThrowHeldTime: number;  //  float
  bForceCrouchWhileOptiwanding: boolean;  // private bool
  bIsUsingOptiwand: boolean;  // private bool
  DeployedC2Charge: any /* deployedc2chargebase */;  // private DeployedC2ChargeBase
  LowReadyFireTweenTime: number;  // config float
  CurrentReportableCharacter: any /* iamreportablecharacter */;  // private IAmReportableCharacter
  bNotifiedPlayerTheyAreVIP: boolean;  // private bool
  LastArrester: any /* swatplayer */;  //  SwatPlayer
  OneFrameNudgeDirection: THREE.Vector3;  // private Vector
  LimpThreshold: number;  // private const config float
  CurrentLimp: number;  // private config float
  StandardLimpPenalty: number;  // private config float
  YouString: string;  // private config localized string
  PawnModelApparentBaseEyeHeight: number;  // private config float
  PawnModelApparentCrouchEyeHeight: number;  // private config float
  bHasBeenReportedToTOC: boolean;  // private bool
  CommandArrow: any /* commandarrow */;  // private CommandArrow
  CachedQualifyEquipment: any /* equipmentusedonother */;  //  EquipmentUsedOnOther
  CachedQualifyTarget: any /* actor */;  //  Actor

  constructor() {
    super();
  }

  // Methods
  GetViewportOwner(): any /* actor */ {
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

  OffsetViewportRotation(ViewportRotation: THREE.Euler): void {
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

  ShouldDrawReticle(): boolean {
      // TODO: implement
  }

  GetViewportOverlay(): any /* material */ {
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

  PreBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  InitializeHands(): void {
      // TODO: implement
  }

  InitAnimationForCurrentMesh(): void {
      // TODO: implement
  }

  FaceRotation(NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  ClientFaceRotation(NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetHandgunLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetSubMachineGunLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetMachineGunLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetShotgunLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetThrownWeaponLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetTacticalAidLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetPepperSprayLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetM4LowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetUMPLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetOptiwandLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetPaintballLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  CanPawnUseLowReady(): boolean {
      // TODO: implement
  }

  SetLowReady(bEnable: boolean, Reason: string): void {
      // TODO: implement
  }

  GetLoadOut(): any /* officerloadout */ {
      // TODO: implement
  }

  ReceiveLoadOut(inLoadOut: any /* officerloadout */): void {
      // TODO: implement
  }

  HasA(HandheldEquipmentName: string): boolean {
      // no body (native/abstract)
  }

  SetPlayerSkins(inLoadOut: any /* officerloadout */): void {
      // TODO: implement
  }

  DoDefaultEquip(): void {
      // TODO: implement
  }

  ValidateEquipSlot(Slot: any /* handheldequipment.equipmentslot */): boolean {
      // TODO: implement
  }

  ValidateEquipPocket(ThePocket: any /* handheldequipment.pocket */): boolean {
      // TODO: implement
  }

  SetProtection(Region: any /* actor.eskeletalregion */, Protection: any /* protectiveequipment */): void {
      // TODO: implement
  }

  DestroyEquipment(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  Died(Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3): void {
      // TODO: implement
  }

  ServerRequestEquip(Slot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  OnActiveItemEquipped(): void {
      // TODO: implement
  }

  AuthorizedEquipOnServer(Slot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  ServerRequestReload(Slot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  ServerRequestUse(inUsePawn: any /* swatplayer */): void {
      // TODO: implement
  }

  ClientUse(inUsePawn: any /* pawn */): void {
      // TODO: implement
  }

  ServerRequestQualify(DefaultFireFocusActor: any /* actor */): void {
      // TODO: implement
  }

  ClientStartQualify(Qualifier: any /* swatplayer */, QualifyTarget: any /* actor */): void {
      // TODO: implement
  }

  WeHaveACachedQualify(): boolean {
      // TODO: implement
  }

  BeginCachedQualification(): void {
      // TODO: implement
  }

  NotifyClientsOfFinishQualify(QualifyTarget: any /* actor */, success: boolean): void {
      // TODO: implement
  }

  ClientFinishQualify(Qualifier: any /* swatplayer */, QualifyTarget: any /* actor */, success: boolean): void {
      // TODO: implement
  }

  DesiredItemPocketChanged(): void {
      // TODO: implement
  }

  OnEquippingFinished(): void {
      // TODO: implement
  }

  NotifyPlayerHeIsVIPIfNecessary(): void {
      // TODO: implement
  }

  OnUsingBegan(): void {
      // TODO: implement
  }

  SetupReequip(): void {
      // TODO: implement
  }

  OnUsingFinished(): void {
      // TODO: implement
  }

  IWasNonlethaledAndFinishedSoDoAnEquipIfINeedToDoOne(): void {
      // TODO: implement
  }

  OnReloadingFinished(): void {
      // TODO: implement
  }

  CheckDesiredItemAndEquipIfNeeded(): boolean {
      // TODO: implement
  }

  GetEquipmentAtSlot(Slot: any /* handheldequipment.equipmentslot */): any /* handheldequipment */ {
      // TODO: implement
  }

  ValidateReload(): boolean {
      // TODO: implement
  }

  GetFireTweenTime(): number {
      // TODO: implement
  }

  HandsShouldIdle(): boolean {
      // TODO: implement
  }

  IsInProcessOfThrowing(): boolean {
      // TODO: implement
  }

  CanThrowPrep(): boolean {
      // TODO: implement
  }

  RequestEquipShouldBeAllowed(): boolean {
      // TODO: implement
  }

  EndThrow(ThrowHeldTimeFromNetwork: number): void {
      // TODO: implement
  }

  GetThrownProjectileParams(outLocation: THREE.Vector3, outRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetPreThrowAnimation(): string {
      // TODO: implement
  }

  GetThrowAnimation(ThrowSpeed: number): string {
      // TODO: implement
  }

  GetPawnThrowRootBone(): string {
      // TODO: implement
  }

  GetPawnThrowTweenTime(): number {
      // TODO: implement
  }

  IsPlayerPawn(): boolean {
      // TODO: implement
  }

  IsHumanControlled(): boolean {
      // TODO: implement
  }

  ServerBeginFiringWeapon(ItemSlot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  BroadcastEmptyFiredToClients(): void {
      // TODO: implement
  }

  ClientPlayEmptyFired(PawnWhoFired: any /* pawn */): void {
      // TODO: implement
  }

  ServerEndFiringWeapon(): void {
      // TODO: implement
  }

  ReactToFlashbangGrenade(Grenade: any /* swatgrenadeprojectile */, Instigator: any /* pawn */, Damage: number, DamageRadius: number, KarmaImpulse: any /* range */, KarmaImpulseRadius: number, StunRadius: number, PlayerFlashbangStunDuration: number, AIStunDuration: number, MoraleModifier: number): void {
      // TODO: implement
  }

  ClientDoFlashbangReaction(): void {
      // TODO: implement
  }

  ReactToCSGas(GasContainer: any /* actor */, Duration: number, SPPlayerProtectiveEquipmentDurationScaleFactor: number, MPPlayerProtectiveEquipmentDurationScaleFactor: number): void {
      // TODO: implement
  }

  ClientDoGassedReaction(Duration: number): void {
      // TODO: implement
  }

  ReactToStingGrenade(Grenade: any /* swatgrenadeprojectile */, Instigator: any /* pawn */, Damage: number, DamageRadius: number, KarmaImpulse: any /* range */, KarmaImpulseRadius: number, StingRadius: number, PlayerStingDuration: number, HeavilyArmoredPlayerStingDuration: number, AIStingDuration: number, MoraleModifier: number): void {
      // TODO: implement
  }

  ClientDoStungReaction(PlayerDuration: number, iLastStingWeapon: any /* swatplayer.elaststingweapon */): void {
      // TODO: implement
  }

  ReactToBeingPepperSprayed(PepperSpray: any /* actor */, PlayerDuration: number, AIDuration: number, SPPlayerProtectiveEquipmentDurationScaleFactor: number, MPPlayerProtectiveEquipmentDurationScaleFactor: number): void {
      // TODO: implement
  }

  ClientDoPepperSprayedReaction(PlayerDuration: number): void {
      // TODO: implement
  }

  ReactToBeingTased(Taser: any /* actor */, PlayerDuration: number, AIDuration: number): void {
      // TODO: implement
  }

  ClientDoTasedReaction(PlayerDuration: number): void {
      // TODO: implement
  }

  IsVulnerableToTaser(): boolean {
      // TODO: implement
  }

  ReactToC2Detonation(C2Charge: any /* actor */, StunRadius: number, AIStunDuration: number): void {
      // TODO: implement
  }

  OnFlashbangedTimerExpired(): void {
      // TODO: implement
  }

  ClientOnFlashbangTimerExpired(): void {
      // TODO: implement
  }

  OnGassedTimerExpired(): void {
      // TODO: implement
  }

  ClientOnGassedTimerExpired(): void {
      // TODO: implement
  }

  OnStungTimerExpired(): void {
      // TODO: implement
  }

  ClientOnStungTimerExpired(): void {
      // TODO: implement
  }

  OnPepperSprayedTimerExpired(): void {
      // TODO: implement
  }

  ClientOnPepperSprayedTimerExpired(): void {
      // TODO: implement
  }

  OnTasedTimerExpired(): void {
      // TODO: implement
  }

  ClientOnTasedTimerExpired(): void {
      // TODO: implement
  }

  RefreshNonlethalCommon(): void {
      // TODO: implement
  }

  RefreshCameraEffects(Pawn: any /* swatplayer */): void {
      // TODO: implement
  }

  UpdateNonLethalEffectEvents(): void {
      // no body (native/abstract)
  }

  UnTriggerAllNonLethalEffectEvents(): void {
      // no body (native/abstract)
  }

  ResetNonlethalEffects(): void {
      // TODO: implement
  }

  OnbIsTasedChanged(): void {
      // TODO: implement
  }

  OnNonlethalEffectChanged(): void {
      // TODO: implement
  }

  OnCurrentLimpChanged(): void {
      // TODO: implement
  }

  OnQualifyInterrupted(): void {
      // TODO: implement
  }

  OnQualifyCompleted(): void {
      // TODO: implement
  }

  SetDeployedC2Charge(Charge: any /* deployedc2chargebase */): void {
      // TODO: implement
  }

  GetDeployedC2Charge(): any /* deployedc2chargebase */ {
      // TODO: implement
  }

  CanBeArrestedNow(): boolean {
      // TODO: implement
  }

  CanBeUnarrestedNow(): boolean {
      // TODO: implement
  }

  GetQualifyTimeForArrest(): number {
      // TODO: implement
  }

  AuthorizedInterruptQualification(): void {
      // TODO: implement
  }

  GetViewPoint(): THREE.Vector3 {
      // no body (native/abstract)
  }

  GetThirdPersonEyesLocation(): THREE.Vector3 {
      // TODO: implement
  }

  ViewRotationOffset(): THREE.Euler {
      // TODO: implement
  }

  ViewLocationOffset(CameraRotation: THREE.Euler): THREE.Vector3 {
      // TODO: implement
  }

  CalcDrawOffset(): THREE.Vector3 {
      // TODO: implement
  }

  GetViewRotation(): THREE.Euler {
      // TODO: implement
  }

  ApplyRotationOffset(Acceleration: THREE.Vector3): void {
      // TODO: implement
  }

  GetStungRotationOffset(): THREE.Euler {
      // TODO: implement
  }

  ApplyStungRotationOffset(Acceleration: THREE.Vector3): void {
      // TODO: implement
  }

  GetTasedViewLocationOffset(CameraRotation: THREE.Euler): THREE.Vector3 {
      // TODO: implement
  }

  ScaleStingEffectAmplitude(Amplitude: number, DurationAlpha: number): number {
      // TODO: implement
  }

  GetLeanPositionOffset(): THREE.Vector3 {
      // no body (native/abstract)
  }

  GetLeanRotationOffset(): THREE.Euler {
      // no body (native/abstract)
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  IsTheVIP(): boolean {
      // TODO: implement
  }

  IsLowerBodyInjured(): boolean {
      // TODO: implement
  }

  OnSkeletalRegionHit(RegionHit: any /* actor.eskeletalregion */, HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, Damage: number, DamageType: any /* class */, Instigator: any /* actor */): void {
      // TODO: implement
  }

  FindItemForPickupToReplace(PickedUp: any /* handheldequipment */): any /* handheldequipment */ {
      // TODO: implement
  }

  OnPickedUp(PickedUp: any /* handheldequipment */): void {
      // TODO: implement
  }

  EndCrouch(HeightAdjust: number): void {
      // TODO: implement
  }

  StartCrouch(HeightAdjust: number): void {
      // TODO: implement
  }

  SetForceCrouchState(inbForceCrouch: boolean): void {
      // TODO: implement
  }

  SetForceCrouchWhileOptiwanding(B: boolean): void {
      // TODO: implement
  }

  ServerSetForceCrouchWhileOptiwanding(B: boolean): void {
      // TODO: implement
  }

  IsUsingOptiwand(): boolean {
      // TODO: implement
  }

  SetIsUsingOptiwand(B: boolean): void {
      // TODO: implement
  }

  ServerSetIsUsingOptiwand(B: boolean): void {
      // TODO: implement
  }

  SetOneFrameNudgeDirection(direction: THREE.Vector3): void {
      // TODO: implement
  }

  ApplyOneFrameNudgeRotationOffset(Acceleration: THREE.Vector3): void {
      // TODO: implement
  }

  OnReportableReportedToTOC(ReportableCharacter: any /* iamreportablecharacter */, Reporter: any /* pawn */): void {
      // TODO: implement
  }

  BroadcastReportableReportedToTOC(ReportableCharacter: any /* iamreportablecharacter */, inUniqueID: string, PlayerTag: string, PlayerName: string): void {
      // TODO: implement
  }

  OnClientReportableReportedToTOC(ReportableCharacter: any /* iamreportablecharacter */, inUniqueID: string, PlayerTag: string, PlayerName: string): void {
      // TODO: implement
  }

  TriggerNonLethaledEffectEvent(EffectEventName: string): void {
      // TODO: implement
  }

  UnTriggerNonLethaledEffectEvent(EffectEventName: string): void {
      // TODO: implement
  }

  GetPlayerTag(): string {
      // TODO: implement
  }

  OnEffectStarted(inStartedEffect: any /* actor */): void {
      // TODO: implement
  }

  OnEffectStopped(inStoppedEffect: any /* actor */, Completed: boolean): void {
      // TODO: implement
  }

  OnEffectInitialized(inInitializedEffect: any /* actor */): void {
      // TODO: implement
  }

  CanBeUsedNow(): boolean {
      // TODO: implement
  }

  OnUsed(Other: any /* pawn */): void {
      // TODO: implement
  }

  PostUsed(): void {
      // TODO: implement
  }

  GetEffectEventForReportingToTOC(): string {
      // TODO: implement
  }

  GetEffectEventForReportResponseFromTOC(): string {
      // TODO: implement
  }

  ShowCommandArrow(inLifeSpan: number, inSource: any /* actor */, inTarget: any /* actor */, inSourceLocation: THREE.Vector3, inTargetLocation: THREE.Vector3, inPointAtSource: boolean): void {
      // TODO: implement
  }

  ReadyToTriggerEffectEvents(): boolean {
      // TODO: implement
  }

  CanThrowPrep(): boolean {
      // TODO: implement
  }

  RequestEquipShouldBeAllowed(): boolean {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  DoThrowingPrep(): void {
      // TODO: implement
  }

  Tick(dTime: number): void {
      // TODO: implement
  }

  EndThrow(ThrowHeldTimeFromNetwork: number): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  CanThrowPrep(): boolean {
      // TODO: implement
  }

  RequestEquipShouldBeAllowed(): boolean {
      // TODO: implement
  }

  Tick(dTime: number): void {
      // TODO: implement
  }

  EndThrow(ThrowHeldTimeFromNetwork: number): void {
      // TODO: implement
  }

  InterruptState(Reason: string): void {
      // TODO: implement
  }

  CanThrowPrep(): boolean {
      // TODO: implement
  }

  RequestEquipShouldBeAllowed(): boolean {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  EndThrow(ThrowHeldTimeFromNetwork: number): void {
      // TODO: implement
  }

  InterruptState(Reason: string): void {
      // TODO: implement
  }

}
