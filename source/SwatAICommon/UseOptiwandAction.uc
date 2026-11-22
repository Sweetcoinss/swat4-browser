class UseOptiwandAction extends SwatWeaponAction
	native
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private HandheldEquipment optiwand;
var(Parameters) bool bUseOverloadedViewOrigin;
var(Parameters) Vector OverloadedViewOrigin;
var(Parameters) bool bMirrorAroundCorner;
var(Parameters) Vector OptiwandViewDirection;
var array<Pawn> SeenPawns;
var config float OptiwandUseTweenTime;

function cleanup()
{
	super(ActionBase).cleanup();
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(optiwand, none), Not_PreBool(optiwand.IsIdle())))
	{
		optiwand.AIInterrupt();
	}
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
	return;
}

private function Vector GetOptiwandViewOrigin()
{
	if(bUseOverloadedViewOrigin)
	{
		return OverloadedViewOrigin;
	}
	else
	{
		return optiwand.GetThirdPersonModel().GetBoneCoords('Lens', true).Origin;
	}
	return;
}

// Export UUseOptiwandAction::execLookForPawnsUsingOptiwand(FFrame&, void* const)
native function LookForPawnsUsingOptiwand(Vector OptiwandViewOrigin);

function ReportSeeingPawns()
{
	local int i, NumEnemies, NumHostages;
	local Pawn SeenPawnIter;

	i = 0;
	J0x07:

	if(Less_IntInt(i, SeenPawns.Length))
	{
		SeenPawnIter = SeenPawns[i];
		if(SeenPawnIter.IsA('SwatEnemy'))
		{
			AddAdd_Int(NumEnemies);
		}
		else
		{
			if(SeenPawnIter.IsA('SwatHostage'))
			{
				AddAdd_Int(NumHostages);
			}
		}
		SwatAIRepository(Level.AIRepo).GetHive().GetAwareness().ForceViewerSawPawn(m_pawn, SeenPawnIter);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerOptiwandReportSpeech(NumEnemies, NumHostages);
	return;
}

function DebugSeenPawns()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, SeenPawns.Length))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("UseOptiwandAction - SeenPawns[", string(i)), "] is: "), string(SeenPawns[i].Name)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

latent function EquipOptiwand()
{
	optiwand = ISwatOfficer(m_pawn).GetItemAtSlot(9);
	assert(NotEqual_ObjectObject(optiwand, none));
	optiwand.LatentWaitForIdleAndEquip();
	return;
}

private function name GetUseOptiwandAnimation()
{
	if(bMirrorAroundCorner)
	{
		return 'sUseOptiwandCorner';
	}
	else
	{
		return 'sUseOptiwand';
	}
	return;
}

latent function UseOptiwand()
{
	local int MirroringAnimChannel;

	MirroringAnimChannel = m_pawn.AnimPlayEquipment(0, GetUseOptiwandAnimation(), OptiwandUseTweenTime);
	LookForPawnsUsingOptiwand(GetOptiwandViewOrigin());
	m_pawn.FinishAnim(MirroringAnimChannel);
	ReportSeeingPawns();
	if(m_pawn.logAI)
	{
		DebugSeenPawns();
	}
	return;
}

state Running
{Begin:

	EquipOptiwand();
	UseOptiwand();
	ISwatOfficer(m_pawn).ReEquipFiredWeapon();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.UseOptiwandGoal'
}