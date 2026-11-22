class AnimEditProps extends MeshObject
	native
	hidecategories(Object);

cpptext
{
	void PostEditChange();

}

var const int WBrowserAnimationPtr;
var(Compression) float GlobalCompression;
var(Compression) MeshObject.EAnimCompressMethod CompressionMethod;

defaultproperties
{
	GlobalCompression=1.0000000
}