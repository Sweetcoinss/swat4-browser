class InitialReactionAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private InitialReactionDefinition InitialReaction;
var(Parameters) Pawn StimuliPawn;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	ISwatAI(m_pawn).AnimStopSpecial();
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
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

latent function RotateTowardStimuli()
{
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, Rotator(Subtract_VectorVector(StimuliPawn.Location, m_pawn.Location)));
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

latent function PlayInitialReactionAnimation()
{
	local int ReactionAnimationChannel;

	assert(NotEqual_ObjectObject(m_pawn, none));
	InitialReaction = SwatAIRepository(Level.AIRepo).GetInitialReactions().GetRandomInitialReactionDefinitionFor(m_pawn, StimuliPawn);
	ReactionAnimationChannel = m_pawn.AnimPlaySpecial(InitialReaction.AnimationName, InitialReaction.AnimationTweenTime);
	m_pawn.FinishAnim(ReactionAnimationChannel);
	return;
}

state Running
{Begin:

	useResources(Class'Tyrion.AI_Resource'.2);
	RotateTowardStimuli();
	useResources(Class'Tyrion.AI_Resource'.4);
	PlayInitialReactionAnimation();
	ISwatAI(m_pawn).GetCommanderAction().ResetIdling();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.InitialReactionGoal'
}