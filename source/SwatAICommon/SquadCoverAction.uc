class SquadCoverAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var array<CoverGoal> CoverGoals;
var(Parameters) Vector coverLocation;
var private LevelInfo Level;

function cleanup()
{
	super(ActionBase).cleanup();
	CleanupCoverGoals();
	return;
}

private function CleanupCoverGoals()
{
	J0x00:
	if(Greater_IntInt(CoverGoals.Length, 0))
	{
		if(NotEqual_ObjectObject(CoverGoals[0], none))
		{
			CoverGoals[0].Release();
			CoverGoals[0] = none;
		}
		CoverGoals.Remove(0, 1);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

private function NavigationPoint GetClosestCoverFromPoint(Pawn Officer, NavigationPointList PointsInRoomThatCanHitCoverLocation)
{
	local int i;
	local NavigationPoint Iter, ClosestPoint;
	local float ClosestDistance, IterDistance;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PointsInRoomThatCanHitCoverLocation.GetSize()))
	{
		Iter = PointsInRoomThatCanHitCoverLocation.GetEntryAt(i);
		IterDistance = VSize(Subtract_VectorVector(Officer.Location, Iter.Location));
		if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestPoint, none), Less_FloatFloat(IterDistance, ClosestDistance)))
		{
			ClosestPoint = Iter;
			ClosestDistance = IterDistance;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(NotEqual_ObjectObject(ClosestPoint, none))
	{
		PointsInRoomThatCanHitCoverLocation.Remove(ClosestPoint);
	}
	return ClosestPoint;
	return;
}

private latent function CreateCoverGoals()
{
	local int i, NextOpenIndex;
	local Pawn Officer;
	local bool AimAround;
	local SwatAIRepository SwatAIRepo;
	local NavigationPointList PointsInRoomThatCanHitCoverLocation;
	local name CoverFromRoomName;
	local NavigationPoint CoverFromNavigationPoint;
	local Vector CoverFromPoint;

	SwatAIRepo = SwatAIRepository(Level.AIRepo);
	CoverFromRoomName = SwatAIRepo.GetClosestRoomNameToPoint(CommandOrigin, CommandGiver);
	yield();
	assert(NotEqual_ObjectObject(SwatAIRepo, none));
	PointsInRoomThatCanHitCoverLocation = SwatAIRepo.GetNavigationPointsInRoomThatCanHitPoint(CoverFromRoomName, coverLocation);
	yield();
	i = 0;
	J0x75:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		Officer = squad().pawns[i];
		CoverFromNavigationPoint = GetClosestCoverFromPoint(Officer, PointsInRoomThatCanHitCoverLocation);
		if(EqualEqual_ObjectObject(CoverFromNavigationPoint, none))
		{
			CoverFromPoint = CommandOrigin;
		}
		else
		{
			CoverFromPoint = CoverFromNavigationPoint.Location;
		}
		NextOpenIndex = CoverGoals.Length;
		CoverGoals[NextOpenIndex] = Class'SwatAICommon.CoverGoal'.static.Allocate(self).;
		construct_AI_ResourceVectorVectorVectorBool(AI_Resource(Officer.CharacterAI), coverLocation, CommandOrigin, CoverFromPoint, AimAround);
		assert(NotEqual_ObjectObject(CoverGoals[NextOpenIndex], none));
		CoverGoals[NextOpenIndex].AddRef();
		CoverGoals[NextOpenIndex].postGoal(self);
		AimAround = true;
		yield();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x75;
	}
	SwatAIRepo.ReleaseNavigationPointList(PointsInRoomThatCanHitCoverLocation);
	return;
}

state Running
{Begin:

	Level = resource.Pawn().Level;
	assert(NotEqual_ObjectObject(Level, none));
	CreateCoverGoals();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadCoverGoal'
}