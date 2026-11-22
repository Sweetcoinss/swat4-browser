class GUITabControl extends GUIMultiComponent
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

struct sTabButtonPair
{
	var() export editinline config GUIButton TabHeader "The header button for this tab";
	var() export editinline config GUIPanel TabPanel "The tab";
};

var() editinline config array<editinline sTabButtonPair> MyTabs "The tabs for this tab control";
var() editinline config sTabButtonPair InitialTab "The initial tab for this tab control";
var() editconst editinline sTabButtonPair ActiveTab "The active tab for this tab control";
var() editinline config bool bAlwaysUseInitialTabWhenShown "If true, will set the active tab to the initial tab every time this is shown";

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, MyTabs.Length))
	{
		MyTabs[i].TabHeader.__OnClick__Delegate = TabHeaderClick;
		MyTabs[i].TabHeader.bNeverFocus = false;
		MyTabs[i].TabHeader.bMaintainFocus = true;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	ActiveTab = InitialTab;
	return;
}

event Show()
{
	local int i;

	if(bAlwaysUseInitialTabWhenShown)
	{
		ActiveTab = InitialTab;
	}
	super.Show();
	i = 0;
	J0x21:

	if(Less_IntInt(i, MyTabs.Length))
	{
		MyTabs[i].TabHeader.Show();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x21;
	}
	ActiveTab.TabPanel.Show();
	return;
}

event Hide()
{
	local int i;

	super.Hide();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, MyTabs.Length))
	{
		MyTabs[i].TabHeader.Hide();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0D;
	}
	ActiveTab.TabPanel.Hide();
	return;
}

event Activate()
{
	local int i;

	super.Activate();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, MyTabs.Length))
	{
		MyTabs[i].TabHeader.Activate();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0D;
	}
	ActiveTab.TabHeader.Focus();
	ActiveTab.TabPanel.Activate();
	return;
}

event DeActivate()
{
	local int i;

	super.DeActivate();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, MyTabs.Length))
	{
		MyTabs[i].TabHeader.DeActivate();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0D;
	}
	ActiveTab.TabHeader.EnableComponent();
	ActiveTab.TabPanel.DeActivate();
	return;
}

function TabHeaderClick(GUIComponent Sender)
{
	OpenTab_GUIButton(GUIButton(Sender));
	return;
}

overloaded function OpenTab()
{
	return;
}

overloaded function OpenTab(int Index)
{
	InternalOpenTabPair(GetTab(Index));
	return;
}

overloaded function OpenTab(GUIPanel tab)
{
	InternalOpenTabPair(GetTabByPanel(tab));
	return;
}

overloaded function OpenTab(GUIButton Header)
{
	InternalOpenTabPair(GetTabByHeader(Header));
	return;
}

function InternalOpenTabPair(sTabButtonPair theTab)
{
	ActiveTab.TabHeader.EnableComponent();
	ActiveTab.TabPanel.DeActivate();
	ActiveTab.TabPanel.Hide();
	theTab.TabPanel.Show();
	theTab.TabPanel.Activate();
	theTab.TabHeader.Focus();
	ActiveTab = theTab;
	return;
}

function sTabButtonPair CreateNewPair(string PanelClassName, string PanelName, string ButtonClassName, string ButtonName)
{
	local sTabButtonPair NewPair;

	NewPair.TabPanel = GUIPanel(AddComponent(PanelClassName, PanelName, true));
	NewPair.TabHeader = GUIButton(AddComponent(ButtonClassName, ButtonName, true));
	if(EqualEqual_StrStr(NewPair.TabHeader.Caption, ""))
	{
		NewPair.TabHeader.SetCaption(ButtonName);
	}
	return NewPair;
	return;
}

overloaded function AddTab()
{
	return;
}

overloaded function AddTab(sTabButtonPair NewPair)
{
	AddTab_IntsTabButtonPair(MyTabs.Length, NewPair);
	return;
}

overloaded function AddTab(int Index, sTabButtonPair NewPair)
{
	if(Less_IntInt(Index, 0))
	{
		return;
	}
	MyTabs[Index] = NewPair;
	NewPair.TabHeader.__OnClick__Delegate = TabHeaderClick;
	NewPair.TabHeader.bNeverFocus = false;
	NewPair.TabHeader.bMaintainFocus = true;
	NewPair.TabHeader.Show();
	NewPair.TabHeader.Activate();
	return;
}

overloaded function AddTab(string PanelClassName, string PanelName, string ButtonClassName, string ButtonName)
{
	AddTab_IntStrStrStrStr(MyTabs.Length, PanelClassName, PanelName, ButtonClassName, ButtonName);
	return;
}

overloaded function AddTab(int Index, string PanelClassName, string PanelName, string ButtonClassName, string ButtonName)
{
	AddTab_IntsTabButtonPair(Index, CreateNewPair(PanelClassName, PanelName, ButtonClassName, ButtonName));
	return;
}

overloaded function AddTab(GUIPanel Panel, GUIButton Header)
{
	AddTab_IntGUIPanelGUIButton(MyTabs.Length, Panel, Header);
	return;
}

overloaded function AddTab(int Index, GUIPanel Panel, GUIButton Header)
{
	InternalAddTab(Index, Panel, Header);
	return;
}

function InternalAddTab(int Index, GUIPanel Panel, GUIButton Header)
{
	local sTabButtonPair NewPair;

	if(Less_IntInt(Index, 0))
	{
		return;
	}
	NewPair.TabPanel = GUIPanel(AppendComponent(Panel));
	NewPair.TabHeader = GUIButton(AppendComponent(Header));
	AddTab_IntsTabButtonPair(Index, NewPair);
	return;
}

overloaded function RemoveTab()
{
	return;
}

overloaded function RemoveTab(int Index)
{
	RemoveComponent(MyTabs[Index].TabHeader);
	RemoveComponent(MyTabs[Index].TabPanel);
	MyTabs.Remove(Index, 1);
	return;
}

overloaded function RemoveTab(GUIPanel Panel)
{
	RemoveTab_Int(GetTabIndexByPanel(Panel));
	return;
}

overloaded function RemoveTab(GUIButton Header)
{
	RemoveTab_Int(GetTabIndexByHeader(Header));
	return;
}

function sTabButtonPair GetTab(int Index)
{
	return MyTabs[Index];
	return;
}

function sTabButtonPair GetTabByPanel(GUIPanel Panel)
{
	return MyTabs[GetTabIndexByPanel(Panel)];
	return;
}

function sTabButtonPair GetTabByHeader(GUIButton Header)
{
	return MyTabs[GetTabIndexByHeader(Header)];
	return;
}

function int GetTabIndexByPanel(GUIPanel Panel)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MyTabs.Length))
	{
		if(EqualEqual_ObjectObject(Panel, MyTabs[i].TabPanel))
		{
			return i;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function int GetTabIndexByHeader(GUIButton Header)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MyTabs.Length))
	{
		if(EqualEqual_ObjectObject(Header, MyTabs[i].TabHeader))
		{
			return i;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function Clear()
{
	MyTabs.Remove(0, MyTabs.Length);
	return;
}

function int Num()
{
	return MyTabs.Length;
	return;
}

function bool IsEmpty()
{
	return EqualEqual_IntInt(Num(), 0);
	return;
}

function AlignTabs(GUI.eProgressDirection AlignDirection, bool ButtonsAlignedTopLeft, int MaxButtonsPerRow, float RowSize, float RowSpacing, float ButtonSpacing)
{
	local int i, numRows;
	local float ButtonWidth, PanelWidth, ButtonHeight, PanelHeight, PanelTop, PanelLeft;

	if(EqualEqual_IntInt(MyTabs.Length, 0))
	{
		return;
	}
	numRows = Add_IntInt(Divide_IntInt(Subtract_IntInt(MyTabs.Length, 1), MaxButtonsPerRow), 1);
	switch(AlignDirection)
	{
		case 0:
		case 1:
			PanelWidth = Subtract_FloatFloat(ClientBounds[2], ClientBounds[0]);
			PanelHeight = Subtract_FloatFloat(Subtract_FloatFloat(ClientBounds[3], ClientBounds[1]), Multiply_FloatFloat(float(numRows), RowSize));
			ButtonWidth = Subtract_FloatFloat(Divide_FloatFloat(PanelWidth, float(MaxButtonsPerRow)), ButtonSpacing);
			ButtonHeight = Subtract_FloatFloat(RowSize, RowSpacing);
			PanelLeft = ClientBounds[0];
			if(ButtonsAlignedTopLeft)
			{
				PanelTop = Add_FloatFloat(ClientBounds[1], Multiply_FloatFloat(ButtonHeight, float(numRows)));
			}
			else
			{
				PanelTop = ClientBounds[1];
			}
			break;
		case 2:
		case 3:
			PanelWidth = Subtract_FloatFloat(Subtract_FloatFloat(ClientBounds[2], ClientBounds[0]), Multiply_FloatFloat(float(numRows), RowSize));
			PanelHeight = Subtract_FloatFloat(ClientBounds[3], ClientBounds[1]);
			ButtonWidth = Subtract_FloatFloat(RowSize, RowSpacing);
			ButtonHeight = Subtract_FloatFloat(Divide_FloatFloat(PanelHeight, float(MaxButtonsPerRow)), ButtonSpacing);
			PanelTop = ClientBounds[1];
			if(ButtonsAlignedTopLeft)
			{
				PanelLeft = Add_FloatFloat(ClientBounds[0], Multiply_FloatFloat(ButtonWidth, float(numRows)));
			}
			else
			{
				PanelLeft = ClientBounds[0];
			}
			break;
		default:
			break;
	}
	i = 0;
	J0x1AE:

	if(Less_IntInt(i, MyTabs.Length))
	{
		MyTabs[i].TabPanel.bScaled = false;
		MyTabs[i].TabPanel.WinLeft = PanelLeft;
		MyTabs[i].TabPanel.WinTop = PanelTop;
		MyTabs[i].TabPanel.WinWidth = PanelWidth;
		MyTabs[i].TabPanel.WinHeight = PanelHeight;
		MyTabs[i].TabHeader.bScaled = false;
		MyTabs[i].TabHeader.WinWidth = ButtonWidth;
		MyTabs[i].TabHeader.WinHeight = ButtonHeight;
		switch(AlignDirection)
		{
			case 0:
				MyTabs[i].TabHeader.WinLeft = Add_FloatFloat(ClientBounds[0], Multiply_FloatFloat(Percent_FloatFloat(float(i), float(MaxButtonsPerRow)), Add_FloatFloat(ButtonWidth, ButtonSpacing)));
				if(ButtonsAlignedTopLeft)
				{
					MyTabs[i].TabHeader.WinTop = Add_FloatFloat(ClientBounds[1], Multiply_FloatFloat(float(Divide_IntInt(i, MaxButtonsPerRow)), Add_FloatFloat(ButtonHeight, RowSpacing)));
				}
				else
				{
					MyTabs[i].TabHeader.WinTop = Subtract_FloatFloat(ClientBounds[3], Multiply_FloatFloat(float(Add_IntInt(Divide_IntInt(i, MaxButtonsPerRow), 1)), Add_FloatFloat(ButtonHeight, RowSpacing)));
				}
				break;
			case 1:
				MyTabs[i].TabHeader.WinLeft = Add_FloatFloat(ClientBounds[0], Multiply_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(float(MaxButtonsPerRow), Percent_FloatFloat(float(i), float(MaxButtonsPerRow))), float(1)), Add_FloatFloat(ButtonWidth, ButtonSpacing)));
				if(ButtonsAlignedTopLeft)
				{
					MyTabs[i].TabHeader.WinTop = Add_FloatFloat(ClientBounds[1], Multiply_FloatFloat(float(Divide_IntInt(i, MaxButtonsPerRow)), Add_FloatFloat(ButtonHeight, RowSpacing)));
				}
				else
				{
					MyTabs[i].TabHeader.WinTop = Subtract_FloatFloat(ClientBounds[3], Multiply_FloatFloat(float(Add_IntInt(Divide_IntInt(i, MaxButtonsPerRow), 1)), Add_FloatFloat(ButtonHeight, RowSpacing)));
				}
				break;
			case 2:
				MyTabs[i].TabHeader.WinTop = Add_FloatFloat(ClientBounds[1], Multiply_FloatFloat(Percent_FloatFloat(float(i), float(MaxButtonsPerRow)), Add_FloatFloat(ButtonHeight, ButtonSpacing)));
				if(ButtonsAlignedTopLeft)
				{
					MyTabs[i].TabHeader.WinLeft = Add_FloatFloat(ClientBounds[0], Multiply_FloatFloat(float(Divide_IntInt(i, MaxButtonsPerRow)), Add_FloatFloat(ButtonWidth, RowSpacing)));
				}
				else
				{
					MyTabs[i].TabHeader.WinLeft = Subtract_FloatFloat(ClientBounds[2], Multiply_FloatFloat(float(Add_IntInt(Divide_IntInt(i, MaxButtonsPerRow), 1)), Add_FloatFloat(ButtonWidth, RowSpacing)));
				}
				break;
			case 3:
				MyTabs[i].TabHeader.WinTop = Add_FloatFloat(ClientBounds[1], Multiply_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(float(MaxButtonsPerRow), Percent_FloatFloat(float(i), float(MaxButtonsPerRow))), float(1)), Add_FloatFloat(ButtonHeight, ButtonSpacing)));
				if(ButtonsAlignedTopLeft)
				{
					MyTabs[i].TabHeader.WinLeft = Add_FloatFloat(ClientBounds[0], Multiply_FloatFloat(float(Divide_IntInt(i, MaxButtonsPerRow)), Add_FloatFloat(ButtonWidth, RowSpacing)));
				}
				else
				{
					MyTabs[i].TabHeader.WinLeft = Subtract_FloatFloat(ClientBounds[2], Multiply_FloatFloat(float(Add_IntInt(Divide_IntInt(i, MaxButtonsPerRow), 1)), Add_FloatFloat(ButtonWidth, RowSpacing)));
				}
				break;
			default:
				break;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1AE;
	}
	return;
}

defaultproperties
{
	PropagateVisibility=false
	PropagateActivity=false
	PropagateState=false
	RenderWeight=0.2000000
}