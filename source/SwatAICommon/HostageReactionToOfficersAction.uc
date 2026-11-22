class HostageReactionToOfficersAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinimumThreatToPoint = 0.1;

var(Parameters) Pawn Officer;
var(Parameters) bool bWasInDanger;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private InitialReactionGoal CurrentInitialReactionGoal;
var config float DesiredDistanceToOfficer;
var config name PointToLeftAnimation;
var config name PointToRightAnimation;
var config name PointBehindAnimation;
var private name PointToThreatAnimation;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	m_pawn.AnimStopSpecial();
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentInitialReactionGoal, none))
	{
		CurrentInitialReactionGoal.Release();
		CurrentInitialReactionGoal = none;
	}
	return;
}

latent function RotateToOfficer()
{
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, Rotator(Subtract_VectorVector(Officer.Location, m_pawn.Location)));
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

latent function PlayReactionAnimation(name AnimationName)
{
	local int SpecialChannel;

	SpecialChannel = m_pawn.AnimPlaySpecial(AnimationName, 0.2000000);
	m_pawn.FinishAnim(SpecialChannel);
	return;
}

function Actor GetHighestThreat(float MinimumValue)
{
	local int i;
	local Actor HighestThreatActor;
	local float HighestThreatValue;
	local array<AwarenessKnowledge> PotentiallyVisibleSet;

	PotentiallyVisibleSet = ISwatAI(m_pawn).GetAwareness().GetPotentiallyVisibleKnowledge();
	i = 0;
	J0x2B:

	if(Less_IntInt(i, PotentiallyVisibleSet.Length))
	{
		if(AndAnd_BoolBool(GreaterEqual_FloatFloat(PotentiallyVisibleSet[i].threat, MinimumValue), Greater_FloatFloat(PotentiallyVisibleSet[i].threat, HighestThreatValue)))
		{
			HighestThreatValue = PotentiallyVisibleSet[i].threat;
			HighestThreatActor = PotentiallyVisibleSet[i].aboutAwarenessPoint;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2B;
	}
	return HighestThreatActor;
	return;
}

function name GetThreatAnimation()
{
	local Actor HighestThreat;
	local Vector XAxis, YAxis, ZAxis;

	HighestThreat = GetHighestThreat(0.1000000);
	GetAxes(m_pawn.Rotation, XAxis, YAxis, ZAxis);
	if(NotEqual_ObjectObject(HighestThreat, none))
	{
		if(Less_FloatFloat(Dot_VectorVector(Normal(Subtract_VectorVector(HighestThreat.Location, m_pawn.Location)), XAxis), -0.5000000))
		{
			return PointBehindAnimation;
		}
		else
		{
			if(GreaterEqual_FloatFloat(Dot_VectorVector(Normal(Subtract_VectorVector(HighestThreat.Location, m_pawn.Location)), YAxis), 0.0000000))
			{
				return PointToRightAnimation;
			}
			else
			{
				return PointToLeftAnimation;
			}
		}
	}
	return 'None';
	return;
}

latent function PlayInitialReaction()
{
	CurrentInitialReactionGoal = Class'SwatAICommon.InitialReactionGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(characterResource(), Officer);
	assert(NotEqual_ObjectObject(CurrentInitialReactionGoal, none));
	CurrentInitialReactionGoal.AddRef();
	CurrentInitialReactionGoal.postGoal(self);
	waitForGoal(CurrentInitialReactionGoal);
	CurrentInitialReactionGoal.unPostGoal(self);
	CurrentInitialReactionGoal.Release();
	CurrentInitialReactionGoal = none;
	return;
}

private function TriggerReactionSpeech()
{
	if(bWasInDanger)
	{
		ISwatHostage(m_pawn).GetHostageSpeechManagerAction().TriggerSpottedOfficerScaredSpeech();
	}
	else
	{
		ISwatHostage(m_pawn).GetHostageSpeechManagerAction().TriggerSpottedOfficerNormalSpeech();
	}
	return;
}

state Running
{Begin:

	useResources(Class'Tyrion.AI_Resource'.2);
	PointToThreatAnimation = GetThreatAnimation();
	if(AndAnd_BoolBool(NotEqual_NameName(PointToThreatAnimation, 'None'), Not_PreBool(ISwatHostage(m_pawn).GetHostageCommanderAction().IsInDanger())))
	{
		RotateToOfficer();
		useResources(Class'Tyrion.AI_Resource'.4);
		PlayReactionAnimation(PointToThreatAnimation);
	}
	else
	{
		clearDummyWeaponGoal();
		TriggerReactionSpeech();
		PlayInitialReaction();
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.HostageReactionToOfficersGoal'
}