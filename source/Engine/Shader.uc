class Shader extends RenderedMaterial
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

enum EPerPixelSpecular
{
	PP_None,                        // 0
	PP_Low,                         // 1
	PP_Medium,                      // 2
	PP_High                         // 3
};

enum EPerPixelSpecularType
{
	ST_AlgorithmicRV,               // 0
	ST_AlgorithmicNH                // 1
};

enum EOutputBlending
{
	OB_Normal,                      // 0
	OB_Masked,                      // 1
	OB_Modulate,                    // 2
	OB_Translucent,                 // 3
	OB_Invisible,                   // 4
	OB_Brighten,                    // 5
	OB_Darken,                      // 6
	OB_Feathered,                   // 7
	OB_AdditiveFade                 // 8
};

var editinlineuse Material Diffuse;
var editinlineuse Material Opacity;
var editinlineuse Material NormalMap;
var editinlineuse Cubemap PerPixelReflection;
var editinlineuse Material PerPixelReflectionMask;
var Shader.EPerPixelSpecular PerPixelSpecular;
var Shader.EPerPixelSpecularType PerPixelSpecularType;
var byte PerPixelSpecularBrightness;
var editinlineuse Material Specular;
var editinlineuse Material SpecularityMask;
var editinlineuse Material SelfIllumination;
var editinlineuse Material SelfIlluminationMask;
var byte GlowBrightness;
var editinlineuse Material GlowMapOverride;
var editinlineuse Material GlowMaskOverride;
var editinlineuse Material Detail;
var float DetailScale;
var Shader.EOutputBlending OutputBlending;
var(ShaderLOD) bool bAllowSelfIlluminationLOD;
var bool TwoSided;
var bool Wireframe;
var bool ModulateStaticLighting2X;
var bool PerformLightingOnSpecularPass;

function Reset()
{
	if(NotEqual_ObjectObject(Diffuse, none))
	{
		Diffuse.Reset();
	}
	if(NotEqual_ObjectObject(Opacity, none))
	{
		Opacity.Reset();
	}
	if(NotEqual_ObjectObject(Specular, none))
	{
		Specular.Reset();
	}
	if(NotEqual_ObjectObject(SpecularityMask, none))
	{
		SpecularityMask.Reset();
	}
	if(NotEqual_ObjectObject(SelfIllumination, none))
	{
		SelfIllumination.Reset();
	}
	if(NotEqual_ObjectObject(SelfIlluminationMask, none))
	{
		SelfIlluminationMask.Reset();
	}
	if(NotEqual_ObjectObject(FallbackMaterial, none))
	{
		FallbackMaterial.Reset();
	}
	return;
}

function Trigger(Actor Other, Actor EventInstigator)
{
	if(NotEqual_ObjectObject(Diffuse, none))
	{
		Diffuse.Trigger(Other, EventInstigator);
	}
	if(NotEqual_ObjectObject(Opacity, none))
	{
		Opacity.Trigger(Other, EventInstigator);
	}
	if(NotEqual_ObjectObject(Specular, none))
	{
		Specular.Trigger(Other, EventInstigator);
	}
	if(NotEqual_ObjectObject(SpecularityMask, none))
	{
		SpecularityMask.Trigger(Other, EventInstigator);
	}
	if(NotEqual_ObjectObject(SelfIllumination, none))
	{
		SelfIllumination.Trigger(Other, EventInstigator);
	}
	if(NotEqual_ObjectObject(SelfIlluminationMask, none))
	{
		SelfIlluminationMask.Trigger(Other, EventInstigator);
	}
	if(NotEqual_ObjectObject(FallbackMaterial, none))
	{
		FallbackMaterial.Trigger(Other, EventInstigator);
	}
	return;
}

defaultproperties
{
	PerPixelSpecularBrightness=90
	GlowBrightness=32
	DetailScale=8.0000000
	MaterialType=24
}