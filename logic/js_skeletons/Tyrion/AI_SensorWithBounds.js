// Auto-generated skeleton from UnrealScript: Tyrion/AI_SensorWithBounds.uc
// Parent: DeleteableObject

class AI_SensorWithBounds extends DeleteableObject {

  // Variables
  sensor: any /* ai_sensor */;  //  AI_Sensor
  lowerBound: number;  //  float
  upperBound: number;  //  float

  constructor() {
    super();
  }

  // Methods
  activateSensor(Recipient: any /* isensornotification */, sensorClass: any /* class */, resource: any /* ai_resource */, lowerBound: number, upperBound: number, userData: any /* object */): void {
      // TODO: implement
  }

  activateSentinel(Goal: any /* ai_goal */, sentinelClass: any /* class */, resource: any /* ai_resource */, lowerBound: number, upperBound: number, userData: any /* object */): void {
      // TODO: implement
  }

  deactivateSensor(Recipient: any /* isensornotification */): void {
      // TODO: implement
  }

  deactivateSentinel(Goal: any /* ai_goal */): void {
      // TODO: implement
  }

}
