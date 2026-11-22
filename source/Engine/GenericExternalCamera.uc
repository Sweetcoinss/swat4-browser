class GenericExternalCamera extends Actor
	native
	config
	placeable
	hidecategories(Karma,Advanced,Collision,Events,Force,Karma,LightColor,Lighting,Movement,Object,Sound);

enum EOptimizeOption
{
	OPTIMIZE_None,                  // 0
	OPTIMIZE_Radius,                // 1
	OPTIMIZE_Zone,                  // 2
	OPTIMIZE_VisibleZones           // 3
};

var ScriptedTexture CameraTexture "ScriptedTexture that this class renders into.  The ScriptedTexture can be combined with other materials for special effects.";
var int ResolutionX "The X Resolution of the desired rendered texture.  Lower resolutions are faster but more pixelated.";
var int ResolutionY "The Y Resolution of the desired rendered texture.  Lower resolutions are faster but more pixelated.";
var int OptimizedRadius "Used only if OptimizeFor is set to OPTIMIZE_Radius";
var int UpdateRate "How many times per second to update the texture";
var int FOV "The desired field of view for the rendered viewport";
var GenericExternalCamera.EOptimizeOption OptimizeFor "How to optimize this camera.  Note: OPTIMIZE_VisibleZones does nothing currently";
var bool bTimerHasElapsed;
var Timer RenderTimer;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	Initialize();
	return;
}

simulated function Initialize()
{
	CameraTexture.Client = self;
	CameraTexture.bNotifyClientBeforeRendering = true;
	CameraTexture.SetSize(ResolutionX, ResolutionY);
	AddAdd_Int(CameraTexture.Revision);
	RenderTimer = Spawn(Class'Engine.Timer');
	RenderTimer.__TimerDelegate__Delegate = OnRenderTimer;
	RenderTimer.StartTimer(Divide_FloatFloat(1.0000000, float(UpdateRate)), true, true);
	return;
}

simulated event Destroyed()
{
	if(NotEqual_ObjectObject(CameraTexture, none))
	{
		CameraTexture.Client = none;
	}
	RenderTimer.Destroy();
	super.Destroyed();
	return;
}

simulated event PreScriptedTextureRendered(ScriptedTexture Tex)
{
	if(bTimerHasElapsed)
	{
		AddAdd_Int(Tex.Revision);
		bTimerHasElapsed = false;
	}
	return;
}

simulated event RenderTexture(ScriptedTexture inTexture)
{
	inTexture.DrawPortal(0, 0, ResolutionX, ResolutionY, Level.GetLocalPlayerController(), GetViewLocation(), GetViewRotation(), FOV,, true);
	return;
}

simulated function Rotator GetViewRotation()
{
	return Rotation;
	return;
}

simulated function Vector GetViewLocation()
{
	return Location;
	return;
}

simulated function OnRenderTimer()
{
	switch(OptimizeFor)
	{
		case 1:
			if(Greater_FloatFloat(VSize(Subtract_VectorVector(Level.GetLocalPlayerController().Pawn.Location, Location)), float(OptimizedRadius)))
			{
				return;
			}
			break;
		case 2:
			if(NotEqual_ObjectObject(Level.GetLocalPlayerController().Pawn.Region.Zone, Region.Zone))
			{
				return;
			}
			break;
		default:
			break;
	}
	bTimerHasElapsed = true;
	return;
}

defaultproperties
{
	ResolutionX=256
	ResolutionY=256
	OptimizedRadius=1024
	UpdateRate=60
	FOV=90
	bHidden=true
	bNoDelete=true
	RemoteRole=0
	Texture=Texture'Engine_res.SubActionFOV'
	bDirectional=true
}