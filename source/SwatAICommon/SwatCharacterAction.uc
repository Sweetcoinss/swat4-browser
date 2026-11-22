class SwatCharacterAction extends AI_CharacterAction
	abstract
	native
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Pawn m_pawn;
var private LevelInfo Level;
var config float MinInitialDelayTime;
var config float MaxInitialDelayTime;

function initAction(AI_Resource R, AI_Goal Goal)
{
	m_pawn = AI_CharacterResource(R).m_pawn;
	assert(NotEqual_ObjectObject(m_pawn, none));
	Level = m_pawn.Level;
	super.initAction(R, Goal);
	return;
}

function SetPawn(Pawn inPawn)
{
	assert(NotEqual_ObjectObject(inPawn, none));
	m_pawn = inPawn;
	return;
}

function DisableSenses(optional bool bPermanently)
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	ISwatAI(m_pawn).DisableVision(bPermanently);
	ISwatAI(m_pawn).DisableHearing(bPermanently);
	return;
}

function EnableSenses()
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	ISwatAI(m_pawn).EnableVision();
	ISwatAI(m_pawn).EnableHearing();
	return;
}

protected latent function SleepInitialDelayTime(bool bClaimChildResources)
{
	local float DelayTime;

	DelayTime = RandRange(MinInitialDelayTime, MaxInitialDelayTime);
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(string(Name), " DelayTime is: "), string(DelayTime)));
	}
	if(Greater_FloatFloat(DelayTime, 0.0000000))
	{
		if(bClaimChildResources)
		{
			useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
		}
		Sleep(DelayTime);
		if(bClaimChildResources)
		{
			clearDummyGoals();
		}
	}
	return;
}
