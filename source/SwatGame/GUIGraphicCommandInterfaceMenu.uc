class GUIGraphicCommandInterfaceMenu extends Object
	native;

const MAX_COMMANDS_PER_PAGE = 12;

var export editinline GUIGraphicCommandInterface GCI;
var CommandInterface.CommandInterfacePage Page;
var bool IsAMainMenu;
var ScreenLocation Origin;
var ScreenLocation Root;
var export editinline GUIGraphicCommandInterfaceMenuPad MenuPads[12];

function Open()
{
	local ScreenLocation CurrentLocation;
	local float VerticalSpacing, HorizontalSpacing;
	local bool CascadeUp;
	local export editinline GUIGraphicCommandInterfaceMenuPad CurrentPad;
	local int i;

	GotoState('None');
	CloseInstantly();
	VerticalSpacing = GCI.ActualHeight();
	HorizontalSpacing = GCI.ActualWidth();
	CascadeUp = GCI.GetLogic().MenuInfo[int(Page)].CascadeUp;
	CurrentLocation = Root;
	i = 0;
	J0x7A:

	if(Less_IntInt(i, 12))
	{
		CurrentPad = MenuPads[i];
		if(CurrentPad.HideInGCI(GCI))
		{
			CurrentPad.SetVisibility(false);
			// [Explicit Continue]
			goto J0x13A;
		}
		CurrentPad.SetVisibility(true);
		CurrentPad.MoveTo(CurrentLocation.X, CurrentLocation.Y, HorizontalSpacing, VerticalSpacing, GCI.OpenCloseTime);
		if(CascadeUp)
		{
			SubtractEqual_FloatFloat(CurrentLocation.Y, VerticalSpacing);
			// [Explicit Continue]
			goto J0x13A;
		}
		AddEqual_FloatFloat(CurrentLocation.Y, VerticalSpacing);
		J0x13A:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x7A;
	}
	if(IsAMainMenu)
	{
		GCI.TriggerEffectEvent('MainMenuBeganOpening');
	}
	else
	{
		GCI.TriggerEffectEvent('SubMenuBeganOpening');
	}
	return;
}

function Close()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 12))
	{
		MenuPads[i].MoveTo(Origin.X, Origin.Y, 0.0000000, 0.0000000, GCI.OpenCloseTime);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(IsAMainMenu)
	{
		GCI.TriggerEffectEvent('MainMenuBeganClosing');
	}
	else
	{
		GCI.TriggerEffectEvent('SubMenuBeganClosing');
	}
	GotoState('Closing');
	return;
}

function CloseInstantly()
{
	local int i;

	UpdateOriginAndRoot();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, 12))
	{
		MenuPads[i].MoveTo(Origin.X, Origin.Y, 0.0000000, 0.0000000, 0.0000000);
		MenuPads[i].OnUnselected();
		MenuPads[i].SetVisibility(false);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0D;
	}
	return;
}

private function UpdateOriginAndRoot()
{
	local CommandInterface.ECommand AnchorCommand;
	local Command AnchorCommandRef;
	local GUIGraphicCommandInterfaceMenu AnchorPage;
	local export editinline GUIGraphicCommandInterfaceMenuPad Pad;
	local int PadsPrecedingDefault;
	local bool FoundDefault;
	local int i;

	AnchorCommand = GCI.GetLogic().MenuInfo[int(Page)].AnchorCommand;
	if(EqualEqual_IntInt(int(AnchorCommand), int(0)))
	{
		Origin.X = float(Divide_IntInt(GCI.Controller.ResolutionX, 2));
		Origin.Y = float(Divide_IntInt(GCI.Controller.ResolutionY, 2));
		if(EqualEqual_IntInt(int(GCI.PlayerOwner().Level.NetMode), int(NM_Standalone)))
		{
			FoundDefault = false;
			i = 0;
			J0xCA:

			if(Less_IntInt(i, 12))
			{
				if(EqualEqual_ObjectObject(MenuPads[i].Command, GCI.GetDefaultCommand()))
				{
					FoundDefault = true;
					// [Explicit Break]
					goto J0x137;
					// [Explicit Continue]
					goto J0x12D;
				}
				if(NotEqual_ObjectObject(MenuPads[i].Command, none))
				{
					AddAdd_Int(PadsPrecedingDefault);
				}
				J0x12D:

				AddAdd_PreInt(i);
				// [Loop Continue]
				goto J0xCA;
			}
		}
		J0x137:

		if(Not_PreBool(FoundDefault))
		{
			PadsPrecedingDefault = 0;
		}
		Root.X = Add_FloatFloat(Origin.X, Multiply_FloatFloat(float(GCI.Controller.ResolutionX), GCI.MainPageCenterOffset.X));
		Root.Y = Subtract_FloatFloat(Origin.Y, Multiply_FloatFloat(float(PadsPrecedingDefault), GCI.ActualHeight()));
		return;
	}
	AnchorCommandRef = GCI.GetCommandRef(AnchorCommand);
	AnchorPage = GCI.MenuPages[int(AnchorCommandRef.Page)];
	if(EqualEqual_ObjectObject(AnchorPage, none))
	{
		return;
	}
	i = 0;
	J0x212:

	if(Less_IntInt(i, 12))
	{
		Pad = AnchorPage.MenuPads[i];
		if(EqualEqual_ObjectObject(Pad.Command, AnchorCommandRef))
		{
			if(Pad.bRepositioning)
			{
				Origin.X = Add_FloatFloat(Add_FloatFloat(Pad.TransitionSpec.NewPos.WinLeft, Pad.TransitionSpec.NewPos.WinWidth), float(2));
				Origin.Y = Add_FloatFloat(Pad.TransitionSpec.NewPos.WinTop, Divide_FloatFloat(GCI.ActualHeight(), float(2)));
			}
			else
			{
				Origin.X = Add_FloatFloat(Add_FloatFloat(Pad.ActualLeft(), Pad.ActualWidth()), float(2));
				Origin.Y = Add_FloatFloat(Pad.ActualTop(), Divide_FloatFloat(GCI.ActualHeight(), float(2)));
			}
			Root.X = Origin.X;
			Root.Y = Origin.Y;
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x212;
	}
	return;
	return;
}

function ClearAllCommands()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 12))
	{
		MenuPads[i].Command = none;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function ClearCommands(bool PageChange)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 12))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(MenuPads[i].Command, none), Not_PreBool(MenuPads[i].Command.bStatic)))
		{
			MenuPads[i].Command = none;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function Command GetNextCommandUp(Command CurrentCommand)
{
	if(GCI.GetLogic().MenuInfo[int(Page)].CascadeUp)
	{
		return GetCommandNextIndex(CurrentCommand);
	}
	else
	{
		return GetCommandPreviousIndex(CurrentCommand);
	}
	return;
}

function Command GetNextCommandDown(Command CurrentCommand)
{
	if(Not_PreBool(GCI.GetLogic().MenuInfo[int(Page)].CascadeUp))
	{
		return GetCommandNextIndex(CurrentCommand);
	}
	else
	{
		return GetCommandPreviousIndex(CurrentCommand);
	}
	return;
}

function Command GetCommandPreviousIndex(Command CurrentCommand)
{
	local int i;

	i = Subtract_IntInt(CurrentCommand.GCIMenuPad, 1);
	J0x17:

	if(GreaterEqual_IntInt(i, 0))
	{
		if(Not_PreBool(MenuPads[i].HideInGCI(GCI)))
		{
			return MenuPads[i].Command;
		}
		SubtractSubtract_PreInt(i);
		// [Loop Continue]
		goto J0x17;
	}
	return CurrentCommand;
	return;
}

function Command GetCommandNextIndex(Command CurrentCommand)
{
	local int i;

	i = Add_IntInt(CurrentCommand.GCIMenuPad, 1);
	J0x17:

	if(Less_IntInt(i, 12))
	{
		if(Not_PreBool(MenuPads[i].HideInGCI(GCI)))
		{
			return MenuPads[i].Command;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x17;
	}
	return CurrentCommand;
	return;
}

function Command GetTopCommand()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 12))
	{
		if(NotEqual_ObjectObject(MenuPads[i].Command, none))
		{
			return MenuPads[i].Command;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	AssertWithDescription(false, "[tcohen] GUIGraphicCommandInterfaceMenu::GetTopCommand() no Commands found.");
	return;
}

state Closing
{
	function HidePads()
	{
		local int i;

		i = 0;
		J0x07:

		if(Less_IntInt(i, 12))
		{
			MenuPads[i].SetVisibility(false);
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x07;
		}
		return;
	}
Begin:

	Sleep(GCI.OpenCloseTime);
	HidePads();
	stop;
}
