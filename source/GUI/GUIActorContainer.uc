class GUIActorContainer extends GUIActorContainerBase
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

var(GUIActor) config Class<Actor> actorClass "The actual class of the actor to spawn for this container";
var(GUIActor) config float ScaleFactor "The size offset for this Actor";
var(GUIActor) config StaticMesh StaticMesh "StaticMesh if DrawType=DT_StaticMesh";
var(GUIActor) config Mesh Mesh "Mesh if DrawType=DT_Mesh.";
var(GUIActor) config float DrawScale "Scaling factor, 1.0=normal size.";
var(GUIActor) config Vector DrawScale3D "Scaling vector, (1.0,1.0,1.0)=normal size.";
var(GUIActor) config array<Material> Skins "Multiple skin support - not replicated.";
var(GUIActor) config bool bUnlit "Lights don't affect actor.";
var(GUIActor) config Rotator RotationRate "Change in rotation per second.";
var(GUIActor) config bool bHighDetail "Only show up in high or super high detail mode.";
var(GUIActor) config bool bSuperHighDetail "Only show up in super high detail mode.";

function SpawnActor()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Actor, none), EqualEqual_ObjectObject(Actor.Class, actorClass)), EqualEqual_NameName(Actor.Tag, ActorName)))
	{
		return;
	}
	Actor = PlayerOwner().Spawn(actorClass,, ActorName);
	Actor.bHidden = false;
	return;
}

event OnModify()
{
	if(EqualEqual_ObjectObject(Actor, none))
	{
		return;
	}
	Actor.Skins = Skins;
	Actor.bUnlit = bUnlit;
	Actor.RotationRate = RotationRate;
	Actor.bHighDetail = bHighDetail;
	Actor.bSuperHighDetail = bSuperHighDetail;
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Actor.Mesh, Mesh), NotEqual_ObjectObject(Mesh, none)))
	{
		Actor.LinkMesh(Mesh);
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Actor.StaticMesh, StaticMesh), NotEqual_ObjectObject(StaticMesh, none)))
	{
		Actor.SetStaticMesh(StaticMesh);
	}
	super.OnModify();
	return;
}

protected function PositionActor()
{
	local float extraSize;

	extraSize = 1.0000000;
	Controller.SizeOfControl(self, extraSize);
	MultiplyEqual_FloatFloat(extraSize, ScaleFactor);
	Actor.SetDrawScale(Multiply_FloatFloat(Actor.default.DrawScale, extraSize));
	Actor.SetDrawScale3D(Multiply_VectorFloat(Actor.default.DrawScale3D, extraSize));
	super.PositionActor();
	return;
}

defaultproperties
{
	ScaleFactor=3.5000000
	OnDraw=GUIActorContainer.InternalOnDraw
}