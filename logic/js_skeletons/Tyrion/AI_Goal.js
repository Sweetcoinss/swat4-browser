// Auto-generated skeleton from UnrealScript: Tyrion/AI_Goal.uc
// Parent: Tyrion_GoalBase

class AI_Goal extends Tyrion_GoalBase {

  // Variables
  activationSentinel: any /* ai_sensorwithbounds */;  //  AI_SensorWithBounds
  deactivationSentinel: any /* ai_sensorwithbounds */;  //  AI_SensorWithBounds
  achievingAction: any /* ai_action */;  //  AI_Action
  parentAction: any /* ai_action */;  //  AI_Action
  bInactive: boolean;  //  bool
  bPermanent: boolean;  //  bool
  bDeleted: boolean;  //  bool
  bGoalConsidered: boolean;  //  bool
  bWakeUpPoster: boolean;  //  bool
  bTerminateIfStolen: boolean;  //  bool
  bGoalFailed: boolean;  //  bool
  bGoalAchieved: boolean;  //  bool
  ignoreCounter: number;  //  int
  matchedN: number;  //  int
  resource: any /* ai_resource */;  //  AI_Resource

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

  Construct(): void {
      // TODO: implement
  }

  Construct(R: any /* ai_resource */): void {
      // TODO: implement
  }

  Init(R: any /* ai_resource */): void {
      // TODO: implement
  }

  myAddRef(): any /* ai_goal */ {
      // TODO: implement
  }

  priorityFn(): number {
      // TODO: implement
  }

  postGoal(Parent: any /* ai_action */): any /* ai_goal */ {
      // TODO: implement
  }

  unPostGoal(Parent: any /* ai_action */): void {
      // TODO: implement
  }

  copyParametersFrom(otherGoal: any /* ai_goal */): boolean {
      // no body (native/abstract)
  }

  changePriority(newPriority: number): void {
      // TODO: implement
  }

  hasCompleted(): boolean {
      // TODO: implement
  }

  wasAchieved(): boolean {
      // TODO: implement
  }

  wasNotAchieved(): boolean {
      // TODO: implement
  }

  wasConsidered(): boolean {
      // TODO: implement
  }

  beingAchieved(): boolean {
      // TODO: implement
  }

  markGoalAsAchieved(): void {
      // TODO: implement
  }

  handleGoalSuccess(): void {
      // TODO: implement
  }

  markGoalAsFailed(): void {
      // TODO: implement
  }

  handleGoalFailure(): void {
      // TODO: implement
  }

  DeActivate(): void {
      // TODO: implement
  }

  Activate(): void {
      // TODO: implement
  }

  setUpDeactivationSentinel(): void {
      // TODO: implement
  }

  GetDefaultPriority(): number {
      // TODO: implement
  }

}
