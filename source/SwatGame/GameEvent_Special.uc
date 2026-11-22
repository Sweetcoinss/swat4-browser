class GameEvent_Special extends Object;

var array<IInterested_GameEvent_Special> Interested;

function Register(IInterested_GameEvent_Special inInterested)
{
	Interested[Interested.Length] = inInterested;
	return;
}

function UnRegister(IInterested_GameEvent_Special inInterested)
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

function Triggered(name SpecialGameEvent)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Interested.Length))
	{
		Interested[i].OnSpecialGameEvent(SpecialGameEvent);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}
