class SwatTimeDisplay extends GUITimeDisplay
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private config SwatGUIController.eTimeType TimeType "Type of timer this is";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	SwatGUIController(Controller).SetTimeDisplay(self, TimeType);
	return;
}

function DoNothing()
{
	return;
}
