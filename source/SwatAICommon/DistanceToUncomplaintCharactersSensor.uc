class DistanceToUncomplaintCharactersSensor extends DistanceSensor;

const kDistanceToUncompliantUpdateRate = 0.1;

var private Pawn ClosestUncompliantCharacter;

function bool IsWithinRequiredDistance()
{
	local Pawn OurPawn;
	local float DistanceToCharacter;

	OurPawn = sensorAction.m_pawn;
	assert(NotEqual_ObjectObject(OurPawn, none));
	ClosestUncompliantCharacter = SwatAIRepository(OurPawn.Level.AIRepo).GetClosestUncompliantViewableAIInRoom(OurPawn.GetRoomName(), OurPawn, 'SwatAICharacter');
	if(NotEqual_ObjectObject(ClosestUncompliantCharacter, none))
	{
		DistanceToCharacter = VSize(Subtract_VectorVector(ClosestUncompliantCharacter.Location, OurPawn.Location));
		return Less_FloatFloat(DistanceToCharacter, RequiredDistance);
	}
	else
	{
		return false;
	}
	return;
}

protected function SetWithinSensorValue()
{
	setObjectValue(ClosestUncompliantCharacter);
	return;
}

protected function SetOutsideSensorValue()
{
	setObjectValue(none);
	return;
}

overloaded function setParameters(float inRequiredDistance)
{
	SetUseNavigationDistance(false);
	SetRequiredDistance(inRequiredDistance);
	DistanceSensorUpdateRate = 0.1000000;
	PostSetParameters();
	return;
}
