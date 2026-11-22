// Auto-generated skeleton from UnrealScript: SwatGame/SwatHUD.uc
// Parent: HUD

class SwatHUD extends HUD {

  // Variables
  EndA: THREE.Vector3;  //  Vector
  EndB: THREE.Vector3;  //  Vector
  Color: THREE.Color;  //  Color
  LifeSpan: number;  //  float
  Origin: THREE.Vector3;  //  Vector
  direction: THREE.Vector3;  //  Vector
  Length: number;  //  float
  HalfAngle: number;  //  float
  Color: THREE.Color;  //  Color
  LifeSpan: number;  //  float
  CommandPositionX: number;  // config float
  CommandPositionY: number;  // config float
  CommandTextureSizeX: number;  // config int
  CommandTextureSizeY: number;  // config int
  ScaleX: number;  //  float
  ScaleY: number;  //  float
  bShowFocusDebug: boolean;  //  bool
  CommandClearTexture: any /* texture */;  //  Texture
  CommandFallInTexture: any /* texture */;  //  Texture
  CommandStackUpTexture: any /* texture */;  //  Texture
  CommandComplyTexture: any /* texture */;  //  Texture
  bShowVisionCones: boolean;  // private bool
  bShowAIMovementDebugInfo: boolean;  // private bool
  bShowOfficerAIAssignmentsInfo: boolean;  // private bool
  bShowCoverInfo: boolean;  // private bool
  ShowCoverInfoPawn: any /* pawn */;  // private Pawn
  ShowCoverInfoDetail: any /* aicoverfinder.eshowcoverinfodetail */;  // private AICoverFinder.EShowCoverInfoDetail
  bShowAwarenessInfo: boolean;  // private bool
  Awareness: any /* awarenessproxy */;  // private AwarenessProxy
  DebugLines: any /* debugline */[];  //  array<DebugLine>
  DebugCones: any /* debugcone */[];  //  array<DebugCone>
  LastTimeDebugShapesDrawn: number;  // private float

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  RenderToScale(C: any /* canvas */, t: any /* texture */): void {
      // TODO: implement
  }

  PostRender(C: any /* canvas */): void {
      // TODO: implement
  }

  WorldSpaceOverlays(): void {
      // TODO: implement
  }

  ShowVC(): void {
      // TODO: implement
  }

  HideVC(): void {
      // TODO: implement
  }

  DrawVisionCones(): void {
      // TODO: implement
  }

  DebugAIMovement(): void {
      // TODO: implement
  }

  DebugAssignments(): void {
      // TODO: implement
  }

  DrawDebugAIMovement(): void {
      // TODO: implement
  }

  DrawOfficerAIAssignmentsInfo(): void {
      // TODO: implement
  }

  DebugCover(AINameString: string): void {
      // TODO: implement
  }

  DebugCover2(AINameString: string): void {
      // TODO: implement
  }

  DebugCover3(AINameString: string): void {
      // TODO: implement
  }

  DebugCoverInternal(AINameString: string): boolean {
      // TODO: implement
  }

  DrawDebugCover(): void {
      // no body (native/abstract)
  }

  DebugAwareness(AINameString: string): void {
      // TODO: implement
  }

  DebugOfficerAwareness(): void {
      // TODO: implement
  }

  DrawDebugAwareness(): void {
      // TODO: implement
  }

  ToggleGUI(): void {
      // TODO: implement
  }

  ToggleHUD(): void {
      // TODO: implement
  }

  ShowFocus(): void {
      // TODO: implement
  }

  RenderCommand(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  DebugRenderPlayerInterfaces(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  DrawDebugShapes(DrawTarget: any /* hud */): void {
      // TODO: implement
  }

  AddDebugLine(EndA: THREE.Vector3, EndB: THREE.Vector3, Color: THREE.Color, LifeSpan: number): number {
      // TODO: implement
  }

  RemoveDebugLine(Index: number): void {
      // TODO: implement
  }

  ClearDebugLines(): void {
      // TODO: implement
  }

  AddDebugBox(Center: THREE.Vector3, Diameter: number, Color: THREE.Color, LifeSpan: number): void {
      // TODO: implement
  }

  AddDebugCone(Origin: THREE.Vector3, direction: THREE.Vector3, Length: number, HalfAngle: number, Color: THREE.Color, LifeSpan: number): number {
      // TODO: implement
  }

  RemoveDebugCone(Index: number): void {
      // TODO: implement
  }

  ClearDebugCones(): void {
      // TODO: implement
  }

}
