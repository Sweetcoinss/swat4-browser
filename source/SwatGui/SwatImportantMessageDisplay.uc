class SwatImportantMessageDisplay extends GUILabel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private config SwatGUIController.eIMDType IMDType "Type of IMD this is";
var(SwatGui) config float ImportantMessageDisplayTime "How long the messages should remain on screen (0 = stay on screen)";

function InitComponent(GUIComponent MyOwner)
{
	super(GUITextComponent).InitComponent(MyOwner);
	SwatGUIController(Controller).SetIMD(self, IMDType);
	return;
}

function MessageRecieved(string MsgText, optional float DisplayTime)
{
	Caption = MsgText;
	Show();
	if(EqualEqual_FloatFloat(DisplayTime, float(0)))
	{
		DisplayTime = ImportantMessageDisplayTime;
	}
	if(Greater_FloatFloat(DisplayTime, 0.0000000))
	{
		SetTimer(ImportantMessageDisplayTime);
	}
	return;
}

function ClearDisplay()
{
	Caption = "";
	Hide();
	return;
}

event Timer()
{
	ClearDisplay();
	return;
}
