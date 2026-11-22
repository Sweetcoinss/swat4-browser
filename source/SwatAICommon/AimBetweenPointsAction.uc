class AimBetweenPointsAction extends SwatWeaponAction
	collapsecategories
	hidecategories(Object,InternalParameters);

const MinPauseTime = 0.2;
const MaxPauseTime = 1.0;

latent function AimBetweenPoints()
{
	local int i, TotalPoints;
	local Vector CurrentPoint;

	TotalPoints = AimBetweenPointsGoal(achievingGoal).GetNumberOfPoints();
	i = 0;
	J0x21:

	if(Less_IntInt(i, TotalPoints))
	{
		CurrentPoint = AimBetweenPointsGoal(achievingGoal).GetPoint(i);
		AimAndHoldAtPoint(CurrentPoint, 0.2000000, 1.0000000);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x21;
	}
	return;
}

state Running
{Begin:

	AimBetweenPoints();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.AimBetweenPointsGoal'
}