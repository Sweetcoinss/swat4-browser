class FlashbangCameraEffect extends SwatCameraEffect
	native
	noexport;

var private float RetinaImageDuration;
var private float FlashWhiteDuration;
var private float FlashFadeDuration;
var private float FlashInsetAmount;
var private float RetinaEaseIn;
var private float RetinaEaseOut;
var private float FlashEaseIn;
var private float FlashEaseOut;
var private float FlashInsetEaseIn;
var private float FlashInsetEaseOut;
var private Shader RetinaImage;
var ScriptedTexture frame;
var private Texture Flash;
var SwatGamePlayerController PlayerController;
var string ParamsClassName;
var private Class<FlashbangEffectParams> ParamsClass;

function Initialize(SwatGamePlayerController inPlayerController)
{
	local Object pClass;

	pClass = DynamicLoadObject(ParamsClassName, Class'Core.Class');
	assert(NotEqual_ObjectObject(pClass, none));
	ParamsClass = Class<FlashbangEffectParams>(pClass);
	PlayerController = inPlayerController;
	return;
}

function OnAdded()
{
	AssertWithDescription(NotEqual_ObjectObject(ParamsClass, none), "[henry] FlashbangCameraEffect::OnAdded ParamsClass is None.");
	if(NotEqual_ObjectObject(ParamsClass, none))
	{
		RetinaImageDuration = ParamsClass.default.RetinaImageDuration;
		FlashWhiteDuration = ParamsClass.default.FlashWhiteDuration;
		FlashFadeDuration = ParamsClass.default.FlashFadeDuration;
		FlashInsetAmount = ParamsClass.default.FlashInsetAmount;
		RetinaEaseIn = ParamsClass.default.RetinaEaseIn;
		RetinaEaseOut = ParamsClass.default.RetinaEaseOut;
		FlashEaseIn = ParamsClass.default.FlashEaseIn;
		FlashEaseOut = ParamsClass.default.FlashEaseOut;
		FlashInsetEaseIn = ParamsClass.default.FlashInsetEaseIn;
		FlashInsetEaseOut = ParamsClass.default.FlashInsetEaseOut;
		RetinaImage = ParamsClass.default.RetinaImage;
		Flash = ParamsClass.default.Flash;
	}
	AssertWithDescription(NotEqual_ObjectObject(Flash, none), "[henry] FlashbangCameraEffect::OnAdded() Flash is None.");
	AssertWithDescription(NotEqual_ObjectObject(RetinaImage, none), "[henry] FlashbangCameraEffect::OnAdded() RetinaImage is None.");
	frame = ScriptedTexture(Combiner(RetinaImage.Diffuse).Material1);
	AssertWithDescription(NotEqual_ObjectObject(frame, none), "[henry] FlashbangCameraEffect::OnAdded() RetinaImage.Diffuse.Material1 is not a ScriptedTexture.");
	if(OrOr_BoolBool(NotEqual_IntInt(frame.USize, PlayerController.FlashbangRetinaImageTextureWidth), NotEqual_IntInt(frame.VSize, PlayerController.FlashbangRetinaImageTextureHeight)))
	{
		frame.SetSize(PlayerController.FlashbangRetinaImageTextureWidth, PlayerController.FlashbangRetinaImageTextureHeight);
	}
	frame.Client = PlayerController;
	AddAdd_Int(frame.Revision);
	return;
}

defaultproperties
{
	RetinaImageDuration=6.0000000
	FlashWhiteDuration=0.5000000
	FlashFadeDuration=3.0000000
	FlashInsetAmount=0.2000000
	RetinaEaseIn=3.0000000
	RetinaEaseOut=1.0000000
	FlashEaseIn=2.0000000
	FlashEaseOut=1.0000000
	FlashInsetEaseIn=1.7000000
	FlashInsetEaseOut=2.0000000
	RetinaImage=Shader'CameraEffectsTex.FlashbangCameraEffects.RetinaImage'
	Flash=Texture'CameraEffectsTex.FlashbangCameraEffects.Flash'
	ParamsClassName="SwatCameraEffects.DesignerFlashbangParams"
}