// Auto-generated skeleton from UnrealScript: Engine/Emitter.uc
// Parent: Actor

class Emitter extends Actor {

  // Variables
  Emitters: any /* particleemitter> */;  // export editinline array<export editinline ParticleEmitter>
  Initialized: number;  // transient int
  BoundingBox: any /* box */;  // transient Box
  EmitterRadius: number;  // transient float
  EmitterHeight: number;  // transient float
  ActorForcesEnabled: boolean;  // transient bool
  GlobalOffset: THREE.Vector3;  // transient Vector
  TimeTillReset: number;  // transient float
  UseParticleProjectors: boolean;  // transient bool
  ParticleMaterial: any /* particlematerial */;  // transient ParticleMaterial
  DeleteParticleEmitters: boolean;  // transient bool
  bPlaying: boolean;  //  bool
  bStoppedOverTime: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  PlayEmitters(): void {
      // TODO: implement
  }

  StopEmitters(bStopOverTime: boolean): void {
      // TODO: implement
  }

  Kill(): void {
      // no body (native/abstract)
  }

  UpdatePrecacheRenderData(): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  PreAutoDestroyed(): void {
      // TODO: implement
  }

}
