class LookAtOfficersActionBase extends SwatCharacterAction
	abstract
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kLookAtNearbyOfficerMinDistSq = 90000;
const kTimeDurationLookingAtOfficerMin = 4.0;
const kTimeDurationLookingAtOfficerMax = 6.0;
const kTimeBetweenLookingAtOfficersMin = 0.0;
const kTimeBetweenLookingAtOfficersMax = 20.0;

var private UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId UpperBodyAnimBehaviorClientId;
var private Pawn OfficerBeingLookedAt;
var private float TimeStartedLookingAtOfficer;
var private float TimeDurationLookingAtOfficer;
var private float TimeLastLookedAtOfficer;
var private float TimeBetweenLookingAtOfficers;

protected function InitLookAtOfficersActionBase(UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId Id)
{
	UpperBodyAnimBehaviorClientId = Id;
	TimeLastLookedAtOfficer = m_pawn.Level.TimeSeconds;
	TimeBetweenLookingAtOfficers = RandRange(0.0000000, 20.0000000);
	return;
}

protected latent function LookAtNearbyOfficers()
{
	local ISwatAI SwatAI;

	SwatAI = ISwatAI(m_pawn);
	m_pawn.ChangeAnimation();
	J0x1F:

	if(Class'Engine.Pawn'.static.checkConscious(m_pawn))
	{
		CacheNearbyOfficerToLookAt();
		if(NotEqual_ObjectObject(OfficerBeingLookedAt, none))
		{
			SwatAI.SetUpperBodyAnimBehavior(2, UpperBodyAnimBehaviorClientId);
			SwatAI.AimAtActor(OfficerBeingLookedAt);
		}
		else
		{
			SwatAI.UnsetUpperBodyAnimBehavior(UpperBodyAnimBehaviorClientId);
			SwatAI.DisableAim();
		}
		Sleep(RandRange(0.2000000, 0.4000000));
		// [Loop Continue]
		goto J0x1F;
	}
	return;
}

private function CacheNearbyOfficerToLookAt()
{
	if(NotEqual_ObjectObject(OfficerBeingLookedAt, none))
	{
		if(Greater_FloatFloat(Subtract_FloatFloat(m_pawn.Level.TimeSeconds, TimeStartedLookingAtOfficer), TimeDurationLookingAtOfficer))
		{
			OfficerBeingLookedAt = none;
			TimeLastLookedAtOfficer = m_pawn.Level.TimeSeconds;
			TimeBetweenLookingAtOfficers = RandRange(0.0000000, 20.0000000);
		}
	}
	if(EqualEqual_ObjectObject(OfficerBeingLookedAt, none))
	{
		if(Greater_FloatFloat(Subtract_FloatFloat(m_pawn.Level.TimeSeconds, TimeLastLookedAtOfficer), TimeBetweenLookingAtOfficers))
		{
			DetermineAndCacheNearbyOfficerToLookAt();
		}
	}
	return;
}

private function DetermineAndCacheNearbyOfficerToLookAt()
{
	local SwatAIRepository SwatAIRepo;
	local array<Pawn> OfficerPawns;
	local Pawn Officer;
	local float OfficerDistanceSq;
	local Pawn BestOfficer;
	local float BestOfficerDistanceSq;
	local int i;
	local ISwatAI SwatAI;
	local Controller Iter;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		SwatAI = ISwatAI(m_pawn);
		SwatAIRepo = SwatAIRepository(m_pawn.Level.AIRepo);
		OfficerPawns = SwatAIRepo.GetElementSquad().pawns;
		OfficerPawns[OfficerPawns.Length] = m_pawn.Level.GetLocalPlayerController().Pawn;
	}
	else
	{
		assert(Level.IsCOOPServer);
		Iter = Level.ControllerList;
		J0xC0:

		if(NotEqual_ObjectObject(Iter, none))
		{
			if(Iter.IsA('PlayerController'))
			{
				OfficerPawns[OfficerPawns.Length] = Iter.Pawn;
			}
			Iter = Iter.nextController;
			// [Loop Continue]
			goto J0xC0;
		}
	}
	i = 0;
	J0x118:

	if(Less_IntInt(i, OfficerPawns.Length))
	{
		Officer = OfficerPawns[i];
		if(Class'Engine.Pawn'.static.checkConscious(Officer))
		{
			OfficerDistanceSq = VDistSquared(m_pawn.Location, Officer.Location);
			if(AndAnd_BoolBool(Less_FloatFloat(OfficerDistanceSq, float(90000)), m_pawn.LineOfSightTo(Officer)))
			{
				if(OrOr_BoolBool(EqualEqual_ObjectObject(BestOfficer, none), Less_FloatFloat(OfficerDistanceSq, BestOfficerDistanceSq)))
				{
					BestOfficer = Officer;
					BestOfficerDistanceSq = OfficerDistanceSq;
				}
			}
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x118;
	}
	OfficerBeingLookedAt = BestOfficer;
	TimeStartedLookingAtOfficer = m_pawn.Level.TimeSeconds;
	TimeDurationLookingAtOfficer = RandRange(4.0000000, 6.0000000);
	return;
}
