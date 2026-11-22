// Auto-generated skeleton from UnrealScript: SwatGame/ClassicCommandInterface.uc
// Parent: CommandInterface

class ClassicCommandInterface extends CommandInterface {

  // Variables
  Command: any /* command */;  //  Command
  Status: any /* commandinterface.menupadstatus */;  //  CommandInterface.MenuPadStatus
  ElementString: string;  // config localized string
  RedTeamString: string;  // config localized string
  BlueTeamString: string;  // config localized string
  BackString: string;  // config localized string
  HUDPage: any /* hudpagebase */;  // export editinline HUDPageBase
  View: any /* guiclassiccommandinterfacecontainer */;  // private export editinline GUIClassicCommandInterfaceContainer

  constructor() {
    super();
  }

  // Methods
  Initialize(): void {
      // TODO: implement
  }

  PostUpdate(): void {
      // TODO: implement
  }

  SetCommand(Command: any /* command */, Status: any /* commandinterface.menupadstatus */): void {
      // TODO: implement
  }

  SetCurrentPage(NewPage: any /* commandinterface.commandinterfacepage */, Force: boolean): void {
      // TODO: implement
  }

  PostMainPageChanged(): void {
      // TODO: implement
  }

  GiveCommandIndex(CommandIndex: number): void {
      // TODO: implement
  }

  UpdateView(): void {
      // TODO: implement
  }

  PostDeactivated(): void {
      // TODO: implement
  }

  ClearCommands(PageChange: boolean): void {
      // TODO: implement
  }

}
