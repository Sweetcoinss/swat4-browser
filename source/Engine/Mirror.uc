class Mirror extends Actor
	native
	config
	placeable
	hidecategories(Karma,Advanced,Mirrors,Events,Force,Karma,Havok,LightColor,Lighting,Movement,Object,Sound);

cpptext
{
	virtual void CheckForErrors();
    virtual void PostEditAdd(GroupFactory& Grouper);
	virtual void PostEditChange();
	virtual void PostEditLoad();

    static void SetMirrorsEnabled(UBOOL Enabled); // turn realtime mirrors on/off globally
    static UBOOL GetMirrorsEnabled();

  private:
    static UBOOL bMirrorsEnabled;

}

var /*0x00000000-0x00080000*/ private MirrorCamera MyCamera;
var int MirrorSkinIndex "This is the Skin array index that the mirror texture will override.";
var private string DefaultMirrorMaterialString "This is the Package.Name of the material that is used when mirrors are disabled";
var private Material DefaultMirrorMaterial;

// Export UMirror::execSetMirrorsEnabled(FFrame&, void* const)
native static function SetMirrorsEnabled(bool bInMirrorsEnabled);

// Export UMirror::execInitialize(FFrame&, void* const)
native function Initialize();

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	AssertWithDescription(NotEqual_ObjectObject(MyCamera, none), Concat_StrStr(Concat_StrStr("Error: MyCamera is none for ", string(self)), ".  This is either an old instance of the mirror, or someone deleted the MirrorCamera that was auto-created when this Mirror was placed has been deleted. Please delete this Mirror, and place a new one."));
	Initialize();
	MyCamera.OwnerMirror = self;
	return;
}

defaultproperties
{
	DefaultMirrorMaterialString="Repo_Tex.repo_catwalk_cubemap_env"
	bIsMirror=true
	DrawType=8
	StaticMesh=StaticMesh'Hotel_sm.hot_medicinecabinet'
	bNoDelete=true
	bWorldGeometry=true
	RemoteRole=0
	bShadowCast=true
	CollisionRadius=1.0000000
	CollisionHeight=30.0000000
	bCollideActors=true
	bBlockActors=true
	bBlockPlayers=true
	bBlockKarma=true
	bEdShouldSnap=true
}