class IncapacitatedAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) name IncapaciatedIdleCategoryOverride;
var(Parameters) bool bIsInstantIncapacitation;
var config float MinTimeBeforeTriggeringIncapacitatedSpeech;
var config float MaxTimeBeforeTriggeringIncapacitatedSpeech;
var config float MinTimeBetweenTriggeringIncapacitatedSpeech;
var config float MaxTimeBetweenTriggeringIncapacitatedSpeech;
var config float DistanceToHearIncapacitatedSpeech;

function bool IsRagdollIncapacitation()
{
	return EqualEqual_NameName(IncapaciatedIdleCategoryOverride, 'None');
	return;
}

function Convulse()
{
	return;
}

private function bool ShouldTriggerIncapacitatedSpeech()
{
	local Pawn Player;
	local Controller Iter;

	assert(NotEqual_ObjectObject(Level, none));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Player = Level.GetLocalPlayerController().Pawn;
		if(NotEqual_ObjectObject(Player, none))
		{
			if(LessEqual_FloatFloat(m_pawn.Controller.GetDistanceToSound(Player, m_pawn.Location, Player.Location), DistanceToHearIncapacitatedSpeech))
			{
				return true;
			}
		}
	}
	else
	{
		Iter = Level.ControllerList;
		J0xA9:

		if(NotEqual_ObjectObject(Iter, none))
		{
			if(Iter.IsA('PlayerController'))
			{
				Player = Iter.Pawn;
				if(NotEqual_ObjectObject(Player, none))
				{
					if(LessEqual_FloatFloat(m_pawn.Controller.GetDistanceToSound(Player, m_pawn.Location, Player.Location), DistanceToHearIncapacitatedSpeech))
					{
						return true;
					}
				}
			}
			Iter = Iter.nextController;
			// [Loop Continue]
			goto J0xA9;
		}
	}
	return false;
	return;
}

state Running
{Begin:

	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(string(m_pawn.Name), " started incapacitated behavior"));
	}
	useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
	if(IsRagdollIncapacitation())
	{
		m_pawn.BecomeRagdoll();
	}
	else
	{
		m_pawn.SetCollision(true, false, false);
		ISwatAI(m_pawn).SetIdleCategory(IncapaciatedIdleCategoryOverride);
	}
	if(bIsInstantIncapacitation)
	{
		Sleep(RandRange(MinTimeBeforeTriggeringIncapacitatedSpeech, MaxTimeBeforeTriggeringIncapacitatedSpeech));
	}
Loop:

	if(ShouldTriggerIncapacitatedSpeech())
	{
		ISwatAI(m_pawn).GetSpeechManagerAction().TriggerIncapacitatedSpeech();
	}
	Sleep(RandRange(MinTimeBetweenTriggeringIncapacitatedSpeech, MaxTimeBetweenTriggeringIncapacitatedSpeech));
	goto 'Loop';
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.IncapacitatedGoal'
}