class CommanderGoal extends SwatCharacterGoal
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) PatrolList Patrol;
var(Parameters) bool bStartIncapacitated;
var(Parameters) name StartIncapacitateIdleCategoryOverride;

function SetPatrol(PatrolList inPatrol)
{
	Patrol = inPatrol;
	return;
}

function BecomeIncapacitated(optional name IncapacitatedIdleCategoryOverride)
{
	if(EqualEqual_ObjectObject(achievingAction, none))
	{
		bStartIncapacitated = true;
		StartIncapacitateIdleCategoryOverride = IncapacitatedIdleCategoryOverride;
	}
	else
	{
		assert(NotEqual_ObjectObject(CommanderAction(achievingAction), none));
		CommanderAction(achievingAction).BecomeIncapacitated();
	}
	return;
}

defaultproperties
{
	goalName="Commander"
	bPermanent=true
}