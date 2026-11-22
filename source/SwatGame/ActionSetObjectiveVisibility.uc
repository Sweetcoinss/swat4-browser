class ActionSetObjectiveVisibility extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name ObjectiveName;
var bool Visible;

latent function Variable execute()
{
	SwatGameReplicationInfo(parentScript.Level.GetGameReplicationInfo()).SetObjectiveVisibility(ObjectiveName, Visible);
	return none;
	return;
}

function editorDisplayString(out string S)
{
	local string ShowHide;

	if(Visible)
	{
		ShowHide = "Show";
	}
	else
	{
		ShowHide = "Hide";
	}
	if(EqualEqual_NameName(ObjectiveName, 'None'))
	{
		S = Concat_StrStr(ShowHide, " some Objective");
	}
	else
	{
		S = Concat_StrStr(Concat_StrStr(ShowHide, " the objective named "), string(ObjectiveName));
	}
	return;
}

defaultproperties
{
	Visible=true
	actionDisplayName="Show or Hide an Objective"
	actionHelp="Shows or Hides an Objective"
	category="Objectives"
}