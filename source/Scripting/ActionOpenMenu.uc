class ActionOpenMenu extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var string Menu;
var string Param1;
var string Param2;
var string param3;

latent function Variable execute()
{
	local PlayerController PC;

	super.execute();
	PC = parentScript.Level.GetLocalPlayerController();
	if(NotEqual_ObjectObject(PC, none))
	{
		PC.Player.GUIController.OpenMenu(Menu, Param1, Param2, param3);
	}
	else
	{
		SLog("Couldn't get the player controller");
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Open menu ", propertyDisplayString('Menu'));
	return;
}

defaultproperties
{
	actionDisplayName="Open Menu"
	actionHelp="Opens a menu"
	category="Other"
}