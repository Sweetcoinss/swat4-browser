class ElementSpeechManagerAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

function Pawn GetClosestOfficerToOfficer(Pawn Officer)
{
	local int i;
	local float IterDistance, ClosestDistance;
	local Pawn IterOfficer, ClosestOfficer;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		IterOfficer = squad().pawns[i];
		if(NotEqual_ObjectObject(IterOfficer, Officer))
		{
			IterDistance = VSize(Subtract_VectorVector(Officer.Location, IterOfficer.Location));
			if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestOfficer, none), Less_FloatFloat(IterDistance, ClosestDistance)))
			{
				ClosestDistance = IterDistance;
				ClosestOfficer = IterOfficer;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return ClosestOfficer;
	return;
}

function TriggerEnemyFleeingSpeech(Pawn Enemy)
{
	local int i;
	local Pawn Officer;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		Officer = squad().pawns[i];
		if(Officer.LineOfSightTo(Enemy))
		{
			ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerSuspectFleeingSpeech(Enemy);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function TriggerSuspectDownSpeech(Pawn Enemy)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerTo(Enemy, true);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerSuspectDownSpeech(Enemy);
	}
	return;
}

function TriggerHostageDownSpeech(Pawn Hostage)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerTo(Hostage, true);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerHostageDownSpeech(Hostage);
	}
	return;
}

function TriggerOfficerDownSpeech(Pawn Officer)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerTo(Officer, true);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerOfficerDownSpeech();
	}
	return;
}

function TriggerLeadDownSpeech(Pawn Lead)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerTo(Lead, true);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerLeadDownSpeech();
	}
	return;
}

function TriggerSuspectWontComplySpeech(Pawn Suspect)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerTo(Suspect, true);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerSuspectWontComplySpeech(Suspect);
	}
	return;
}

function TriggerHostageWontComplySpeech(Pawn Hostage)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerTo(Hostage, true);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerHostageWontComplySpeech(Hostage);
	}
	return;
}

function TriggerReactedFirstShotSpeech(Pawn OfficerShot)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerToOfficer(OfficerShot);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerReactedFirstShotSpeech();
	}
	return;
}

function TriggerReactedSecondShotSpeech(Pawn OfficerShot)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerToOfficer(OfficerShot);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerReactedSecondShotSpeech();
	}
	return;
}

function TriggerReactedThirdShotSpeech(Pawn OfficerShot)
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerToOfficer(OfficerShot);
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		ISwatOfficer(ClosestOfficer).GetOfficerSpeechManagerAction().TriggerReactedThirdShotSpeech();
	}
	return;
}

function TriggerTargetCompliantSpeech(Pawn Target)
{
	local Pawn OfficerIter;
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		OfficerIter = squad().pawns[i];
		if(OfficerIter.LineOfSightTo(Target))
		{
			ISwatOfficer(OfficerIter).GetOfficerSpeechManagerAction().TriggerTargetCompliantSpeech(Target);
			// [Explicit Break]
			goto J0x83;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x83:

	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.ElementSpeechManagerGoal'
}