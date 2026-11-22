class Mutator extends Info
	native
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var Mutator NextMutator;
var string GroupName;
var localized string FriendlyName;
var localized string Description;
var bool bUserAdded;

event PreBeginPlay()
{
	if(Not_PreBool(MutatorIsAllowed()))
	{
		Destroy();
	}
	return;
}

function bool MutatorIsAllowed()
{
	return OrOr_BoolBool(Not_PreBool(Level.IsDemoBuild()), EqualEqual_ObjectObject(Class, Class'Engine.Mutator'));
	return;
}

function Destroyed()
{
	local Mutator M;

	if(EqualEqual_ObjectObject(Level.Game.BaseMutator, self))
	{
		Level.Game.BaseMutator = NextMutator;
	}
	else
	{
		M = Level.Game.BaseMutator;
		J0x5A:

		if(NotEqual_ObjectObject(M, none))
		{
			if(EqualEqual_ObjectObject(M.NextMutator, self))
			{
				M.NextMutator = NextMutator;
				// [Explicit Break]
				goto J0xA7;
			}
			M = M.NextMutator;
			// [Loop Continue]
			goto J0x5A;
		}
	}
	J0xA7:

	super(Actor).Destroyed();
	return;
}

function Mutate(string MutateString, PlayerController Sender)
{
	if(NotEqual_ObjectObject(NextMutator, none))
	{
		NextMutator.Mutate(MutateString, Sender);
	}
	return;
}

function ModifyLogin(out string Portal, out string Options)
{
	if(NotEqual_ObjectObject(NextMutator, none))
	{
		NextMutator.ModifyLogin(Portal, Options);
	}
	return;
}

function ModifyPlayer(Pawn Other)
{
	if(NotEqual_ObjectObject(NextMutator, none))
	{
		NextMutator.ModifyPlayer(Other);
	}
	return;
}

function AddMutator(Mutator M)
{
	if(EqualEqual_ObjectObject(NextMutator, none))
	{
		NextMutator = M;
	}
	else
	{
		NextMutator.AddMutator(M);
	}
	return;
}

function bool ReplaceWith(Actor Other, string aClassName)
{
	local Actor A;
	local Class<Actor> aClass;

	if(EqualEqual_StrStr(aClassName, ""))
	{
		return true;
	}
	aClass = Class<Actor>(DynamicLoadObject(aClassName, Class'Core.Class'));
	if(NotEqual_ObjectObject(aClass, none))
	{
		A = Spawn(aClass, Other.Owner, Other.Tag, Other.Location, Other.Rotation);
	}
	if(NotEqual_ObjectObject(A, none))
	{
		A.Event = Other.Event;
		A.Tag = Other.Tag;
		return true;
	}
	return false;
	return;
}

function bool AlwaysKeep(Actor Other)
{
	if(NotEqual_ObjectObject(NextMutator, none))
	{
		return NextMutator.AlwaysKeep(Other);
	}
	return false;
	return;
}

function bool IsRelevant(Actor Other, out byte bSuperRelevant)
{
	local bool bResult;

	bResult = CheckReplacement(Other, bSuperRelevant);
	if(AndAnd_BoolBool(bResult, NotEqual_ObjectObject(NextMutator, none)))
	{
		bResult = NextMutator.IsRelevant(Other, bSuperRelevant);
	}
	return bResult;
	return;
}

function bool CheckRelevance(Actor Other)
{
	local bool bResult;
	local byte bSuperRelevant;

	if(AlwaysKeep(Other))
	{
		return true;
	}
	bResult = IsRelevant(Other, bSuperRelevant);
	return bResult;
	return;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	return true;
	return;
}

function PlayerChangedClass(Controller aPlayer)
{
	if(NotEqual_ObjectObject(NextMutator, none))
	{
		NextMutator.PlayerChangedClass(aPlayer);
	}
	return;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
	local int i;

	i = ServerState.ServerInfo.Length;
	ServerState.ServerInfo.Length = Add_IntInt(i, 1);
	ServerState.ServerInfo[i].Key = "Mutator";
	ServerState.ServerInfo[i].Value = GetHumanReadableName();
	return;
}

function GetServerPlayers(out ServerResponseLine ServerState)
{
	return;
}

function string ParseChatPercVar(Controller Who, string Cmd)
{
	if(NotEqual_ObjectObject(NextMutator, none))
	{
		Cmd = NextMutator.ParseChatPercVar(Who, Cmd);
	}
	return Cmd;
	return;
}

function ServerTraveling(string URL, bool bItems)
{
	if(NotEqual_ObjectObject(NextMutator, none))
	{
		NextMutator.ServerTraveling(URL, bItems);
	}
	return;
}

defaultproperties
{
	FriendlyName="Mutator"
	Description="Description"
}