class BoobyTrapDoorAttachment extends ReactiveWorldObject implements IAmUsedByToolkit
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

function PostBeginPlay()
{
	super.PostBeginPlay();
	AssertWithDescription(AndAnd_BoolBool(NotEqual_ObjectObject(Owner, none), Owner.IsA('BoobyTrap')), "BoobyDoorAttachment's can only be spawned by BoobyTraps, and must have the BoobyTrap as the owner");
	UsableNow = false;
	return;
}

simulated function bool CanBeUsedByToolkitNow()
{
	return BoobyTrap(Owner).bActive;
	return;
}

function OnUsingByToolkitBegan(Pawn User)
{
	return;
}

function OnUsedByToolkit(Pawn User)
{
	ReactToUsed(User.GetActiveItem());
	BoobyTrap(Owner).ReactToUsed(User.GetActiveItem());
	return;
}

function ReactToUsed(Actor Other)
{
	if(AndAnd_BoolBool(BoobyTrap(Owner).bActive, Other.IsA('Toolkit')))
	{
		super.ReactToUsed(Other);
	}
	return;
}

function OnUsingByToolkitInterrupted(Pawn User)
{
	return;
}

simulated function float GetQualifyTimeForToolkit()
{
	return BoobyTrap(Owner).QualifyTime;
	return;
}

defaultproperties
{
	bCollideWorld=true
	bBlockActors=true
}