class StingCameraEffect extends SwatCameraEffect
	native
	noexport;

var private byte BlurAlpha;
var private const transient int RenderTargets[3];
var private transient float LastFrameTime;
var private float FadeInTime;
var private float FadeOutTime;
var private float DoubleVisionTime;
var private float DoubleVisionFadeOutTime;
var private bool bBlurTime;
var private int PassOneDivide;
var private int PassTwoDivide;
var private float MaxBlurFrameTime;
var private SwatGamePlayerController PlayerController;
var private const transient int noise;
var private float ZoomInFraction;
var private float NoiseAmplitude;
var private float NoiseRate;
var private float DoubleVisionNoiseAmplitude;
var private float DoubleVisionNoiseRate;
var private Plane TintColor;
var private float TintTime;
var private float TintFadeOutTime;
var string StingGrenadeParamsClassName;
var private Class<StingEffectParams> StingGrenadeParamsClass;
var string LessLethalShotgunParamsClassName;
var private Class<StingEffectParams> LessLethalShotgunParamsClass;
var private const transient float StartTime;
var private const transient float Duration;
var private transient float EffectAlpha;
var private transient float DoubleVisionAlpha;
var private transient float TintAlpha;

function Initialize(SwatGamePlayerController inPlayerController)
{
	local Object pClass;

	pClass = DynamicLoadObject(StingGrenadeParamsClassName, Class'Core.Class');
	assert(NotEqual_ObjectObject(pClass, none));
	StingGrenadeParamsClass = Class<StingEffectParams>(pClass);
	pClass = DynamicLoadObject(LessLethalShotgunParamsClassName, Class'Core.Class');
	assert(NotEqual_ObjectObject(pClass, none));
	LessLethalShotgunParamsClass = Class<StingEffectParams>(pClass);
	PlayerController = inPlayerController;
	return;
}

function OnAdded()
{
	local Class<StingEffectParams> ParamsClass;

	assert(NotEqual_ObjectObject(StingGrenadeParamsClass, none));
	assert(NotEqual_ObjectObject(LessLethalShotgunParamsClass, none));
	assert(NotEqual_ObjectObject(PlayerController, none));
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerController, none), NotEqual_ObjectObject(SwatPlayer(PlayerController.ViewTarget), none)), EqualEqual_IntInt(int(SwatPlayer(PlayerController.ViewTarget).LastStingWeapon), int(1))))
	{
		ParamsClass = LessLethalShotgunParamsClass;
	}
	else
	{
		ParamsClass = StingGrenadeParamsClass;
	}
	BlurAlpha = ParamsClass.default.BlurAlpha;
	FadeInTime = ParamsClass.default.FadeInTime;
	FadeOutTime = ParamsClass.default.FadeOutTime;
	DoubleVisionTime = ParamsClass.default.DoubleVisionTime;
	DoubleVisionFadeOutTime = ParamsClass.default.DoubleVisionFadeOutTime;
	bBlurTime = ParamsClass.default.bBlurTime;
	PassOneDivide = ParamsClass.default.PassOneDivide;
	PassTwoDivide = ParamsClass.default.PassTwoDivide;
	MaxBlurFrameTime = ParamsClass.default.MaxBlurFrameTime;
	ZoomInFraction = ParamsClass.default.ZoomInFraction;
	NoiseAmplitude = ParamsClass.default.NoiseAmplitude;
	NoiseRate = ParamsClass.default.NoiseRate;
	DoubleVisionNoiseAmplitude = ParamsClass.default.DoubleVisionNoiseAmplitude;
	DoubleVisionNoiseRate = ParamsClass.default.DoubleVisionNoiseRate;
	TintColor = ParamsClass.default.TintColor;
	TintTime = ParamsClass.default.TintTime;
	TintFadeOutTime = ParamsClass.default.TintFadeOutTime;
	if(Greater_FloatFloat(PlayerController.Level.TimeSeconds, Add_FloatFloat(StartTime, Duration)))
	{
		LastFrameTime = PlayerController.Level.TimeSeconds;
	}
	return;
}

defaultproperties
{
	BlurAlpha=20
	FadeInTime=0.2000000
	FadeOutTime=2.5000000
	DoubleVisionTime=2.5000000
	DoubleVisionFadeOutTime=0.5000000
	bBlurTime=true
	PassOneDivide=2
	PassTwoDivide=2
	MaxBlurFrameTime=2.0000000
	ZoomInFraction=0.1000000
	NoiseAmplitude=0.1000000
	NoiseRate=1.0000000
	DoubleVisionNoiseAmplitude=0.2500000
	DoubleVisionNoiseRate=2.2000000
	TintColor=(W=1.0000000,X=1.0000000,Y=0.8000000,Z=0.5000000)
	TintTime=0.5000000
	TintFadeOutTime=0.2500000
	StingGrenadeParamsClassName="SwatCameraEffects.DesignerStingParams"
	LessLethalShotgunParamsClassName="SwatCameraEffects.DesignerLessLethalSGParams"
}