class SoundMarkerBase extends Actor
	abstract
	native
	config
	notplaceable
	hidecategories(Karma);

var private bool QueuedTillStartup;
var private bool GameStarted;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	RegisterNotifyGameStarted();
	return;
}

simulated function OnGameStarted()
{
	GameStarted = true;
	if(QueuedTillStartup)
	{
		Log(Concat_StrStr("Sound is queued and played in ", string(self)));
		PlayEffects();
	}
	return;
}

simulated event Touch(Actor Other)
{
	super.Touch(Other);
	if(AndAnd_BoolBool(Other.IsA('Pawn'), Pawn(Other).IsPlayerPawn()))
	{
		if(GameStarted)
		{
			PlayEffects();
		}
		else
		{
			QueuedTillStartup = true;
		}
	}
	return;
}

simulated function PlayEffects()
{
	return;
}

defaultproperties
{
	bHidden=true
	bNoDelete=true
	bStasis=true
	bAlwaysRelevant=true
	RemoteRole=0
	Texture=Texture'IGEffectsSystem_EditorTextures.SoundEffectsSubsystem.SoundMarker'
	bCollideActors=true
	bBlockZeroExtentTraces=false
}