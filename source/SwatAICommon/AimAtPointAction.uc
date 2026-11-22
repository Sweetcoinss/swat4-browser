class AimAtPointAction extends SwatWeaponAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector Point;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(2, 14);
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(14);
	return;
}

latent function AimAtDesiredPoint()
{
	J0x00:
	if(ISwatAI(m_pawn).AnimCanAimAtDesiredPoint(Point))
	{
		LatentAimAtPoint(Point);
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

state Running
{Begin:

	AimAtDesiredPoint();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.AimAtPointGoal'
}