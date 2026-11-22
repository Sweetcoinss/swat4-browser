class TakeCoverAction extends SwatCharacterAction
	native
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private AICoverFinder AICoverFinder;
var private bool m_tookCover;
var private AICoverResult CoverResult;
var private MoveToLocationGoal CurrentMoveToLocationGoal;

function initAction(AI_Resource R, AI_Goal Goal)
{
	local ISwatAI SwatAI;

	super.initAction(R, Goal);
	if(EqualEqual_ObjectObject(AICoverFinder, none))
	{
		SwatAI = ISwatAI(m_pawn);
		if(NotEqual_ObjectObject(SwatAI, none))
		{
			AICoverFinder = SwatAI.GetCoverFinder();
		}
	}
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none))
	{
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = none;
	}
	ResetFullBodyAnimations();
	return;
}

function SwapInFullBodyTakeCoverAnimations()
{
	if(m_pawn.IsA('SwatEnemy'))
	{
		ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 18);
		ISwatEnemy(m_pawn).StartSprinting();
	}
	return;
}

function ResetFullBodyAnimations()
{
	if(m_pawn.IsA('SwatEnemy'))
	{
		ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(18);
		ISwatEnemy(m_pawn).StopSprinting();
	}
	return;
}

protected latent function NotifyFoundCover()
{
	SwapInFullBodyTakeCoverAnimations();
	return;
}

protected latent function MoveToTakeCover(Vector Destination)
{
	assert(EqualEqual_ObjectObject(CurrentMoveToLocationGoal, none));
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " MoveToTakeCover - Destination is: "), string(Destination)));
	}
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(AI_MovementResource(m_pawn.MovementAI), achievingGoal.Priority, Destination);
	assert(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none));
	CurrentMoveToLocationGoal.AddRef();
	CurrentMoveToLocationGoal.SetWalkThreshold(0.0000000);
	CurrentMoveToLocationGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToLocationGoal.SetAcceptNearbyPath(true);
	CurrentMoveToLocationGoal.SetUseCoveredPaths();
	CurrentMoveToLocationGoal.postGoal(self);
	waitForGoal(CurrentMoveToLocationGoal);
	CurrentMoveToLocationGoal.unPostGoal(self);
	CurrentMoveToLocationGoal.Release();
	CurrentMoveToLocationGoal = none;
	return;
}

protected latent function TakeCover()
{
	m_tookCover = false;
	assert(NotEqual_ObjectObject(m_pawn, none));
	assert(NotEqual_ObjectObject(SwatCharacterResource(m_pawn.CharacterAI).CommonSensorAction, none));
	assert(NotEqual_ObjectObject(SwatCharacterResource(m_pawn.CharacterAI).CommonSensorAction.GetVisionSensor(), none));
	CoverResult = AICoverFinder.FindCover(SwatCharacterResource(m_pawn.CharacterAI).CommonSensorAction.GetVisionSensor().pawns, 0);
	if(NotEqual_IntInt(int(CoverResult.coverLocationInfo), int(0)))
	{
		NotifyFoundCover();
		if(m_pawn.logAI)
		{
			Log(Concat_StrStr("Taking cover at: ", string(CoverResult.coverLocation)));
		}
		MoveToTakeCover(CoverResult.coverLocation);
		ResetFullBodyAnimations();
		if(EqualEqual_IntInt(int(CoverResult.coverLocationInfo), int(1)))
		{
			m_pawn.ShouldCrouch(true);
		}
		m_tookCover = true;
	}
	return;
}

state Running
{Begin:

	TakeCover();
	if(m_tookCover)
	{
		succeed();
	}
	else
	{
		fail(12);
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.TakeCoverGoal'
}