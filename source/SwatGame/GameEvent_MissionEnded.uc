class GameEvent_MissionEnded extends Object;

var array<IInterested_GameEvent_MissionEnded> Interested;

function Register(IInterested_GameEvent_MissionEnded inInterested)
{
	Interested[Interested.Length] = inInterested;
	return;
}

function UnRegister(IInterested_GameEvent_MissionEnded inInterested)
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
	local array<IInterested_GameEvent_MissionEnded> localInterested;
	local int i;

	localInterested = Interested;
	i = 0;
	J0x12:

	if(Less_IntInt(i, localInterested.Length))
	{
		localInterested[i].OnMissionEnded();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}
