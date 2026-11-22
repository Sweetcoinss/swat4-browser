class moNumericEdit extends GUIMenuOption
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var export editinline GUINumericEdit MyNumericEdit;
var int MinValue;
var int MaxValue;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyNumericEdit = GUINumericEdit(MyComponent);
	MyNumericEdit.MinValue = MinValue;
	MyNumericEdit.MaxValue = MaxValue;
	MyNumericEdit.CalcMaxLen();
	MyNumericEdit.__OnChange__Delegate = InternalOnChange;
	return;
}

function SetValue(int V)
{
	MyNumericEdit.SetValue(V);
	return;
}

function int GetValue()
{
	return MyNumericEdit.Value;
	return;
}

function InternalOnChange(GUIComponent Sender)
{
	OnChange(self);
	return;
}

defaultproperties
{
	ComponentClassName="GUI.GUINumericEdit"
	OnClickSound=1
}