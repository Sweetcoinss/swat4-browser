// Auto-generated skeleton from UnrealScript: SwatGame/SwatDoor.uc
// Parent: Door

class SwatDoor extends Door {

  // Variables
  bIsLocked: boolean;  // private bool
  bCanBeLocked: boolean;  // private bool
  bWasInitiallyLocked: boolean;  // private bool
  bWasInitiallyOpen: boolean;  // private bool
  bIsBroken: boolean;  //  bool
  DoorAntiPortal: any /* antiportalactor */;  // private AntiPortalActor
  bIsBoobyTrapped: boolean;  // private bool
  BoobyTrap: any /* boobytrap */;  // private BoobyTrap
  Attachments: any /* doorattachmentspec */[];  //  array<DoorAttachmentSpec>
  CurrentPosition: any /* door.doorposition */;  // private Door.DoorPosition
  QualifyTimeForToolkit: number;  // config float
  QualifyTimeForWedge: number;  // config float
  QualifyTimeForC2Charge: number;  // config float
  DoorWay: any /* doorway */;  //  DoorWay
  LeftStackupPoints: any /* leftstackuppoint */[];  // /*0x00000000-0x00080000*/ array<LeftStackupPoint>
  RightStackupPoints: any /* rightstackuppoint */[];  // /*0x00000000-0x00080000*/ array<RightStackupPoint>
  LeftClearPoints: any /* leftclearpoint */[];  // /*0x00000000-0x00080000*/ array<LeftClearPoint>
  RightClearPoints: any /* rightclearpoint */[];  // /*0x00000000-0x00080000*/ array<RightClearPoint>
  AlternateLeftStackupPoints: any /* stackuppoint */[];  // /*0x00000000-0x00080000*/ array<StackupPoint>
  AlternateRightStackupPoints: any /* stackuppoint */[];  // /*0x00000000-0x00080000*/ array<StackupPoint>
  LeftAdditionalGrenadeThrowDistance: number;  //  float
  RightAdditionalGrenadeThrowDistance: number;  //  float
  LeftInternalRoomName: string;  //  name
  RightInternalRoomName: string;  //  name
  LastInteractor: any /* pawn */;  // private Pawn
  PendingInteractor: any /* pawn */;  // private Pawn
  LeftPlacedThrowPoint: any /* placedthrowpoint */;  // edfindable PlacedThrowPoint
  RightPlacedThrowPoint: any /* placedthrowpoint */;  // edfindable PlacedThrowPoint
  LeftSideBackOpenPointBoneName: string;  // private config name
  LeftSideFrontOpenPointBoneName: string;  // private config name
  LeftSideCenterOpenPointBoneName: string;  // private config name
  RightSideBackOpenPointBoneName: string;  // private config name
  RightSideFrontOpenPointBoneName: string;  // private config name
  RightSideCenterOpenPointBoneName: string;  // private config name
  OpenLeftAwayClosePointBoneName: string;  // private config name
  OpenLeftTowardsClosePointBoneName: string;  // private config name
  OpenRightAwayClosePointBoneName: string;  // private config name
  OpenRightTowardsClosePointBoneName: string;  // private config name
  RightSideKnobBreachPointBoneName: string;  // private config name
  RightSideHingeBreachPointBoneName: string;  // private config name
  LeftSideKnobBreachPointBoneName: string;  // private config name
  LeftSideHingeBreachPointBoneName: string;  // private config name
  bLeftSideBackOpenPointUsable: boolean;  // private bool
  bLeftSideFrontOpenPointUsable: boolean;  // private bool
  bLeftSideCenterOpenPointUsable: boolean;  // private bool
  bRightSideBackOpenPointUsable: boolean;  // private bool
  bRightSideFrontOpenPointUsable: boolean;  // private bool
  bRightSideCenterOpenPointUsable: boolean;  // private bool
  bRightSideKnobBreachPointUsable: boolean;  // private bool
  bRightSideHingeBreachPointUsable: boolean;  // private bool
  bLeftSideKnobBreachPointUsable: boolean;  // private bool
  bLeftSideHingeBreachPointUsable: boolean;  // private bool
  LeftSideBackOpenPoint: THREE.Vector3;  // private Vector
  LeftSideFrontOpenPoint: THREE.Vector3;  // private Vector
  LeftSideCenterOpenPoint: THREE.Vector3;  // private Vector
  RightSideBackOpenPoint: THREE.Vector3;  // private Vector
  RightSideFrontOpenPoint: THREE.Vector3;  // private Vector
  RightSideCenterOpenPoint: THREE.Vector3;  // private Vector
  RightSideKnobBreachPoint: THREE.Vector3;  // private Vector
  RightSideHingeBreachPoint: THREE.Vector3;  // private Vector
  LeftSideKnobBreachPoint: THREE.Vector3;  // private Vector
  LeftSideHingeBreachPoint: THREE.Vector3;  // private Vector
  OpenLeftAwayClosePoint: THREE.Vector3;  // private Vector
  OpenLeftTowardsClosePoint: THREE.Vector3;  // private Vector
  OpenRightAwayClosePoint: THREE.Vector3;  // private Vector
  OpenRightTowardsClosePoint: THREE.Vector3;  // private Vector
  LeftSideBackKnobOpenAnimation: string;  // private config name
  LeftSideFrontKnobOpenAnimation: string;  // private config name
  LeftSideCenterKnobOpenAnimation: string;  // private config name
  LeftSideBackPushOpenAnimation: string;  // private config name
  LeftSideFrontPushOpenAnimation: string;  // private config name
  LeftSideCenterPushOpenAnimation: string;  // private config name
  RightSideBackKnobOpenAnimation: string;  // private config name
  RightSideFrontKnobOpenAnimation: string;  // private config name
  RightSideCenterKnobOpenAnimation: string;  // private config name
  RightSideBackPushOpenAnimation: string;  // private config name
  RightSideFrontPushOpenAnimation: string;  // private config name
  RightSideCenterPushOpenAnimation: string;  // private config name
  LeftSideBackKnobTryAnimation: string;  // private config name
  LeftSideFrontKnobTryAnimation: string;  // private config name
  LeftSideCenterKnobTryAnimation: string;  // private config name
  LeftSideBackPushTryAnimation: string;  // private config name
  LeftSideFrontPushTryAnimation: string;  // private config name
  LeftSideCenterPushTryAnimation: string;  // private config name
  RightSideBackKnobTryAnimation: string;  // private config name
  RightSideFrontKnobTryAnimation: string;  // private config name
  RightSideCenterKnobTryAnimation: string;  // private config name
  RightSideBackPushTryAnimation: string;  // private config name
  RightSideFrontPushTryAnimation: string;  // private config name
  RightSideCenterPushTryAnimation: string;  // private config name
  LeftSideCenterFranticKnobOpenAnimation: string;  // private config name
  RightSideCenterFranticKnobOpenAnimation: string;  // private config name
  LeftSideCenterFranticPushOpenAnimation: string;  // private config name
  RightSideCenterFranticPushOpenAnimation: string;  // private config name
  OLBackTowardsKnobCloseAnimation: string;  // private config name
  OLBackTowardsPushCloseAnimation: string;  // private config name
  OLFrontTowardsKnobCloseAnimation: string;  // private config name
  OLFrontTowardsPushCloseAnimation: string;  // private config name
  OLFrontAwayKnobCloseAnimation: string;  // private config name
  OLFrontAwayPushCloseAnimation: string;  // private config name
  ORBackTowardsKnobCloseAnimation: string;  // private config name
  ORBackTowardsPushCloseAnimation: string;  // private config name
  ORFrontTowardsKnobCloseAnimation: string;  // private config name
  ORFrontTowardsPushCloseAnimation: string;  // private config name
  ORFrontAwayKnobCloseAnimation: string;  // private config name
  ORFrontAwayPushCloseAnimation: string;  // private config name
  MoveAndClearPauseThreshold: number;  // private config float
  DoorBufferVolume: any /* doorbuffervolume */;  //  DoorBufferVolume
  DoorBufferVolumeCollisionMesh: any /* staticmesh */;  //  StaticMesh
  DeployedWedgeClassName: string;  //  string
  DeployedWedgeClass: any /* class */;  //  Class<Actor>
  DeployedC2ChargeClassName: string;  //  string
  DeployedC2ChargeClass: any /* class */;  //  Class<Actor>
  DeployedWedge: any /* deployedwedgebase */;  // private DeployedWedgeBase
  DeployedC2ChargeLeft: any /* deployedc2chargebase */;  // private DeployedC2ChargeBase
  DeployedC2ChargeRight: any /* deployedc2chargebase */;  // private DeployedC2ChargeBase
  doorknob: any /* the */;  // SwatDoor.ECommandDirection AcceptsCommandsFrom "Only applies in single-player. Designates the side from which squad commands can be given on this door. The side is determined by drawing an imaginary line from the door hinge to the
  PreviousAcceptsCommandsFrom: any /* swatdoor.ecommanddirection */;  // private const transient SwatDoor.ECommandDirection
  InterestedInDoorOpeningRegistrants: any /* iinterestedindooropening */[];  //  array<IInterestedInDoorOpening>
  BlockingPawns: any /* pawn */[];  //  array<Pawn>
  ReasonForMove: any /* swatdoor.emovereason */;  // private SwatDoor.EMoveReason
  RemainingUpdateAttachmentLocationsCounter: number;  // private int

  constructor() {
    super();
  }

  // Methods
  GetPosition(): any /* door.doorposition */ {
      // TODO: implement
  }

  IsChargePlacedOnLeft(): boolean {
      // TODO: implement
  }

  IsChargePlacedOnRight(): boolean {
      // TODO: implement
  }

  WasDoorInitiallyLocked(): boolean {
      // TODO: implement
  }

  WasDoorInitiallyOpen(): boolean {
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

  Tick(dTime: number): void {
      // TODO: implement
  }

  GetInitialPosition(): any /* door.doorposition */ {
      // TODO: implement
  }

  IsBoobyTrapped(): boolean {
      // TODO: implement
  }

  SetBoobyTrap(Trap: any /* boobytrap */): void {
      // TODO: implement
  }

  IsInterestedInDoorOpeningRegistrant(Registrant: any /* iinterestedindooropening */): boolean {
      // TODO: implement
  }

  RegisterInterestedInDoorOpening(Registrant: any /* iinterestedindooropening */): void {
      // TODO: implement
  }

  UnRegisterInterestedInDoorOpening(Registrant: any /* iinterestedindooropening */): void {
      // TODO: implement
  }

  NotifyRegistrantsDoorOpening(): void {
      // TODO: implement
  }

  CanInteract(): boolean {
      // TODO: implement
  }

  Interact(Other: any /* pawn */, Force: boolean): void {
      // TODO: implement
  }

  OnWedged(): void {
      // TODO: implement
  }

  OnUnwedged(): void {
      // TODO: implement
  }

  OnUnlocked(): void {
      // TODO: implement
  }

  KnowsDoorIsLocked(TeamNumber: number): boolean {
      // TODO: implement
  }

  IsAntiPortalOn(): boolean {
      // TODO: implement
  }

  ReactivateNearbyRagdolls(): void {
      // TODO: implement
  }

  SetAntiPortalAndMPBlockingVolume(Enabled: boolean): void {
      // TODO: implement
  }

  SetPositionForMove(inPositionForMove: any /* door.doorposition */, inReasonForMove: any /* swatdoor.emovereason */, bDontUpdateDesired: boolean): void {
      // TODO: implement
  }

  Moved(Instantly: boolean, Force: boolean): void {
      // TODO: implement
  }

  NotifyAIsBlockingDoorClose(): void {
      // TODO: implement
  }

  NotifyAIsBlockingDoorOpen(): void {
      // TODO: implement
  }

  NotifyClientsOfDoorBlocked(OpeningBlocked: boolean): void {
      // TODO: implement
  }

  Blasted(Instigator: any /* pawn */): void {
      // TODO: implement
  }

  Breached(Charge: any /* deployedc2chargebase */): void {
      // TODO: implement
  }

  PointIsToMyLeft(Point: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  PointIsOnSideThatDoorIsOpenTo(Point: THREE.Vector3, TreatOpeningDoorsAsClosed: boolean): boolean {
      // TODO: implement
  }

  ActorIsToMyLeft(Other: any /* actor */): boolean {
      // TODO: implement
  }

  LocalPlayerIsToMyLeft(): boolean {
      // TODO: implement
  }

  PointIsOnExternalSide(Point: THREE.Vector3): boolean {
      // TODO: implement
  }

  PositionIsBlocked(TestPosition: any /* door.doorposition */): boolean {
      // TODO: implement
  }

  GetPivotLocation(): THREE.Vector3 {
      // TODO: implement
  }

  LocationIsInSweep(DoorPivot: THREE.Vector3, testLocation: THREE.Vector3, TestLocationCollisionRadius: number, Side: any /* door.doorposition */): boolean {
      // TODO: implement
  }

  UpdateOfficerDoorKnowledge(): void {
      // TODO: implement
  }

  PawnBelievesDoorLocked(Pawn: any /* swatpawn */): boolean {
      // TODO: implement
  }

  Broken(): void {
      // TODO: implement
  }

  PostBroken(): void {
      // TODO: implement
  }

  PlayBreachedEffects(): void {
      // TODO: implement
  }

  PlayDoorBreached(TheCharge: any /* deployedc2chargebase */): void {
      // TODO: implement
  }

  IsDoorOpenTowardsRequesterLocation(RequesterLocation: THREE.Vector3): boolean {
      // TODO: implement
  }

  GetStackupPoints(RequesterLocation: THREE.Vector3): any /* stackuppoint */[] {
      // TODO: implement
  }

  GetClearPoints(RequesterLocation: THREE.Vector3): any /* clearpoint */[] {
      // TODO: implement
  }

  AddSelfToRoomList(): void {
      // TODO: implement
  }

  GetLeftRoomName(): string {
      // no body (native/abstract)
  }

  GetRightRoomName(): string {
      // no body (native/abstract)
  }

  GetDoorModels(): any /* actor */[] {
      // TODO: implement
  }

  IsLeftSideFrontOpenPointUsable(): boolean {
      // TODO: implement
  }

  IsRightSideFrontOpenPointUsable(): boolean {
      // TODO: implement
  }

  AreSideOpenPointsUsableFromSide(bOnLeftSideOfDoor: boolean): boolean {
      // TODO: implement
  }

  AreSideOpenPointsUsable(Other: any /* pawn */): boolean {
      // TODO: implement
  }

  IsOfficerAtSideOpenPoint(Officer: any /* pawn */, bOnLeftSide: boolean): boolean {
      // TODO: implement
  }

  AreSideBreachPointsUsableFromSide(bOnLeftSideOfDoor: boolean): boolean {
      // TODO: implement
  }

  AreSideBreachPointsUsable(Other: any /* pawn */): boolean {
      // TODO: implement
  }

  GetClosestLeftBreachPointTo(TargetLocation: THREE.Vector3): THREE.Vector3 {
      // TODO: implement
  }

  GetClosestRightBreachPointTo(TargetLocation: THREE.Vector3): THREE.Vector3 {
      // TODO: implement
  }

  GetSideBreachPoint(Other: any /* pawn */): THREE.Vector3 {
      // TODO: implement
  }

  GetBreachFromPoint(Other: any /* pawn */): THREE.Vector3 {
      // TODO: implement
  }

  GetBreachAimPoint(Other: any /* pawn */): THREE.Vector3 {
      // TODO: implement
  }

  GetOpenPositions(Other: any /* pawn */, bPreferSides: boolean, OpenPoint: THREE.Vector3, PawnOpenRotation: THREE.Euler): any /* iswatai.aidoorusageside */ {
      // TODO: implement
  }

  GetCenterOpenRotation(CenterOpenPoint: THREE.Vector3): THREE.Euler {
      // TODO: implement
  }

  GetSidesOpenRotation(OpenPoint: THREE.Vector3): THREE.Euler {
      // TODO: implement
  }

  GetClosestLeftOpenPointTo(TargetLocation: THREE.Vector3, DoorUsageSide: any /* iswatai.aidoorusageside */): THREE.Vector3 {
      // TODO: implement
  }

  GetClosestRightOpenPointTo(TargetLocation: THREE.Vector3, DoorUsageSide: any /* iswatai.aidoorusageside */): THREE.Vector3 {
      // TODO: implement
  }

  GetSidesOpenPoint(Officer: any /* pawn */, DoorUsageSide: any /* iswatai.aidoorusageside */): THREE.Vector3 {
      // TODO: implement
  }

  GetCenterOpenPoint(Other: any /* pawn */, DoorUsageSide: any /* iswatai.aidoorusageside */): THREE.Vector3 {
      // TODO: implement
  }

  GetClosePoint(bCloseFromLeft: boolean): THREE.Vector3 {
      // TODO: implement
  }

  GetLeftSideFrontOpenAnimation(): string {
      // TODO: implement
  }

  GetLeftSideBackOpenAnimation(): string {
      // TODO: implement
  }

  GetLeftSideCenterFranticOpenAnimation(): string {
      // TODO: implement
  }

  GetLeftSideCenterOpenAnimation(): string {
      // TODO: implement
  }

  GetRightSideFrontOpenAnimation(): string {
      // TODO: implement
  }

  GetRightSideBackOpenAnimation(): string {
      // TODO: implement
  }

  GetRightSideCenterFranticOpenAnimation(): string {
      // TODO: implement
  }

  GetRightSideCenterOpenAnimation(): string {
      // TODO: implement
  }

  GetOpenAnimation(Other: any /* pawn */, DoorUsageSide: any /* iswatai.aidoorusageside */, bIsFranticOpen: boolean): string {
      // TODO: implement
  }

  GetOLBackTowardsCloseAnimation(): string {
      // TODO: implement
  }

  GetOLFrontTowardsCloseAnimation(): string {
      // TODO: implement
  }

  GetOLFrontAwayCloseAnimation(): string {
      // TODO: implement
  }

  GetORBackTowardsCloseAnimation(): string {
      // TODO: implement
  }

  GetORFrontTowardsCloseAnimation(): string {
      // TODO: implement
  }

  GetORFrontAwayCloseAnimation(): string {
      // TODO: implement
  }

  GetCloseAnimation(Other: any /* pawn */, bCloseFromBehind: boolean): string {
      // TODO: implement
  }

  GetLeftSideFrontTryAnimation(): string {
      // TODO: implement
  }

  GetLeftSideBackTryAnimation(): string {
      // TODO: implement
  }

  GetLeftSideCenterTryAnimation(): string {
      // TODO: implement
  }

  GetRightSideFrontTryAnimation(): string {
      // TODO: implement
  }

  GetRightSideBackTryAnimation(): string {
      // TODO: implement
  }

  GetRightSideCenterTryAnimation(): string {
      // TODO: implement
  }

  GetTryDoorAnimation(Other: any /* pawn */, DoorUsageSide: any /* iswatai.aidoorusageside */): string {
      // TODO: implement
  }

  GetLastInteractor(): any /* pawn */ {
      // TODO: implement
  }

  GetPendingInteractor(): any /* pawn */ {
      // TODO: implement
  }

  SetPendingInteractor(Interactor: any /* pawn */): void {
      // TODO: implement
  }

  IsBlockedFor(Other: any /* pawn */): boolean {
      // TODO: implement
  }

  WasBlockedBy(BlockedClassName: string): boolean {
      // TODO: implement
  }

  GetPlacedThrowPoint(Origin: THREE.Vector3): any /* placedthrowpoint */ {
      // TODO: implement
  }

  GetAdditionalGrenadeThrowDistance(Origin: THREE.Vector3): number {
      // TODO: implement
  }

  CanBeLocked(): boolean {
      // TODO: implement
  }

  Lock(): void {
      // TODO: implement
  }

  GetMoveAndClearPauseThreshold(): number {
      // TODO: implement
  }

  SpawnDeployedWedge(): void {
      // TODO: implement
  }

  SpawnDeployedC2ChargeLeft(): void {
      // TODO: implement
  }

  SpawnDeployedC2ChargeRight(): void {
      // TODO: implement
  }

  GetDeployedWedge(): any /* deployedwedgebase */ {
      // TODO: implement
  }

  GetDeployedC2ChargeLeft(): any /* deployedc2chargebase */ {
      // TODO: implement
  }

  GetDeployedC2ChargeRight(): any /* deployedc2chargebase */ {
      // TODO: implement
  }

  IsC2ChargeOnPlayersSide(): boolean {
      // TODO: implement
  }

  CanBeUsedByToolkitNow(): boolean {
      // TODO: implement
  }

  OnUsingByToolkitBegan(User: any /* pawn */): void {
      // TODO: implement
  }

  OnUsedByToolkit(User: any /* pawn */): void {
      // TODO: implement
  }

  OnUsingByToolkitInterrupted(User: any /* pawn */): void {
      // TODO: implement
  }

  GetQualifyTimeForToolkit(): number {
      // TODO: implement
  }

  GetSkeletalRegionCenter(Region: any /* actor.eskeletalregion */): THREE.Vector3 {
      // no body (native/abstract)
  }

  OnUsedByWedge(): void {
      // TODO: implement
  }

  GetQualifyTimeForWedge(): number {
      // TODO: implement
  }

  OnUsedByC2Charge(Instigator: any /* icanusec2charge */): void {
      // TODO: implement
  }

  GetQualifyTimeForC2Charge(): number {
      // TODO: implement
  }

  OnSkeletalRegionHit(RegionHit: any /* actor.eskeletalregion */, HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, Damage: number, DamageType: any /* class */, Instigator: any /* actor */): void {
      // TODO: implement
  }

  DesiredPositionChanged(): void {
      // TODO: implement
  }

  GetDoorwayWidth(): number {
      // TODO: implement
  }

  GetPushAwayDirection(thePawn: any /* swatragdollpawn */): THREE.Vector3 {
      // TODO: implement
  }

  InitializeRemainingUpdateAttachmentLocationsCounter(): void {
      // TODO: implement
  }

  CanInteract(): boolean {
      // TODO: implement
  }

  Interact(Other: any /* pawn */, Force: boolean): void {
      // TODO: implement
  }

  MoveToPosition(NewPosition: any /* door.doorposition */, Instantly: boolean): void {
      // TODO: implement
  }

  StartMoving(): void {
      // TODO: implement
  }

  MoveSucceeds(): boolean {
      // TODO: implement
  }

  OnMoveEnded(): void {
      // TODO: implement
  }

  Tick(dTime: number): void {
      // TODO: implement
  }

  StartMoving(): void {
      // TODO: implement
  }

  OnMoveEnded(): void {
      // TODO: implement
  }

  StartMoving(): void {
      // TODO: implement
  }

  MoveSucceeds(): boolean {
      // TODO: implement
  }

  StartMoving(): void {
      // TODO: implement
  }

  StartMoving(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  StartMoving(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  StartMoving(): void {
      // TODO: implement
  }

}
