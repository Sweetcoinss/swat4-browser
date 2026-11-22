class UseOptiwandGoal extends SwatWeaponGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) bool bUseOverloadedViewOrigin;
var(Parameters) Vector OverloadedViewOrigin;
var(Parameters) bool bMirrorAroundCorner;
var(Parameters) Vector OptiwandViewDirection;

overloaded function Construct(AI_Resource R, Vector inOptiwandViewDirection)
{
	construct_AI_ResourceInt(R, Priority);
	OptiwandViewDirection = inOptiwandViewDirection;
	return;
}

function SetOverloadedViewOrigin(Vector inOverloadedViewOrigin)
{
	bUseOverloadedViewOrigin = true;
	OverloadedViewOrigin = inOverloadedViewOrigin;
	return;
}

function SetMirrorAroundCorner()
{
	bMirrorAroundCorner = true;
	return;
}

defaultproperties
{
	Priority=80
	goalName="UseOptiwand"
}