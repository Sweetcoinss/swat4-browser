class moComboBox extends GUIMenuOption
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var export editinline GUIComboBox MyComboBox;
var bool bReadOnly;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyComboBox = GUIComboBox(MyComponent);
	ReadOnly(bReadOnly);
	return;
}

function int ItemCount()
{
	return MyComboBox.ItemCount();
	return;
}

function setIndex(int i)
{
	MyComboBox.setIndex(i);
	return;
}

function int GetIndex()
{
	return MyComboBox.GetIndex();
	return;
}

function string find(string test, bool bExact)
{
	return MyComboBox.find(test, bExact);
	return;
}

function AddItem(string Item, optional Object Extra, optional string Str)
{
	MyComboBox.AddItem(Item, Extra, Str);
	return;
}

function RemoveItem(int Item, optional int Count)
{
	MyComboBox.RemoveItem(Item, Count);
	return;
}

function string GetItem(int Index)
{
	return MyComboBox.GetItem(Index);
	return;
}

function Object GetItemObject(int Index)
{
	return MyComboBox.GetItemObject(Index);
	return;
}

function string GetText()
{
	local string aaa;

	aaa = MyComboBox.Get();
	return aaa;
	return;
}

function Object GetObject()
{
	return MyComboBox.GetObject();
	return;
}

function string GetExtra()
{
	return MyComboBox.GetExtra();
	return;
}

function SetText(string NewText)
{
	MyComboBox.SetText(NewText);
	return;
}

function ReadOnly(bool B)
{
	MyComboBox.ReadOnly(B);
	return;
}

defaultproperties
{
	ComponentClassName="GUI.GUIComboBox"
}