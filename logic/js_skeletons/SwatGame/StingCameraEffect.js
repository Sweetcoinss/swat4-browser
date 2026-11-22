// Auto-generated skeleton from UnrealScript: SwatGame/StingCameraEffect.uc
// Parent: SwatCameraEffect

class StingCameraEffect extends SwatCameraEffect {

  // Variables
  BlurAlpha: number;  // private byte
  LastFrameTime: number;  // private transient float
  FadeInTime: number;  // private float
  FadeOutTime: number;  // private float
  DoubleVisionTime: number;  // private float
  DoubleVisionFadeOutTime: number;  // private float
  bBlurTime: boolean;  // private bool
  PassOneDivide: number;  // private int
  PassTwoDivide: number;  // private int
  MaxBlurFrameTime: number;  // private float
  PlayerController: any /* swatgameplayercontroller */;  // private SwatGamePlayerController
  noise: number;  // private const transient int
  ZoomInFraction: number;  // private float
  NoiseAmplitude: number;  // private float
  NoiseRate: number;  // private float
  DoubleVisionNoiseAmplitude: number;  // private float
  DoubleVisionNoiseRate: number;  // private float
  TintColor: THREE.Plane;  // private Plane
  TintTime: number;  // private float
  TintFadeOutTime: number;  // private float
  StingGrenadeParamsClassName: string;  //  string
  StingGrenadeParamsClass: any /* class */;  // private Class<StingEffectParams>
  LessLethalShotgunParamsClassName: string;  //  string
  LessLethalShotgunParamsClass: any /* class */;  // private Class<StingEffectParams>
  StartTime: number;  // private const transient float
  Duration: number;  // private const transient float
  EffectAlpha: number;  // private transient float
  DoubleVisionAlpha: number;  // private transient float
  TintAlpha: number;  // private transient float

  constructor() {
    super();
  }

  // Methods
  Initialize(inPlayerController: any /* swatgameplayercontroller */): void {
      // TODO: implement
  }

  OnAdded(): void {
      // TODO: implement
  }

}
