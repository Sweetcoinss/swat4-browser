class SoundMarker extends SoundMarkerBase
	native
	config
	placeable
	hidecategories(Karma);

var string Schema1;
var string Schema2;

simulated function PlayEffects()
{
	SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).PlayMarkerSounds(self, Schema1, Schema2);
	return;
}
