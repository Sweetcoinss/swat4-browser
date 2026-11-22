class GUIPage extends GUIMultiComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
		UBOOL NativeKeyEvent(BYTE& iKey, BYTE& State, FLOAT Delta );
		void UpdateTimers(float DeltaTime);
		UBOOL MousePressed(UBOOL IsRepeat);					// The Mouse was pressed
		UBOOL MouseReleased();								// The Mouse was released
        UBOOL PerformHitTest(INT MouseX, INT MouseY);
        UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);

        UBOOL XControllerEvent(int Id, eXControllerCodes iCode);

}

var() const editconst editinline array<export editinline GUIComponent> Timers "List of components with Active Timers if last on the stack.";
var() config bool bIsOverlay "If true, underlaying components should remain active";
var() config bool bIsHUD "If true, underlaying systems should remain active for input (gui should not swallow invalid input)";
var() editconst export editinline GUILabel HelpText "The label that displays the hint for the watched component on this page";
var() editconst export editinline GUIDlg CurrentDialog "The current dialog";
//var delegate<OnKeyEventFirstCrack> __OnKeyEventFirstCrack__Delegate;
//var delegate<OnDlgReturned> __OnDlgReturned__Delegate;
//var delegate<OnPopupReturned> __OnPopupReturned__Delegate;

delegate bool OnKeyEventFirstCrack(out byte Key, out byte State, float Delta)
{
	return false;
	return;
}

delegate OnDlgReturned(int returnButton, optional string Passback)
{
	return;
}

delegate OnPopupReturned(GUIListElem returnObj, optional string Passback)
{
	return;
}

event PostActivate()
{
	return;
}

event Activate()
{
	EnableComponent();
	super.Activate();
	Focus();
	return;
}

event DeActivate()
{
	DisableComponent();
	super.DeActivate();
	if(Not_PreBool(bPersistent))
	{
		Free();
	}
	return;
}

event Show()
{
	if(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)))
	{
		PlayerOwner().TriggerEffectEvent('UIMenuLoop',,,,,,,, Style.EffectCategory);
	}
	super.Show();
	if(NotEqual_ObjectObject(HelpText, none))
	{
		HelpText.Hide();
	}
	return;
}

event Hide()
{
	if(AndAnd_BoolBool(Not_PreBool(bNeverTriggerEffectEvents), NotEqual_ObjectObject(Style, none)))
	{
		PlayerOwner().UnTriggerEffectEvent('UIMenuLoop', Style.EffectCategory);
	}
	super.Hide();
	return;
}

final function CleanupDialogs()
{
	local int i;

	if(NotEqual_ObjectObject(CurrentDialog, none))
	{
		DlgReturned();
	}
	i = 0;
	J0x18:

	if(Less_IntInt(i, Controls.Length))
	{
		if(NotEqual_ObjectObject(GUIDlg(Controls[i]), none))
		{
			RemoveComponent(Controls[i]);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x18;
	}
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MapControls();
	return;
}

event ChangeHint(string NewHint)
{
	if(EqualEqual_ObjectObject(HelpText, none))
	{
		return;
	}
	HelpText.SetCaption(NewHint);
	HelpText.SetVisibility(AndAnd_BoolBool(Not_PreBool(Controller.bDontDisplayHelpText), NotEqual_StrStr(NewHint, "")));
	return;
}

event HandleParameters(string Param1, string Param2, optional int param3)
{
	return;
}

event NotifyLevelChange()
{
	return;
}

event Free(optional bool bForce)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Timers.Length))
	{
		Timers[i] = none;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	Timers.Remove(0, Timers.Length);
	HelpText = none;
	CurrentDialog = none;
	super.Free(bForce);
	return;
}

final function OpenDlg(string Caption, optional int TheButtons, optional string Passback, optional int TimeOut)
{
	if(NotEqual_ObjectObject(CurrentDialog, none))
	{
		return;
	}
	CurrentDialog = GUIDlg(AddComponent("GUI.GUIDlg", Concat_StrStr(Concat_StrStr(string(self.Name), "_"), Passback), true));
	CurrentDialog.SetupDlg(Caption, Passback, TheButtons, float(TimeOut));
	CurrentDialog.Show();
	CurrentDialog.Activate();
	return;
}

final function DlgReturned()
{
	local string Passback;
	local int Selection;

	Selection = CurrentDialog.Selection;
	Passback = CurrentDialog.Passback;
	CurrentDialog.DeActivate();
	CurrentDialog.Hide();
	RemoveComponent(CurrentDialog);
	CurrentDialog = none;
	OnDlgReturned(Selection, Passback);
	return;
}

function OnProgress(string Str1, string Str2)
{
	return;
}

defaultproperties
{
	bIsOverlay=true
	PropagateState=false
	WinTop=0.0000000
	WinLeft=0.0000000
	WinWidth=1.0000000
	WinHeight=1.0000000
	bSwallowAllKeyEvents=true
	bTabStop=false
	bPersistent=true
}