class DistanceToOfficersSensor extends DistanceSensor;

var private bool bRequiresLineOfSight;

function bool IsWithinRequiredDistance()
{
	local Hive HiveMind;

	HiveMind = SwatAIRepository(sensorAction.m_pawn.Level.AIRepo).GetHive();
	assert(NotEqual_ObjectObject(HiveMind, none));
	assert(NotEqual_ObjectObject(sensorAction.m_pawn, none));
	return HiveMind.IsPawnWithinDistanceOfOfficers(sensorAction.m_pawn, RequiredDistance, bRequiresLineOfSight);
	return;
}

overloaded function setParameters(float inRequiredDistance, bool bInRequiresLineOfSight)
{
	SetUseNavigationDistance(false);
	SetRequiredDistance(inRequiredDistance);
	DistanceSensorUpdateRate = 0.0000000;
	bRequiresLineOfSight = bInRequiresLineOfSight;
	PostSetParameters();
	return;
}
