class ReactToBeingShotAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

enum TorsoHitRegion
{
	TorsoHitRegion_Front,           // 0
	TorsoHitRegion_Back,            // 1
	TorsoHitRegion_Left,            // 2
	TorsoHitRegion_Right            // 3
};

var config array<name> StandingHitInFront;
var config array<name> StandingHitInBack;
var config array<name> StandingHitLeft;
var config array<name> StandingHitRight;
var config array<name> CrouchingHitInFront;
var config array<name> CrouchingHitInBack;
var config array<name> CrouchingHitLeft;
var config array<name> CrouchingHitRight;
var config array<name> StandingHitInHead;
var config array<name> CrouchingHitInHead;
var config array<name> StandingHitRightArm;
var config array<name> CrouchingHitRightArm;
var config array<name> StandingHitLeftArm;
var config array<name> CrouchingHitLeftArm;
var config array<name> StandingHitRightLeg;
var config array<name> CrouchingHitRightLeg;
var config array<name> StandingHitLeftLeg;
var config array<name> CrouchingHitLeftLeg;
var config array<name> CompliantHitFront;
var config array<name> CompliantHitBack;
var config array<name> CompliantHitLeft;
var config array<name> CompliantHitRight;
var config array<name> RestrainedHitFront;
var config array<name> RestrainedHitBack;
var config array<name> RestrainedHitLeft;
var config array<name> RestrainedHitRight;
var config array<name> QuickHitFront;
var config array<name> QuickHitBack;
var config array<name> QuickHitLeft;
var config array<name> QuickHitRight;
var config name QuickHitBaseBone;
var config array<name> RestrainedQuickHitFront;
var config array<name> RestrainedQuickHitBack;
var config array<name> RestrainedQuickHitLeft;
var config array<name> RestrainedQuickHitRight;
var config name RestrainedQuickHitBaseBone;
var(Parameters) Vector HitNormal;
var(Parameters) Vector HitLocation;
var(Parameters) Actor.ESkeletalRegion RegionHit;

private function name GetHitRightAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitRight[Rand(CompliantHitRight.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitRight[Rand(RestrainedHitRight.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitRight[Rand(CrouchingHitRight.Length)];
			}
			else
			{
				return StandingHitRight[Rand(StandingHitRight.Length)];
			}
		}
	}
	return;
}

private function name GetHitLeftAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitLeft[Rand(CompliantHitLeft.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitLeft[Rand(RestrainedHitLeft.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitLeft[Rand(CrouchingHitLeft.Length)];
			}
			else
			{
				return StandingHitLeft[Rand(StandingHitLeft.Length)];
			}
		}
	}
	return;
}

private function name GetHitInBackAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitBack[Rand(CompliantHitBack.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitBack[Rand(RestrainedHitBack.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitInBack[Rand(CrouchingHitInBack.Length)];
			}
			else
			{
				return StandingHitInBack[Rand(StandingHitInBack.Length)];
			}
		}
	}
	return;
}

private function name GetHitInFrontAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitFront[Rand(CompliantHitFront.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitFront[Rand(RestrainedHitFront.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitInFront[Rand(CrouchingHitInFront.Length)];
			}
			else
			{
				return StandingHitInFront[Rand(StandingHitInFront.Length)];
			}
		}
	}
	return;
}

private function ReactToBeingShotAction.TorsoHitRegion GetTorsoHitRegion(Vector vHitLocation)
{
	local float fDot;
	local Vector vPawnDirection, vPawnDirectionNoZ, vHitDirectionNoZ, vPawnsLeftDirectionNoZ;

	vPawnDirection = Vector(ISwatAI(m_pawn).GetAimOrientation());
	vPawnDirectionNoZ = vPawnDirection;
	vPawnDirectionNoZ.Z = 0.0000000;
	vHitDirectionNoZ = Normal(Subtract_VectorVector(vHitLocation, m_pawn.Location));
	vHitDirectionNoZ.Z = 0.0000000;
	fDot = Dot_VectorVector(vPawnDirectionNoZ, vHitDirectionNoZ);
	if(Greater_FloatFloat(fDot, 0.7070000))
	{
		return 0;
	}
	else
	{
		if(Less_FloatFloat(fDot, -0.7070000))
		{
			return 1;
		}
		else
		{
			vPawnsLeftDirectionNoZ = Cross_VectorVector(vPawnDirection, vect(0.0000000, 0.0000000, 1.0000000));
			vPawnsLeftDirectionNoZ.Z = 0.0000000;
			fDot = Dot_VectorVector(vPawnsLeftDirectionNoZ, vHitDirectionNoZ);
			if(Less_FloatFloat(fDot, 0.0000000))
			{
				return 3;
			}
			else
			{
				return 2;
			}
		}
	}
	return;
}

private function name GetHitTorsoAnimation()
{
	local ReactToBeingShotAction.TorsoHitRegion TorsoHitRegion;

	TorsoHitRegion = GetTorsoHitRegion(HitLocation);
	switch(TorsoHitRegion)
	{
		case 0:
			return GetHitInFrontAnimation();
		case 1:
			return GetHitInBackAnimation();
		case 3:
			return GetHitRightAnimation();
		case 2:
			return GetHitLeftAnimation();
		default:
			assert(false);
			return 'None';
			break;
	}
	return;
}

private function name GetHitHeadAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitFront[Rand(CompliantHitFront.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitFront[Rand(RestrainedHitFront.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitInHead[Rand(CrouchingHitInHead.Length)];
			}
			else
			{
				return StandingHitInHead[Rand(StandingHitInHead.Length)];
			}
		}
	}
	return;
}

private function name GetHitLeftArmAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitLeft[Rand(CompliantHitLeft.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitLeft[Rand(RestrainedHitLeft.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitLeftArm[Rand(CrouchingHitLeftArm.Length)];
			}
			else
			{
				return StandingHitLeftArm[Rand(StandingHitLeftArm.Length)];
			}
		}
	}
	return;
}

private function name GetHitRightArmAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitRight[Rand(CompliantHitRight.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitRight[Rand(RestrainedHitRight.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitRightArm[Rand(CrouchingHitRightArm.Length)];
			}
			else
			{
				return StandingHitRightArm[Rand(StandingHitRightArm.Length)];
			}
		}
	}
	return;
}

private function name GetHitLeftLegAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitLeft[Rand(CompliantHitLeft.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitLeft[Rand(RestrainedHitLeft.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitLeftLeg[Rand(CrouchingHitLeftLeg.Length)];
			}
			else
			{
				return StandingHitLeftLeg[Rand(StandingHitLeftLeg.Length)];
			}
		}
	}
	return;
}

private function name GetHitRightLegAnimation()
{
	if(ISwatAI(m_pawn).IsCompliant())
	{
		return CompliantHitRight[Rand(CompliantHitRight.Length)];
	}
	else
	{
		if(ISwatAI(m_pawn).IsArrested())
		{
			return RestrainedHitRight[Rand(RestrainedHitRight.Length)];
		}
		else
		{
			if(m_pawn.bIsCrouched)
			{
				return CrouchingHitRightLeg[Rand(CrouchingHitRightLeg.Length)];
			}
			else
			{
				return StandingHitRightLeg[Rand(StandingHitRightLeg.Length)];
			}
		}
	}
	return;
}

private function name GetHitAnimationUsingBodyTargeting()
{
	switch(RegionHit)
	{
		case 1:
			return GetHitHeadAnimation();
		case 2:
			return GetHitTorsoAnimation();
		case 3:
			return GetHitLeftArmAnimation();
		case 4:
			return GetHitRightArmAnimation();
		case 5:
			return GetHitLeftLegAnimation();
		case 6:
			return GetHitRightLegAnimation();
		default:
			assert(false);
			return 'None';
			break;
	}
	return;
}

private function name GetHitAnimation()
{
	if(EqualEqual_IntInt(int(RegionHit), int(0)))
	{
		return GetHitTorsoAnimation();
	}
	else
	{
		return GetHitAnimationUsingBodyTargeting();
	}
	return;
}

private function name GetNormalQuickHitAnimation(ReactToBeingShotAction.TorsoHitRegion inTorsoHitRegion)
{
	switch(inTorsoHitRegion)
	{
		case 0:
			return QuickHitFront[Rand(QuickHitFront.Length)];
		case 1:
			return QuickHitBack[Rand(QuickHitBack.Length)];
		case 3:
			return QuickHitRight[Rand(QuickHitRight.Length)];
		case 2:
			return QuickHitLeft[Rand(QuickHitLeft.Length)];
		default:
			assert(false);
			return 'None';
			break;
	}
	return;
}

private function name GetRestrainedQuickHitAnimation(ReactToBeingShotAction.TorsoHitRegion inTorsoHitRegion)
{
	switch(inTorsoHitRegion)
	{
		case 0:
			return RestrainedQuickHitFront[Rand(RestrainedQuickHitFront.Length)];
		case 1:
			return RestrainedQuickHitBack[Rand(RestrainedQuickHitFront.Length)];
		case 3:
			return RestrainedQuickHitRight[Rand(RestrainedQuickHitFront.Length)];
		case 2:
			return RestrainedQuickHitLeft[Rand(RestrainedQuickHitFront.Length)];
		default:
			assert(false);
			return 'None';
			break;
	}
	return;
}

private function name GetQuickHitAnimation(Vector vQuickHitLocation)
{
	local ReactToBeingShotAction.TorsoHitRegion TorsoHitRegion;

	TorsoHitRegion = GetTorsoHitRegion(vQuickHitLocation);
	if(ISwatAI(m_pawn).IsArrested())
	{
		return GetRestrainedQuickHitAnimation(TorsoHitRegion);
	}
	else
	{
		return GetNormalQuickHitAnimation(TorsoHitRegion);
	}
	return;
}

private latent function PlayHitAnimation()
{
	local int AnimSpecialChannel;

	AssertWithDescription(NotEqual_NameName(GetHitAnimation(), 'None'), "ReactToBeingShotAction::PlayHitAnimation - Hit Animation not found!  Ask crombie to fix this!");
	AnimSpecialChannel = m_pawn.AnimPlaySpecial(GetHitAnimation(), 0.1000000);
	m_pawn.FinishAnim(AnimSpecialChannel);
	return;
}

private function TriggerInjuredSpeech()
{
	if(ISwatAI(m_pawn).IsIntenseInjury())
	{
		ISwatAI(m_pawn).GetSpeechManagerAction().TriggerIntenseInjuredSpeech();
	}
	else
	{
		ISwatAI(m_pawn).GetSpeechManagerAction().TriggerNormalInjuredSpeech();
	}
	return;
}

function PlayQuickHit(Vector QuickHitLocation)
{
	local name QuickHitAnimation;

	ISwatAI(m_pawn).AnimStopQuickHit();
	QuickHitAnimation = GetQuickHitAnimation(QuickHitLocation);
	ISwatAI(m_pawn).AnimPlayQuickHit(QuickHitAnimation, 0.1000000, QuickHitBaseBone);
	return;
}

latent function LatentPlayQuickHit(Vector QuickHitLocation)
{
	PlayQuickHit(QuickHitLocation);
	m_pawn.FinishAnim(ISwatAI(m_pawn).AnimGetQuickHitChannel());
	return;
}

state Running
{Begin:

	TriggerInjuredSpeech();
	if(ISwatAI(m_pawn).ShouldPlayFullBodyHitAnimation())
	{
		useResources(Or_IntInt(Class'Tyrion.AI_Resource'.4, Class'Tyrion.AI_Resource'.2));
		PlayHitAnimation();
	}
	else
	{
		LatentPlayQuickHit(HitLocation);
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.ReactToBeingShotGoal'
}