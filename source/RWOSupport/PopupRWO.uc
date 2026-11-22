class PopupRWO extends ReactiveWorldObject
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var(Havok) name HingeConstraintLabel "The label of the HavokHingeConstraint for this RWO.  This HingeConstraint will have hkHingeType set to HKH_Normal before impulses are imparted.";
var HavokHingeConstraint HingeConstraint;

function PostBeginPlay()
{
	local HavokHingeConstraint Candidate;

	super.PostBeginPlay();
	if(NotEqual_NameName(HingeConstraintLabel, 'None'))
	{
		foreach AllActors(Class'Engine.HavokHingeConstraint', Candidate)
		{
			if(EqualEqual_NameName(Candidate.Label, HingeConstraintLabel))
			{
				HingeConstraint = Candidate;
			}
		}
		AssertWithDescription(NotEqual_ObjectObject(HingeConstraint, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The HavokHingeConstraint labeled ", string(HingeConstraintLabel)), " was not found for the ReactiveWorldObject of class "), string(Class.Name)), " named "), string(Name)));
	}
	return;
}

simulated event TakeHitImpulse(Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(NotEqual_ObjectObject(HingeConstraint, none))
	{
		HingeConstraint.hkMotorActive = false;
		HingeConstraint.UpdateConstraintDetails();
	}
	super(HavokActor).TakeHitImpulse(HitLocation, Momentum, DamageType);
	return;
}
