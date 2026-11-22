class GUIComboBox extends GUIMultiComponent
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

var export editinline GUIEditBox Edit;
var export editinline GUIComboButton MyShowListBtn;
var export editinline GUIListBox MyListBox;
var export editinline GUIList List;
var() config int MaxVisibleItems "Maximum number of lines to display at once";
var() config bool bShowListOnFocus "Show the attached list when this recieves focus";
var() config bool bReadOnly "Is this ComboBox read only";
var int Index;
var string TextStr;
//var delegate<OnListIndexChanged> __OnListIndexChanged__Delegate;

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	MyListBox = GUIListBox(AddComponent("GUI.GUIListBox", Concat_StrStr(string(self.Name), "_LBox")));
	Edit = GUIEditBox(AddComponent("GUI.GUIEditBox", Concat_StrStr(string(self.Name), "_EditBox")));
	MyShowListBtn = GUIComboButton(AddComponent("GUI.GUIComboButton", Concat_StrStr(string(self.Name), "_ComboB")));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	Edit.SetText("", true);
	MyShowListBtn.bRepeatClick = false;
	List = MyListBox.List;
	List.bHotTrack = true;
	List.__OnChange__Delegate = SubComponentChanged;
	List.__OnLostFocus__Delegate = SubComponentFocusLost;
	Edit.__OnChange__Delegate = SubComponentChanged;
	Edit.__OnClick__Delegate = SubComponentClicked;
	Edit.__OnLostFocus__Delegate = SubComponentFocusLost;
	Edit.bReadOnly = bReadOnly;
	if(bReadOnly)
	{
		Edit.SetFocusInstead(List);
	}
	MyShowListBtn.__OnClick__Delegate = SubComponentClicked;
	MyShowListBtn.SetFocusInstead(List);
	return;
}

event Show()
{
	super.Show();
	MyListBox.Hide();
	SetDirty();
	return;
}

event Activate()
{
	super.Activate();
	MyListBox.DeActivate();
	SetDirty();
	return;
}

function SubComponentFocusLost(GUIComponent Sender)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan} SubComponentFocusLost: Sender = ", string(Sender)), ", bActive = "), string(Sender.bActiveInput)), ", bVisible = "), string(Sender.bVisible)));
	switch(Sender)
	{
		case Edit:
		case List:
			MyListBox.Hide();
			MyListBox.DeActivate();
			break;
		default:
			break;
	}
	return;
}

function SubComponentClicked(GUIComponent Sender)
{
	switch(Sender)
	{
		case Edit:
			if(Not_PreBool(Edit.bReadOnly))
			{
				break;
			}
		case MyShowListBtn:
			if(MyListBox.bVisible)
			{
				InternalCloseList();
			}
			else
			{
				InternalOpenList();
			}
			break;
		default:
			break;
	}
	return;
}

private function InternalOpenList()
{
	MyListBox.Show();
	MyListBox.Activate();
	MyListBox.Focus();
	if(NotEqual_ObjectObject(GUIMultiComponent(MenuOwner), none))
	{
		GUIMultiComponent(MenuOwner).BringToFront(self);
	}
	return;
}

private function InternalCloseList()
{
	MyListBox.Hide();
	MyListBox.DeActivate();
	return;
}

function SubComponentChanged(GUIComponent Sender)
{
	switch(Sender)
	{
		case List:
			Edit.SetText(List.SelectedText(-1), true);
			Index = List.GetIndex();
			OnListIndexChanged(Sender);
			break;
		case Edit:
			TextStr = Edit.GetText();
			OnChange(self);
			MyListBox.Hide();
			MyListBox.DeActivate();
			break;
		default:
			break;
	}
	return;
}

delegate OnListIndexChanged(GUIComponent Sender)
{
	return;
}

function SetText(string NewText)
{
	List.find(NewText);
	Edit.SetText(NewText, true);
	SetDirty();
	return;
}

function string GetText()
{
	return Edit.GetText();
	return;
}

function string Get()
{
	local string temp;

	temp = List.Get();
	if(ComplementEqual_StrStr(temp, Edit.GetText()))
	{
		return List.Get();
	}
	else
	{
		return "";
	}
	return;
}

function Object GetObject()
{
	local string temp;

	temp = List.Get();
	if(ComplementEqual_StrStr(temp, Edit.GetText()))
	{
		return List.GetObject();
	}
	else
	{
		return none;
	}
	return;
}

function string GetExtra()
{
	local string temp;

	temp = List.Get();
	if(ComplementEqual_StrStr(temp, Edit.GetText()))
	{
		return List.GetExtra();
	}
	else
	{
		return "";
	}
	return;
}

function int GetInt()
{
	return List.GetExtraIntData();
	return;
}

function bool GetBool()
{
	return List.GetExtraBoolData();
	return;
}

function setIndex(int i)
{
	List.setIndex(i);
	SetDirty();
	return;
}

function int GetIndex()
{
	return List.GetIndex();
	return;
}

function Clear()
{
	List.Clear();
	return;
}

function AddItem(string Item, optional Object Extra, optional string Str, optional int theInt, optional bool theBool)
{
	List.Add(Item, Extra, Str, theInt, theBool);
	return;
}

function RemoveItem(int Item, optional int Count)
{
	List.Remove(Item, Count);
	return;
}

function string GetItem(int Index)
{
	List.setIndex(Index);
	return List.Get();
	return;
}

function Object GetItemObject(int Index)
{
	List.setIndex(Index);
	return List.GetObject();
	return;
}

function string find(string Text, optional bool bExact, optional bool bDontSetIndex)
{
	return List.find(Text, bExact, bDontSetIndex);
	return;
}

function int ItemCount()
{
	return List.ItemCount;
	return;
}

function ReadOnly(bool B)
{
	Edit.bReadOnly = B;
	return;
}

defaultproperties
{
	MaxVisibleItems=8
	bReadOnly=true
	StyleName="STY_ComboListBox"
	WinHeight=0.0273440
	RenderWeight=0.9510000
}