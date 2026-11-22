class LineOfSightTrigger extends Triggers
	native
	config
	placeable
	hidecategories(Karma);

var float MaxViewDist;
var float OldTickTime;
var bool bEnabled;
var bool bTriggered;
var name SeenActorTag;
var Actor SeenActor;
var int MaxViewAngle;
var float RequiredViewDir;

function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	RequiredViewDir = Cos(Divide_FloatFloat(Multiply_FloatFloat(float(MaxViewAngle), 3.1415930), float(180)));
	if(NotEqual_NameName(SeenActorTag, 'None'))
	{
		foreach AllActors(Class'Engine.Actor', SeenActor, SeenActorTag)
		{
			break;
		}
	}
	return;
}

event PlayerSeesMe(PlayerController P)
{
	TriggerEvent(Event, self, P.Pawn);
	bTriggered = true;
	return;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	bEnabled = true;
	return;
}

defaultproperties
{
	MaxViewDist=3000.0000000
	bEnabled=true
	MaxViewAngle=15
	bCollideActors=false
}