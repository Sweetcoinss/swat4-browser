class SwatKeyMappingPopup extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUILabel MyTitleLabel;
var(SwatGui) private export editinline config GUIButton MyCancelButton;
var string Passback;
var int PassbackInt;
var GUIListElem theElem;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyCancelButton.__OnClick__Delegate = InternalOnClick;
	return;
}

function InternalOnActivate()
{
	theElem = CreateElement("");
	Controller.__OnNeedRawKeyPress__Delegate = InternalOnRawKeyPress;
	return;
}

function InternalOnDeActivate()
{
	Controller.__OnNeedRawKeyPress__Delegate = None;
	Controller.ParentPage().OnPopupReturned(theElem, Passback);
	return;
}

event HandleParameters(string Param1, string Param2, optional int param3)
{
	MyTitleLabel.SetCaption(Param1);
	Passback = Param2;
	PassbackInt = param3;
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

function bool InternalOnRawKeyPress(byte NewKey)
{
	local string iKey;

	if(Not_PreBool(bActiveInput))
	{
		return false;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(NewKey), int(1)), MyCancelButton.IsInBounds()))
	{
		Controller.CloseMenu();
		return true;
	}
	iKey = PlayerOwner().ConsoleCommand(At_StrStr("KEYNAME", string(NewKey)));
	theElem = CreateElement(Passback,, iKey, PassbackInt);
	Controller.CloseMenu();
	return true;
	return;
}

protected function bool HandleKeyEvent(out byte Key, out byte State, float Delta)
{
	return false;
	return;
}

defaultproperties
{
	OnActivate=SwatKeyMappingPopup.InternalOnActivate
	OnDeActivate=SwatKeyMappingPopup.InternalOnDeActivate
}