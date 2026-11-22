class QualifiedUseEquipmentModel extends HandheldEquipmentModel
	abstract
	config(SwatGame)
	notplaceable
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

var(QualifiedUseEquipmentModelAnimations) name BeginQualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) name QualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) name EndQualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) name HolderBeginQualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) name HolderQualifyLoopAnimation;
var(QualifiedUseEquipmentModelAnimations) name HolderEndQualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) name BeginAlternateQualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) name AlternateQualifyLoopAnimation;
var(QualifiedUseEquipmentModelAnimations) name EndAlternateQualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) name HolderBeginAlternateQualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) name HolderAlternateQualifyLoopAnimation;
var(QualifiedUseEquipmentModelAnimations) name HolderEndAlternateQualifyAnimation;
var(QualifiedUseEquipmentModelAnimations) Pawn.EAnimPlayType HolderAnimationBlending;
var(QualifiedUseEquipmentModelAnimations) bool HolderShouldHideBeginAndEndAnims;
var(QualifiedUseEquipmentModelAnimations) float FinishQualifyTweenTime;

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	return;
}

simulated function SetHandHeldEquipment(HandheldEquipment HHE)
{
	super.SetHandHeldEquipment(HHE);
	if(NotEqual_IntInt(int(DrawType), int(2)))
	{
		AssertWithDescription(EqualEqual_NameName(BeginQualifyAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies a BeginQualifyAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(QualifyAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies a QualifyAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(EndQualifyAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies an EndQualifyAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(BeginAlternateQualifyAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies a BeginAlternateQualifyAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(AlternateQualifyLoopAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies an AlternateQualifyLoopAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(EndAlternateQualifyAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies an EndAlternateQualifyAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
	}
	return;
}

simulated function PlayBeginQualify(bool UseAlternate)
{
	local name ModelAnimation, HolderAnimation;

	if(Not_PreBool(UseAlternate))
	{
		ModelAnimation = BeginQualifyAnimation;
		HolderAnimation = HolderBeginQualifyAnimation;
	}
	else
	{
		ModelAnimation = BeginAlternateQualifyAnimation;
		HolderAnimation = HolderBeginAlternateQualifyAnimation;
	}
	if(NotEqual_NameName(ModelAnimation, 'None'))
	{
		PlayAnim(ModelAnimation);
	}
	if(NotEqual_NameName(HolderAnimation, 'None'))
	{
		if(Owner.IsA('SwatPawn'))
		{
			HolderUseAnimationChannel = Pawn(Owner).AnimPlayEquipment(HolderAnimationBlending, HolderAnimation,, HolderAnimationRootBone);
		}
		else
		{
			Owner.PlayAnim(HolderAnimation);
			HolderUseAnimationChannel = 0;
		}
		if(AndAnd_BoolBool(Owner.IsA('Pawn'), HolderShouldHideBeginAndEndAnims))
		{
			Pawn(Owner).EnableAnimEquipmentAlphaOverride(0.0100000);
		}
	}
	return;
}

latent simulated function FinishBeginQualify(bool UseAlternate)
{
	local name ModelAnimation, HolderAnimation;

	if(Not_PreBool(UseAlternate))
	{
		ModelAnimation = BeginQualifyAnimation;
		HolderAnimation = HolderBeginQualifyAnimation;
	}
	else
	{
		ModelAnimation = BeginAlternateQualifyAnimation;
		HolderAnimation = HolderBeginAlternateQualifyAnimation;
	}
	if(NotEqual_NameName(ModelAnimation, 'None'))
	{
		FinishAnim();
	}
	if(NotEqual_NameName(HolderAnimation, 'None'))
	{
		Owner.FinishAnim(HolderUseAnimationChannel);
	}
	if(AndAnd_BoolBool(Owner.IsA('Pawn'), HolderShouldHideBeginAndEndAnims))
	{
		Pawn(Owner).DisableAnimEquipmentAlphaOverride();
	}
	return;
}

simulated function PlayQualifyLoop(bool UseAlternate)
{
	local name ModelAnimation, HolderAnimation;

	if(Not_PreBool(UseAlternate))
	{
		ModelAnimation = QualifyAnimation;
		HolderAnimation = HolderQualifyLoopAnimation;
	}
	else
	{
		ModelAnimation = AlternateQualifyLoopAnimation;
		HolderAnimation = HolderAlternateQualifyLoopAnimation;
	}
	if(NotEqual_NameName(ModelAnimation, 'None'))
	{
		PlayAnim(ModelAnimation);
	}
	if(NotEqual_NameName(HolderAnimation, 'None'))
	{
		if(Owner.IsA('SwatPawn'))
		{
			Pawn(Owner).AnimLoopEquipment(HolderAnimationBlending, HolderAnimation,, HolderAnimationRootBone);
		}
		else
		{
			Owner.LoopAnim(HolderAnimation);
			HolderUseAnimationChannel = 0;
		}
	}
	return;
}

simulated function PlayEndQualify(bool UseAlternate)
{
	local name ModelAnimation, HolderAnimation;

	if(Not_PreBool(UseAlternate))
	{
		ModelAnimation = EndQualifyAnimation;
		HolderAnimation = HolderEndQualifyAnimation;
	}
	else
	{
		ModelAnimation = EndAlternateQualifyAnimation;
		HolderAnimation = HolderEndAlternateQualifyAnimation;
	}
	if(NotEqual_NameName(ModelAnimation, 'None'))
	{
		PlayAnim(ModelAnimation,, FinishQualifyTweenTime);
	}
	if(NotEqual_NameName(HolderAnimation, 'None'))
	{
		if(Owner.IsA('SwatPawn'))
		{
			HolderUseAnimationChannel = Pawn(Owner).AnimPlayEquipment(HolderAnimationBlending, HolderAnimation, FinishQualifyTweenTime, HolderAnimationRootBone);
		}
		else
		{
			Owner.StopAnimating();
			Owner.PlayAnim(HolderAnimation,, FinishQualifyTweenTime);
			HolderUseAnimationChannel = 0;
		}
		if(AndAnd_BoolBool(Owner.IsA('Pawn'), HolderShouldHideBeginAndEndAnims))
		{
			Pawn(Owner).EnableAnimEquipmentAlphaOverride(0.0000000);
		}
	}
	return;
}

latent simulated function FinishEndQualify(bool UseAlternate)
{
	local name ModelAnimation, HolderAnimation;

	if(Not_PreBool(UseAlternate))
	{
		ModelAnimation = EndQualifyAnimation;
		HolderAnimation = HolderEndQualifyAnimation;
	}
	else
	{
		ModelAnimation = EndAlternateQualifyAnimation;
		HolderAnimation = HolderEndAlternateQualifyAnimation;
	}
	if(NotEqual_NameName(ModelAnimation, 'None'))
	{
		FinishAnim();
	}
	if(NotEqual_NameName(HolderAnimation, 'None'))
	{
		Owner.FinishAnim(HolderUseAnimationChannel);
	}
	if(AndAnd_BoolBool(Owner.IsA('Pawn'), HolderShouldHideBeginAndEndAnims))
	{
		Pawn(Owner).DisableAnimEquipmentAlphaOverride();
	}
	return;
}

simulated function OnInterrupted()
{
	StopAnimating();
	if(AndAnd_BoolBool(Owner.IsA('Pawn'), HolderShouldHideBeginAndEndAnims))
	{
		Pawn(Owner).DisableAnimEquipmentAlphaOverride();
	}
	return;
}
