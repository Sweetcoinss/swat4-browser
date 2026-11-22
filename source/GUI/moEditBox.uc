class moEditBox extends GUIMenuOption
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var export editinline GUIEditBox MyEditBox;
var bool bReadOnly;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyEditBox = GUIEditBox(MyComponent);
	MyEditBox.bReadOnly = bReadOnly;
	return;
}

function string GetText()
{
	return MyEditBox.GetText();
	return;
}

function SetText(string NewText)
{
	MyEditBox.SetText(NewText);
	return;
}

function ReadOnly(bool B)
{
	MyEditBox.bReadOnly = B;
	return;
}

function IntOnly(bool B)
{
	MyEditBox.bIntOnly = B;
	return;
}

function FloatOnly(bool B)
{
	MyEditBox.bFloatOnly = B;
	return;
}

function MaskText(bool B)
{
	MyEditBox.bMaskText = B;
	return;
}

defaultproperties
{
	ComponentClassName="GUI.GUIEditBox"
}