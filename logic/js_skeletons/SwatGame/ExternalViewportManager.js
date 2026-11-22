// Auto-generated skeleton from UnrealScript: SwatGame/ExternalViewportManager.uc
// Parent: Actor

class ExternalViewportManager extends Actor {

  // Variables
  kDefaultSizeX: number;  // private const config float
  kDefaultSizeY: number;  // private const config float
  kActiveSizeX: number;  // private const config float
  kActiveSizeY: number;  // private const config float
  kZoomRate: number;  // private const config float
  kViewportFOV: number;  // private const config float
  kViewportRightPadding: number;  // private const config float
  kViewportTopPadding: number;  // private const config float
  OfficerFontName: string;  // private const config string
  kNegativeFontYOffset: number;  // private const config float
  kNegativeFontXOffset: number;  // private const config float
  iCurrentControllable: number;  // private int
  AllControllable: any /* icontrollablethroughviewport */[];  //  array<IControllableThroughViewport>
  CurrentControllables: any /* icontrollablethroughviewport */[];  //  array<IControllableThroughViewport>
  filter: string;  // private string
  InitialControllable: string;  // private string
  CurrentSizeX: number;  // private float
  CurrentSizeY: number;  // private float
  CurrentWidth: number;  // private float
  CurrentHeight: number;  // private float
  LastDeltaTime: number;  // private float
  BaseControllableClass: any /* class */;  // private Class<Actor>
  GUIParent: any /* guiexternalviewport */;  // private export editinline GUIExternalViewport
  DeadTexture: any /* material */;  // private Material
  LastViewRotation: THREE.Euler;  // private Rotator
  LastViewLocation: THREE.Vector3;  // private Vector
  ReticleTexture: any /* material */;  // private Material
  MouseAccel: THREE.Vector3;  // private Vector
  OriginalRotation: THREE.Euler;  // private Rotator

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  OnGameStarted(): void {
      // TODO: implement
  }

  OnMissionEnded(): void {
      // TODO: implement
  }

  ShowViewport(inFilter: string, inSpecificControllableFilter: string): void {
      // TODO: implement
  }

  SetFilter(inFilter: string): boolean {
      // TODO: implement
  }

  GetFilter(): string {
      // TODO: implement
  }

  ShouldControlViewport(): boolean {
      // TODO: implement
  }

  Initialize(): void {
      // TODO: implement
  }

  HasOfficers(ViewportType: string): boolean {
      // TODO: implement
  }

  SetCurrentControllable(NewControllable: any /* icontrollablethroughviewport */): void {
      // TODO: implement
  }

  GetCurrentControllable(): any /* icontrollablethroughviewport */ {
      // TODO: implement
  }

  SetInput(dMouseX: number, dMouseY: number): void {
      // TODO: implement
  }

  ControllableMatchesFilter(Controllable: any /* icontrollablethroughviewport */, filter: string): boolean {
      // TODO: implement
  }

  IncrementControllableAndTestValidity(): boolean {
      // TODO: implement
  }

  CycleControllableViewport(SpecificControllableFilter: string): void {
      // TODO: implement
  }

  UpdateGUIComponent(inCanvas: any /* canvas */, X: number, Y: number, W: number, H: number): void {
      // TODO: implement
  }

  InstantMinimize(): void {
      // TODO: implement
  }

  UpdateGeometry(inCanvas: any /* canvas */, inDeltaTime: number, X: number, Y: number, W: number, H: number): void {
      // TODO: implement
  }

  DrawOfficerName(inCanvas: any /* canvas */): void {
      // TODO: implement
  }

  Render(inCanvas: any /* canvas */): void {
      // TODO: implement
  }

  GetControllingStateName(): string {
      // TODO: implement
  }

  CanIssueCommands(): boolean {
      // TODO: implement
  }

  DrawReticle(inCanvas: any /* canvas */): void {
      // TODO: implement
  }

  DegreesToUnreal(inDegrees: number): number {
      // TODO: implement
  }

  ViewportCalcView(CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): void {
      // TODO: implement
  }

  OnBeginControlling(): void {
      // TODO: implement
  }

  OnEndControlling(): void {
      // TODO: implement
  }

  HandleReload(): void {
      // TODO: implement
  }

  HandleFire(): void {
      // TODO: implement
  }

  HandleAltFire(): void {
      // TODO: implement
  }

  DrawViewport(inCanvas: any /* canvas */, X: number, Y: number, W: number, H: number): void {
      // TODO: implement
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

  HideViewport(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

}
