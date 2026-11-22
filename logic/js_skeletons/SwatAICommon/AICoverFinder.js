// Auto-generated skeleton from UnrealScript: SwatAICommon/AICoverFinder.uc
// Parent: Object

class AICoverFinder extends Object {

  // Variables
  coverLocationInfo: any /* aicoverfinder.eaicoverlocationinfo */;  //  AICoverFinder.EAICoverLocationInfo
  coverActor: any /* actor */;  //  Actor
  coverLocation: THREE.Vector3;  //  Vector
  coverSide: any /* aicoverfinder.eaicoverlocationside */;  //  AICoverFinder.EAICoverLocationSide
  coverYaw: number;  //  int
  m_pawn: any /* pawn */;  // private Pawn

  constructor() {
    super();
  }

  // Methods
  IsCoverAvailable(): boolean {
      // no body (native/abstract)
  }

  FindCover(otherPawns: any /* pawn */[], locationType: any /* aicoverfinder.eaicoverlocationtype */): any /* aicoverresult */ {
      // no body (native/abstract)
  }

  FindCoverBehindActor(otherPawns: any /* pawn */[], coverActor: any /* actor */, locationType: any /* aicoverfinder.eaicoverlocationtype */): any /* aicoverresult */ {
      // no body (native/abstract)
  }

  IsLocationInCover(otherPawns: any /* pawn */[], Location: THREE.Vector3): any /* aicoverresult */ {
      // no body (native/abstract)
  }

  IsLocationInCoverBehindActor(otherPawns: any /* pawn */[], coverActor: any /* actor */, Location: THREE.Vector3): any /* aicoverresult */ {
      // no body (native/abstract)
  }

  Construct(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  GetOuterPawn(): any /* pawn */ {
      // TODO: implement
  }

}
