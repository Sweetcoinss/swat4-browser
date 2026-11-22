// Auto-generated skeleton from UnrealScript: SwatGame/CommandInterfaceDoorRelatedContext.uc
// Parent: PlayerInterfaceDoorRelatedContext

class CommandInterfaceDoorRelatedContext extends PlayerInterfaceDoorRelatedContext {

  // Variables
  CaresAboutPlayerOnExternalSide: boolean;  // config bool
  PlayerIsOnExternalSide: boolean;  // config bool
  CaresAboutCanIssueCommandsFromMySide: boolean;  // config bool
  CanIssueCommandsFromMySide: boolean;  // config bool
  DefaultCommand: any /* commandinterface.ecommand */;  // config CommandInterface.ECommand
  DefaultCommandPriority: number;  // config int
  Command: any /* commandinterface.ecommand */[];  // config array<CommandInterface.ECommand>

  constructor() {
    super();
  }

}
