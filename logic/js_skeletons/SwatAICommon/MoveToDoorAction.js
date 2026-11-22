// Auto-generated skeleton from UnrealScript: SwatAICommon/MoveToDoorAction.uc
// Parent: MoveToLocationAction

class MoveToDoorAction extends MoveToLocationAction {

  // Variables
  Destination: THREE.Vector3;  // private Vector
  OpenPoint: THREE.Vector3;  // private Vector
  MoveToDoorThreshold: number;  // config float

  constructor() {
    super();
  }

  // Methods
  SetDistanceSensorParameters(): void {
      // TODO: implement
  }

  SetUsageSide(inDoorUsageSide: any /* iswatai.aidoorusageside */): void {
      // TODO: implement
  }

  GetDoorUsageSide(): any /* iswatai.aidoorusageside */ {
      // TODO: implement
  }

  SetDoorUsageRotation(inDoorUsageRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetDoorUsageRotation(): THREE.Euler {
      // TODO: implement
  }

  ShouldStopMoving(): boolean {
      // TODO: implement
  }

  GetDestination(): THREE.Vector3 {
      // TODO: implement
  }

  IsInPosition(): boolean {
      // TODO: implement
  }

  MoveToDoor(Target: any /* door */, inDestination: THREE.Vector3): void {
      // TODO: implement
  }

  MoveToOpenDoor(Target: any /* door */): void {
      // TODO: implement
  }

  MoveToCloseDoor(Target: any /* door */, bCloseFromLeftSide: boolean, bCloseFromBehind: boolean): void {
      // TODO: implement
  }

  RotateAndLockToDoorUsageRotation(): void {
      // TODO: implement
  }

  ReportMoveToOutcome(succeeded: boolean): void {
      // TODO: implement
  }

}
