// Auto-generated skeleton from UnrealScript: SwatAICommon/OrderComplianceAction.uc
// Parent: SwatWeaponAction

class OrderComplianceAction extends SwatWeaponAction {

  // Variables
  CompliantSensor: any /* compliantsensor */;  //  CompliantSensor
  TimeToStopTryingToEngage: number;  // private float
  MaximumTimeToWaitToEngage: number;  // config float
  MinComplianceOrderSleepTime: number;  // config float
  MaxComplianceOrderSleepTime: number;  // config float
  MinComplianceWaitTime: number;  // config float
  MaxComplianceWaitTime: number;  // config float
  ComplyMGOrderAnims: string[];  // config array<name>
  ComplySGOrderAnims: string[];  // config array<name>
  ComplySMGOrderAnims: string[];  // config array<name>
  ComplyHGOrderAnims: string[];  // config array<name>
  ComplyPepperBallOrderAnims: string[];  // config array<name>

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  ActivateComplianceSensor(): void {
      // TODO: implement
  }

  SetOrderComplianceAim(): void {
      // TODO: implement
  }

  UnsetOrderComplianceAim(): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  GetComplyOrderAnimName(): string {
      // TODO: implement
  }

  OrderToComply(): void {
      // TODO: implement
  }

  SetTimeToStopTryingToEngage(): void {
      // TODO: implement
  }

}
