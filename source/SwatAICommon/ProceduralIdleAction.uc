class ProceduralIdleAction extends BaseIdleAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function bool AreResourcesAvailableToIdle(AI_Goal Goal)
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	assert(NotEqual_ObjectObject(AI_Resource(m_pawn.CharacterAI), none));
	return AI_Resource(m_pawn.CharacterAI).requiredResourcesAvailable(Goal.Priority, Goal.Priority, Goal.Priority);
	return;
}

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	if(m_pawn.bIsCrouched)
	{
		ISwatAI(m_pawn).AnimSetIdle('cFidgetMG', 0.1000000);
	}
	else
	{
		ISwatAI(m_pawn).AnimSetIdle('sFidgetMG', 0.1000000);
	}
	return;
}
