class SquadSecureGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var array<Actor> SecureTargets;

function CopyAdditionalPropertiesFromTemplate(SquadCommandGoal Template)
{
	local int i;
	local SquadSecureGoal TemplateSquadSecureGoal;

	TemplateSquadSecureGoal = SquadSecureGoal(Template);
	assert(NotEqual_ObjectObject(TemplateSquadSecureGoal, none));
	assert(EqualEqual_IntInt(SecureTargets.Length, 0));
	super.CopyAdditionalPropertiesFromTemplate(Template);
	if(NotEqual_ObjectObject(TemplateSquadSecureGoal.achievingAction, none))
	{
		SquadSecureAction(TemplateSquadSecureGoal.achievingAction).CopyTargetsBeingSecuredToGoal();
	}
	Log(Concat_StrStr("TemplateSquadSecureGoal.SecureTargets.Length is: ", string(TemplateSquadSecureGoal.SecureTargets.Length)));
	i = 0;
	J0xB2:

	if(Less_IntInt(i, TemplateSquadSecureGoal.SecureTargets.Length))
	{
		SecureTargets[i] = TemplateSquadSecureGoal.SecureTargets[i];
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("SecureTargets[", string(i)), "] is: "), string(SecureTargets[i])));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xB2;
	}
	return;
}

function AddSecureTarget(Actor SecureTarget)
{
	assert(NotEqual_ObjectObject(SecureTarget, none));
	if(AndAnd_BoolBool(Not_PreBool(IsASecureTarget(SecureTarget)), OrOr_BoolBool(Not_PreBool(SecureTarget.IsA('IEvidence')), IEvidence(SecureTarget).CanBeUsedNow())))
	{
		SecureTargets[SecureTargets.Length] = SecureTarget;
		if(NotEqual_ObjectObject(achievingAction, none))
		{
			SquadSecureAction(achievingAction).NotifyNewSecureTarget();
		}
	}
	return;
}

function int GetNumSecureTargets()
{
	ValidateSecureTargets();
	return SecureTargets.Length;
	return;
}

function Actor GetSecureTarget(int SecureTargetIndex)
{
	assert(Less_IntInt(SecureTargetIndex, SecureTargets.Length));
	assert(GreaterEqual_IntInt(SecureTargetIndex, 0));
	return SecureTargets[SecureTargetIndex];
	return;
}

function RemoveSecureTarget(Actor SecureTarget)
{
	local int i;

	assert(NotEqual_ObjectObject(SecureTarget, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, SecureTargets.Length))
	{
		if(EqualEqual_ObjectObject(SecureTargets[i], SecureTarget))
		{
			SecureTargets.Remove(i, 1);
			// [Explicit Break]
			goto J0x50;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x50:

	return;
}

private function bool IsASecureTarget(Actor TestSecureTarget)
{
	local int i;

	assert(NotEqual_ObjectObject(TestSecureTarget, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, SecureTargets.Length))
	{
		if(EqualEqual_ObjectObject(SecureTargets[i], TestSecureTarget))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return false;
	return;
}

private function ValidateSecureTargets()
{
	local int i;
	local Pawn RestrainTarget;

	i = 0;
	J0x07:

	if(Less_IntInt(i, SecureTargets.Length))
	{
		assert(NotEqual_ObjectObject(SecureTargets[i], none));
		if(SecureTargets[i].IsA('Pawn'))
		{
			RestrainTarget = Pawn(SecureTargets[i]);
			if(OrOr_BoolBool(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(RestrainTarget)), ISwatAI(RestrainTarget).IsArrested()))
			{
				SecureTargets.Remove(i, 1);
			}
			// [Explicit Continue]
			goto J0xDE;
		}
		assert(SecureTargets[i].IsA('IEvidence'));
		if(Not_PreBool(IEvidence(SecureTargets[i]).CanBeUsedNow()))
		{
			SecureTargets.Remove(i, 1);
		}
		J0xDE:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function bool IsInteractingWith(Actor TestActor)
{
	if(OrOr_BoolBool(TestActor.IsA('Pawn'), TestActor.IsA('IEvidence')))
	{
		if(IsASecureTarget(TestActor))
		{
			return true;
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(achievingAction, none), SquadSecureAction(achievingAction).IsTargetBeingSecured(TestActor)))
		{
			return true;
		}
	}
	return false;
	return;
}

defaultproperties
{
	bRepostElementGoalOnSubElementSquad=true
	goalName="SquadSecure"
}