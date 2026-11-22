class AvoidLocationAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kRunFromLocationMinDistSq = 40000.0;
const kRunFromLocationDistSq = 640000.0;

var private MoveToActorGoal CurrentMoveToActorGoal;
var(Parameters) Vector AvoidLocation;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	instantSucceed();
	return;
}

function NavigationPoint FindRunToPoint()
{
	local int i;
	local array<AwarenessKnowledge> PotentiallyVisibleSet;
	local AwarenessKnowledge Knowledge;
	local NavigationPoint NavigationPoint;
	local Vector DirectionToAvoidLocation, DirectionToNavigationPoint;
	local float DistSq, Weight;
	local NavigationPoint BestRunToPoint;
	local float BestRunToPointWeight;

	DirectionToAvoidLocation = Subtract_VectorVector(AvoidLocation, m_pawn.Location);
	PotentiallyVisibleSet = ISwatAI(m_pawn).GetAwareness().GetPotentiallyVisibleKnowledge(m_pawn);
	i = 0;
	J0x4B:

	if(Less_IntInt(i, PotentiallyVisibleSet.Length))
	{
		Knowledge = PotentiallyVisibleSet[i];
		NavigationPoint = Knowledge.aboutAwarenessPoint.GetClosestNavigationPoint();
		if(NotEqual_ObjectObject(NavigationPoint, none))
		{
			DistSq = VDistSquared(m_pawn.Location, NavigationPoint.Location);
			if(AndAnd_BoolBool(GreaterEqual_FloatFloat(DistSq, 40000.0000000), LessEqual_FloatFloat(DistSq, 640000.0000000)))
			{
				DirectionToNavigationPoint = Subtract_VectorVector(NavigationPoint.Location, m_pawn.Location);
				if(Less_FloatFloat(Dot_VectorVector(DirectionToNavigationPoint, DirectionToAvoidLocation), 0.0000000))
				{
					Weight = Subtract_FloatFloat(Knowledge.Confidence, Multiply_FloatFloat(Knowledge.threat, 2.0000000));
					if(AndAnd_BoolBool(Greater_FloatFloat(Weight, 0.0000000), OrOr_BoolBool(EqualEqual_ObjectObject(BestRunToPoint, none), Greater_FloatFloat(Weight, BestRunToPointWeight))))
					{
						BestRunToPoint = NavigationPoint;
						BestRunToPointWeight = Weight;
					}
				}
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x4B;
	}
	return BestRunToPoint;
	return;
}

latent function RunFromAvoidLocation()
{
	local NavigationPoint RunToPoint;

	RunToPoint = FindRunToPoint();
	if(NotEqual_ObjectObject(RunToPoint, none))
	{
		CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, FindRunToPoint());
		assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
		CurrentMoveToActorGoal.AddRef();
		CurrentMoveToActorGoal.SetAcceptNearbyPath(true);
		CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
		CurrentMoveToActorGoal.SetMoveToThreshold(8.0000000);
		CurrentMoveToActorGoal.SetWalkThreshold(0.0000000);
		CurrentMoveToActorGoal.postGoal(self);
		waitForGoal(CurrentMoveToActorGoal);
		CurrentMoveToActorGoal.unPostGoal(self);
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	return;
}

state Running
{Begin:

	if(Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority)))
	{
		instantSucceed();
	}
	useResources(Class'Tyrion.AI_Resource'.2);
	RunFromAvoidLocation();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.AvoidLocationGoal'
}