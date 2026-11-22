// Auto-generated skeleton from UnrealScript: Engine/Projector.uc
// Parent: Actor

class Projector extends Actor {

  // Variables
  MaterialBlendingOp: any /* projector.eprojectorblending */;  //  Projector.EProjectorBlending
  FrameBufferBlendingOp: any /* projector.eprojectorblending */;  //  Projector.EProjectorBlending
  ProjTexture: any /* material */;  //  Material
  FOV: number;  //  int
  MaxTraceDistance: number;  //  int
  bProjectBSP: boolean;  //  bool
  bProjectTerrain: boolean;  //  bool
  bProjectStaticMesh: boolean;  //  bool
  bProjectParticles: boolean;  //  bool
  bProjectActor: boolean;  //  bool
  bLevelStatic: boolean;  //  bool
  bClipBSP: boolean;  //  bool
  bClipStaticMesh: boolean;  //  bool
  bProjectOnUnlit: boolean;  //  bool
  bGradient: boolean;  //  bool
  bProjectOnBackfaces: boolean;  //  bool
  bProjectOnParallelBSP: boolean;  //  bool
  ProjectTag: string;  //  name
  bDynamicAttach: boolean;  //  bool
  Box: any /* box */;  // const transient Box
  RenderInfo: any /* projectorrenderinfoptr */;  // const transient ProjectorRenderInfoPtr
  GradientTexture: any /* texture */;  //  Texture
  GradientMatrix: any /* matrix */;  // transient Matrix
  Matrix: any /* matrix */;  // transient Matrix
  OldLocation: THREE.Vector3;  // transient Vector

  constructor() {
    super();
  }

  // Methods
  AttachProjector(FadeInTime: number): void {
      // no body (native/abstract)
  }

  DetachProjector(Force: boolean): void {
      // no body (native/abstract)
  }

  AbandonProjector(Lifetime: number): void {
      // no body (native/abstract)
  }

  AttachActor(A: any /* actor */): void {
      // no body (native/abstract)
  }

  DetachActor(A: any /* actor */): void {
      // no body (native/abstract)
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

  UnTouch(Other: any /* actor */): void {
      // TODO: implement
  }

  UpdateMatrix(): void {
      // no body (native/abstract)
  }

  PreRenderCallback(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

}
