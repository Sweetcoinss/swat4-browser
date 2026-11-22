class MusicTrigger extends Triggers
	config
	placeable
	hidecategories(Karma);

var string Song;
var float FadeInTime;
var float FadeOutTime;
var bool FadeOutAllSongs;
var transient bool Triggered;
var transient int SongHandle;

function Trigger(Actor Other, Pawn EventInstigator)
{
	if(Not_PreBool(Triggered))
	{
		Triggered = true;
		if(FadeOutAllSongs)
		{
			StopAllMusic(FadeOutTime);
		}
		SongHandle = PlayMusic(Song, FadeInTime);
	}
	else
	{
		Triggered = false;
		if(NotEqual_IntInt(SongHandle, 0))
		{
			StopMusic(SongHandle, FadeOutTime);
		}
		else
		{
			Log("WARNING: invalid song handle");
		}
	}
	return;
}

defaultproperties
{
	bCollideActors=false
}