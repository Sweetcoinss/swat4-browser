class DeployPepperBallAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn TargetPawn;
var private MoveToOpponentGoal CurrentMoveToOpponentGoal;
var private AttackTargetGoal CurrentAttackTargetGoal;
var private HandheldEquipment CSBallLauncher;
var config int MaxNumberPepperBallsToFire;

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
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CSBallLauncher, none), Not_PreBool(CSBallLauncher.IsIdle())))
	{
		CSBallLauncher.AIInterrupt();
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

latent function EquipCSBallLauncher()
{
	CSBallLauncher = ISwatOfficer(m_pawn).GetItemAtSlot(1);
	assert(AndAnd_BoolBool(NotEqual_ObjectObject(CSBallLauncher, none), CSBallLauncher.IsA('CSBallLauncher')));
	CSBallLauncher.LatentWaitForIdleAndEquip();
	return;
}

latent function UnequipCSBallLauncher()
{
	ISwatOfficer(m_pawn).ReEquipFiredWeapon();
	return;
}

latent function AttackWithCSBallLauncher()
{
	local int NumRemainingAmmoToStopFiring;

	CurrentMoveToOpponentGoal = Class'SwatAICommon.MoveToOpponentGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(AI_Resource(m_pawn.MovementAI), achievingGoal.Priority, TargetPawn);
	assert(NotEqual_ObjectObject(CurrentMoveToOpponentGoal, none));
	CurrentMoveToOpponentGoal.AddRef();
	CurrentMoveToOpponentGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToOpponentGoal.postGoal(self);
	NumRemainingAmmoToStopFiring = Subtract_IntInt(FiredWeapon(CSBallLauncher).Ammo.RoundsRemainingBeforeReload(), MaxNumberPepperBallsToFire);
	CurrentAttackTargetGoal = Class'SwatAICommon.AttackTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(AI_Resource(m_pawn.WeaponAI), achievingGoal.Priority, TargetPawn);
	assert(NotEqual_ObjectObject(CurrentAttackTargetGoal, none));
	CurrentAttackTargetGoal.AddRef();
	CurrentAttackTargetGoal.SetOrderedToAttackTarget(true);
	CurrentAttackTargetGoal.SetHavePerfectAim(true);
	CurrentAttackTargetGoal.postGoal(self);
	J0x134:

	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(ISwatAI(TargetPawn).IsGassed()), CSBallLauncher.IsEquipped()), Greater_IntInt(FiredWeapon(CSBallLauncher).Ammo.RoundsRemainingBeforeReload(), NumRemainingAmmoToStopFiring)))
	{
		yield();
		// [Loop Continue]
		goto J0x134;
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
	ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerDeployingPepperBallSpeech();
	EquipCSBallLauncher();
	AttackWithCSBallLauncher();
	UnequipCSBallLauncher();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.DeployPepperBallGoal'
}