class UWindowComboControl extends UWindowDialogControl;

var float EditBoxWidth;
var float EditAreaDrawX;
var float EditAreaDrawY;
var UWindowEditBox EditBox;
var UWindowComboButton Button;
var UWindowComboLeftButton LeftButton;
var UWindowComboRightButton RightButton;
var Class<UWindowComboList> ListClass;
var UWindowComboList List;
var bool bListVisible;
var bool bCanEdit;
var bool bButtons;

function Created()
{
	super.Created();
	EditBox = UWindowEditBox(CreateWindow(Class'UWindow.UWindowEditBox', 0.0000000, 0.0000000, Subtract_FloatFloat(WinWidth, float(12)), WinHeight));
	EditBox.NotifyOwner = self;
	EditBoxWidth = Divide_FloatFloat(WinWidth, float(2));
	EditBox.bTransient = true;
	Button = UWindowComboButton(CreateWindow(Class'UWindow.UWindowComboButton', Subtract_FloatFloat(WinWidth, float(12)), 0.0000000, 12.0000000, 10.0000000));
	Button.Owner = self;
	List = UWindowComboList(Root.CreateWindow(ListClass, 0.0000000, 0.0000000, 100.0000000, 100.0000000));
	List.LookAndFeel = LookAndFeel;
	List.Owner = self;
	List.Setup();
	List.HideWindow();
	bListVisible = false;
	SetEditTextColor(LookAndFeel.EditBoxTextColor);
	return;
}

function SetButtons(bool bInButtons)
{
	bButtons = bInButtons;
	if(bInButtons)
	{
		LeftButton = UWindowComboLeftButton(CreateWindow(Class'UWindow.UWindowComboLeftButton', Subtract_FloatFloat(WinWidth, float(12)), 0.0000000, 12.0000000, 10.0000000));
		RightButton = UWindowComboRightButton(CreateWindow(Class'UWindow.UWindowComboRightButton', Subtract_FloatFloat(WinWidth, float(12)), 0.0000000, 12.0000000, 10.0000000));
	}
	else
	{
		LeftButton = none;
		RightButton = none;
	}
	return;
}

function Notify(byte E)
{
	super.Notify(E);
	if(EqualEqual_IntInt(int(E), 10))
	{
		if(Not_PreBool(bListVisible))
		{
			if(Not_PreBool(bCanEdit))
			{
				DropDown();
				Root.CaptureMouse(List);
			}
		}
		else
		{
			CloseUp();
		}
	}
	return;
}

function int FindItemIndex(string V, optional bool bIgnoreCase)
{
	return List.FindItemIndex(V, bIgnoreCase);
	return;
}

function RemoveItem(int Index)
{
	List.RemoveItem(Index);
	return;
}

function int FindItemIndex2(string v2, optional bool bIgnoreCase)
{
	return List.FindItemIndex2(v2, bIgnoreCase);
	return;
}

function Close(optional bool bByParent)
{
	if(AndAnd_BoolBool(bByParent, bListVisible))
	{
		CloseUp();
	}
	super(UWindowWindow).Close(bByParent);
	return;
}

function SetNumericOnly(bool bNumericOnly)
{
	EditBox.bNumericOnly = bNumericOnly;
	return;
}

function SetNumericFloat(bool bNumericFloat)
{
	EditBox.bNumericFloat = bNumericFloat;
	return;
}

function SetFont(int NewFont)
{
	super.SetFont(NewFont);
	EditBox.SetFont(NewFont);
	return;
}

function SetEditTextColor(Color NewColor)
{
	EditBox.SetTextColor(NewColor);
	return;
}

function SetEditable(bool bNewCanEdit)
{
	bCanEdit = bNewCanEdit;
	EditBox.SetEditable(bCanEdit);
	return;
}

function int GetSelectedIndex()
{
	return List.FindItemIndex(GetValue());
	return;
}

function SetSelectedIndex(int Index)
{
	SetValue(List.GetItemValue(Index), List.GetItemValue2(Index));
	return;
}

function string GetValue()
{
	return EditBox.GetValue();
	return;
}

function string GetValue2()
{
	return EditBox.GetValue2();
	return;
}

function SetValue(string NewValue, optional string NewValue2)
{
	EditBox.SetValue(NewValue, NewValue2);
	UWindowDialogClientWindow(OwnerWindow).Notify(self, 1);
	return;
}

function SetMaxLength(int MaxLength)
{
	EditBox.MaxLength = MaxLength;
	return;
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.Combo_Draw(self, C);
	super(UWindowWindow).Paint(C, X, Y);
	return;
}

function AddItem(string S, optional string S2, optional int SortWeight)
{
	List.AddItem(S, S2, SortWeight);
	return;
}

function InsertItem(string S, optional string S2, optional int SortWeight)
{
	List.InsertItem(S, S2, SortWeight);
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super.BeforePaint(C, X, Y);
	LookAndFeel.Combo_SetupSizes(self, C);
	List.bLeaveOnscreen = AndAnd_BoolBool(bListVisible, bLeaveOnscreen);
	return;
}

function CloseUp()
{
	bListVisible = false;
	EditBox.SetEditable(bCanEdit);
	EditBox.SelectAll();
	List.HideWindow();
	return;
}

function DropDown()
{
	bListVisible = true;
	EditBox.SetEditable(false);
	List.ShowWindow();
	return;
}

function Sort()
{
	List.Sort();
	return;
}

function ClearValue()
{
	EditBox.Clear();
	return;
}

function Clear()
{
	List.Clear();
	EditBox.Clear();
	return;
}

function FocusOtherWindow(UWindowWindow W)
{
	super(UWindowWindow).FocusOtherWindow(W);
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bListVisible, NotEqual_ObjectObject(W.ParentWindow, self)), NotEqual_ObjectObject(W, List)), NotEqual_ObjectObject(W.ParentWindow, List)))
	{
		CloseUp();
	}
	return;
}

defaultproperties
{
	ListClass=Class'UWindow.UWindowComboList'
	bNoKeyboard=true
}