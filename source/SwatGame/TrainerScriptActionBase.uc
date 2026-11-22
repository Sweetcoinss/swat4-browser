class TrainerScriptActionBase extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var private SwatTrainer m_swatTrainer;

function SwatTrainer GetSwatTrainer()
{
	local Pawn Pawn;
	local SwatTrainer SwatTrainer;

	if(EqualEqual_ObjectObject(m_swatTrainer, none))
	{
		Pawn = parentScript.Level.PawnList;
		J0x28:

		if(NotEqual_ObjectObject(Pawn, none))
		{
			SwatTrainer = SwatTrainer(Pawn);
			if(NotEqual_ObjectObject(SwatTrainer, none))
			{
				m_swatTrainer = SwatTrainer;
				// [Explicit Break]
				goto J0x73;
			}
			Pawn = Pawn.nextPawn;
			// [Loop Continue]
			goto J0x28;
		}
	}
	J0x73:

	return m_swatTrainer;
	return;
}

latent function waitForGoal(AI_Goal Goal)
{
	J0x00:
	if(Not_PreBool(Goal.hasCompleted()))
	{
		Sleep(0.0000000);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}
