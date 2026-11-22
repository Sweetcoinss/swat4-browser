class ShadowBitmapMaterial extends BitmapMaterial
	native
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual void Destroy();

	virtual FBaseTexture* GetRenderInterface();
	virtual UBitmapMaterial* Get(FTime Time,UViewport* Viewport);
#if IG_SHARED	// rowan: GetShadowLocation, needed for shadow projector culling
	FVector	GetShadowLocation();
#endif

#if IG_DYNAMIC_SHADOW_DETAIL	// rowan: native change shadow resolution
	void SetResolution(INT Resolution);
#endif

}

var const transient int TextureInterfaces[2];
var Actor ShadowActor;
var Vector LightDirection;
var float LightDistance;
var float LightFOV;
var bool Dirty;
var bool Invalid;
var bool bDebugShadow;
var bool bBlobShadow;
var float CullDistance;
var byte ShadowDarkness;
var BitmapMaterial BlobShadow;

// Export UShadowBitmapMaterial::execGetShadowLocation(FFrame&, void* const)
native final function Vector GetShadowLocation();

// Export UShadowBitmapMaterial::execSetResolution(FFrame&, void* const)
native final function SetResolution(int Resolution);

defaultproperties
{
	Dirty=true
	ShadowDarkness=255
	BlobShadow=Texture'Engine_res.BlobTexture'
	Format=5
	UClampMode=2
	VClampMode=2
	UBits=7
	VBits=7
	USize=128
	VSize=128
	UClamp=128
	VClamp=128
	BorderColor=(R=128,G=128,B=128,A=255)
	MaterialType=37
}