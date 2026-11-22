class SquadInfo extends Actor
	native
	config
	placeable
	hidecategories(Karma);

var Tyrion_ResourceBase SquadAI;
var array<Pawn> pawns;
var(AI) Tyrion_ResourceBase.AI_LOD_Levels AI_LOD_Level;
var float tickTime;
var float tickTimeOrg;
var Range tickTimeUpdateRange;
var bool logTyrion;

function PostBeginPlay()
{
	SquadAI = Class<Tyrion_ResourceBase>(static.DynamicLoadObject("Tyrion.AI_SquadResource", Class'Core.Class')).Allocate(self).;
	Construct_Void();
	SquadAI.setResourceOwner(self);
	return;
}

function memberDestroyed(Pawn member)
{
	if(Class'Engine.Pawn'.static.checkAlive(member))
	{
		memberDied(member);
	}
	return;
}

function memberDied(Pawn member, optional Pawn InstigatedBy, optional Class<DamageType> DamageType, optional Vector HitLocation)
{
	SquadAI.PawnDied(member);
	if(Not_PreBool(SquadAI.isActive()))
	{
		cleanupAI();
	}
	return;
}

function cleanupAI()
{
	SquadAI.cleanup();
	SquadAI.deleteSensors();
	SquadAI.deleteRemovedActions();
	return;
}

function rematchGoals()
{
	SquadAI.bMatchGoals = true;
	return;
}

function int nActiveMembers(out Pawn livingPawn)
{
	local int i, n;

	i = Subtract_IntInt(pawns.Length, 1);
	J0x0F:

	if(GreaterEqual_IntInt(i, 0))
	{
		if(Class'Engine.Pawn'.static.checkAlive(pawns[i]))
		{
			livingPawn = pawns[i];
			AddAdd_Int(n);
		}
		SubtractSubtract_PreInt(i);
		// [Loop Continue]
		goto J0x0F;
	}
	return n;
	return;
}

function addToSquad(Pawn P)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		if(EqualEqual_ObjectObject(pawns[i], P))
		{
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	pawns[pawns.Length] = P;
	return;
}

function removeFromSquad(Pawn P)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		if(EqualEqual_ObjectObject(pawns[i], P))
		{
			pawns.Remove(i, 1);
			// [Explicit Break]
			goto J0x45;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x45:

	return;
}

defaultproperties
{
	AI_LOD_Level=4
	tickTimeUpdateRange=(Min=0.0950000,Max=0.1050000)
	bHidden=true
}