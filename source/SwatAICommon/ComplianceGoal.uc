class ComplianceGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var private bool bHasCompliedAlready;
var private bool bCanBeArrested;

function bool CanBeArrested()
{
	return bCanBeArrested;
	return;
}

function SetCanBeArrested()
{
	bCanBeArrested = true;
	return;
}

function bool HasCompliedAlready()
{
	return bHasCompliedAlready;
	return;
}

function SetHasCompliedAlready()
{
	bHasCompliedAlready = true;
	return;
}

defaultproperties
{
	Priority=96
	goalName="Compliance"
}