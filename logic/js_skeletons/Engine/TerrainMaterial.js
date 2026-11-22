// Auto-generated skeleton from UnrealScript: Engine/TerrainMaterial.uc
// Parent: RenderedMaterial

class TerrainMaterial extends RenderedMaterial {

  // Variables
  Texture: any /* material */;  //  Material
  AlphaWeight: any /* bitmapmaterial */;  //  BitmapMaterial
  TextureMatrix: any /* matrix */;  //  Matrix
  Layers: any /* terrainmateriallayer */[];  // const array<TerrainMaterialLayer>
  MacroTexture: any /* texture */;  // const Texture
  MacroTextureTransform: any /* matrix */;  // const Matrix
  ForceFogOverride: boolean;  // const bool
  RenderMethod: number;  // const byte
  FirstPass: boolean;  // const bool

  constructor() {
    super();
  }

}
