// Auto-generated skeleton from UnrealScript: SwatAICommon/MoveToActionBase.uc
// Parent: SwatMovementAction

class MoveToActionBase extends SwatMovementAction {

  // Variables
  bHasRotatedTowardFirstPoint: boolean;  // private bool
  bWasAvoidingCollision: boolean;  // private bool
  bIsMoving: boolean;  // private bool
  MovementTimeOut: number;  // private float
  OriginalMoveToThreshold: number;  // private float
  OverriddenMoveToThreshold: number;  // private float
  CurrentOpenDoorGoal: any /* opendoorgoal */;  // private OpenDoorGoal
  CurrentCloseDoorGoal: any /* closedoorgoal */;  // private CloseDoorGoal
  DistanceSensor: any /* distancesensor */;  //  DistanceSensor

  constructor() {
    super();
  }

  // Methods
  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  GetDestination(): THREE.Vector3 {
      // TODO: implement
  }

  ShouldStopMoving(): boolean {
      // TODO: implement
  }

  IsInPosition(): boolean {
      // TODO: implement
  }

  ShouldWalk(): boolean {
      // TODO: implement
  }

  ActivateDistanceSensor(): void {
      // TODO: implement
  }

  SetDistanceSensorParameters(): void {
      // TODO: implement
  }

  ShouldUseNavigationDistanceOnSensor(): boolean {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  HandleDistanceSensorMessage(Value: any /* ai_sensordata */): void {
      // TODO: implement
  }

  SetMovement(bWalkWhileMoving: boolean, bCrouchWhileMoving: boolean): void {
      // TODO: implement
  }

  MoveTowardActor(Actor: any /* actor */, viewFocus: any /* actor */, DestinationOffset: number, bUseStrafing: boolean): void {
      // no body (native/abstract)
  }

  MoveTowardLocation(Location: THREE.Vector3, viewFocus: any /* actor */): void {
      // no body (native/abstract)
  }

  FindPathToActor(Actor: any /* actor */, bAcceptNearbyPath: boolean): any /* actor */ {
      // no body (native/abstract)
  }

  FindPathToLocation(Location: THREE.Vector3, bAcceptNearbyPath: boolean): any /* actor */ {
      // no body (native/abstract)
  }

  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  SetOverriddenMoveToThreshold(): void {
      // TODO: implement
  }

  ResetOverriddenMoveToThreshold(): void {
      // TODO: implement
  }

  RotateTowardsMovementActor(): void {
      // TODO: implement
  }

  RotateTowardsMovementActor(MovementActor: any /* actor */): void {
      // TODO: implement
  }

  RotateTowardsMovementPoint(): void {
      // TODO: implement
  }

  RotateTowardsMovementPoint(MovementPoint: THREE.Vector3): void {
      // TODO: implement
  }

  ShouldRotateTowardsPointsDuringMovement(): boolean {
      // TODO: implement
  }

  HasReachedNearbyPath(ReachedActor: any /* actor */): boolean {
      // TODO: implement
  }

  ReportMoveToOutcome(succeeded: boolean): void {
      // TODO: implement
  }

  PostOpenDoorGoal(Target: any /* door */): void {
      // TODO: implement
  }

  ShouldCloseDoor(Destination: any /* actor */): boolean {
      // TODO: implement
  }

  PostCloseDoorGoal(Target: any /* door */, bCloseFromLeft: boolean): void {
      // TODO: implement
  }

  NavigateThroughDoor(Target: any /* door */): void {
      // TODO: implement
  }

}
