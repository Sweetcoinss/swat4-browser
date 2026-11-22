// Auto-generated skeleton from UnrealScript: Engine/Interaction.uc
// Parent: Interactions

class Interaction extends Interactions {

  // Variables
  bActive: boolean;  //  bool
  bVisible: boolean;  //  bool
  bRequiresTick: boolean;  //  bool
  bNativeEvents: boolean;  //  bool
  ViewportOwner: any /* player */;  //  Player
  Master: any /* interactionmaster */;  //  InteractionMaster

  constructor() {
    super();
  }

  // Methods
  Initialize(): void {
      // no body (native/abstract)
  }

  ConsoleCommand(S: string): boolean {
      // no body (native/abstract)
  }

  WorldToScreen(Location: THREE.Vector3, CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): THREE.Vector3 {
      // no body (native/abstract)
  }

  ScreenToWorld(Location: THREE.Vector3, CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): THREE.Vector3 {
      // no body (native/abstract)
  }

  Initialized(): void {
      // TODO: implement
  }

  Message(msg: string, MsgLife: number): void {
      // TODO: implement
  }

  KeyType(Key: any /* interactions.einputkey */, Unicode: string): boolean {
      // TODO: implement
  }

  KeyEvent(Key: any /* interactions.einputkey */, Action: any /* interactions.einputaction */, Delta: number): boolean {
      // TODO: implement
  }

  PreRender(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  PostRender(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  SetFocus(): void {
      // TODO: implement
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

}
