// Auto-generated skeleton from UnrealScript: SwatGame/SwatAI.uc
// Parent: SwatRagdollPawn

class SwatAI extends SwatRagdollPawn {

  // Variables
  behavior: any /* iswatai.eupperbodyanimbehavior */;  //  ISwatAI.EUpperBodyAnimBehavior
  clientId: number;  //  int
  Vision: any /* visionnotifier */;  //  VisionNotifier
  Hearing: any /* hearingnotifier */;  //  HearingNotifier
  bIsIncapacitated: boolean;  // private bool
  bIsCompliant: boolean;  // private bool
  EyeBoneName: string;  //  name
  EyeBoneIndex: number;  // const int
  CurrentViewPoint: THREE.Vector3;  // private const Vector
  CurrentViewDirection: THREE.Euler;  // private const Rotator
  LastViewUpdateTime: number;  // private const float
  IdleCategory: string;  // private name
  LastIdleUpdateTime: number;  // private float
  AIKnowledge: any /* aiknowledge */;  // private AIKnowledge
  AICoverFinder: any /* aicoverfinder */;  // private AICoverFinder
  PendingDoor: any /* swatdoor */;  // private SwatDoor
  bShowBlackboardDebugInfo: boolean;  //  bool
  bShowTyrionCharacterDebugInfo: boolean;  //  bool
  bShowTyrionMovementDebugInfo: boolean;  //  bool
  bShowTyrionWeaponDebugInfo: boolean;  //  bool
  bShowTyrionHeadDebugInfo: boolean;  //  bool
  bShowMoraleHistoryDebugInfo: boolean;  //  bool
  bShowAimingDebugInfo: boolean;  //  bool
  bVisionDisabled: boolean;  //  bool
  bVisionDisabledPermanently: boolean;  //  bool
  bHearingDisabled: boolean;  //  bool
  bHearingDisabledPermanently: boolean;  //  bool
  PlayerBlockingPathStartTime: number;  // private float
  PlayerBlockingPathTime: number;  // config float
  bAlwaysTestPathReachability: boolean;  // private bool
  PathReachabilityRenderedRecentlyDelta: number;  // config float
  UpperBodyAnimBehaviorEntries: any /* upperbodyanimbehaviorentry */[];  //  array<UpperBodyAnimBehaviorEntry>
  FBStandingReactionAnimations: string[];  // config array<name>
  FBStandingNoWeaponReactionAnimations: string[];  // config array<name>
  FBCrouchingReactionAnimations: string[];  // config array<name>
  FBCrouchingNoWeaponReactionAnimations: string[];  // config array<name>
  FBCompliantReactionAnimations: string[];  // config array<name>
  FBRestrainedReactionAnimations: string[];  // config array<name>
  FBStandingAffectedAnimations: string[];  // config array<name>
  FBStandingNoWeaponAffectedAnimations: string[];  // config array<name>
  FBCrouchingAffectedAnimations: string[];  // config array<name>
  FBCrouchingNoWeaponAffectedAnimations: string[];  // config array<name>
  FBCompliantAffectedAnimations: string[];  // config array<name>
  FBRestrainedAffectedAnimations: string[];  // config array<name>
  FBStandingRecoveryAnimations: string[];  // config array<name>
  FBStandingNoWeaponRecoveryAnimations: string[];  // config array<name>
  FBCrouchingRecoveryAnimations: string[];  // config array<name>
  FBCrouchingNoWeaponRecoveryAnimations: string[];  // config array<name>
  FBCompliantRecoveryAnimations: string[];  // config array<name>
  FBRestrainedRecoveryAnimations: string[];  // config array<name>
  GasStandingReactionAnimations: string[];  // config array<name>
  GasStandingNoWeaponReactionAnimations: string[];  // config array<name>
  GasCrouchingReactionAnimations: string[];  // config array<name>
  GasCrouchingNoWeaponReactionAnimations: string[];  // config array<name>
  GasCompliantReactionAnimations: string[];  // config array<name>
  GasRestrainedReactionAnimations: string[];  // config array<name>
  GasStandingAffectedAnimations: string[];  // config array<name>
  GasStandingNoWeaponAffectedAnimations: string[];  // config array<name>
  GasCrouchingAffectedAnimations: string[];  // config array<name>
  GasCrouchingNoWeaponAffectedAnimations: string[];  // config array<name>
  GasCompliantAffectedAnimations: string[];  // config array<name>
  GasRestrainedAffectedAnimations: string[];  // config array<name>
  GasStandingRecoveryAnimations: string[];  // config array<name>
  GasStandingNoWeaponRecoveryAnimations: string[];  // config array<name>
  GasCrouchingRecoveryAnimations: string[];  // config array<name>
  GasCrouchingNoWeaponRecoveryAnimations: string[];  // config array<name>
  GasCompliantRecoveryAnimations: string[];  // config array<name>
  GasRestrainedRecoveryAnimations: string[];  // config array<name>
  TasedStandingReactionAnimations: string[];  // config array<name>
  TasedCrouchingReactionAnimations: string[];  // config array<name>
  TasedCompliantReactionAnimations: string[];  // config array<name>
  TasedRestrainedReactionAnimations: string[];  // config array<name>
  TasedStandingAffectedAnimations: string[];  // config array<name>
  TasedCrouchingAffectedAnimations: string[];  // config array<name>
  TasedCompliantAffectedAnimations: string[];  // config array<name>
  TasedRestrainedAffectedAnimations: string[];  // config array<name>
  TasedStandingRecoveryAnimations: string[];  // config array<name>
  TasedCrouchingRecoveryAnimations: string[];  // config array<name>
  TasedCompliantRecoveryAnimations: string[];  // config array<name>
  TasedRestrainedRecoveryAnimations: string[];  // config array<name>
  StungStandingReactionAnimations: string[];  // config array<name>
  StungStandingNoWeaponReactionAnimations: string[];  // config array<name>
  StungCrouchingReactionAnimations: string[];  // config array<name>
  StungCrouchingNoWeaponReactionAnimations: string[];  // config array<name>
  StungCompliantReactionAnimations: string[];  // config array<name>
  StungRestrainedReactionAnimations: string[];  // config array<name>
  StungStandingAffectedAnimations: string[];  // config array<name>
  StungStandingNoWeaponAffectedAnimations: string[];  // config array<name>
  StungCrouchingAffectedAnimations: string[];  // config array<name>
  StungCrouchingNoWeaponAffectedAnimations: string[];  // config array<name>
  StungCompliantAffectedAnimations: string[];  // config array<name>
  StungRestrainedAffectedAnimations: string[];  // config array<name>
  StungStandingRecoveryAnimations: string[];  // config array<name>
  StungStandingNoWeaponRecoveryAnimations: string[];  // config array<name>
  StungCrouchingRecoveryAnimations: string[];  // config array<name>
  StungCrouchingNoWeaponRecoveryAnimations: string[];  // config array<name>
  StungCompliantRecoveryAnimations: string[];  // config array<name>
  StungRestrainedRecoveryAnimations: string[];  // config array<name>
  StandingFlinchAnimations: string[];  // config array<name>
  CrouchingFlinchAnimations: string[];  // config array<name>
  CompliantFlinchAnimations: string[];  // config array<name>
  RestrainedFlinchAnimations: string[];  // config array<name>
  UnderhandThrownProjectileInitialOffset: THREE.Vector3;  // config Vector
  OverhandThrownProjectileInitialOffset: THREE.Vector3;  // config Vector
  ThrownProjectilePitch: number;  // config int
  ThrowShortAnimation: string;  // config name
  ThrowLongAnimation: string;  // config name
  ThrowFromLeftAnimation: string;  // config name
  ThrowFromRightAnimation: string;  // config name
  ThrowAnimationTweenTime: number;  // config float
  MaxUnderhandThrowDistance: number;  // config float
  ZPositiveOffsetForOverhandThrow: number;  // config float
  ShoulderOffset: THREE.Vector3;  // config Vector
  MinLastRenderedTimeDeltaForRelevency: number;  // config float
  MinTimeBetweenFireHG: number;  // config float
  MaxTimeBetweenFireHG: number;  // config float
  MinTimeBetweenFireSMGSingleShot: number;  // config float
  MaxTimeBetweenFireSMGSingleShot: number;  // config float
  MinTimeBetweenFireSMGBurst: number;  // config float
  MaxTimeBetweenFireSMGBurst: number;  // config float
  MinTimeBetweenFireSMGFullAuto: number;  // config float
  MaxTimeBetweenFireSMGFullAuto: number;  // config float
  MinTimeBetweenFireMGSingleShot: number;  // config float
  MaxTimeBetweenFireMGSingleShot: number;  // config float
  MinTimeBetweenFireMGFullBurst: number;  // config float
  MaxTimeBetweenFireMGFullBurst: number;  // config float
  MinTimeBetweenFireMGFullAuto: number;  // config float
  MaxTimeBetweenFireMGFullAuto: number;  // config float
  MinTimeBetweenFireShotgun: number;  // config float
  MaxTimeBetweenFireShotgun: number;  // config float
  EndTimeToStopFiringFullAuto: number;  // private float
  TurnAwayAnimationHG: string[];  // config array<name>
  TurnAwayAnimationSG: string[];  // config array<name>
  TurnAwayAnimationMG: string[];  // config array<name>
  TurnAwayAnimationSMG: string[];  // config array<name>
  TurnAwayAnimationPB: string[];  // config array<name>
  ArchetypeInstance: any /* archetypeinstance */;  // private ArchetypeInstance
  bUsesAwarenessForPathfindingCost: boolean;  // private bool
  bUsesCoverForPathfindingCost: boolean;  // private bool
  OtherPawnsToFavorCoveredPathFrom: any /* pawn */[];  //  array<Pawn>
  CurrentWeaponTarget: any /* actor */;  // private Actor
  CurrentWeaponTargetLocation: THREE.Vector3;  // private Vector
  NextCanHitWeaponTraceToggleTime: number;  // private float
  bCanHitUsesWeaponTrace: boolean;  // private bool
  vGrenadeTargetLocation: THREE.Vector3;  // private Vector
  ThrowSide: any /* iswatai.aithrowside */;  // private ISwatAI.AIThrowSide
  bHasBeenReportedToTOC: boolean;  // private bool
  SpawnedFromName: string;  // private name
  Commander: any /* commandergoal */;  // private CommanderGoal
  SpeechManager: any /* speechmanagergoal */;  // private SpeechManagerGoal
  LastVelocity: THREE.Vector3;  // private Vector
  LatentSound: any /* soundinstance */;  // private SoundInstance
  MoveMouthDuringEffect: boolean;  // private bool
  TouchingStaircaseAimVolumes: any /* staircaseaimvolume */[];  //  array<StaircaseAimVolume>
  bIsAimLocked: boolean;  // private bool
  bDebugPathLines: boolean;  // private bool
  CurrentEffectEventName: string;  // private name
  CurrentSeed: number;  // private int
  bEffectEventStillPlaying: boolean;  // private bool

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

  InitAimPoses(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  CharacterAICreated(): void {
      // TODO: implement
  }

  CleanupTyrion(): void {
      // TODO: implement
  }

  CleanupPrivateTyrion(): void {
      // TODO: implement
  }

  SetupVisionBone(): void {
      // no body (native/abstract)
  }

  CreateTyrionResources(): void {
      // TODO: implement
  }

  ConstructCharacterAI(): void {
      // TODO: implement
  }

  SetupCommanderGoal(): void {
      // TODO: implement
  }

  SetupSpeechManagerGoal(): void {
      // TODO: implement
  }

  ConstructMovementAI(): void {
      // TODO: implement
  }

  ConstructWeaponAI(): void {
      // TODO: implement
  }

  CleanupSensing(): void {
      // TODO: implement
  }

  CreateVisionNotifier(): void {
      // TODO: implement
  }

  CreateHearingNotifier(): void {
      // TODO: implement
  }

  EndCrouch(HeightAdjust: number): void {
      // TODO: implement
  }

  StartCrouch(HeightAdjust: number): void {
      // TODO: implement
  }

  OnActiveItemEquipped(): void {
      // TODO: implement
  }

  SetupIdling(): void {
      // TODO: implement
  }

  CanUseIdle(Idle: any /* idledefinition */): boolean {
      // TODO: implement
  }

  AddIdleActions(): void {
      // TODO: implement
  }

  SetIdleCategory(inIdleCategory: string): void {
      // TODO: implement
  }

  GetIdleCategory(): string {
      // TODO: implement
  }

  RegisterVisionNotification(Registrant: any /* ivisionnotification */): void {
      // TODO: implement
  }

  UnregisterVisionNotification(Registrant: any /* ivisionnotification */): void {
      // TODO: implement
  }

  isVisible(TestPawn: any /* pawn */): boolean {
      // TODO: implement
  }

  GetViewDirection(): THREE.Vector3 {
      // no body (native/abstract)
  }

  GetViewPoint(): THREE.Vector3 {
      // no body (native/abstract)
  }

  IsRelevantToPlayerOrOfficers(): boolean {
      // no body (native/abstract)
  }

  GetRestrainedHandcuffs(): any /* handheldequipment */ {
      // TODO: implement
  }

  NotifyBecameCompliant(): void {
      // TODO: implement
  }

  RegisterHearingNotification(Registrant: any /* ihearingnotification */): void {
      // TODO: implement
  }

  UnregisterHearingNotification(Registrant: any /* ihearingnotification */): void {
      // TODO: implement
  }

  NotifyStartedMoving(): void {
      // TODO: implement
  }

  NotifyStoppedMoving(): void {
      // TODO: implement
  }

  IsIdleCurrent(): boolean {
      // TODO: implement
  }

  ChooseIdle(): void {
      // TODO: implement
  }

  GetExtraCostForPoint(Point: any /* navigationpoint */): number {
      // TODO: implement
  }

  EnableFavorLowThreatPath(): void {
      // TODO: implement
  }

  DisableFavorLowThreatPath(): void {
      // TODO: implement
  }

  GetAwarenessCostForPoint(Point: any /* navigationpoint */): number {
      // TODO: implement
  }

  GetCoverCostForPoint(Point: any /* navigationpoint */): number {
      // TODO: implement
  }

  PlayerBlockingPath(): void {
      // TODO: implement
  }

  EnableFavorCoveredPath(otherPawnsToCoverFrom: any /* pawn */[]): void {
      // TODO: implement
  }

  DisableFavorCoveredPath(): void {
      // TODO: implement
  }

  SetPendingDoor(inPendingDoor: any /* door */): void {
      // TODO: implement
  }

  ClearPendingDoor(): void {
      // TODO: implement
  }

  ShouldForceOpenLockedDoors(): boolean {
      // TODO: implement
  }

  InteractWithPendingDoor(): void {
      // TODO: implement
  }

  NotifyBlockingDoorClose(BlockedDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyBlockingDoorOpen(BlockedDoor: any /* door */): void {
      // TODO: implement
  }

  ShouldPlayFullBodyHitAnimation(): boolean {
      // TODO: implement
  }

  SwapInCompliantAnimSet(): void {
      // TODO: implement
  }

  SwapInRestrainedAnimSet(): void {
      // TODO: implement
  }

  GetFBReactionAnimation(): string {
      // TODO: implement
  }

  GetFBAffectedAnimation(): string {
      // TODO: implement
  }

  GetFBRecoveryAnimation(): string {
      // TODO: implement
  }

  GetGasReactionAnimation(): string {
      // TODO: implement
  }

  GetGasAffectedAnimation(): string {
      // TODO: implement
  }

  GetGasRecoveryAnimation(): string {
      // TODO: implement
  }

  GetStungReactionAnimation(): string {
      // TODO: implement
  }

  GetStungAffectedAnimation(): string {
      // TODO: implement
  }

  GetStungRecoveryAnimation(): string {
      // TODO: implement
  }

  GetTasedReactionAnimation(): string {
      // TODO: implement
  }

  GetTasedAffectedAnimation(): string {
      // TODO: implement
  }

  GetTasedRecoveryAnimation(): string {
      // TODO: implement
  }

  GetTurnAwayAnimation(): string {
      // TODO: implement
  }

  GetMovementAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetCrouchingInjuredAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetFlashbangedAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetGassedAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetPepperSprayedAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStungAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetTasedAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  AimAtPoint(Point: THREE.Vector3): void {
      // TODO: implement
  }

  AimAtActor(Target: any /* actor */): void {
      // TODO: implement
  }

  AimToRotation(DesiredRotation: THREE.Euler): void {
      // TODO: implement
  }

  LockAim(): void {
      // TODO: implement
  }

  UnlockAim(): void {
      // TODO: implement
  }

  CanProcedurallyAnimateUpperBody(): boolean {
      // TODO: implement
  }

  DisableAim(): void {
      // TODO: implement
  }

  SetUpperBodyAnimBehavior(behavior: any /* iswatai.eupperbodyanimbehavior */, clientId: any /* upperbodyanimbehaviorclients.eupperbodyanimbehaviorclientid */): void {
      // TODO: implement
  }

  UnsetUpperBodyAnimBehavior(clientId: any /* upperbodyanimbehaviorclients.eupperbodyanimbehaviorclientid */): void {
      // TODO: implement
  }

  GetUpperBodyAnimBehavior(): any /* iswatai.eupperbodyanimbehavior */ {
      // TODO: implement
  }

  GetMovementUpperBodyAimBehavior(): any /* iswatai.eupperbodyanimbehavior */ {
      // TODO: implement
  }

  SetUpperBodyAnimBehaviorPawnState(newDominantBehavior: any /* iswatai.eupperbodyanimbehavior */, previousDominantBehavior: any /* iswatai.eupperbodyanimbehavior */): void {
      // TODO: implement
  }

  SetUpperBodyAnimBehaviorForClient(behavior: any /* iswatai.eupperbodyanimbehavior */, clientId: any /* upperbodyanimbehaviorclients.eupperbodyanimbehaviorclientid */): void {
      // TODO: implement
  }

  UnsetUpperBodyAnimBehaviorForClient(clientId: any /* upperbodyanimbehaviorclients.eupperbodyanimbehaviorclientid */): void {
      // TODO: implement
  }

  GetDominantUpperBodyAnimBehavior(): any /* iswatai.eupperbodyanimbehavior */ {
      // TODO: implement
  }

  AnimIsWeaponAimSet(): boolean {
      // TODO: implement
  }

  GetAimOrientation(): THREE.Euler {
      // TODO: implement
  }

  OnTouchedStaircaseAimVolume(StaircaseAimVolume: any /* staircaseaimvolume */): void {
      // TODO: implement
  }

  OnUntouchedStaircaseAimVolume(StaircaseAimVolume: any /* staircaseaimvolume */): void {
      // TODO: implement
  }

  GetNumTouchingStaircaseAimVolumes(): number {
      // TODO: implement
  }

  GetTouchingStaircaseAimVolumeAtIndex(Index: number): any /* staircaseaimvolume */ {
      // TODO: implement
  }

  GetAimAroundAction(): any /* aimaroundaction */ {
      // TODO: implement
  }

  AdjustAim(FiredAmmunition: any /* ammunition */, projStart: THREE.Vector3, aimerror: number): THREE.Euler {
      // TODO: implement
  }

  GetAimRotation(): THREE.Euler {
      // TODO: implement
  }

  GetCSBallLauncherAimRotation(TargetLocation: THREE.Vector3): THREE.Euler {
      // TODO: implement
  }

  GetAimOrigin(): THREE.Vector3 {
      // no body (native/abstract)
  }

  SetAimUrgency(Fast: boolean): void {
      // TODO: implement
  }

  CanHitTargetAt(Target: any /* actor */, AILocation: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  CanHit(Target: any /* actor */): boolean {
      // no body (native/abstract)
  }

  HasUsableWeapon(): boolean {
      // TODO: implement
  }

  GetWeaponTarget(): any /* actor */ {
      // TODO: implement
  }

  SetWeaponTarget(Target: any /* actor */): void {
      // no body (native/abstract)
  }

  SetWeaponTargetLocation(TargetLocation: THREE.Vector3): void {
      // TODO: implement
  }

  GetDefaultAIFireModeForWeapon(Weapon: any /* firedweapon */): any /* firedweapon.firemode */ {
      // TODO: implement
  }

  GetTimeToWaitBetweenFiring(Weapon: any /* firedweapon */): number {
      // TODO: implement
  }

  GetLengthOfTimeToFireFullAuto(): number {
      // TODO: implement
  }

  SetLengthOfTimeToFireFullAuto(): void {
      // TODO: implement
  }

  WeaponDischargedAt(TargetPawn: any /* pawn */): void {
      // TODO: implement
  }

  NotifyWeaponDischarged(): void {
      // TODO: implement
  }

  OnUsingBegan(): void {
      // TODO: implement
  }

  OnAutoFireStarted(): void {
      // TODO: implement
  }

  WantsToContinueAutoFiring(): boolean {
      // TODO: implement
  }

  CanHitCurrentTarget(): boolean {
      // TODO: implement
  }

  Died(Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3): void {
      // TODO: implement
  }

  TriggerPawnDied(Killer: any /* controller */): void {
      // TODO: implement
  }

  BecomeIncapacitated(IncapaciatedIdleCategoryOverride: string, Incapacitator: any /* pawn */): void {
      // TODO: implement
  }

  NotifyBecameIncapacitated(Incapacitator: any /* pawn */): void {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  NotifyHit(Damage: number, HitInstigator: any /* pawn */): void {
      // TODO: implement
  }

  OnSkeletalRegionHit(RegionHit: any /* actor.eskeletalregion */, HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, Damage: number, DamageType: any /* class */, Instigator: any /* actor */): void {
      // TODO: implement
  }

  GetFlinchAnimation(): string {
      // TODO: implement
  }

  GetCommanderAction(): any /* commanderaction */ {
      // no body (native/abstract)
  }

  GetSpeechManagerAction(): any /* characterspeechmanageraction */ {
      // TODO: implement
  }

  DrawVisionCone(DrawTarget: any /* hud */): void {
      // TODO: implement
  }

  DrawDebugAIMovement(DrawTarget: any /* hud */): void {
      // TODO: implement
  }

  DebugTyrionInfo(resource: any /* ai_resource */): void {
      // TODO: implement
  }

  ShowAimingDebugInfo(): void {
      // TODO: implement
  }

  EnableVision(): void {
      // TODO: implement
  }

  DisableVision(bDisableVisionPermanently: boolean): void {
      // TODO: implement
  }

  IsHearingEnabled(): boolean {
      // TODO: implement
  }

  EnableHearing(): void {
      // TODO: implement
  }

  DisableHearing(bDisableHearingPermanently: boolean): void {
      // TODO: implement
  }

  GetArchetypeInstance(): any /* archetypeinstance */ {
      // TODO: implement
  }

  InitializeFromSpawner(Spawner: any /* spawner */): void {
      // TODO: implement
  }

  Internal_InitializeFromArchetypeInstance(inInstance: any /* archetypeinstance */): void {
      // TODO: implement
  }

  InitializeFromArchetypeInstance(): void {
      // TODO: implement
  }

  DestroyEquipment(): void {
      // TODO: implement
  }

  InitKnowledge(): void {
      // TODO: implement
  }

  TermKnowledge(): void {
      // TODO: implement
  }

  PostBeginPlay(why..": any /* into */): any /* destroyed() without getting its event */ {
      // no body (native/abstract)
  }

  GetKnowledge(): any /* aiknowledge */ {
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

  SetIsCompliant(): void {
      // TODO: implement
  }

  SetIncapacitated(bInIsIncapacitated: boolean): void {
      // TODO: implement
  }

  IsOtherActorAThreat(otherActor: any /* actor */): boolean {
      // no body (native/abstract)
  }

  GetKnownLocationOfPawn(otherPawn: any /* pawn */, Location: THREE.Vector3): boolean {
      // TODO: implement
  }

  CanMoveFreely(): boolean {
      // no body (native/abstract)
  }

  IsAggressive(): boolean {
      // TODO: implement
  }

  GetInitialMorale(): number {
      // TODO: implement
  }

  InitCoverFinder(): void {
      // TODO: implement
  }

  GetCoverFinder(): any /* aicoverfinder */ {
      // TODO: implement
  }

  FindRunToPoint(PointToRunAwayFrom: THREE.Vector3, MinDistanceToRunAway: number): any /* navigationpoint */ {
      // TODO: implement
  }

  GetUseGrenadeBehavior(): any /* usegrenadeaction */ {
      // TODO: implement
  }

  GetThrowOriginOffset(bIsUnderhandThrow: boolean, Orientation: THREE.Euler): THREE.Vector3 {
      // TODO: implement
  }

  GetThrowOrigin(bIsUnderhandThrow: boolean, Orientation: THREE.Euler): THREE.Vector3 {
      // TODO: implement
  }

  GetThrowAngle(): number {
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

  IsUnderhandThrow(Origin: THREE.Vector3, TargetLocation: THREE.Vector3): boolean {
      // TODO: implement
  }

  IsUnderhandThrowTo(TargetLocation: THREE.Vector3): boolean {
      // TODO: implement
  }

  SetGrenadeTargetLocation(vInGrenadeTargetLocation: THREE.Vector3): void {
      // TODO: implement
  }

  SetThrowSide(inThrowSide: any /* iswatai.aithrowside */): void {
      // TODO: implement
  }

  IsPlayerPawn(): boolean {
      // TODO: implement
  }

  IsHumanControlled(): boolean {
      // TODO: implement
  }

  HasBeenReportedToTOC(): boolean {
      // TODO: implement
  }

  ToggleDebugPathLines(): void {
      // TODO: implement
  }

  LatentAITriggerEffectEvent(EffectEvent: string, Other: any /* actor */, TargetMaterial: any /* material */, HitLocation: THREE.Vector3, HitNormal: THREE.Euler, PlayOnOther: boolean, MoveMouth: boolean): void {
      // TODO: implement
  }

  string(EffectEvent)): any, "): any /* is: */, string(Tag)): any, "): any /* is: */, string(Level.TimeSeconds)): any): any /* "), */ {
      // no body (native/abstract)
  }

  AITriggerEffectEvent(EffectEvent: string, Other: any /* actor */, TargetMaterial: any /* material */, HitLocation: THREE.Vector3, HitNormal: THREE.Euler, PlayOnOther: boolean, ReferenceTag: string, MoveMouth: boolean, Seed: number): void {
      // TODO: implement
  }

  GetPlayerTag(): string {
      // TODO: implement
  }

  ServerOnEffectStopped(EffectName: string, Seed: number): void {
      // TODO: implement
  }

  RestartInterruptedActionSpeech(PreviousEffectEvent: string): void {
      // TODO: implement
  }

  RestartStunnedActionSpeech(Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  OnEffectInitialized(inInitializedEffect: any /* actor */): void {
      // TODO: implement
  }

  OnEffectStarted(inStartedEffect: any /* actor */): void {
      // TODO: implement
  }

  OnEffectStopped(inStoppedEffect: any /* actor */, Completed: boolean): void {
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

  UniqueID(): string {
      // TODO: implement
  }

  GetEffectEventForReportingToTOC(): string {
      // TODO: implement
  }

  GetEffectEventForReportResponseFromTOC(): string {
      // TODO: implement
  }

  GetEffectEventForReportingToTOCWhenDead(): string {
      // TODO: implement
  }

  GetEffectEventForReportingToTOCWhenIncapacitated(): string {
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

}
