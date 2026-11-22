class SwatSaveCustomPopup extends SwatGUIPopup
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIEditBox MyEditBox;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyEditBox.__OnEntryCompleted__Delegate = InternalOnConfirm;
	MyEditBox.__OnChange__Delegate = EntryOnChanged;
	return;
}

function EntryOnChanged(GUIComponent Sender)
{
	MyOKButton.SetEnabled(NotEqual_StrStr(MyEditBox.GetText(), ""));
	return;
}

protected function InternalOnConfirm(GUIComponent Sender)
{
	if(NotEqual_StrStr(MyEditBox.GetText(), ""))
	{
		super.InternalOnConfirm(Sender);
	}
	return;
}

protected function Confirm()
{
	ReturnElem.Item = MyEditBox.GetText();
	return;
}

defaultproperties
{
	Passback="SaveCustom"
}