class DoubleDoor extends SwatDoor
	native
	config(SwatGame)
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

const kDoubleDoorWidth = 156.0;

var StaticMesh OneOfDoubleDoorsSM "The static mesh representation of one of the double doors for placement in UnrealEd, and collision";
var DoorModel LeftHingeDoorModel;
var DoorModel RightHingeDoorModel;

simulated function BeginPlay()
{
	super(Actor).BeginPlay();
	LoadAnimationSet("SwatDoubleDoorAnimations.SwatDoubleDoor");
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		assert(EqualEqual_ObjectObject(LeftHingeDoorModel, none));
		LeftHingeDoorModel = Spawn(Class'SwatGame.DoorModel', self);
		assert(NotEqual_ObjectObject(LeftHingeDoorModel, none));
		LeftHingeDoorModel.SetStaticMesh(OneOfDoubleDoorsSM);
		LeftHingeDoorModel.Door = self;
		AttachToBone(LeftHingeDoorModel, 'DoorHingeL');
		assert(EqualEqual_ObjectObject(RightHingeDoorModel, none));
		RightHingeDoorModel = Spawn(Class'SwatGame.DoorModel', self);
		assert(NotEqual_ObjectObject(RightHingeDoorModel, none));
		RightHingeDoorModel.SetStaticMesh(OneOfDoubleDoorsSM);
		RightHingeDoorModel.Door = self;
		AttachToBone(RightHingeDoorModel, 'DoorHingeR');
	}
	return;
}

simulated function PostBroken()
{
	LeftHingeDoorModel.SetStaticMesh(BrokenStaticMesh);
	RightHingeDoorModel.SetStaticMesh(BrokenStaticMesh);
	return;
}

simulated function array<Actor> GetDoorModels()
{
	local array<Actor> DoorModels;

	DoorModels[0] = LeftHingeDoorModel;
	DoorModels[1] = RightHingeDoorModel;
	return DoorModels;
	return;
}

simulated function PlayBreachedEffects()
{
	LeftHingeDoorModel.TriggerEffectEvent('Breached');
	RightHingeDoorModel.TriggerEffectEvent('Breached');
	return;
}

simulated function float GetDoorwayWidth()
{
	return 156.0000000;
	return;
}

simulated function Vector GetPushAwayDirection(SwatRagdollPawn thePawn)
{
	local Vector LeftHingeToPawn2D, HingeToKnob2D, HingeLocation2D, DesiredPushLocation2D, CenterLeftSide2D, CenterRightSide2D,
		PawnLocation2D;

	local float DistFromDoorwayPlane, FudgeFactor;

	HingeToKnob2D = Vector(Rotation);
	HingeToKnob2D.Z = 0.0000000;
	HingeToKnob2D = Normal(HingeToKnob2D);
	HingeLocation2D = Subtract_VectorVector(Location, Multiply_VectorFloat(HingeToKnob2D, Multiply_FloatFloat(GetDoorwayWidth(), 0.5000000)));
	HingeLocation2D.Z = 0.0000000;
	PawnLocation2D = thePawn.Location;
	PawnLocation2D.Z = 0.0000000;
	LeftHingeToPawn2D = Subtract_VectorVector(PawnLocation2D, HingeLocation2D);
	if(Greater_FloatFloat(VSize2D(Multiply_VectorFloat(HingeToKnob2D, Dot_VectorVector(Subtract_VectorVector(thePawn.Location, Location), HingeToKnob2D))), Multiply_FloatFloat(GetDoorwayWidth(), 0.5000000)))
	{
		return Normal(Multiply_VectorFloat(HingeToKnob2D, Dot_VectorVector(Subtract_VectorVector(thePawn.Location, Location), HingeToKnob2D)));
	}
	CenterLeftSide2D = Add_VectorVector(Location, Multiply_VectorFloat(Multiply_VectorFloat(Normal(Cross_VectorVector(HingeToKnob2D, vect(0.0000000, 0.0000000, 1.0000000))), GetDoorwayWidth()), 0.5000000));
	CenterRightSide2D = Add_VectorVector(Location, Multiply_VectorFloat(Multiply_VectorFloat(Normal(Cross_VectorVector(HingeToKnob2D, vect(0.0000000, 0.0000000, -1.0000000))), GetDoorwayWidth()), 0.5000000));
	DistFromDoorwayPlane = VSize2D(Subtract_VectorVector(LeftHingeToPawn2D, Multiply_VectorFloat(HingeToKnob2D, Dot_VectorVector(LeftHingeToPawn2D, HingeToKnob2D))));
	FudgeFactor = Multiply_FloatFloat(GetDoorwayWidth(), 0.4000000);
	if(AndAnd_BoolBool(PointIsOnSideThatDoorIsOpenTo(thePawn.Location), LessEqual_FloatFloat(DistFromDoorwayPlane, FudgeFactor)))
	{
		if(OrOr_BoolBool(IsOpenLeft(), IsOpeningLeft()))
		{
			DesiredPushLocation2D = CenterRightSide2D;
		}
		else
		{
			DesiredPushLocation2D = CenterLeftSide2D;
		}
	}
	else
	{
		if(PointIsToMyLeft(thePawn.Location))
		{
			DesiredPushLocation2D = CenterLeftSide2D;
		}
		else
		{
			DesiredPushLocation2D = CenterRightSide2D;
		}
	}
	return Normal(Subtract_VectorVector(DesiredPushLocation2D, Location));
	return;
}

simulated state BeingBlasted
{
	simulated function PlayBlastedEffects()
	{
		LeftHingeDoorModel.TriggerEffectEvent('Blasted');
		RightHingeDoorModel.TriggerEffectEvent('Blasted');
		return;
	}
	stop;
}

defaultproperties
{
	OneOfDoubleDoorsSM=StaticMesh'Doors_sm.TestDoorKarma78Wide'
	DoorBufferVolumeCollisionMesh=StaticMesh'Doors_sm.door_phys_doubleref'
	StaticMesh=StaticMesh'Doors_sm.FusedDoubleDoor'
	Mesh=SkeletalMesh'SWATDoubleDoorAnimations.SWATdoubleDoor'
	CollisionRadius=120.0000000
}