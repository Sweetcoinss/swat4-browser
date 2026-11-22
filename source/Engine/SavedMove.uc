class SavedMove extends Info
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var SavedMove NextMove;
var float TimeStamp;
var float Delta;
var bool bRun;
var bool bDuck;
var bool bPressedJump;
var bool bDoubleJump;
var bool bLeanLeft;
var bool bLeanRight;
var Actor.EDoubleClickDir DoubleClickMove;
var Actor.EPhysics SavedPhysics;
var Vector SavedLocation;
var Vector SavedVelocity;

final function Clear()
{
	TimeStamp = 0.0000000;
	Delta = 0.0000000;
	DoubleClickMove = 0;
	Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	bRun = false;
	bDuck = false;
	bPressedJump = false;
	bDoubleJump = false;
	bLeanLeft = false;
	bLeanRight = false;
	return;
}

final function PostUpdate(PlayerController P)
{
	bDoubleJump = OrOr_BoolBool(P.bDoubleJump, bDoubleJump);
	if(NotEqual_ObjectObject(P.Pawn, none))
	{
		SavedLocation = P.Pawn.Location;
		SavedVelocity = P.Pawn.Velocity;
	}
	return;
}

final function SetMoveFor(float LevelTimeseconds, PlayerController P, float DeltaTime, Vector newAccel, Actor.EDoubleClickDir InDoubleClick)
{
	if(Greater_FloatFloat(VSize(newAccel), float(3072)))
	{
		newAccel = Multiply_FloatVector(float(3072), Normal(newAccel));
	}
	if(Greater_FloatFloat(Delta, float(0)))
	{
		Acceleration = Divide_VectorFloat(Add_VectorVector(Multiply_FloatVector(DeltaTime, newAccel), Multiply_FloatVector(Delta, Acceleration)), Add_FloatFloat(Delta, DeltaTime));
	}
	else
	{
		if(NotEqual_ObjectObject(P.Pawn, none))
		{
			SavedPhysics = P.Pawn.Physics;
		}
		Acceleration = newAccel;
	}
	AddEqual_FloatFloat(Delta, DeltaTime);
	if(EqualEqual_IntInt(int(DoubleClickMove), int(0)))
	{
		DoubleClickMove = InDoubleClick;
	}
	bRun = Greater_IntInt(int(P.bRun), 0);
	bDuck = Greater_IntInt(int(P.bDuck), 0);
	bPressedJump = OrOr_BoolBool(P.bPressedJump, bPressedJump);
	bDoubleJump = OrOr_BoolBool(P.bDoubleJump, bDoubleJump);
	bLeanLeft = Greater_IntInt(int(P.bLeanLeft), 0);
	bLeanRight = Greater_IntInt(int(P.bLeanRight), 0);
	TimeStamp = LevelTimeseconds;
	return;
}
