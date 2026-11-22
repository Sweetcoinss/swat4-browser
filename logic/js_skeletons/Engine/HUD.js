// Auto-generated skeleton from UnrealScript: Engine/HUD.uc
// Parent: Actor

class HUD extends Actor {

  // Variables
  Message: any /* class */;  //  Class<LocalMessage>
  Switch: number;  //  int
  RelatedPRI: any /* playerreplicationinfo */;  //  PlayerReplicationInfo
  OptionalObject: any /* object */;  //  Object
  EndOfLife: number;  //  float
  Lifetime: number;  //  float
  bDrawing: boolean;  //  bool
  numLines: number;  //  int
  StringMessage: string;  //  string
  DrawColor: THREE.Color;  //  Color
  StringFont: any /* font */;  //  Font
  XL: number;  //  float
  YL: number;  //  float
  YPos: number;  //  float
  Text: string;  //  string
  TextColor: THREE.Color;  //  Color
  MessageLife: number;  //  float
  PRI: any /* playerreplicationinfo */;  //  PlayerReplicationInfo
  SmallFont: any /* font */;  //  Font
  MedFont: any /* font */;  //  Font
  BigFont: any /* font */;  //  Font
  LargeFont: any /* font */;  //  Font
  HUDConfigWindowType: string;  //  string
  nextHUD: any /* hud */;  //  HUD
  PlayerOwner: any /* playercontroller */;  //  PlayerController
  ProgressFontName: string;  // localized string
  ProgressFontFont: any /* font */;  //  Font
  ProgressFadeTime: number;  //  float
  MOTDColor: THREE.Color;  //  Color
  ScoreBoard: any /* scoreboard */;  //  ScoreBoard
  bHideHUD: boolean;  //  bool
  bShowScores: boolean;  //  bool
  bShowDebugInfo: boolean;  //  bool
  bHideCenterMessages: boolean;  //  bool
  bBadConnectionAlert: boolean;  //  bool
  bMessageBeep: boolean;  // config bool
  HudCanvasScale: number;  // globalconfig float
  LoadingMessage: string;  // localized string
  SavingMessage: string;  // localized string
  ConnectingMessage: string;  // localized string
  PausedMessage: string;  // localized string
  PrecachingMessage: string;  // localized string
  Movie: any /* movie */;  // const transient Movie
  MoviePosX: number;  //  int
  MoviePosY: number;  //  int
  TexMovieTop: number;  //  float
  TexMovieLeft: number;  //  float
  TexMovieBottom: number;  //  float
  TexMovieRight: number;  //  float
  TexMovieTranslucent: boolean;  //  bool
  TextureMovie: any /* movietexture */;  //  MovieTexture
  ConsoleColor: THREE.Color;  //  Color
  ConsoleMessageCount: number;  // globalconfig int
  ConsoleFontSize: number;  // globalconfig int
  MessageFontOffset: number;  // globalconfig int
  ConsoleMessagePosX: number;  //  float
  ConsoleMessagePosY: number;  //  float

  constructor() {
    super();
  }

  // Methods
  Draw3DLine(Start: THREE.Vector3, End: THREE.Vector3, LineColor: THREE.Color): void {
      // no body (native/abstract)
  }

  Draw3DCircle(Origin: THREE.Vector3, PlaneXAxis: THREE.Vector3, PlaneYAxis: THREE.Vector3, Radius: number, Color: THREE.Color, NumSides: number): void {
      // no body (native/abstract)
  }

  Draw3DCylinder(Base: THREE.Vector3, X: THREE.Vector3, Y: THREE.Vector3, Z: THREE.Vector3, Radius: number, HalfHeight: number, Color: THREE.Color, NumSides: number): void {
      // no body (native/abstract)
  }

  Draw3DCone(Origin: THREE.Vector3, direction: THREE.Vector3, Length: number, HalfAngle: number, Color: THREE.Color, NumSides: number): void {
      // no body (native/abstract)
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  SpawnScoreBoard(ScoringType: any /* class */): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  ShowScores(): void {
      // TODO: implement
  }

  ShowDebug(): void {
      // TODO: implement
  }

  WorldSpaceOverlays(): void {
      // TODO: implement
  }

  CheckCountdown(GRI: any /* gamereplicationinfo */): void {
      // TODO: implement
  }

  ConnectFailure(FailCode: string, URL: string): void {
      // TODO: implement
  }

  ShowUpgradeMenu(): void {
      // TODO: implement
  }

  PlayStartupMessage(Stage: number): void {
      // TODO: implement
  }

  ClearMessage(M: any /* hudlocalizedmessage */): void {
      // TODO: implement
  }

  CopyMessage(M1: any /* hudlocalizedmessage */, M2: any /* hudlocalizedmessage */): void {
      // TODO: implement
  }

  PostRender(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  DrawSpectatingHud(C: any /* canvas */): void {
      // TODO: implement
  }

  DrawRoute(): void {
      // TODO: implement
  }

  DrawHUD(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  PrintActionMessage(C: any /* canvas */, BigMessage: string): void {
      // TODO: implement
  }

  DisplayProgressMessage(C: any /* canvas */): void {
      // TODO: implement
  }

  DrawLevelAction(C: any /* canvas */): boolean {
      // TODO: implement
  }

  DisplayBadConnectionAlert(): void {
      // TODO: implement
  }

  PlayMovieDirect(MovieFilename: string, XPos: number, YPos: number, UseSound: boolean, LoopMovie: boolean): void {
      // TODO: implement
  }

  PlayMovieScaled(InMovie: any /* movietexture */, Left: number, Top: number, Right: number, Bottom: number, UseSound: boolean, LoopMovie: boolean, Translucent: boolean): void {
      // TODO: implement
  }

  IsMoviePlaying(): boolean {
      // TODO: implement
  }

  PauseMovie(Pause: boolean): void {
      // TODO: implement
  }

  IsMoviePaused(): boolean {
      // TODO: implement
  }

  StopMovie(): void {
      // TODO: implement
  }

  Message(PRI: any /* playerreplicationinfo */, msg: string, MsgType: string): void {
      // TODO: implement
  }

  DisplayPortrait(PRI: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  LocalizedMessage(Message: any /* class */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */, CriticalString: string): void {
      // TODO: implement
  }

  PlayReceivedMessage(S: string, PName: string, PZone: any /* zoneinfo */): void {
      // TODO: implement
  }

  ProcessKeyEvent(Key: number, Action: number, Delta: number): boolean {
      // TODO: implement
  }

  DisplayMessages(C: any /* canvas */): void {
      // TODO: implement
  }

  AddTextMessage(M: string, MessageClass: any /* class */, PRI: any /* playerreplicationinfo */): void {
      // TODO: implement
  }

  UseSmallFont(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  UseMediumFont(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  UseLargeFont(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  UseHugeFont(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  LoadFontStatic(i: number): any /* font */ {
      // TODO: implement
  }

  LoadFont(i: number): any /* font */ {
      // TODO: implement
  }

  GetConsoleFont(C: any /* canvas */): any /* font */ {
      // TODO: implement
  }

  GetMediumFontFor(Canvas: any /* canvas */): any /* font */ {
      // TODO: implement
  }

  LargerFontThan(aFont: any /* font */): any /* font */ {
      // TODO: implement
  }

  LoadProgressFont(): any /* font */ {
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

}
