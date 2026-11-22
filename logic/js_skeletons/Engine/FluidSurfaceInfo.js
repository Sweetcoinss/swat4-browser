// Auto-generated skeleton from UnrealScript: Engine/FluidSurfaceInfo.uc
// Parent: Info

class FluidSurfaceInfo extends Info {

  // Variables
  FluidGridType: any /* fluidsurfaceinfo.efluidgridtype */;  //  FluidSurfaceInfo.EFluidGridType
  FluidGridSpacing: number;  //  float
  FluidXSize: number;  //  int
  FluidYSize: number;  //  int
  FluidHeightScale: number;  //  float
  FluidSpeed: number;  //  float
  FluidDamping: number;  //  float
  FluidNoiseFrequency: number;  //  float
  FluidNoiseStrength: any /* range */;  //  Range
  TestRipple: boolean;  //  bool
  TestRippleSpeed: number;  //  float
  TestRippleStrength: number;  //  float
  TestRippleRadius: number;  //  float
  UTiles: number;  //  float
  UOffset: number;  //  float
  VTiles: number;  //  float
  VOffset: number;  //  float
  AlphaCurveScale: number;  //  float
  AlphaHeightScale: number;  //  float
  AlphaMax: number;  //  byte
  ShootStrength: number;  //  float
  ShootRadius: number;  //  float
  RippleVelocityFactor: number;  //  float
  TouchStrength: number;  //  float
  ShootEffect: any /* class */;  //  Class<Actor>
  OrientShootEffect: boolean;  //  bool
  TouchEffect: any /* class */;  //  Class<Actor>
  OrientTouchEffect: boolean;  //  bool
  ClampBitmap: number[];  // const array<int>
  ClampTerrain: any /* terraininfo */;  // edfindable TerrainInfo
  bShowBoundingBox: boolean;  //  bool
  bUseNoRenderZ: boolean;  //  bool
  NoRenderZ: number;  //  float
  WarmUpTime: number;  //  float
  UpdateRate: number;  //  float
  FluidColor: THREE.Color;  //  Color
  Verts0: number[];  // const transient array<float>
  Verts1: number[];  // const transient array<float>
  VertAlpha: number[];  // const transient array<byte>
  LatestVerts: number;  // const transient int
  FluidBoundingBox: any /* box */;  // const transient Box
  FluidOrigin: THREE.Vector3;  // const transient Vector
  TimeRollover: number;  // const transient float
  TestRippleAng: number;  // const transient float
  Primitive: any /* fluidsurfaceprimitive */;  // const transient FluidSurfacePrimitive
  Oscillators: any /* fluidsurfaceoscillator */[];  // const transient array<FluidSurfaceOscillator>
  bHasWarmedUp: boolean;  // const transient bool

  constructor() {
    super();
  }

  // Methods
  Pling(Position: THREE.Vector3, Strength: number, Radius: number): void {
      // no body (native/abstract)
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

}
