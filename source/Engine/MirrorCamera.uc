class MirrorCamera extends GenericExternalCamera
	native
	config
	placeable
	hidecategories(Karma,Advanced,Collision,Events,Force,Karma,LightColor,Lighting,Movement,Object,Sound);

cpptext
{
    UScriptedTexture* CreateScriptedTexture( const TCHAR* BaseName );

}

var private float MirrorOffset "How much the camera is allowed to move in relation to the player's view rotation.  Larger numbers look more realistic, but can clip into geometry";
var private Shader ReferenceShader "If set, allows extra effects to be applied to the Mirror scripted texture.  A copy of the reference shader will be made, and the Diffuse material of the new shader will be set to the reflection texture for this mirror.";
var private const transient ScriptedTexture MirrorTexture;
var private const transient TexScaler MirrorScaler;
var const transient Material MirrorMaterial;
var Mirror OwnerMirror;

// Export UMirrorCamera::execInitialize(FFrame&, void* const)
native function Initialize();

// Export UMirrorCamera::execCreateNewScriptedTexture(FFrame&, void* const)
native static function ScriptedTexture CreateNewScriptedTexture(string InName);

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	RenderTimer = Spawn(Class'Engine.Timer');
	RenderTimer.__TimerDelegate__Delegate = OnRenderTimer;
	RenderTimer.StartTimer(Divide_FloatFloat(1.0000000, float(UpdateRate)), true, true);
	return;
}

simulated event Destroyed()
{
	if(NotEqual_ObjectObject(MirrorTexture, none))
	{
		MirrorTexture.Client = none;
	}
	super.Destroyed();
	return;
}

simulated function Rotator GetViewRotation()
{
	local Vector EyeLocation, ToPlayer;
	local Actor ViewActor;
	local Rotator EyeRotation, MirrorRot;

	Level.GetLocalPlayerController().PlayerCalcView(ViewActor, EyeLocation, EyeRotation);
	ToPlayer = Subtract_VectorVector(Location, EyeLocation);
	MirrorRot = Rotator(MirrorVectorByNormal(ToPlayer, Normal(Vector(Rotation))));
	MirrorRot.Roll = Rotation.Roll;
	MirrorRot.Pitch = Rotation.Pitch;
	return MirrorRot;
	return;
}

simulated function Vector GetViewLocation()
{
	return Location;
	return;
}

defaultproperties
{
	MirrorOffset=20.0000000
	FOV=85
	DrawScale=0.5000000
}