// Auto-generated skeleton from UnrealScript: Engine/xWeatherEffect.uc
// Parent: Actor

class xWeatherEffect extends Actor {

  // Variables
  pos: THREE.Vector3;  //  Vector
  Vel: THREE.Vector3;  //  Vector
  Life: number;  //  float
  Size: number;  //  float
  HitTime: number;  //  float
  InvLifeSpan: number;  //  float
  DistAtten: number;  //  float
  frame: number;  //  byte
  Dummy1: number;  //  byte
  Visible: number;  //  byte
  Dummy2: number;  //  byte
  WeatherType: any /* xweathereffect.eweathertype */;  //  xWeatherEffect.EWeatherType
  numParticles: number;  //  int
  numActive: number;  // transient int
  Box: any /* box */;  // transient Box
  eyePos: THREE.Vector3;  // transient Vector
  eyeDir: THREE.Vector3;  // transient Vector
  spawnOrigin: THREE.Vector3;  // transient Vector
  eyeMoveVec: THREE.Vector3;  // transient Vector
  eyeVel: number;  // transient float
  deviation: number;  //  float
  maxPclEyeDist: number;  //  float
  numCols: number;  //  float
  numRows: number;  //  float
  numFrames: number;  // transient float
  texU: number;  // transient float
  texV: number;  // transient float
  noReference: boolean;  // transient bool
  spawnVecU: THREE.Vector3;  //  Vector
  spawnVecV: THREE.Vector3;  //  Vector
  spawnVel: THREE.Vector3;  //  Vector
  Position: any /* rangevector */;  //  RangeVector
  speed: any /* range */;  //  Range
  Life: any /* range */;  //  Range
  Size: any /* range */;  //  Range
  EyeSizeClamp: any /* range */;  //  Range
  pcl: any /* weatherpcl */[];  // transient array<WeatherPcl>
  pclBlockers: any /* volume */[];  // transient array<Volume>

  constructor() {
    super();
  }

}
