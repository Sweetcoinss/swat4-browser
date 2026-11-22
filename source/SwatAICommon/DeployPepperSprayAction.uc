class DeployPepperSprayAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn TargetPawn;
var private MoveToOpponentGoal CurrentMoveToOpponentGoal;
var private AttackTargetGoal CurrentAttackTargetGoal;
var private HandheldEquipment PepperSpray;

function cleanup()
{
	if(NotEqual_ObjectObject(CurrentMoveToOpponentGoal, none))
	{
		CurrentMoveToOpponentGoal.Release();
		CurrentMoveToOpponentGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAttackTargetGoal, none))
	{
		CurrentAttackTargetGoal.Release();
		CurrentAttackTargetGoal = none;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PepperSpray, none), Not_PreBool(PepperSpray.IsIdle())))
	{
		PepperSpray.AIInterrupt();
	}
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
	super(AI_CharacterAction).cleanup();
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

latent function EquipPepperSpray()
{
	PepperSpray = ISwatOfficer(m_pawn).GetItemAtSlot(6);
	assert(AndAnd_BoolBool(NotEqual_ObjectObject(PepperSpray, none), PepperSpray.IsA('PepperSpray')));
	PepperSpray.LatentWaitForIdleAndEquip();
	return;
}

latent function UnequipPepperSpray()
{
	ISwatOfficer(m_pawn).ReEquipFiredWeapon();
	return;
}

latent function AttackWithPepperSpray()
{
	CurrentMoveToOpponentGoal = Class'SwatAICommon.MoveToOpponentGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(AI_Resource(m_pawn.MovementAI), achievingGoal.Priority, TargetPawn);
	assert(NotEqual_ObjectObject(CurrentMoveToOpponentGoal, none));
	CurrentMoveToOpponentGoal.AddRef();
	CurrentMoveToOpponentGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToOpponentGoal.postGoal(self);
	CurrentAttackTargetGoal = Class'SwatAICommon.AttackTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(AI_Resource(m_pawn.WeaponAI), achievingGoal.Priority, TargetPawn);
	assert(NotEqual_ObjectObject(CurrentAttackTargetGoal, none));
	CurrentAttackTargetGoal.AddRef();
	CurrentAttackTargetGoal.SetOrderedToAttackTarget(true);
	CurrentAttackTargetGoal.SetHavePerfectAim(true);
	CurrentAttackTargetGoal.postGoal(self);
	J0x10A:

	if(AndAnd_BoolBool(Not_PreBool(ISwatAI(TargetPawn).GetCommanderAction().IsAffectedByPepperSpray()), PepperSpray.IsEquipped()))
	{
		yield();
		// [Loop Continue]
		goto J0x10A;
	}
	J0x14A:

	if(PepperSpray.IsBeingUsed())
	{
		yield();
		// [Loop Continue]
		goto J0x14A;
	}
	CurrentMoveToOpponentGoal.unPostGoal(self);
	CurrentMoveToOpponentGoal.Release();
	CurrentMoveToOpponentGoal = none;
	CurrentAttackTargetGoal.unPostGoal(self);
	CurrentAttackTargetGoal.Release();
	CurrentAttackTargetGoal = none;
	return;
}

state Running
{Begin:

	SwatAIRepository(Level.AIRepo).GetHive().NotifyOfficersOfTarget(TargetPawn);
	EquipPepperSpray();
	AttackWithPepperSpray();
	UnequipPepperSpray();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.DeployPepperSprayGoal'
}