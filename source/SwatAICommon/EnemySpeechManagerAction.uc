class EnemySpeechManagerAction extends CharacterSpeechManagerAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function TriggerOfficerEncounteredSpeech()
{
	if(ISwatEnemy(m_pawn).GetEnemyCommanderAction().WasSurprised())
	{
		TriggerSpeech('AnnouncedSpottedOfficerSurprised');
	}
	else
	{
		if(AndAnd_BoolBool(Not_PreBool(ISwatAI(m_pawn).IsAggressive()), Less_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2))))
		{
			TriggerSpeech('AnnouncedSpottedOfficerScared');
		}
		else
		{
			TriggerSpeech('AnnouncedSpottedOfficer');
		}
	}
	return;
}

function TriggerDoorBlockedSpeech()
{
	TriggerSpeech('DoorBlocked', true);
	return;
}

function TriggerFleeSpeech()
{
	TriggerSpeech('AnnouncedFlee');
	return;
}

function TriggerCallForHelpSpeech()
{
	TriggerSpeech('CalledForHelp');
	return;
}

function TriggerInvestigateSpeech()
{
	TriggerSpeech('AnnouncedInvestigate', true);
	return;
}

function TriggerBarricadeSpeech()
{
	TriggerSpeech('AnnouncedBarricade', true);
	return;
}

function TriggerUncompliantSpeech()
{
	TriggerSpeech('AnnouncedNonCompliant', true);
	return;
}

function TriggerDownedOfficerSpeech()
{
	TriggerSpeech('ReactedDownOfficer');
	return;
}
