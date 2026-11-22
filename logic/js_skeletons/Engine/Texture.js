// Auto-generated skeleton from UnrealScript: Engine/Texture.uc
// Parent: BitmapMaterial

class Texture extends BitmapMaterial {

  // Variables
  MipZero: THREE.Color;  // const Color
  MaxColor: THREE.Color;  // const Color
  DetailTexture: any /* texture */;  // deprecated Texture
  EnvironmentMap: any /* texture */;  // deprecated Texture
  EnvMapTransformType: any /* texture.eenvmaptransformtype */;  // deprecated Texture.EEnvMapTransformType
  Specular: number;  // deprecated float
  bRealtime: boolean;  // private bool
  bParametric: boolean;  // private bool
  bRealtimeChanged: boolean;  // private transient bool
  bHasComp: boolean;  // private const editconst bool
  LODSet: any /* texture.elodset */;  //  Texture.ELODSet
  NormalLOD: number;  //  int
  MinLOD: number;  //  int
  MaxLOD: number;  // transient int
  AnimCurrent: any /* texture */;  // transient Texture
  PrimeCurrent: number;  // transient byte
  Accumulator: number;  // transient float
  Mips: number[];  // native const array<int>
  CompFormat: any /* bitmapmaterial.etextureformat */;  // const editconst BitmapMaterial.ETextureFormat
  RenderInterface: number;  // const transient int

  constructor() {
    super();
  }

}
