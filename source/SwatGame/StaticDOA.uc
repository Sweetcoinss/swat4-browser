class StaticDOA extends StaticMeshActor implements IAmReportableCharacter, IUseArchetype
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var private bool HasBeenReported;
var private name SpawnedFromName;

replication
{
	// Pos:0x000
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		HasBeenReported, SpawnedFromName;
}

simulated function bool CanBeUsedNow()
{
	return Not_PreBool(HasBeenReported);
	return;
}

simulated function OnUsed(Pawn Other)
{
	AssertWithDescription(Not_PreBool(HasBeenReported), "[tcohen] StaticDOA::OnUsed() but this DOA has already been reported.");
	SwatGameInfo(Level.Game).GameEvents.ReportableReportedToTOC.Triggered(self, Other);
	return;
}

simulated function PostUsed()
{
	HasBeenReported = true;
	return;
}

simulated function string UniqueID()
{
	return string(SpawnedFromName);
	return;
}

simulated function name GetEffectEventForReportingToTOC()
{
	return 'ReportedDOA';
	return;
}

simulated function name GetEffectEventForReportResponseFromTOC()
{
	return 'RepliedDOAReported';
	return;
}

function InitializeFromSpawner(Spawner Spawner)
{
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

defaultproperties
{
	bStatic=false
	bStasis=true
	CollisionRadius=30.0000000
	CollisionHeight=20.0000000
	bUseCylinderCollision=true
}