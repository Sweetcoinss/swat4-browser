class ActionTrainerLookAtPlayer extends TrainerScriptActionBase
	editinlinenew
	collapsecategories
	hidecategories(Object);

latent function Variable execute()
{
	local SwatTrainer SwatTrainer;
	local Pawn PlayerPawn;

	SwatTrainer = GetSwatTrainer();
	if(NotEqual_ObjectObject(parentScript.Level.GetLocalPlayerController(), none))
	{
		PlayerPawn = parentScript.Level.GetLocalPlayerController().Pawn;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SwatTrainer, none), NotEqual_ObjectObject(PlayerPawn, none)))
	{
		SwatTrainer.AnimSetFlag(2, true);
		SwatTrainer.AimAtActor(PlayerPawn);
		SwatTrainer.AnimSnapBaseToAim();
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = "Trainer AI - look at player";
	return;
}

defaultproperties
{
	actionDisplayName="Trainer - Look At Player"
	actionHelp="Causes the Trainer AI to look at the player."
	category="AI"
}