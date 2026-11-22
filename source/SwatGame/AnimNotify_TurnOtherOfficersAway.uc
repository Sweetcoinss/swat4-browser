class AnimNotify_TurnOtherOfficersAway extends AnimNotify_Scripted
	editinlinenew
	collapsecategories
	hidecategories(Object);

event Notify(Actor Owner)
{
	local SwatAIRepository SwatAIRepo;
	local OfficerTeamInfo Element;
	local Pawn Officer;
	local int i;

	assert(NotEqual_ObjectObject(Owner, none));
	if(Owner.IsA('SwatOfficer'))
	{
		SwatAIRepo = SwatAIRepository(Owner.Level.AIRepo);
		assert(NotEqual_ObjectObject(SwatAIRepo, none));
		Element = SwatAIRepo.GetElementSquad();
		i = 0;
		J0x68:

		if(Less_IntInt(i, Element.pawns.Length))
		{
			Officer = Element.pawns[i];
			if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Officer, Owner), Class'Engine.Pawn'.static.checkConscious(Officer)), Pawn(Owner).LineOfSightTo(Officer)))
			{
				SwatOfficer(Officer).PlayTurnAwayAnimation();
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x68;
		}
	}
	return;
}
