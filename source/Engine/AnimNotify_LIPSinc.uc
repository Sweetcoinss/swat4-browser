class AnimNotify_LIPSinc extends AnimNotify
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

cpptext
{
	// AnimNotify interface.
	virtual void Notify( UMeshInstance *Instance, AActor *Owner );

}

var name LIPSincAnimName;
var float Volume;
var int Radius;
var float Pitch;

defaultproperties
{
	Volume=1.0000000
	Radius=80
	Pitch=1.0000000
}