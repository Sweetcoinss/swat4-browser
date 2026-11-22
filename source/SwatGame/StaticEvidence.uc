class StaticEvidence extends ReactiveStaticMesh implements IEvidence, ICanBeSpawned, IUseArchetype
	abstract
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var private InanimateSpawner SpawnedFrom;
var private name SpawnedFromName;
var private ArchetypeInstance ArchetypeInstance;
var private bool Secured;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		SpawnedFromName;
}

simulated function DestroyRWO()
{
	Hide();
	return;
}

simulated function bool CanBeUsedNow()
{
	return AndAnd_BoolBool(Not_PreBool(Secured), Not_PreBool(bHidden));
	return;
}

simulated function OnUsed(Pawn SecurerPawn)
{
	ReactToUsed(SecurerPawn);
	SwatGameInfo(Level.Game).GameEvents.EvidenceSecured.Triggered(self);
	return;
}

simulated function PostUsed()
{
	Secured = true;
	return;
}

simulated function string UniqueID()
{
	return string(SpawnedFromName);
	return;
}

function InitializeFromSpawner(Spawner Spawner)
{
	SpawnedFrom = InanimateSpawner(Spawner);
	SpawnedFromName = Spawner.Name;
	return;
}

function Internal_InitializeFromArchetypeInstance(ArchetypeInstance inInstance)
{
	ArchetypeInstance = inInstance;
	InitializeFromArchetypeInstance();
	return;
}

function InitializeFromArchetypeInstance()
{
	return;
}

function Spawner GetSpawner()
{
	return SpawnedFrom;
	return;
}

defaultproperties
{
	bNoDelete=false
	RemoteRole=1
}