class SingleDoor extends SwatDoor
	native
	config(SwatGame)
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

const kSingleDoorWidth = 78.0;

var private bool bNoDoor "If true, the SingleDoor behaves like just a DoorWay with no model at all.  NOTE that it still needs a correct StaticMesh to indicate the doorway geometry!";
var DoorModel DoorModel;

simulated function BeginPlay()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SingleDoor::BeginPlay()."));
	}
	super(Actor).BeginPlay();
	LoadAnimationSet("SwatDoorAnimation.SwatDoorAnimationSet");
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		assert(EqualEqual_ObjectObject(DoorModel, none));
		DoorModel = Spawn(Class'SwatGame.DoorModel', self);
		assert(NotEqual_ObjectObject(DoorModel, none));
		DoorModel.Door = self;
		DoorModel.SetStaticMesh(StaticMesh);
		DoorModel.SetDrawScale3D(DrawScale3D);
		AttachToBone(DoorModel, 'DoorHinge');
	}
	if(bNoDoor)
	{
		if(NotEqual_ObjectObject(DoorModel, none))
		{
			DoorModel.bHidden = true;
			DoorModel.SetCollision(false, false, false);
			DoorModel.HavokSetBlocking(false);
			DoorModel.bBlockZeroExtentTraces = false;
			DoorModel.bBlockNonZeroExtentTraces = false;
		}
		SetCollision(false);
	}
	return;
}

simulated function Door.DoorPosition GetInitialPosition()
{
	if(bNoDoor)
	{
		return 1;
	}
	else
	{
		return super.GetInitialPosition();
	}
	return;
}

simulated function bool WasDoorInitiallyLocked()
{
	if(bNoDoor)
	{
		return false;
	}
	else
	{
		return super.WasDoorInitiallyLocked();
	}
	return;
}

simulated function PostBroken()
{
	DoorModel.SetStaticMesh(BrokenStaticMesh);
	return;
}

simulated function array<Actor> GetDoorModels()
{
	local array<Actor> DoorModels;

	DoorModels[0] = DoorModel;
	return DoorModels;
	return;
}

simulated function PlayBreachedEffects()
{
	DoorModel.TriggerEffectEvent('Breached');
	return;
}

simulated function float GetDoorwayWidth()
{
	return 78.0000000;
	return;
}

simulated function Vector GetPushAwayDirection(SwatRagdollPawn thePawn)
{
	local Vector HingeToKnob2D, HingeLocation2D, DesiredCorner2D, FarCornerLeftSide2D, FarCornerRightSide2D;

	local float InnerRadiusScaleFactor;

	HingeToKnob2D = Vector(Rotation);
	HingeToKnob2D.Z = 0.0000000;
	HingeToKnob2D = Normal(HingeToKnob2D);
	HingeLocation2D = Subtract_VectorVector(Location, Multiply_VectorFloat(HingeToKnob2D, Multiply_FloatFloat(GetDoorwayWidth(), 0.5000000)));
	HingeLocation2D.Z = 0.0000000;
	if(Less_FloatFloat(Dot_VectorVector(HingeToKnob2D, Subtract_VectorVector(thePawn.Location, HingeLocation2D)), float(0)))
	{
		return Subtract_PreVector(HingeToKnob2D);
	}
	FarCornerLeftSide2D = Add_VectorVector(HingeLocation2D, Multiply_VectorFloat(Normal(Add_VectorVector(HingeToKnob2D, Cross_VectorVector(HingeToKnob2D, vect(0.0000000, 0.0000000, 1.0000000)))), CollisionRadius));
	FarCornerRightSide2D = Add_VectorVector(HingeLocation2D, Multiply_VectorFloat(Normal(Add_VectorVector(HingeToKnob2D, Cross_VectorVector(HingeToKnob2D, vect(0.0000000, 0.0000000, -1.0000000)))), CollisionRadius));
	InnerRadiusScaleFactor = 0.6000000;
	if(AndAnd_BoolBool(PointIsOnSideThatDoorIsOpenTo(thePawn.Location), Less_FloatFloat(VSize2D(Subtract_VectorVector(HingeLocation2D, thePawn.Location)), Multiply_FloatFloat(GetDoorwayWidth(), InnerRadiusScaleFactor))))
	{
		if(OrOr_BoolBool(IsOpenLeft(), IsOpeningLeft()))
		{
			DesiredCorner2D = FarCornerRightSide2D;
		}
		else
		{
			DesiredCorner2D = FarCornerLeftSide2D;
		}
	}
	else
	{
		if(PointIsToMyLeft(thePawn.Location))
		{
			DesiredCorner2D = FarCornerLeftSide2D;
		}
		else
		{
			DesiredCorner2D = FarCornerRightSide2D;
		}
	}
	return Subtract_VectorVector(DesiredCorner2D, HingeLocation2D);
	return;
}

simulated state BeingBlasted
{
	simulated function PlayBlastedEffects()
	{
		DoorModel.TriggerEffectEvent('Blasted');
		return;
	}
	stop;
}

defaultproperties
{
	BrokenStaticMesh=StaticMesh'Doors_sm.door_door01_damaged'
	Mesh=SkeletalMesh'SWATDoorAnimation.SwatDoor'
	CollisionRadius=90.0000000
}