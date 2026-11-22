class GUIListBoxBase extends GUIMultiComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
	void PreDraw(UCanvas* Canvas);
	void Draw(UCanvas* Canvas);								// Handle drawing of the component natively
	void UpdateComponent(UCanvas* Canvas);

}

var() editconst export editinline GUIVertScrollBar MyScrollBar;
var() editconst export editinline GUIListBase MyActiveList;
var() config bool bVisibleWhenEmpty "List box is visible when empty.";
var() config bool bReadOnly "List box is Unselectable.";
var() config bool bPropagateStyle "If true, the style is propagated to the lists.";

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	MyScrollBar = GUIVertScrollBar(AddComponent("GUI.GUIVertScrollBar", Concat_StrStr(string(self.Name), "_SBar")));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyScrollBar.WinLeft = -1.0000000;
	MyScrollBar.WinTop = -1.0000000;
	MyScrollBar.WinWidth = 0.0000000;
	MyScrollBar.WinHeight = 0.0000000;
	MyScrollBar.bVisible = false;
	MyScrollBar.bActiveInput = bActiveInput;
	return;
}

function InitBaseList(GUIListBase LocalList)
{
	if(bPropagateStyle)
	{
		LocalList.StyleName = StyleName;
		LocalList.Style = Style;
	}
	LocalList.bVisibleWhenEmpty = bVisibleWhenEmpty;
	LocalList.bAllowHTMLTextFormatting = bAllowHTMLTextFormatting;
	LocalList.MyScrollBar = MyScrollBar;
	LocalList.bReadOnly = bReadOnly;
	SetVisibility(bVisible);
	SetActive(bActiveInput);
	SetActiveList(LocalList);
	return;
}

function SetActiveList(GUIListBase LocalList)
{
	local int i;

	MyActiveList = LocalList;
	MyScrollBar.MyList = LocalList;
	i = 0;
	J0x26:

	if(Less_IntInt(i, MyScrollBar.Controls.Length))
	{
		if(NotEqual_ObjectObject(MyScrollBar.Controls[i].FocusInstead, LocalList))
		{
		}
		MyScrollBar.Controls[i].SetFocusInstead(LocalList);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x26;
	}
	if(NotEqual_ObjectObject(MyScrollBar.FocusInstead, LocalList))
	{
	}
	MyScrollBar.SetFocusInstead(LocalList);
	SetDirty();
	return;
}

event Show()
{
	super.Show();
	MyScrollBar.Hide();
	return;
}

function bool IsEmpty()
{
	return EqualEqual_IntInt(MyActiveList.ItemCount, 0);
	return;
}

function int Num()
{
	return MyActiveList.ItemCount;
	return;
}

function Clear()
{
	MyActiveList.Clear();
	return;
}

function int GetIndex()
{
	return MyActiveList.GetIndex();
	return;
}

function int setIndex(int NewIndex)
{
	return MyActiveList.setIndex(NewIndex);
	return;
}

defaultproperties
{
	bVisibleWhenEmpty=true
	bPropagateStyle=true
	StyleName="STY_ListBox"
	bDrawStyle=true
}