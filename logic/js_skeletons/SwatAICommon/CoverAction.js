// Auto-generated skeleton from UnrealScript: SwatAICommon/CoverAction.uc
// Parent: SwatCharacterAction

class CoverAction extends SwatCharacterAction {

  // Variables
  CurrentMoveToLocationGoal: any /* movetolocationgoal */;  // private MoveToLocationGoal
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  CurrentAimAroundGoal: any /* aimaroundgoal */;  // private AimAroundGoal
  StartCanHitCoverLocationTime: number;  // private float
  TimeToAnnounceStillCovering: number;  // private float
  LastCoverFromLocation: THREE.Vector3;  // private Vector
  InnerAimAroundFOVDegrees: number;  // config float
  OuterAimAroundFOVDegrees: number;  // config float
  MinDeltaWaitTimeToAnnounceStillCovering: number;  // config float
  MaxDeltaWaitTimeToAnnounceStillCovering: number;  // config float

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  MoveToCoverFromLocation(): void {
      // TODO: implement
  }

  RotateToFaceCoverLocation(): void {
      // TODO: implement
  }

  CanAimAtCoverLocation(): boolean {
      // TODO: implement
  }

  MovingCanAimAtCoverLocation(): boolean {
      // TODO: implement
  }

  AimAroundAtCoverLocation(): void {
      // TODO: implement
  }

  SetTimeToAnnounceStillCovering(): void {
      // TODO: implement
  }

  HasMovedFarAwayFromCoverFromLocation(): boolean {
      // TODO: implement
  }

}
