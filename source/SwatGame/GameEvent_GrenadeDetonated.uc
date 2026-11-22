class GameEvent_GrenadeDetonated extends Object;

var array<IInterested_GameEvent_GrenadeDetonated> Interested;

function Register(IInterested_GameEvent_GrenadeDetonated inInterested)
{
	Interested[Interested.Length] = inInterested;
	return;
}

function UnRegister(IInterested_GameEvent_GrenadeDetonated inInterested)
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

function Triggered(Pawn GrenadeOwner, SwatGrenadeProjectile Grenade)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Interested.Length))
	{
		Interested[i].OnGrenadeDetonated(GrenadeOwner, Grenade);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}
