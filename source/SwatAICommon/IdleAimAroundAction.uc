class IdleAimAroundAction extends AimAroundAction
	collapsecategories
	hidecategories(Object,InternalParameters);

function float selectionHeuristic(AI_Goal Goal)
{
	if(EqualEqual_ObjectObject(m_pawn, none))
	{
		m_pawn = AI_WeaponResource(Goal.resource).m_pawn;
		assert(NotEqual_ObjectObject(m_pawn, none));
	}
	if(EqualEqual_ObjectObject(Level, none))
	{
		Level = m_pawn.Level;
	}
	if(Not_PreBool(SwatAIRepository(Level.AIRepo).IsOfficerMovingAndClearing(m_pawn)))
	{
		return super.selectionHeuristic(Goal);
	}
	else
	{
		return 0.0000000;
	}
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.IdleAimAroundGoal'
}