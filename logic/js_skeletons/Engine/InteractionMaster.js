// Auto-generated skeleton from UnrealScript: Engine/InteractionMaster.uc
// Parent: Interactions

class InteractionMaster extends Interactions {

  // Variables
  Client: any /* client */;  // transient Client
  BaseMenu: any /* interaction */;  // const transient Interaction
  Console: any /* interaction */;  // const transient Interaction
  GlobalInteractions: any /* interaction */[];  // transient array<Interaction>
  bRequireRawJoystick: boolean;  // transient bool

  constructor() {
    super();
  }

  // Methods
  Travel(URL: string): void {
      // no body (native/abstract)
  }

  AddInteraction(InteractionName: string, AttachTo: any /* player */): any /* interaction */ {
      // TODO: implement
  }

  RemoveInteraction(RemoveMe: any /* interaction */): void {
      // TODO: implement
  }

  SetFocusTo(Inter: any /* interaction */, ViewportOwner: any /* player */): void {
      // TODO: implement
  }

  Process_KeyType(InteractionArray: any /* interaction */[], Key: any /* interactions.einputkey */, Unicode: string): boolean {
      // TODO: implement
  }

  Process_KeyEvent(InteractionArray: any /* interaction */[], Key: any /* interactions.einputkey */, Action: any /* interactions.einputaction */, Delta: number): boolean {
      // TODO: implement
  }

  Process_PreRender(InteractionArray: any /* interaction */[], Canvas: any /* canvas */): void {
      // TODO: implement
  }

  Process_PostRender(InteractionArray: any /* interaction */[], Canvas: any /* canvas */): void {
      // TODO: implement
  }

  Process_Tick(InteractionArray: any /* interaction */[], DeltaTime: number): void {
      // TODO: implement
  }

  Process_Message(msg: string, MsgLife: number, InteractionArray: any /* interaction */[]): void {
      // TODO: implement
  }

  GetKeyFromBinding(BindingText: string, bLocalized: boolean): string {
      // no body (native/abstract)
  }

}
