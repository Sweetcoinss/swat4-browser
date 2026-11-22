class ActionSetTrainingText extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name TrainingText;

latent function Variable execute()
{
	SwatRepo(parentScript.Level.GetRepo()).GetTrainingTextManager().SetTrainingText(TrainingText);
	return none;
	return;
}

function editorDisplayString(out string S)
{
	if(EqualEqual_NameName(TrainingText, 'None'))
	{
		S = "Clear the training text control.";
	}
	else
	{
		S = Concat_StrStr(Concat_StrStr("Display the ", string(TrainingText)), " training text.");
	}
	return;
}

defaultproperties
{
	actionDisplayName="Set the contents of the training text control"
	actionHelp="Sets the contents of the training text control"
	category="Script"
}