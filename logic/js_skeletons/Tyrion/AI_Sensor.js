// Auto-generated skeleton from UnrealScript: Tyrion/AI_Sensor.uc
// Parent: DeleteableObject

class AI_Sensor extends DeleteableObject {

  // Variables
  sensorAction: any /* ai_sensoraction */;  //  AI_SensorAction
  recipients: any /* ai_sensorrecipient */[];  //  array<AI_SensorRecipient>
  Value: any /* ai_sensordata */;  //  AI_SensorData
  bNotifyOnValueChange: boolean;  //  bool
  bNotifyIfResourceInactive: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  getResource(): any /* ai_resource */ {
      // TODO: implement
  }

  Construct(Action: any /* ai_sensoraction */): void {
      // TODO: implement
  }

  activateSensor(Recipient: any /* isensornotification */, sensorClass: any /* class */, resource: any /* ai_resource */, lowerBound: number, upperBound: number, userData: any /* object */): any /* ai_sensor */ {
      // TODO: implement
  }

  activateSentinel(Goal: any /* ai_goal */, sentinelClass: any /* class */, resource: any /* ai_resource */, lowerBound: number, upperBound: number, userData: any /* object */): any /* ai_sensor */ {
      // TODO: implement
  }

  deactivateSensor(Recipient: any /* isensornotification */, lowerBound: number, upperBound: number): void {
      // TODO: implement
  }

  deactivateSentinel(Goal: any /* ai_goal */, lowerBound: number, upperBound: number): void {
      // TODO: implement
  }

  Begin(): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  sendSensorMessage(Recipient: any /* ai_sensorrecipient */, Value: any /* ai_sensordata */): void {
      // TODO: implement
  }

  sendMessageOnNextValueUpdate(Recipient: any /* isensornotification */): void {
      // TODO: implement
  }

  setIntegerValue(NewValue: number): void {
      // TODO: implement
  }

  setFloatValue(NewValue: number): void {
      // TODO: implement
  }

  setCategoricalValue(NewValue: number): void {
      // TODO: implement
  }

  setObjectValue(NewValue: any /* object */): void {
      // TODO: implement
  }

  bSendMessage(Object: any /* object */): boolean {
      // TODO: implement
  }

  QueryValue(): any /* ai_sensordata */ {
      // TODO: implement
  }

  queryIntegerValue(): number {
      // TODO: implement
  }

  queryFloatValue(): number {
      // TODO: implement
  }

  queryObjectValue(): any /* object */ {
      // TODO: implement
  }

  ClearValue(): void {
      // TODO: implement
  }

  queryUsage(): number {
      // TODO: implement
  }

  activateSensorInternal(sensorClass: any /* class */, R: any /* ai_resource */, lowerBound: number, upperBound: number, userData: any /* object */, Recipient: any /* isensornotification */): any /* ai_sensor */ {
      // TODO: implement
  }

  deactivateSensorInternal(Recipient: any /* isensornotification */, lowerBound: number, upperBound: number): void {
      // TODO: implement
  }

}
