class ZoneInfo extends Info
	native
	config
	placeable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

enum EFogType
{
	FG_Linear,                      // 0
	FG_Exponential                  // 1
};

var SkyZoneInfo SkyZone;
var name ZoneTag;
var localized string LocationName;
var float KillZ;
var Actor.eKillZType KillZType;
var bool bSoftKillZ;
var bool bTerrainZone;
var bool bDistanceFog;
var bool bClearToFogColor;
var const array<TerrainInfo> Terrains;
var bool bUseFlashlight "When set to true, AI Officers will turn on their flashlight when they enter this zone";
var Vector AmbientVector;
var(ZoneLight) byte AmbientBrightness;
var(ZoneLight) byte AmbientHue;
var(ZoneLight) byte AmbientSaturation;
var(ZoneLight) float AmbientXGroundRatio;
var(ZoneLight) Color DistanceFogColor;
var(ZoneLight) float DistanceFogStart;
var(ZoneLight) float DistanceFogEnd;
var(ZoneLight) float DistanceFogBlendTime;
var(ZoneLight) ZoneInfo.EFogType DistanceFogType;
var(ZoneLight) float DistanceFogExpBias;
var(ZoneLight) float DistanceFogClipBias;
var bool bClipToDistanceFog;
var(ZoneLight) const Texture EnvironmentMap;
var(ZoneLight) float TexUPanSpeed;
var(ZoneLight) float TexVPanSpeed;
var(ZoneSound) editinline I3DL2Listener ZoneEffect;
var(ZoneVisibility) bool bLonelyZone;
var(ZoneVisibility) editinline array<editinline ZoneInfo> ManualExcludes;
var array<NavigationPoint> ZonePropagationNodes;
var name ZoneSoundTag "Zones with the same ZoneSoundTag are linked, and treated as one giant zone for sound propagation purposes";
var array<name> EffectsContexts;

// Export UZoneInfo::execZoneActors(FFrame&, void* const)
native(308) final iterator function ZoneActors(Class<Actor> BaseClass, out Actor Actor);

simulated function LinkToSkybox()
{
	local SkyZoneInfo TempSkyZone;

	foreach AllActors(Class'Engine.SkyZoneInfo', TempSkyZone, 'None')
	{
		SkyZone = TempSkyZone;
	}
	if(EqualEqual_IntInt(int(Level.DetailMode), int(0)))
	{
		foreach AllActors(Class'Engine.SkyZoneInfo', TempSkyZone, 'None')
		{
			if(AndAnd_BoolBool(Not_PreBool(TempSkyZone.bHighDetail), Not_PreBool(TempSkyZone.bSuperHighDetail)))
			{
				SkyZone = TempSkyZone;
			}
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(Level.DetailMode), int(1)))
		{
			foreach AllActors(Class'Engine.SkyZoneInfo', TempSkyZone, 'None')
			{
				if(Not_PreBool(TempSkyZone.bSuperHighDetail))
				{
					SkyZone = TempSkyZone;
				}
			}
		}
		else
		{
			if(EqualEqual_IntInt(int(Level.DetailMode), int(2)))
			{
				foreach AllActors(Class'Engine.SkyZoneInfo', TempSkyZone, 'None')
				{
					SkyZone = TempSkyZone;
				}
			}
		}
	}
	return;
}

simulated function PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	LinkToSkybox();
	return;
}

event ActorEntered(Actor Other)
{
	if(NotEqual_ObjectObject(Pawn(Other), none))
	{
		Pawn(Other).EnteredZone(self);
	}
	return;
}

event ActorLeaving(Actor Other)
{
	if(NotEqual_ObjectObject(Pawn(Other), none))
	{
		Pawn(Other).LeftZone(self);
	}
	return;
}

defaultproperties
{
	KillZ=-10000.0000000
	AmbientSaturation=255
	AmbientXGroundRatio=0.3000000
	DistanceFogColor=(R=128,G=128,B=128,A=0)
	DistanceFogStart=3000.0000000
	DistanceFogEnd=8000.0000000
	DistanceFogBlendTime=1.0000000
	DistanceFogExpBias=1.0000000
	DistanceFogClipBias=1.0000000
	TexUPanSpeed=1.0000000
	TexVPanSpeed=1.0000000
	bStatic=true
	bNoDelete=true
	Texture=Texture'Engine_res.S_ZoneInfo'
}