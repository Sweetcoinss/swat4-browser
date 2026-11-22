// Auto-generated skeleton from UnrealScript: Engine/Shader.uc
// Parent: RenderedMaterial

class Shader extends RenderedMaterial {

  // Variables
  Diffuse: any /* material */;  // editinlineuse Material
  Opacity: any /* material */;  // editinlineuse Material
  NormalMap: any /* material */;  // editinlineuse Material
  PerPixelReflection: any /* cubemap */;  // editinlineuse Cubemap
  PerPixelReflectionMask: any /* material */;  // editinlineuse Material
  PerPixelSpecular: any /* shader.eperpixelspecular */;  //  Shader.EPerPixelSpecular
  PerPixelSpecularType: any /* shader.eperpixelspeculartype */;  //  Shader.EPerPixelSpecularType
  PerPixelSpecularBrightness: number;  //  byte
  Specular: any /* material */;  // editinlineuse Material
  SpecularityMask: any /* material */;  // editinlineuse Material
  SelfIllumination: any /* material */;  // editinlineuse Material
  SelfIlluminationMask: any /* material */;  // editinlineuse Material
  GlowBrightness: number;  //  byte
  GlowMapOverride: any /* material */;  // editinlineuse Material
  GlowMaskOverride: any /* material */;  // editinlineuse Material
  Detail: any /* material */;  // editinlineuse Material
  DetailScale: number;  //  float
  OutputBlending: any /* shader.eoutputblending */;  //  Shader.EOutputBlending
  TwoSided: boolean;  //  bool
  Wireframe: boolean;  //  bool
  ModulateStaticLighting2X: boolean;  //  bool
  PerformLightingOnSpecularPass: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  Reset(): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* actor */): void {
      // TODO: implement
  }

}
