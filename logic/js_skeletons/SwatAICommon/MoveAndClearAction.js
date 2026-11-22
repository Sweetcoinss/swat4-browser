// Auto-generated skeleton from UnrealScript: SwatAICommon/MoveAndClearAction.uc
// Parent: SwatCharacterAction

class MoveAndClearAction extends SwatCharacterAction {

  // Variables
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  CurrentRotateTowardActorGoal: any /* rotatetowardactorgoal */;  // private RotateTowardActorGoal
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  CurrentAimAroundGoal: any /* aimaroundgoal */;  // private AimAroundGoal
  ClearRoute: any /* navigationpoint */[];  //  array<NavigationPoint>
  CurrentClearRouteIndex: number;  // private int
  bPauseMovement: boolean;  // private bool
  EndHoldClearPositionTime: number;  // private float
  DistanceToStopMovingWithUncompliantCharacter: number;  // config float
  MoveAndClearMinAimHoldTime: number;  // config float
  MoveAndClearMaxAimHoldTime: number;  // config float
  MoveAndClearAimAroundInnerRadius: number;  // config float
  MoveAndClearAimAroundOuterRadius: number;  // config float
  MoveAndClearAimAroundPointTooCloseDistance: number;  // config float
  MinHoldClearPositionTime: number;  // config float
  MaxHoldClearPositionTime: number;  // config float
  DistanceToUncomplaintCharactersSensor: any /* distancetouncomplaintcharacterssensor */;  // private DistanceToUncomplaintCharactersSensor

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  resourceStolenCB(Goal: any /* ai_goal */, stolenResource: any /* ai_resource */): void {
      // TODO: implement
  }

  SetupDistanceToUncomplaintCharactersSensor(): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  PauseMovement(PausingCharacter: any /* pawn */): void {
      // TODO: implement
  }

  UnPauseMovement(): void {
      // TODO: implement
  }

  RemoveRotateToFacePausingCharacterGoal(): void {
      // TODO: implement
  }

  RotateToFacePausingCharacter(PausingCharacter: any /* pawn */): void {
      // TODO: implement
  }

  AimAround(): void {
      // TODO: implement
  }

  RotateToClearPointRotation(): void {
      // TODO: implement
  }

  BuildClearRoute(): void {
      // TODO: implement
  }

  MoveToClearRoutePoint(ClearRoutePoint: any /* navigationpoint */): void {
      // TODO: implement
  }

  MoveToNextClearRoutePoint(): void {
      // TODO: implement
  }

  MoveToClearRoutePoints(): void {
      // TODO: implement
  }

  IsClearPointOnSameSideAsCommandOrigin(): boolean {
      // TODO: implement
  }

  HasCurrentAssignment(): boolean {
      // TODO: implement
  }

  ShouldAnnounceClear(): boolean {
      // TODO: implement
  }

  IsRotatedToClearPointRotation(): boolean {
      // TODO: implement
  }

}
