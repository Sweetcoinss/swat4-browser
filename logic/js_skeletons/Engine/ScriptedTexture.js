// Auto-generated skeleton from UnrealScript: Engine/ScriptedTexture.uc
// Parent: BitmapMaterial

class ScriptedTexture extends BitmapMaterial {

  // Variables
  RenderTarget: number;  // const transient int
  RenderViewport: any /* viewport */;  // const transient Viewport
  Client: any /* actor */;  //  Actor
  bNotifyClientBeforeRendering: boolean;  //  bool
  Revision: number;  // transient int
  OldRevision: number;  // const transient int

  constructor() {
    super();
  }

  // Methods
  SetSize(Width: number, Height: number): any /* in unscriptedtexture.cpp
    void */ {
      // no body (native/abstract)
  }

  SetSize(Width: number, Height: number): void {
      // no body (native/abstract)
  }

  DrawText(StartX: number, StartY: number, Text: string, Font: any /* font */, Color: THREE.Color): void {
      // no body (native/abstract)
  }

  TextSize(Text: string, Font: any /* font */, Width: number, Height: number): void {
      // no body (native/abstract)
  }

  DrawTile(X: number, Y: number, XL: number, YL: number, U: number, V: number, UL: number, VL: number, Material: any /* material */, Color: THREE.Color): void {
      // no body (native/abstract)
  }

  DrawPortal(X: number, Y: number, Width: number, Height: number, CamActor: any /* actor */, CamLocation: THREE.Vector3, CamRotation: THREE.Euler, FOV: number, ClearZ: boolean, RenderPlayer: boolean): void {
      // no body (native/abstract)
  }

}
