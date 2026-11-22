class GUIGFXButton extends GUIButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

cpptext
{
		void Draw(UCanvas* Canvas);

}

var() config Material Graphic "The graphic to display";
var() config GUI.eIconPosition Position "How do we draw the Icon";
var() config bool bCheckBox "Is this a check box button (ie: supports 2 states)";
var() config bool bClientBound "Graphic is drawn using clientbounds if true";
var() editinline config array<editinline Color> GraphicColors "This array holds 1 image color for each state";
var(DEBUG) bool bChecked;
var(DEBUG) bool bForceUpdate;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

event Show()
{
	bForceUpdate = false;
	super(GUIComponent).Show();
	return;
}

function SetChecked(bool bNewChecked, optional bool bForceAnUpdate)
{
	if(AndAnd_BoolBool(bCheckBox, OrOr_BoolBool(OrOr_BoolBool(NotEqual_BoolBool(bChecked, bNewChecked), bForceUpdate), bForceAnUpdate)))
	{
		bChecked = bNewChecked;
		bForceUpdate = false;
		OnChange(self);
		SetDirty();
	}
	return;
}

event Click()
{
	SetChecked(Not_PreBool(bChecked));
	super(GUIComponent).Click();
	return;
}

defaultproperties
{
	GraphicColors=/* ERROR: System.ArgumentOutOfRangeException */
	bForceUpdate=true
	bTabStop=false
}