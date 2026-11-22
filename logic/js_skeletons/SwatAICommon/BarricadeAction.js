// Auto-generated skeleton from UnrealScript: SwatAICommon/BarricadeAction.uc
// Parent: SuspiciousAction

class BarricadeAction extends SuspiciousAction {

  // Variables
  CurrentAimAroundGoal: any /* aimaroundgoal */;  // private AimAroundGoal
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  CurrentCloseDoorGoal: any /* closedoorgoal */;  // private CloseDoorGoal
  CurrentMoveToDoorGoal: any /* movetodoorgoal */;  // private MoveToDoorGoal
  AttackDoorGoal: any /* attacktargetgoal */;  // private AttackTargetGoal
  CurrentAimAtTargetGoal: any /* aimattargetgoal */;  // private AimAtTargetGoal
  DoorsInRoom: any /* door */[];  //  array<Door>
  ClosableDoorsInRoom: any /* door */[];  //  array<Door>
  BarricadePoint: any /* navigationpoint */;  // private NavigationPoint
  DoorOpening: any /* door */;  // private Door
  DoorOpeningSensor: any /* dooropeningsensor */;  // private DoorOpeningSensor
  ShootAtDoorsChance: number;  // config float
  MinShootingAtDoorsTime: number;  // config float
  MaxShootingAtDoorsTime: number;  // config float
  CloseAndLockInitialDoorChance: number;  // config float
  CloseAndLockSubsequentDoorChance: number;  // config float
  MinBarricadeDelayTime: number;  // config float
  MaxBarricadeDelayTime: number;  // config float
  ReactionSpeechChance: number;  // config float
  CrouchAtFleePointChance: number;  // config float
  AimAtClosestDoorTime: number;  // config float

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  FindBarricadePoint(): void {
      // TODO: implement
  }

  MoveToBarricadePoint(): void {
      // TODO: implement
  }

  ShouldCrouchAtFleePoint(): boolean {
      // TODO: implement
  }

  AimAround(): void {
      // TODO: implement
  }

  PopulateDoorsInRoom(): void {
      // TODO: implement
  }

  DoesRoomHaveDoorsToCloseAndLock(): boolean {
      // TODO: implement
  }

  GetClosestDoorToStimuliOrigin(): any /* door */ {
      // TODO: implement
  }

  GetClosestClosableDoorToStimuliOrigin(): any /* door */ {
      // TODO: implement
  }

  RemoveDoorFromCloseAndLockList(DoorToRemove: any /* door */): void {
      // TODO: implement
  }

  AimAtClosestDoor(): void {
      // TODO: implement
  }

  CloseDoor(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  LockDoor(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  CloseAndLockDoorsInRoom(): void {
      // TODO: implement
  }

  CreateDoorOpeningSensor(): void {
      // TODO: implement
  }

  RemoveAimAroundGoal(): void {
      // TODO: implement
  }

  ShootAtOpeningDoor(): void {
      // TODO: implement
  }

  AimAtOpeningDoor(): void {
      // TODO: implement
  }

}
