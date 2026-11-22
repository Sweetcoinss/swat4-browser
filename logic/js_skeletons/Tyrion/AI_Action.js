// Auto-generated skeleton from UnrealScript: Tyrion/AI_Action.uc
// Parent: AI_RunnableAction

class AI_Action extends AI_RunnableAction {

  // Variables
  satisfiesGoal: any /* class */;  // const editconst Class<AI_Goal>
  achievingGoal: any /* ai_goal */;  //  AI_Goal
  childGoals: any /* ai_goal */[];  //  array<AI_Goal>
  heuristicValue: number;  //  float
  resourceUsage: number;  //  int
  waitingForGoalsN: number;  //  int

  constructor() {
    super();
  }

  // Methods
  succeed(): void {
      // TODO: implement
  }

  instantSucceed(): void {
      // TODO: implement
  }

  instantFail(errorCode: any /* actionbase.act_errorcodes */, bRemoveGoal: boolean): void {
      // TODO: implement
  }

  fail(errorCode: any /* actionbase.act_errorcodes */, bRemoveGoal: boolean): void {
      // TODO: implement
  }

  waitForGoal(Goal: any /* ai_goal */, bTryOnlyOnce: boolean): void {
      // TODO: implement
  }

  interruptGoalIf(Goal: any /* ai_goal */, condition: any /* class */): void {
      // TODO: implement
  }

  waitForAllGoals(goal1: any /* ai_goal */, goal2: any /* ai_goal */, goal3: any /* ai_goal */, goal4: any /* ai_goal */, goal5: any /* ai_goal */, goal6: any /* ai_goal */, goal7: any /* ai_goal */, goal8: any /* ai_goal */, goal9: any /* ai_goal */): void {
      // TODO: implement
  }

  waitForAllGoalsInList(goals: any /* ai_goal */[]): void {
      // TODO: implement
  }

  waitForAnyGoal(goal1: any /* ai_goal */, goal2: any /* ai_goal */, goal3: any /* ai_goal */, goal4: any /* ai_goal */, goal5: any /* ai_goal */, goal6: any /* ai_goal */, goal7: any /* ai_goal */): void {
      // TODO: implement
  }

  waitForAllGoalsConsidered(goal1: any /* ai_goal */, goal2: any /* ai_goal */, goal3: any /* ai_goal */, goal4: any /* ai_goal */, goal5: any /* ai_goal */, goal6: any /* ai_goal */, goal7: any /* ai_goal */): void {
      // TODO: implement
  }

  waitForResourcesAvailable(legsPriority: number, armsPriority: number, headPriority: number): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  getResource(): any /* ai_resource */ {
      // TODO: implement
  }

  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  myAddRef(): any /* ai_action */ {
      // TODO: implement
  }

  interruptAction(): void {
      // TODO: implement
  }

  removeAction(): void {
      // TODO: implement
  }

  runAction(): void {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  isChildGoal(Goal: any /* ai_goal */): boolean {
      // TODO: implement
  }

  goalAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  resourceStolenCB(Goal: any /* ai_goal */, stolenResource: any /* ai_resource */): void {
      // TODO: implement
  }

}
