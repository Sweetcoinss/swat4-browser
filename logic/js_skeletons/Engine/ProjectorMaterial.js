// Auto-generated skeleton from UnrealScript: Engine/ProjectorMaterial.uc
// Parent: RenderedMaterial

class ProjectorMaterial extends RenderedMaterial {

  // Variables
  Gradient: any /* bitmapmaterial */;  // const transient BitmapMaterial
  Projected: any /* material */;  // const transient Material
  BaseMaterial: any /* material */;  // const transient Material
  BaseMaterialBlending: number;  // const transient byte
  FrameBufferBlending: number;  // const transient byte
  Matrix: any /* matrix */;  // const transient Matrix
  GradientMatrix: any /* matrix */;  // const transient Matrix
  bProjected: boolean;  // const transient bool
  bProjectOnUnlit: boolean;  // const transient bool
  bGradient: boolean;  // const transient bool
  bProjectOnAlpha: boolean;  // const transient bool
  bProjectOnBackfaces: boolean;  // const transient bool
  bStaticProjector: boolean;  // const transient bool
  bTwoSided: boolean;  // const transient bool

  constructor() {
    super();
  }

}
