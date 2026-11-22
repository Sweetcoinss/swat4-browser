class WarpZoneMarker extends SmallNavigationPoint
	native
	config
	notplaceable
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var WarpZoneInfo markedWarpZone;
var Actor TriggerActor;
var Actor TriggerActor2;

function PostBeginPlay()
{
	if(Greater_IntInt(markedWarpZone.numDestinations, 1))
	{
		FindTriggerActor();
	}
	super(NavigationPoint).PostBeginPlay();
	return;
}

function FindTriggerActor()
{
	local ZoneTrigger Z;

	foreach AllActors(Class'Engine.ZoneTrigger', Z)
	{
		if(EqualEqual_NameName(Z.Event, markedWarpZone.ZoneTag))
		{
			TriggerActor = Z;
			return;
		}
	}
	return;
}

function Actor SpecialHandling(Pawn Other)
{
	if(EqualEqual_ObjectObject(Other.Region.Zone, markedWarpZone))
	{
		markedWarpZone.ActorEntered(Other);
	}
	return self;
	return;
}

defaultproperties
{
	bCollideWhenPlacing=false
	bHiddenEd=true
}