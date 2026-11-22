class PepperSprayCameraEffect extends SwatCameraEffect
	native
	noexport;

var private byte BlurAlpha;
var private const transient int RenderTargets[2];
var private transient float LastFrameTime;
var private float FadeInTime;
var private float FadeOutTime;
var private bool bBlurTime;
var private int PassOneDivide;
var private int PassTwoDivide;
var private float MaxBlurFrameTime;
var private Vector GreyColorChooser;
var private Vector GreyWeight;
var private SwatGamePlayerController PlayerController;
var private const transient int noise;
var private float ZoomInFraction;
var private float NoiseAmplitude;
var private float NoiseRate;
var string ParamsClassName;
var private Class<PepperSprayEffectParams> ParamsClass;
var private const transient float StartTime;
var private const transient float Duration;
var private const transient float EffectAlpha;

function Initialize(SwatGamePlayerController inPlayerController)
{
	local Object pClass;

	pClass = DynamicLoadObject(ParamsClassName, Class'Core.Class');
	assert(NotEqual_ObjectObject(pClass, none));
	ParamsClass = Class<PepperSprayEffectParams>(pClass);
	PlayerController = inPlayerController;
	return;
}

function OnAdded()
{
	assert(NotEqual_ObjectObject(ParamsClass, none));
	BlurAlpha = ParamsClass.default.BlurAlpha;
	FadeInTime = ParamsClass.default.FadeInTime;
	FadeOutTime = ParamsClass.default.FadeOutTime;
	bBlurTime = ParamsClass.default.bBlurTime;
	PassOneDivide = ParamsClass.default.PassOneDivide;
	PassTwoDivide = ParamsClass.default.PassTwoDivide;
	MaxBlurFrameTime = ParamsClass.default.MaxBlurFrameTime;
	GreyColorChooser = ParamsClass.default.GreyColorChooser;
	GreyWeight = ParamsClass.default.GreyWeight;
	ZoomInFraction = ParamsClass.default.ZoomInFraction;
	NoiseAmplitude = ParamsClass.default.NoiseAmplitude;
	NoiseRate = ParamsClass.default.NoiseRate;
	LastFrameTime = PlayerController.Level.TimeSeconds;
	return;
}

defaultproperties
{
	BlurAlpha=10
	FadeInTime=0.3000000
	FadeOutTime=2.5000000
	bBlurTime=true
	PassOneDivide=2
	PassTwoDivide=2
	MaxBlurFrameTime=2.0000000
	GreyColorChooser=(X=0.2000000,Y=0.6000000,Z=0.4000000)
	GreyWeight=(X=0.4000000,Y=0.7000000,Z=0.8000000)
	ZoomInFraction=0.1000000
	NoiseAmplitude=0.1000000
	NoiseRate=1.0000000
	ParamsClassName="SwatCameraEffects.DesignerPepperSprayParams"
}