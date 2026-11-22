class Taser extends RoundBasedWeapon implements IInterestedPawnDied
	config(SwatEquipment)
	hidecategories(Karma);

enum EStickPolicy
{
	STICK_Nothing,                  // 0
	STICK_TaseablePawns,            // 1
	STICK_SkeletalMeshes,           // 2
	STICK_Actors,                   // 3
	STICK_AllGeometry,              // 4
	STICK_Always                    // 5
};

enum EProbeState
{
	PROBE_Traveling,                // 0
	PROBE_AfterHit,                 // 1
	PROBE_Slacking                  // 2
};

enum EWireState
{
	WIRE_AttachedToGun,             // 0
	WIRE_Falling                    // 1
};

struct TaserProbeShot
{
	var Vector TargetLocation;
	var Actor Victim;
	var name VictimBone;
	var TaserProbeBase Probe;
	var TaserWire TaserWire;
	var Vector TargetBoneOffset;
	var Vector ProbeInitialLocation;
	var Vector ProbeOriginLocation;
	var Rotator ProbeOriginRotation;
	var float CurrentTravelTime;
	var float TravelTime;
	var float PostTravelTime;
	var Taser.EProbeState ProbeState;
	var Taser.EWireState WireState;
	var Material HitMaterial;
	var bool StickToTarget;
	var bool TaserHit;
	var bool Active;
};

struct ProbeRecoilState
{
	var float recoilTime;
	var Vector initialVelocity;
	var float initialSpeed;
};

var config float PlayerTasedDuration;
var config float AITasedDuration;
var config Class<TaserProbeBase> ProbeClass;
var config float TaserAimSpread;
var config Taser.EStickPolicy StickToWhat;
var config name FirstPersonProbeBones[2];
var config name ThirdPersonProbeBones[2];
var config Vector FirstPersonProbeOffset[2];
var config Vector ThirdPersonProbeOffset[2];
var config float ProbeStickTime;
var config float ProbeFallDuration;
var config float FadeDuration;
var config float ProbeVisualSpeed;
var config float ProbeRecoilTime;
var config float ProbeFinalRecoilSpeed;
var config Class<TaserWire> TaserWireClass;
var config name WireZapAnimation[2];
var config name WireSlackAnimation[2];
var config float WireForceSlackTimeFraction;
var config float WireSlackAnimRate;
var config float WireSlackTweenTime;
var config float WireSlackStartSpeed;
var config float WireMinYZScale;
var config float WireMaxYZScale;
var config float WireAnimRate;
var config float WireMaxHeightFraction;
var config float WireMaxHeight;
var config name WireEndEffectorName;
var config float WireDetachDistance;
var private name ProbePartNames[2];
var private name WirePartNames[2];
var private TaserProbeShot probes[2];
var private ProbeRecoilState probeRecoils[2];
var private float ActualTasedDuration;
var private float MinTravelTime;
var private bool TaserHit;
var private bool ShouldTick;

function PostBeginPlay()
{
	super(HandheldEquipment).PostBeginPlay();
	Level.RegisterNotifyPawnDied(self);
	AssertWithDescription(NotEqual_ObjectObject(ProbeClass, none), "[tcohen] The TaserProbeClass for the Taser is invalid.  Please set this in SwatEquipment.ini, [SwatEquipment.Taser].");
	AssertWithDescription(NotEqual_ObjectObject(TaserWireClass, none), "[henry] The TaserWireClass for the Taser is invalid.  Please set this in SwatEquipment.ini, [SwatEquipment.Taser].");
	return;
}

simulated function OnOtherPawnDied(Pawn DeadPawn)
{
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(DeadPawn, Owner), EqualEqual_ObjectObject(DeadPawn, probes[0].Victim)), EqualEqual_ObjectObject(DeadPawn, probes[1].Victim)))
	{
		if(OrOr_BoolBool(probes[0].Active, probes[1].Active))
		{
			Log("Taser owner or victim was killed while the tasers were shot");
		}
		EndBothProbes();
		if(EqualEqual_ObjectObject(DeadPawn, Owner))
		{
			Level.UnRegisterNotifyPawnDied(self);
		}
	}
	return;
}

simulated function Destroyed()
{
	super(FiredWeapon).Destroyed();
	DestroyBothProbes();
	return;
}

simulated function ApplyTaserAimError(Rotator CenterFireDirection, out Rotator FireDirection1, out Rotator FireDirection2)
{
	local float Rho, Theta, XScale, YScale;
	local Vector xPlanarVec, yPlanarVec, zPlanarVec, spherePoint, diff, randPoint2,
		randPoint1;

	local float planarAimError, boundaryDist;

	planarAimError = Tan(Multiply_FloatFloat(GetAimError(), 0.0174533));
	Rho = Multiply_FloatFloat(Sqrt(FRand()), planarAimError);
	Theta = Multiply_FloatFloat(FRand(), 360.0000000);
	XScale = Multiply_FloatFloat(Rho, Cos(Multiply_FloatFloat(Theta, 0.0174533)));
	YScale = Multiply_FloatFloat(Rho, Sin(Multiply_FloatFloat(Theta, 0.0174533)));
	GetAxes(CenterFireDirection, xPlanarVec, yPlanarVec, zPlanarVec);
	spherePoint = Vector(CenterFireDirection);
	randPoint1 = Add_VectorVector(Add_VectorVector(spherePoint, Multiply_FloatVector(XScale, yPlanarVec)), Multiply_FloatVector(YScale, zPlanarVec));
	diff = Subtract_VectorVector(spherePoint, randPoint1);
	boundaryDist = Add_FloatFloat(VSize(diff), planarAimError);
	diff = Normal(diff);
	randPoint2 = Add_VectorVector(randPoint1, Multiply_VectorFloat(diff, FMin(Tan(Multiply_FloatFloat(TaserAimSpread, 0.0174533)), boundaryDist)));
	randPoint1 = Normal(randPoint1);
	randPoint2 = Normal(randPoint2);
	FireDirection1 = Rotator(randPoint1);
	FireDirection2 = Rotator(randPoint2);
	return;
}

simulated function TraceFire()
{
	local Vector StartLocation;
	local Rotator StartDirection, FireDirection1, FireDirection2;
	local Vector StartTrace, EndTrace;
	local Material MaterialHit;
	local Vector HitLocation, HitNormal, HitDiff;
	local Actor LocalVictim;
	local Actor.ESkeletalRegion HitRegion;
	local int i;
	local float spread;
	local Actor ActualTasedVictim;

	GetPerfectFireStart(StartLocation, StartDirection);
	if(true)
	{
		ApplyTaserAimError(StartDirection, FireDirection1, FireDirection2);
		StartDirection = FireDirection1;
	}
	else
	{
		FireDirection1 = StartDirection;
		FireDirection2 = StartDirection;
	}
	StartTrace = StartLocation;
	EndTrace = Add_VectorVector(StartLocation, Multiply_VectorFloat(Vector(StartDirection), float(Range)));
	i = 0;
	J0x7C:

	if(Less_IntInt(i, 2))
	{
		probes[i].Victim = none;
		probes[i].VictimBone = 'None';
		probes[i].HitMaterial = none;
		spread = 0.0000000;
		if(EqualEqual_IntInt(i, 0))
		{
			EndTrace = Add_VectorVector(StartLocation, Multiply_VectorFloat(Vector(FireDirection1), float(Range)));
		}
		else
		{
			EndTrace = Add_VectorVector(StartLocation, Multiply_VectorFloat(Vector(FireDirection2), float(Range)));
		}
		foreach TraceActors(Class'Engine.Actor', LocalVictim, HitLocation, HitNormal, MaterialHit, EndTrace, StartTrace,, true, HitRegion)
		{
			if(AndAnd_BoolBool(OrOr_BoolBool(LocalVictim.bHidden, EqualEqual_IntInt(int(LocalVictim.DrawType), int(0))), Not_PreBool(LocalVictim.IsA('LevelInfo'))))
			{
				continue;
			}
			if(LocalVictim.IsA('SwatDoor'))
			{
				continue;
			}
			if(Greater_FloatFloat(VDistSquared(HitLocation, StartLocation), Square(float(Range))))
			{
				HitDiff = Normal(Subtract_VectorVector(HitLocation, StartLocation));
				MultiplyEqual_VectorFloat(HitDiff, float(Range));
				EndTrace = Add_VectorVector(StartLocation, HitDiff);
				probes[i].Victim = none;
				probes[i].VictimBone = 'None';
				probes[i].TargetLocation = EndTrace;
				probes[i].TaserHit = false;
				break;
			}
			probes[i].Victim = LocalVictim;
			probes[i].VictimBone = GetLastTracedBone();
			probes[i].TargetLocation = HitLocation;
			probes[i].HitMaterial = MaterialHit;
			break;
		}
		if(EqualEqual_ObjectObject(probes[i].Victim, none))
		{
			probes[i].TargetLocation = EndTrace;
			probes[i].TaserHit = false;
			// [Explicit Continue]
			goto J0x31A;
		}
		probes[i].TaserHit = probes[i].Victim.IsA('ICanBeTased');
		J0x31A:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x7C;
	}
	ActualTasedDuration = ProbeFallDuration;
	TaserHit = OrOr_BoolBool(probes[0].TaserHit, probes[1].TaserHit);
	ActualTasedVictim = none;
	if(AndAnd_BoolBool(AndAnd_BoolBool(probes[0].TaserHit, probes[1].TaserHit), NotEqual_ObjectObject(probes[0].Victim, probes[1].Victim)))
	{
		if(Less_FloatFloat(VDistSquared(probes[0].TargetLocation, probes[0].ProbeOriginLocation), VDistSquared(probes[1].TargetLocation, probes[1].ProbeOriginLocation)))
		{
			ActualTasedVictim = probes[0].Victim;
		}
		else
		{
			ActualTasedVictim = probes[1].Victim;
		}
	}
	else
	{
		if(probes[0].TaserHit)
		{
			ActualTasedVictim = probes[0].Victim;
		}
		else
		{
			if(probes[1].TaserHit)
			{
				ActualTasedVictim = probes[1].Victim;
			}
		}
	}
	if(NotEqual_ObjectObject(ActualTasedVictim, none))
	{
		ICanBeTased(ActualTasedVictim).ReactToBeingTased(self, PlayerTasedDuration, AITasedDuration);
		if(ClassIsChildOf(ActualTasedVictim.Class, Class'SwatGame.SwatPlayer'))
		{
			ActualTasedDuration = PlayerTasedDuration;
		}
		else
		{
			ActualTasedDuration = AITasedDuration;
		}
	}
	InitializeProbes();
	Level.GetLocalPlayerController().AddRecoil(RecoilBackDuration, RecoilForeDuration, RecoilMagnitude);
	return;
}

simulated function InitializeProbes()
{
	local Vector targetOffset;
	local Coords boneCoords;
	local float travelDistance, heightPeak;
	local int i;

	ShouldTick = true;
	i = 0;
	J0x0F:

	if(Less_IntInt(i, 2))
	{
		probes[i].Active = true;
		probes[i].ProbeState = 0;
		probes[i].WireState = 0;
		if(NotEqual_ObjectObject(probes[i].Victim, none))
		{
			if(NotEqual_NameName(probes[i].VictimBone, 'None'))
			{
				boneCoords = probes[i].Victim.GetBoneCoords(probes[i].VictimBone, true);
				targetOffset = Subtract_VectorVector(probes[i].TargetLocation, boneCoords.Origin);
				probes[i].TargetBoneOffset.X = Dot_VectorVector(targetOffset, boneCoords.XAxis);
				probes[i].TargetBoneOffset.Y = Dot_VectorVector(targetOffset, boneCoords.YAxis);
				probes[i].TargetBoneOffset.Z = Dot_VectorVector(targetOffset, boneCoords.ZAxis);
			}
			else
			{
				probes[i].TargetBoneOffset = Subtract_VectorVector(probes[i].TargetLocation, probes[i].Victim.Location);
			}
		}
		else
		{
			probes[i].TargetBoneOffset.X = 0.0000000;
			probes[i].TargetBoneOffset.Y = 0.0000000;
			probes[i].TargetBoneOffset.Z = 0.0000000;
		}
		GetProbeOriginFrame(i);
		probes[i].ProbeInitialLocation = probes[i].ProbeOriginLocation;
		if(EqualEqual_ObjectObject(probes[i].Probe, none))
		{
			probes[i].Probe = Spawn(ProbeClass, self, ProbePartNames[i], probes[i].ProbeOriginLocation, probes[i].ProbeOriginRotation, true);
		}
		else
		{
			probes[i].Probe.SetLocation(probes[i].ProbeOriginLocation);
			probes[i].Probe.SetRotation(probes[i].ProbeOriginRotation);
		}
		assert(NotEqual_ObjectObject(probes[i].Probe, none));
		probes[i].Probe.ResetState();
		probes[i].Probe.OptimizeIn();
		probes[i].Probe.Show();
		if(EqualEqual_ObjectObject(probes[i].TaserWire, none))
		{
			probes[i].TaserWire = Spawn(TaserWireClass, self, WirePartNames[i], probes[i].ProbeOriginLocation, probes[i].ProbeOriginRotation, true);
		}
		else
		{
			probes[i].TaserWire.SetLocation(probes[i].ProbeOriginLocation);
			probes[i].TaserWire.SetRotation(probes[i].ProbeOriginRotation);
		}
		assert(NotEqual_ObjectObject(probes[i].TaserWire, none));
		probes[i].TaserWire.OptimizeIn();
		probes[i].TaserWire.Show();
		probes[i].TaserWire.SetPhysics(0);
		probes[i].TaserWire.minYZScale = WireMinYZScale;
		probes[i].TaserWire.maxYZScale = WireMaxYZScale;
		probes[i].TaserWire.endEffectorName = WireEndEffectorName;
		travelDistance = VSize(Subtract_VectorVector(probes[i].Probe.Location, probes[i].TargetLocation));
		travelDistance = FMax(travelDistance, 0.0100000);
		probes[i].TravelTime = Divide_FloatFloat(travelDistance, ProbeVisualSpeed);
		probes[i].CurrentTravelTime = 0.0000000;
		heightPeak = FMin(Multiply_FloatFloat(WireMaxHeightFraction, travelDistance), WireMaxHeight);
		probes[i].Probe.Velocity = Divide_VectorFloat(Subtract_VectorVector(probes[i].TargetLocation, probes[i].ProbeOriginLocation), probes[i].TravelTime);
		SubtractEqual_FloatFloat(probes[i].Probe.Velocity.Z, Multiply_FloatFloat(4.0000000, heightPeak));
		probes[i].TaserWire.PlayAnim(WireZapAnimation[i], WireAnimRate);
		probes[i].StickToTarget = false;
		if(NotEqual_NameName(probes[i].VictimBone, 'None'))
		{
			if(AndAnd_BoolBool(probes[i].Victim.IsA('ICanBeTased'), ICanBeTased(probes[i].Victim).IsVulnerableToTaser()))
			{
				if(GreaterEqual_IntInt(int(StickToWhat), int(1)))
				{
					probes[i].StickToTarget = true;
				}
			}
			else
			{
				if(GreaterEqual_IntInt(int(StickToWhat), int(2)))
				{
					probes[i].StickToTarget = true;
				}
			}
		}
		else
		{
			if(NotEqual_ObjectObject(probes[i].Victim, none))
			{
				if(probes[i].Victim.IsA('LevelInfo'))
				{
					if(GreaterEqual_IntInt(int(StickToWhat), int(4)))
					{
						probes[i].StickToTarget = true;
					}
				}
				else
				{
					if(GreaterEqual_IntInt(int(StickToWhat), int(3)))
					{
						probes[i].StickToTarget = true;
					}
				}
			}
			else
			{
				if(GreaterEqual_IntInt(int(StickToWhat), int(5)))
				{
					probes[i].StickToTarget = true;
				}
			}
		}
		if(AndAnd_BoolBool(EqualEqual_BoolBool(probes[i].StickToTarget, true), TaserHit))
		{
			probes[i].PostTravelTime = ProbeStickTime;
			// [Explicit Continue]
			goto J0x76C;
		}
		probes[i].PostTravelTime = ProbeFallDuration;
		J0x76C:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0F;
	}
	if(TaserHit)
	{
		probes[0].PostTravelTime = FMax(probes[0].PostTravelTime, probes[1].PostTravelTime);
		probes[1].PostTravelTime = probes[0].PostTravelTime;
	}
	MinTravelTime = FMin(probes[0].TravelTime, probes[1].TravelTime);
	Tick(0.0000000);
	return;
}

simulated function GetProbeOriginFrame(int probeInd)
{
	local Coords ProbeBoneCoords;

	if(InFirstPersonView())
	{
		ProbeBoneCoords = GetFirstPersonModel().GetBoneCoords(FirstPersonProbeBones[probeInd], true);
		probes[probeInd].ProbeOriginLocation = ProbeBoneCoords.Origin;
		probes[probeInd].ProbeOriginRotation = Rotator(ProbeBoneCoords.XAxis);
	}
	else
	{
		probes[probeInd].ProbeOriginLocation = GetThirdPersonModel().Location;
		GetAxes(GetThirdPersonModel().Rotation, ProbeBoneCoords.XAxis, ProbeBoneCoords.YAxis, ProbeBoneCoords.ZAxis);
		AddEqual_VectorVector(probes[probeInd].ProbeOriginLocation, Add_VectorVector(Add_VectorVector(Multiply_FloatVector(ThirdPersonProbeOffset[probeInd].X, ProbeBoneCoords.XAxis), Multiply_FloatVector(ThirdPersonProbeOffset[probeInd].Y, ProbeBoneCoords.YAxis)), Multiply_FloatVector(ThirdPersonProbeOffset[probeInd].Z, ProbeBoneCoords.ZAxis)));
		probes[probeInd].ProbeOriginRotation = SwatPawn(GetThirdPersonModel().Owner).GetAimRotation();
	}
	return;
}

simulated function GetProbeOrigin(int probeInd)
{
	local Coords ProbeBoneCoords;

	if(InFirstPersonView())
	{
		ProbeBoneCoords = GetFirstPersonModel().GetBoneCoords(FirstPersonProbeBones[probeInd], true);
		probes[probeInd].ProbeOriginLocation = ProbeBoneCoords.Origin;
	}
	else
	{
		probes[probeInd].ProbeOriginLocation = GetThirdPersonModel().Location;
		GetAxes(GetThirdPersonModel().Rotation, ProbeBoneCoords.XAxis, ProbeBoneCoords.YAxis, ProbeBoneCoords.ZAxis);
		AddEqual_VectorVector(probes[probeInd].ProbeOriginLocation, Add_VectorVector(Add_VectorVector(Multiply_FloatVector(ThirdPersonProbeOffset[probeInd].X, ProbeBoneCoords.XAxis), Multiply_FloatVector(ThirdPersonProbeOffset[probeInd].Y, ProbeBoneCoords.YAxis)), Multiply_FloatVector(ThirdPersonProbeOffset[probeInd].Z, ProbeBoneCoords.ZAxis)));
	}
	return;
}

event LostChild(Actor Other)
{
	local TaserProbeBase deadProbe;
	local TaserWire deadWire;

	super(Actor).LostChild(Other);
	deadProbe = TaserProbeBase(Other);
	deadWire = TaserWire(Other);
	if(NotEqual_ObjectObject(deadProbe, none))
	{
		if(EqualEqual_ObjectObject(probes[0].Probe, deadProbe))
		{
			probes[0].Probe = none;
		}
		else
		{
			probes[1].Probe = none;
		}
	}
	else
	{
		if(NotEqual_ObjectObject(deadWire, none))
		{
			if(EqualEqual_ObjectObject(probes[0].TaserWire, deadWire))
			{
				probes[0].TaserWire = none;
			}
			else
			{
				probes[1].TaserWire = none;
			}
		}
	}
	return;
}

simulated function Tick(float dTime)
{
	local Vector diff;
	local float timeFraction, timeScale, diffSize, heightPeak;
	local Coords boneCoords;
	local int i;
	local name currentAnimation;
	local float rawTime, actualAnimRate, recoilSpeedFade;

	super(FiredWeapon).Tick(dTime);
	if(Not_PreBool(ShouldTick))
	{
		return;
	}
	i = 0;
	J0x1F:

	if(Less_IntInt(i, 2))
	{
		if(EqualEqual_BoolBool(probes[i].Active, false))
		{
			// [Explicit Continue]
			goto J0x9B4;
		}
		if(OrOr_BoolBool(EqualEqual_ObjectObject(probes[i].Probe, none), EqualEqual_ObjectObject(probes[i].TaserWire, none)))
		{
			EndBothProbes();
			return;
		}
		GetProbeOrigin(i);
		if(NotEqual_ObjectObject(probes[i].Victim, none))
		{
			if(NotEqual_NameName(probes[i].VictimBone, 'None'))
			{
				boneCoords = probes[i].Victim.GetBoneCoords(probes[i].VictimBone, true);
				probes[i].TargetLocation = Add_VectorVector(Add_VectorVector(Add_VectorVector(boneCoords.Origin, Multiply_FloatVector(probes[i].TargetBoneOffset.X, boneCoords.XAxis)), Multiply_FloatVector(probes[i].TargetBoneOffset.Y, boneCoords.YAxis)), Multiply_FloatVector(probes[i].TargetBoneOffset.Z, boneCoords.ZAxis));
			}
			else
			{
				probes[i].TargetLocation = Add_VectorVector(probes[i].Victim.Location, probes[i].TargetBoneOffset);
			}
		}
		AddEqual_FloatFloat(probes[i].CurrentTravelTime, dTime);
		timeFraction = Divide_FloatFloat(probes[i].CurrentTravelTime, probes[i].TravelTime);
		timeFraction = FMin(timeFraction, 1.0000000);
		timeFraction = FMax(0.0100000, timeFraction);
		timeScale = Subtract_FloatFloat(1.0000000, Square(Subtract_FloatFloat(timeFraction, 1.0000000)));
		diff = Subtract_VectorVector(probes[i].TargetLocation, probes[i].ProbeOriginLocation);
		diffSize = VSize(diff);
		MultiplyEqual_VectorFloat(diff, timeScale);
		if(Greater_FloatFloat(WireMaxHeightFraction, float(0)))
		{
			heightPeak = FMin(Multiply_FloatFloat(WireMaxHeightFraction, diffSize), WireMaxHeight);
			AddEqual_FloatFloat(diff.Z, Multiply_FloatFloat(heightPeak, Subtract_FloatFloat(1.0000000, Multiply_FloatFloat(4.0000000, Square(Subtract_FloatFloat(timeFraction, 0.5000000))))));
		}
		if(LessEqual_FloatFloat(probes[i].CurrentTravelTime, probes[i].TravelTime))
		{
			probes[i].Probe.SetLocation(Add_VectorVector(probes[i].ProbeOriginLocation, diff));
			probes[i].TaserWire.GetAnimParams(0, currentAnimation, rawTime, actualAnimRate);
			if(OrOr_BoolBool(EqualEqual_NameName(currentAnimation, 'None'), Greater_FloatFloat(rawTime, WireForceSlackTimeFraction)))
			{
				probes[i].TaserWire.LoopAnim(WireSlackAnimation[i], WireSlackAnimRate, 0.0000000, 1);
				probes[i].TaserWire.AnimBlendToAlpha(1, 1.0000000, WireSlackTweenTime);
			}
		}
		else
		{
			if(probes[i].StickToTarget)
			{
				probes[i].Probe.SetLocation(Add_VectorVector(probes[i].ProbeOriginLocation, diff));
				if(Less_IntInt(int(probes[i].ProbeState), int(1)))
				{
					if(NotEqual_ObjectObject(probes[i].Victim, none))
					{
						probes[i].Probe.TriggerEffectEvent('BulletHit',, probes[i].HitMaterial);
					}
					probes[i].ProbeState = 1;
					probes[i].TaserWire.LoopAnim(WireSlackAnimation[i], WireSlackAnimRate, 0.0000000, 1);
					probes[i].TaserWire.AnimBlendToAlpha(1, 1.0000000, WireSlackTweenTime);
				}
			}
			else
			{
				if(Less_IntInt(int(probes[i].ProbeState), int(1)))
				{
					if(NotEqual_ObjectObject(probes[i].Victim, none))
					{
						probes[i].Probe.TriggerEffectEvent('BulletHit',, probes[i].HitMaterial);
					}
					probeRecoils[i].recoilTime = 0.0000000;
					diff = Normal(Subtract_VectorVector(probes[i].Probe.Location, probes[i].ProbeOriginLocation));
					probeRecoils[i].initialVelocity = Multiply_FloatVector(Dot_VectorVector(probes[i].Probe.Velocity, diff), diff);
					probeRecoils[i].initialSpeed = VSize(probeRecoils[i].initialVelocity);
					probes[i].Probe.StartPhysics();
					probes[i].ProbeState = 1;
				}
				else
				{
					if(Less_IntInt(int(probes[i].ProbeState), int(2)))
					{
						if(Less_FloatFloat(VSizeSquared(probes[i].Probe.Velocity), Square(WireSlackStartSpeed)))
						{
							probes[i].ProbeState = 2;
							probes[i].TaserWire.LoopAnim(WireSlackAnimation[i], WireSlackAnimRate, 0.0000000, 1);
							probes[i].TaserWire.AnimBlendToAlpha(1, 1.0000000, WireSlackTweenTime);
						}
					}
				}
				if(LessEqual_FloatFloat(probeRecoils[i].recoilTime, ProbeRecoilTime))
				{
					diff = Normal(Subtract_VectorVector(probes[i].Probe.Location, probes[i].ProbeOriginLocation));
					SubtractEqual_VectorVector(probes[i].Probe.Velocity, Multiply_FloatVector(Dot_VectorVector(probes[i].Probe.Velocity, diff), diff));
					if(Greater_FloatFloat(ProbeRecoilTime, float(0)))
					{
						timeFraction = Divide_FloatFloat(probeRecoils[i].recoilTime, ProbeRecoilTime);
						recoilSpeedFade = Add_FloatFloat(probeRecoils[i].initialSpeed, Multiply_FloatFloat(timeFraction, Subtract_FloatFloat(ProbeFinalRecoilSpeed, probeRecoils[i].initialSpeed)));
						AddEqual_VectorVector(probes[i].Probe.Velocity, Multiply_FloatVector(Multiply_FloatFloat(recoilSpeedFade, Cos(Multiply_FloatFloat(3.1415930, timeFraction))), diff));
					}
					else
					{
						SubtractEqual_VectorVector(probes[i].Probe.Velocity, Multiply_FloatVector(ProbeFinalRecoilSpeed, diff));
					}
					AddEqual_FloatFloat(probeRecoils[i].recoilTime, dTime);
				}
			}
			if(EqualEqual_IntInt(int(probes[i].WireState), int(0)))
			{
				if(Greater_FloatFloat(VDistSquared(probes[i].ProbeInitialLocation, probes[i].ProbeOriginLocation), Square(WireDetachDistance)))
				{
					probes[i].WireState = 1;
					probes[i].TaserWire.SetPhysics(2);
					probes[i].CurrentTravelTime = FMax(probes[i].CurrentTravelTime, Add_FloatFloat(MinTravelTime, probes[i].PostTravelTime));
				}
			}
			if(Greater_FloatFloat(probes[i].CurrentTravelTime, Add_FloatFloat(Add_FloatFloat(MinTravelTime, probes[i].PostTravelTime), FadeDuration)))
			{
				EndProbe(i);
			}
			else
			{
				if(Greater_FloatFloat(probes[i].CurrentTravelTime, Add_FloatFloat(MinTravelTime, probes[i].PostTravelTime)))
				{
				}
			}
		}
		if(EqualEqual_IntInt(int(probes[i].WireState), int(0)))
		{
			probes[i].TaserWire.SetStartLocation(probes[i].ProbeOriginLocation);
		}
		probes[i].TaserWire.SetEndLocation(probes[i].Probe.Location);
		probes[i].TaserWire.UpdateSpan();
		J0x9B4:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1F;
	}
	if(AndAnd_BoolBool(EqualEqual_BoolBool(probes[0].Active, false), EqualEqual_BoolBool(probes[1].Active, false)))
	{
		ShouldTick = false;
	}
	return;
}

simulated function EndBothProbes()
{
	EndProbe(0);
	EndProbe(1);
	ShouldTick = false;
	return;
}

simulated function EndProbe(int probeInd)
{
	if(EqualEqual_BoolBool(probes[probeInd].Active, false))
	{
		return;
	}
	if(NotEqual_ObjectObject(probes[probeInd].Probe, none))
	{
		probes[probeInd].Probe.SetPhysics(0);
		probes[probeInd].Probe.OptimizeOut();
	}
	if(NotEqual_ObjectObject(probes[probeInd].TaserWire, none))
	{
		probes[probeInd].TaserWire.SetPhysics(0);
		probes[probeInd].TaserWire.AnimBlendToAlpha(1, 0.0000000, 0.0000000);
		probes[probeInd].TaserWire.StopAnimating();
		probes[probeInd].TaserWire.OptimizeOut();
	}
	probes[probeInd].Active = false;
	probes[probeInd].Victim = none;
	probes[probeInd].VictimBone = 'None';
	return;
}

simulated function DestroyBothProbes()
{
	DestroyProbe(0);
	DestroyProbe(1);
	ShouldTick = false;
	return;
}

simulated function DestroyProbe(int probeInd)
{
	if(NotEqual_ObjectObject(probes[probeInd].Probe, none))
	{
		probes[probeInd].Probe.Destroy();
		probes[probeInd].Probe = none;
	}
	if(NotEqual_ObjectObject(probes[probeInd].TaserWire, none))
	{
		probes[probeInd].TaserWire.Destroy();
		probes[probeInd].TaserWire = none;
	}
	probes[probeInd].Active = false;
	probes[probeInd].Victim = none;
	probes[probeInd].VictimBone = 'None';
	return;
}

latent simulated function PostRoundUsed()
{
	J0x00:
	if(ShouldTick)
	{
		Sleep(0.0000000);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

defaultproperties
{
	PlayerTasedDuration=15.0000000
	AITasedDuration=1.0000000
	ProbeClass=Class'SwatProgrammerSampleClasses.TaserProbe'
	TaserAimSpread=3.0000000
	StickToWhat=1
	FirstPersonProbeBones[0]="TaserProng1"
	FirstPersonProbeBones[1]="TaserProng2"
	ThirdPersonProbeBones[0]="TaserProng1"
	ThirdPersonProbeBones[1]="TaserProng2"
	FirstPersonProbeOffset[0]=(X=0.0000000,Y=-11.0000000,Z=5.0000000)
	FirstPersonProbeOffset[1]=(X=0.0000000,Y=-11.0000000,Z=3.8000000)
	ThirdPersonProbeOffset[0]=(X=0.0000000,Y=-11.0000000,Z=4.5000000)
	ThirdPersonProbeOffset[1]=(X=0.0000000,Y=-11.0000000,Z=5.5000000)
	ProbeStickTime=0.5000000
	ProbeFallDuration=0.7500000
	FadeDuration=0.5000000
	ProbeVisualSpeed=900.0000000
	ProbeRecoilTime=0.4000000
	ProbeFinalRecoilSpeed=220.0000000
	TaserWireClass=Class'SwatEquipment.TaserWire'
	WireZapAnimation[0]="Fire1"
	WireZapAnimation[1]="Fire2"
	WireSlackAnimation[0]="Slack1"
	WireSlackAnimation[1]="Slack2"
	WireForceSlackTimeFraction=0.7000000
	WireSlackAnimRate=2.5000000
	WireSlackTweenTime=0.5000000
	WireSlackStartSpeed=150.0000000
	WireMinYZScale=0.1000000
	WireMaxYZScale=1.0000000
	WireAnimRate=1.0000000
	WireMaxHeightFraction=0.1200000
	WireMaxHeight=15.0000000
	WireEndEffectorName="TaserProng"
	WireDetachDistance=20.0000000
	ProbePartNames[0]="'"
	ProbePartNames[1]="'"
	WirePartNames[0]="'"
	WirePartNames[1]="'"
	MagazineSize=1
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=20.0000000
	bCanShootThroughGlass=false
	MaxAimError=60.0000000
	SmallAimErrorRecoveryRate=2.5000000
	LargeAimErrorRecoveryRate=8.0000000
	AimErrorBreakingPoint=2.2500000
	LookAimErrorPenaltyFactor=0.0001250
	MaxLookAimErrorPenalty=10.0000000
	InjuredAimErrorPenalty=0.5000000
	MaxInjuredAimErrorPenalty=1.0000000
	EquippedAimErrorPenalty=5.0000000
	FiredAimErrorPenalty=0.5000000
	WalkToRunAimErrorPenalty=6.0000000
	StandToWalkAimErrorPenalty=2.0000000
	StandingAimError=0.6500000
	WalkingAimError=2.5000000
	RunningAimError=7.5000000
	CrouchingAimError=0.5000000
	RecoilBackDuration=0.0500000
	RecoilForeDuration=0.1500000
	RecoilMagnitude=100.0000000
	Range=336
	FirstPersonModelClass=Class'SwatEquipmentModels.Taser_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.Taser_ThirdPerson'
	Description="The Taser stun gun works on the principal of Electro-Muscular Disruption (EMD).  It fires small electrodes into the target and then sends a powerful electric charge down the thin wires.  The EMD effect causes involuntary contraction of the target's muscle tissue regardless of an individual's pain tolerance or mental focus.  The effect is painful and demoralizing to even the most aggressive suspects.||The Taser has two key drawbacks.  The first is that it has a relatively short range.  The second is that new electrodes must be loaded after each shot."
	FriendlyName="Taser Stun Gun"
	GUIImage=Texture'gui_tex.equip_taser'
	ZoomedFOV=60.0000000
	UnequipAnimationRate=2.0000000
}