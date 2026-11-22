// Auto-generated skeleton from UnrealScript: SwatGame/PepperSprayCameraEffect.uc
// Parent: SwatCameraEffect

class PepperSprayCameraEffect extends SwatCameraEffect {

  // Variables
  BlurAlpha: number;  // private byte
  LastFrameTime: number;  // private transient float
  FadeInTime: number;  // private float
  FadeOutTime: number;  // private float
  bBlurTime: boolean;  // private bool
  PassOneDivide: number;  // private int
  PassTwoDivide: number;  // private int
  MaxBlurFrameTime: number;  // private float
  GreyColorChooser: THREE.Vector3;  // private Vector
  GreyWeight: THREE.Vector3;  // private Vector
  PlayerController: any /* swatgameplayercontroller */;  // private SwatGamePlayerController
  noise: number;  // private const transient int
  ZoomInFraction: number;  // private float
  NoiseAmplitude: number;  // private float
  NoiseRate: number;  // private float
  ParamsClassName: string;  //  string
  ParamsClass: any /* class */;  // private Class<PepperSprayEffectParams>
  StartTime: number;  // private const transient float
  Duration: number;  // private const transient float
  EffectAlpha: number;  // private const transient float

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
