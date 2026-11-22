class ActionHUDSetDefaultCommandVisibility extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var bool Visible;

latent function Variable execute()
{
	if(NotEqual_ObjectObject(parentScript.Level.GetLocalPlayerController(), none))
	{
		SwatGamePlayerController(parentScript.Level.GetLocalPlayerController()).GetHUDPage().DefaultCommand.SetVisibility(Visible);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	if(Visible)
	{
		S = "Show the DefaultCommand HUD component";
	}
	else
	{
		S = "Hide the DefaultCommand HUD component";
	}
	return;
}

defaultproperties
{
	actionDisplayName="Set the visibility of the DefaultCommand HUD component"
	actionHelp="Sets the visibility of the DefaultCommand indicator"
	category="Script"
}