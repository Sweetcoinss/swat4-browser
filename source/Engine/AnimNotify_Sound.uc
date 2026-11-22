class AnimNotify_Sound extends AnimNotify
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

cpptext
{
	// AnimNotify interface.
	virtual void Notify( UMeshInstance *Instance, AActor *Owner );

}

var Sound Sound;
var float Volume;
var int Radius;

defaultproperties
{
	Volume=1.0000000
}