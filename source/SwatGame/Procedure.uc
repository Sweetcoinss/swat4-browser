class Procedure extends Object implements IProcedure
	abstract
	config(Leadership);

const NOT_IN_ARRAY = -1;

var config localized string Description;
var config bool IsNeverHidden;
var config bool IsShownInObjectivesPanel;
var config bool IsABonus;
var private SwatGameInfo Game;

protected final function SwatGameInfo GetGame()
{
	assert(NotEqual_ObjectObject(Game, none));
	return Game;
	return;
}

final function Init(SwatGameInfo GameInfo)
{
	assert(NotEqual_ObjectObject(GameInfo, none));
	Game = GameInfo;
	if(Game.DebugLeadership)
	{
		Log(Concat_StrStr("[LEADERSHIP] Initializing ", string(Class.Name)));
	}
	PostInitHook();
	return;
}

function PostInitHook()
{
	return;
}

function string Status()
{
	return "";
	return;
}

function int GetCurrentValue()
{
	return;
}

function bool IsMaxed()
{
	return true;
	return;
}

function Add(Pawn inPawn, out array<SwatPawn> SwatPawnArray)
{
	if(IsInArray(inPawn, SwatPawnArray))
	{
		return;
	}
	assert(inPawn.IsA('SwatPawn'));
	SwatPawnArray[SwatPawnArray.Length] = SwatPawn(inPawn);
	return;
}

function Remove(Pawn inPawn, out array<SwatPawn> SwatPawnArray)
{
	local int i;

	i = GetArrayIndex(inPawn, SwatPawnArray);
	if(NotEqual_IntInt(i, -1))
	{
		SwatPawnArray.Remove(i, 1);
	}
	return;
}

function AssertNotInArray(Pawn inPawn, out array<SwatPawn> SwatPawnArray, name Doc)
{
	AssertWithDescription(Not_PreBool(IsInArray(inPawn, SwatPawnArray)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Class.Name)), ": "), string(inPawn.Name)), " was found to be in the "), string(Doc)), " array, but it shouldn't be there."));
	return;
}

function bool IsInArray(Pawn inPawn, out array<SwatPawn> SwatPawnArray)
{
	return NotEqual_IntInt(GetArrayIndex(inPawn, SwatPawnArray), -1);
	return;
}

function int GetArrayIndex(Pawn inPawn, out array<SwatPawn> SwatPawnArray)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, SwatPawnArray.Length))
	{
		if(EqualEqual_ObjectObject(SwatPawnArray[i], inPawn))
		{
			return i;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return -1;
	return;
}

function int GetNumActors(Class<Actor> inClass)
{
	local Actor AnActor;
	local int NumActors;

	foreach GetGame().AllActors(inClass, AnActor)
	{
		AddAdd_Int(NumActors);
	}
	return NumActors;
	return;
}

function int GetNumPlayers()
{
	return GetNumActors(Class'SwatGame.SwatPlayer');
	return;
}

function int GetNumOfficers()
{
	return GetNumActors(Class'SwatGame.SwatOfficer');
	return;
}
