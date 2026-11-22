// Auto-generated skeleton from UnrealScript: Engine/ParticleEmitter.uc
// Parent: Object

class ParticleEmitter extends Object {

  // Variables
  Location: THREE.Vector3;  //  Vector
  OldLocation: THREE.Vector3;  //  Vector
  Velocity: THREE.Vector3;  //  Vector
  StartSize: THREE.Vector3;  //  Vector
  SpinsPerSecond: THREE.Vector3;  //  Vector
  StartSpin: THREE.Vector3;  //  Vector
  RevolutionCenter: THREE.Vector3;  //  Vector
  RevolutionsPerSecond: THREE.Vector3;  //  Vector
  RevolutionsMultiplier: THREE.Vector3;  //  Vector
  Size: THREE.Vector3;  //  Vector
  StartLocation: THREE.Vector3;  //  Vector
  ColorMultiplier: THREE.Vector3;  //  Vector
  VelocityMultiplier: THREE.Vector3;  //  Vector
  OldMeshLocation: THREE.Vector3;  //  Vector
  Color: THREE.Color;  //  Color
  Time: number;  //  float
  MaxLifetime: number;  //  float
  Mass: number;  //  float
  HitCount: number;  //  int
  flags: number;  //  int
  Subdivision: number;  //  int
  BoneIndex: number;  //  int
  Owner: any /* emitter */;  // transient Emitter
  Initialized: boolean;  // transient bool
  Inactive: boolean;  // transient bool
  InactiveTime: number;  // transient float
  Particles: any /* particle */[];  // transient array<Particle>
  ParticleIndex: number;  // transient int
  ActiveParticles: number;  // transient int
  PPSFraction: number;  // transient float
  BoundingBox: any /* box */;  // transient Box
  RealExtentMultiplier: THREE.Vector3;  // transient Vector
  RealDisableFogging: boolean;  // transient bool
  AllParticlesDead: boolean;  // transient bool
  WarmedUp: boolean;  // transient bool
  OtherIndex: number;  // transient int
  InitialDelay: number;  // transient float
  GlobalOffset: THREE.Vector3;  // transient Vector
  TimeTillReset: number;  // transient float
  PS2Data: number;  // transient int
  MaxActiveParticles: number;  // transient int
  CurrentCollisionSoundIndex: number;  // transient int
  CurrentSpawningSoundIndex: number;  // transient int
  CurrentMeshSpawningIndex: number;  // transient int
  MaxSizeScale: number;  // transient float
  KillPending: number;  // transient int
  DeferredParticles: number;  // transient int
  RealMeshNormal: THREE.Vector3;  // transient Vector
  MeshVertsAndNormals: THREE.Vector3[];  // transient array<Vector>
  CurrentSpawnOnTrigger: number;  // transient int
  RenderableParticles: number;  // transient int
  RealVelocityLossRange: any /* rangevector */;  // transient RangeVector

  constructor() {
    super();
  }

  // Methods
  SpawnParticle(amount: number): void {
      // no body (native/abstract)
  }

  Trigger(): void {
      // no body (native/abstract)
  }

  ResetParticles(): void {
      // no body (native/abstract)
  }

}
