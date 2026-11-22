// Auto-generated skeleton from UnrealScript: SwatAICommon/SquadStackUpAction.uc
// Parent: OfficerSquadAction

class SquadStackUpAction extends OfficerSquadAction {

  // Variables
  Officer: any /* pawn */;  //  Pawn
  Weight: number;  //  float
  PointIndex: number;  //  int
  CurrentStackUpGoal: any /* stackupgoal */;  // private StackUpGoal
  StackUpGoals: any /* stackupgoal */[];  //  array<StackUpGoal>
  StackedUpGoals: any /* stackedupgoal */[];  //  array<StackedUpGoal>
  StackUpPoints: any /* stackuppoint */[];  //  array<StackupPoint>
  UnorderedOfficers: any /* pawn */[];  //  array<Pawn>
  OfficersInStackUpOrder: any /* pawn */[];  //  array<Pawn>
  MatchedOfficersToStackupPoints: any /* pawn */[];  //  array<Pawn>
  CurrentPickLockGoal: any /* picklockgoal */;  // private PickLockGoal
  CurrentCloseDoorGoal: any /* closedoorgoal */;  // private CloseDoorGoal

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  ClearOutStackUpGoals(): void {
      // TODO: implement
  }

  ClearOutStackedUpGoals(): void {
      // TODO: implement
  }

  ClearStackupPointClaims(): void {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  GetFirstOfficer(): any /* pawn */ {
      // TODO: implement
  }

  GetSecondOfficer(): any /* pawn */ {
      // TODO: implement
  }

  GetThirdOfficer(): any /* pawn */ {
      // TODO: implement
  }

  GetFourthOfficer(): any /* pawn */ {
      // TODO: implement
  }

  GetStackupPointForOrderedOfficer(OrderedOfficer: any /* pawn */): any /* stackuppoint */ {
      // TODO: implement
  }

  GetStackupPointIndexForOrderedOfficer(OrderedOfficer: any /* pawn */): number {
      // TODO: implement
  }

  PickLock(bMoveToPostPickLockDestination: boolean): void {
      // TODO: implement
  }

  StackUpOfficer(Officer: any /* pawn */, Destination: any /* stackuppoint */): void {
      // TODO: implement
  }

  NotifyPawnDied(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  PopulateUnorderedOfficers(): void {
      // TODO: implement
  }

  GetNumberLivingOfficersInSquad(): number {
      // TODO: implement
  }

  DeflateWeightByCloserUnorderedOfficersTo(Officer: any /* pawn */, OfficerNavDistanceToPoint: number, Point: any /* stackuppoint */): number {
      // TODO: implement
  }

  IsPositionedOnWrongSideOfDoor(Officer: any /* pawn */, Destination: any /* stackuppoint */): boolean {
      // TODO: implement
  }

  DetermineOfficerStackupPoints(): void {
      // TODO: implement
  }

  GetStackupWeightForOfficer(Officer: any /* pawn */, Point: any /* stackuppoint */): number {
      // TODO: implement
  }

  GetUnorderedOfficerIndex(Officer: any /* pawn */): number {
      // TODO: implement
  }

  IsOfficerOrdered(Officer: any /* pawn */): boolean {
      // TODO: implement
  }

  ShouldFirstOfficerBeStackedUp(): boolean {
      // TODO: implement
  }

  SetOrderedStackUpPointForOfficer(Officer: any /* pawn */, OfficerDestination: any /* stackuppoint */): void {
      // TODO: implement
  }

  PostStackUpGoalOnOfficer(Officer: any /* pawn */, OfficerDestination: any /* stackuppoint */, bRunToPoint: boolean): void {
      // TODO: implement
  }

  PopulateStackUpPoints(): void {
      // TODO: implement
  }

  IsOfficerAtSideOpenPoint(Officer: any /* pawn */): boolean {
      // TODO: implement
  }

  TestForAlreadyStackedUpOfficers(): void {
      // TODO: implement
  }

  AreOfficersAlreadyStackedUp(): boolean {
      // TODO: implement
  }

  CanInteractWithTargetDoor(): boolean {
      // TODO: implement
  }

  IsDoorOpenTowardsStackupSide(): boolean {
      // TODO: implement
  }

  NeedsToStackUp(): boolean {
      // TODO: implement
  }

  TriggerOrderedToStackUpReplySpeech(): void {
      // TODO: implement
  }

  StackUpSquad(bTriggerGenericOrderReply: boolean): void {
      // TODO: implement
  }

  ShouldRunToStackupPoint(): boolean {
      // TODO: implement
  }

  InternalStackUpSquad(): void {
      // TODO: implement
  }

  PostStackedUpGoal(Officer: any /* pawn */, inStackupPoint: any /* stackuppoint */): void {
      // TODO: implement
  }

  SwapStackUpPositions(OfficerOne: any /* pawn */, OfficerTwo: any /* pawn */): void {
      // TODO: implement
  }

  RemoveStackedUpGoalOnOfficer(Officer: any /* pawn */): void {
      // TODO: implement
  }

  TriggerCompletedSpeech(): void {
      // TODO: implement
  }

  IsC2ChargeDeployedOnThisSideOfDoor(): boolean {
      // TODO: implement
  }

  GetC2BreachingOfficer(): any /* pawn */ {
      // TODO: implement
  }

  MoveUpC2Breacher(Breacher: any /* pawn */): void {
      // TODO: implement
  }

  MoveUpShotgunBreacher(Breacher: any /* pawn */): void {
      // TODO: implement
  }

  MoveUpBreacher(Breacher: any /* pawn */): void {
      // TODO: implement
  }

  SwapOfficerRoles(OfficerA: any /* pawn */, OfficerB: any /* pawn */): void {
      // TODO: implement
  }

}
