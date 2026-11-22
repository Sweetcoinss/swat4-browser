class ElementSquadInfo extends OfficerTeamInfo
	native
	config
	hidecategories(Karma);

var private ElementSpeechManagerGoal ElementSpeechManagerGoal;
var private ElementSpeechManagerAction ElementSpeechManager;

event PostBeginPlay()
{
	super.PostBeginPlay();
	PostSpeechManagerGoal();
	return;
}

protected function InitAbilities()
{
	super.InitAbilities();
	SquadAI.addAbility(Class'SwatAICommon.ElementSpeechManagerAction'.static.Allocate(self)., Construct_Void());
	return;
}

private function PostSpeechManagerGoal()
{
	ElementSpeechManagerGoal = Class'SwatAICommon.ElementSpeechManagerGoal'.static.Allocate(self).;
	construct_AI_Resource(AI_Resource(SquadAI));
	assert(NotEqual_ObjectObject(ElementSpeechManagerGoal, none));
	ElementSpeechManagerGoal.AddRef();
	ElementSpeechManagerGoal.postGoal(none);
	return;
}

event Destroyed()
{
	super.Destroyed();
	ElementSpeechManager = none;
	if(NotEqual_ObjectObject(ElementSpeechManagerGoal, none))
	{
		ElementSpeechManagerGoal.Release();
		ElementSpeechManagerGoal = none;
	}
	return;
}

private function ElementSpeechManagerAction GetElementSpeechManagerAction()
{
	assert(NotEqual_ObjectObject(ElementSpeechManagerGoal, none));
	assert(NotEqual_ObjectObject(ElementSpeechManagerGoal.achievingAction, none));
	assert(NotEqual_ObjectObject(ElementSpeechManagerAction(ElementSpeechManagerGoal.achievingAction), none));
	return ElementSpeechManagerAction(ElementSpeechManagerGoal.achievingAction);
	return;
}

protected function UnpostCommandGoals()
{
	local OfficerTeamInfo RedSquad, BlueSquad;

	ClearCommandGoal();
	RedSquad = SwatAIRepo.GetRedSquad();
	BlueSquad = SwatAIRepo.GetBlueSquad();
	RedSquad.ClearCommandGoal();
	BlueSquad.ClearCommandGoal();
	return;
}

function RemoveCommandGoalsFor(OfficerTeamInfo TeamInfo)
{
	local SquadCommandGoal NewCommandGoal;
	local OfficerTeamInfo RedSquad, BlueSquad;

	assert(NotEqual_ObjectObject(TeamInfo, none));
	assert(NotEqual_ObjectObject(TeamInfo, self));
	if(IsExecutingCommandGoal())
	{
		RedSquad = SwatAIRepo.GetRedSquad();
		BlueSquad = SwatAIRepo.GetBlueSquad();
		if(CurrentSquadCommandGoal.ShouldRepostElementGoalOnSubElementSquad())
		{
			if(EqualEqual_ObjectObject(TeamInfo, RedSquad))
			{
				if(AndAnd_BoolBool(Not_PreBool(BlueSquad.IsExecutingCommandGoal()), BlueSquad.CanExecuteCommand()))
				{
					NewCommandGoal = CreateCommandGoalFromTemplate(BlueSquad, CurrentSquadCommandGoal);
					assert(NotEqual_ObjectObject(NewCommandGoal, none));
					BlueSquad.InternalPostCommandGoal(NewCommandGoal);
				}
			}
			else
			{
				assert(EqualEqual_ObjectObject(TeamInfo, BlueSquad));
				if(AndAnd_BoolBool(Not_PreBool(RedSquad.IsExecutingCommandGoal()), RedSquad.CanExecuteCommand()))
				{
					NewCommandGoal = CreateCommandGoalFromTemplate(RedSquad, CurrentSquadCommandGoal);
					assert(NotEqual_ObjectObject(NewCommandGoal, none));
					RedSquad.InternalPostCommandGoal(NewCommandGoal);
				}
			}
			CurrentSquadCommandGoal.unPostGoal(none);
		}
		else
		{
			if(AndAnd_BoolBool(EqualEqual_ObjectObject(TeamInfo, RedSquad), Not_PreBool(BlueSquad.IsExecutingCommandGoal())))
			{
				ColoredSquadInfo(BlueSquad).TriggerNeedOrdersSpeech();
			}
			else
			{
				if(AndAnd_BoolBool(EqualEqual_ObjectObject(TeamInfo, BlueSquad), Not_PreBool(RedSquad.IsExecutingCommandGoal())))
				{
					ColoredSquadInfo(RedSquad).TriggerNeedOrdersSpeech();
				}
			}
		}
	}
	ClearCommandGoal();
	return;
}

private function SquadCommandGoal CreateCommandGoalFromTemplate(OfficerTeamInfo TeamInfo, SquadCommandGoal CommandGoalTemplate)
{
	local SquadCommandGoal NewCommandGoal;

	assert(NotEqual_ObjectObject(CommandGoalTemplate, none));
	NewCommandGoal = CommandGoalTemplate.Class.static.Allocate(self).;
	construct_AI_Resource(AI_Resource(TeamInfo.SquadAI));
	assert(NotEqual_ObjectObject(NewCommandGoal, none));
	NewCommandGoal.copyParametersFrom(CommandGoalTemplate);
	NewCommandGoal.CopyAdditionalPropertiesFromTemplate(CommandGoalTemplate);
	NewCommandGoal.SetHasBeenCopied();
	return NewCommandGoal;
	return;
}

private function bool CanSpeak()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		if(Class'Engine.Pawn'.static.checkConscious(pawns[i]))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function TriggerEnemyFleeingSpeech(Pawn Enemy)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerEnemyFleeingSpeech(Enemy);
	}
	return;
}

function TriggerSuspectDownSpeech(Pawn Enemy)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerSuspectDownSpeech(Enemy);
	}
	return;
}

function TriggerHostageDownSpeech(Pawn Hostage)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerHostageDownSpeech(Hostage);
	}
	return;
}

function TriggerOfficerDownSpeech(Pawn Officer)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerOfficerDownSpeech(Officer);
	}
	return;
}

function TriggerLeadDownSpeech(Pawn Lead)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerLeadDownSpeech(Lead);
	}
	return;
}

function TriggerSuspectWontComplySpeech(Pawn Suspect)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerSuspectWontComplySpeech(Suspect);
	}
	return;
}

function TriggerHostageWontComplySpeech(Pawn Hostage)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerHostageWontComplySpeech(Hostage);
	}
	return;
}

function TriggerReactedFirstShotSpeech(Pawn OfficerShot)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerReactedFirstShotSpeech(OfficerShot);
	}
	return;
}

function TriggerReactedSecondShotSpeech(Pawn OfficerShot)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerReactedSecondShotSpeech(OfficerShot);
	}
	return;
}

function TriggerReactedThirdShotSpeech(Pawn OfficerShot)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerReactedThirdShotSpeech(OfficerShot);
	}
	return;
}

function TriggerTargetCompliantSpeech(Pawn Target)
{
	if(CanSpeak())
	{
		GetElementSpeechManagerAction().TriggerTargetCompliantSpeech(Target);
	}
	return;
}

function TriggerTeamReportedSpeech(Pawn Officer)
{
	ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerElementReportedSpeech();
	return;
}
