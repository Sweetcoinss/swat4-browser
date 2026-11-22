// Auto-generated skeleton from UnrealScript: Engine/TerrainInfo.uc
// Parent: Info

class TerrainInfo extends Info {

  // Variables
  Normal1: THREE.Vector3;  //  Vector
  Normal2: THREE.Vector3;  //  Vector
  TerrainMatrix: any /* matrix */;  //  Matrix
  LayerWeightMap: any /* texture */;  //  Texture
  Location: THREE.Vector3;  //  Vector
  Rotation: THREE.Euler;  //  Rotator
  Scale: THREE.Vector3;  //  Vector
  TempScale: THREE.Vector3;  //  Vector
  Color: THREE.Color;  //  Color
  Distance: number;  //  int
  UniqueID: number;  //  int
  DecoInfo: any /* decoinfo */[];  //  array<DecoInfo>
  Location: THREE.Vector3;  //  Vector
  Radius: number;  //  float
  Sectors: any /* decosectorinfo */[];  //  array<DecoSectorInfo>
  TerrainSectorSize: number;  //  int
  TerrainMap: any /* texture */;  //  Texture
  TerrainScale: THREE.Vector3;  //  Vector
  MacroTexture: any /* texture */;  //  Texture
  MacroTextureTransform: any /* matrix */;  // native const Matrix
  DecoLayers: any /* decorationlayer */[];  //  array<DecorationLayer>
  DecoLayerOffset: number;  //  float
  Inverted: boolean;  //  bool
  bDisableRebuildOnEdit: boolean;  // transient bool
  bKCollisionHalfRes: boolean;  //  bool
  JustLoaded: number;  // transient int
  DecoLayerData: any /* decorationlayerdata */[];  // native const array<DecorationLayerData>
  Sectors: any /* terrainsector */[];  // native const array<TerrainSector>
  Vertices: THREE.Vector3[];  // native const array<Vector>
  HeightmapX: number;  // native const int
  HeightmapY: number;  // native const int
  SectorsX: number;  // native const int
  SectorsY: number;  // native const int
  Primitive: any /* terrainprimitive */;  // native const TerrainPrimitive
  FaceNormals: any /* normalpair */[];  // native const array<NormalPair>
  SelectedVertices: number[];  // native const array<int>
  ShowGrid: number;  // native const int
  QuadVisibilityBitmap: number[];  // const array<int>
  EdgeTurnBitmap: number[];  // const array<int>
  QuadDomMaterialBitmap: any /* material */[];  // const array<Material>
  RenderCombinations: number[];  // native const array<int>
  VertexStreams: number[];  // native const array<int>
  ColorStreams: number[];  // native const array<int>
  BaseColors: THREE.Color[];  // native const array<Color>
  VertexColors: THREE.Color[];  // native const array<Color>
  PaintedColor: THREE.Color[];  // native const array<Color>
  CollapsedLayers: any /* texture */;  // native const Texture
  OldTerrainMap: any /* texture */;  // native const Texture
  OldHeightmap: number[];  // native const array<byte>
  DecolayerRenderer: number;  // native const int
  VisibleSectorsCount: number;  // native const int
  RenderThingsCount: number;  // native const int
  VisibleSectors: number;  // native const int
  SectorProjectors: number;  // native const int
  RenderThings: number;  // native const int

  constructor() {
    super();
  }

}
