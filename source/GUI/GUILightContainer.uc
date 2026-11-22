class GUILightContainer extends GUIActorContainerBase
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

var(GUIActor) config Class<Light> actorClass "The actual class of the actor to spawn for this container";
var(GUIActor) config Actor.ELightType LightType;
var(GUIActor) config Actor.ELightEffect LightEffect;
var(GUIActor) config float LightBrightness;
var(GUIActor) config float LightRadius;
var(GUIActor) config byte LightHue;
var(GUIActor) config byte LightSaturation;
var(GUIActor) config bool bDoNotApproximateBumpmap;
var(GUIActor) config bool bSpecialLit "Only affects special-lit surfaces.";
var(GUIActor) config bool bIsSpotlight "Will act as pointlight instead";

function SpawnActor()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Actor, none), EqualEqual_ObjectObject(Actor.Class, actorClass)), EqualEqual_NameName(Actor.Tag, ActorName)))
	{
		return;
	}
	Actor = PlayerOwner().Spawn(actorClass,, ActorName);
	return;
}

event OnModify()
{
	if(EqualEqual_ObjectObject(Actor, none))
	{
		return;
	}
	Actor.bSpecialLit = bSpecialLit;
	Actor.bDoNotApproximateBumpmap = bDoNotApproximateBumpmap;
	Actor.LightHue = LightHue;
	Actor.LightSaturation = LightSaturation;
	Actor.LightRadius = LightRadius;
	Actor.LightBrightness = LightBrightness;
	Actor.LightEffect = LightEffect;
	Actor.LightType = LightType;
	Actor.bDirectional = bIsSpotlight;
	super.OnModify();
	return;
}

defaultproperties
{
	OnDraw=GUILightContainer.InternalOnDraw
}