class SwatJoinIPPopup extends SwatGUIPopup
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIEditBox MyPWEditBox;
var(SwatGui) private export editinline config GUIEditBox MyEditBox;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyEditBox.__OnEntryCompleted__Delegate = InternalOnConfirm;
	MyPWEditBox.__OnEntryCompleted__Delegate = InternalOnConfirm;
	return;
}

protected function Confirm()
{
	local string Password;

	ReturnElem.Item = MyEditBox.GetText();
	Password = MyPWEditBox.GetText();
	if(NotEqual_StrStr(Password, ""))
	{
		ReturnElem.Item = Concat_StrStr(Concat_StrStr(ReturnElem.Item, "?Password="), Password);
	}
	return;
}

defaultproperties
{
	Passback="JoinIP"
}