class NetPlayerTeamA extends NetPlayer
	config(SwatPawn)
	hidecategories(Karma);

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if(Level.IsPlayingCOOP)
	{
		bAlwaysRelevant = true;
	}
	return;
}

simulated function int GetTeamNumber()
{
	return 0;
	return;
}

defaultproperties
{
	TeamNumber=0
	MinimumLongThrowSpeed=1000.0000000
	PreThrowAnimation="sPullPinUpper"
	ThrowShortAnimation="sThrowShortUpper"
	ThrowLongAnimation="sThrowLongUpper"
	ThrowAnimationRootBone="Bip01_Spine1"
	ThrowSpeedTimeFactor=360.0000000
	ThrowSpeedRange=(Min=350.0000000,Max=1500.0000000)
	StingEffectDropOffTimePercent=0.2000000
	StingEffectFrequency=6.0000000
	StingViewEffectAmplitude=(Pitch=9000,Yaw=9000,Roll=9000)
	StingInputEffectMagnitude=9.0000000
	TasedViewEffectAmplitude=20.0000000
	TasedViewEffectFrequency=200.0000000
	PawnModelApparentBaseEyeHeight=30.0000000
	PawnModelApparentCrouchEyeHeight=6.0000000
	LimbTwitchTime=3.0000000
	LimbIdleTime=8.0000000
	TwitchInfos[0]=(BoneName="Bip01_Head",ForceMagnitude=(Min=-3000.0000000,Max=3000.0000000),ForceVector=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetBoneName="Bip01_Spine",TargetForceNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000),TwitchType=0)
	TwitchInfos[1]=(BoneName="Bip01_Spine2",ForceMagnitude=(Min=-120.0000000,Max=1200.0000000),ForceVector=(X=0.0000000,Y=0.0000000,Z=0.0000000),TargetBoneName="Bip01_Spine",TargetForceNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000),TwitchType=2)
	RenderTimeout=1.5000000
	InitialRagdollRenderTimeout=3.0000000
	AnimBoneBase="bip01"
	AnimBoneSpineLow="Bip01_Spine1"
	AnimBoneRightShoulder="Bip01_R_UpperArm"
	AnimBoneHead="Bip01_Head"
	AnimBoneJaw="Bone03jaw"
	NormalAimLocationBone="Bip01_Head"
	LeanAimLocationBone="Bip01_Head"
	NormalFireLocationBone="Bip01_Spine2"
	LeanFireLocationBone="Bip01_Head"
	AnimSocketGripRhand="GripRHand"
	AnimSocketGripBack="GripBack"
	AnimSocketGripHolster="GripHolster"
	AnimSocketGripBelt1="GripBelt1"
	AnimSocketGripBelt2="GripBelt2"
	AnimSocketHolster="Holster"
	AnimSocketPouch="Pouch"
	AnimSocketHeadGear="HeadGear"
	MaleAnimGroups[0]="SWATMaleAnimation.SWATaimPoses"
	MaleAnimGroups[1]="SWATMaleAnimation.SWAThostage"
	MaleAnimGroups[2]="SWATMaleAnimation.SWATmovement"
	MaleAnimGroups[3]="SWATMaleAnimation.SWATinjuries"
	MaleAnimGroups[4]="SWATMaleAnimation.SWATfidgets"
	MaleAnimGroups[5]="SWATMaleAnimation.SWATaction"
	FemaleAnimGroups[0]="FemaleAnimation.FEMALEaimPoses"
	FemaleAnimGroups[1]="FemaleAnimation.FEMALEhostage"
	FemaleAnimGroups[2]="FemaleAnimation.FEMALEmovement"
	FemaleAnimGroups[3]="FemaleAnimation.FEMALEinjuries"
	FemaleAnimGroups[4]="FemaleAnimation.FEMALEfidgets"
	FemaleAnimGroups[5]="FemaleAnimation.FEMALEaction"
	PercentageHealthForIntenseInjury=0.5000000
	MaxComplianceIssueDistance=2000.0000000
	QualifyTimeForArrest=3.0000000
	RelevancyPropogationDistance=800.0000000
	RelevancyLOSDistance=160.0000000
	GroundSpeed=150.0000000
	BaseEyeHeight=48.0000000
	CrouchEyeHeight=35.0000000
	CrouchHeight=52.0000000
	Bob=0.0020000
	Skins=/* Array type was not detected. */
}