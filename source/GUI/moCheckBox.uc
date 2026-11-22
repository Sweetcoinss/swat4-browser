class moCheckBox extends GUIMenuOption
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var export editinline GUICheckBoxButton MyCheckBox;
var bool bChecked;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyCheckBox = GUICheckBoxButton(MyComponent);
	return;
}

function bool IsChecked()
{
	return MyCheckBox.bChecked;
	return;
}

function bool Checked(bool C)
{
	MyCheckBox.bChecked = C;
	bChecked = C;
	OnChange(self);
	return true;
	return;
}

defaultproperties
{
	ComponentClassName="GUI.GUICheckBoxButton"
}