class IdleAimAroundGoal extends AimAroundGoal
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

defaultproperties
{
	ExtraDoorWeight=0.3330000
	bUseUpperBodyProcedurally=false
	bAimOnlyIfCharacterResourcesAvailable=true
	UpperBodyAnimBehaviorClientId=3
	bInitialDelay=true
	MinInitialDelayTime=2.0000000
	Priority=30
	goalName="IdleAimAround"
	bPermanent=true
}