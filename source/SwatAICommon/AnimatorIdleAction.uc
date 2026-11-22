class AnimatorIdleAction extends BaseIdleAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private name AnimationName;
var private int NumTimesPlayed;
var private int NumTimesToPlay;

function bool AreResourcesAvailableToIdle(AI_Goal Goal)
{
	return true;
	return;
}

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	NumTimesToPlay = AnimatorIdleDefinition(OurIdleDefinition).GetRandomNumberOfTimeToPlay();
	PlayIdleAnimation();
	return;
}

function PlayIdleAnimation()
{
	AnimationName = AnimatorIdleDefinition(OurIdleDefinition).AnimationName;
	ISwatAI(m_pawn).AnimSetIdle(AnimationName, AnimatorIdleDefinition(OurIdleDefinition).AnimationTweenTime);
	AddAdd_PreInt(NumTimesPlayed);
	return;
}

state Running
{Begin:

	assert(NotEqual_ObjectObject(m_pawn, none));
	assert(OurIdleDefinition.IsA('AnimatorIdleDefinition'));
	m_pawn.FinishAnim();
	if(OrOr_BoolBool(Less_IntInt(NumTimesPlayed, NumTimesToPlay), Not_PreBool(ISwatAI(m_pawn).IsRelevantToPlayerOrOfficers())))
	{
		PlayIdleAnimation();
		goto 'Begin';
	}
	succeed();
	stop;
}
