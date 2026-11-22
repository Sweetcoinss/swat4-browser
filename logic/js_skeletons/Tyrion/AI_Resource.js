// Auto-generated skeleton from UnrealScript: Tyrion/AI_Resource.uc
// Parent: Tyrion_ResourceBase

class AI_Resource extends Tyrion_ResourceBase {

  // Variables
  idleActions: any /* ai_runnableaction */[];  //  array<AI_RunnableAction>
  runningActions: any /* ai_runnableaction */[];  //  array<AI_RunnableAction>
  removedActions: any /* ai_runnableaction */[];  //  array<AI_RunnableAction>
  usedByAction: any /* ai_action */;  //  AI_Action
  sensors: any /* ai_sensor */[];  //  array<AI_Sensor>
  sensorActions: any /* ai_sensoraction */[];  //  array<AI_SensorAction>

  constructor() {
    super();
  }

  // Methods
  Init(): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  deleteSensors(): void {
      // TODO: implement
  }

  deleteRemovedActions(): void {
      // no body (native/abstract)
  }

  myAddRef(): any /* ai_resource */ {
      // TODO: implement
  }

  PushRunnableAction(Pushed: any /* ai_runnableaction */): void {
      // TODO: implement
  }

  PawnDied(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  chooseAction(Goal: any /* ai_goal */): any /* ai_action */ {
      // no body (native/abstract)
  }

  ShallowCopyAction(otherAction: any /* ai_action */): any /* ai_action */ {
      // TODO: implement
  }

  resourceCheck(Goal: any /* ai_goal */, bestAction: any /* ai_action */): void {
      // TODO: implement
  }

  addSensorActionClass(sensorActionClass: any /* class */): any /* ai_sensoraction */ {
      // TODO: implement
  }

  multipleActionsCheck(Action: any /* ai_action */): boolean {
      // TODO: implement
  }

  doesParentHaveResource(parentAction: any /* ai_action */): boolean {
      // TODO: implement
  }

  getActionClass(): any /* class */ {
      // TODO: implement
  }

  setActionParameters(Goal: any /* ai_goal */, Action: any /* ai_action */): boolean {
      // TODO: implement
  }

  Pawn(): any /* pawn */ {
      // TODO: implement
  }

  findGoalByName(gName: string): any /* ai_goal */ {
      // no body (native/abstract)
  }

  setActionParametersInternal(Goal: any /* object */, Action: any /* object */): boolean {
      // no body (native/abstract)
  }

  addGoal(Parent: any /* ai_action */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  removeGoal(Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  resetGoals(): void {
      // TODO: implement
  }

  displayTyrionDebug(): void {
      // TODO: implement
  }

}
