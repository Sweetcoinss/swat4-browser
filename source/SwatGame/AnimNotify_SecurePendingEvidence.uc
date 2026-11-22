class AnimNotify_SecurePendingEvidence extends AnimNotify_Scripted
	editinlinenew
	collapsecategories
	hidecategories(Object);

function IEvidence GetEvidenceTarget(SwatOfficer SwatOfficer)
{
	local int i;
	local SecureEvidenceAction SecureEvidenceAction;
	local AI_Resource resource;
	local AI_RunnableAction Action;

	resource = AI_Resource(SwatOfficer.CharacterAI);
	if(NotEqual_ObjectObject(resource, none))
	{
		i = 0;
		J0x2B:

		if(Less_IntInt(i, resource.runningActions.Length))
		{
			Action = resource.runningActions[i];
			SecureEvidenceAction = SecureEvidenceAction(Action);
			if(NotEqual_ObjectObject(SecureEvidenceAction, none))
			{
				return SecureEvidenceAction.GetEvidenceTarget();
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x2B;
		}
	}
	return none;
	return;
}

event Notify(Actor Owner)
{
	local SwatOfficer SwatOfficer;
	local IEvidence EvidenceTarget;

	SwatOfficer = SwatOfficer(Owner);
	if(NotEqual_ObjectObject(SwatOfficer, none))
	{
		EvidenceTarget = GetEvidenceTarget(SwatOfficer);
		if(NotEqual_ObjectObject(EvidenceTarget, none))
		{
			EvidenceTarget.OnUsed(SwatOfficer);
			EvidenceTarget.PostUsed();
		}
	}
	return;
}
