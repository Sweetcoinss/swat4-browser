class DistanceSensor extends AI_Sensor;

const kTwoDimensionalUpdateRate = 0.0;
const kPathfindingUpdateRate = 0.25;
const kMinDistanceForPathfinding = 150.0;

var Actor TargetActor;
var Vector TargetLocation;
var float RequiredDistance;
var bool bWithinRequiredDistance;
var bool bInitialTest;
var bool bUseNavigationDistance;
var bool bIgnoreHeightDistance;
var float CollisionHeightMultiplier;
var float DistanceSensorUpdateRate;
//var delegate<UpdateTarget> __UpdateTarget__Delegate;

function NotifyWithinRequiredDistance()
{
	if(OrOr_BoolBool(Not_PreBool(bWithinRequiredDistance), bInitialTest))
	{
		bWithinRequiredDistance = true;
		bInitialTest = false;
		SetWithinSensorValue();
	}
	return;
}

function NotifyOutsideRequiredDistance()
{
	if(OrOr_BoolBool(bWithinRequiredDistance, bInitialTest))
	{
		bWithinRequiredDistance = false;
		bInitialTest = false;
		SetOutsideSensorValue();
	}
	return;
}

protected function SetWithinSensorValue()
{
	setIntegerValue(1);
	return;
}

protected function SetOutsideSensorValue()
{
	setIntegerValue(0);
	return;
}

delegate UpdateTarget()
{
	return;
}

function ResetRequiredDistance(float inNewRequiredDistance)
{
	if(NotEqual_FloatFloat(RequiredDistance, inNewRequiredDistance))
	{
		RequiredDistance = inNewRequiredDistance;
		bInitialTest = true;
	}
	return;
}

function ResetTargetActor(Actor inNewTargetActor)
{
	assert(NotEqual_ObjectObject(inNewTargetActor, none));
	if(NotEqual_ObjectObject(TargetActor, inNewTargetActor))
	{
		TargetActor = inNewTargetActor;
		bInitialTest = true;
	}
	return;
}

function Vector GetTargetOrigin()
{
	if(NotEqual_ObjectObject(TargetActor, none))
	{
		return TargetActor.Location;
	}
	else
	{
		return TargetLocation;
	}
	return;
}

function bool IsWithinRequiredDistance()
{
	local float Distance2D, Distance, HeightDifference;
	local Vector TargetOrigin;

	TargetOrigin = GetTargetOrigin();
	Distance2D = VSize2D(Subtract_VectorVector(TargetOrigin, sensorAction.m_pawn.Location));
	HeightDifference = Abs(Subtract_FloatFloat(TargetOrigin.Z, sensorAction.m_pawn.Location.Z));
	if(AndAnd_BoolBool(bUseNavigationDistance, OrOr_BoolBool(Greater_FloatFloat(Distance2D, 150.0000000), OrOr_BoolBool(bIgnoreHeightDistance, Greater_FloatFloat(HeightDifference, Multiply_FloatFloat(CollisionHeightMultiplier, sensorAction.m_pawn.CollisionHeight))))))
	{
		if(NotEqual_ObjectObject(TargetActor, none))
		{
			Distance = sensorAction.m_pawn.GetPathfindingDistanceToActor(TargetActor, true);
		}
		else
		{
			if(sensorAction.m_pawn.FastTrace(TargetLocation, sensorAction.m_pawn.Location))
			{
				Distance = VSize(Subtract_VectorVector(TargetLocation, sensorAction.m_pawn.Location));
			}
			else
			{
				Distance = sensorAction.m_pawn.GetPathfindingDistanceToPoint(TargetLocation, true);
			}
		}
		DistanceSensorUpdateRate = 0.2500000;
		return Less_FloatFloat(Distance, RequiredDistance);
	}
	else
	{
		DistanceSensorUpdateRate = 0.0000000;
		return AndAnd_BoolBool(LessEqual_FloatFloat(Distance2D, RequiredDistance), OrOr_BoolBool(bIgnoreHeightDistance, Less_FloatFloat(HeightDifference, Multiply_FloatFloat(CollisionHeightMultiplier, sensorAction.m_pawn.CollisionHeight))));
	}
	return;
}

function SetRequiredDistance(float inRequiredDistance)
{
	assert(GreaterEqual_FloatFloat(inRequiredDistance, 0.0000000));
	RequiredDistance = inRequiredDistance;
	return;
}

function SetUseNavigationDistance(bool inUseNavigationDistance)
{
	bUseNavigationDistance = inUseNavigationDistance;
	return;
}

function SetIgnoreHeightDistance(bool inIgnoreHeightDistance)
{
	bIgnoreHeightDistance = inIgnoreHeightDistance;
	return;
}

function SetCollisionHeightMultiplier(float NewCollisionHeightMultiplier)
{
	assert(Greater_FloatFloat(NewCollisionHeightMultiplier, 0.0000000));
	CollisionHeightMultiplier = NewCollisionHeightMultiplier;
	return;
}

overloaded function setParameters()
{
	return;
}

overloaded function setParameters(float inRequiredDistance, Actor inTargetActor, optional bool inUseNavigationDistance)
{
	SetUseNavigationDistance(inUseNavigationDistance);
	SetRequiredDistance(inRequiredDistance);
	assert(NotEqual_ObjectObject(inTargetActor, none));
	TargetActor = inTargetActor;
	PostSetParameters();
	return;
}

overloaded function setParameters(float inRequiredDistance, Vector inTargetLocation, optional bool inUseNavigationDistance)
{
	SetUseNavigationDistance(inUseNavigationDistance);
	SetRequiredDistance(inRequiredDistance);
	TargetLocation = inTargetLocation;
	PostSetParameters();
	return;
}

protected function PostSetParameters()
{
	if(Greater_FloatFloat(RequiredDistance, 0.0000000))
	{
		assert(NotEqual_ObjectObject(sensorAction, none));
		assert(sensorAction.IsA('DistanceSensorAction'));
		if(sensorAction.m_pawn.logTyrion)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(sensorAction.Name), " told to run by "), string(Name)), " RequiredDistance is: "), string(RequiredDistance)));
		}
		bInitialTest = true;
		if(sensorAction.IsIdle())
		{
			sensorAction.runAction();
		}
	}
	return;
}

defaultproperties
{
	CollisionHeightMultiplier=1.0000000
}