// Auto-generated skeleton from UnrealScript: SwatAICommon/StackupPoint.uc
// Parent: BaseDoorPoint

class StackupPoint extends BaseDoorPoint {

  // Variables
  OfficerClaimer: any /* pawn */;  // private Pawn
  CanThrowFromPoint: boolean;  //  bool
  ThrowSide: any /* iswatai.aithrowside */;  //  ISwatAI.AIThrowSide
  AlternatePriority: number;  // private int
  StackupPathToDoor: THREE.Vector3[];  //  array<Vector>
  BlockedOpenLeft: any /* actor */;  // private Actor
  BlockedOpenRight: any /* actor */;  // private Actor

  constructor() {
    super();
  }

  // Methods
  IsClaimedByOfficer(): boolean {
      // TODO: implement
  }

  SetClaimedByOfficer(Officer: any /* pawn */): void {
      // TODO: implement
  }

  ClearClaims(): void {
      // TODO: implement
  }

}
