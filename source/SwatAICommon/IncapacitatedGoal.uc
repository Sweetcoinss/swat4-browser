class IncapacitatedGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) name IncapaciatedIdleCategoryOverride;
var(Parameters) bool bIsInstantIncapacitation;

overloaded function Construct(AI_Resource R, bool bInIsInstantIncapacitation, optional name inIncapaciatedIdleCategoryOverride)
{
	construct_AI_ResourceInt(R, Priority);
	IncapaciatedIdleCategoryOverride = inIncapaciatedIdleCategoryOverride;
	bIsInstantIncapacitation = bInIsInstantIncapacitation;
	return;
}

defaultproperties
{
	Priority=100
	goalName="Incapacitated"
}