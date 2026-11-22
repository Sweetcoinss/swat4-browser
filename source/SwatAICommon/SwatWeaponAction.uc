class SwatWeaponAction extends AI_WeaponAction
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

const kLowSkillLevelErrorAngle = 0.2079;
const kMediumSkillLevelErrorAngle = 0.1392;
const kHighSkillLevelErrorAngle = 0.0698;

var private LevelInfo Level;
var private Pawn m_pawn;

function initAction(AI_Resource R, AI_Goal Goal)
{
	m_pawn = AI_WeaponResource(R).m_pawn;
	assert(NotEqual_ObjectObject(m_pawn, none));
	Level = m_pawn.Level;
	assert(NotEqual_ObjectObject(Level, none));
	super(AI_Action).initAction(R, Goal);
	return;
}

function Vector GetAimSpot(Vector vTargetLocation, Vector vProjStart)
{
	local Vector vAimSpot;

	vAimSpot = vTargetLocation;
	AddEqual_VectorVector(vAimSpot, GetSkillLevelAimErrorOffset(vTargetLocation, vProjStart));
	return vAimSpot;
	return;
}

function Vector GetSkillLevelAimErrorOffset(Vector vTargetLocation, Vector vProjStart)
{
	local float TargetDistance, OffsetRadius, OffsetAngle;
	local Vector vSkillLevelAimErrorOffset;

	OffsetAngle = GetOffsetAngleForEnemy(ISwatEnemy(m_pawn).GetEnemySkill());
	TargetDistance = VSize(Subtract_VectorVector(vTargetLocation, vProjStart));
	OffsetRadius = Multiply_FloatFloat(Sin(OffsetAngle), TargetDistance);
	vSkillLevelAimErrorOffset = Multiply_VectorFloat(VRand(), Multiply_FloatFloat(OffsetRadius, FRand()));
	return vSkillLevelAimErrorOffset;
	return;
}

function float GetOffsetAngleForEnemy(ISwatEnemy.EnemySkill EnemySkill)
{
	switch(EnemySkill)
	{
		case 0:
			return 0.2079000;
		case 1:
			return 0.1392000;
		case 2:
			return 0.0698000;
		default:
			assert(false);
			return 0.0000000;
			break;
	}
	return;
}

function bool HasWeaponEquipped()
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	return NotEqual_ObjectObject(m_pawn.GetActiveItem(), none);
	return;
}

latent function AimAndHoldAtPoint(Vector Point, float MinPauseTime, float MaxPauseTime)
{
	if(ISwatAI(m_pawn).AnimCanAimAtDesiredPoint(Point))
	{
		LatentAimAtPoint(Point);
		Sleep(RandRange(MinPauseTime, MaxPauseTime));
	}
	else
	{
		Warn(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " cannot aim "), string(m_pawn.GetActiveItem())), " at Point: "), string(Point)));
	}
	return;
}

final latent function LatentAimAtPoint(Vector Point)
{
	if(ISwatAI(m_pawn).AnimCanAimAtDesiredPoint(Point))
	{
		ISwatAI(m_pawn).AimAtPoint(Point);
		J0x35:

		if(OrOr_BoolBool(AndAnd_BoolBool(Not_PreBool(ISwatAI(m_pawn).AnimIsAimedAtDesired()), HasWeaponEquipped()), ISwatAI(m_pawn).AnimAreAimingChannelsMuted()))
		{
			yield();
			// [Loop Continue]
			goto J0x35;
		}
	}
	else
	{
		Warn(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " cannot aim "), string(m_pawn.GetActiveItem())), " at Point: "), string(Point)));
	}
	return;
}

final function AimAtPoint(Vector Point)
{
	if(ISwatAI(m_pawn).AnimCanAimAtDesiredPoint(Point))
	{
		ISwatAI(m_pawn).AimAtPoint(Point);
	}
	return;
}

static function bool IsAThreatBasedOnAim(Pawn PotentialThreat, Pawn Target)
{
	local HandheldEquipment ActiveItem;

	assert(NotEqual_ObjectObject(PotentialThreat, none));
	ActiveItem = PotentialThreat.GetActiveItem();
	if(OrOr_BoolBool(EqualEqual_ObjectObject(ActiveItem, none), Not_PreBool(ActiveItem.IsA('FiredWeapon'))))
	{
		return false;
	}
	if(Target.IsA('Pawn'))
	{
		return true;
	}
	else
	{
		return false;
	}
	return;
}

final function UpdateThreatToTarget(Actor Target)
{
	local Pawn TargetPawn;

	TargetPawn = Pawn(Target);
	if(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(m_pawn), Class'Engine.Pawn'.static.checkConscious(TargetPawn)), Class'SwatAICommon.SwatWeaponAction'.static.IsAThreatBasedOnAim(m_pawn, TargetPawn)))
	{
		if(AndAnd_BoolBool(m_pawn.IsA('SwatEnemy'), Not_PreBool(ISwatEnemy(m_pawn).IsAThreat())))
		{
			ISwatEnemy(m_pawn).BecomeAThreat();
		}
		if(TargetPawn.IsA('SwatAI'))
		{
			SwatCharacterResource(TargetPawn.CharacterAI).ThreatenedSensorAction.UpdateThreatFrom(m_pawn);
		}
	}
	return;
}

final latent function LatentAimAtActor(Actor Target)
{
	if(AndAnd_BoolBool(ISwatAI(m_pawn).AnimCanAimAtDesiredActor(Target), HasWeaponEquipped()))
	{
		ISwatAI(m_pawn).AimAtActor(Target);
		J0x40:

		if(OrOr_BoolBool(AndAnd_BoolBool(Not_PreBool(ISwatAI(m_pawn).AnimIsAimedAtDesired()), HasWeaponEquipped()), ISwatAI(m_pawn).AnimAreAimingChannelsMuted()))
		{
			UpdateThreatToTarget(Target);
			yield();
			// [Loop Continue]
			goto J0x40;
		}
		UpdateThreatToTarget(Target);
	}
	return;
}

final function AimAtActor(Actor Target)
{
	if(ISwatAI(m_pawn).AnimCanAimAtDesiredActor(Target))
	{
		ISwatAI(m_pawn).AimAtActor(Target);
	}
	return;
}

latent function ShootWeaponAt(Actor Target)
{
	local FiredWeapon CurrentWeapon;

	AssertWithDescription(NotEqual_ObjectObject(Target, none), "SwatWeaponAction::ShootWeaponAt - Target is None!");
	AssertWithDescription(NotEqual_ObjectObject(m_pawn, none), "SwatWeaponAction::ShootWeaponAt - m_Pawn is None!");
	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(Not_PreBool(CurrentWeapon.IsEmpty()))
	{
		ISwatAI(m_pawn).SetWeaponTarget(Target);
		CurrentWeapon.LatentUse();
	}
	return;
}

function FiredWeapon GetBackupWeapon()
{
	if(m_pawn.IsA('SwatEnemy'))
	{
		return ISwatEnemy(m_pawn).GetBackupWeapon();
	}
	else
	{
		assert(m_pawn.IsA('SwatOfficer'));
		return ISwatOfficer(m_pawn).GetBackupWeapon();
	}
	return;
}

latent function SwitchWeapons()
{
	if(m_pawn.IsA('SwatEnemy'))
	{
		ISwatEnemy(m_pawn).ThrowWeaponDown();
		ISwatAICharacter(m_pawn).SetDesiredAIEquipment(2);
	}
	GetBackupWeapon().LatentWaitForIdleAndEquip();
	return;
}
