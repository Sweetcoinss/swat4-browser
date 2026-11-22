// Auto-generated skeleton from UnrealScript: SwatAICommon/SquadMoveAndClearAction.uc
// Parent: SquadStackUpAction

class SquadMoveAndClearAction extends SquadStackUpAction {

  // Variables
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  CurrentOpenDoorGoal: any /* opendoorgoal */;  // private OpenDoorGoal
  CurrentMoveToLocationGoal: any /* movetolocationgoal */;  // private MoveToLocationGoal
  CurrentThrowGrenadeGoal: any /* throwgrenadegoal */;  // private ThrowGrenadeGoal
  CurrentRemoveWedgeGoal: any /* removewedgegoal */;  // private RemoveWedgeGoal
  MoveAndClearGoals: any /* moveandcleargoal */[];  //  array<MoveAndClearGoal>
  MoveUpStackupGoals: any /* stackupgoal */[];  //  array<StackUpGoal>
  ClearPoints: any /* clearpoint */[];  //  array<ClearPoint>
  bClearingRoomIsOnRight: boolean;  // private bool
  bShouldStackUpBeforeClearing: boolean;  // private bool
  ClearFormation: any /* formation */;  // private Formation
  FollowerMoveInFormationGoal: any /* moveinformationgoal */;  // private MoveInFormationGoal
  LeaderDistanceSensor: any /* distancesensor */;  // private DistanceSensor
  FollowerDistanceSensor: any /* distancesensor */;  // private DistanceSensor
  LeaderMoveAndClearGoal: any /* moveandcleargoal */;  // private MoveAndClearGoal
  FollowerMoveAndClearGoal: any /* moveandcleargoal */;  // private MoveAndClearGoal
  WaitForFirstTwoOfficersTimer: any /* timer */;  // private Timer
  ThirdOfficerStackUpGoal: any /* stackupgoal */;  // private StackUpGoal
  FourthOfficerStackUpGoal: any /* stackupgoal */;  // private StackUpGoal
  LeaderDoorSideSensor: any /* doorsidesensor */;  // private DoorSideSensor
  FollowerDoorSideSensor: any /* doorsidesensor */;  // private DoorSideSensor
  bLeaderReachedOtherSide: boolean;  // private bool
  bFollowerReachedOtherSide: boolean;  // private bool
  NumClearPointsInClearingRoom: number;  // private int
  Leader: any /* pawn */;  // private Pawn
  Follower: any /* pawn */;  // private Pawn
  DoorOpener: any /* pawn */;  // private Pawn
  Thrower: any /* pawn */;  // private Pawn
  Breacher: any /* pawn */;  // private Pawn
  ThirdOfficer: any /* pawn */;  // private Pawn
  FourthOfficer: any /* pawn */;  // private Pawn
  InitialClearPauseTime: number;  // config float
  MaxWaitForFirstTwoOfficersTime: number;  // config float
  FormationMoveToThreshold: number;  // config float
  FormationWalkThreshold: number;  // config float
  DoorOpenedFromSideDelayTime: number;  // config float
  Projectile: any /* swatgrenadeprojectile */;  // private SwatGrenadeProjectile

  constructor() {
    super();
  }

  // Methods
  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  DetermineClearRoomSide(): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  ClearOutMoveAndClearGoals(): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  DeactivateDistanceSensors(): void {
      // TODO: implement
  }

  DeactivateDoorSideSensors(): void {
      // TODO: implement
  }

  goalAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */): void {
      // TODO: implement
  }

  NotifyPawnDied(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  NotifyGrenadeDetonated(Grenade: any /* swatgrenadeprojectile */): void {
      // TODO: implement
  }

  NotifyDoorOpening(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyGrenadeReadyToThrow(): void {
      // TODO: implement
  }

  NotifyRegisteredOnProjectile(Grenade: any /* swatgrenadeprojectile */): void {
      // TODO: implement
  }

  LatentMoveOfficerToActor(Officer: any /* pawn */, Destination: any /* actor */, Priority: number): void {
      // TODO: implement
  }

  ShouldRunToStackupPoint(): boolean {
      // TODO: implement
  }

  OpenTargetDoor(Officer: any /* pawn */): void {
      // TODO: implement
  }

  FirstOfficerReadyToOpenDoor(): void {
      // TODO: implement
  }

  ShouldThrowerBeFirstOfficer(): boolean {
      // TODO: implement
  }

  GetThrowingOfficer(ThrownItemSlot: any /* handheldequipment.equipmentslot */): any /* pawn */ {
      // TODO: implement
  }

  MoveOfficerToThrowingPoint(Officer: any /* pawn */, ThrowingPoint: THREE.Vector3): void {
      // TODO: implement
  }

  GetTargetDoorEdge(Officer: any /* pawn */): THREE.Vector3 {
      // TODO: implement
  }

  GetThrowSide(CenterOpenPoint: THREE.Vector3, ThrowingPoint: THREE.Vector3): any /* iswatai.aithrowside */ {
      // TODO: implement
  }

  GetTargetThrowPoint(ThrowOrigin: THREE.Vector3): THREE.Vector3 {
      // TODO: implement
  }

  PrepareToThrowGrenade(GrenadeSlot: any /* handheldequipment.equipmentslot */, bWaitToThrowGrenade: boolean): void {
      // TODO: implement
  }

  ThrowGrenade(): void {
      // TODO: implement
  }

  FinishUpThrowBehavior(): void {
      // TODO: implement
  }

  TriggerThrowGrenadeMoveUpSpeech(): void {
      // TODO: implement
  }

  MoveUpThrower(): void {
      // TODO: implement
  }

  SwapOfficerRoles(OfficerA: any /* pawn */, OfficerB: any /* pawn */): void {
      // TODO: implement
  }

  RemoveWedge(): void {
      // TODO: implement
  }

  WaitToFinishOpeningDoor(): void {
      // TODO: implement
  }

  OpenDoorForThrowingGrenade(): void {
      // TODO: implement
  }

  PrepareToMoveSquad(): void {
      // TODO: implement
  }

  FindNumberOfClearPointsInClearingRoom(): void {
      // TODO: implement
  }

  AddMoveAndClearGoalToList(Officer: any /* pawn */, Destination: any /* clearpoint */, bAnnounceClear: boolean): void {
      // TODO: implement
  }

  PostMoveAndClearGoalOnOfficer(Officer: any /* pawn */, Destination: any /* clearpoint */, bAnnounceClear: boolean): any /* moveandcleargoal */ {
      // TODO: implement
  }

  CreateClearFormation(): void {
      // TODO: implement
  }

  StopFollowingLeader(): void {
      // TODO: implement
  }

  SetupOfficerRoles(): void {
      // TODO: implement
  }

  SetThrower(): void {
      // TODO: implement
  }

  SetBreacher(): void {
      // TODO: implement
  }

  MoveFirstTwoOfficersThroughDoor(): void {
      // TODO: implement
  }

  MoveUpSecondTwoOfficers(): void {
      // TODO: implement
  }

  StartFollowerMoveAndClear(): void {
      // TODO: implement
  }

  PauseLeadingOfficer(): void {
      // TODO: implement
  }

  ActivateFollowingSensor(): void {
      // TODO: implement
  }

  StopLeadingOfficer(): void {
      // TODO: implement
  }

  PauseFollowingOfficer(): void {
      // TODO: implement
  }

  StopFollowingOfficer(): void {
      // TODO: implement
  }

  MoveFirstTwoOfficersToClearPoints(): void {
      // TODO: implement
  }

  MoveRemainingOfficersThroughDoor(): void {
      // TODO: implement
  }

  WaitForFirstTwoOfficersTimerCompleted(): void {
      // TODO: implement
  }

  WaitForFirstTwoOfficers(): void {
      // TODO: implement
  }

  StartWaitForFirstTwoOfficersTimer(): void {
      // TODO: implement
  }

  ClearFirstTwoOfficersTimer(): void {
      // TODO: implement
  }

  ClearSecondTwoOfficersMoveUpBehavior(): void {
      // TODO: implement
  }

  ActivateDoorSideSensors(): void {
      // TODO: implement
  }

  HandleDoorSideSensorMessage(DoorSideSensor: any /* ai_sensor */): void {
      // TODO: implement
  }

  MoveStackedUpSquad(): void {
      // TODO: implement
  }

  GetClearingRoomName(): string {
      // TODO: implement
  }

  IsOfficerInRoomToClear(Officer: any /* pawn */): boolean {
      // TODO: implement
  }

  ShouldStackUpBeforeClearing(): boolean {
      // TODO: implement
  }

  ShouldStackUpIfOfficersInRoomToClear(): boolean {
      // TODO: implement
  }

  AreAnyOfficersInRoomToClear(): boolean {
      // TODO: implement
  }

  IsFirstOfficerThrower(): boolean {
      // TODO: implement
  }

  TriggerStartedClearingSpeech(Officer: any /* pawn */): void {
      // TODO: implement
  }

  ShouldAnnounceClearThreshold(): boolean {
      // TODO: implement
  }

  TriggerReportedThresholdClearSpeech(Officer: any /* pawn */): void {
      // TODO: implement
  }

  TriggerReportedContinuingClear(Officer: any /* pawn */): void {
      // TODO: implement
  }

}
