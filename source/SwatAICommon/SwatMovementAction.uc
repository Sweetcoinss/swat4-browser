class SwatMovementAction extends AI_MovementAction
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Pawn m_pawn;
var private LevelInfo Level;

function initAction(AI_Resource R, AI_Goal Goal)
{
	m_pawn = AI_MovementResource(R).m_pawn;
	assert(NotEqual_ObjectObject(m_pawn, none));
	Level = m_pawn.Level;
	assert(NotEqual_ObjectObject(Level, none));
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 1);
	super(AI_Action).initAction(R, Goal);
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	ISwatAI(m_pawn).AimToRotation(m_pawn.Rotation);
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(1);
	m_pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	return;
}

latent function RotateTowardActor(Actor Target)
{
	ISwatAI(m_pawn).AimAtActor(Target);
	FinishRotation();
	return;
}

latent function RotateTowardPoint(Vector Point)
{
	ISwatAI(m_pawn).AimAtPoint(Point);
	FinishRotation();
	return;
}

latent function RotateTowardRotation(Rotator DesiredRotation)
{
	ISwatAI(m_pawn).AimToRotation(DesiredRotation);
	FinishRotation();
	return;
}

latent function FinishRotation()
{
	J0x00:
	ISwatAI(m_pawn).AnimSnapBaseToAim();
	yield();
	if(!(EqualEqual_IntInt(WrapAngle0To2Pi(ISwatAI(m_pawn).GetAimOrientation().Yaw), WrapAngle0To2Pi(int(ISwatAI(m_pawn).GetAnimBaseYaw())))))
		goto J0x00;
	return;
}

latent function DropToGround()
{
	J0x00:
	if(NotEqual_IntInt(int(m_pawn.Physics), int(1)))
	{
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	return;
}
