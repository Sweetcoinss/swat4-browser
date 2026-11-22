class ActionExitLoop extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

latent function Variable execute()
{
	super.execute();
	parentScript.exitLoop();
	return none;
	return;
}

defaultproperties
{
	actionDisplayName="Exit Loop"
	actionHelp="Ends execution of the current loop. Does nothing if no loop is running"
	category="Script"
}