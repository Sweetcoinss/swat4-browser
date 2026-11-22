class SwatGUIPopup extends GUIPage
	abstract
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(DynamicConfig) private editconst editinline SwatGUIConfig GC "Config class for the GUI";
var(SwatGui) private export editinline config GUIButton MyOKButton;
var(SwatGui) private export editinline config GUIButton MyCancelButton;
var(SwatGui) private editconst string Passback;
var(SwatGui) private editconst GUIListElem ReturnElem;

function InitComponent(GUIComponent MyOwner)
{
	GC = SwatGUIController(Controller).GuiConfig;
	super.InitComponent(MyOwner);
	if(NotEqual_ObjectObject(MyCancelButton, none))
	{
		MyCancelButton.__OnClick__Delegate = InternalOnCancel;
	}
	if(NotEqual_ObjectObject(MyOKButton, none))
	{
		MyOKButton.__OnClick__Delegate = InternalOnConfirm;
	}
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	return;
}

protected function InternalOnCancel(GUIComponent Sender)
{
	Cancel();
	Controller.CloseMenu();
	return;
}

protected function InternalOnConfirm(GUIComponent Sender)
{
	Confirm();
	Controller.CloseMenu();
	Controller.TopPage().OnPopupReturned(ReturnElem, Passback);
	return;
}

protected function Cancel()
{
	return;
}

protected function Confirm()
{
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(State), int(1)), KeyMatchesBinding(Key, "GUICloseMenu")))
	{
		InternalOnCancel(none);
		return true;
	}
	return false;
	return;
}

defaultproperties
{
	StyleName="STY_DialogPanel"
	WinTop=0.3000000
	WinLeft=0.2000000
	WinWidth=0.6000000
	WinHeight=0.4000000
	bDrawStyle=true
}