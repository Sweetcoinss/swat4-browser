class SecureEvidenceGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) IEvidence EvidenceTarget;

overloaded function Construct(AI_Resource R, IEvidence inEvidenceTarget)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inEvidenceTarget, none));
	EvidenceTarget = inEvidenceTarget;
	return;
}

defaultproperties
{
	Priority=80
	goalName="SecureEvidence"
}