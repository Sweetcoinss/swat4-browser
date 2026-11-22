class SwatGameDescriptionPopup extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyCancelButton;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyCancelButton.__OnClick__Delegate = InternalOnClick;
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyCancelButton:
			Controller.CloseMenu();
			break;
		default:
			break;
	}
	return;
}
