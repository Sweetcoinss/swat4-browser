class DesaturateMaterial extends Material
	native
	collapsecategories
	noexport
	hidecategories(Object);

var BitmapMaterial SourceBitmap;
var Vector GreyColorChooser;
var Vector GreyWeight;
var FinalBlend.EFrameBufferBlending Blending;

defaultproperties
{
	GreyColorChooser=(X=0.3000000,Y=0.6000000,Z=0.1000000)
	GreyWeight=(X=0.7000000,Y=0.7000000,Z=0.7000000)
}