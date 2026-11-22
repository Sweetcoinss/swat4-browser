class AimAroundAction extends SwatWeaponAction implements IInterestedPawnDied, IInterestedActorDestroyed
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

const kStaircaseAimPointMinZDiff = 64.0;
const kStaircaseTravelDirectionSmallValue = 8.0;
const kMaxFindAndAimAtPointAttempts = 10;
const kAwarenessPointClosePenaltyDistance = 192.0;

enum EAimFov
{
	kAimFovNone,                    // 0
	kAimFovOuter,                   // 1
	kAimFovInner                    // 2
};

enum EStaircaseTravelDirection
{
	kStaircaseTravelDirectionNone,  // 0
	kStaircaseTravelDirectionUp,    // 1
	kStaircaseTravelDirectionDown   // 2
};

var(Parameters) private float MinAimAtPointTime;
var(Parameters) private float MaxAimAtPointTime;
var(Parameters) private float MinWaitForNewPointTime;
var(Parameters) private float MaxWaitForNewPointTime;
var(Parameters) private bool bDoOnce;
var(Parameters) private bool bOnlyAimIfMoving;
var(Parameters) private float ExtraDoorWeight;
var(Parameters) private bool bAimWeapon;
var(Parameters) private bool bUseUpperBodyProcedurally;
var(Parameters) private bool bAimOnlyIfCharacterResourcesAvailable;
var(Parameters) private UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId UpperBodyAnimBehaviorClientId;
var(Parameters) private float AimInnerFovDot;
var(Parameters) private float AimOuterFovDot;
var(Parameters) private float PointTooCloseRadius;
var(Parameters) private bool bInitialDelay;
var(Parameters) private float MinInitialDelayTime;
var(Parameters) private float MaxInitialDelayTime;
var private float StairCasePointWeight;
var private bool bForceReevaluation;
var private float AimAtPointDuration;
var private Actor CurrentAimPoint;
var private ISwatAI.EUpperBodyAnimBehavior CurrentUpperBodyAnimBehavior;
var array<Pawn> FriendlyPawns;
var private AimAroundAction.EStaircaseTravelDirection StaircaseTravelDirectionForCurrentAimPoint;
var private bool PawnIsMoving;
var private Vector PawnDirectionNormal;
var private Vector CurrentAimDirectionNormal;
var array<Vector> FriendlyPawnDirectionNormals;

function initAction(AI_Resource R, AI_Goal Goal)
{
	local Pawn otherPawn;

	super.initAction(R, Goal);
	m_pawn.Level.RegisterNotifyPawnDied(self);
	m_pawn.Level.RegisterNotifyActorDestroyed(self);
	otherPawn = m_pawn.Level.PawnList;
	J0x5F:

	if(NotEqual_ObjectObject(otherPawn, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(otherPawn, m_pawn), Not_PreBool(ISwatAI(m_pawn).IsOtherActorAThreat(otherPawn))))
		{
			FriendlyPawns[FriendlyPawns.Length] = otherPawn;
		}
		otherPawn = otherPawn.nextPawn;
		// [Loop Continue]
		goto J0x5F;
	}
	if(bAimWeapon)
	{
		CurrentUpperBodyAnimBehavior = 2;
	}
	else
	{
		CurrentUpperBodyAnimBehavior = 1;
	}
	SetCurrentUpperBodyAnimBehavior();
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	m_pawn.Level.UnRegisterNotifyPawnDied(self);
	m_pawn.Level.UnRegisterNotifyActorDestroyed(self);
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(UpperBodyAnimBehaviorClientId);
	return;
}

function float selectionHeuristic(AI_Goal Goal)
{
	if(EqualEqual_ObjectObject(satisfiesGoal, Goal.Class))
	{
		return 1.0000000;
	}
	else
	{
		return 0.0000000;
	}
	return;
}

function SetCurrentUpperBodyAnimBehavior()
{
	if(OrOr_BoolBool(Not_PreBool(bUseUpperBodyProcedurally), Not_PreBool(ISwatAI(m_pawn).HasUsableWeapon())))
	{
		CurrentUpperBodyAnimBehavior = 0;
	}
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(CurrentUpperBodyAnimBehavior, UpperBodyAnimBehaviorClientId);
	return;
}

function OnOtherPawnDied(Pawn DeadPawn)
{
	RemovePawnFromCachedData(DeadPawn);
	return;
}

function OnOtherActorDestroyed(Actor ActorBeingDestroyed)
{
	if(ActorBeingDestroyed.IsA('Pawn'))
	{
		RemovePawnFromCachedData(Pawn(ActorBeingDestroyed));
	}
	return;
}

function RemovePawnFromCachedData(Pawn Pawn)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, FriendlyPawns.Length))
	{
		if(EqualEqual_ObjectObject(FriendlyPawns[i], Pawn))
		{
			FriendlyPawns.Remove(i, 1);
			// [Explicit Break]
			goto J0x45;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x45:

	return;
}

function ForceReevaluation()
{
	bForceReevaluation = true;
	return;
}

function float GetAimDirectionNormal(Actor Target, out Vector Result)
{
	local Vector PawnLocation;
	local float magnitude;

	assert(NotEqual_ObjectObject(Target, none));
	PawnLocation = ISwatAI(m_pawn).AnimGetAimOrigin();
	if(PawnIsMoving)
	{
		AddEqual_VectorVector(PawnLocation, Multiply_VectorFloat(m_pawn.Velocity, AimAtPointDuration));
	}
	Result = Subtract_VectorVector(Target.GetAimLocation(m_pawn.GetActiveItem()), PawnLocation);
	magnitude = VSize(Result);
	DivideEqual_VectorFloat(Result, magnitude);
	return magnitude;
	return;
}

// Export UAimAroundAction::execIsPointTooClose(FFrame&, void* const)
native function bool IsPointTooClose(Actor Point);

// Export UAimAroundAction::execGetZDiffFromPawnToActor(FFrame&, void* const)
native function float GetZDiffFromPawnToActor(Actor Actor);

function AimAroundAction.EAimFov GetAimDirectionFov(Vector AimDirectionNormal)
{
	local float D;

	D = Dot_VectorVector(PawnDirectionNormal, AimDirectionNormal);
	if(GreaterEqual_FloatFloat(D, AimInnerFovDot))
	{
		return 2;
	}
	if(GreaterEqual_FloatFloat(D, AimOuterFovDot))
	{
		return 1;
	}
	return 0;
	return;
}

function ApplyConfidenceAndDistanceWeight(out float Weight, AimAroundAction.EAimFov AimFov, float Confidence, float Distance)
{
	local float ClosenessWeight, ConfidenceWeight;

	ConfidenceWeight = Subtract_FloatFloat(1.0000000, Confidence);
	if(Less_FloatFloat(Distance, 192.0000000))
	{
		ClosenessWeight = Add_FloatFloat(Multiply_FloatFloat(Divide_FloatFloat(Distance, 192.0000000), 0.7500000), 0.2500000);
		MultiplyEqual_FloatFloat(ClosenessWeight, ClosenessWeight);
		MultiplyEqual_FloatFloat(ConfidenceWeight, ClosenessWeight);
	}
	if(EqualEqual_IntInt(int(AimFov), int(1)))
	{
		MultiplyEqual_FloatFloat(ConfidenceWeight, ConfidenceWeight);
	}
	ConfidenceWeight = Add_FloatFloat(Multiply_FloatFloat(0.9000000, Subtract_FloatFloat(ConfidenceWeight, 1.0000000)), 1.0000000);
	AddEqual_FloatFloat(Weight, ConfidenceWeight);
	return;
}

function ApplyThreatWeight(out float Weight, AimAroundAction.EAimFov AimFov, float threat)
{
	local float ThreatWeight;

	ThreatWeight = threat;
	if(EqualEqual_IntInt(int(AimFov), int(1)))
	{
		ThreatWeight = Multiply_FloatFloat(ThreatWeight, ThreatWeight);
	}
	AddEqual_FloatFloat(Weight, Multiply_FloatFloat(ThreatWeight, 4.0000000));
	return;
}

function ApplyAimDirectionSimilarityWeight(out float Weight, AimAroundAction.EAimFov AimFov, Vector AimDirectionNormal)
{
	local float AimDirectionSimilarity;

	if(EqualEqual_IntInt(int(AimFov), int(2)))
	{
		AimDirectionSimilarity = Dot_VectorVector(CurrentAimDirectionNormal, AimDirectionNormal);
		if(Less_FloatFloat(AimDirectionSimilarity, 0.0000000))
		{
			AimDirectionSimilarity = 0.0000000;
		}
		AimDirectionSimilarity = Subtract_FloatFloat(1.0000000, AimDirectionSimilarity);
		AimDirectionSimilarity = Add_FloatFloat(Multiply_FloatFloat(1.5000000, AimDirectionSimilarity), 0.5000000);
		MultiplyEqual_FloatFloat(Weight, AimDirectionSimilarity);
	}
	return;
}

function ApplyNearFriendlyPawnPenalty(out float Weight, AimAroundAction.EAimFov AimFov, Vector AimDirectionNormal)
{
	local int i;
	local float Similarity, MinSimilarityDot, TotalSimilarity;

	MinSimilarityDot = 0.9810000;
	i = 0;
	J0x12:

	if(AndAnd_BoolBool(Less_IntInt(i, FriendlyPawnDirectionNormals.Length), Less_FloatFloat(TotalSimilarity, 1.0000000)))
	{
		Similarity = Dot_VectorVector(AimDirectionNormal, FriendlyPawnDirectionNormals[i]);
		Similarity = Divide_FloatFloat(Subtract_FloatFloat(Similarity, MinSimilarityDot), Subtract_FloatFloat(1.0000000, MinSimilarityDot));
		Similarity = FClamp(Similarity, 0.0000000, 1.0000000);
		AddEqual_FloatFloat(TotalSimilarity, Similarity);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	TotalSimilarity = FClamp(TotalSimilarity, 0.0000000, 1.0000000);
	MultiplyEqual_FloatFloat(Weight, Subtract_FloatFloat(1.0000000, TotalSimilarity));
	return;
}

function ApplyExtraDoorWeight(out float Weight, AimAroundAction.EAimFov AimFov, AwarenessPoint AwarenessPoint)
{
	local NavigationPoint ClosestNavigationPointToAwarenessPoint;

	ClosestNavigationPointToAwarenessPoint = AwarenessPoint.GetClosestNavigationPoint();
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(AimFov), int(2)), NotEqual_ObjectObject(ClosestNavigationPointToAwarenessPoint, none)), ClosestNavigationPointToAwarenessPoint.IsA('Door')))
	{
		AddEqual_FloatFloat(Weight, ExtraDoorWeight);
	}
	return;
}

function float GetKnowledgeAimWeight(AwarenessKnowledge Knowledge)
{
	local float Weight, Distance;
	local Vector AimDirectionNormal;
	local AimAroundAction.EAimFov AimFov;

	Weight = 0.0000000;
	Distance = GetAimDirectionNormal(Knowledge.aboutAwarenessPoint, AimDirectionNormal);
	if(Not_PreBool(IsPointTooClose(Knowledge.aboutAwarenessPoint)))
	{
		AimFov = GetAimDirectionFov(AimDirectionNormal);
		if(NotEqual_IntInt(int(AimFov), int(0)))
		{
			ApplyConfidenceAndDistanceWeight(Weight, AimFov, Knowledge.Confidence, Distance);
			ApplyThreatWeight(Weight, AimFov, Knowledge.threat);
			ApplyAimDirectionSimilarityWeight(Weight, AimFov, AimDirectionNormal);
			ApplyNearFriendlyPawnPenalty(Weight, AimFov, AimDirectionNormal);
			ApplyExtraDoorWeight(Weight, AimFov, Knowledge.aboutAwarenessPoint);
		}
	}
	return Weight;
	return;
}

function CacheWeightProcessingData()
{
	local Pawn otherPawn;
	local int i;

	PawnIsMoving = Greater_FloatFloat(VSize(m_pawn.Velocity), 0.0000000);
	if(PawnIsMoving)
	{
		PawnDirectionNormal = Normal(m_pawn.Velocity);
	}
	else
	{
		PawnDirectionNormal = Normal(Vector(m_pawn.Rotation));
	}
	if(NotEqual_ObjectObject(CurrentAimPoint, none))
	{
		GetAimDirectionNormal(CurrentAimPoint, CurrentAimDirectionNormal);
	}
	else
	{
		CurrentAimDirectionNormal = PawnDirectionNormal;
	}
	FriendlyPawnDirectionNormals.Remove(0, FriendlyPawnDirectionNormals.Length);
	FriendlyPawnDirectionNormals.Insert(0, FriendlyPawns.Length);
	i = 0;
	J0xA2:

	if(Less_IntInt(i, FriendlyPawns.Length))
	{
		otherPawn = FriendlyPawns[i];
		if(m_pawn.LineOfSightTo(otherPawn))
		{
			GetAimDirectionNormal(otherPawn, FriendlyPawnDirectionNormals[i]);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xA2;
	}
	return;
}

// Export UAimAroundAction::execGetStaircaseTravelDirection(FFrame&, void* const)
native function AimAroundAction.EStaircaseTravelDirection GetStaircaseTravelDirection();

function StaircaseAimPoint GetStaircaseAimPoint()
{
	local ISwatAI SwatAI;
	local int i, NumTouchingStaircaseVolumes;
	local StaircaseAimVolume StaircaseAimVolume;
	local int j, NumStaircaseAimPoints;
	local StaircaseAimPoint StaircaseAimPoint;
	local AimAroundAction.EStaircaseTravelDirection StaircaseTravelDirection;
	local float ZDiff;
	local StaircaseAimPoint BestStairCaseAimPoint;
	local float BestStairCaseAimPointZDiff;

	SwatAI = ISwatAI(m_pawn);
	assert(NotEqual_ObjectObject(SwatAI, none));
	NumTouchingStaircaseVolumes = SwatAI.GetNumTouchingStaircaseAimVolumes();
	StaircaseTravelDirection = 0;
	if(Greater_IntInt(NumTouchingStaircaseVolumes, 0))
	{
		StaircaseTravelDirection = GetStaircaseTravelDirection();
	}
	if(NotEqual_IntInt(int(StaircaseTravelDirection), int(0)))
	{
		i = 0;
		J0x66:

		if(Less_IntInt(i, NumTouchingStaircaseVolumes))
		{
			StaircaseAimVolume = SwatAI.GetTouchingStaircaseAimVolumeAtIndex(i);
			NumStaircaseAimPoints = StaircaseAimVolume.GetNumStaircaseAimPoints();
			j = 0;
			J0xAB:

			if(Less_IntInt(j, NumStaircaseAimPoints))
			{
				StaircaseAimPoint = StaircaseAimVolume.GetStaircaseAimPointAtIndex(j);
				ZDiff = GetZDiffFromPawnToActor(StaircaseAimPoint);
				if(Not_PreBool(IsPointTooClose(StaircaseAimPoint)))
				{
					if(EqualEqual_IntInt(int(StaircaseTravelDirection), int(1)))
					{
						if(AndAnd_BoolBool(Greater_FloatFloat(ZDiff, 64.0000000), OrOr_BoolBool(EqualEqual_ObjectObject(BestStairCaseAimPoint, none), Greater_FloatFloat(ZDiff, BestStairCaseAimPointZDiff))))
						{
							BestStairCaseAimPoint = StaircaseAimPoint;
							BestStairCaseAimPointZDiff = ZDiff;
						}
						// [Explicit Continue]
						goto J0x1A0;
					}
					if(EqualEqual_IntInt(int(StaircaseTravelDirection), int(2)))
					{
						if(AndAnd_BoolBool(Less_FloatFloat(ZDiff, Subtract_PreFloat(64.0000000)), OrOr_BoolBool(EqualEqual_ObjectObject(BestStairCaseAimPoint, none), Greater_FloatFloat(ZDiff, BestStairCaseAimPointZDiff))))
						{
							BestStairCaseAimPoint = StaircaseAimPoint;
							BestStairCaseAimPointZDiff = ZDiff;
						}
					}
				}
				J0x1A0:

				AddAdd_Int(j);
				// [Loop Continue]
				goto J0xAB;
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x66;
		}
	}
	StaircaseTravelDirectionForCurrentAimPoint = StaircaseTravelDirection;
	return BestStairCaseAimPoint;
	return;
}

function FindBestPointToAimAt()
{
	local array<AwarenessKnowledge> PotentiallyVisibleSet;
	local AwarenessKnowledge Knowledge;
	local StaircaseAimPoint StaircaseAimPoint;
	local Actor BestAimPoint;
	local float BestAimPointWeight;
	local bool bLocalAimWeapon;
	local int i;
	local float Weight;
	local FiredWeapon CurrentWeapon;

	CacheWeightProcessingData();
	PotentiallyVisibleSet = ISwatAI(m_pawn).GetAwareness().GetPotentiallyVisibleKnowledge(m_pawn);
	i = 0;
	J0x36:

	if(Less_IntInt(i, PotentiallyVisibleSet.Length))
	{
		Knowledge = PotentiallyVisibleSet[i];
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Knowledge.aboutAwarenessPoint, m_pawn.Anchor.GetClosestAwarenessPoint()), ISwatAI(m_pawn).AnimCanAimAtDesiredActor(Knowledge.aboutAwarenessPoint)))
		{
			Weight = GetKnowledgeAimWeight(Knowledge);
			if(Greater_FloatFloat(Weight, BestAimPointWeight))
			{
				BestAimPoint = Knowledge.aboutAwarenessPoint;
				BestAimPointWeight = Weight;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x36;
	}
	StaircaseAimPoint = GetStaircaseAimPoint();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(StaircaseAimPoint, none), Greater_FloatFloat(StairCasePointWeight, BestAimPointWeight)))
	{
		BestAimPoint = StaircaseAimPoint;
		bLocalAimWeapon = true;
	}
	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(Not_PreBool(bAimWeapon))
	{
		if(EqualEqual_ObjectObject(CurrentWeapon, none))
		{
			CurrentUpperBodyAnimBehavior = 0;
		}
		else
		{
			if(bLocalAimWeapon)
			{
				CurrentUpperBodyAnimBehavior = 2;
			}
			else
			{
				CurrentUpperBodyAnimBehavior = 1;
			}
		}
	}
	else
	{
		if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(BestAimPoint, none), EqualEqual_ObjectObject(CurrentWeapon, none)), Not_PreBool(m_pawn.CanHit(BestAimPoint))))
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentWeapon, none), ISwatAI(m_pawn).CanPawnUseLowReady()))
			{
				CurrentUpperBodyAnimBehavior = 1;
			}
			else
			{
				CurrentUpperBodyAnimBehavior = 0;
			}
		}
	}
	CurrentAimPoint = BestAimPoint;
	return;
}

// Export UAimAroundAction::execShouldContinueAimingAtCurrentPoint(FFrame&, void* const)
native function bool ShouldContinueAimingAtCurrentPoint();

latent function AimAtBestPoint()
{
	local ISwatAI SwatAI;
	local float EndAimTime;

	SwatAI = ISwatAI(m_pawn);
	if(NotEqual_ObjectObject(SwatAI, none))
	{
		if(NotEqual_ObjectObject(CurrentAimPoint, none))
		{
			ISwatAI(m_pawn).AimAtActor(CurrentAimPoint);
			SetCurrentUpperBodyAnimBehavior();
			EndAimTime = Add_FloatFloat(m_pawn.Level.TimeSeconds, AimAtPointDuration);
			J0x69:

			if(Less_FloatFloat(m_pawn.Level.TimeSeconds, EndAimTime))
			{
				if(Not_PreBool(ShouldContinueAimingAtCurrentPoint()))
				{
					CurrentAimPoint = none;
					return;
				}
				yield();
				// [Loop Continue]
				goto J0x69;
			}
		}
		else
		{
			SetCurrentUpperBodyAnimBehavior();
		}
	}
	return;
}

private function bool CanAimAtNewPoint()
{
	local AI_MovementResource movementResource;

	if(bAimOnlyIfCharacterResourcesAvailable)
	{
		movementResource = AI_MovementResource(m_pawn.MovementAI);
		assert(NotEqual_ObjectObject(movementResource, none));
		if(Not_PreBool(movementResource.requiredResourcesAvailable(achievingGoal.Priority, 0)))
		{
			return false;
		}
	}
	return true;
	return;
}

latent function FindAndAimAtPoint()
{
	local bool tryAgain;
	local int attempts;

	AimAtPointDuration = RandRange(MinAimAtPointTime, MaxAimAtPointTime);
	tryAgain = true;
	J0x1E:

	if(AndAnd_BoolBool(CanAimAtNewPoint(), EqualEqual_BoolBool(tryAgain, true)))
	{
		tryAgain = false;
		FindBestPointToAimAt();
		if(NotEqual_ObjectObject(CurrentAimPoint, none))
		{
			AimAtBestPoint();
			if(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentAimPoint, none), Less_IntInt(AddAdd_PreInt(attempts), 10)))
			{
				tryAgain = true;
			}
		}
		// [Loop Continue]
		goto J0x1E;
	}
	return;
}

state Running
{Begin:

	if(bInitialDelay)
	{
		Sleep(RandRange(MinInitialDelayTime, MaxInitialDelayTime));
		bInitialDelay = false;
	}
	if(OrOr_BoolBool(Not_PreBool(bOnlyAimIfMoving), Greater_FloatFloat(VSize(m_pawn.Velocity), 0.0000000)))
	{
		FindAndAimAtPoint();
	}
	else
	{
		CurrentAimPoint = none;
	}
	if(bDoOnce)
	{
		succeed();
	}
	else
	{
		if(EqualEqual_ObjectObject(CurrentAimPoint, none))
		{
			Sleep(RandRange(MinWaitForNewPointTime, MaxWaitForNewPointTime));
		}
		yield();
		goto 'Begin';
	}
	stop;
}

defaultproperties
{
	StairCasePointWeight=200.0000000
	satisfiesGoal=Class'SwatAICommon.AimAroundGoal'
}