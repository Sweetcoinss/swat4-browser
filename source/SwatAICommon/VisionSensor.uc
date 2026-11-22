class VisionSensor extends AI_Sensor implements IVisionNotification;

var array<Pawn> pawns;
var Pawn LastPawnSeen;
var float LastTimeSeen;
var Pawn LastPawnLost;
var Vector LastLostPawnLocation;
var float LastTimeLost;

function OnViewerSawPawn(Pawn Viewer, Pawn Seen)
{
	local int i;

	if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(Seen)))
	{
		return;
	}
	i = 0;
	J0x22:

	if(Less_IntInt(i, pawns.Length))
	{
		if(EqualEqual_ObjectObject(pawns[i], Seen))
		{
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x22;
	}
	pawns[pawns.Length] = Seen;
	LastPawnSeen = Seen;
	LastPawnLost = none;
	LastTimeSeen = Viewer.Level.TimeSeconds;
	setIntegerValue(pawns.Length);
	return;
}

function OnViewerLostPawn(Pawn Viewer, Pawn Lost)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		if(EqualEqual_ObjectObject(pawns[i], Lost))
		{
			pawns.Remove(i, 1);
			LastPawnSeen = none;
			LastPawnLost = Lost;
			LastLostPawnLocation = Lost.Location;
			LastTimeLost = Viewer.Level.TimeSeconds;
			setIntegerValue(pawns.Length);
			// [Explicit Break]
			goto J0x94;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x94:

	return;
}

function Begin()
{
	ISwatAI(CommonSensorAction(sensorAction).Pawn()).RegisterVisionNotification(self);
	return;
}

function cleanup()
{
	ISwatAI(CommonSensorAction(sensorAction).Pawn()).UnregisterVisionNotification(self);
	return;
}

function bool IsCurrentlySeen(Pawn TestPawn)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		if(EqualEqual_ObjectObject(pawns[i], TestPawn))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function Pawn GetVisibleConsciousPawnClosestTo(Vector testLocation, optional name PawnClassType)
{
	local int i;
	local Pawn Closest, Iter;
	local float ClosestDistance, IterDistance;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		Iter = pawns[i];
		if(Class'Engine.Pawn'.static.checkConscious(Iter))
		{
			if(AndAnd_BoolBool(NotEqual_NameName(PawnClassType, 'None'), Not_PreBool(Iter.IsA(PawnClassType))))
			{
				// [Explicit Continue]
				goto J0xB8;
			}
			IterDistance = VSize(Subtract_VectorVector(testLocation, Iter.Location));
			if(OrOr_BoolBool(EqualEqual_ObjectObject(Closest, none), Less_FloatFloat(IterDistance, ClosestDistance)))
			{
				Closest = Iter;
				ClosestDistance = IterDistance;
			}
		}
		J0xB8:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return Closest;
	return;
}
