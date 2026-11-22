class Volume extends Brush
	native
	config
	notplaceable
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var Actor AssociatedActor;
var name AssociatedActorTag;
var int LocationPriority;
var localized string LocationName;
var edfindable DecorationList DecoList;
var bool bOccludedByGeometryInEditor;

// Export UVolume::execEncompasses(FFrame&, void* const)
native function bool Encompasses(Actor Other);

function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	if(NotEqual_NameName(AssociatedActorTag, 'None'))
	{
		foreach AllActors(Class'Engine.Actor', AssociatedActor, AssociatedActorTag)
		{
			break;
		}
	}
	if(NotEqual_ObjectObject(AssociatedActor, none))
	{
		GotoState('AssociatedTouch');
		InitialState = GetStateName();
	}
	return;
}

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	super(Actor).DisplayDebug(Canvas, YL, YPos);
	Canvas.DrawText(Concat_StrStr("AssociatedActor ", string(AssociatedActor)), false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	return;
}

state AssociatedTouch
{
	event Touch(Actor Other)
	{
		AssociatedActor.Touch(Other);
		return;
	}

	event UnTouch(Actor Other)
	{
		AssociatedActor.UnTouch(Other);
		return;
	}

	function BeginState()
	{
		local Actor A;

		foreach TouchingActors(Class'Engine.Actor', A)
		{
			Touch(A);
		}
		return;
	}
	stop;
}

defaultproperties
{
	LocationName="unspecified"
	bSkipActorPropertyReplication=true
	bCollideActors=true
}