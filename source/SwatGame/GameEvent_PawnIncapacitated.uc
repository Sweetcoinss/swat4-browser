class GameEvent_PawnIncapacitated extends Object;

var array<IInterested_GameEvent_PawnIncapacitated> Interested;

function Register(IInterested_GameEvent_PawnIncapacitated inInterested)
{
	Interested[Interested.Length] = inInterested;
	return;
}

function UnRegister(IInterested_GameEvent_PawnIncapacitated inInterested)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Interested.Length))
	{
		if(EqualEqual_ObjectObject(Interested[i], inInterested))
		{
			Interested.Remove(i, 1);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function Triggered(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Interested.Length))
	{
		Interested[i].OnPawnIncapacitated(Pawn, Incapacitator, WasAThreat);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}
