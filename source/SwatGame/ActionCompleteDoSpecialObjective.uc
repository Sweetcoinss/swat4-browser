class ActionCompleteDoSpecialObjective extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name DoSpecialObjectiveName;

latent function Variable execute()
{
	local int i;
	local MissionObjectives Objectives;

	super.execute();
	Objectives = SwatRepo(parentScript.Level.GetRepo()).MissionObjectives;
	assert(NotEqual_ObjectObject(Objectives, none));
	i = 0;
	J0x44:

	if(Less_IntInt(i, Objectives.Objectives.Length))
	{
		if(EqualEqual_NameName(Objectives.Objectives[i].Name, DoSpecialObjectiveName))
		{
			AssertWithDescription(Objectives.Objectives[i].IsA('Do_Special'), Concat_StrStr(Concat_StrStr("[tcohen] ActionCompleteDoSpecialObjective::Execute() The Objective named ", string(DoSpecialObjectiveName)), " is not a Do_Special type of Objective.  This Action can only be used on Objectives of class Do_Special."));
			Do_Special(Objectives.Objectives[i]).OnSpecialGameEvent('None');
			return none;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x44;
	}
	AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ActionCompleteDoSpecialObjective::Execute() The Objective named ", string(DoSpecialObjectiveName)), " was not found to be a current Objective."));
	return none;
	return;
}

function editorDisplayString(out string S)
{
	if(EqualEqual_NameName(DoSpecialObjectiveName, 'None'))
	{
		S = "Complete a 'Do_Special' Mission Objective.";
	}
	else
	{
		S = Concat_StrStr(Concat_StrStr("Complete the '", string(DoSpecialObjectiveName)), "' Mission Objective.");
	}
	return;
}

defaultproperties
{
	actionDisplayName="Complete a 'Do_Special' Mission Objective."
	actionHelp="Completes a 'Do_Special' Mission Objective."
	category="Objectives"
}