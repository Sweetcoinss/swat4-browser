class InitialReactionDefinition extends Object within InitialReactionsList
	config
	perobjectconfig;

enum EReactionCharacterType
{
	GuardReaction,                  // 0
	EnemyReaction,                  // 1
	HostageReaction                 // 2
};

enum ECharacterReactionPosition
{
	ReactStanding,                  // 0
	ReactCrouching,                 // 1
	CharacterPositionDoesntMatter   // 2
};

enum EStimuliPosition
{
	StimuliInFront,                 // 0
	StimuliBehind,                  // 1
	StimuliPositionDoesntMatter     // 2
};

var config array<InitialReactionDefinition.EReactionCharacterType> ReactionCharacterTypes;
var config InitialReactionDefinition.ECharacterReactionPosition ReactionPosition;
var config InitialReactionDefinition.EStimuliPosition StimuliPosition;
var config name AnimationName;
var config float AnimationTweenTime;

function bool CanUseInitialReactionDefinition(Pawn Reactor, Pawn Stimuli)
{
	assert(NotEqual_ObjectObject(Reactor, none));
	assert(Reactor.IsA('SwatAI'));
	assert(NotEqual_ObjectObject(Stimuli, none));
	return AndAnd_BoolBool(AndAnd_BoolBool(CanUseInitialReactionBasedOnType(Reactor), CanUseInitialReactionBasedOnPosition(Reactor)), CanUseInitialReactionBasedOnStimuliPosition(Reactor, Stimuli));
	return;
}

private function bool CanUseInitialReactionBasedOnType(Pawn Reactor)
{
	local InitialReactionDefinition.EReactionCharacterType TypeToMatch;
	local int i;

	if(Reactor.IsA('SwatGuard'))
	{
		TypeToMatch = 0;
	}
	else
	{
		if(Reactor.IsA('SwatEnemy'))
		{
			TypeToMatch = 1;
		}
		else
		{
			if(Reactor.IsA('SwatHostage'))
			{
				TypeToMatch = 2;
			}
			else
			{
				assert(false);
				return false;
			}
		}
	}
	i = 0;
	J0x6A:

	if(Less_IntInt(i, ReactionCharacterTypes.Length))
	{
		if(EqualEqual_IntInt(int(ReactionCharacterTypes[i]), int(TypeToMatch)))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x6A;
	}
	return false;
	return;
}

private function bool CanUseInitialReactionBasedOnPosition(Pawn Reactor)
{
	if(EqualEqual_IntInt(int(ReactionPosition), int(2)))
	{
		return true;
	}
	else
	{
		if(EqualEqual_IntInt(int(ReactionPosition), int(0)))
		{
			return Not_PreBool(Reactor.bIsCrouched);
		}
		else
		{
			assert(EqualEqual_IntInt(int(ReactionPosition), int(1)));
			return Reactor.bIsCrouched;
		}
	}
	return;
}

private function bool CanUseInitialReactionBasedOnStimuliPosition(Pawn Reactor, Pawn Stimuli)
{
	local bool bInFront;

	if(EqualEqual_IntInt(int(StimuliPosition), int(2)))
	{
		return true;
	}
	else
	{
		bInFront = GreaterEqual_FloatFloat(Dot_VectorVector(Vector(ISwatAI(Reactor).GetAimOrientation()), Normal(Subtract_VectorVector(Stimuli.Location, Reactor.Location))), 0.0000000);
		if(EqualEqual_IntInt(int(StimuliPosition), int(0)))
		{
			return bInFront;
		}
		else
		{
			assert(EqualEqual_IntInt(int(StimuliPosition), int(1)));
			return Not_PreBool(bInFront);
		}
	}
	return;
}

defaultproperties
{
	AnimationTweenTime=0.1000000
}