class ActionHUDSetFireModeVisibility extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var bool Visible;

latent function Variable execute()
{
	if(NotEqual_ObjectObject(parentScript.Level.GetLocalPlayerController(), none))
	{
		SwatGamePlayerController(parentScript.Level.GetLocalPlayerController()).GetHUDPage().FireMode.SetVisibility(Visible);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	if(Visible)
	{
		S = "Show the FireMode HUD component";
	}
	else
	{
		S = "Hide the FireMode HUD component";
	}
	return;
}

defaultproperties
{
	actionDisplayName="Set the visibility of the FireMode HUD component"
	actionHelp="Sets the visibility of the FireMode indicator"
	category="Script"
}