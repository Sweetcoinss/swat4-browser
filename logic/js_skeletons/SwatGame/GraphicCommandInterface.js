// Auto-generated skeleton from UnrealScript: SwatGame/GraphicCommandInterface.uc
// Parent: CommandInterface

class GraphicCommandInterface extends CommandInterface {

  // Variables
  View: any /* guigraphiccommandinterface */;  // private export editinline GUIGraphicCommandInterface
  bIsClosed: boolean;  // private bool
  bWasClosedBeforePageChange: boolean;  // private bool

  constructor() {
    super();
  }

  // Methods
  Initialize(): void {
      // TODO: implement
  }

  PreUpdateHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): boolean {
      // TODO: implement
  }

  CancelGivingCommand(): void {
      // TODO: implement
  }

  Open(): void {
      // TODO: implement
  }

  PostDeactivated(): void {
      // TODO: implement
  }

  Close(): void {
      // TODO: implement
  }

  OnCurrentTeamChanged(NewTeam: any /* officerteaminfo */): void {
      // TODO: implement
  }

  ClearCommands(PageChange: boolean): void {
      // TODO: implement
  }

  SetCommand(Command: any /* command */, Status: any /* commandinterface.menupadstatus */): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  PreMainPageChanged(): void {
      // TODO: implement
  }

  PostMainPageChanged(): void {
      // TODO: implement
  }

}
