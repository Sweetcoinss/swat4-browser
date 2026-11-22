// Auto-generated skeleton from UnrealScript: Engine/Canvas.uc
// Parent: Object

class Canvas extends Object {

  // Variables
  DefaultFont: any /* font */;  // const Font
  Font: any /* font */;  //  Font
  SpaceX: number;  //  float
  SpaceY: number;  //  float
  OrgX: number;  //  float
  OrgY: number;  //  float
  ClipX: number;  //  float
  ClipY: number;  //  float
  CurX: number;  //  float
  CurY: number;  //  float
  Z: number;  //  float
  Style: number;  //  byte
  CurYL: number;  //  float
  DrawColor: THREE.Color;  //  Color
  bCenter: boolean;  //  bool
  bNoSmooth: boolean;  //  bool
  SizeX: number;  // const int
  SizeY: number;  // const int
  TinyFont: any /* font */;  // const Font
  SmallFont: any /* font */;  // const Font
  MedFont: any /* font */;  // const Font
  DefaultFontName: string;  //  string
  TinyFontName: string;  //  string
  SmallFontName: string;  //  string
  MedFontName: string;  //  string
  WhiteTex: any /* texture */;  //  Texture
  Viewport: any /* viewport */;  // const Viewport
  pCanvasUtil: number;  // const int

  constructor() {
    super();
  }

  // Methods
  StrLen(String: string, XL: number, YL: number): void {
      // no body (native/abstract)
  }

  DrawText(Text: string, CR: boolean): void {
      // no body (native/abstract)
  }

  DrawTile(Mat: any /* material */, XL: number, YL: number, U: number, V: number, UL: number, VL: number): void {
      // no body (native/abstract)
  }

  DrawActor(A: any /* actor */, Wireframe: boolean, ClearZ: boolean, DisplayFOV: number): void {
      // no body (native/abstract)
  }

  DrawTileClipped(Mat: any /* material */, XL: number, YL: number, U: number, V: number, UL: number, VL: number): void {
      // no body (native/abstract)
  }

  DrawTextClipped(Text: string, bCheckHotKey: boolean): void {
      // no body (native/abstract)
  }

  TextSize(String: string, XL: number, YL: number): void {
      // no body (native/abstract)
  }

  DrawPortal(X: number, Y: number, Width: number, Height: number, CamActor: any /* actor */, CamLocation: THREE.Vector3, CamRotation: THREE.Euler, FOV: number, ClearZ: boolean): void {
      // no body (native/abstract)
  }

  WrapStringToArray(Text: string, OutArray: string[], dx: number, EOL: string, bIsCodedString: boolean): void {
      // no body (native/abstract)
  }

  DrawTileStretched(Mat: any /* material */, XL: number, YL: number): void {
      // no body (native/abstract)
  }

  DrawTileJustified(Mat: any /* material */, Justification: number, XL: number, YL: number): void {
      // no body (native/abstract)
  }

  DrawTileScaled(Mat: any /* material */, XScale: number, YScale: number): void {
      // no body (native/abstract)
  }

  DrawTextJustified(String: string, Justification: number, x1: number, y1: number, x2: number, y2: number): void {
      // no body (native/abstract)
  }

  DrawTextMultiline(Text: string, Origin2D: THREE.Vector3, ForegroundColor: THREE.Color, BackgroundColor: THREE.Color, Wrapped: boolean, Centered: boolean): void {
      // no body (native/abstract)
  }

  Reset(): void {
      // TODO: implement
  }

  SetPos(X: number, Y: number): void {
      // TODO: implement
  }

  SetOrigin(X: number, Y: number): void {
      // TODO: implement
  }

  SetClip(X: number, Y: number): void {
      // TODO: implement
  }

  DrawPattern(Tex: any /* material */, XL: number, YL: number, Scale: number): void {
      // TODO: implement
  }

  DrawIcon(Tex: any /* texture */, Scale: number): void {
      // TODO: implement
  }

  DrawRect(Tex: any /* texture */, RectX: number, RectY: number): void {
      // TODO: implement
  }

  SetDrawColor(R: number, G: number, B: number, A: number): void {
      // TODO: implement
  }

  MakeColor(R: number, G: number, B: number, A: number): THREE.Color {
      // TODO: implement
  }

  DrawVertical(X: number, Height: number): void {
      // TODO: implement
  }

  DrawHorizontal(Y: number, Width: number): void {
      // TODO: implement
  }

  DrawLine(direction: number, Size: number): void {
      // TODO: implement
  }

  DrawBracket(Width: number, Height: number, bracket_size: number): void {
      // TODO: implement
  }

  DrawBox(Canvas: any /* canvas */, Width: number, Height: number): void {
      // TODO: implement
  }

}
