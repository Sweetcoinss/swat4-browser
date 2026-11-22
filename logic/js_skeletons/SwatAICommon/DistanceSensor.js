// Auto-generated skeleton from UnrealScript: SwatAICommon/DistanceSensor.uc
// Parent: AI_Sensor

class DistanceSensor extends AI_Sensor {

  // Variables
  TargetActor: any /* actor */;  //  Actor
  TargetLocation: THREE.Vector3;  //  Vector
  RequiredDistance: number;  //  float
  bWithinRequiredDistance: boolean;  //  bool
  bInitialTest: boolean;  //  bool
  bUseNavigationDistance: boolean;  //  bool
  bIgnoreHeightDistance: boolean;  //  bool
  CollisionHeightMultiplier: number;  //  float
  DistanceSensorUpdateRate: number;  //  float
  __UpdateTarget__Delegate: any /* delegate<updatetarget> */;  //  delegate<UpdateTarget>

  constructor() {
    super();
  }

  // Methods
  NotifyWithinRequiredDistance(): void {
      // TODO: implement
  }

  NotifyOutsideRequiredDistance(): void {
      // TODO: implement
  }

  SetWithinSensorValue(): void {
      // TODO: implement
  }

  SetOutsideSensorValue(): void {
      // TODO: implement
  }

  ResetRequiredDistance(inNewRequiredDistance: number): void {
      // TODO: implement
  }

  ResetTargetActor(inNewTargetActor: any /* actor */): void {
      // TODO: implement
  }

  GetTargetOrigin(): THREE.Vector3 {
      // TODO: implement
  }

  IsWithinRequiredDistance(): boolean {
      // TODO: implement
  }

  SetRequiredDistance(inRequiredDistance: number): void {
      // TODO: implement
  }

  SetUseNavigationDistance(inUseNavigationDistance: boolean): void {
      // TODO: implement
  }

  SetIgnoreHeightDistance(inIgnoreHeightDistance: boolean): void {
      // TODO: implement
  }

  SetCollisionHeightMultiplier(NewCollisionHeightMultiplier: number): void {
      // TODO: implement
  }

  setParameters(): void {
      // TODO: implement
  }

  setParameters(inRequiredDistance: number, inTargetActor: any /* actor */, inUseNavigationDistance: boolean): void {
      // TODO: implement
  }

  setParameters(inRequiredDistance: number, inTargetLocation: THREE.Vector3, inUseNavigationDistance: boolean): void {
      // TODO: implement
  }

  PostSetParameters(): void {
      // TODO: implement
  }

}
