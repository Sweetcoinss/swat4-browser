class ActionFailDoNotSpecialObjective extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name DoNotSpecialObjectiveName;

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
		if(EqualEqual_NameName(Objectives.Objectives[i].Name, DoNotSpecialObjectiveName))
		{
			AssertWithDescription(Objectives.Objectives[i].IsA('DoNot_Special'), Concat_StrStr(Concat_StrStr("[tcohen] ActionFailDoNotSpecialObjective::Execute() The Objective named ", string(DoNotSpecialObjectiveName)), " is not a DoNot_Special type of Objective.  This Action can only be used on Objectives of class DoNot_Special."));
			DoNot_Special(Objectives.Objectives[i]).OnSpecialGameEvent('None');
			return none;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x44;
	}
	AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ActionFailDoNotSpecialObjective::Execute() The Objective named ", string(DoNotSpecialObjectiveName)), " was not found to be a current Objective."));
	return none;
	return;
}

function editorDisplayString(out string S)
{
	if(EqualEqual_NameName(DoNotSpecialObjectiveName, 'None'))
	{
		S = "Fail a 'DoNot_Special' Mission Objective.";
	}
	else
	{
		S = Concat_StrStr(Concat_StrStr("Fail the '", string(DoNotSpecialObjectiveName)), "' Mission Objective.");
	}
	return;
}

defaultproperties
{
	actionDisplayName="Fail a 'DoNot_Special' Mission Objective."
	actionHelp="Fails a 'DoNot_Special' Mission Objective."
	category="Objectives"
}