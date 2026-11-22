class GUIActorContainerBase extends GUIComponent
	abstract
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
    virtual void Modify() { eventOnModify(); Super::Modify(); } //callback from the object browser

}

var(GUIActor) config name ActorName "The Name of the actor to spawn for this container (will load from the config section corresponding to this name && trigger any scripted sequences based off this name)";
var(GUIActor) editconst editinline Actor Actor "The actor that this container refers to";
var(GUIActor) config Vector Offset "The positional offset for this Actor";
var(GUIActor) config Rotator Rotation "Rotation.";
var(GUIActor) config Actor.EDrawType DrawType;
var(GUIActor) config Material Texture "Sprite texture.if DrawType=DT_Sprite";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function SpawnActor()
{
	return;
}

event Show()
{
	SpawnActor();
	OnModify();
	super.Show();
	return;
}

event Hide()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Actor, none), Not_PreBool(Actor.bDeleteMe)))
	{
		Actor.Destroy();
		Actor = none;
	}
	super.Hide();
	return;
}

function bool InternalOnDraw(Canvas Canvas)
{
	Canvas.DrawActor(Actor, false, true, PlayerOwner().FovAngle);
	return true;
	return;
}

event OnChangeLayout()
{
	PositionActor();
	super.OnChangeLayout();
	return;
}

protected function PositionActor()
{
	local float extraOffY, extraOffZ, translatedX, translatedY, translatedZ;

	local Vector CamPos, X, Y, Z;
	local Rotator CamRot;

	if(EqualEqual_ObjectObject(Actor, none))
	{
		return;
	}
	translatedX = Offset.X;
	translatedY = Offset.Y;
	translatedZ = Offset.Z;
	Controller.CenterOfControl(self, extraOffY, extraOffZ);
	AddEqual_FloatFloat(translatedY, extraOffY);
	AddEqual_FloatFloat(translatedZ, extraOffZ);
	translatedY = Multiply_FloatFloat(Divide_FloatFloat(Subtract_FloatFloat(translatedY, float(Divide_IntInt(Controller.ResolutionX, 2))), float(Controller.ResolutionX)), Controller.GUI_TO_WORLD_X);
	translatedZ = Multiply_FloatFloat(Divide_FloatFloat(Subtract_FloatFloat(float(Divide_IntInt(Controller.ResolutionY, 2)), translatedZ), float(Controller.ResolutionY)), Controller.GUI_TO_WORLD_Y);
	CamRot = PlayerOwner().Rotation;
	CamPos = PlayerOwner().Location;
	GetAxes(CamRot, X, Y, Z);
	Actor.SetLocation(Add_VectorVector(CamPos, Add_VectorVector(Add_VectorVector(Multiply_FloatVector(translatedX, X), Multiply_FloatVector(translatedY, Y)), Multiply_FloatVector(translatedZ, Z))));
	return;
}

event OnModify()
{
	if(EqualEqual_ObjectObject(Actor, none))
	{
		return;
	}
	Actor.Texture = Texture;
	if(NotEqual_RotatorRotator(Actor.Rotation, Rotation))
	{
		Actor.SetRotation(Rotation);
	}
	if(NotEqual_IntInt(int(Actor.DrawType), int(DrawType)))
	{
		Actor.SetDrawType(DrawType);
	}
	PositionActor();
	return;
}

function SaveLayout(bool FlushToDisk)
{
	super.SaveLayout(FlushToDisk);
	return;
}

defaultproperties
{
	Offset=(X=80.0000000,Y=0.0000000,Z=0.0000000)
	bAcceptsInput=false
	bNeverFocus=true
}