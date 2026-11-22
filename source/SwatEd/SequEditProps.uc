class SequEditProps extends MeshObject
	native
	hidecategories(Object);

cpptext
{
	void PostEditChange();

}

var const int WBrowserAnimationPtr;
var(SequenceProperties) float Rate;
var(SequenceProperties) float Compression;
var(SequenceProperties) MeshObject.EAnimCompressMethod ReCompressionMethod;
var(SequenceProperties) name SequenceName;
var(Groups) array<name> Groups;

defaultproperties
{
	Compression=1.0000000
}