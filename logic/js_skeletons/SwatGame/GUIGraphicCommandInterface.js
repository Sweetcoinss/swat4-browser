// Auto-generated skeleton from UnrealScript: SwatGame/GUIGraphicCommandInterface.uc
// Parent: GUIMultiComponent

class GUIGraphicCommandInterface extends GUIMultiComponent {

  // Variables
  X: number;  // private float
  Y: number;  // private float
  CurrentCommand: any /* command */;  //  Command
  Logic: any /* graphiccommandinterface */;  // private GraphicCommandInterface
  MouseSensitivity: number;  // private float
  LastMouseMoveTime: number;  // private float
  GestureDistanceX: number;  // private float
  GestureDistanceY: number;  // private float
  __OnCapturedMouseMove__Delegate: any /* delegate<oncapturedmousemove> */;  //  delegate<OnCapturedMouseMove>
  __OnKeyEvent__Delegate: any /* delegate<onkeyevent> */;  //  delegate<OnKeyEvent>

  constructor() {
    super();
  }

  // Methods
  OnConstruct(MyController: any /* guicontroller */): void {
      // TODO: implement
  }

  InitComponent(Owner: any /* guicomponent */): void {
      // TODO: implement
  }

  SetLogic(inLogic: any /* graphiccommandinterface */): void {
      // TODO: implement
  }

  GetLogic(): any /* graphiccommandinterface */ {
      // TODO: implement
  }

  CenteredPadY(RawPadY: number): number {
      // TODO: implement
  }

  ClearAllCommands(): void {
      // TODO: implement
  }

  ClearCommands(PageChange: boolean): void {
      // TODO: implement
  }

  OnCurrentTeamChanged(NewTeam: any /* officerteaminfo */): void {
      // TODO: implement
  }

  SetCommand(Command: any /* command */, Status: any /* commandinterface.menupadstatus */): void {
      // no body (native/abstract)
  }

  SelectCommand(NewSelection: any /* command */, LateralMove: boolean): void {
      // TODO: implement
  }

  Open(): void {
      // TODO: implement
  }

  Close(): void {
      // TODO: implement
  }

  CloseInstantly(): void {
      // TODO: implement
  }

  OnRightMousePressed(): boolean {
      // TODO: implement
  }

  OnRightMouseReleased(): boolean {
      // TODO: implement
  }

  OnLeftMousePressed(): boolean {
      // TODO: implement
  }

  SelectCommandTeam(): boolean {
      // TODO: implement
  }

  OnMouseMovedUp(): void {
      // TODO: implement
  }

  OnMouseMovedDown(): void {
      // TODO: implement
  }

  OnMouseMovedRight(): void {
      // TODO: implement
  }

  OnMouseMovedLeft(): void {
      // TODO: implement
  }

  Scroll(UpOrDown: string): void {
      // TODO: implement
  }

  GiveCommand(): void {
      // TODO: implement
  }

  GetCommandRef(Command: any /* commandinterface.ecommand */): any /* command */ {
      // TODO: implement
  }

  GetDefaultCommand(): any /* command */ {
      // TODO: implement
  }

  Pad(Length: number, S: string): string {
      // TODO: implement
  }

  MousePressed(): void {
      // TODO: implement
  }

  MouseReleased(): void {
      // TODO: implement
  }

  TriggerEffectEvent(EffectEvent: string): void {
      // TODO: implement
  }

}
