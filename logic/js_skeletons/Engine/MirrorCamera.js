// Auto-generated skeleton from UnrealScript: Engine/MirrorCamera.uc
// Parent: GenericExternalCamera

class MirrorCamera extends GenericExternalCamera {

  // Variables
  MirrorTexture: any /* scriptedtexture */;  // private const transient ScriptedTexture
  MirrorScaler: any /* texscaler */;  // private const transient TexScaler
  MirrorMaterial: any /* material */;  // const transient Material
  OwnerMirror: any /* mirror */;  //  Mirror

  constructor() {
    super();
  }

  // Methods
  Initialize(): void {
      // no body (native/abstract)
  }

  CreateNewScriptedTexture(InName: string): any /* scriptedtexture */ {
      // no body (native/abstract)
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  GetViewRotation(): THREE.Euler {
      // TODO: implement
  }

  GetViewLocation(): THREE.Vector3 {
      // TODO: implement
  }

}
