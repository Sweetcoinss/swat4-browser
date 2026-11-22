class UWindowPageControl extends UWindowTabControl;

function ResolutionChanged(float W, float H)
{
	local UWindowPageControlPage i;

	i = UWindowPageControlPage(Items.Next);
	J0x19:

	if(NotEqual_ObjectObject(i, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(i.Page, none), NotEqual_ObjectObject(i, SelectedTab)))
		{
			i.Page.ResolutionChanged(W, H);
		}
		i = UWindowPageControlPage(i.Next);
		// [Loop Continue]
		goto J0x19;
	}
	if(NotEqual_ObjectObject(SelectedTab, none))
	{
		UWindowPageControlPage(SelectedTab).Page.ResolutionChanged(W, H);
	}
	return;
}

function NotifyQuitUnreal()
{
	local UWindowPageControlPage i;

	i = UWindowPageControlPage(Items.Next);
	J0x19:

	if(NotEqual_ObjectObject(i, none))
	{
		if(NotEqual_ObjectObject(i.Page, none))
		{
			i.Page.NotifyQuitUnreal();
		}
		i = UWindowPageControlPage(i.Next);
		// [Loop Continue]
		goto J0x19;
	}
	return;
}

function NotifyBeforeLevelChange()
{
	local UWindowPageControlPage i;

	i = UWindowPageControlPage(Items.Next);
	J0x19:

	if(NotEqual_ObjectObject(i, none))
	{
		if(NotEqual_ObjectObject(i.Page, none))
		{
			i.Page.NotifyBeforeLevelChange();
		}
		i = UWindowPageControlPage(i.Next);
		// [Loop Continue]
		goto J0x19;
	}
	return;
}

function NotifyAfterLevelChange()
{
	local UWindowPageControlPage i;

	i = UWindowPageControlPage(Items.Next);
	J0x19:

	if(NotEqual_ObjectObject(i, none))
	{
		if(NotEqual_ObjectObject(i.Page, none))
		{
			i.Page.NotifyAfterLevelChange();
		}
		i = UWindowPageControlPage(i.Next);
		// [Loop Continue]
		goto J0x19;
	}
	return;
}

function GetDesiredDimensions(out float W, out float H)
{
	local float MaxW, MaxH, tW, tH;
	local UWindowPageControlPage i;

	MaxW = 0.0000000;
	MaxH = 0.0000000;
	i = UWindowPageControlPage(Items.Next);
	J0x2F:

	if(NotEqual_ObjectObject(i, none))
	{
		if(NotEqual_ObjectObject(i.Page, none))
		{
			i.Page.GetDesiredDimensions(tW, tH);
		}
		if(Greater_FloatFloat(tW, MaxW))
		{
			MaxW = tW;
		}
		if(Greater_FloatFloat(tH, MaxH))
		{
			MaxH = tH;
		}
		i = UWindowPageControlPage(i.Next);
		// [Loop Continue]
		goto J0x2F;
	}
	W = MaxW;
	H = Add_FloatFloat(MaxH, TabArea.WinHeight);
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float OldWinHeight;
	local UWindowPageControlPage i;

	OldWinHeight = WinHeight;
	super.BeforePaint(C, X, Y);
	WinHeight = OldWinHeight;
	i = UWindowPageControlPage(Items.Next);
	J0x44:

	if(NotEqual_ObjectObject(i, none))
	{
		LookAndFeel.Tab_SetTabPageSize(self, i.Page);
		i = UWindowPageControlPage(i.Next);
		// [Loop Continue]
		goto J0x44;
	}
	return;
}

function Paint(Canvas C, float X, float Y)
{
	super.Paint(C, X, Y);
	LookAndFeel.Tab_DrawTabPageArea(self, C, UWindowPageControlPage(SelectedTab).Page);
	return;
}

function UWindowPageControlPage AddPage(string Caption, Class<UWindowPageWindow> PageClass, optional name ObjectName)
{
	local UWindowPageControlPage P;

	P = UWindowPageControlPage(AddTab(Caption));
	P.Page = UWindowPageWindow(CreateWindow(PageClass, 0.0000000, Subtract_FloatFloat(TabArea.WinHeight, float(Subtract_IntInt(LookAndFeel.TabSelectedM.H, LookAndFeel.TabUnselectedM.H))), WinWidth, Subtract_FloatFloat(WinHeight, Subtract_FloatFloat(TabArea.WinHeight, float(Subtract_IntInt(LookAndFeel.TabSelectedM.H, LookAndFeel.TabUnselectedM.H)))),,, ObjectName));
	P.Page.OwnerTab = P;
	if(NotEqual_ObjectObject(P, SelectedTab))
	{
		P.Page.HideWindow();
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(UWindowPageControlPage(SelectedTab), none), WindowIsVisible()))
		{
			UWindowPageControlPage(SelectedTab).Page.ShowWindow();
			UWindowPageControlPage(SelectedTab).Page.BringToFront();
		}
	}
	return P;
	return;
}

function UWindowPageControlPage InsertPage(UWindowPageControlPage BeforePage, string Caption, Class<UWindowPageWindow> PageClass, optional name ObjectName)
{
	local UWindowPageControlPage P;

	if(EqualEqual_ObjectObject(BeforePage, none))
	{
		return AddPage(Caption, PageClass);
	}
	P = UWindowPageControlPage(InsertTab(BeforePage, Caption));
	P.Page = UWindowPageWindow(CreateWindow(PageClass, 0.0000000, Subtract_FloatFloat(TabArea.WinHeight, float(Subtract_IntInt(LookAndFeel.TabSelectedM.H, LookAndFeel.TabUnselectedM.H))), WinWidth, Subtract_FloatFloat(WinHeight, Subtract_FloatFloat(TabArea.WinHeight, float(Subtract_IntInt(LookAndFeel.TabSelectedM.H, LookAndFeel.TabUnselectedM.H)))),,, ObjectName));
	P.Page.OwnerTab = P;
	if(NotEqual_ObjectObject(P, SelectedTab))
	{
		P.Page.HideWindow();
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(UWindowPageControlPage(SelectedTab), none), WindowIsVisible()))
		{
			UWindowPageControlPage(SelectedTab).Page.ShowWindow();
			UWindowPageControlPage(SelectedTab).Page.BringToFront();
		}
	}
	return P;
	return;
}

function UWindowPageControlPage GetPage(string Caption)
{
	return UWindowPageControlPage(GetTab(Caption));
	return;
}

function DeletePage(UWindowPageControlPage P)
{
	P.Page.Close(true);
	P.Page.HideWindow();
	DeleteTab(P);
	return;
}

function Close(optional bool bByParent)
{
	local UWindowPageControlPage i;

	i = UWindowPageControlPage(Items.Next);
	J0x19:

	if(NotEqual_ObjectObject(i, none))
	{
		if(NotEqual_ObjectObject(i.Page, none))
		{
			i.Page.Close(true);
		}
		i = UWindowPageControlPage(i.Next);
		// [Loop Continue]
		goto J0x19;
	}
	super(UWindowWindow).Close(bByParent);
	return;
}

function GotoTab(UWindowTabControlItem NewSelected, optional bool bByUser)
{
	local UWindowPageControlPage i;

	super.GotoTab(NewSelected, bByUser);
	i = UWindowPageControlPage(Items.Next);
	J0x2A:

	if(NotEqual_ObjectObject(i, none))
	{
		if(NotEqual_ObjectObject(i, NewSelected))
		{
			i.Page.HideWindow();
		}
		i = UWindowPageControlPage(i.Next);
		// [Loop Continue]
		goto J0x2A;
	}
	if(NotEqual_ObjectObject(UWindowPageControlPage(NewSelected), none))
	{
		UWindowPageControlPage(NewSelected).Page.ShowWindow();
	}
	return;
}

function UWindowPageControlPage FirstPage()
{
	return UWindowPageControlPage(Items.Next);
	return;
}

defaultproperties
{
	ListClass=Class'UWindow.UWindowPageControlPage'
}