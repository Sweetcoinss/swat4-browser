// Auto-generated skeleton from UnrealScript: Engine/LiftCenter.uc
// Parent: NavigationPoint

class LiftCenter extends NavigationPoint {

  // Variables
  LiftTag: string;  //  name
  MyLift: any /* mover */;  //  Mover
  LiftTrigger: string;  //  name
  RecommendedTrigger: any /* trigger */;  //  Trigger
  MaxDist2D: number;  //  float
  LiftOffset: THREE.Vector3;  //  Vector

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  SpecialHandling(Other: any /* pawn */): any /* actor */ {
      // TODO: implement
  }

  SuggestMovePreparation(Other: any /* pawn */): boolean {
      // TODO: implement
  }

  ProceedWithMove(Other: any /* pawn */): boolean {
      // TODO: implement
  }

}
