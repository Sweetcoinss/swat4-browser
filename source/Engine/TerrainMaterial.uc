class TerrainMaterial extends RenderedMaterial
	native
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual UMaterial* CheckFallback();
	virtual UBOOL HasFallback();

}

struct native TerrainMaterialLayer
{
	var Material Texture;
	var BitmapMaterial AlphaWeight;
	var Matrix TextureMatrix;
};

var const array<TerrainMaterialLayer> Layers;
var const Texture MacroTexture;
var const Matrix MacroTextureTransform;
var const bool ForceFogOverride;
var const byte RenderMethod;
var const bool FirstPass;

defaultproperties
{
	MaterialType=27
}