// Auto-generated skeleton from UnrealScript: SwatAICommon/VisionSensor.uc
// Parent: AI_Sensor

class VisionSensor extends AI_Sensor {

  // Variables
  pawns: any /* pawn */[];  //  array<Pawn>
  LastPawnSeen: any /* pawn */;  //  Pawn
  LastTimeSeen: number;  //  float
  LastPawnLost: any /* pawn */;  //  Pawn
  LastLostPawnLocation: THREE.Vector3;  //  Vector
  LastTimeLost: number;  //  float

  constructor() {
    super();
  }

  // Methods
  OnViewerSawPawn(Viewer: any /* pawn */, Seen: any /* pawn */): void {
      // TODO: implement
  }

  OnViewerLostPawn(Viewer: any /* pawn */, Lost: any /* pawn */): void {
      // TODO: implement
  }

  Begin(): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  IsCurrentlySeen(TestPawn: any /* pawn */): boolean {
      // TODO: implement
  }

  GetVisibleConsciousPawnClosestTo(testLocation: THREE.Vector3, PawnClassType: string): any /* pawn */ {
      // TODO: implement
  }

}
