// Auto-generated skeleton from UnrealScript: Engine/Pawn.uc
// Parent: Actor

class Pawn extends Actor {

  // Variables
  Position: THREE.Vector3;  //  Vector
  Normal: THREE.Vector3;  //  Vector
  ObjectImpulse: number;  //  float
  Timestep: number;  //  float
  ProjectedVelocity: number;  //  float
  ObjectMassInv: number;  //  float
  CharacterMassInv: number;  //  float
  Body: any /* actor */;  //  Actor
  ObjectImpulse: THREE.Vector3;  //  Vector
  ImpulsePosition: THREE.Vector3;  //  Vector
  CharacterImpulse: THREE.Vector3;  //  Vector
  Controller: any /* controller */;  //  Controller
  m_LastSteerDirection: THREE.Vector3;  //  Vector
  m_LastSteerDirectionTime: number;  //  float
  CharacterAI: any /* tyrion_resourcebase */;  //  Tyrion_ResourceBase
  MovementAI: any /* tyrion_resourcebase */;  //  Tyrion_ResourceBase
  WeaponAI: any /* tyrion_resourcebase */;  //  Tyrion_ResourceBase
  logTyrion: boolean;  //  bool
  logAI: boolean;  //  bool
  nextPawn: any /* pawn */;  //  Pawn
  bDisplayBattleDebug: boolean;  //  bool
  NetRelevancyTime: number;  //  float
  LastRealViewer: any /* playercontroller */;  //  PlayerController
  LastViewer: any /* actor */;  //  Actor
  RelevancyPropogationDistance: number;  // config float
  RelevancyLOSDistance: number;  // config float
  bJustLanded: boolean;  //  bool
  bUpAndOut: boolean;  //  bool
  bIsWalking: boolean;  //  bool
  bWarping: boolean;  //  bool
  bWantsToCrouch: boolean;  //  bool
  bIsCrouched: boolean;  // const bool
  bTryToUncrouch: boolean;  // const bool
  bCanCrouch: boolean;  //  bool
  bIsCurrentMeshRenderZValid: boolean;  // private bool
  CurrentMeshRenderZ: number;  // private float
  LastUnPossessedController: any /* controller */;  // private Controller
  bForceCrouch: boolean;  // private bool
  bWantsToLeanLeft: boolean;  //  bool
  bWantsToLeanRight: boolean;  //  bool
  DesiredLeanState: any /* pawn.eleanstate */;  // const Pawn.ELeanState
  LeanState: any /* pawn.eleanstate */;  // const Pawn.ELeanState
  LeanLockedYaw: number;  // const int
  LeanAlpha: number;  // const float
  LeanTransitionDuration: number;  // private config float
  LeanHorizontalDistance: number;  // private config float
  bCrawler: boolean;  //  bool
  bReducedSpeed: boolean;  // const bool
  bJumpCapable: boolean;  //  bool
  bCanJump: boolean;  //  bool
  bCanWalk: boolean;  //  bool
  bCanSwim: boolean;  //  bool
  bCanFly: boolean;  //  bool
  bCanStrafe: boolean;  //  bool
  bCanDoubleJump: boolean;  //  bool
  bAvoidLedges: boolean;  //  bool
  bStopAtLedges: boolean;  //  bool
  bNoJumpAdjust: boolean;  //  bool
  bCountJumps: boolean;  //  bool
  bSimulateGravity: boolean;  // const bool
  bUpdateEyeheight: boolean;  //  bool
  bIgnoreForces: boolean;  //  bool
  bNoVelocityUpdate: boolean;  // const bool
  bCanWalkOffLedges: boolean;  //  bool
  bCanBeBaseForPawns: boolean;  //  bool
  bClientCollision: boolean;  //  bool
  bSimGravityDisabled: boolean;  // const bool
  bDirectHitWall: boolean;  //  bool
  bHavokInitCalled: boolean;  // const transient bool
  bThumped: boolean;  //  bool
  bInvulnerableBody: boolean;  //  bool
  bIsFemale: boolean;  //  bool
  bAutoActivate: boolean;  //  bool
  bUpdatingDisplay: boolean;  //  bool
  bAmbientCreature: boolean;  //  bool
  bRollToDesired: boolean;  //  bool
  bCachedRelevant: boolean;  //  bool
  bUseCompressedPosition: boolean;  //  bool
  bWeaponBob: boolean;  // config bool
  bHideRegularHUD: boolean;  //  bool
  bSpecialHUD: boolean;  //  bool
  bSpecialCalcView: boolean;  //  bool
  bIsTyping: boolean;  //  bool
  Visibility: number;  //  byte
  DesiredSpeed: number;  //  float
  MaxDesiredSpeed: number;  //  float
  SkillModifier: number;  //  float
  AvgPhysicsTime: number;  // const float
  MeleeRange: number;  //  float
  Anchor: any /* navigationpoint */;  //  NavigationPoint
  LastAnchor: any /* navigationpoint */;  // const NavigationPoint
  FindAnchorFailedTime: number;  //  float
  LastValidAnchorTime: number;  //  float
  LastValidAnchorLocation: THREE.Vector3;  //  Vector
  LastDistanceToAnchor: number;  //  float
  DestinationOffset: number;  //  float
  NextPathRadius: number;  //  float
  SerpentineDir: THREE.Vector3;  //  Vector
  SerpentineDist: number;  //  float
  SerpentineTime: number;  //  float
  UncrouchTime: number;  // const float
  SpawnTime: number;  //  float
  VisionCounter: number;  // const float
  VisionUpdateRange: any /* range */;  //  Range
  ViewablePawns: any /* pawn */[];  // const array<Pawn>
  NextPathReachabilityRetestedTime: number;  //  float
  bAlwaysUseWalkAimErrorWhenMoving: boolean;  //  bool
  GroundSpeed: number;  // config float
  WaterSpeed: number;  //  float
  AirSpeed: number;  //  float
  LadderSpeed: number;  //  float
  AccelRate: number;  //  float
  JumpZ: number;  //  float
  AirControl: number;  //  float
  MaxFallSpeed: number;  //  float
  ConstantAcceleration: THREE.Vector3;  //  Vector
  ReachedDestinationThreshold: number;  //  float
  OwnerName: string;  //  string
  BaseEyeHeight: number;  // config float
  CrouchEyeHeight: number;  // config float
  EyeHeight: number;  //  float
  Floor: THREE.Vector3;  // const Vector
  SplashTime: number;  //  float
  CrouchHeight: number;  // config float
  CrouchRadius: number;  // config float
  OldZ: number;  //  float
  HeadVolume: any /* physicsvolume */;  //  PhysicsVolume
  Health: number;  // travel int
  LastPainTime: number;  //  float
  ReducedDamageType: any /* class */;  //  Class<DamageType>
  HeadScale: number;  //  float
  noise1spot: THREE.Vector3;  // const Vector
  noise1time: number;  // const float
  noise1other: any /* pawn */;  // const Pawn
  noise1loudness: number;  // const float
  noise2spot: THREE.Vector3;  // const Vector
  noise2time: number;  // const float
  noise2other: any /* pawn */;  // const Pawn
  noise2loudness: number;  // const float
  LastPainSound: number;  //  float
  Bob: number;  // config float
  LandBob: number;  //  float
  AppliedBob: number;  //  float
  bobtime: number;  //  float
  WalkBob: THREE.Vector3;  //  Vector
  SoundDampening: number;  //  float
  DamageScaling: number;  //  float
  MenuName: string;  // localized string
  Shadow: any /* shadowprojector */;  //  ShadowProjector
  BloodEffect: any /* class */;  //  Class<Effects>
  LowGoreBlood: any /* class */;  //  Class<Effects>
  PlayerReplicationInfo: any /* playerreplicationinfo */;  //  PlayerReplicationInfo
  LandMovementState: string;  //  name
  WaterMovementState: string;  //  name
  LastStartSpot: any /* playerstart */;  //  PlayerStart
  LastStartTime: number;  //  float
  AnimAction: string;  //  name
  DeathHitLocation: THREE.Vector3;  //  Vector
  KillerLocation: THREE.Vector3;  //  Vector
  DeathHitDamageType: any /* class */;  //  Class<DamageType>
  DeathHitMomentum: THREE.Vector3;  //  Vector
  bPhysicsAnimUpdate: boolean;  //  bool
  bWasCrouched: boolean;  //  bool
  bWasWalking: boolean;  //  bool
  bWasOnGround: boolean;  //  bool
  bInitializeAnimation: boolean;  //  bool
  bPlayedDeath: boolean;  //  bool
  OldPhysics: any /* actor.ephysics */;  //  Actor.EPhysics
  OldRotYaw: number;  //  float
  OldAcceleration: THREE.Vector3;  //  Vector
  BaseMovementRate: number;  //  float
  TurnLeftAnim: string;  //  name
  TurnRightAnim: string;  //  name
  MovementBlendStartTime: number;  //  float
  ForwardStrafeBias: number;  //  float
  BackwardStrafeBias: number;  //  float
  PawnPosition: any /* compressedposition */;  // transient CompressedPosition
  FirstPersonFOV: number;  // config float
  Hands: any /* hands */;  // private Hands
  bRenderHands: boolean;  //  bool
  ActiveItem: any /* handheldequipment */;  // private HandheldEquipment
  PendingItem: any /* handheldequipment */;  // private HandheldEquipment
  DesiredItemPocket: any /* handheldequipment.pocket */;  // private HandheldEquipment.Pocket
  HasEquippedFirstItemYet: boolean;  //  bool
  LastCollisionAvoidanceTick: number;  // private int
  bCollisionAvoidanceEnabled: boolean;  // private bool
  bAvoidingCollision: boolean;  // private bool
  MovingThroughDoor: any /* door */;  // private Door
  CollisionAvoidanceNotifier: any /* collisionavoidancenotifier */;  // private CollisionAvoidanceNotifier
  SkeletalRegionInformation: any /* skeletalregioninformation */[];  //  array<SkeletalRegionInformation>
  SkeletalRegionProtection: any /* protectiveequipment */[];  //  array<ProtectiveEquipment>
  AccumulatedLimbInjury: number;  //  float
  bNotifiedDeathListeners: boolean;  // private const bool

  constructor() {
    super();
  }

  // Methods
  AddPawn(): void {
      // no body (native/abstract)
  }

  RemovePawn(): void {
      // no body (native/abstract)
  }

  NotifyKilled(Killer: any /* controller */, Killed: any /* controller */, Other: any /* pawn */): void {
      // TODO: implement
  }

  IgnoresSeenPawnsOfType(SeenType: any /* class */): boolean {
      // TODO: implement
  }

  CanSee(Other: any /* actor */): boolean {
      // no body (native/abstract)
  }

  CanHitTargetAt(Target: any /* actor */, AILocation: THREE.Vector3): boolean {
      // TODO: implement
  }

  CanHit(Target: any /* actor */): boolean {
      // TODO: implement
  }

  HavokCharacterCollision(data: any /* havokcharacterobjectinteractionevent */, res: any /* havokcharacterobjectinteractionresult */): boolean {
      // TODO: implement
  }

  SetHeadScale(NewScale: number): void {
      // TODO: implement
  }

  IsActorReachable(Actor: any /* actor */): boolean {
      // no body (native/abstract)
  }

  IsLocationReachable(Location: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  FitsAtLocation(NewLocation: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  IsDoorBlockedForPawn(Target: any /* door */): boolean {
      // no body (native/abstract)
  }

  DisableCollisionAvoidance(): void {
      // TODO: implement
  }

  EnableCollisionAvoidance(): void {
      // TODO: implement
  }

  IsCollisionAvoidanceEnabled(): boolean {
      // TODO: implement
  }

  IsAtRunningSpeed(): boolean {
      // TODO: implement
  }

  ClearRouteCache(): void {
      // no body (native/abstract)
  }

  ReachedDestination(Goal: any /* actor */): boolean {
      // no body (native/abstract)
  }

  ReachedLocation(Location: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  ForceCrouchThisTick(): void {
      // no body (native/abstract)
  }

  SetForceCrouchState(inbForceCrouch: boolean): void {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  DrawHUD(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  SpecialCalcView(ViewActor: any /* actor */, CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): boolean {
      // TODO: implement
  }

  IsControlledByLocalHuman(): boolean {
      // TODO: implement
  }

  IsPrimaryWeapon(theItem: any /* handheldequipment */): boolean {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  GetHumanReadableTeamName(): string {
      // TODO: implement
  }

  PlayTeleportEffect(bOut: boolean, bSound: boolean): void {
      // TODO: implement
  }

  PossessedBy(C: any /* controller */): void {
      // TODO: implement
  }

  UnPossessed(): void {
      // TODO: implement
  }

  PointOfView(): boolean {
      // TODO: implement
  }

  BecomeViewTarget(): void {
      // TODO: implement
  }

  DropToGround(): void {
      // TODO: implement
  }

  SetWalking(bNewIsWalking: boolean): void {
      // TODO: implement
  }

  CanSplash(): boolean {
      // TODO: implement
  }

  DisplayDebug(Canvas: any /* canvas */, YL: number, YPos: number): void {
      // TODO: implement
  }

  CalcDrawOffset(): THREE.Vector3 {
      // TODO: implement
  }

  WeaponBob(BobDamping: number): THREE.Vector3 {
      // TODO: implement
  }

  CheckBob(DeltaTime: number, Y: THREE.Vector3): void {
      // TODO: implement
  }

  IsPlayerPawn(): boolean {
      // TODO: implement
  }

  WasPlayerPawn(): boolean {
      // TODO: implement
  }

  IsHumanControlled(): boolean {
      // TODO: implement
  }

  IsLocallyControlled(): boolean {
      // TODO: implement
  }

  IsFirstPerson(): boolean {
      // TODO: implement
  }

  GetViewRotation(): THREE.Euler {
      // TODO: implement
  }

  SetViewLocation(NewLocation: THREE.Vector3): void {
      // TODO: implement
  }

  SetViewRotation(NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetAimRotation(): THREE.Euler {
      // TODO: implement
  }

  GetAimOrigin(): THREE.Vector3 {
      // TODO: implement
  }

  GetThirdPersonEyesLocation(): THREE.Vector3 {
      // TODO: implement
  }

  GetFireTweenTime(): number {
      // TODO: implement
  }

  InGodMode(): boolean {
      // TODO: implement
  }

  NearMoveTarget(): boolean {
      // TODO: implement
  }

  PressingFire(): boolean {
      // TODO: implement
  }

  PressingAltFire(): boolean {
      // TODO: implement
  }

  GetMoveTarget(): any /* actor */ {
      // TODO: implement
  }

  SetMoveTarget(NewTarget: any /* actor */): void {
      // TODO: implement
  }

  LineOfSightTo(Other: any /* actor */): boolean {
      // no body (native/abstract)
  }

  AdjustAim(FiredAmmunition: any /* ammunition */, projStart: THREE.Vector3, aimerror: number): THREE.Euler {
      // TODO: implement
  }

  AdjustedStrength(): number {
      // TODO: implement
  }

  ReceiveLocalizedMessage(Message: any /* class */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): void {
      // TODO: implement
  }

  ClientMessage(S: string, Type: string): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  CanTrigger(t: any /* trigger */): boolean {
      // TODO: implement
  }

  SetDisplayProperties(NewStyle: any /* actor.erenderstyle */, NewTexture: any /* material */, bLighting: boolean): void {
      // TODO: implement
  }

  SetDefaultDisplayProperties(): void {
      // TODO: implement
  }

  FinishedInterpolation(): void {
      // TODO: implement
  }

  JumpOutOfWater(jumpDir: THREE.Vector3): void {
      // TODO: implement
  }

  ModifyVelocity(DeltaTime: number, OldVelocity: THREE.Vector3): void {
      // TODO: implement
  }

  FellOutOfWorld(KillType: any /* actor.ekillztype */): void {
      // TODO: implement
  }

  ShouldCrouch(Crouch: boolean): void {
      // TODO: implement
  }

  EndCrouch(HeightAdjust: number): void {
      // TODO: implement
  }

  StartCrouch(HeightAdjust: number): void {
      // TODO: implement
  }

  Lean(inLeanState: any /* pawn.eleanstate */): void {
      // no body (native/abstract)
  }

  UnLean(): void {
      // no body (native/abstract)
  }

  ShouldLeanLeft(Lean: boolean): void {
      // TODO: implement
  }

  ShouldLeanRight(Lean: boolean): void {
      // TODO: implement
  }

  OnLeanStateChange(): void {
      // TODO: implement
  }

  GetLeanYawRanges(LeftYawLimit: number, RightYawLimit: number): void {
      // no body (native/abstract)
  }

  CanLean(inLeanState: any /* pawn.eleanstate */, testLocation: THREE.Vector3, testRotation: THREE.Euler): boolean {
      // no body (native/abstract)
  }

  RestartPlayer(): void {
      // TODO: implement
  }

  AddVelocity(NewVelocity: THREE.Vector3): void {
      // TODO: implement
  }

  KilledBy(EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  TakeFallingDamage(): void {
      // TODO: implement
  }

  ClientRestart(): void {
      // TODO: implement
  }

  ClientSetLocation(NewLocation: THREE.Vector3, NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  ClientSetRotation(NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  FaceRotation(NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  ClientDying(DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3, inKillerLocation: THREE.Vector3): void {
      // TODO: implement
  }

  InCurrentCombo(): boolean {
      // TODO: implement
  }

  ServerRequestEquip(Slot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  ValidateEquipSlot(Slot: any /* handheldequipment.equipmentslot */): boolean {
      // TODO: implement
  }

  EncroachingOn(Other: any /* actor */): boolean {
      // TODO: implement
  }

  EncroachedBy(Other: any /* actor */): void {
      // TODO: implement
  }

  JumpOffPawn(): void {
      // TODO: implement
  }

  BaseChange(): void {
      // TODO: implement
  }

  UpdateEyeHeight(DeltaTime: number): void {
      // TODO: implement
  }

  EyePosition(): THREE.Vector3 {
      // no body (native/abstract)
  }

  AddViewablePawn(NewViewablePawn: any /* pawn */): void {
      // no body (native/abstract)
  }

  GetYawEdgeAlpha(Pitch: number): number {
      // no body (native/abstract)
  }

  Destroyed(): void {
      // TODO: implement
  }

  PreBeginPlay(): void {
      // TODO: implement
  }

  CharacterAICreated(): void {
      // TODO: implement
  }

  MovementAICreated(): void {
      // TODO: implement
  }

  WeaponAICreated(): void {
      // TODO: implement
  }

  IsInRoom(RoomName: string): boolean {
      // no body (native/abstract)
  }

  GetRoomName(): string {
      // no body (native/abstract)
  }

  GetPathfindingDistanceToActor(Destination: any /* actor */, bAcceptNearbyPath: boolean): number {
      // no body (native/abstract)
  }

  GetPathfindingDistanceToPoint(Point: THREE.Vector3, bAcceptNearbyPath: boolean): number {
      // no body (native/abstract)
  }

  IsStunned(): boolean {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  CreateCollisionAvoidanceNotifier(): void {
      // TODO: implement
  }

  IsAvoidingCollision(): boolean {
      // TODO: implement
  }

  RegisterCollisionAvoidanceNotification(Registrant: any /* icollisionavoidancenotification */): void {
      // TODO: implement
  }

  UnregisterCollisionAvoidanceNotification(Registrant: any /* icollisionavoidancenotification */): void {
      // TODO: implement
  }

  NotifyBeganCollisionAvoidance(): void {
      // TODO: implement
  }

  NotifyEndedCollisionAvoidance(): void {
      // TODO: implement
  }

  GetCollisionSoftRadius(): number {
      // TODO: implement
  }

  InitSkeletalRegions(): void {
      // TODO: implement
  }

  SwitchToMesh(NewMesh: any /* mesh */): void {
      // TODO: implement
  }

  OnMeshChanged(): void {
      // TODO: implement
  }

  SetProtection(Region: any /* actor.eskeletalregion */, Protection: any /* protectiveequipment */): void {
      // TODO: implement
  }

  HasProtection(ProtectionClass: string): boolean {
      // TODO: implement
  }

  GetSkeletalRegionInformation(Region: any /* actor.eskeletalregion */): any /* skeletalregioninformation */ {
      // TODO: implement
  }

  GetSkeletalRegionProtection(Region: any /* actor.eskeletalregion */): any /* protectiveequipment */ {
      // TODO: implement
  }

  OnSkeletalRegionHit(RegionHit: any /* actor.eskeletalregion */, HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, Damage: number, DamageType: any /* class */, Instigator: any /* actor */): void {
      // TODO: implement
  }

  InitializeHands(): void {
      // TODO: implement
  }

  GetHands(): any /* hands */ {
      // TODO: implement
  }

  SetHands(inHands: any /* hands */): void {
      // TODO: implement
  }

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  PostLoadGame(): void {
      // TODO: implement
  }

  SetMesh(): void {
      // TODO: implement
  }

  Gasp(): void {
      // TODO: implement
  }

  SetMovementPhysics(): void {
      // TODO: implement
  }

  GetAdditionalBaseAimError(): number {
      // no body (native/abstract)
  }

  GetInjuredAimErrorPenalty(): number {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  GetTeam(): any /* teaminfo */ {
      // TODO: implement
  }

  GetKillerController(): any /* controller */ {
      // TODO: implement
  }

  NotifyPawnDeathListeners(): void {
      // no body (native/abstract)
  }

  Died(Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3): void {
      // TODO: implement
  }

  checkAlive(Pawn: any /* pawn */): boolean {
      // TODO: implement
  }

  checkDead(Pawn: any /* pawn */): boolean {
      // TODO: implement
  }

  checkIsAThreat(Pawn: any /* pawn */): boolean {
      // TODO: implement
  }

  checkConscious(Pawn: any /* pawn */): boolean {
      // TODO: implement
  }

  IsDead(): boolean {
      // no body (native/abstract)
  }

  IsConscious(): boolean {
      // no body (native/abstract)
  }

  IsIncapacitated(): boolean {
      // no body (native/abstract)
  }

  GetIncapacitatedDamageAmount(): number {
      // TODO: implement
  }

  ShouldBecomeIncapacitated(): boolean {
      // TODO: implement
  }

  IsArrested(): boolean {
      // TODO: implement
  }

  GetCurrentAssignment(): any /* pawn */ {
      // TODO: implement
  }

  isAlive(): boolean {
      // TODO: implement
  }

  IsInjured(): boolean {
      // no body (native/abstract)
  }

  checkIsInjured(Pawn: any /* pawn */): boolean {
      // TODO: implement
  }

  IsLowerBodyInjured(): boolean {
      // no body (native/abstract)
  }

  CanMoveFreely(): boolean {
      // TODO: implement
  }

  IsAThreat(): boolean {
      // no body (native/abstract)
  }

  IsCompliant(): boolean {
      // no body (native/abstract)
  }

  IsAttackingPlayer(): boolean {
      // TODO: implement
  }

  rematchGoals(): void {
      // TODO: implement
  }

  Falling(): void {
      // TODO: implement
  }

  HitWall(HitNormal: THREE.Vector3, Wall: any /* actor */): void {
      // TODO: implement
  }

  Landed(HitNormal: THREE.Vector3): void {
      // TODO: implement
  }

  HeadVolumeChange(newHeadVolume: any /* physicsvolume */): void {
      // TODO: implement
  }

  TouchingWaterVolume(): boolean {
      // TODO: implement
  }

  EnteredZone(Zone: any /* zoneinfo */): void {
      // TODO: implement
  }

  LeftZone(Zone: any /* zoneinfo */): void {
      // TODO: implement
  }

  IsInPain(): boolean {
      // TODO: implement
  }

  TakeDrowningDamage(): void {
      // TODO: implement
  }

  CheckWaterJump(WallNormal: THREE.Vector3): boolean {
      // TODO: implement
  }

  DoDoubleJump(bUpdating: boolean): void {
      // TODO: implement
  }

  CanDoubleJump(): boolean {
      // TODO: implement
  }

  Dodge(DoubleClickMove: any /* actor.edoubleclickdir */): boolean {
      // TODO: implement
  }

  DoJump(bUpdating: boolean): boolean {
      // TODO: implement
  }

  PlayMoverHitSound(): void {
      // TODO: implement
  }

  CanBeAffectedByHurtRadius(): boolean {
      // TODO: implement
  }

  PlayHit(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, DamageType: any /* class */, Momentum: THREE.Vector3): void {
      // TODO: implement
  }

  ChunkUp(HitRotation: THREE.Euler, D: any /* class */): void {
      // TODO: implement
  }

  SetAnimAction(NewAction: string): void {
      // TODO: implement
  }

  PlayRagdoll(DamageType: any /* class */, HitLoc: THREE.Vector3): void {
      // TODO: implement
  }

  PlayDying(DamageType: any /* class */, HitLoc: THREE.Vector3, HitMomentum: THREE.Vector3, inKillerLocation: THREE.Vector3): void {
      // TODO: implement
  }

  ChangeAnimation(): void {
      // TODO: implement
  }

  AnimEnd(Channel: number): void {
      // TODO: implement
  }

  CannotJumpNow(): boolean {
      // TODO: implement
  }

  PlayJump(): void {
      // TODO: implement
  }

  PlayFalling(): void {
      // TODO: implement
  }

  PlayMoving(): void {
      // TODO: implement
  }

  PlayWaiting(): void {
      // TODO: implement
  }

  PlayLanded(impactVel: number): void {
      // TODO: implement
  }

  PlayLandingAnimation(impactVel: number): void {
      // TODO: implement
  }

  GetDesiredItemPocket(): any /* handheldequipment.pocket */ {
      // TODO: implement
  }

  SetDesiredItemPocket(NewPocket: any /* handheldequipment.pocket */): void {
      // TODO: implement
  }

  DesiredItemPocketChanged(): void {
      // TODO: implement
  }

  SetActiveItem(inActiveItem: any /* handheldequipment */): void {
      // TODO: implement
  }

  SetPendingItem(inPendingItem: any /* handheldequipment */): void {
      // TODO: implement
  }

  GetActiveItem(): any /* handheldequipment */ {
      // no body (native/abstract)
  }

  GetPendingItem(): any /* handheldequipment */ {
      // TODO: implement
  }

  OnEquipKeyFrame(): void {
      // TODO: implement
  }

  OnActiveItemEquipped(): void {
      // TODO: implement
  }

  OnEquippingFinished(): void {
      // TODO: implement
  }

  OnUnequipKeyFrame(): void {
      // TODO: implement
  }

  OnActiveItemUnEquipped(): void {
      // TODO: implement
  }

  OnUseKeyFrame(): void {
      // TODO: implement
  }

  OnUsingBegan(): void {
      // TODO: implement
  }

  OnUsingFinished(): void {
      // TODO: implement
  }

  IWasNonlethaledAndFinishedSoDoAnEquipIfINeedToDoOne(): void {
      // TODO: implement
  }

  OnReloadKeyFrame(): void {
      // TODO: implement
  }

  OnReloadingFinished(): void {
      // TODO: implement
  }

  IdleHoldingEquipment(): void {
      // TODO: implement
  }

  DestroyEquipment(): void {
      // TODO: implement
  }

  AIInterruptEquipment(): void {
      // TODO: implement
  }

  FindAnchor(bMustFindAnchor: boolean): void {
      // no body (native/abstract)
  }

  ServerBeginFiringWeapon(ItemSlot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  ServerEndFiringWeapon(): void {
      // TODO: implement
  }

  BroadcastEmptyFiredToClients(): void {
      // TODO: implement
  }

  ServerSetCurrentFireMode(ItemSlot: any /* handheldequipment.equipmentslot */, NewFireMode: any /* firedweapon.firemode */): void {
      // TODO: implement
  }

  OnFireModeChanged(): void {
      // TODO: implement
  }

  ServerRequestReload(ItemSlot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  AnimGetSpecialChannel(): number {
      // TODO: implement
  }

  AnimGetEquipmentChannel(): number {
      // TODO: implement
  }

  AnimPlaySpecial(AnimName: string, TweenTime: number, Bone: string, Rate: number): number {
      // TODO: implement
  }

  AnimPlayEquipment(AnimPlayType: any /* pawn.eanimplaytype */, AnimName: string, TweenTime: number, Bone: string, Rate: number): number {
      // TODO: implement
  }

  AnimLoopSpecial(AnimName: string, TweenTime: number, Bone: string, Rate: number): number {
      // TODO: implement
  }

  AnimLoopEquipment(AnimPlayType: any /* pawn.eanimplaytype */, AnimName: string, TweenTime: number, Bone: string, Rate: number): number {
      // TODO: implement
  }

  EnableAnimSpecialAlphaOverride(Alpha: number): void {
      // TODO: implement
  }

  DisableAnimSpecialAlphaOverride(): void {
      // TODO: implement
  }

  EnableAnimEquipmentAlphaOverride(Alpha: number): void {
      // TODO: implement
  }

  DisableAnimEquipmentAlphaOverride(): void {
      // TODO: implement
  }

  AnimStopSpecial(): void {
      // TODO: implement
  }

  AnimStopEquipment(): void {
      // TODO: implement
  }

  AnimFinishSpecial(): void {
      // TODO: implement
  }

  AnimFinishEquipment(): void {
      // TODO: implement
  }

  OnCollisionAvoidanceMoveTo(MoveToLocation: THREE.Vector3): void {
      // TODO: implement
  }

  ViewRotationOffset(): THREE.Euler {
      // TODO: implement
  }

  ViewLocationOffset(CameraRotation: THREE.Euler): THREE.Vector3 {
      // TODO: implement
  }

  WantsToContinueAutoFiring(): boolean {
      // TODO: implement
  }

  OnAutoFireStarted(): void {
      // TODO: implement
  }

  FindItemForPickupToReplace(PickedUp: any /* handheldequipment */): any /* handheldequipment */ {
      // TODO: implement
  }

  OnPickedUp(PickedUp: any /* handheldequipment */): void {
      // TODO: implement
  }

  BecomeRagdoll(): void {
      // TODO: implement
  }

  ApplyRotationOffset(Acceleration: THREE.Vector3): void {
      // TODO: implement
  }

  OnEvidenceSecured(Evidence: any /* ievidence */): void {
      // TODO: implement
  }

  InterruptState(Reason: string): void {
      // TODO: implement
  }

  ChangeAnimation(): void {
      // TODO: implement
  }

  StopPlayFiring(): void {
      // TODO: implement
  }

  PlayFiring(Rate: number, FiringMode: string): void {
      // TODO: implement
  }

  PlayWeaponSwitch(NewWeapon: any /* weapon */): void {
      // TODO: implement
  }

  PlayNextAnimation(): void {
      // TODO: implement
  }

  Died(Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3): void {
      // TODO: implement
  }

  FellOutOfWorld(KillType: any /* actor.ekillztype */): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  Landed(HitNormal: THREE.Vector3): void {
      // TODO: implement
  }

  ReduceCylinder(): void {
      // TODO: implement
  }

  LandThump(): void {
      // TODO: implement
  }

  AnimEnd(Channel: number): void {
      // TODO: implement
  }

  LieStill(): void {
      // TODO: implement
  }

  BaseChange(): void {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

}
