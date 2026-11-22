class SwatPasswordPopup extends SwatGUIPopup
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIEditBox MyPWEditBox;
var(SwatGui) private export editinline config GUILabel MyCaption;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyPWEditBox.__OnEntryCompleted__Delegate = InternalOnConfirm;
	return;
}

event HandleParameters(string Param1, string Param2, optional int param3)
{
	MyCaption.SetCaption(Param1);
	ReturnElem.ExtraStrData = Param2;
	MyPWEditBox.SetText("");
	return;
}

protected function Confirm()
{
	ReturnElem.Item = MyPWEditBox.GetText();
	return;
}

defaultproperties
{
	Passback="Password"
}