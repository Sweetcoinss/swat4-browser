class StaircaseAimVolume extends Volume
	config
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var array<string> StaircaseAimPointNames;
var array<StaircaseAimPoint> StaircaseAimPoints;

event PostBeginPlay()
{
	local StaircaseAimPoint StaircaseAimPoint;
	local int i;

	super.PostBeginPlay();
	foreach AllActors(Class'SwatAICommon.StaircaseAimPoint', StaircaseAimPoint)
	{
		i = 0;
		J0x1D:

		if(Less_IntInt(i, StaircaseAimPointNames.Length))
		{
			if(ComplementEqual_StrStr(StaircaseAimPointNames[i], string(StaircaseAimPoint.Name)))
			{
				StaircaseAimPoints[StaircaseAimPoints.Length] = StaircaseAimPoint;
				continue;
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1D;
		}
	}
	return;
}

event Touch(Actor Other)
{
	local ISwatAI SwatAI;

	super(Actor).Touch(Other);
	SwatAI = ISwatAI(Other);
	if(NotEqual_ObjectObject(SwatAI, none))
	{
		SwatAI.OnTouchedStaircaseAimVolume(self);
	}
	return;
}

event UnTouch(Actor Other)
{
	local ISwatAI SwatAI;

	super(Actor).UnTouch(Other);
	SwatAI = ISwatAI(Other);
	if(NotEqual_ObjectObject(SwatAI, none))
	{
		SwatAI.OnUntouchedStaircaseAimVolume(self);
	}
	return;
}

function int GetNumStaircaseAimPoints()
{
	return StaircaseAimPoints.Length;
	return;
}

function StaircaseAimPoint GetStaircaseAimPointAtIndex(int Index)
{
	assert(AndAnd_BoolBool(GreaterEqual_IntInt(Index, 0), Less_IntInt(Index, StaircaseAimPoints.Length)));
	return StaircaseAimPoints[Index];
	return;
}

defaultproperties
{
	bOccludedByGeometryInEditor=true
}