// Auto-generated skeleton from UnrealScript: SwatAICommon/AIKnowledge.uc
// Parent: Object

class AIKnowledge extends Object {

  // Variables
  Location: THREE.Vector3;  //  Vector
  bHasEverSeenPawn: boolean;  //  bool
  m_knowledgeMap: number;  // private int
  m_thisPawn: any /* pawn */;  // private Pawn
  m_visionNotifier: any /* visionnotifier */;  // private VisionNotifier

  constructor() {
    super();
  }

  // Methods
  Init(thisPawn: any /* pawn */, VisionNotifier: any /* visionnotifier */): void {
      // TODO: implement
  }

  Term(): void {
      // TODO: implement
  }

  GetLastKnownKnowledgeAboutPawn(otherPawn: any /* pawn */, outKnowledge: any /* knowledgeaboutpawn */): boolean {
      // no body (native/abstract)
  }

  HasKnownKnowledgeAboutPawn(otherPawn: any /* pawn */): boolean {
      // no body (native/abstract)
  }

  UpdateKnowledgeAboutPawn(otherPawn: any /* pawn */): void {
      // no body (native/abstract)
  }

  OnViewerSawPawn(Viewer: any /* pawn */, Seen: any /* pawn */): void {
      // no body (native/abstract)
  }

  OnViewerLostPawn(Viewer: any /* pawn */, Seen: any /* pawn */): void {
      // no body (native/abstract)
  }

}
