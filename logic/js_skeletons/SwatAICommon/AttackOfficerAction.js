// Auto-generated skeleton from UnrealScript: SwatAICommon/AttackOfficerAction.uc
// Parent: SwatCharacterAction

class AttackOfficerAction extends SwatCharacterAction {

  // Variables
  CurrentMoveToAttackOfficerGoal: any /* movetoattackofficergoal */;  // private MoveToAttackOfficerGoal
  CurrentAttackTargetGoal: any /* attacktargetgoal */;  // private AttackTargetGoal
  MinPassiveAttackOfficerPercentageChance: number;  // private config float
  MaxPassiveAttackOfficerPercentageChance: number;  // private config float
  MinAggressiveAttackOfficerPercentageChance: number;  // private config float
  MaxAggressiveAttackOfficerPercentageChance: number;  // private config float
  LowSkillSuccessAfterFiringChance: number;  // private config float
  MediumSkillSuccessAfterFiringChance: number;  // private config float
  HighSkillSuccessAfterFiringChance: number;  // private config float

  constructor() {
    super();
  }

  // Methods
  GetOfficerTarget(): any /* pawn */ {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  GetSkillSpecificSuccessAfterFiringChance(): number {
      // TODO: implement
  }

  MoveToAttackEnemy(): void {
      // TODO: implement
  }

  AttackEnemyWithWeapon(): void {
      // TODO: implement
  }

  FinishUpMoveToAttackBehavior(): void {
      // TODO: implement
  }

}
