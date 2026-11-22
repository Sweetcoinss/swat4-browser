class ActionTrainerStopAnim extends TrainerScriptActionBase
	editinlinenew
	collapsecategories
	hidecategories(Object);

latent function Variable execute()
{
	local SwatTrainer SwatTrainer;

	SwatTrainer = GetSwatTrainer();
	if(NotEqual_ObjectObject(SwatTrainer, none))
	{
		SwatTrainer.AnimStopSpecial();
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = "Trainer AI - stop looping animation";
	return;
}

defaultproperties
{
	actionDisplayName="Trainer - Stop Looping Animation"
	actionHelp="Stops a looping animation on the Trainer AI."
	category="AI"
}