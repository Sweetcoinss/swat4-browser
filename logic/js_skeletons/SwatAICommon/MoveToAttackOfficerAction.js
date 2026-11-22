// Auto-generated skeleton from UnrealScript: SwatAICommon/MoveToAttackOfficerAction.uc
// Parent: MoveToOpponentAction

class MoveToAttackOfficerAction extends MoveToOpponentAction {

  // Variables
  StartMovingLocation: THREE.Vector3;  // private Vector
  DistanceToTravel: number;  // private float
  bFinishUp: boolean;  // private bool
  MinDistanceToTravel: number;  // config float
  MaxDistanceToTravel: number;  // config float
  CrouchWhileAttackingChance: number;  // config float
  MinDistanceToCrouch: number;  // config float
  MinTimeToCrouch: number;  // config float
  MaxTimeToCrouch: number;  // config float
  MinTimeToStand: number;  // config float
  MaxTimeToStand: number;  // config float

  constructor() {
    super();
  }

  // Methods
  ShouldStopMovingToOfficer(MovingPawn: any /* pawn */): boolean {
      // TODO: implement
  }

  ShouldCrouchWhileAttacking(): boolean {
      // TODO: implement
  }

  CrouchWhileAttacking(): void {
      // TODO: implement
  }

  StandUp(): void {
      // TODO: implement
  }

  FinishUp(): void {
      // TODO: implement
  }

}
