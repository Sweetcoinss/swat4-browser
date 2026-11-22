// Auto-generated skeleton from UnrealScript: Engine/I3DL2Listener.uc
// Parent: Object

class I3DL2Listener extends Object {

  // Variables
  EnvironmentSize: number;  //  float
  EnvironmentDiffusion: number;  //  float
  Room: number;  //  int
  RoomHF: number;  //  int
  RoomLF: number;  //  int
  DecayTime: number;  //  float
  DecayHFRatio: number;  //  float
  DecayLFRatio: number;  //  float
  Reflections: number;  //  int
  ReflectionsDelay: number;  //  float
  ReflectionsPan: THREE.Vector3;  //  Vector
  Reverb: number;  //  int
  ReverbDelay: number;  //  float
  ReverbPan: THREE.Vector3;  //  Vector
  EchoTime: number;  //  float
  EchoDepth: number;  //  float
  ModulationTime: number;  //  float
  ModulationDepth: number;  //  float
  RoomRolloffFactor: number;  //  float
  AirAbsorptionHF: number;  //  float
  HFReference: number;  //  float
  LFReference: number;  //  float
  bDecayTimeScale: boolean;  //  bool
  bReflectionsScale: boolean;  //  bool
  bReflectionsDelayScale: boolean;  //  bool
  bReverbScale: boolean;  //  bool
  bReverbDelayScale: boolean;  //  bool
  bEchoTimeScale: boolean;  //  bool
  bModulationTimeScale: boolean;  //  bool
  bDecayHFLimit: boolean;  //  bool
  Environment: number;  // transient int
  Updated: number;  // transient int

  constructor() {
    super();
  }

}
