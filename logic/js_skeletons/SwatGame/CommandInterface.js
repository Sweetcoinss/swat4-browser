// Auto-generated skeleton from UnrealScript: SwatGame/CommandInterface.uc
// Parent: PlayerFocusInterface

class CommandInterface extends PlayerFocusInterface {

  // Variables
  Element: any /* officerteaminfo */;  //  OfficerTeamInfo
  RedTeam: any /* officerteaminfo */;  //  OfficerTeamInfo
  BlueTeam: any /* officerteaminfo */;  //  OfficerTeamInfo
  CurrentCommandTeam: any /* officerteaminfo */;  //  OfficerTeamInfo
  ContextsListClass: any /* class */;  //  Class<CommandInterfaceContextsList>
  MenuInfoClass: any /* class */;  //  Class<CommandInterfaceMenuInfo>
  MenuInfo: any /* commandinterfacemenuinfo */[];  //  array<CommandInterfaceMenuInfo>
  StaticCommandsClass: any /* class */;  // config Class<CommandInterfaceStaticCommands>
  StaticCommands: string[];  //  array<name>
  CommandClass: any /* class */;  //  Class<Command>
  Commands: any /* command */[];  //  array<Command>
  Enabled: boolean;  //  bool
  DefaultCommandEnabled: boolean;  //  bool
  CurrentPage: any /* commandinterface.commandinterfacepage */;  // private CommandInterface.CommandInterfacePage
  CurrentMainPage: any /* commandinterface.commandinterfacepage */;  // private CommandInterface.CommandInterfacePage
  DefaultCommand: any /* command */;  // private Command
  DefaultPriority: number;  // private int
  CurrentOverrideDefaultCommand: any /* command */;  // private Command
  DefaultCommandControl: any /* guidefaultcommandindicator */;  // private export editinline GUIDefaultCommandIndicator
  CurrentMainPageControl: any /* guilabel */;  // private export editinline GUILabel
  Selected: boolean;  // private bool
  PendingCommand: any /* command */;  // private Command
  PendingCommandOrigin: THREE.Vector3;  // private Vector
  PendingCommandTeam: any /* officerteaminfo */;  // private OfficerTeamInfo
  PendingCommandFoci: any /* focus */[];  //  array<Focus>
  PendingCommandFociLength: number;  // private int
  PendingCommandTargetCharacter: any /* swataicharacter */;  // private SwatAICharacter
  ExpectedCommand: string;  //  name
  ExpectedCommandTeam: string;  //  name
  ExpectedCommandTargetDoor: string;  //  name
  ExpectedCommandSource: string;  //  name
  CurrentDoorFocus: any /* swatdoor */;  // private SwatDoor
  LastCommandTeam: any /* officerteaminfo */;  // private OfficerTeamInfo
  CommandSpeechInitialized: boolean;  // private bool
  DebugTerminalLocation: boolean;  // config bool
  LastFocusUpdateOrigin: THREE.Vector3;  //  Vector
  GaveCommandString: string;  //  string
  SometimesSendInterruptedCommand: boolean;  // config bool

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  SetFocusInterfaceType(): void {
      // TODO: implement
  }

  InstantiateCommand(Index: number, InstanceName: string, Command: any /* commandinterface.ecommand */): any /* command */ {
      // TODO: implement
  }

  OnGameStarted(): void {
      // TODO: implement
  }

  Initialize(): void {
      // TODO: implement
  }

  ActivateStaticCommands(): void {
      // TODO: implement
  }

  OnSelectedCommandInterfaceChanged(NewSelected: any /* commandinterface */): void {
      // TODO: implement
  }

  PreUpdateHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): boolean {
      // TODO: implement
  }

  ResetFocusHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): void {
      // TODO: implement
  }

  PostContextMatched(inContext: any /* playerinterfacecontext */, Target: any /* actor */): void {
      // TODO: implement
  }

  PostDoorRelatedContextMatched(inContext: any /* playerinterfacedoorrelatedcontext */, Target: any /* actor */): void {
      // TODO: implement
  }

  PostUpdate(): void {
      // TODO: implement
  }

  SetCurrentTeam(): void {
      // TODO: implement
  }

  SetCurrentTeam(NewTeam: any /* officerteaminfo */): void {
      // TODO: implement
  }

  OnCurrentTeamChanged(NewTeam: any /* officerteaminfo */): void {
      // TODO: implement
  }

  SetCurrentTeam(NewTeam: string): void {
      // TODO: implement
  }

  GetCurrentTeam(): string {
      // TODO: implement
  }

  UpdateFocus(): void {
      // TODO: implement
  }

  SetCurrentPage(NewPage: any /* commandinterface.commandinterfacepage */, Force: boolean): void {
      // TODO: implement
  }

  GetCurrentPage(): any /* commandinterface.commandinterfacepage */ {
      // TODO: implement
  }

  GetCurrentMainPage(): any /* commandinterface.commandinterfacepage */ {
      // TODO: implement
  }

  back(): void {
      // TODO: implement
  }

  NextTeam(): void {
      // TODO: implement
  }

  SetMainPage(Page: any /* commandinterface.commandinterfacepage */): void {
      // TODO: implement
  }

  PreMainPageChanged(): void {
      // TODO: implement
  }

  PostMainPageChanged(): void {
      // TODO: implement
  }

  NextMainPage(): void {
      // TODO: implement
  }

  CheckTeam(): void {
      // TODO: implement
  }

  CurrentTeamHasActiveMembers(): boolean {
      // TODO: implement
  }

  DeActivate(): void {
      // TODO: implement
  }

  PostDeactivated(): void {
      // TODO: implement
  }

  SetCommandStatus(Command: any /* command */, TeamChanged: boolean): void {
      // TODO: implement
  }

  ClearCommands(PageChange: boolean): void {
      // TODO: implement
  }

  ConsiderDefaultCommand(inDefaultCommand: any /* command */, inDefaultPriority: number): void {
      // TODO: implement
  }

  SetExpectedCommand(inExpectedCommand: string, inExpectedCommandTeam: string, inExpectedCommandTargetDoor: string, inExpectedCommandSource: string): void {
      // TODO: implement
  }

  GetColorizedCommandText(Command: any /* command */): string {
      // no body (native/abstract)
  }

  ColorizeExpectedCommand(Command: any /* command */): string {
      // TODO: implement
  }

  GetDefaultCommand(): any /* command */ {
      // TODO: implement
  }

  SetCommand(Command: any /* command */, Status: any /* commandinterface.menupadstatus */): void {
      // TODO: implement
  }

  TeamCanExecuteCommand(Command: any /* command */, Door: any /* swatdoor */): boolean {
      // no body (native/abstract)
  }

  GiveCommand(Command: any /* command */): void {
      // TODO: implement
  }

  FlushPendingCommand(): void {
      // TODO: implement
  }

  GiveCommandSP(): void {
      // TODO: implement
  }

  GiveCommandMP(): void {
      // TODO: implement
  }

  ReceiveCommandMP(CommandIndex: number, Source: any /* actor */, SourceID: string, SourceActorName: string, TargetActor: any /* actor */, TargetID: string, TargetLocation: THREE.Vector3, VoiceType: any /* swatguiconfig.evoicetype */): void {
      // TODO: implement
  }

  CancelGivingCommand(): void {
      // TODO: implement
  }

  ExplicitBeginState(): void {
      // TODO: implement
  }

  StartCommand(): void {
      // TODO: implement
  }

  IsExpectedCommandSource(CommandSource: string): boolean {
      // TODO: implement
  }

  SendCommandToOfficers(): void {
      // TODO: implement
  }

  GetPendingCommandTargetActor(): any /* actor */ {
      // TODO: implement
  }

  GiveDefaultCommand(): void {
      // TODO: implement
  }

  CheckForValidDoor(Command: any /* command */, Door: any /* actor */): boolean {
      // TODO: implement
  }

  CheckForValidPawn(Command: any /* command */, Pawn: any /* actor */): boolean {
      // TODO: implement
  }

  GetPendingFocusOfClass(ClassName: string): any /* actor */ {
      // TODO: implement
  }

  GetExaminableFocus(): any /* actor */ {
      // TODO: implement
  }

  GetUsableFocus(): any /* actor */ {
      // TODO: implement
  }

  GetDoorFocus(PreferOpenDoor: boolean, PreferFarthestDoor: boolean): any /* swatdoor */ {
      // TODO: implement
  }

  GetLastFocusLocation(): THREE.Vector3 {
      // TODO: implement
  }

  OnSpeechCommandRecognized(Rule: string, Value: string, Confidence: any /* speechmanager.speechrecognitionconfidence */): void {
      // TODO: implement
  }

  OnEffectStarted(inStartedEffect: any /* actor */): void {
      // TODO: implement
  }

  OnEffectStopped(inStoppedEffect: any /* actor */, Completed: boolean): void {
      // TODO: implement
  }

  OnEffectInitialized(inInitializedEffect: any /* actor */): void {
      // TODO: implement
  }

  GetPendingFocusString(): string {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  FlushPendingCommand(): void {
      // TODO: implement
  }

  OnEffectStarted(inStartedEffect: any /* actor */): void {
      // TODO: implement
  }

  OnEffectStopped(inStoppedEffect: any /* actor */, Completed: boolean): void {
      // TODO: implement
  }

  OnEffectInitialized(inInitializedEffect: any /* actor */): void {
      // TODO: implement
  }

  OnEffectStarted(inStartedEffect: any /* actor */): void {
      // TODO: implement
  }

  OnEffectStopped(inStoppedEffect: any /* actor */, Completed: boolean): void {
      // TODO: implement
  }

  ExplicitBeginState(): void {
      // TODO: implement
  }

}
