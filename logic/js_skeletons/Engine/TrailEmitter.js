// Auto-generated skeleton from UnrealScript: Engine/TrailEmitter.uc
// Parent: ParticleEmitter

class TrailEmitter extends ParticleEmitter {

  // Variables
  Location: THREE.Vector3;  //  Vector
  Color: THREE.Color;  //  Color
  Size: number;  //  float
  DoubleDummy1: number;  //  int
  DoubleDummy2: number;  //  int
  TrailIndex: number;  //  int
  NumPoints: number;  //  int
  LastLocation: THREE.Vector3;  //  Vector
  TrailData: any /* particletraildata */[];  // transient array<ParticleTrailData>
  TrailInfo: any /* particletrailinfo */[];  // transient array<ParticleTrailInfo>
  VertexBuffer: any /* vertexbuffer */;  // transient VertexBuffer
  IndexBuffer: any /* indexbuffer */;  // transient IndexBuffer
  VerticesPerParticle: number;  // transient int
  IndicesPerParticle: number;  // transient int
  PrimitivesPerParticle: number;  // transient int

  constructor() {
    super();
  }

}
