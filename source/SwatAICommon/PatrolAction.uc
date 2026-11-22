class PatrolAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private MoveToActorGoal CurrentMoveToActorGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private int CurrentPatrolIndex;
var(Parameters) PatrolList Patrol;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	m_pawn.ChangeAnimation();
	ISwatAI(m_pawn).SetIdleCategory('None');
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(string(Goal.Name), " was not achieved.  failing."));
	}
	instantFail(errorCode);
	return;
}

latent function MoveToPatrolDestination()
{
	local PatrolPoint Destination;

	Destination = Patrol.GetPatrolEntry(CurrentPatrolIndex).PatrolPoint;
	assert(NotEqual_ObjectObject(Destination, none));
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, Destination);
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetRotateTowardsFirstPoint(true);
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToActorGoal.SetShouldWalkEntireMove(true);
	CurrentMoveToActorGoal.SetShouldCloseOpenedDoors(true);
	CurrentMoveToActorGoal.SetShouldNotCloseInitiallyOpenDoors(true);
	CurrentMoveToActorGoal.postGoal(self);
	waitForGoal(CurrentMoveToActorGoal);
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	return;
}

latent function RotateToPatrolPointRotation(PatrolPoint PatrolPoint)
{
	assert(NotEqual_ObjectObject(PatrolPoint, none));
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, PatrolPoint.Rotation);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

latent function IdleAtPatrolPoint()
{
	local float PatrolPointIdleTime;
	local PatrolEntry CurrentPatrolEntry;

	CurrentPatrolEntry = Patrol.GetPatrolEntry(CurrentPatrolIndex);
	PatrolPointIdleTime = RandRange(CurrentPatrolEntry.IdleTime.Min, CurrentPatrolEntry.IdleTime.Max);
	if(Greater_FloatFloat(PatrolPointIdleTime, 0.0000000))
	{
		RotateToPatrolPointRotation(CurrentPatrolEntry.PatrolPoint);
		useResources(Class'Tyrion.AI_Resource'.4);
		ISwatAI(m_pawn).SetIdleCategory(CurrentPatrolEntry.IdleCategory);
		m_pawn.FinishAnim();
		Sleep(PatrolPointIdleTime);
		ISwatAI(m_pawn).SetIdleCategory('None');
		clearDummyMovementGoal();
	}
	return;
}

function UpdatePatrolIndex()
{
	AddAdd_Int(CurrentPatrolIndex);
	if(EqualEqual_IntInt(CurrentPatrolIndex, Patrol.GetNumPatrolEntries()))
	{
		CurrentPatrolIndex = 0;
	}
	return;
}

state Running
{	J0x00:
	if(Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority)))
	{
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	useResources(Class'Tyrion.AI_Resource'.2);
	CurrentPatrolIndex = 0;
	goto 'Patrolling';
Patrolling:

	MoveToPatrolDestination();
	if(LessEqual_FloatFloat(Multiply_FloatFloat(FRand(), float(100)), float(Patrol.GetPatrolEntry(CurrentPatrolIndex).IdleChance)))
	{
		IdleAtPatrolPoint();
	}
	UpdatePatrolIndex();
	goto 'Patrolling';
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.PatrolGoal'
}