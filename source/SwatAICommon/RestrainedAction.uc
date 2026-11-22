class RestrainedAction extends LookAtOfficersActionBase
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kPostRestrainedGoalPriority = 93;

var private HandheldEquipment Cuffs;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var(Parameters) Pawn Restrainer;
var config float MinSleepTimeBeforeLookingAtOfficers;
var config float MaxSleepTimeBeforeLookingAtOfficers;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super(SwatCharacterAction).initAction(R, Goal);
	InitLookAtOfficersActionBase(13);
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(13);
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.unPostGoal(self);
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(Not_PreBool(ISwatAI(m_pawn).IsArrested()))
	{
		ISwatAI(m_pawn).SwapInCompliantAnimSet();
		ISwatAI(m_pawn).SetIdleCategory('Compliant');
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Cuffs, none), Not_PreBool(Cuffs.IsEquipped())))
	{
		Cuffs.AIInterrupt();
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
		{
			m_pawn.AnimStopSpecial();
		}
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Restrainer.IsA('SwatOfficer'), Restrainer.GetActiveItem().IsA('Cuffs')), OrOr_BoolBool(Restrainer.GetActiveItem().IsBeingUsed(), Restrainer.GetActiveItem().IsBeingEquipped())), EqualEqual_ObjectObject(IAmUsedOnOther(Restrainer.GetActiveItem()).GetOther(), m_pawn)))
	{
		Restrainer.GetActiveItem().AIInterrupt();
	}
	ISwatAI(m_pawn).UnlockAim();
	m_pawn.EnableCollisionAvoidance();
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

function RotateToRestrainablePosition()
{
	local Rotator DesiredRestrainRotation;

	DesiredRestrainRotation = Rotator(Subtract_VectorVector(m_pawn.Location, Restrainer.Location));
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, DesiredRestrainRotation);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	ISwatAI(m_pawn).AimToRotation(DesiredRestrainRotation);
	ISwatAI(m_pawn).LockAim();
	return;
}

latent function Restrain()
{
	MPLog("in RestrainedAction::Restrain().");
	if(m_pawn.IsA('SwatEnemy'))
	{
		ISwatEnemy(m_pawn).DropAllWeapons();
	}
	Cuffs = ISwatAI(m_pawn).GetRestrainedHandcuffs();
	assert(NotEqual_ObjectObject(Cuffs, none));
	ISwatAI(m_pawn).SetIdleCategory('Restrained');
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		m_pawn.AnimPlaySpecial(Cuffs.GetThirdPersonModel().HolderEquipAnimation, Cuffs.GetThirdPersonModel().HolderEquipTweenTime, Cuffs.GetThirdPersonModel().HolderAnimationRootBone, Cuffs.EquipAnimationRate);
	}
	Cuffs.LatentWaitForIdleAndEquip();
	ICanBeArrested(m_pawn).OnArrested(Restrainer);
	return;
}

function RestrainInterrupted()
{
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr("restrain interrupted on ", string(m_pawn.Name)));
	}
	if(NotEqual_ObjectObject(Cuffs, none))
	{
		if(Not_PreBool(Cuffs.IsEquipped()))
		{
			instantFail(1);
		}
	}
	return;
}

state Running
{
	function BeginState()
	{
		super(Object).BeginState();
		Cuffs = ISwatAI(m_pawn).GetRestrainedHandcuffs();
		return;
	}
Begin:

	if(Not_PreBool(ISwatAI(m_pawn).IsArrested()))
	{
		useResources(Class'Tyrion.AI_Resource'.2);
		m_pawn.DisableCollisionAvoidance();
		RotateToRestrainablePosition();
		Restrain();
		useResources(Class'Tyrion.AI_Resource'.4);
	}
	SwatAIRepository(m_pawn.Level.AIRepo).GetHive().NotifyAIBecameRestrained(m_pawn);
	ISwatAI(m_pawn).GetCommanderAction().NotifyRestrained();
	ISwatAI(m_pawn).SetIdleCategory('Restrained');
	ISwatAI(m_pawn).SwapInRestrainedAnimSet();
	if(NotEqual_IntInt(achievingGoal.Priority, 93))
	{
		achievingGoal.changePriority(93);
		clearDummyGoals();
	}
	J0x102:

	if(Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority)))
	{
		yield();
		// [Loop Continue]
		goto J0x102;
	}
	useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
	m_pawn.EnableCollisionAvoidance();
	ISwatAI(m_pawn).UnlockAim();
	Sleep(RandRange(MinSleepTimeBeforeLookingAtOfficers, MaxSleepTimeBeforeLookingAtOfficers));
	LookAtNearbyOfficers();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.RestrainedGoal'
}