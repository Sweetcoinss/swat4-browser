// Auto-generated skeleton from UnrealScript: SwatAICommon/AttackTargetAction.uc
// Parent: SwatWeaponAction

class AttackTargetAction extends SwatWeaponAction {

  // Variables
  TargetSensor: any /* targetsensor */;  // private TargetSensor
  bCanHitTarget: boolean;  // private bool
  TimeToStopTryingToAttack: number;  // private float
  MaximumTimeToWaitToAttack: number;  // config float

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  ActivateTargetSensor(): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  ReadyWeapon(): void {
      // TODO: implement
  }

  SetFireMode(CurrentWeapon: any /* firedweapon */): void {
      // TODO: implement
  }

  ShouldSucceed(): boolean {
      // TODO: implement
  }

  AttackTarget(): void {
      // TODO: implement
  }

  AimAndFireAtTarget(CurrentWeapon: any /* firedweapon */): void {
      // TODO: implement
  }

  AimAtLastSeenPosition(): void {
      // TODO: implement
  }

  IsTargetAThreat(): boolean {
      // TODO: implement
  }

  SetTimeToStopTryingToAttack(): void {
      // TODO: implement
  }

}
