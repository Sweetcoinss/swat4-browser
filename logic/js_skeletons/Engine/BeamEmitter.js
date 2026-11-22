// Auto-generated skeleton from UnrealScript: Engine/BeamEmitter.uc
// Parent: ParticleEmitter

class BeamEmitter extends ParticleEmitter {

  // Variables
  Location: THREE.Vector3;  //  Vector
  t: number;  //  float
  SheetsUsed: number;  // transient int
  VerticesPerParticle: number;  // transient int
  IndicesPerParticle: number;  // transient int
  PrimitivesPerParticle: number;  // transient int
  BeamValueSum: number;  // transient float
  HFPoints: any /* particlebeamdata */[];  // transient array<ParticleBeamData>
  LFPoints: THREE.Vector3[];  // transient array<Vector>
  HitActors: any /* actor */[];  // transient array<Actor>
  TimeSinceLastDynamicNoise: number;  // transient float

  constructor() {
    super();
  }

}
