class GameEvent_PostGameStarted extends Object;

var array<IInterested_GameEvent_PostGameStarted> Interested;

function Register(IInterested_GameEvent_PostGameStarted inInterested)
{
	Interested[Interested.Length] = inInterested;
	return;
}

function UnRegister(IInterested_GameEvent_PostGameStarted inInterested)
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

function Triggered()
{
	local int i;

	Log("dkaplan: Triggered of GameEvent_PostGameStarted");
	i = 0;
	J0x3A:

	if(Less_IntInt(i, Interested.Length))
	{
		Interested[i].OnPostGameStarted();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x3A;
	}
	return;
}
