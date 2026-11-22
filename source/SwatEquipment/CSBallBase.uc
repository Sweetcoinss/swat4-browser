class CSBallBase extends SwatProjectile
	abstract
	config(SwatEquipment)
	hidecategories(Karma);

var config float CloudRadius;
var config float CloudDuration;
var config float AIGassedDuration;
var config float PlayerGassedDuration;
var config float UpdatePeriod;
var config float SPPlayerProtectiveEquipmentDurationScaleFactor;
var config float MPPlayerProtectiveEquipmentDurationScaleFactor;
var Vector PreviousLocation;

simulated function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	PreviousLocation = Location;
	return;
}

simulated function PostBump(Actor Other)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(Other.IsA('Door')), Not_PreBool(Other.bHidden)), Not_PreBool(Other.IsA('CSBallBase'))), NotEqual_ObjectObject(Other, Owner)))
	{
		TriggerEffectEvent('BulletHit');
		GotoState('Hit');
	}
	return;
}

simulated event HitWall(Vector HitNormal, Actor HitWall)
{
	TriggerEffectEvent('BulletHit', HitWall, none, Location, Rotator(HitNormal));
	GotoState('Hit');
	return;
}

simulated event Touch(Actor Other)
{
	local Actor HitActor;
	local Vector TraceEnd, HitLocation, HitNormal;

	TraceEnd = Add_VectorVector(PreviousLocation, Multiply_FloatVector(float(2), Subtract_VectorVector(Location, PreviousLocation)));
	HitActor = Trace(HitLocation, HitNormal, TraceEnd, PreviousLocation, true,,, false, false, true);
	if(Level.AnalyzeBallistics)
	{
		if(NotEqual_ObjectObject(HitActor, none))
		{
			Log(Concat_StrStr("... HitActor=", string(HitActor)));
		}
		else
		{
			Log("... HitActor=None");
		}
	}
	if(NotEqual_ObjectObject(HitActor, none))
	{
		if(AndAnd_BoolBool(HitActor.bHidden, NotEqual_NameName(HitActor.Class.Name, 'LevelInfo')))
		{
			Log("... invisible & !BSP: returning");
			return;
		}
		SetCollision(false, false, false);
		SetLocation(HitLocation);
		GotoState('Hit');
		TriggerEffectEvent('BulletHit');
	}
	return;
}

function Tick(float dTime)
{
	PreviousLocation = Location;
	return;
}

simulated state Hit
{
	simulated event Timer()
	{
		local Pawn Pawn;
		local Vector ViewPoint;
		local Actor HitActor;
		local Vector HitLocation, HitNormal;
		local Material HitMaterial;
		local SwatDoor HitDoor;
		local bool PawnShouldBeAffected;

		Pawn = Level.PawnList;
		J0x14:

		if(NotEqual_ObjectObject(Pawn, none))
		{
			if(Pawn.IsA('SwatAI'))
			{
				ViewPoint = SwatAI(Pawn).GetViewPoint();
			}
			else
			{
				if(Pawn.IsA('SwatPlayer'))
				{
					ViewPoint = SwatPlayer(Pawn).GetThirdPersonEyesLocation();
				}
				else
				{
					ViewPoint = Pawn.GetAimOrigin();
				}
			}
			if(Greater_FloatFloat(VSize(Subtract_VectorVector(ViewPoint, Location)), CloudRadius))
			{
			}
			else
			{
				PawnShouldBeAffected = true;
				foreach TraceActors(Class'Engine.Actor', HitActor, HitLocation, HitNormal, HitMaterial, ViewPoint, Location)
				{
					if(EqualEqual_NameName(HitActor.Class.Name, 'LevelInfo'))
					{
						PawnShouldBeAffected = false;
						break;
					}
					if(OrOr_BoolBool(EqualEqual_IntInt(int(HitActor.DrawType), int(0)), HitActor.bHidden))
					{
						continue;
					}
					if(HitActor.IsA('SwatDoor'))
					{
						continue;
					}
					if(HitActor.IsA('DoorModel'))
					{
						PawnShouldBeAffected = false;
						break;
					}
				}
				if(PawnShouldBeAffected)
				{
					if(Pawn.IsA('SwatPlayer'))
					{
						IReactToCSGas(Pawn).ReactToCSGas(self, PlayerGassedDuration, SPPlayerProtectiveEquipmentDurationScaleFactor, MPPlayerProtectiveEquipmentDurationScaleFactor);
						if(Level.GetEngine().EnableDevTools)
						{
							MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("CSBallBase::Timer() calling ReactToCSGas() on: ", string(Pawn)), ", PlayerGassedDuration is: "), string(PlayerGassedDuration)), ", SP/MP duration scale factor is "), string(SPPlayerProtectiveEquipmentDurationScaleFactor)), "/"), string(MPPlayerProtectiveEquipmentDurationScaleFactor)), " for protective equipment"));
						}
					}
					else
					{
						IReactToCSGas(Pawn).ReactToCSGas(self, AIGassedDuration, 1.0000000, 1.0000000);
						if(Level.GetEngine().EnableDevTools)
						{
							MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("CSBallBase::Timer() calling ReactToCSGas() on: ", string(Pawn)), ", AIGassedDuration is: "), string(AIGassedDuration)), ", SP/MP duration scale factor is 1/1 for protective equipment"));
						}
					}
				}
			}
			Pawn = Pawn.nextPawn;
			// [Loop Continue]
			goto J0x14;
		}
		return;
	}

	function BeginState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("CSBallBase::Hit state beginning");
		}
		SetPhysics(0);
		SetDrawType(0);
		SetCollision(false, false, false);
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			SetTimer(UpdatePeriod, true);
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog("CSBallBase::Hit state calling timer");
			}
			Timer();
		}
		return;
	}
Begin:

	Sleep(CloudDuration);
	Destroy();
	stop;
}

defaultproperties
{
	CloudRadius=50.0000000
	CloudDuration=2.0000000
	AIGassedDuration=10.0000000
	PlayerGassedDuration=10.0000000
	UpdatePeriod=0.6000000
	MPPlayerProtectiveEquipmentDurationScaleFactor=0.2000000
	RemoteRole=0
	Texture=Texture'Engine_res.SunIcon'
	CollisionRadius=5.0000000
	CollisionHeight=5.0000000
}