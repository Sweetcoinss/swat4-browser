// Auto-generated skeleton from UnrealScript: SwatAICommon/PickLockAction.uc
// Parent: SwatCharacterAction

class PickLockAction extends SwatCharacterAction {

  // Variables
  CurrentRotateTowardPointGoal: any /* rotatetowardpointgoal */;  // private RotateTowardPointGoal
  CurrentRotateTowardRotationGoal: any /* rotatetowardrotationgoal */;  // private RotateTowardRotationGoal
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  CurrentMoveToLocationGoal: any /* movetolocationgoal */;  // private MoveToLocationGoal
  Toolkit: any /* handheldequipment */;  // private HandheldEquipment
  bDoorHasOpened: boolean;  // private bool
  bMovedToPickLock: boolean;  // private bool

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  NotifyDoorOpening(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  SetPickLockAim(): void {
      // TODO: implement
  }

  UnsetPickLockAim(): void {
      // TODO: implement
  }

  GetPickLockPoint(): THREE.Vector3 {
      // TODO: implement
  }

  MoveToPickLockPoint(): void {
      // TODO: implement
  }

  GetLockPickPoint(): THREE.Vector3 {
      // TODO: implement
  }

  RotateToLockPickPoint(): void {
      // TODO: implement
  }

  EquipToolkit(): void {
      // TODO: implement
  }

  PickLock(): void {
      // TODO: implement
  }

  MoveToPostPickLockLocation(): void {
      // TODO: implement
  }

  RotateToPostPickLockRotation(): void {
      // TODO: implement
  }

}
