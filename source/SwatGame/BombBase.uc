class BombBase extends ReactiveStaticMesh implements IAmUsedByToolkit, ICanBeSpawned, ICanBeDisabled, IUseArchetype
	abstract
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var config float TimeToQualify;
var bool bActive;
var private name SpawnedFromName;
var Spawner Spawner;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		SpawnedFromName, bActive;
}

simulated function PostNetBeginPlay()
{
	super(Actor).PostNetBeginPlay();
	if(Not_PreBool(bActive))
	{
		ReactToTriggered(none);
	}
	return;
}

simulated function bool CanBeUsedByToolkitNow()
{
	return bActive;
	return;
}

simulated function OnUsingByToolkitBegan(Pawn User)
{
	return;
}

simulated function OnUsedByToolkit(Pawn User)
{
	if(bActive)
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			SwatGameInfo(Level.Game).GameEvents.BombDisabled.Triggered(self, User);
			SwatGameInfo(Level.Game).GameEvents.InanimateDisabled.Triggered(self, User);
			BroadcastReactToTriggered(User);
			bActive = false;
		}
	}
	return;
}

simulated function OnUsingByToolkitInterrupted(Pawn User)
{
	return;
}

simulated function float GetQualifyTimeForToolkit()
{
	return TimeToQualify;
	return;
}

function InitializeFromSpawner(Spawner inSpawner)
{
	Spawner = inSpawner;
	SpawnedFromName = Spawner.Name;
	return;
}

function Internal_InitializeFromArchetypeInstance(ArchetypeInstance Instance)
{
	return;
}

function InitializeFromArchetypeInstance()
{
	return;
}

function Spawner GetSpawner()
{
	return Spawner;
	return;
}

simulated function bool isActive()
{
	return bActive;
	return;
}

simulated function string UniqueID()
{
	return string(SpawnedFromName);
	return;
}

defaultproperties
{
	TimeToQualify=5.0000000
	bActive=true
	bNoDelete=false
	RemoteRole=1
	bUseCollisionBoneBoundingBox=true
}