// Auto-generated skeleton from UnrealScript: SwatGame/SwatPawn.uc
// Parent: Pawn

class SwatPawn extends Pawn {

  // Variables
  AnimSet: any /* animationset */;  // private AnimationSet
  AnimBoneBase: string;  // private config name
  AnimBoneSpineLow: string;  // private config name
  AnimBoneRightShoulder: string;  // private config name
  AnimBoneHead: string;  // private config name
  AnimBoneJaw: string;  // private config name
  NormalAimLocationBone: string;  // private config name
  LeanAimLocationBone: string;  // private config name
  NormalFireLocationBone: string;  // private config name
  LeanFireLocationBone: string;  // private config name
  AnimSocketGripRhand: string;  // private config name
  AnimSocketGripBack: string;  // private config name
  AnimSocketGripHolster: string;  // private config name
  AnimSocketGripBelt1: string;  // private config name
  AnimSocketGripBelt2: string;  // private config name
  AnimSocketHolster: string;  // private config name
  AnimSocketPouch: string;  // private config name
  AnimSocketHeadGear: string;  // private config name
  MaleAnimGroups: string[];  // config array<string>
  FemaleAnimGroups: string[];  // config array<string>
  PercentageHealthForIntenseInjury: number;  // private config float
  bWasSpecialChannelAnimatingLastFrame: boolean;  // private bool
  bWasEquipmentChannelAnimatingLastFrame: boolean;  // private bool
  AnimSpecialAlphaOverride: number;  // private float
  bIsAnimSpecialAlphaOverrideEnabled: boolean;  // private bool
  AnimEquipmentAlphaOverride: number;  // private float
  bIsAnimEquipmentAlphaOverrideEnabled: boolean;  // private bool
  AnimBaseYaw: number;  // private float
  AnimBaseTurnToYaw: number;  // private float
  bIsAnimBaseTurnToYawValid: boolean;  // private bool
  AnimRotationUrgency: any /* swatpawn.eanimrotationurgency */;  // private SwatPawn.EAnimRotationUrgency
  AnimAimRotationUrgency: any /* swatpawn.eanimaimrotationurgency */;  // private SwatPawn.EAnimAimRotationUrgency
  bIsTurning: boolean;  // private bool
  AverageSpeedSampleIndex: number;  // private int
  LastSpeedSampleTick: number;  // private int
  AimBlendChangeTime: number;  // private float
  InertialAimAcceleration: number;  // private float
  InertialAimDeceleration: number;  // private float
  InertialAimMaxVelocity: number;  // private float
  InertialAimPositionPitch: number;  // private float
  InertialAimPositionYaw: number;  // private float
  InertialAimVelocityPitch: number;  // private float
  InertialAimVelocityYaw: number;  // private float
  bIsMouthMoving: boolean;  // private bool
  MouthMovementPerlinNoise: any /* perlinnoise */;  // private PerlinNoise
  AnimAimType: any /* swatpawn.eanimaimtype */;  // private SwatPawn.EAnimAimType
  AnimAimRotator: THREE.Euler;  // private Rotator
  AnimAimPoint: THREE.Vector3;  // private Vector
  AnimAimActor: any /* actor */;  // private Actor
  AnimLeanState: any /* pawn.eleanstate */;  // private Pawn.ELeanState
  bAnimDrawDebugLines: boolean;  // private bool
  DoorKnowledgeMap: any /* pawndoorknowledge> */;  // native const transient map<name, PawnDoorKnowledge>
  FlashlightShouldBeOn: boolean;  // private bool
  bIsLowReady: boolean;  // private bool
  ReasonForLowReady: string;  // private name
  bShouldBeAtLowReady: boolean;  // private bool
  ReasonForShouldBeAtLowReady: string;  // private name
  bIsOnStairs: boolean;  // private bool
  bGoingUpStairs: boolean;  // private bool
  LastLocation: THREE.Vector3;  // private Vector
  bIsFlashbanged: boolean;  // private bool
  bIsGassed: boolean;  // private bool
  bIsPepperSprayed: boolean;  // private bool
  bIsStung: boolean;  // private bool
  bIsStunnedByC2: boolean;  // private bool
  bIsTased: boolean;  // private bool
  MaxComplianceIssueDistance: number;  // private config float
  bArrested: boolean;  // private bool
  BeingArrested: boolean;  // private bool
  ArrestedBy: any /* pawn */;  // private Pawn
  QualifyTimeForArrest: number;  // private config float
  bWantsToContinueAutoFiring: boolean;  //  bool
  LeanPositionOffset: THREE.Vector3;  // private Vector
  LeanRotationOffset: THREE.Euler;  // private Rotator
  LastLeanOffsetsUpdateTime: number;  // private float
  LeanVerticalDistance: number;  // private config float
  LeanRollDegrees: number;  // private config float
  LeanBezierPt1X: number;  // private config float
  LeanBezierPt1Y: number;  // private config float
  LeanBezierPt2X: number;  // private config float
  LeanBezierPt2Y: number;  // private config float
  CachedPlayerControllerForOptiwand: any /* controller */;  //  Controller
  RenderBoundingBoxExpansionSize: number;  // const float
  LastAimRotator: THREE.Euler;  // private Rotator

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

  Destroyed(): void {
      // TODO: implement
  }

  InitAnimationForCurrentMesh(): void {
      // TODO: implement
  }

  InitNativeAnimationSystemForPawn(): void {
      // no body (native/abstract)
  }

  GetAnimPackageGroups(): string[] {
      // TODO: implement
  }

  AnimLoadPackageGroups(): void {
      // TODO: implement
  }

  StaticGetAnimPackageGroups(AnimationSetNames: string[], LoadFemalePackageGroups: boolean): void {
      // TODO: implement
  }

  AnimSwapInSet(Set: any /* animationsetmanager.eanimationset */): void {
      // TODO: implement
  }

  AnimSwapInSet_Native(Set: any /* animationset */): void {
      // no body (native/abstract)
  }

  ShouldUseCuffedAnims(): boolean {
      // TODO: implement
  }

  GetCompliantAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetRestrainedAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingWalkAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingWalkUpStairsAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingWalkDownStairsAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingRunAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingRunUpStairsAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingRunDownStairsAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetCrouchingAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingInjuredAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingInjuredUpStairsAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingInjuredDownStairsAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetCrouchingInjuredAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  IsLowerBodyInjured(): boolean {
      // no body (native/abstract)
  }

  GetMovementAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  SetThirdPersonMovementAnims(): void {
      // TODO: implement
  }

  GetHandgunAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetSubMachineGunAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetMachineGunAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetShotgunAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetThrownWeaponAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetTacticalAidAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetTacticalAidUseAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetPepperSprayAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetM4AimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetUMPAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetOptiwandAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetPaintballAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetCuffedAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetEquipmentAimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  AnimStopAimChannels(): void {
      // no body (native/abstract)
  }

  SetThirdPersonEquipmentAnims(): void {
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

  GetLowReadySet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  SetThirdPersonLowReadyAnims(): void {
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

  GetAffectedByTacticalAidAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  SetThirdPersonNonlethalReactionAnims(): void {
      // TODO: implement
  }

  GetMouthMovementSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  SetThirdPersonMouthMovementAnims(): void {
      // TODO: implement
  }

  SetThirdPersonLeanAnims(): void {
      // no body (native/abstract)
  }

  ChangeAnimation(): void {
      // TODO: implement
  }

  SetAdditionalAnimSets(): void {
      // TODO: implement
  }

  StartMouthMovement(): void {
      // TODO: implement
  }

  StopMouthMovement(): void {
      // TODO: implement
  }

  InitMouthMovementPerlinNoise(): void {
      // TODO: implement
  }

  OnLeanStateChange(): void {
      // TODO: implement
  }

  IsTurning(): boolean {
      // TODO: implement
  }

  OnActiveItemEquipped(): void {
      // TODO: implement
  }

  OnEquippingFinished(): void {
      // TODO: implement
  }

  OnActiveItemUnEquipped(): void {
      // TODO: implement
  }

  OnNonlethalEffectChanged(): void {
      // TODO: implement
  }

  OnbIsTasedChanged(): void {
      // TODO: implement
  }

  OnArrestedStatusChanged(): void {
      // TODO: implement
  }

  AimToRotation(DesiredRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetViewDirection(): THREE.Vector3 {
      // TODO: implement
  }

  GetViewPoint(): THREE.Vector3 {
      // TODO: implement
  }

  ServerSetAimRotation(Rotator: THREE.Euler): void {
      // TODO: implement
  }

  GetAimRotation(): THREE.Euler {
      // TODO: implement
  }

  AdjustAim(FiredAmmunition: any /* ammunition */, projStart: THREE.Vector3, aimerror: number): THREE.Euler {
      // TODO: implement
  }

  AnimSetAimRotation(Rotator: THREE.Euler): void {
      // TODO: implement
  }

  AnimSetAimPoint(Point: THREE.Vector3): void {
      // TODO: implement
  }

  AnimSetAimActor(Actor: any /* actor */): void {
      // TODO: implement
  }

  AnimAimUnset(): void {
      // TODO: implement
  }

  AnimIsAimSet(): boolean {
      // TODO: implement
  }

  AnimGetAimRotation(): THREE.Euler {
      // no body (native/abstract)
  }

  AnimIsAimedAtDesired(): boolean {
      // no body (native/abstract)
  }

  AnimCanAimAtDesiredPoint(Point: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  AnimCanAimAtDesiredActor(Actor: any /* actor */): boolean {
      // no body (native/abstract)
  }

  AnimCanAimAtDesiredRotation(Rotation: THREE.Euler): boolean {
      // no body (native/abstract)
  }

  IsLowReady(): boolean {
      // TODO: implement
  }

  SetLowReady(bEnable: boolean, Reason: string): void {
      // TODO: implement
  }

  CanPawnUseLowReady(): boolean {
      // TODO: implement
  }

  ServerSetLowReadyStatus(bEnable: boolean, Reason: string): void {
      // TODO: implement
  }

  OnLowReadyStatusChanged(): void {
      // TODO: implement
  }

  AnimGetSpecialChannel(): number {
      // no body (native/abstract)
  }

  AnimGetEquipmentChannel(): number {
      // no body (native/abstract)
  }

  AnimGetQuickHitChannel(): number {
      // no body (native/abstract)
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

  AnimPlayQuickHit(AnimName: string, TweenTime: number, Bone: string, Rate: number): number {
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
      // no body (native/abstract)
  }

  AnimStopEquipment(): void {
      // no body (native/abstract)
  }

  AnimStopQuickHit(): void {
      // no body (native/abstract)
  }

  AnimFinishSpecial(): void {
      // TODO: implement
  }

  AnimFinishEquipment(): void {
      // TODO: implement
  }

  AnimSetTweenAndBoneForChannel(Channel: number, TweenTime: number, Bone: string): void {
      // TODO: implement
  }

  GetUpperBodyBone(): string {
      // TODO: implement
  }

  AnimSetRotationUrgency(Urgency: any /* swatpawn.eanimrotationurgency */): void {
      // TODO: implement
  }

  AnimSetAnimAimRotationUrgency(Urgency: any /* swatpawn.eanimaimrotationurgency */): void {
      // TODO: implement
  }

  AnimSetIdle(NewIdleAnimation: string, TweenTime: number): void {
      // no body (native/abstract)
  }

  AnimSetFlag(Flag: any /* swatpawn.eanimflag */, bEnable: boolean): void {
      // TODO: implement
  }

  AnimGetFlag(Flag: any /* swatpawn.eanimflag */): boolean {
      // TODO: implement
  }

  AnimAreChannelsAtZeroAlpha(StartChannel: number, LastChannel: number): boolean {
      // no body (native/abstract)
  }

  AnimAreAimingChannelsMuted(): boolean {
      // no body (native/abstract)
  }

  GetAnimBaseYaw(): number {
      // TODO: implement
  }

  AnimSnapBaseToAim(): void {
      // no body (native/abstract)
  }

  AnimIsBaseAtAim(): boolean {
      // TODO: implement
  }

  AnimSnapRotationToBase(): void {
      // no body (native/abstract)
  }

  AnimGetAimOrigin(): THREE.Vector3 {
      // no body (native/abstract)
  }

  ToggleAnimDrawDebugLines(): void {
      // TODO: implement
  }

  SetRenderBoundingBoxExpansionSize(NewRenderBoundingBoxExpansionSize: number): void {
      // no body (native/abstract)
  }

  Died(Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3): void {
      // TODO: implement
  }

  TriggerPawnDied(Killer: any /* controller */): void {
      // TODO: implement
  }

  IsIntenseInjury(): boolean {
      // TODO: implement
  }

  SetWalking(bNewIsWalking: boolean): void {
      // TODO: implement
  }

  BaseChange(): void {
      // TODO: implement
  }

  IsAtRunningSpeed(): boolean {
      // TODO: implement
  }

  GetDoorKnowledge(inDoor: any /* door */): any /* pawndoorknowledge */ {
      // no body (native/abstract)
  }

  InitializeDoorKnowledge(inDoor: any /* door */, DoorKnowledge: any /* pawndoorknowledge */): void {
      // TODO: implement
  }

  DoesBelieveDoorLocked(inDoor: any /* door */): boolean {
      // no body (native/abstract)
  }

  DoesBelieveDoorWedged(inDoor: any /* door */): boolean {
      // no body (native/abstract)
  }

  SetDoorLockedBelief(inDoor: any /* door */, bBelievesDoorLocked: boolean): void {
      // TODO: implement
  }

  SetDoorWedgedBelief(inDoor: any /* door */, bBelievesDoorWedged: boolean): void {
      // TODO: implement
  }

  SetIsFlashbanged(Value: boolean): void {
      // TODO: implement
  }

  SetIsGassed(Value: boolean): void {
      // TODO: implement
  }

  SetIsPepperSprayed(Value: boolean): void {
      // TODO: implement
  }

  SetIsStung(Value: boolean): void {
      // TODO: implement
  }

  SetIsStunnedByC2(Value: boolean): void {
      // TODO: implement
  }

  SetIsTased(Value: boolean): void {
      // TODO: implement
  }

  IsFlashbanged(): boolean {
      // TODO: implement
  }

  IsGassed(): boolean {
      // TODO: implement
  }

  IsPepperSprayed(): boolean {
      // TODO: implement
  }

  IsStung(): boolean {
      // TODO: implement
  }

  IsStunnedByC2(): boolean {
      // TODO: implement
  }

  IsTased(): boolean {
      // TODO: implement
  }

  IsNonlethaled(): boolean {
      // TODO: implement
  }

  ResetNonlethalEffects(): void {
      // TODO: implement
  }

  GetDesiredFlashlightState(): boolean {
      // TODO: implement
  }

  GetDelayBeforeFlashlightShutoff(): number {
      // TODO: implement
  }

  ToggleDesiredFlashlightState(): void {
      // TODO: implement
  }

  ServerToggleDesiredFlashlightState(): void {
      // TODO: implement
  }

  FlashlightShouldBeOnChanged(): void {
      // TODO: implement
  }

  SetDesiredFlashlightState(DesireFlashlightOn: boolean): void {
      // TODO: implement
  }

  UpdateFlashlight(): void {
      // TODO: implement
  }

  OnPlayerViewChanged(): void {
      // TODO: implement
  }

  CanIssueComplianceTo(otherPawn: any /* pawn */): boolean {
      // TODO: implement
  }

  HasFiredWeaponEquipped(): boolean {
      // TODO: implement
  }

  IssueComplianceTo(TargetPawn: any /* pawn */): void {
      // TODO: implement
  }

  IssueCompliance(): boolean {
      // TODO: implement
  }

  CanBeArrestedNow(): boolean {
      // TODO: implement
  }

  IsBeingArrestedNow(): boolean {
      // TODO: implement
  }

  OnArrestBegan(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnArrested(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnArrestedSwatPawn(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnUnarrestedSwatPawn(Unarrester: any /* pawn */): void {
      // TODO: implement
  }

  OnArrestInterrupted(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  GetQualifyTimeForArrest(): number {
      // TODO: implement
  }

  IsArrested(): boolean {
      // no body (native/abstract)
  }

  GetArrester(): any /* pawn */ {
      // TODO: implement
  }

  WantsToContinueAutoFiring(): boolean {
      // TODO: implement
  }

  OnAutoFireStarted(): void {
      // TODO: implement
  }

  OnFireModeChanged(): void {
      // TODO: implement
  }

  OnMeshChanged(): void {
      // TODO: implement
  }

  UpdateHUDFireMode(): void {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  OnEvidenceSecured(Evidence: any /* ievidence */): void {
      // TODO: implement
  }

  GetTeamNumber(): number {
      // TODO: implement
  }

  UnPossessed(): void {
      // TODO: implement
  }

  BroadcastStopAllSounds(): void {
      // TODO: implement
  }

  StopAllSounds(): void {
      // TODO: implement
  }

  GetPlayerTag(): string {
      // TODO: implement
  }

}
