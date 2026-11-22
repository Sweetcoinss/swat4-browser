class ActionCinematicExit extends Action
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

latent function Variable execute()
{
	super.execute();
	cinematicExit();
	if(NotEqual_ObjectObject(parentScript.Level.GetLocalPlayerController(), none))
	{
		PlayerController(parentScript.Level.GetLocalPlayerController().Pawn.Controller).myHUD.bHideHUD = false;
	}
	return none;
	return;
}

// Export UActionCinematicExit::execcinematicExit(FFrame&, void* const)
native static function cinematicExit();

function editorDisplayString(out string S)
{
	S = "Exit cinematic mode";
	return;
}

defaultproperties
{
	actionDisplayName="Cinematic Mode: Exit"
	actionHelp="Exit cinematic mode"
	category="Cinematic"
}