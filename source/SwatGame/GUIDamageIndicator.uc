class GUIDamageIndicator extends GUIMultiComponent
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

struct HitRegion
{
	var() float FlashTime;
	var() int NumFlashed;
	var() bool bDamaged;
	var() export editinline config GUIImage RegionImage;
};

var() config int NumFlashes;
var() config float FlashLength;
var() config Color FlashColor;
var() config Color NonFlashColor;
var() config Material HeadStandingImage;
var() config Material TorsoStandingImage;
var() config Material LeftArmStandingImage;
var() config Material RightArmStandingImage;
var() config Material LeftLegStandingImage;
var() config Material RightLegStandingImage;
var() config Material HeadCrouchingImage;
var() config Material TorsoCrouchingImage;
var() config Material LeftArmCrouchingImage;
var() config Material RightArmCrouchingImage;
var() config Material LeftLegCrouchingImage;
var() config Material RightLegCrouchingImage;
var() array<HitRegion> HitRegions;

function InitComponent(GUIComponent Owner)
{
	local int i;
	local HitRegion NewRegion;

	super.InitComponent(Owner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, int(7)))
	{
		NewRegion.RegionImage = GUIImage(AddComponent("GUI.GUIImage", Concat_StrStr(Concat_StrStr(string(self.Name), "_"), string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', i))), true));
		NewRegion.RegionImage.ImageStyle = 2;
		NewRegion.RegionImage.ImageRenderStyle = 1;
		NewRegion.RegionImage.WinWidth = 1.0000000;
		NewRegion.RegionImage.WinHeight = 1.0000000;
		NewRegion.RegionImage.WinLeft = 0.0000000;
		NewRegion.RegionImage.WinTop = 0.0000000;
		HitRegions[i] = NewRegion;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	Reset();
	return;
}

function Reset()
{
	Stand();
	ClearDamage();
	return;
}

function Stand()
{
	HitRegions[int(1)].RegionImage.Image = HeadStandingImage;
	HitRegions[int(2)].RegionImage.Image = TorsoStandingImage;
	HitRegions[int(3)].RegionImage.Image = LeftArmStandingImage;
	HitRegions[int(4)].RegionImage.Image = RightArmStandingImage;
	HitRegions[int(5)].RegionImage.Image = LeftLegStandingImage;
	HitRegions[int(6)].RegionImage.Image = RightLegStandingImage;
	return;
}

function Crouch()
{
	HitRegions[int(1)].RegionImage.Image = HeadCrouchingImage;
	HitRegions[int(2)].RegionImage.Image = TorsoCrouchingImage;
	HitRegions[int(3)].RegionImage.Image = LeftArmCrouchingImage;
	HitRegions[int(4)].RegionImage.Image = RightArmCrouchingImage;
	HitRegions[int(5)].RegionImage.Image = LeftLegCrouchingImage;
	HitRegions[int(6)].RegionImage.Image = RightLegCrouchingImage;
	return;
}

function ClearDamage()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(7)))
	{
		HitRegions[i].bDamaged = false;
		HitRegions[i].RegionImage.ImageColor = NonFlashColor;
		HitRegions[i].FlashTime = 0.0000000;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	KillTimer();
	return;
}

function SkeletalRegionHit(Actor.ESkeletalRegion RegionHit, int Damage)
{
	AssertWithDescription(Less_IntInt(int(RegionHit), int(7)), Concat_StrStr(Concat_StrStr(string(self.Name), " recieved an Invalid hit region, "), string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', int(RegionHit)))));
	if(EqualEqual_IntInt(Damage, 0))
	{
		return;
	}
	HitRegions[int(RegionHit)].FlashTime = FlashLength;
	HitRegions[int(RegionHit)].NumFlashed = 0;
	HitRegions[int(RegionHit)].bDamaged = OrOr_BoolBool(HitRegions[int(RegionHit)].bDamaged, Greater_IntInt(Damage, 0));
	HitRegions[int(RegionHit)].RegionImage.ImageColor = FlashColor;
	SetTimer(Divide_FloatFloat(FlashLength, float(Multiply_IntInt(NumFlashes, 2))), true);
	return;
}

event Timer()
{
	local int i;
	local bool bComplete, bShowFlash;

	bComplete = true;
	i = 0;
	J0x0F:

	if(Less_IntInt(i, int(7)))
	{
		if(Greater_FloatFloat(HitRegions[i].FlashTime, float(0)))
		{
			SubtractEqual_FloatFloat(HitRegions[i].FlashTime, Divide_FloatFloat(FlashLength, float(Multiply_IntInt(NumFlashes, 2))));
			AddAdd_Int(HitRegions[i].NumFlashed);
			if(Less_IntInt(HitRegions[i].NumFlashed, Multiply_IntInt(NumFlashes, 2)))
			{
				bComplete = false;
				bShowFlash = EqualEqual_FloatFloat(Percent_FloatFloat(float(HitRegions[i].NumFlashed), float(2)), float(0));
			}
			else
			{
				bShowFlash = HitRegions[i].bDamaged;
			}
			if(bShowFlash)
			{
				HitRegions[i].RegionImage.ImageColor = FlashColor;
				// [Explicit Continue]
				goto J0x11A;
			}
			HitRegions[i].RegionImage.ImageColor = NonFlashColor;
		}
		J0x11A:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0F;
	}
	if(bComplete)
	{
		KillTimer();
	}
	return;
}

defaultproperties
{
	bPersistent=true
}