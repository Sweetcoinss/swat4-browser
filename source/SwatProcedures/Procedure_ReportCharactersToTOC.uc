class Procedure_ReportCharactersToTOC extends Procedure implements IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnArrested, IInterested_GameEvent_ReportableReportedToTOC
	config(Leadership);

var config int Bonus;
var array<IAmReportableCharacter> ReportableCharacters;
var array<IAmReportableCharacter> ReportedCharacters;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDied.Register(self);
	GetGame().GameEvents.PawnIncapacitated.Register(self);
	GetGame().GameEvents.PawnArrested.Register(self);
	GetGame().GameEvents.ReportableReportedToTOC.Register(self);
	FindInitialReportableCharacters();
	return;
}

private function FindInitialReportableCharacters()
{
	local IAmReportableCharacter ReportableCharacter;

	foreach GetGame().AllActors(Class'SwatGame.IAmReportableCharacter', ReportableCharacter)
	{
		if(ReportableCharacter.CanBeUsedNow())
		{
			AddReportableCharacter(ReportableCharacter, 'InitiallyReportable');
		}
	}
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Pawn.IsA('IAmReportableCharacter'))
	{
		AddReportableCharacter(IAmReportableCharacter(Pawn), 'PawnDied');
	}
	return;
}

function OnPawnArrested(Pawn Pawn, Pawn Arrester)
{
	if(Pawn.IsA('IAmReportableCharacter'))
	{
		AddReportableCharacter(IAmReportableCharacter(Pawn), 'PawnArrested');
	}
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Pawn.IsA('IAmReportableCharacter'))
	{
		AddReportableCharacter(IAmReportableCharacter(Pawn), 'PawnIncapacitated');
	}
	return;
}

private function AddReportableCharacter(IAmReportableCharacter ReportableCharacter, name DebugWhy)
{
	local bool isAlreadyInArray;
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ReportableCharacters.Length))
	{
		if(EqualEqual_ObjectObject(ReportableCharacters[i], ReportableCharacter))
		{
			isAlreadyInArray = true;
			// [Explicit Break]
			goto J0x41;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x41:

	if(Not_PreBool(isAlreadyInArray))
	{
		ReportableCharacters[ReportableCharacters.Length] = ReportableCharacter;
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(ReportableCharacter.Name)), " to the list of ReportableCharacters because "), string(DebugWhy)), ". ReportableCharacters.length="), string(ReportableCharacters.Length)));
		}
	}
	else
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " was called to AddReportableCharacter() because "), string(DebugWhy)), ", but "), string(ReportableCharacter)), " is already in the list of ReportableCharacters."));
		}
	}
	return;
}

function OnReportableReportedToTOC(IAmReportableCharacter ReportableCharacter, Pawn Reporter)
{
	local int i;
	local bool wasInReportableArray, isAlreadyInReportedArray;

	assert(NotEqual_ObjectObject(ReportableCharacter, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, ReportableCharacters.Length))
	{
		if(EqualEqual_ObjectObject(ReportableCharacters[i], ReportableCharacter))
		{
			wasInReportableArray = true;
			// [Explicit Break]
			goto J0x4C;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x4C:

	AssertWithDescription(wasInReportableArray, "Unexpected bonus state: AI was reported without first being declared eligible [darren]");
	i = 0;
	J0xB7:

	if(Less_IntInt(i, ReportedCharacters.Length))
	{
		if(EqualEqual_ObjectObject(ReportedCharacters[i], ReportableCharacter))
		{
			isAlreadyInReportedArray = true;
			// [Explicit Break]
			goto J0xF1;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xB7;
	}
	J0xF1:

	AssertWithDescription(Not_PreBool(isAlreadyInReportedArray), "Unexpected bonus state: AI was reported more than once [darren]");
	if(Not_PreBool(isAlreadyInReportedArray))
	{
		ReportedCharacters[ReportedCharacters.Length] = ReportableCharacter;
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(ReportableCharacter.Name)), " to the list of ReportedCharacters because ReportableReportedToTOC"), ". ReportedCharacters.length="), string(ReportedCharacters.Length)), " (ReportableCharacters.length="), string(ReportableCharacters.Length)), ")"));
		}
	}
	assert(LessEqual_IntInt(ReportedCharacters.Length, ReportableCharacters.Length));
	return;
}

function string Status()
{
	assert(LessEqual_IntInt(ReportedCharacters.Length, ReportableCharacters.Length));
	return Concat_StrStr(Concat_StrStr(string(ReportedCharacters.Length), "/"), string(ReportableCharacters.Length));
	return;
}

function int GetCurrentValue()
{
	local int retval;

	assert(LessEqual_IntInt(ReportedCharacters.Length, ReportableCharacters.Length));
	if(EqualEqual_IntInt(ReportedCharacters.Length, 0))
	{
		retval = 0;
	}
	else
	{
		retval = int(Multiply_FloatFloat(Divide_FloatFloat(float(ReportedCharacters.Length), float(ReportableCharacters.Length)), float(Bonus)));
	}
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = "), string(retval)), " with status (ReportedCharacters.length / ReportableCharacters.length) = "), Status()));
	}
	return retval;
	return;
}

function bool IsMaxed()
{
	return EqualEqual_IntInt(GetCurrentValue(), Bonus);
	return;
}
