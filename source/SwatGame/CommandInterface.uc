class CommandInterface extends PlayerFocusInterface implements IInterested_GameEvent_GameStarted, ISpeechClient, IEffectObserver
	abstract
	native
	config(PlayerFocusInterface)
	notplaceable
	hidecategories(Karma);

cpptext
{
    virtual UBOOL DoorRelatedContextMatches(UPlayerInterfaceDoorRelatedContext* DoorRelatedContext, ASwatDoor* Door);
    virtual UBOOL ContextMatches(UPlayerInterfaceContext* inContext, AActor* Candidate);
    FString GetColorizedCommandText(UCommand* Command);

}

enum CommandInterfacePage
{
	Page_None,                      // 0
	Page_Command,                   // 1
	Page_Deploy,                    // 2
	Page_Response,                  // 3
	Page_RapidDeployment,           // 4
	Page_VIPEscort,                 // 5
	Page_General                    // 6
};

enum MenuPadStatus
{
	Pad_Normal,                     // 0
	Pad_GreyedOut,                  // 1
	Pad_Disabled                    // 2
};

enum ECommand
{
	Command_None,                   // 0
	Command_Command,                // 1
	Command_Deploy,                 // 2
	Command_StackUpAndTryDoor,      // 3
	Command_PickLock,               // 4
	Command_MoveAndClear,           // 5
	Command_BreachAndClear,         // 6
	Command_BreachAndMakeEntry,     // 7
	Command_OpenAndClear,           // 8
	Command_OpenAndMakeEntry,       // 9
	Command_BangAndClear,           // 10
	Command_BreachBangAndClear,     // 11
	Command_BreachBangAndMakeEntry, // 12
	Command_OpenBangAndClear,       // 13
	Command_OpenBangAndMakeEntry,   // 14
	Command_GasAndClear,            // 15
	Command_BreachGasAndClear,      // 16
	Command_BreachGasAndMakeEntry,  // 17
	Command_OpenGasAndClear,        // 18
	Command_OpenGasAndMakeEntry,    // 19
	Command_StingAndClear,          // 20
	Command_BreachStingAndClear,    // 21
	Command_BreachStingAndMakeEntry,// 22
	Command_OpenStingAndClear,      // 23
	Command_OpenStingAndMakeEntry,  // 24
	Command_FallIn,                 // 25
	Command_MoveTo,                 // 26
	Command_Cover,                  // 27
	Command_Disable,                // 28
	Command_DisableBomb,            // 29
	Command_DisableBoobyTrap,       // 30
	Command_CloseDoor,              // 31
	Command_RemoveWedge,            // 32
	Command_SecureEvidence,         // 33
	Command_Restrain,               // 34
	Command_MirrorRoom,             // 35
	Command_MirrorUnderDoor,        // 36
	Command_MirrorCorner,           // 37
	Command_Report,                 // 38
	Command_Deploy_Wedge,           // 39
	Command_Deploy_BreachingShotgun,// 40
	Command_Deploy_LessLethalShotgun,// 41
	Command_Deploy_Taser,           // 42
	Command_Deploy_Flashbang,       // 43
	Command_Deploy_CSGas,           // 44
	Command_Deploy_StingGrenade,    // 45
	Command_Deploy_PepperSpray,     // 46
	Command_Deploy_C2Charge,        // 47
	Command_Deploy_CSBallLauncher,  // 48
	Command_Static                  // 49
};

var OfficerTeamInfo Element;
var OfficerTeamInfo RedTeam;
var OfficerTeamInfo BlueTeam;
var OfficerTeamInfo CurrentCommandTeam;
var Class<CommandInterfaceContextsList> ContextsListClass;
var Class<CommandInterfaceMenuInfo> MenuInfoClass;
var array<CommandInterfaceMenuInfo> MenuInfo;
var config Class<CommandInterfaceStaticCommands> StaticCommandsClass;
var array<name> StaticCommands;
var Class<Command> CommandClass;
var array<Command> Commands;
var bool Enabled;
var bool DefaultCommandEnabled;
var private CommandInterface.CommandInterfacePage CurrentPage;
var private CommandInterface.CommandInterfacePage CurrentMainPage;
var private Command DefaultCommand;
var private int DefaultPriority;
var private Command CurrentOverrideDefaultCommand;
var private export editinline GUIDefaultCommandIndicator DefaultCommandControl;
var private export editinline GUILabel CurrentMainPageControl;
var private bool Selected;
var private Command PendingCommand;
var private Vector PendingCommandOrigin;
var private OfficerTeamInfo PendingCommandTeam;
var array<Focus> PendingCommandFoci;
var private int PendingCommandFociLength;
var private SwatAICharacter PendingCommandTargetCharacter;
var name ExpectedCommand;
var name ExpectedCommandTeam;
var name ExpectedCommandTargetDoor;
var name ExpectedCommandSource;
var private SwatDoor CurrentDoorFocus;
var private OfficerTeamInfo LastCommandTeam;
var private bool CommandSpeechInitialized;
var config bool DebugTerminalLocation;
var Vector LastFocusUpdateOrigin;
var string GaveCommandString;
var config bool SometimesSendInterruptedCommand;

simulated function PreBeginPlay()
{
	local int i;
	local CommandInterfaceContextsList ContextsList;
	local CommandInterfaceStaticCommands StaticCommandsList;

	super(Actor).PreBeginPlay();
	CurrentPage = 1;
	SetMainPage(1);
	ContextsList = ContextsListClass.static.Allocate(self, none).;
	Construct_Void();
	assert(NotEqual_ObjectObject(ContextsList, none));
	i = 0;
	J0x4A:

	if(Less_IntInt(i, ContextsList.Context.Length))
	{
		Context[i] = ContextsList.Context[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x4A;
	}
	i = 0;
	J0x94:

	if(Less_IntInt(i, ContextsList.DoorRelatedContext.Length))
	{
		DoorRelatedContext[i] = ContextsList.DoorRelatedContext[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x94;
	}
	StaticCommandsList = StaticCommandsClass.static.Allocate(self, none).;
	Construct_Void();
	assert(NotEqual_ObjectObject(StaticCommandsList, none));
	i = 0;
	J0x10B:

	if(Less_IntInt(i, StaticCommandsList.StaticCommand.Length))
	{
		StaticCommands[i] = StaticCommandsList.StaticCommand[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x10B;
	}
	i = 1;
	J0x155:

	if(Less_IntInt(i, int(7)))
	{
		MenuInfo[i] = MenuInfoClass.static.Allocate(self, none, string(GetEnum(Enum'SwatGame.CommandInterface.CommandInterfacePage', i))).;
		Construct_Void();
		assert(NotEqual_ObjectObject(MenuInfo[i], none));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x155;
	}
	return;
}

simulated function PostBeginPlay()
{
	local int i, j, NumDynamicCommands;
	local Command NewCommand;

	super.PostBeginPlay();
	Label = 'CommandInterface';
	assert(NotEqual_ObjectObject(CommandClass, none));
	NumDynamicCommands = int(50);
	i = 0;
	J0x2D:

	if(Less_IntInt(i, int(49)))
	{
		NewCommand = InstantiateCommand(i, GetEnum(Enum'SwatGame.CommandInterface.ECommand', i), byte(i));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2D;
	}
	i = 0;
	J0x74:

	if(Less_IntInt(i, StaticCommands.Length))
	{
		NewCommand = InstantiateCommand(Add_IntInt(NumDynamicCommands, i), StaticCommands[i], 49);
		NewCommand.bStatic = true;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x74;
	}
	i = 1;
	J0xCB:

	if(Less_IntInt(i, int(7)))
	{
		if(NotEqual_NameName(MenuInfo[i].OverrideDefaultCommand, 'None'))
		{
			j = 0;
			J0xFE:

			if(Less_IntInt(j, Commands.Length))
			{
				if(AndAnd_BoolBool(NotEqual_ObjectObject(Commands[j], none), EqualEqual_NameName(Commands[j].Name, MenuInfo[i].OverrideDefaultCommand)))
				{
					MenuInfo[i].OverrideDefaultCommandObject = Commands[j];
				}
				AddAdd_PreInt(j);
				// [Loop Continue]
				goto J0xFE;
			}
			AssertWithDescription(NotEqual_ObjectObject(MenuInfo[i].OverrideDefaultCommandObject, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The OverrideDefaultCommand ", string(MenuInfo[i].OverrideDefaultCommand)), " specified for the CommandInterface menu named "), string(MenuInfo[i].Name)), " is not a valid command name.  Please fix this in CommandInterfaceMenus_MP/SP.ini"));
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xCB;
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Element = SwatAIRepository(Level.AIRepo).GetElementSquad();
		RedTeam = SwatAIRepository(Level.AIRepo).GetRedSquad();
		BlueTeam = SwatAIRepository(Level.AIRepo).GetBlueSquad();
	}
	SetCurrentTeam_OfficerTeamInfo(Element);
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		SwatGameInfo(Level.Game).GameEvents.GameStarted.Register(self);
	}
	else
	{
		Initialize();
	}
	return;
}

simulated function SetFocusInterfaceType()
{
	FocusInterfaceType = 'CommandInterface';
	return;
}

simulated function Command InstantiateCommand(int Index, name InstanceName, CommandInterface.ECommand Command)
{
	local Command NewCommand;

	NewCommand = CommandClass.static.Allocate(self, none, string(InstanceName)).;
	Construct_Void();
	assert(NotEqual_ObjectObject(NewCommand, none));
	Commands[Index] = NewCommand;
	NewCommand.Index = Index;
	AssertWithDescription(OrOr_BoolBool(NotEqual_IntInt(int(NewCommand.Page), int(0)), EqualEqual_IntInt(int(NewCommand.Command), int(0))), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Class.Name)), "::InstantiateCommand() There is no Page specified for "), string(InstanceName)), ".  Check that the config file contains a specification for this Command."));
	NewCommand.Command = Command;
	if(NotEqual_IntInt(int(NewCommand.SubPage), int(0)))
	{
		NewCommand.bStatic = true;
	}
	return NewCommand;
	return;
}

simulated function OnGameStarted()
{
	Initialize();
	return;
}

simulated function Initialize()
{
	local SwatGamePlayerController Player;

	Player = SwatGamePlayerController(Level.GetLocalPlayerController());
	assert(NotEqual_ObjectObject(Player, none));
	DefaultCommandControl = Player.GetHUDPage().DefaultCommand;
	assert(NotEqual_ObjectObject(DefaultCommandControl, none));
	CurrentMainPageControl = Player.GetHUDPage().CommandInterfaceMenuPage;
	assert(NotEqual_ObjectObject(CurrentMainPageControl, none));
	SetMainPage(CurrentMainPage);
	Player.UpdateFocus();
	CheckTeam();
	DefaultCommandControl.OnCurrentTeamChanged(CurrentCommandTeam);
	ActivateStaticCommands();
	return;
}

simulated function ActivateStaticCommands()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Commands.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Commands[i], none), Commands[i].bStatic))
		{
			SetCommandStatus(Commands[i]);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated function OnSelectedCommandInterfaceChanged(CommandInterface NewSelected)
{
	Selected = EqualEqual_ObjectObject(NewSelected, self);
	SetCurrentTeam_OfficerTeamInfo(CurrentCommandTeam);
	return;
}

protected simulated function bool PreUpdateHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	local bool Result;

	Result = AndAnd_BoolBool(Enabled, EqualEqual_ObjectObject(Player.GetCommandInterface(), self));
	return Result;
	return;
}

protected simulated function ResetFocusHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	if(EqualEqual_ObjectObject(CurrentOverrideDefaultCommand, none))
	{
		DefaultCommand = Commands[int(25)];
		DefaultPriority = -1;
	}
	else
	{
		if(NotEqual_ObjectObject(DefaultCommand, CurrentOverrideDefaultCommand))
		{
			DefaultCommand = CurrentOverrideDefaultCommand;
			DefaultCommandControl.SetCaption(GetColorizedCommandText(DefaultCommand));
		}
	}
	CurrentDoorFocus = none;
	ClearCommands(false);
	LastFocusUpdateOrigin = SwatGamePlayerController(Level.GetLocalPlayerController()).LastFocusUpdateOrigin;
	return;
}

protected simulated event PostContextMatched(PlayerInterfaceContext inContext, Actor Target)
{
	local CommandInterfaceContext Context;
	local int i;

	Context = CommandInterfaceContext(inContext);
	i = 0;
	J0x17:

	if(Less_IntInt(i, Context.Command.Length))
	{
		SetCommandStatus(Commands[int(Context.Command[i])]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x17;
	}
	if(NotEqual_IntInt(int(Context.DefaultCommand), int(0)))
	{
		ConsiderDefaultCommand(Commands[int(Context.DefaultCommand)], byte(Context.DefaultCommandPriority));
	}
	return;
}

protected simulated event PostDoorRelatedContextMatched(PlayerInterfaceDoorRelatedContext inContext, Actor Target)
{
	local CommandInterfaceDoorRelatedContext Context;
	local int i;

	CurrentDoorFocus = SwatDoor(Target);
	assert(NotEqual_ObjectObject(CurrentDoorFocus, none));
	Context = CommandInterfaceDoorRelatedContext(inContext);
	i = 0;
	J0x32:

	if(Less_IntInt(i, Context.Command.Length))
	{
		SetCommandStatus(Commands[int(Context.Command[i])]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x32;
	}
	if(NotEqual_IntInt(int(Context.DefaultCommand), int(0)))
	{
		ConsiderDefaultCommand(Commands[int(Context.DefaultCommand)], byte(Context.DefaultCommandPriority));
	}
	return;
}

simulated function PostUpdate()
{
	return;
}

overloaded function SetCurrentTeam()
{
	return;
}

final overloaded simulated function SetCurrentTeam(OfficerTeamInfo NewTeam)
{
	if(NotEqual_ObjectObject(NewTeam, CurrentCommandTeam))
	{
		CurrentCommandTeam = NewTeam;
		if(NotEqual_ObjectObject(DefaultCommandControl, none))
		{
			DefaultCommandControl.OnCurrentTeamChanged(NewTeam);
		}
		OnCurrentTeamChanged(NewTeam);
	}
	return;
}

protected simulated function OnCurrentTeamChanged(OfficerTeamInfo NewTeam)
{
	return;
}

final overloaded simulated function SetCurrentTeam(name NewTeam)
{
	switch(NewTeam)
	{
		case 'RedTeam':
			SetCurrentTeam_OfficerTeamInfo(RedTeam);
			break;
		case 'BlueTeam':
			SetCurrentTeam_OfficerTeamInfo(BlueTeam);
			break;
		case 'Element':
			SetCurrentTeam_OfficerTeamInfo(Element);
			break;
		default:
			assert(false);
			break;
	}
	CheckTeam();
	return;
}

final simulated function name GetCurrentTeam()
{
	switch(CurrentCommandTeam)
	{
		case RedTeam:
			return 'RedTeam';
		case BlueTeam:
			return 'BlueTeam';
		case Element:
			return 'Element';
		default:
			assert(false);
			return;
			break;
	}
}

final simulated function UpdateFocus()
{
	SwatGamePlayerController(Level.GetLocalPlayerController()).UpdateFocus();
	return;
}

simulated function SetCurrentPage(CommandInterface.CommandInterfacePage NewPage, optional bool Force)
{
	return;
}

simulated function CommandInterface.CommandInterfacePage GetCurrentPage()
{
	return CurrentPage;
	return;
}

simulated function CommandInterface.CommandInterfacePage GetCurrentMainPage()
{
	return CurrentMainPage;
	return;
}

simulated function back()
{
	if(NotEqual_IntInt(int(CurrentPage), int(CurrentMainPage)))
	{
		SetCurrentPage(CurrentMainPage);
	}
	return;
}

simulated function NextTeam()
{
	if(EqualEqual_ObjectObject(CurrentCommandTeam, Element))
	{
		SetCurrentTeam_OfficerTeamInfo(RedTeam);
	}
	else
	{
		if(EqualEqual_ObjectObject(CurrentCommandTeam, RedTeam))
		{
			SetCurrentTeam_OfficerTeamInfo(BlueTeam);
		}
		else
		{
			if(EqualEqual_ObjectObject(CurrentCommandTeam, BlueTeam))
			{
				SetCurrentTeam_OfficerTeamInfo(Element);
			}
			else
			{
				AssertWithDescription(false, "[tcohen] CommandInterface::NextTeam() CurrentCommandTeam isn't Red, Blue, or Element.");
			}
		}
	}
	CheckTeam();
	return;
}

final simulated function SetMainPage(CommandInterface.CommandInterfacePage Page)
{
	PreMainPageChanged();
	CurrentMainPage = Page;
	if(Less_IntInt(int(CurrentMainPage), MenuInfo.Length))
	{
		if(NotEqual_ObjectObject(CurrentMainPageControl, none))
		{
			CurrentMainPageControl.SetCaption(MenuInfo[int(Page)].Text);
		}
		CurrentOverrideDefaultCommand = MenuInfo[int(CurrentMainPage)].OverrideDefaultCommandObject;
	}
	SwatGamePlayerController(Level.GetLocalPlayerController()).UpdateFocus();
	PostMainPageChanged();
	return;
}

protected simulated function PreMainPageChanged()
{
	return;
}

protected simulated function PostMainPageChanged()
{
	return;
}

final simulated function NextMainPage()
{
	local int CurrentMainPageIndex;
	local bool FoundNextMainPage;

	CurrentMainPageIndex = int(CurrentMainPage);
	FoundNextMainPage = false;
	J0x15:

	if(Not_PreBool(FoundNextMainPage))
	{
		AddAdd_Int(CurrentMainPageIndex);
		if(GreaterEqual_IntInt(CurrentMainPageIndex, int(7)))
		{
			CurrentMainPageIndex = 1;
		}
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(MenuInfo[CurrentMainPageIndex].AnchorCommand), int(0)), MenuInfo[CurrentMainPageIndex].IsAvailable(Level)))
		{
			FoundNextMainPage = true;
		}
		// [Loop Continue]
		goto J0x15;
	}
	SetMainPage(byte(CurrentMainPageIndex));
	return;
}

simulated function CheckTeam()
{
	local bool RedHasMembers, BlueHasMembers;

	if(Not_PreBool(Element.hasActiveMembers()))
	{
		DeActivate();
	}
	else
	{
		RedHasMembers = RedTeam.hasActiveMembers();
		BlueHasMembers = BlueTeam.hasActiveMembers();
		if(Not_PreBool(RedHasMembers))
		{
			SetCurrentTeam_OfficerTeamInfo(BlueTeam);
		}
		else
		{
			if(Not_PreBool(BlueHasMembers))
			{
				SetCurrentTeam_OfficerTeamInfo(RedTeam);
			}
		}
	}
	return;
}

simulated function bool CurrentTeamHasActiveMembers()
{
	return CurrentCommandTeam.hasActiveMembers();
	return;
}

final simulated function DeActivate()
{
	Enabled = false;
	DefaultCommandControl.Hide();
	PostDeactivated();
	return;
}

protected simulated function PostDeactivated()
{
	return;
}

simulated function SetCommandStatus(Command Command, optional bool TeamChanged)
{
	local CommandInterface.MenuPadStatus Status;

	if(EqualEqual_ObjectObject(Command, none))
	{
		return;
	}
	if(OrOr_BoolBool(OrOr_BoolBool(Command.IsCancel, NotEqual_IntInt(int(Command.SubPage), int(0))), TeamCanExecuteCommand(Command, CurrentDoorFocus)))
	{
		Status = 0;
	}
	else
	{
		Status = 1;
	}
	SetCommand(Command, Status);
	return;
}

simulated function ClearCommands(bool PageChange)
{
	return;
}

final simulated function ConsiderDefaultCommand(Command inDefaultCommand, byte inDefaultPriority)
{
	if(NotEqual_ObjectObject(CurrentOverrideDefaultCommand, none))
	{
		return;
	}
	if(AndAnd_BoolBool(Greater_IntInt(int(inDefaultPriority), DefaultPriority), TeamCanExecuteCommand(inDefaultCommand, CurrentDoorFocus)))
	{
		DefaultCommand = inDefaultCommand;
		DefaultPriority = int(inDefaultPriority);
		DefaultCommandControl.SetCaption(GetColorizedCommandText(DefaultCommand));
	}
	return;
}

function SetExpectedCommand(name inExpectedCommand, name inExpectedCommandTeam, name inExpectedCommandTargetDoor, name inExpectedCommandSource)
{
	local name PreviousExpectedCommand;
	local int i;

	PreviousExpectedCommand = ExpectedCommand;
	ExpectedCommand = inExpectedCommand;
	ExpectedCommandTeam = inExpectedCommandTeam;
	ExpectedCommandTargetDoor = inExpectedCommandTargetDoor;
	ExpectedCommandSource = inExpectedCommandSource;
	i = 0;
	J0x3E:

	if(Less_IntInt(i, Commands.Length))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Commands[i], none), Commands[i].bStatic), OrOr_BoolBool(EqualEqual_NameName(Commands[i].Name, ExpectedCommand), EqualEqual_NameName(Commands[i].Name, PreviousExpectedCommand))))
		{
			SetCommandStatus(Commands[i]);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x3E;
	}
	DefaultCommandControl.SetCaption(GetColorizedCommandText(DefaultCommand));
	return;
}

// Export UCommandInterface::execGetColorizedCommandText(FFrame&, void* const)
native final function string GetColorizedCommandText(Command Command);

final simulated event string ColorizeExpectedCommand(Command Command)
{
	switch(ExpectedCommandTeam)
	{
		case 'Element':
			return Concat_StrStr(Concat_StrStr("[c=FFC800][b]", Command.Text), "[\\b][\\c]");
		case 'RedTeam':
			return Concat_StrStr(Concat_StrStr("[c=800000][b]", Command.Text), "[\\b][\\c]");
		case 'BlueTeam':
			return Concat_StrStr(Concat_StrStr("[c=0000af][b]", Command.Text), "[\\b][\\c]");
		default:
			return Concat_StrStr(Concat_StrStr("[c=00af00][b]", Command.Text), "[\\b][\\c]");
			break;
	}
	return;
}

final simulated function Command GetDefaultCommand()
{
	return DefaultCommand;
	return;
}

simulated function SetCommand(Command Command, CommandInterface.MenuPadStatus Status)
{
	return;
}

// Export UCommandInterface::execTeamCanExecuteCommand(FFrame&, void* const)
native final function bool TeamCanExecuteCommand(Command Command, optional SwatDoor Door);

simulated function GiveCommand(Command Command)
{
	local SwatGamePlayerController Player;
	local ExternalViewportManager ExternalViewportManager;
	local IControllableThroughViewport Controllable;
	local Actor OriginActor;

	if(Command.IsCancel)
	{
		CancelGivingCommand();
		return;
	}
	if(NotEqual_IntInt(int(Command.SubPage), int(0)))
	{
		SetCurrentPage(Command.SubPage);
		return;
	}
	Player = SwatGamePlayerController(Level.GetLocalPlayerController());
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Player.Pawn, none), Player.Pawn.checkDead(Player.Pawn)))
	{
		return;
	}
	FlushPendingCommand();
	ExternalViewportManager = Player.GetExternalViewportManager();
	if(EqualEqual_ObjectObject(Player.ActiveViewport, ExternalViewportManager))
	{
		Controllable = ExternalViewportManager.GetCurrentControllable();
		OriginActor = Actor(Controllable);
		assert(NotEqual_ObjectObject(Controllable, none));
		PendingCommandOrigin = ExternalViewportManager.GetCurrentControllable().GetViewportLocation();
	}
	else
	{
		OriginActor = Player.Pawn;
		PendingCommandOrigin = LastFocusUpdateOrigin;
	}
	PendingCommand = Command;
	PendingCommandTeam = CurrentCommandTeam;
	PendingCommandFoci = Foci;
	PendingCommandFociLength = FociLength;
	PendingCommandTargetCharacter = SwatAICharacter(GetFocusOfClass('SwatAICharacter'));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", Player began to give "), string(Command.Name)), " through "), string(OriginActor.Name)), " from ("), string(PendingCommandOrigin)), ") to "), string(CurrentCommandTeam)), ".  Focus: "), GetPendingFocusString()));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		GiveCommandSP();
	}
	else
	{
		GiveCommandMP();
	}
	return;
}

function FlushPendingCommand()
{
	return;
}

simulated function GiveCommandSP()
{
	switch(PendingCommand.EffectEvent)
	{
		case 'None':
			AssertWithDescription(false, Concat_StrStr("[COMMAND INTERFACE SPEECH] The EffectEvent is missing for the given Command ", string(PendingCommand.Name)));
			break;
		default:
			if(EqualEqual_ObjectObject(CurrentCommandTeam, LastCommandTeam))
			{
				GotoState('SpeakingCommand');
				ExplicitBeginState();
			}
			else
			{
				StartCommand();
			}
			break;
	}
	return;
}

simulated function GiveCommandMP()
{
	local Actor PendingCommandTargetActor;
	local Vector PendingCommandTargetLocation;
	local SwatGUIConfig.eVoiceType VoiceType;
	local string SourceID, TargetID;

	PendingCommandTargetActor = GetPendingCommandTargetActor();
	if(NotEqual_ObjectObject(PendingCommandTargetActor, none))
	{
		PendingCommandTargetLocation = PendingCommandTargetActor.Location;
	}
	else
	{
		PendingCommandTargetLocation = GetLastFocusLocation();
	}
	if(NotEqual_ObjectObject(NetPlayer(PlayerPawn), none))
	{
		if(NetPlayer(PlayerPawn).IsTheVIP())
		{
			VoiceType = 6;
		}
		else
		{
			VoiceType = NetPlayer(PlayerPawn).VoiceType;
		}
	}
	SourceID = PlayerPawn.UniqueID();
	if(NotEqual_ObjectObject(PendingCommandTargetActor, none))
	{
		TargetID = PendingCommandTargetActor.UniqueID();
	}
	if(PlayerController.CanIssueCommand())
	{
		PlayerController.StartIssueCommandTimer();
		PlayerController.ServerGiveCommand(PendingCommand.Index, Command_MP(PendingCommand).IsTaunt, PlayerPawn, SourceID, PendingCommandTargetActor, TargetID, PendingCommandTargetLocation, VoiceType);
		ReceiveCommandMP(PendingCommand.Index, PlayerPawn, SourceID, PlayerController.GetHumanReadableName(), PendingCommandTargetActor, TargetID, PendingCommandTargetLocation, VoiceType);
	}
	return;
}

simulated function ReceiveCommandMP(int CommandIndex, Actor Source, string SourceID, string SourceActorName, Actor TargetActor, string TargetID, Vector TargetLocation, SwatGUIConfig.eVoiceType VoiceType)
{
	local Actor SourceOfSound;
	local name VoiceTag;

	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Source, none), NotEqual_StrStr(SourceID, "")))
	{
		Source = FindByUniqueID(none, SourceID);
	}
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(TargetActor, none), NotEqual_StrStr(TargetID, "")))
	{
		TargetActor = FindByUniqueID(none, TargetID);
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("TMC CommandInterface::ReceiveCommandMP() received the command ", string(Commands[CommandIndex].Name)), ", Source="), string(Source)), ", TargetActor="), string(TargetActor)), ", TargetLocation="), string(TargetLocation)), ", VoiceType="), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eVoiceType', int(VoiceType)))), ", Command_MP(Commands[CommandIndex]).ArrowLifetime = "), string(Command_MP(Commands[CommandIndex]).ArrowLifetime)));
	if(Command_MP(Commands[CommandIndex]).IsTaunt)
	{
		SourceOfSound = Source;
	}
	else
	{
		SourceOfSound = PlayerPawn;
	}
	VoiceTag = SwatRepo(Level.GetRepo()).GuiConfig.GetTagForVoiceType(VoiceType);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(TargetActor, none), TargetActor.IsA('SwatPawn')))
	{
		if(AndAnd_BoolBool(TargetActor.IsA('SwatAICharacter'), SwatAICharacter(TargetActor).IsFemale()))
		{
			AddContextForNextEffectEvent('Female');
		}
		else
		{
			AddContextForNextEffectEvent('Male');
		}
		if(TargetActor.IsA('SwatHostage'))
		{
			AddContextForNextEffectEvent('Civilian');
		}
		else
		{
			AddContextForNextEffectEvent('Suspect');
		}
	}
	if(NotEqual_ObjectObject(SourceOfSound, none))
	{
		SourceOfSound.TriggerEffectEvent(Commands[CommandIndex].EffectEvent,,,,,,,, VoiceTag);
	}
	PlayerController.ClientMessage(Concat_StrStr(Concat_StrStr(Concat_StrStr("[c=FFC800][b]", SourceActorName), GaveCommandString), Commands[CommandIndex].Text), 'CommandGiven');
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Source, none), Greater_FloatFloat(Command_MP(Commands[CommandIndex]).ArrowLifetime, 0.0000000)))
	{
		assert(Source.IsA('SwatPlayer'));
		SwatPlayer(Source).ShowCommandArrow(Command_MP(Commands[CommandIndex]).ArrowLifetime, Source, TargetActor, Source.Location, TargetLocation, OrOr_BoolBool(Command_MP(Commands[CommandIndex]).IsTaunt, Command_MP(Commands[CommandIndex]).TargetIsSelf));
	}
	return;
}

simulated function CancelGivingCommand()
{
	return;
}

function ExplicitBeginState()
{
	AssertWithDescription(false, "[tcohen] CommandInterface::ExplicitBeginState() was called in the Global state.  This should only (and always) be called immediately after calling GotoState('SpeakingCommand').");
	return;
}

function StartCommand()
{
	GotoState('None');
	if(EqualEqual_ObjectObject(PendingCommandTeam, Element))
	{
		Level.GetLocalPlayerController().Pawn.TriggerEffectEvent('OrderedElement',,,,,,, self);
	}
	else
	{
		if(EqualEqual_ObjectObject(PendingCommandTeam, RedTeam))
		{
			Level.GetLocalPlayerController().Pawn.TriggerEffectEvent('OrderedRed',,,,,,, self);
		}
		else
		{
			if(EqualEqual_ObjectObject(PendingCommandTeam, BlueTeam))
			{
				Level.GetLocalPlayerController().Pawn.TriggerEffectEvent('OrderedBlue',,,,,,, self);
			}
			else
			{
				AssertWithDescription(false, "[tcohen] CommandInterface::SpeakTeam() PendingCommandTeam isn't Red, Blue, or Element.");
			}
		}
	}
	GotoState('SpeakingTeam');
	return;
}

simulated function bool IsExpectedCommandSource(name CommandSource)
{
	if(EqualEqual_NameName(ExpectedCommandSource, 'RedTeam'))
	{
		return OrOr_BoolBool(EqualEqual_NameName(CommandSource, 'OfficerRedOne'), EqualEqual_NameName(CommandSource, 'OfficerRedTwo'));
	}
	if(EqualEqual_NameName(ExpectedCommandSource, 'BlueTeam'))
	{
		return OrOr_BoolBool(EqualEqual_NameName(CommandSource, 'OfficerBlueOne'), EqualEqual_NameName(CommandSource, 'OfficerBlueTwo'));
	}
	return EqualEqual_NameName(CommandSource, ExpectedCommandSource);
	return;
}

simulated function SendCommandToOfficers()
{
	local Actor PendingCommandTargetActor;
	local name LastFocusSource;

	PendingCommandTargetActor = GetPendingCommandTargetActor();
	if(EqualEqual_ObjectObject(Level.GetLocalPlayerController().Pawn, none))
	{
		Log(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", ...          in SendCommandToOfficers(), Level.GetLocalPlayerController().Pawn is none"));
		return;
	}
	LastFocusSource = SwatGamePlayerController(Level.GetLocalPlayerController()).GetLastFocusSource();
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(AndAnd_BoolBool(NotEqual_NameName(ExpectedCommand, 'None'), NotEqual_NameName(PendingCommand.Name, ExpectedCommand)), AndAnd_BoolBool(NotEqual_NameName(ExpectedCommandTeam, 'None'), NotEqual_NameName(PendingCommandTeam.Label, ExpectedCommandTeam))), AndAnd_BoolBool(NotEqual_NameName(ExpectedCommandTargetDoor, 'None'), OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(PendingCommandTargetActor, none), Not_PreBool(PendingCommandTargetActor.IsA('SwatDoor'))), NotEqual_NameName(PendingCommandTargetActor.Label, ExpectedCommandTargetDoor)))), AndAnd_BoolBool(NotEqual_NameName(ExpectedCommandSource, 'None'), Not_PreBool(IsExpectedCommandSource(LastFocusSource)))))
	{
		dispatchMessage(Class'SwatGame.MessageUnexpectedCommandGiven'.static.Allocate(self)., construct_NameNameNameNameNameNameNameName(ExpectedCommand, ExpectedCommandTeam, ExpectedCommandTargetDoor, ExpectedCommandSource, PendingCommand.Name, PendingCommandTeam.Name, PendingCommandTargetActor.Name, LastFocusSource));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", ...          sent MessageUnexpectedCommandGiven:"), "  ExpectedCommand="), string(ExpectedCommand)), ", PendingCommand.name="), string(PendingCommand.Name)), "."), "  ExpectedCommandTeam="), string(ExpectedCommandTeam)), ", PendingCommandTeam.name="), string(PendingCommandTeam.Name)), "."), "  PendingCommandTargetActor.class="), string(PendingCommandTargetActor.Class.Name)), ", PendingCommandTargetActor.name="), string(PendingCommandTargetActor.Name)), "."), ". Focus: "), GetPendingFocusString()));
		return;
	}
	AssertWithDescription(NotEqual_ObjectObject(PendingCommand, none), "[tcohen] CommandInterface::SendCommandToOfficers() was called with PendingCommand=None");
	if(NotEqual_ObjectObject(PendingCommandTargetActor, none))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", ...          sending "), string(PendingCommand.Name)), " to "), string(PendingCommandTeam.Class.Name)), ". Focus: "), GetPendingFocusString()), "  PendingCommandTargetActor.class="), string(PendingCommandTargetActor.Class.Name)), ", PendingCommandTargetActor.name="), string(PendingCommandTargetActor.Name)), "."));
	}
	else
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", ...          sending "), string(PendingCommand.Name)), " to "), string(PendingCommandTeam.Class.Name)), ". Focus: "), GetPendingFocusString()), "  PendingCommandTargetActor=None."));
	}
	switch(PendingCommand.Command)
	{
		case 25:
			PendingCommandTeam.FallIn(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin);
			break;
		case 26:
			PendingCommandTeam.MoveTo(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, GetLastFocusLocation());
			break;
		case 27:
			PendingCommandTeam.Cover(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, GetLastFocusLocation());
			break;
		case 43:
			PendingCommandTeam.DeployThrownItemAt(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, 3, GetLastFocusLocation(), SwatDoor(PendingCommandTargetActor));
			back();
			break;
		case 44:
			PendingCommandTeam.DeployThrownItemAt(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, 4, GetLastFocusLocation(), SwatDoor(PendingCommandTargetActor));
			back();
			break;
		case 45:
			PendingCommandTeam.DeployThrownItemAt(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, 5, GetLastFocusLocation(), SwatDoor(PendingCommandTargetActor));
			back();
			break;
		case 28:
			if(NotEqual_ObjectObject(PendingCommandTargetActor, none))
			{
				PendingCommandTeam.DisableTarget(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, PendingCommandTargetActor);
			}
			break;
		case 32:
			PendingCommandTeam.RemoveWedge(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			break;
		case 33:
			if(NotEqual_ObjectObject(PendingCommandTargetActor, none))
			{
				PendingCommandTeam.SecureEvidence(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, PendingCommandTargetActor);
			}
			break;
		case 37:
			if(NotEqual_ObjectObject(PendingCommandTargetActor, none))
			{
				PendingCommandTeam.MirrorCorner(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, PendingCommandTargetActor);
			}
			break;
		case 3:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.StackUpAndTryDoorAt(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 4:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.PickLock(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 5:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.MoveAndClear(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 6:
		case 7:
		case 8:
		case 9:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.BreachAndClear(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 10:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.BangAndClear(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 11:
		case 12:
		case 13:
		case 14:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.BreachBangAndClear(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 15:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.GasAndClear(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 16:
		case 17:
		case 18:
		case 19:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.BreachGasAndClear(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 20:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.StingAndClear(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 21:
		case 22:
		case 23:
		case 24:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.BreachStingAndClear(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 47:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.DeployC2(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			back();
			break;
		case 40:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.DeployShotgun(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			back();
			break;
		case 39:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.DeployWedge(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			back();
			break;
		case 31:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.CloseDoor(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 35:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.MirrorRoom(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 36:
			if(CheckForValidDoor(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.MirrorUnderDoor(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, SwatDoor(PendingCommandTargetActor));
			}
			break;
		case 34:
			if(CheckForValidPawn(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.Restrain(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, Pawn(PendingCommandTargetActor));
			}
			break;
		case 46:
			if(CheckForValidPawn(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.DeployPepperSpray(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, Pawn(PendingCommandTargetActor));
				back();
			}
			break;
		case 42:
			if(CheckForValidPawn(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.DeployTaser(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, Pawn(PendingCommandTargetActor));
				back();
			}
			break;
		case 41:
			if(CheckForValidPawn(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.DeployLessLethalShotgun(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, Pawn(PendingCommandTargetActor));
				back();
			}
			break;
		case 48:
			if(CheckForValidPawn(PendingCommand, PendingCommandTargetActor))
			{
				PendingCommandTeam.DeployPepperBallGun(Level.GetLocalPlayerController().Pawn, PendingCommandOrigin, Pawn(PendingCommandTargetActor));
				back();
			}
			break;
		default:
			AssertWithDescription(false, Concat_StrStr("[tcohen] CommandInterface::SendCommandToOfficers() Unexpected command ", string(GetEnum(Enum'SwatGame.CommandInterface.ECommand', int(PendingCommand.Command)))));
			return;
			break;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingCommandTargetActor, none), PendingCommandTargetActor.IsA('SwatDoor')))
	{
		dispatchMessage(Class'SwatGame.MessageCommandGiven'.static.Allocate(self)., construct_NameNameName(PendingCommand.Name, PendingCommandTeam.Label, PendingCommandTargetActor.Label));
	}
	else
	{
		dispatchMessage(Class'SwatGame.MessageCommandGiven'.static.Allocate(self)., construct_NameNameName(PendingCommand.Name, PendingCommandTeam.Label, 'None'));
	}
	return;
	return;
}

private simulated function Actor GetPendingCommandTargetActor()
{
	local Actor TemporaryActor;

	switch(PendingCommand.Command)
	{
		case 3:
		case 4:
		case 6:
		case 7:
		case 8:
		case 9:
		case 10:
		case 11:
		case 12:
		case 13:
		case 14:
		case 16:
		case 17:
		case 18:
		case 19:
		case 21:
		case 22:
		case 23:
		case 24:
		case 47:
		case 40:
		case 39:
		case 36:
			return GetDoorFocus();
		case 5:
		case 15:
		case 20:
		case 35:
		case 43:
		case 44:
		case 45:
			return GetDoorFocus(true);
		case 31:
			return GetDoorFocus(true, true);
		case 34:
		case 46:
		case 42:
		case 41:
		case 48:
			return GetPendingFocusOfClass('Pawn');
		case 28:
			return GetPendingFocusOfClass('ICanBeDisabled');
		case 32:
			TemporaryActor = GetDoorFocus();
			if(NotEqual_ObjectObject(TemporaryActor, none))
			{
				return TemporaryActor;
			}
			else
			{
				TemporaryActor = GetPendingFocusOfClass('DeployedWedge');
				AssertWithDescription(NotEqual_ObjectObject(TemporaryActor, none), Concat_StrStr(Concat_StrStr("[tcohen] CommandInterface::GetPendingCommandTargetActor() Gave Command_RemoveWedge,", " but GetDoorFocus()=None,"), " and GetPendingFocusOfClass('DeployedWedge') is also None.  What're we removing?"));
				TemporaryActor = DeployedWedgeBase(TemporaryActor).GetDoorDeployedOn();
				AssertWithDescription(TemporaryActor.IsA('SwatDoor'), Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CommandInterface::GetPendingCommandTargetActor() Gave Command_RemoveWedge,", " and DeployedWedge="), string(TemporaryActor)), ", but DeployedWedge.GetDoorDeployedOn() returned None.  What Door is it deployed on?"));
				return TemporaryActor;
			}
			assert(false);
		case 33:
			return GetPendingFocusOfClass('IEvidence');
		case 37:
			return GetPendingFocusOfClass('MirrorPoint');
		default:
			return none;
			break;
	}
	return;
}

simulated function GiveDefaultCommand()
{
	if(DefaultCommandEnabled)
	{
		GiveCommand(DefaultCommand);
	}
	return;
}

simulated function bool CheckForValidDoor(Command Command, Actor Door)
{
	local bool ValidDoor;

	ValidDoor = AndAnd_BoolBool(NotEqual_ObjectObject(Door, none), Door.IsA('Door'));
	AssertWithDescription(ValidDoor, Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CommandInterface::CheckForValidDoor() Gave ", string(GetEnum(Enum'SwatGame.CommandInterface.ECommand', int(Command.Command)))), " which requires a valid Door, but Door="), string(Door)));
	return ValidDoor;
	return;
}

simulated function bool CheckForValidPawn(Command Command, Actor Pawn)
{
	local bool ValidPawn;

	ValidPawn = AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Pawn.IsA('Pawn'));
	AssertWithDescription(ValidPawn, Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CommandInterface::CheckForValidPawn() Gave ", string(GetEnum(Enum'SwatGame.CommandInterface.ECommand', int(Command.Command)))), " which requires a valid Pawn, but Pawn="), string(Pawn)));
	return ValidPawn;
	return;
}

protected simulated function Actor GetPendingFocusOfClass(name ClassName)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PendingCommandFociLength))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingCommandFoci[i].Actor, none), PendingCommandFoci[i].Actor.IsA(ClassName)))
		{
			return PendingCommandFoci[i].Actor;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

simulated function Actor GetExaminableFocus()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PendingCommandFociLength))
	{
		if(PendingCommandFoci[i].Actor.Examinable)
		{
			return PendingCommandFoci[i].Actor;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

simulated function Actor GetUsableFocus()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PendingCommandFociLength))
	{
		if(PendingCommandFoci[i].Actor.CanBeUsed())
		{
			return PendingCommandFoci[i].Actor;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

simulated function SwatDoor GetDoorFocus(optional bool PreferOpenDoor, optional bool PreferFarthestDoor)
{
	local SwatDoor SwatDoor, Result;
	local int i;

	if(Not_PreBool(PreferFarthestDoor))
	{
		i = 0;
		J0x12:

		if(Less_IntInt(i, PendingCommandFociLength))
		{
			SwatDoor = SwatDoor(PendingCommandFoci[i].Actor);
			if(EqualEqual_ObjectObject(SwatDoor, none))
			{
				// [Explicit Continue]
				goto J0x72;
			}
			Result = SwatDoor;
			if(EqualEqual_BoolBool(SwatDoor.IsOpen(), PreferOpenDoor))
			{
				// [Explicit Break]
				goto J0x7C;
			}
			J0x72:

			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x12;
		}
		J0x7C:

	}
	else
	{
		i = Subtract_IntInt(PendingCommandFociLength, 1);
		J0x8D:

		if(GreaterEqual_IntInt(i, 0))
		{
			SwatDoor = SwatDoor(PendingCommandFoci[i].Actor);
			if(EqualEqual_ObjectObject(SwatDoor, none))
			{
				// [Explicit Continue]
				goto J0xE9;
			}
			Result = SwatDoor;
			if(EqualEqual_BoolBool(SwatDoor.IsOpen(), PreferOpenDoor))
			{
				// [Explicit Break]
				goto J0xF3;
			}
			J0xE9:

			SubtractSubtract_PreInt(i);
			// [Loop Continue]
			goto J0x8D;
		}
	}
	J0xF3:

	return Result;
	return;
}

simulated function Vector GetLastFocusLocation()
{
	local Color Color;

	return PendingCommandFoci[Subtract_IntInt(PendingCommandFociLength, 1)].Location;
	return;
}

simulated function OnSpeechCommandRecognized(name Rule, name Value, SpeechManager.SpeechRecognitionConfidence Confidence)
{
	switch(Rule)
	{
		case 'Team':
			switch(Value)
			{
				case 'RedTeam':
					SetCurrentTeam_OfficerTeamInfo(RedTeam);
					break;
				case 'BlueTeam':
					SetCurrentTeam_OfficerTeamInfo(BlueTeam);
					break;
				case 'Element':
					SetCurrentTeam_OfficerTeamInfo(Element);
					break;
				default:
					assert(false);
					break;
			}
			break;
		case 'Command':
			break;
		default:
			assert(false);
			break;
	}
	return;
}

function OnEffectStarted(Actor inStartedEffect)
{
	return;
}

function OnEffectStopped(Actor inStoppedEffect, bool Completed)
{
	return;
}

function OnEffectInitialized(Actor inInitializedEffect)
{
	return;
}

simulated function string GetPendingFocusString()
{
	local int i;
	local string Result;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PendingCommandFociLength))
	{
		Result = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Result, "("), "Context="), string(PendingCommandFoci[i].Context)), ", Actor="), string(PendingCommandFoci[i].Actor.Name)), ", Location="), string(PendingCommandFoci[i].Location)), ", Region="), string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', int(PendingCommandFoci[i].Region)))), ") ");
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return Result;
	return;
}

simulated event Destroyed()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		SwatGameInfo(Level.Game).GameEvents.GameStarted.UnRegister(self);
	}
	super(Actor).Destroyed();
	return;
}

state Speaking
{
	function FlushPendingCommand()
	{
		if(SometimesSendInterruptedCommand)
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingCommandTeam, CurrentCommandTeam), NotEqual_ObjectObject(CurrentCommandTeam, Element)))
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", ...          the previous command was INTERRUPTED, and WILL be sent to the Officers. "), "(SometimesSendInterruptedCommand=true, PendingCommandTeam="), string(PendingCommandTeam.Class.Name)), ", CurrentCommandTeam="), string(CurrentCommandTeam.Class.Name)), ")"));
				SendCommandToOfficers();
			}
			else
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", ...          the previous command was INTERRUPTED, and will NOT be sent to the Officers. "), "(SometimesSendInterruptedCommand=true, PendingCommandTeam="), string(PendingCommandTeam.Class.Name)), ", CurrentCommandTeam="), string(CurrentCommandTeam.Class.Name)), ")"));
			}
		}
		else
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", ...          the previous command was INTERRUPTED, and will not be sent to the Officers. "), "(SometimesSendInterruptedCommand=false)"));
		}
		return;
	}
	stop;
}

state SpeakingTeam extends Speaking
{
	function OnEffectStarted(Actor inStartedEffect)
	{
		return;
	}

	function OnEffectStopped(Actor inStoppedEffect, bool Completed)
	{
		if(NotEqual_IntInt(int(SwatRepo(Level.GetRepo()).GuiConfig.SwatGameState), int(4)))
		{
			GotoState('None');
			return;
		}
		if(Completed)
		{
			LastCommandTeam = PendingCommandTeam;
			GotoState('SpeakingCommand');
			ExplicitBeginState();
		}
		else
		{
			GotoState('None');
		}
		return;
	}
	stop;
}

state SpeakingCommand extends Speaking
{
	function OnEffectInitialized(Actor inInitializedEffect)
	{
		CommandSpeechInitialized = true;
		return;
	}

	function OnEffectStarted(Actor inStartedEffect)
	{
		return;
	}

	function OnEffectStopped(Actor inStoppedEffect, bool Completed)
	{
		if(NotEqual_IntInt(int(SwatRepo(Level.GetRepo()).GuiConfig.SwatGameState), int(4)))
		{
			GotoState('None');
			return;
		}
		if(Completed)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[COMMAND INTERFACE] At Time ", string(Level.TimeSeconds)), ", "), string(PendingCommand.Name)), " completed."));
			SendCommandToOfficers();
		}
		if(CommandSpeechInitialized)
		{
			GotoState('None');
		}
		return;
	}

	function ExplicitBeginState()
	{
		local name EffectTag;

		if(NotEqual_ObjectObject(PendingCommandTargetCharacter, none))
		{
			if(PendingCommandTargetCharacter.IsA('SwatEnemy'))
			{
				if(PendingCommandTargetCharacter.IsFemale())
				{
					EffectTag = 'FemaleSuspect';
				}
				else
				{
					EffectTag = 'MaleSuspect';
				}
			}
			else
			{
				if(PendingCommandTargetCharacter.IsA('SwatHostage'))
				{
					if(PendingCommandTargetCharacter.IsFemale())
					{
						EffectTag = 'FemaleCivilian';
					}
					else
					{
						EffectTag = 'MaleCivilian';
					}
				}
			}
		}
		CommandSpeechInitialized = false;
		Level.GetLocalPlayerController().Pawn.TriggerEffectEvent(PendingCommand.EffectEvent,,,,,,, self, EffectTag);
		if(Not_PreBool(CommandSpeechInitialized))
		{
			Warn(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] Tried to start the speech for the pending command ", string(PendingCommand.Name)), ", but triggering the "), string(PendingCommand.EffectEvent)), " did not result in any sound starting."));
			GotoState('None');
		}
		return;
	}
	stop;
}

defaultproperties
{
	Enabled=true
	DefaultCommandEnabled=true
	GaveCommandString=": "
	AlwaysAddDoor=true
}