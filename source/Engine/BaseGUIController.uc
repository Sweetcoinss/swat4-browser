class BaseGUIController extends Interaction
	native;

cpptext
{
		virtual void InitializeController();

}

var Material DefaultPens[3];
var bool bIsConsole;
var bool bHackDoNotRenderGUIPages;
//var delegate<OnAdminReply> __OnAdminReply__Delegate;

delegate OnAdminReply(string Reply)
{
	return;
}

event PreLevelChange()
{
	return;
}

event PostLevelChange()
{
	return;
}

event SetProgress(string Message1, string Message2)
{
	return;
}

event bool OpenMenu(string NewMenuName, optional string MenuNameOverride, optional string Param1, optional string Param2, optional int param3)
{
	return false;
	return;
}

event AutoLoadMenus()
{
	return;
}

event bool ReplaceMenu(string NewMenuName, optional string MenuNameOverride, optional string Param1, optional string Param2, optional int param3)
{
	return false;
	return;
}

event bool CloseMenu()
{
	return true;
	return;
}

event CloseAll()
{
	return;
}

function RemoveMenu(string MenuName)
{
	return;
}

function SetControllerStatus(bool On)
{
	bActive = On;
	bVisible = On;
	bRequiresTick = On;
	return;
}

event InitializeController()
{
	return;
}

defaultproperties
{
	DefaultPens[0]=Texture'Engine_res.MenuWhite'
	DefaultPens[1]=Texture'Engine_res.MenuBlack'
	DefaultPens[2]=Texture'Engine_res.MenuGray'
	bActive=false
	bNativeEvents=true
}