class ComplianceAction extends LookAtOfficersActionBase
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kPostComplianceGoalPriority = 91;

var config array<name> CrouchingComplianceAnimations;
var config array<name> StandingComplianceAnimations;
var config array<name> CrouchingStunnedComplianceAnimations;
var config array<name> StandingStunnedComplianceAnimations;
var config array<name> CrouchingArmsUpAnimations;
var config array<name> StandingArmsUpAnimations;
var config array<name> CrouchingStunnedArmsUpAnimations;
var config array<name> StandingStunnedArmsUpAnimations;
var private bool bJustComplied;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super(SwatCharacterAction).initAction(R, Goal);
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 20);
	if(Not_PreBool(ComplianceGoal(achievingGoal).HasCompliedAlready()))
	{
		ComplianceGoal(achievingGoal).SetHasCompliedAlready();
		bJustComplied = true;
	}
	SwatAIRepository(m_pawn.Level.AIRepo).GetHive().NotifyAIBecameCompliant(m_pawn);
	InitLookAtOfficersActionBase(20);
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(20);
	ISwatAI(m_pawn).AnimStopSpecial();
	return;
}

private function TriggerCompliantSpeech()
{
	ISwatAI(m_pawn).GetSpeechManagerAction().TriggerCompliantSpeech();
	return;
}

function name GetComplianceAnimation()
{
	if(m_pawn.bIsCrouched)
	{
		if(m_pawn.IsStunned())
		{
			return CrouchingStunnedComplianceAnimations[Rand(CrouchingStunnedComplianceAnimations.Length)];
		}
		else
		{
			return CrouchingComplianceAnimations[Rand(CrouchingComplianceAnimations.Length)];
		}
	}
	else
	{
		if(m_pawn.IsStunned())
		{
			return StandingStunnedComplianceAnimations[Rand(StandingStunnedComplianceAnimations.Length)];
		}
		else
		{
			return StandingComplianceAnimations[Rand(StandingComplianceAnimations.Length)];
		}
	}
	return;
}

function name GetPreComplyAnimation()
{
	if(m_pawn.bIsCrouched)
	{
		if(m_pawn.IsStunned())
		{
			return CrouchingStunnedArmsUpAnimations[Rand(CrouchingStunnedArmsUpAnimations.Length)];
		}
		else
		{
			return CrouchingArmsUpAnimations[Rand(CrouchingArmsUpAnimations.Length)];
		}
	}
	else
	{
		if(m_pawn.IsStunned())
		{
			return StandingStunnedArmsUpAnimations[Rand(StandingStunnedArmsUpAnimations.Length)];
		}
		else
		{
			return StandingArmsUpAnimations[Rand(StandingArmsUpAnimations.Length)];
		}
	}
	return;
}

final latent function PreComply()
{
	local int ComplyAnimChannel;

	ComplyAnimChannel = m_pawn.AnimPlaySpecial(GetPreComplyAnimation(), 0.1000000);
	m_pawn.FinishAnim(ComplyAnimChannel);
	ComplyAnimChannel = m_pawn.AnimPlaySpecial(GetComplianceAnimation());
	m_pawn.FinishAnim(ComplyAnimChannel);
	return;
}

final latent function Comply()
{
	local ISwatAICharacter SwatAICharacter;

	MPLog("in ComplianceAction::Comply().");
	if(bJustComplied)
	{
		TriggerCompliantSpeech();
		PreComply();
	}
	ComplianceGoal(achievingGoal).SetCanBeArrested();
	SwatAICharacter = ISwatAICharacter(m_pawn);
	if(NotEqual_ObjectObject(SwatAICharacter, none))
	{
		SwatAICharacter.SetCanBeArrested();
	}
	if(m_pawn.IsA('SwatEnemy'))
	{
		ISwatEnemy(m_pawn).DropAllWeapons();
	}
	return;
}

state Running
{	J0x00:
	if(OrOr_BoolBool(ISwatAI(m_pawn).GetCommanderAction().IsRestrainedGoalRunning(), Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority))))
	{
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
	if(AndAnd_BoolBool(bJustComplied, Not_PreBool(m_pawn.IsStunned())))
	{
		SleepInitialDelayTime(false);
	}
	ISwatAI(m_pawn).SwapInCompliantAnimSet();
	ISwatAI(m_pawn).SetIdleCategory('Compliant');
	Comply();
	SwatAIRepository(m_pawn.Level.AIRepo).GetHive().NotifyCompliantAIFinishedComplying(m_pawn);
	if(NotEqual_IntInt(achievingGoal.Priority, 91))
	{
		achievingGoal.changePriority(91);
		clearDummyGoals();
		useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
	}
	LookAtNearbyOfficers();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.ComplianceGoal'
}