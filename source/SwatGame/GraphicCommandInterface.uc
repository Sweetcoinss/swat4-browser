class GraphicCommandInterface extends CommandInterface
	abstract
	native
	config(PlayerFocusInterface)
	notplaceable
	hidecategories(Karma);

cpptext
{
    UBOOL Tick(FLOAT DeltaSeconds, enum ELevelTick TickType);

}

var private export editinline GUIGraphicCommandInterface View;
var private bool bIsClosed;
var private bool bWasClosedBeforePageChange;

simulated function Initialize()
{
	local SwatGamePlayerController Player;

	Player = SwatGamePlayerController(Level.GetLocalPlayerController());
	View = Player.GetHUDPage().GraphicCommandInterface;
	assert(NotEqual_ObjectObject(View, none));
	Log(Concat_StrStr(string(self), "::Initialize() ... Setting the Logic to self!"));
	View.SetLogic(self);
	View.ClearAllCommands();
	super.Initialize();
	View.OnCurrentTeamChanged(CurrentCommandTeam);
	SetCurrentPage(CurrentMainPage, true);
	View.CloseInstantly();
	return;
}

protected simulated function bool PreUpdateHook(SwatGamePlayerController Player, HUDPageBase HUDPage)
{
	return AndAnd_BoolBool(super.PreUpdateHook(Player, HUDPage), bIsClosed);
	return;
}

simulated function CancelGivingCommand()
{
	Close();
	return;
}

simulated function Open()
{
	if(OrOr_BoolBool(Not_PreBool(Enabled), Not_PreBool(SwatGamePlayerController(Level.GetLocalPlayerController()).CanOpenGCI())))
	{
		TriggerEffectEvent('Denied');
		return;
	}
	SwatGamePlayerController(Level.GetLocalPlayerController()).UpdateFocus();
	View.super(GraphicCommandInterface).Open();
	bIsClosed = false;
	return;
}

protected simulated function PostDeactivated()
{
	View.Hide();
	return;
}

simulated function Close()
{
	View.super(GraphicCommandInterface).Close();
	bIsClosed = true;
	return;
}

protected simulated function OnCurrentTeamChanged(OfficerTeamInfo NewTeam)
{
	if(NotEqual_ObjectObject(View, none))
	{
		View.OnCurrentTeamChanged(NewTeam);
	}
	return;
}

simulated function ClearCommands(bool PageChange)
{
	if(NotEqual_ObjectObject(View, none))
	{
		View.ClearCommands(PageChange);
	}
	return;
}

simulated function SetCommand(Command Command, CommandInterface.MenuPadStatus Status)
{
	if(NotEqual_ObjectObject(View, none))
	{
		View.SetCommand(Command, Status);
	}
	return;
}

simulated event Destroyed()
{
	View = none;
	super.Destroyed();
	return;
}

protected simulated function PreMainPageChanged()
{
	bWasClosedBeforePageChange = bIsClosed;
	bIsClosed = true;
	if(NotEqual_ObjectObject(View, none))
	{
		View.CloseInstantly();
	}
	return;
}

protected simulated function PostMainPageChanged()
{
	bIsClosed = bWasClosedBeforePageChange;
	if(AndAnd_BoolBool(NotEqual_ObjectObject(View, none), Not_PreBool(bIsClosed)))
	{
		View.Open();
	}
	return;
}

defaultproperties
{
	bIsClosed=true
	bStasis=true
}