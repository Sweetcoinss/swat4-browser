class SwatIntroMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

struct IntroComponent
{
	var() export editinline config GUIComponent Component;
	var() config string MovieName;
	var() config int MovieWidth;
	var() config int MovieHeight;
	var() config bool bCanNotBeSkipped;
};

var(SwatGui) private export editinline config GUIButton MyEscapeButton;
var(SwatGui) editinline config array<editinline IntroComponent> IntroComponents;
var private int CurrentComponentIndex;
var private bool bWaitForMovieCompletion;
var private int numTicksElapsed;
var private int OldResX;
var private int OldResY;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyEscapeButton.__OnClick__Delegate = InternalOnClick;
	return;
}

function SetupComponents()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, IntroComponents.Length))
	{
		if(EqualEqual_ObjectObject(IntroComponents[i].Component, none))
		{
			// [Explicit Continue]
			goto J0xFC;
		}
		IntroComponents[i].Component.bRepeatCycling = false;
		IntroComponents[i].Component.CyclePosition = -1;
		IntroComponents[i].Component.RePosition('Initial', true);
		IntroComponents[i].Component.__OnRePositionCompleted__Delegate = InternalOnRePositionCompleted;
		IntroComponents[i].Component.bHideMouseCursor = true;
		IntroComponents[i].Component.bCanBeShown = false;
		IntroComponents[i].Component.Hide();
		J0xFC:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	CurrentComponentIndex = -1;
	return;
}

private function InternalOnShow()
{
	SetupComponents();
	numTicksElapsed = 0;
	SetTimer(0.0100000, true);
	return;
}

function StartNextComponent()
{
	StopComponent(CurrentComponentIndex);
	AddAdd_Int(CurrentComponentIndex);
	if(EqualEqual_IntInt(CurrentComponentIndex, IntroComponents.Length))
	{
		Close();
	}
	StartComponent(CurrentComponentIndex);
	return;
}

function StartComponent(int Index)
{
	if(OrOr_BoolBool(Less_IntInt(Index, 0), Greater_IntInt(Index, IntroComponents.Length)))
	{
		return;
	}
	if(NotEqual_ObjectObject(IntroComponents[Index].Component, none))
	{
		IntroComponents[Index].Component.bCanBeShown = true;
		IntroComponents[Index].Component.Show();
		IntroComponents[Index].Component.RePosition('Show');
	}
	if(NotEqual_StrStr(IntroComponents[Index].MovieName, ""))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Starting movie '", IntroComponents[Index].MovieName), "', WinWidth: "), string(Controller.ResolutionX)), ", WinHeight: "), string(Controller.ResolutionY)));
		PlayerOwner().myHUD.PlayMovieDirect(IntroComponents[Index].MovieName, Subtract_IntInt(400, Divide_IntInt(IntroComponents[Index].MovieWidth, 2)), Subtract_IntInt(300, Divide_IntInt(IntroComponents[Index].MovieHeight, 2)), true, false);
		WaitForMovieCompletion();
	}
	return;
}

function StopComponent(int Index)
{
	if(OrOr_BoolBool(Less_IntInt(Index, 0), Greater_IntInt(Index, IntroComponents.Length)))
	{
		return;
	}
	if(NotEqual_ObjectObject(IntroComponents[Index].Component, none))
	{
		IntroComponents[Index].Component.RePosition('Final');
		IntroComponents[Index].Component.bCanBeShown = false;
		IntroComponents[Index].Component.Hide();
		if(EqualEqual_NameName(IntroComponents[Index].Component.Name, 'SwatIntroMenu_IGIntro'))
		{
			GUIImage(IntroComponents[Index].Component).Image = none;
			IntroComponents[Index].Component = none;
		}
	}
	if(NotEqual_StrStr(IntroComponents[Index].MovieName, ""))
	{
		Log(Concat_StrStr(Concat_StrStr("Stopping movie '", IntroComponents[Index].MovieName), "'"));
		PlayerOwner().myHUD.StopMovie();
	}
	bWaitForMovieCompletion = false;
	KillTimer();
	return;
}

private function InternalOnRePositionCompleted(GUIComponent Sender, name NewPosLabel)
{
	if(EqualEqual_NameName(NewPosLabel, 'Show'))
	{
		Sender.RePosition('Wait');
	}
	else
	{
		if(EqualEqual_NameName(NewPosLabel, 'Wait'))
		{
			StartNextComponent();
		}
	}
	return;
}

function WaitForMovieCompletion()
{
	bWaitForMovieCompletion = true;
	SetTimer(0.5000000, true);
	return;
}

event Timer()
{
	if(AndAnd_BoolBool(bWaitForMovieCompletion, Not_PreBool(PlayerOwner().myHUD.IsMoviePlaying())))
	{
		StartNextComponent();
	}
	else
	{
		if(Less_IntInt(numTicksElapsed, 6))
		{
			AddAdd_Int(numTicksElapsed);
			if(Greater_IntInt(numTicksElapsed, 5))
			{
				StartNextComponent();
				Controller.GetGuiResolution();
				OldResX = Controller.ResolutionX;
				OldResY = Controller.ResolutionY;
				Controller.ConsoleCommand("rmode 1");
				Controller.ConsoleCommand("setres 800x600");
			}
		}
	}
	return;
}

private function InternalOnClick(GUIComponent Sender)
{
	if(Not_PreBool(IntroComponents[CurrentComponentIndex].bCanNotBeSkipped))
	{
		StartNextComponent();
	}
	return;
}

function PerformClose()
{
	if(Not_PreBool(IntroComponents[CurrentComponentIndex].bCanNotBeSkipped))
	{
		StartNextComponent();
	}
	return;
}

private function Close()
{
	if(PlayerOwner().myHUD.IsMoviePlaying())
	{
		Log("Stopping intro movie!!");
		PlayerOwner().myHUD.StopMovie();
	}
	Controller.ConsoleCommand(Concat_StrStr(Concat_StrStr(Concat_StrStr("setres ", string(OldResX)), "x"), string(OldResY)));
	Controller.ConsoleCommand("rmode 5");
	Controller.CloseMenu();
	Free(true);
	return;
}

event Free(optional bool bForce)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, IntroComponents.Length))
	{
		IntroComponents[i].Component = none;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	IntroComponents.Remove(0, IntroComponents.Length);
	MyEscapeButton = none;
	super.Free(bForce);
	return;
}

defaultproperties
{
	bHideMouseCursor=true
	OnShow=SwatIntroMenu.InternalOnShow
}