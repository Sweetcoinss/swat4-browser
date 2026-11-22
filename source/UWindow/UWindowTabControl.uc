class UWindowTabControl extends UWindowListControl;

var UWindowTabControlLeftButton LeftButton;
var UWindowTabControlRightButton RightButton;
var UWindowTabControlTabArea TabArea;
var UWindowTabControlItem SelectedTab;
var bool bMultiLine;
var bool bSelectNearestTabOnRemove;

function Created()
{
	super.Created();
	SelectedTab = none;
	TabArea = UWindowTabControlTabArea(CreateWindow(Class'UWindow.UWindowTabControlTabArea', 0.0000000, 0.0000000, Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth), LookAndFeel.Size_ScrollbarWidth), float(10)), Add_FloatFloat(LookAndFeel.Size_TabAreaHeight, LookAndFeel.Size_TabAreaOverhangHeight)));
	TabArea.bAlwaysOnTop = true;
	LeftButton = UWindowTabControlLeftButton(CreateWindow(Class'UWindow.UWindowTabControlLeftButton', Subtract_FloatFloat(WinWidth, float(20)), 0.0000000, 10.0000000, 12.0000000));
	RightButton = UWindowTabControlRightButton(CreateWindow(Class'UWindow.UWindowTabControlRightButton', Subtract_FloatFloat(WinWidth, float(10)), 0.0000000, 10.0000000, 12.0000000));
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	TabArea.WinTop = 0.0000000;
	TabArea.WinLeft = 0.0000000;
	if(bMultiLine)
	{
		TabArea.WinWidth = WinWidth;
	}
	else
	{
		TabArea.WinWidth = Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth), LookAndFeel.Size_ScrollbarWidth), float(10));
	}
	TabArea.LayoutTabs(C);
	WinHeight = Add_FloatFloat(Multiply_FloatFloat(LookAndFeel.Size_TabAreaHeight, float(TabArea.TabRows)), LookAndFeel.Size_TabAreaOverhangHeight);
	TabArea.WinHeight = WinHeight;
	super(UWindowDialogControl).BeforePaint(C, X, Y);
	return;
}

function SetMultiLine(bool InMultiLine)
{
	bMultiLine = InMultiLine;
	if(bMultiLine)
	{
		LeftButton.HideWindow();
		RightButton.HideWindow();
	}
	else
	{
		LeftButton.ShowWindow();
		RightButton.ShowWindow();
	}
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local Region R;
	local Texture t;

	t = GetLookAndFeelTexture();
	R = LookAndFeel.TabBackground;
	DrawStretchedTextureSegment(C, 0.0000000, 0.0000000, WinWidth, Multiply_FloatFloat(LookAndFeel.Size_TabAreaHeight, float(TabArea.TabRows)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	return;
}

function UWindowTabControlItem AddTab(string Caption)
{
	local UWindowTabControlItem i;

	i = UWindowTabControlItem(Items.Append(ListClass));
	i.Owner = self;
	i.SetCaption(Caption);
	if(EqualEqual_ObjectObject(SelectedTab, none))
	{
		SelectedTab = i;
	}
	return i;
	return;
}

function UWindowTabControlItem InsertTab(UWindowTabControlItem BeforeTab, string Caption)
{
	local UWindowTabControlItem i;

	i = UWindowTabControlItem(BeforeTab.InsertBefore(ListClass));
	i.Owner = self;
	i.SetCaption(Caption);
	if(EqualEqual_ObjectObject(SelectedTab, none))
	{
		SelectedTab = i;
	}
	return i;
	return;
}

function GotoTab(UWindowTabControlItem NewSelected, optional bool bByUser)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SelectedTab, NewSelected), bByUser))
	{
		LookAndFeel.PlayMenuSound(self, 5);
	}
	SelectedTab = NewSelected;
	TabArea.bShowSelected = true;
	return;
}

function UWindowTabControlItem GetTab(string Caption)
{
	local UWindowTabControlItem i;

	i = UWindowTabControlItem(Items.Next);
	J0x19:

	if(NotEqual_ObjectObject(i, none))
	{
		if(EqualEqual_StrStr(i.Caption, Caption))
		{
			return i;
		}
		i = UWindowTabControlItem(i.Next);
		// [Loop Continue]
		goto J0x19;
	}
	return none;
	return;
}

function DeleteTab(UWindowTabControlItem tab)
{
	local UWindowTabControlItem NextTab, PrevTab;

	NextTab = UWindowTabControlItem(tab.Next);
	PrevTab = UWindowTabControlItem(tab.Prev);
	tab.Remove();
	if(EqualEqual_ObjectObject(SelectedTab, tab))
	{
		if(bSelectNearestTabOnRemove)
		{
			tab = NextTab;
			if(EqualEqual_ObjectObject(tab, none))
			{
				tab = PrevTab;
			}
			GotoTab(tab);
		}
		else
		{
			GotoTab(UWindowTabControlItem(Items.Next));
		}
	}
	return;
}

defaultproperties
{
	ListClass=Class'UWindow.UWindowTabControlItem'
}