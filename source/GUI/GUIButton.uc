class GUIButton extends GUITextComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var() config int Value "A value associated to this button";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	__OnXControllerEvent__Delegate = InternalOnXControllerEvent;
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	return false;
	return;
}

function bool InternalOnXControllerEvent(byte Id, GUI.eXControllerCodes iCode)
{
	if(EqualEqual_IntInt(int(iCode), int(16)))
	{
		OnClick(self);
		return true;
	}
	return false;
	return;
}

defaultproperties
{
	TextAlign=1
	StyleName="STY_RoundButton"
	WinHeight=0.0400000
	bCaptureMouse=true
	bDrawStyle=true
	bNeverFocus=true
	bTabStop=true
	bMouseOverSound=true
	OnClickSound=1
}