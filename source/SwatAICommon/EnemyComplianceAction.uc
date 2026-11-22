class EnemyComplianceAction extends ComplianceAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var config array<name> CrouchedComplianceDropWeaponAnimations;
var config array<name> StandingComplianceDropWeaponAnimations;
var config array<name> CrouchedStunnedComplianceDropWeaponAnimations;
var config array<name> StandingStunnedComplianceDropWeaponAnimations;

function name GetPreComplyAnimation()
{
	if(NotEqual_ObjectObject(m_pawn.GetActiveItem(), none))
	{
		if(m_pawn.bIsCrouched)
		{
			if(m_pawn.IsStunned())
			{
				return CrouchedStunnedComplianceDropWeaponAnimations[Rand(CrouchedStunnedComplianceDropWeaponAnimations.Length)];
			}
			else
			{
				return CrouchedComplianceDropWeaponAnimations[Rand(CrouchedComplianceDropWeaponAnimations.Length)];
			}
		}
		else
		{
			if(m_pawn.IsStunned())
			{
				return StandingStunnedComplianceDropWeaponAnimations[Rand(StandingStunnedComplianceDropWeaponAnimations.Length)];
			}
			else
			{
				return StandingComplianceDropWeaponAnimations[Rand(StandingComplianceDropWeaponAnimations.Length)];
			}
		}
	}
	else
	{
		return super.GetPreComplyAnimation();
	}
	return;
}
