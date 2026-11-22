class ClassicCommandInterface extends CommandInterface
	abstract
	config(PlayerFocusInterface)
	notplaceable
	hidecategories(Karma);

const MAX_COMMANDS = 12;
const ROW_SPACING = 14.0;

struct MenuPad
{
	var Command Command;
	var CommandInterface.MenuPadStatus Status;
};

var config localized string ElementString;
var config localized string RedTeamString;
var config localized string BlueTeamString;
var config localized string BackString;
var MenuPad CurrentMenuPads[12];
var export editinline HUDPageBase HUDPage;
var private export editinline GUIClassicCommandInterfaceContainer View;

simulated function Initialize()
{
	local SwatGamePlayerController Player;

	Player = SwatGamePlayerController(Level.GetLocalPlayerController());
	assert(NotEqual_ObjectObject(Player, none));
	HUDPage = Player.GetHUDPage();
	assert(NotEqual_ObjectObject(HUDPage, none));
	View = HUDPage.ClassicCommandInterface;
	AssertWithDescription(NotEqual_ObjectObject(View, none), "[tcohen] ClassicCommandInterface::OnGameStarted() HUDPage.ClassicCommandInterface is None.");
	View.SetCCIStyle('Element');
	super.Initialize();
	return;
}

simulated function PostUpdate()
{
	super.PostUpdate();
	UpdateView();
	return;
}

simulated function SetCommand(Command Command, CommandInterface.MenuPadStatus Status)
{
	if(EqualEqual_IntInt(int(Command.Page), int(CurrentPage)))
	{
		CurrentMenuPads[Command.CCIMenuPad].Command = Command;
		CurrentMenuPads[Command.CCIMenuPad].Status = Status;
	}
	return;
}

simulated function SetCurrentPage(CommandInterface.CommandInterfacePage NewPage, optional bool Force)
{
	if(OrOr_BoolBool(NotEqual_IntInt(int(CurrentPage), int(NewPage)), Force))
	{
		CurrentPage = NewPage;
		ClearCommands(true);
		ActivateStaticCommands();
		UpdateFocus();
	}
	return;
}

protected simulated function PostMainPageChanged()
{
	SetCurrentPage(CurrentMainPage);
	return;
}

simulated function GiveCommandIndex(int CommandIndex)
{
	local SwatGamePlayerController Player;

	AssertWithDescription(LessEqual_IntInt(CommandIndex, 12), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CommandInterface::GiveCommand() was called with CommandIndex=", string(CommandIndex)), ", but MAX_COMMANDS="), string(12)), "."));
	Player = SwatGamePlayerController(Level.GetLocalPlayerController());
	switch(CurrentMenuPads[CommandIndex].Status)
	{
		case 2:
			return;
		case 1:
			Player.TriggerEffectEvent('GreyedOutCommandGiven');
			break;
		case 0:
			Player.TriggerEffectEvent('NormalCommandGiven');
			break;
		default:
			assert(false);
			break;
			break;
	}
	GiveCommand(CurrentMenuPads[CommandIndex].Command);
	return;
}

simulated function UpdateView()
{
	local int i;
	local string DrawnIndex, Text;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(EqualEqual_ObjectObject(CurrentCommandTeam, Element))
		{
			View.SetCCIStyle('Element');
			Text = Concat_StrStr(Concat_StrStr(Concat_StrStr("[c=ffffff]", ElementString), "[\\c]"), "|");
		}
		else
		{
			if(EqualEqual_ObjectObject(CurrentCommandTeam, RedTeam))
			{
				View.SetCCIStyle('Red');
				Text = Concat_StrStr(Concat_StrStr(Concat_StrStr("[c=ffffff]", RedTeamString), "[\\c]"), "|");
			}
			else
			{
				if(EqualEqual_ObjectObject(CurrentCommandTeam, BlueTeam))
				{
					View.SetCCIStyle('Blue');
					Text = Concat_StrStr(Concat_StrStr(Concat_StrStr("[c=ffffff]", BlueTeamString), "[\\c]"), "|");
				}
				else
				{
					AssertWithDescription(false, "[tcohen] ClassicCommandInterface::UpdateView() CurrentCommandTeam doesn't match any of the known teams.");
				}
			}
		}
	}
	else
	{
		Text = Concat_StrStr(MenuInfo[int(CurrentMainPage)].Text, "|");
	}
	i = 1;
	J0x198:

	if(Less_IntInt(i, 12))
	{
		switch(i)
		{
			case 10:
				DrawnIndex = "0";
				break;
			case 11:
				DrawnIndex = "-";
				break;
			default:
				DrawnIndex = string(i);
				break;
				break;
		}
		switch(CurrentMenuPads[i].Status)
		{
			case 0:
				Text = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Text, "|"), "[c=000000]"), DrawnIndex), "   "), "[c=ffffff]"), CurrentMenuPads[i].Command.Text), "[\\c]");
				break;
			case 1:
				Text = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Text, "|"), "[c=000000]"), DrawnIndex), "   "), "[c=808080]"), CurrentMenuPads[i].Command.Text), "[\\c]");
				break;
			case 2:
				Text = Concat_StrStr(Text, "|");
				break;
			default:
				assert(false);
				break;
				break;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x198;
	}
	if(NotEqual_IntInt(int(MenuInfo[int(GetCurrentPage())].AnchorCommand), int(0)))
	{
		Text = Concat_StrStr(Concat_StrStr(Text, "||     "), BackString);
	}
	View.SetContent(Text);
	return;
}

protected simulated function PostDeactivated()
{
	if(NotEqual_ObjectObject(View, none))
	{
		View.Hide();
	}
	return;
}

simulated function ClearCommands(bool PageChange)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 12))
	{
		if(OrOr_BoolBool(OrOr_BoolBool(PageChange, EqualEqual_ObjectObject(CurrentMenuPads[i].Command, none)), Not_PreBool(CurrentMenuPads[i].Command.bStatic)))
		{
			CurrentMenuPads[i].Status = 2;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}
