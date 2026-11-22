class FluidVolume extends PhysicsVolume
	native
	config
	notplaceable
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var(SurfaceTexturing) editinlineuse Cubemap ReflectionMap;
var(SurfaceColor) byte Transparency;
var(SurfaceColor) Color BaseColor;
var(SurfaceColor) Color TangentColor;
var(SurfaceColor) Color ReflectionModulator;
var(SurfaceWaves) float SubdivisionSize;
var(SurfaceWaves) byte EdgePolyBuffer;
var(SurfaceWaves) float WaveHeightScaler;
var(SurfaceWaves) float WaveSpeedScaler;
var(SurfaceWaves) editinlineuse FluidSurfaceParamaters SurfaceParamaters;
var(SurfaceRipples) editinlineuse Texture NormalMap;
var(SurfaceRipples) float RippleScale;
var(SurfaceRipples) byte RippleStrength;
var(SurfaceRipples) Vector RippleSpeed;
var(SurfaceLowDetail) editinlineuse Texture Texture;
var(SurfaceLowDetail) float TextureScale;
var(SurfaceLowDetail) Vector TextureSpeed;
var private const noexport transient int Interface;

simulated event ActorEnteredVolume(Actor Other)
{
	Other.TriggerEffectEvent('WaterEnter', none, none, Other.Location, Rotator(Other.Velocity));
	return;
}

simulated event ActorLeavingVolume(Actor Other)
{
	Other.TriggerEffectEvent('WaterLeave', none, none, Other.Location, Rotator(Other.Velocity));
	return;
}

defaultproperties
{
	Transparency=127
	BaseColor=(R=0,G=100,B=255,A=0)
	TangentColor=(R=0,G=150,B=200,A=0)
	ReflectionModulator=(R=128,G=128,B=128,A=128)
	SubdivisionSize=512.0000000
	WaveHeightScaler=0.5000000
	WaveSpeedScaler=1.0000000
	RippleScale=2048.0000000
	RippleStrength=100
	RippleSpeed=(X=3.0000000,Y=3.0000000,Z=0.0000000)
	TextureScale=512.0000000
	TextureSpeed=(X=20.0000000,Y=20.0000000,Z=0.0000000)
	FluidFriction=0.4500000
	bWaterVolume=true
	KBuoyancy=0.9000000
	DrawType=13
	bAcceptsProjectors=false
	bUnlit=true
}