class AI_SquadResource extends AI_Resource
	native
	editinlinenew;

var SquadInfo squad;

function setResourceOwner(Actor aSquad)
{
	squad = SquadInfo(aSquad);
	return;
}

event Init()
{
	super.Init();
	return;
}

function cleanup()
{
	super.cleanup();
	return;
}

function bool requiredResourcesAvailable(int legsPriority, int armsPriority, optional int headPriority)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad.pawns.Length))
	{
		if(Class'Engine.Pawn'.static.checkAlive(squad.pawns[i]))
		{
			if(Not_PreBool(AI_CharacterResource(squad.pawns[i].CharacterAI).requiredResourcesAvailable(legsPriority, armsPriority, headPriority)))
			{
				return false;
			}
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return true;
	return;
}

event bool hasActiveMembers()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad.pawns.Length))
	{
		if(Class'Engine.Pawn'.static.checkAlive(squad.pawns[i]))
		{
			return true;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

event bool isActive()
{
	return AndAnd_BoolBool(GreaterEqual_IntInt(int(squad.AI_LOD_Level), int(3)), hasActiveMembers());
	return;
}

function Pawn Pawn()
{
	local int i;

	if(EqualEqual_IntInt(squad.pawns.Length, 0))
	{
		Log(At_StrStr(At_StrStr("AI WARNING:", string(Name)), "contains no pawns."));
		return none;
	}
	else
	{
		i = 0;
		J0x4F:

		if(Less_IntInt(i, squad.pawns.Length))
		{
			if(Class'Engine.Pawn'.static.checkAlive(squad.pawns[i]))
			{
				return squad.pawns[i];
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x4F;
		}
		Log(At_StrStr(At_StrStr("AI WARNING:", string(Name)), "contains no ACTIVE pawns."));
		return none;
	}
	return;
}

function Class<AI_RunnableAction> getActionClass()
{
	return Class'Tyrion.AI_SquadAction';
	return;
}
