class SwatGUIPanel extends GUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(DynamicConfig) private editconst editinline SwatGUIConfig GC "Config class for the GUI";
var(SwatGui) private config name CameraPositionLabel "When specified, will move the camera to the location specified by the given camera position when the panel is shown.";

function InitComponent(GUIComponent MyOwner)
{
	GC = SwatGUIController(Controller).GuiConfig;
	super(GUIMultiComponent).InitComponent(MyOwner);
	return;
}

event Show()
{
	SetSplashCameraPosition();
	super(GUIMultiComponent).Show();
	return;
}

private final function SetSplashCameraPosition()
{
	local CameraPositionMarker Marker;

	if(OrOr_BoolBool(NotEqual_IntInt(int(GC.SwatGameState), int(0)), EqualEqual_NameName(CameraPositionLabel, 'None')))
	{
		return;
	}
	Marker = CameraPositionMarker(PlayerOwner().findStaticByLabel(Class'Engine.CameraPositionMarker', CameraPositionLabel));
	if(NotEqual_ObjectObject(Marker, none))
	{
		PlayerOwner().SetLocation(Marker.Location);
		PlayerOwner().SetRotation(Marker.Rotation);
	}
	return;
}

defaultproperties
{
	WinTop=0.0000000
	WinLeft=0.0000000
	WinWidth=1.0000000
	WinHeight=1.0000000
}