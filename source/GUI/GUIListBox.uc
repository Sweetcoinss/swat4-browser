class GUIListBox extends GUIListBoxBase
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

var export editinline GUIList List;

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	List = GUIList(AddComponent("GUI.GUIList", Concat_StrStr(string(self.Name), "_List")));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	InitBaseList(List);
	List.__OnClick__Delegate = InternalOnClick;
	List.OnClickSound = 1;
	List.__OnChange__Delegate = InternalOnChange;
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	Click();
	return;
}

function InternalOnChange(GUIComponent Sender)
{
	SetDirty();
	OnChange(self);
	return;
}

function int ItemCount()
{
	return List.ItemCount;
	return;
}
