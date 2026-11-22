// Auto-generated skeleton from UnrealScript: Engine/SparkEmitter.uc
// Parent: ParticleEmitter

class SparkEmitter extends ParticleEmitter {

  // Variables
  TimeBeforeVisible: number;  //  float
  TimeBetweenSegments: number;  //  float
  StartLocation: THREE.Vector3;  //  Vector
  StartVelocity: THREE.Vector3;  //  Vector
  SparkData: any /* particlesparkdata */[];  // transient array<ParticleSparkData>
  VertexBuffer: any /* vertexbuffer */;  // transient VertexBuffer
  IndexBuffer: any /* indexbuffer */;  // transient IndexBuffer
  NumSegments: number;  // transient int
  VerticesPerParticle: number;  // transient int
  IndicesPerParticle: number;  // transient int
  PrimitivesPerParticle: number;  // transient int

  constructor() {
    super();
  }

}
