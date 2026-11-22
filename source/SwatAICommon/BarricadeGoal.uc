class BarricadeGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector StimuliOrigin;
var(Parameters) bool bDelayBarricade;
var(Parameters) bool bCanCloseDoors;

overloaded function Construct(AI_Resource R, Vector inStimuliOrigin, bool bInDelayBarricade, bool bInCanCloseDoors)
{
	construct_AI_ResourceInt(R, Priority);
	StimuliOrigin = inStimuliOrigin;
	bDelayBarricade = bInDelayBarricade;
	bCanCloseDoors = bInCanCloseDoors;
	return;
}

defaultproperties
{
	Priority=60
	goalName="Barricade"
}