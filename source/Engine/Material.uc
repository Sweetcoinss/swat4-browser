class Material extends Object
	native
	collapsecategories
	noexport
	hidecategories(Object);

enum EMaterialType
{
	MT_Material,                    // 0
	MT_Combiner,                    // 1
	MT_GlowMaterial,                // 2
	MT_BlurMaterial,                // 3
	MT_ModifierStart,               // 4
	MT_Modifier,                    // 5
	MT_ColorModifier,               // 6
	MT_FinalBlend,                  // 7
	MT_MaterialSequence,            // 8
	MT_MaterialSwitch,              // 9
	MT_OpacityModifier,             // 10
	MT_TexModifierStart,            // 11
	MT_TexModifier,                 // 12
	MT_TexCoordSource,              // 13
	MT_TexEnvMap,                   // 14
	MT_TexMatrix,                   // 15
	MT_TexOscillator,               // 16
	MT_TexPanner,                   // 17
	MT_TexRotator,                  // 18
	MT_TexScaler,                   // 19
	MT_TexModifierEnd,              // 20
	MT_ModifierEnd,                 // 21
	MT_RenderedMaterialStart,       // 22
	MT_RenderedMaterial,            // 23
	MT_Shader,                      // 24
	MT_ProjectorMaterial,           // 25
	MT_ParticleMaterial,            // 26
	MT_TerrainMaterial,             // 27
	MT_VertexColor,                 // 28
	MT_ConstantMaterialStart,       // 29
	MT_ConstantMaterial,            // 30
	MT_ConstantColor,               // 31
	MT_FadeColor,                   // 32
	MT_ConstantMaterialEnd,         // 33
	MT_BitmapMaterialStart,         // 34
	MT_BitmapMaterial,              // 35
	MT_ScriptedTexture,             // 36
	MT_ShadowBitmapMaterial,        // 37
	MT_TextureStart,                // 38
	MT_Texture,                     // 39
	MT_Cubemap,                     // 40
	MT_TextureEnd,                  // 41
	MT_BitmapMaterialEnd,           // 42
	MT_RenderedMaterialEnd,         // 43
	MT_DesaturateMaterial           // 44
};

enum EMaterialVisualType
{
	MVT_Default,                    // 0
	MVT_Concrete,                   // 1
	MVT_Stone,                      // 2
	MVT_ThinGlass,                  // 3
	MVT_ThickGlass,                 // 4
	MVT_ThinCloth,                  // 5
	MVT_ThickCloth,                 // 6
	MVT_ThinMetal,                  // 7
	MVT_ThickMetal,                 // 8
	MVT_Wood,                       // 9
	MVT_Plastic,                    // 10
	MVT_Cardboard,                  // 11
	MVT_Plaster,                    // 12
	MVT_Water,                      // 13
	MVT_Flesh,                      // 14
	MVT_Carpet,                     // 15
	MVT_Dirt,                       // 16
	MVT_WaterPipe,                  // 17
	MVT_Plant,                      // 18
	MVT_RedBrick,                   // 19
	MVT_OpaqueGlass,                // 20
	MVT_MetalGrate,                 // 21
	MVT_Mirror,                     // 22
	MVT_Roaches,                    // 23
	MVT_WoodDebris,                 // 24
	MVT_WoodCharred,                // 25
	MVT_SteamPipe,                  // 26
	MVT_Sky,                        // 27
	MVT_Electronics                 // 28
};

var Material FallbackMaterial;
var Material DefaultMaterial;
var const transient bool UseFallback;
var const transient bool Validated;
var const Material.EMaterialType MaterialType;
var(MaterialType) int MaterialSoundType;
var(MaterialType) Material.EMaterialVisualType MaterialVisualType;
var(Ballistics) float MomentumToPenetrate "A bullet will penetrate this material if-and-only-if it impacts with more than this Momentum.  A bullet's Momentum is its Mass times the MuzzleVelocity of the FiredWeapon from which it was fired, minus any Momentum that the bullet has already lost (due to prior impact(s)).  The bullet will impart 10% of its Momentum to a KActor it hits if it penetrates the KActor, or 100% of its Momentum if it doesn't penetrate the KActor.";

function Reset()
{
	if(NotEqual_ObjectObject(FallbackMaterial, none))
	{
		FallbackMaterial.Reset();
	}
	return;
}

function Trigger(Actor Other, Actor EventInstigator)
{
	if(NotEqual_ObjectObject(FallbackMaterial, none))
	{
		FallbackMaterial.Trigger(Other, EventInstigator);
	}
	return;
}

defaultproperties
{
	DefaultMaterial=Texture'Engine_res.DefaultTexture'
	MomentumToPenetrate=10000.0000000
}