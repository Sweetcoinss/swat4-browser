class TriggerRadius extends Trigger
	config
	placeable
	hidecategories(Karma,Events,Force,Karma,Lighting,LightColor,Movement,Sound);

var int maxEnterCount;
var int maxExitCount;
var bool doLOSCheck;
var int enterCount;
var int exitCount;

function Touch(Actor Other)
{
	local int i;

	if(IsOverlapping(Other))
	{
		if(checkLOS(Other))
		{
			SLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Trigger ", string(Label)), " entered by "), string(Other.Label)));
			dispatchEnter(Other);
		}
	}
	else
	{
		i = 0;
		J0x6C:

		if(Less_IntInt(i, Touching.Length))
		{
			if(EqualEqual_ObjectObject(Touching[i], Other))
			{
				Touching.Remove(i, 1);
				// [Explicit Break]
				goto J0xAA;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x6C;
		}
		J0xAA:

		i = 0;
		J0xB1:

		if(Less_IntInt(i, Other.Touching.Length))
		{
			if(EqualEqual_ObjectObject(Other.Touching[i], self))
			{
				Other.Touching.Remove(i, 1);
				// [Explicit Break]
				goto J0x106;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xB1;
		}
	}
	J0x106:

	return;
}

function UnTouch(Actor Other)
{
	if(checkLOS(Other))
	{
		SLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Trigger ", string(Label)), " exited by "), string(Other.Label)));
		dispatchExit(Other);
	}
	return;
}

function bool checkLOS(Actor triggerer)
{
	local Vector HitLocation, HitNormal;

	return OrOr_BoolBool(Not_PreBool(doLOSCheck), EqualEqual_ObjectObject(triggerer, Trace(HitLocation, HitNormal, triggerer.Location)));
	return;
}

private function bool dispatchEnter(Actor Instigator)
{
	if(Not_PreBool(CanTrigger(Instigator)))
	{
		return false;
	}
	if(AndAnd_BoolBool(Greater_IntInt(maxEnterCount, -1), GreaterEqual_IntInt(enterCount, maxEnterCount)))
	{
		return false;
	}
	AddAdd_Int(enterCount);
	return dispatchTrigger(Instigator, Class'Gameplay.MessageTriggerEnter'.static.Allocate(self)., construct_NameName(Label, Instigator.Label));
	return;
}

private function bool dispatchExit(Actor Instigator)
{
	if(Not_PreBool(CanTrigger(Instigator)))
	{
		return false;
	}
	if(AndAnd_BoolBool(Greater_IntInt(maxExitCount, -1), GreaterEqual_IntInt(exitCount, maxExitCount)))
	{
		return false;
	}
	AddAdd_Int(exitCount);
	return dispatchTrigger(Instigator, Class'Gameplay.MessageTriggerExit'.static.Allocate(self)., construct_NameName(Label, Instigator.Label));
	return;
}

defaultproperties
{
	maxEnterCount=-1
	maxExitCount=-1
	CollisionRadius=40.0000000
	CollisionHeight=40.0000000
}