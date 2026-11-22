class SpawnableEmitter extends Emitter
	native
	config
	placeable
	hidecategories(Karma);

cpptext
{
    void CheckForErrors();

}

defaultproperties
{
	AutoDestroy=true
	bNoDelete=false
}