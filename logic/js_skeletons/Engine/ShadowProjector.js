// Auto-generated skeleton from UnrealScript: Engine/ShadowProjector.uc
// Parent: Projector

class ShadowProjector extends Projector {

  // Variables
  ShadowActor: any /* actor */;  //  Actor
  LightDirection: THREE.Vector3;  //  Vector
  LightDistance: number;  //  float
  RootMotion: boolean;  //  bool
  bBlobShadow: boolean;  //  bool
  bShadowActive: boolean;  //  bool
  ShadowTexture: any /* shadowbitmapmaterial */;  //  ShadowBitmapMaterial
  Resolution: number;  //  int

  constructor() {
    super();
  }

  // Methods
  UpdateDetailSetting(): void {
      // no body (native/abstract)
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  InitShadow(): void {
      // TODO: implement
  }

  UpdateShadow(): void {
      // no body (native/abstract)
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

  PreRenderCallback(): void {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

}
