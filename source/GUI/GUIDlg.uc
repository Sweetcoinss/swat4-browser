class GUIDlg extends GUIPanel
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
	void PreDraw(UCanvas* Canvas);
	void UpdateComponent(UCanvas* Canvas);

}

var export editinline GUILabel MyLabel;
var array<export editinline GUIButton> MyButtons;
var string Passback;
var int Selection;
var() config float ButtonPercentX "X percentage of space to be used by the buttons";
var() config float ButtonPercentY "Y percentage of space to be used by the buttons";

function InitComponent(GUIComponent MyOwner)
{
	super(GUIMultiComponent).InitComponent(MyOwner);
	return;
}

function SetupDlg(string theCaption, string thePassback, int Options, optional float TimeOut)
{
	MyLabel = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_CaptionLabel"), true));
	assert(NotEqual_ObjectObject(MyLabel, none));
	MyLabel.SetCaption(theCaption);
	MyLabel.TextAlign = 1;
	MyLabel.bMultiLine = true;
	MyLabel.bAllowHTMLTextFormatting = true;
	Passback = thePassback;
	if(EqualEqual_IntInt(Options, 0))
	{
		WinHeight = Divide_FloatFloat(default.WinHeight, 2.0000000);
		WinTop = Add_FloatFloat(default.WinTop, Divide_FloatFloat(default.WinHeight, 4.0000000));
	}
	else
	{
		WinHeight = default.WinHeight;
		WinTop = default.WinTop;
	}
	if(NotEqual_IntInt(And_IntInt(Options, QBTN_Ok), 0))
	{
		AddButton(QBTN_Ok, Controller.DLG_OK);
	}
	if(NotEqual_IntInt(And_IntInt(Options, QBTN_Yes), 0))
	{
		AddButton(QBTN_Yes, Controller.DLG_Yes);
	}
	if(NotEqual_IntInt(And_IntInt(Options, QBTN_Continue), 0))
	{
		AddButton(QBTN_Continue, Controller.DLG_Continue);
	}
	if(NotEqual_IntInt(And_IntInt(Options, QBTN_Retry), 0))
	{
		AddButton(QBTN_Retry, Controller.DLG_Retry);
	}
	if(NotEqual_IntInt(And_IntInt(Options, QBTN_Ignore), 0))
	{
		AddButton(QBTN_Ignore, Controller.DLG_Ignore);
	}
	if(NotEqual_IntInt(And_IntInt(Options, QBTN_No), 0))
	{
		AddButton(QBTN_No, Controller.DLG_No);
	}
	if(NotEqual_IntInt(And_IntInt(Options, QBTN_Abort), 0))
	{
		AddButton(QBTN_Abort, Controller.DLG_Abort);
	}
	if(NotEqual_IntInt(And_IntInt(Options, QBTN_Cancel), 0))
	{
		AddButton(QBTN_Cancel, Controller.DLG_Cancel);
	}
	if(Greater_FloatFloat(TimeOut, float(0)))
	{
		SetTimer(TimeOut);
	}
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	Selection = Or_IntInt(Or_IntInt(QBTN_Cancel, QBTN_No), QBTN_Abort);
	SetDirty();
	return;
}

function AddButton(int inValue, string inCaption)
{
	local export editinline GUIButton theButton;

	theButton = GUIButton(AddComponent("GUI.GUIDlgButton", Concat_StrStr(Concat_StrStr(string(self.Name), "_"), inCaption), true));
	MyButtons[MyButtons.Length] = theButton;
	theButton.SetCaption(inCaption);
	theButton.Value = inValue;
	theButton.__OnClick__Delegate = InternalOnClick;
	theButton.EnableComponent();
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	Selection = GUIButton(Sender).Value;
	GUIPage(MenuOwner).DlgReturned();
	return;
}

event Timer()
{
	Selection = QBTN_TimeOut;
	GUIPage(MenuOwner).DlgReturned();
	return;
}

event DeActivate()
{
	local int i;

	KillTimer();
	MyLabel = none;
	MyButtons.Remove(0, MyButtons.Length);
	i = Subtract_IntInt(Controls.Length, 1);
	J0x29:

	if(GreaterEqual_IntInt(i, 0))
	{
		RemoveComponent(Controls[i]);
		SubtractSubtract_Int(i);
		// [Loop Continue]
		goto J0x29;
	}
	Controls.Remove(0, Controls.Length);
	super(GUIMultiComponent).DeActivate();
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(State), int(1)), KeyMatchesBinding(Key, "GUICloseMenu")))
	{
		GUIPage(MenuOwner).DlgReturned();
		return true;
	}
	return false;
	return;
}

defaultproperties
{
	ButtonPercentX=0.4000000
	ButtonPercentY=0.2000000
	StyleName="STY_DialogPanel"
	WinTop=0.3666670
	WinLeft=0.3125000
	WinWidth=0.3750000
	WinHeight=0.2666670
	bDrawStyle=true
	RenderWeight=0.9990000
}