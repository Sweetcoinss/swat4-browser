class GUIRadioButton extends GUICheckBoxButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

function InitComponent(GUIComponent MyOwner)
{
	super(GUIGFXButton).InitComponent(MyOwner);
	RadioGroup = self;
	return;
}

event Click()
{
	super(GUIComponent).Click();
	SelectRadioButton();
	return;
}

function SetRadioGroup(GUIRadioButton Group)
{
	SetChecked(EqualEqual_ObjectObject(self, Group));
	return;
}

function SelectRadioButton()
{
	if(NotEqual_ObjectObject(GUIMultiComponent(MenuOwner), none))
	{
		GUIMultiComponent(MenuOwner).SetRadioGroup(self);
	}
	return;
}

defaultproperties
{
	Graphic=Texture'gui_tex.radio_om'
}