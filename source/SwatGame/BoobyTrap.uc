class BoobyTrap extends ReactiveStaticMesh implements IUseArchetype, ICanBeDisabled
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var SwatDoor BoobyTrapDoor;
var config float QualifyTime;
var bool bActive;
var name AttachSocket;

function PostBeginPlay()
{
	super(ReactiveWorldObject).PostBeginPlay();
	UsableNow = false;
	return;
}

function OnBoobyTrapInitialize()
{
	return;
}

simulated function bool CanBeUsedByToolkitNow()
{
	return bActive;
	return;
}

function OnUsingByToolkitBegan(Pawn User)
{
	return;
}

function OnUsedByToolkit(Pawn User)
{
	ReactToUsed(User.GetActiveItem());
	return;
}

function OnUsingByToolkitInterrupted(Pawn User)
{
	return;
}

simulated function float GetQualifyTimeForToolkit()
{
	return QualifyTime;
	return;
}

simulated function bool isActive()
{
	return bActive;
	return;
}

function DeActivate()
{
	bActive = false;
	BoobyTrapDoor.SetBoobyTrap(none);
	return;
}

function ReactToUsed(Actor Other)
{
	if(AndAnd_BoolBool(bActive, Other.IsA('Toolkit')))
	{
		super(ReactiveWorldObject).ReactToUsed(Other);
		DeActivate();
	}
	return;
}

function ReactToDamaged(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(bActive)
	{
		super(ReactiveWorldObject).ReactToDamaged(Damage, EventInstigator, HitLocation, Momentum, DamageType);
		DeActivate();
	}
	return;
}

function ReactToTriggered(Actor Other)
{
	if(bActive)
	{
		super(ReactiveWorldObject).ReactToTriggered(BoobyTrapDoor);
		DeActivate();
	}
	return;
}

function OnTriggeredByDoor()
{
	ReactToTriggered(BoobyTrapDoor);
	return;
}

final function InitializeFromSpawner(Spawner Spawner)
{
	local BoobyTrapSpawner BoobySpawner;
	local SwatDoor Door;

	BoobySpawner = BoobyTrapSpawner(Spawner);
	assert(NotEqual_ObjectObject(BoobySpawner, none));
	foreach DynamicActors(Class'SwatGame.SwatDoor', Door, BoobySpawner.DoorTag)
	{
		BoobyTrapDoor = Door;
	}
	BoobyTrapDoor.SetBoobyTrap(self);
	bActive = true;
	AttachSocket = BoobySpawner.DoorAttachmentBone;
	OnBoobyTrapInitialize();
	return;
}

final function Internal_InitializeFromArchetypeInstance(ArchetypeInstance Instance)
{
	return;
}

final function InitializeFromArchetypeInstance()
{
	return;
}
