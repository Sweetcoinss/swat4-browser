interface ISwatAI implements ISwatPawn
	native
	parseconfig;

enum AIDoorUsageSide
{
	kUseDoorFront,                  // 0
	kUseDoorBack,                   // 1
	kUseDoorCenter                  // 2
};

enum AIDoorCloseSide
{
	kCloseFromLeft,                 // 0
	kCloseFromRight                 // 1
};

enum AIThrowSide
{
	kThrowFromCenter,               // 0
	kThrowFromLeft,                 // 1
	kThrowFromRight                 // 2
};

enum EUpperBodyAnimBehavior
{
	kUBAB_FullBody,                 // 0
	kUBAB_LowReady,                 // 1
	kUBAB_AimWeapon                 // 2
};

function RegisterVisionNotification(IVisionNotification Registrant)
{
	return;
}

function UnregisterVisionNotification(IVisionNotification Registrant)
{
	return;
}

function RegisterHearingNotification(IHearingNotification Registrant)
{
	return;
}

function UnregisterHearingNotification(IHearingNotification Registrant)
{
	return;
}

function DisableVision(bool bDisableVisionPermanently)
{
	return;
}

function EnableVision()
{
	return;
}

function DisableHearing(bool bDisableHearingPermanently)
{
	return;
}

function EnableHearing()
{
	return;
}

function bool isVisible(Pawn TestPawn)
{
	return;
}

function SetPendingDoor(Door inPendingDoor)
{
	return;
}

function ClearPendingDoor()
{
	return;
}

function bool ShouldForceOpenLockedDoors()
{
	return;
}

function AwarenessProxy GetAwareness()
{
	return;
}

function DisableAwareness()
{
	return;
}

function EnableFavorLowThreatPath()
{
	return;
}

function DisableFavorLowThreatPath()
{
	return;
}

function AIKnowledge GetKnowledge()
{
	return;
}

function AICoverFinder GetCoverFinder()
{
	return;
}

function EnableFavorCoveredPath(array<Pawn> otherPawnsToCoverFrom)
{
	return;
}

function DisableFavorCoveredPath()
{
	return;
}

function NavigationPoint FindRunToPoint(Vector PointToRunAwayFrom, float MinDistanceToRunAway)
{
	return;
}

function Vector GetViewDirection()
{
	return;
}

function Vector GetViewPoint()
{
	return;
}

function NotifyBecameCompliant()
{
	return;
}

function IssueComplianceTo(Pawn TargetPawn)
{
	return;
}

function bool CanIssueComplianceTo(Pawn TargetPawn)
{
	return;
}

function HandheldEquipment GetRestrainedHandcuffs()
{
	return;
}

function Pawn GetArrester()
{
	return;
}

function bool IsCompliant()
{
	return;
}

function bool IsArrested()
{
	return;
}

function bool IsOtherActorAThreat(Actor otherActor)
{
	return;
}

function bool IsAggressive()
{
	return;
}

function float GetInitialMorale()
{
	return;
}

function bool IsIntenseInjury()
{
	return;
}

function SetIsCompliant()
{
	return;
}

function bool IsRelevantToPlayerOrOfficers()
{
	return;
}

function CommanderAction GetCommanderAction()
{
	return;
}

function CharacterSpeechManagerAction GetSpeechManagerAction()
{
	return;
}

function bool IsIdleCurrent()
{
	return;
}

function ChooseIdle()
{
	return;
}

function SetIdleCategory(name inIdleCategory)
{
	return;
}

function name GetIdleCategory()
{
	return;
}

function int AnimGetSpecialChannel()
{
	return;
}

function int AnimGetQuickHitChannel()
{
	return;
}

function AnimStopSpecial()
{
	return;
}

function AnimStopEquipment()
{
	return;
}

function AnimSetIdle(name NewIdleAnimation, float TweenTime)
{
	return;
}

function name GetUpperBodyBone()
{
	return;
}

function AnimStopQuickHit()
{
	return;
}

function int AnimPlayQuickHit(name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	return;
}

function int AnimPlayEquipment(Pawn.EAnimPlayType AnimPlayType, name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	return;
}

function bool ShouldPlayFullBodyHitAnimation()
{
	return;
}

function LatentAITriggerEffectEvent(name EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional bool MoveMouth)
{
	return;
}

function FiredWeapon.FireMode GetDefaultAIFireModeForWeapon(FiredWeapon Weapon)
{
	return;
}

function float GetTimeToWaitBetweenFiring(FiredWeapon Weapon)
{
	return;
}

function SwapInRestrainedAnimSet()
{
	return;
}

function SwapInCompliantAnimSet()
{
	return;
}

function name GetFBReactionAnimation()
{
	return;
}

function name GetFBAffectedAnimation()
{
	return;
}

function name GetFBRecoveryAnimation()
{
	return;
}

function name GetGasReactionAnimation()
{
	return;
}

function name GetGasAffectedAnimation()
{
	return;
}

function name GetGasRecoveryAnimation()
{
	return;
}

function name GetStungReactionAnimation()
{
	return;
}

function name GetStungAffectedAnimation()
{
	return;
}

function name GetStungRecoveryAnimation()
{
	return;
}

function name GetTasedReactionAnimation()
{
	return;
}

function name GetTasedAffectedAnimation()
{
	return;
}

function name GetTasedRecoveryAnimation()
{
	return;
}

function name GetFlinchAnimation()
{
	return;
}

function SetWeaponTarget(Actor Target)
{
	return;
}

function SetWeaponTargetLocation(Vector TargetLocation)
{
	return;
}

function bool HasUsableWeapon()
{
	return;
}

function bool HasFiredWeaponEquipped()
{
	return;
}

function Vector GetThrowOriginOffset(bool bIsUnderhandThrow, Rotator Orientation)
{
	return;
}

function Vector GetThrowOrigin(bool bIsUnderhandThrow, Rotator Orientation)
{
	return;
}

function float GetThrowAngle()
{
	return;
}

function SetGrenadeTargetLocation(Vector vInGrenadeTargetLocation)
{
	return;
}

function SetThrowSide(ISwatAI.AIThrowSide inThrowSide)
{
	return;
}

function bool IsUnderhandThrow(Vector Origin, Vector TargetLocation)
{
	return;
}

function bool IsUnderhandThrowTo(Vector TargetLocation)
{
	return;
}

function float GetRagdollSimulationTimeout()
{
	return;
}

function DisableRagdoll(optional bool bKeepHavokPhysics)
{
	return;
}

function AimAtPoint(Vector Point)
{
	return;
}

function AimAtActor(Actor Target)
{
	return;
}

function AimToRotation(Rotator DesiredRotation)
{
	return;
}

function LockAim()
{
	return;
}

function UnlockAim()
{
	return;
}

function Rotator GetAimRotation()
{
	return;
}

function SetAimUrgency(bool Fast)
{
	return;
}

function DisableAim()
{
	return;
}

function SetUpperBodyAnimBehavior(ISwatAI.EUpperBodyAnimBehavior behavior, optional UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId clientId)
{
	return;
}

function UnsetUpperBodyAnimBehavior(optional UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId clientId)
{
	return;
}

function ISwatAI.EUpperBodyAnimBehavior GetUpperBodyAnimBehavior()
{
	return;
}

function ISwatAI.EUpperBodyAnimBehavior GetMovementUpperBodyAimBehavior()
{
	return;
}

function bool AnimIsAimedAtDesired()
{
	return;
}

function bool AnimCanAimAtDesiredPoint(Vector Point)
{
	return;
}

function bool AnimCanAimAtDesiredActor(Actor Actor)
{
	return;
}

function bool AnimCanAimAtDesiredRotation(Rotator Rotation)
{
	return;
}

function bool AnimIsWeaponAimSet()
{
	return;
}

function Vector AnimGetAimOrigin()
{
	return;
}

function Rotator GetAimOrientation()
{
	return;
}

function float GetAnimBaseYaw()
{
	return;
}

function AnimSnapBaseToAim()
{
	return;
}

function bool AnimAreAimingChannelsMuted()
{
	return;
}

function bool CanPawnUseLowReady()
{
	return;
}

function bool IsTurning()
{
	return;
}

function OnTouchedStaircaseAimVolume(StaircaseAimVolume StaircaseAimVolume)
{
	return;
}

function OnUntouchedStaircaseAimVolume(StaircaseAimVolume StaircaseAimVolume)
{
	return;
}

function int GetNumTouchingStaircaseAimVolumes()
{
	return;
}

function StaircaseAimVolume GetTouchingStaircaseAimVolumeAtIndex(int Index)
{
	return;
}
