class Procedure_SecureAllWeapons extends Procedure implements IInterested_GameEvent_EvidenceSecured
	config(Leadership);

var config int Bonus;
var int NumSecured;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.EvidenceSecured.Register(self);
	return;
}

function OnEvidenceSecured(IEvidence Secured)
{
	AddAdd_Int(NumSecured);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " incremented NumSecured to "), string(NumSecured)), " because EvidenceSecured."));
	}
	return;
}

function string Status()
{
	local int NumUnsecured;

	NumUnsecured = GetNumUnSecuredWeapons();
	return Concat_StrStr(Concat_StrStr(string(NumSecured), "/"), string(Add_IntInt(NumUnsecured, NumSecured)));
	return;
}

function int GetCurrentValue()
{
	local int NumUnsecured, retval;

	NumUnsecured = GetNumUnSecuredWeapons();
	if(EqualEqual_IntInt(NumUnsecured, 0))
	{
		retval = Bonus;
	}
	else
	{
		retval = int(Multiply_FloatFloat(Divide_FloatFloat(float(NumSecured), float(Add_IntInt(NumUnsecured, NumSecured))), float(Bonus)));
	}
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = "), string(retval)), " because NumSecured = "), string(NumSecured)), " / NumUnsecured = "), string(NumUnsecured)), "."));
	}
	return retval;
	return;
}

private function int GetNumUnSecuredWeapons()
{
	local IEvidence Evidence;
	local int Count;

	foreach GetGame().DynamicActors(Class'Engine.IEvidence', Evidence)
	{
		if(Evidence.CanBeUsedNow())
		{
			AddAdd_Int(Count);
			if(GetGame().DebugLeadershipStatus)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] SecureAllWeapons: Remaining UnSecuredWeapon #", string(Count)), " - "), string(Evidence.Name)));
			}
		}
	}
	return Count;
	return;
}

function bool IsMaxed()
{
	return EqualEqual_IntInt(GetCurrentValue(), Bonus);
	return;
}
