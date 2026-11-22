class GUIClassicCommandInterfaceContainer extends GUIScrollTextBox
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(CCI) config string RedStyleName;
var(CCI) config string BlueStyleName;
var(CCI) config string ElementStyleName;
var(CCI) export editinline GUIStyles RedStyle;
var(CCI) export editinline GUIStyles BlueStyle;
var(CCI) export editinline GUIStyles ElementStyle;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	RedStyle = Controller.GetStyle(RedStyleName);
	BlueStyle = Controller.GetStyle(BlueStyleName);
	ElementStyle = Controller.GetStyle(ElementStyleName);
	assert(NotEqual_ObjectObject(RedStyle, none));
	assert(NotEqual_ObjectObject(BlueStyle, none));
	assert(NotEqual_ObjectObject(ElementStyle, none));
	return;
}

simulated function SetCCIStyle(name NewStyle)
{
	switch(NewStyle)
	{
		case 'Red':
			Style = RedStyle;
			break;
		case 'Blue':
			Style = BlueStyle;
			break;
		case 'Element':
			Style = ElementStyle;
			break;
		default:
			break;
	}
	MyScrollText.Style = Style;
	return;
}

defaultproperties
{
	bPersistent=true
}