class FallInAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kCheckFullBodyUpdateRate = 0.5;

var private MoveInFormationGoal CurrentMoveInFormationGoal;
var private AimAroundGoal CurrentAimAroundGoal;
var config float FallInMinAimHoldTime;
var config float FallInMaxAimHoldTime;
var private bool bIsLowReady;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveInFormationGoal, none))
	{
		CurrentMoveInFormationGoal.Release();
		CurrentMoveInFormationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(7);
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(EqualEqual_ObjectObject(Goal, CurrentMoveInFormationGoal))
	{
		assert(m_pawn.IsA('SwatOfficer'));
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerCouldntCompleteMoveSpeech();
		instantFail(errorCode);
	}
	return;
}

function AimAround()
{
	CurrentAimAroundGoal = Class'SwatAICommon.AimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceFloatFloat(AI_WeaponResource(m_pawn.WeaponAI), FallInMinAimHoldTime, FallInMaxAimHoldTime);
	assert(NotEqual_ObjectObject(CurrentAimAroundGoal, none));
	CurrentAimAroundGoal.SetOnlyAimIfMoving(true);
	CurrentAimAroundGoal.AddRef();
	CurrentAimAroundGoal.postGoal(self);
	return;
}

latent function FollowPlayer()
{
	CurrentMoveInFormationGoal = Class'SwatAICommon.MoveInFormationGoal'.static.Allocate(self).;
	construct_AI_ResourceInt(AI_MovementResource(m_pawn.MovementAI), 90);
	assert(NotEqual_ObjectObject(CurrentMoveInFormationGoal, none));
	CurrentMoveInFormationGoal.AddRef();
	CurrentMoveInFormationGoal.SetRotateTowardsPointsDuringMovement(false);
	CurrentMoveInFormationGoal.SetAcceptNearbyPath(true);
	CurrentMoveInFormationGoal.postGoal(self);
	return;
}

state Running
{Begin:

	SleepInitialDelayTime(true);
	AimAround();
	FollowPlayer();
Loop:

	if(Greater_FloatFloat(VSize(m_pawn.Velocity), 0.0000000))
	{
		if(Not_PreBool(bIsLowReady))
		{
			ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(7);
			bIsLowReady = true;
		}
	}
	else
	{
		if(bIsLowReady)
		{
			ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 7);
			bIsLowReady = false;
		}
	}
	Sleep(0.5000000);
	goto 'Loop';
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.FallInGoal'
}