// Auto-generated skeleton from UnrealScript: Engine/ShadowBitmapMaterial.uc
// Parent: BitmapMaterial

class ShadowBitmapMaterial extends BitmapMaterial {

  // Variables
  ShadowActor: any /* actor */;  //  Actor
  LightDirection: THREE.Vector3;  //  Vector
  LightDistance: number;  //  float
  LightFOV: number;  //  float
  Dirty: boolean;  //  bool
  Invalid: boolean;  //  bool
  bDebugShadow: boolean;  //  bool
  bBlobShadow: boolean;  //  bool
  CullDistance: number;  //  float
  ShadowDarkness: number;  //  byte
  BlobShadow: any /* bitmapmaterial */;  //  BitmapMaterial

  constructor() {
    super();
  }

  // Methods
  GetShadowLocation(): THREE.Vector3 {
      // no body (native/abstract)
  }

  SetResolution(Resolution: number): void {
      // no body (native/abstract)
  }

}
