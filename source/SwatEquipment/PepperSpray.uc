class PepperSpray extends RoundBasedWeapon implements ITacticalAid
	config(SwatEquipment)
	hidecategories(Karma);

const kDistanceToAIToIgnoreFOV = 16.0;

var config float MomentumToPenetrateThreshold;
var config float PlayerPepperSprayedDuration;
var config float AIPepperSprayedDuration;
var config float SPPlayerProtectiveEquipmentDurationScaleFactor;
var config float MPPlayerProtectiveEquipmentDurationScaleFactor;

simulated function TraceFire()
{
	local Vector StartLocation;
	local Rotator StartDirection;
	local ICanBePepperSprayed Candidate;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;
	local Material HitMaterial;
	local bool TraceBlocked;
	local Vector CandidateViewPoint;

	GetPerfectFireStart(StartLocation, StartDirection);
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	foreach RadiusActors(Class'Engine.ICanBePepperSprayed', Candidate, float(Range), StartLocation)
	{
		assert(Candidate.IsA('Pawn'));
		CandidateViewPoint = SwatPawn(Candidate).GetViewPoint();
		if(AndAnd_BoolBool(Not_PreBool(PointWithinInfiniteCone(StartLocation, Vector(StartDirection), CandidateViewPoint, Multiply_FloatFloat(2.0000000, Multiply_FloatFloat(GetAimError(), 0.0174533)))), OrOr_BoolBool(Not_PreBool(Candidate.IsA('SwatAI')), Greater_FloatFloat(VSize(Subtract_VectorVector(CandidateViewPoint, StartLocation)), 16.0000000))))
		{
			continue;
		}
		if(EqualEqual_ObjectObject(Candidate, Owner))
		{
			continue;
		}
		TraceBlocked = false;
		foreach TraceActors(Class'Engine.Actor', HitActor, HitLocation, HitNormal, HitMaterial, CandidateViewPoint, StartLocation,, true)
		{
			if(EqualEqual_ObjectObject(HitActor, Actor(Candidate)))
			{
				break;
				continue;
			}
			if(AndAnd_BoolBool(NotEqual_NameName(HitActor.Class.Name, 'LevelInfo'), OrOr_BoolBool(EqualEqual_IntInt(int(HitActor.DrawType), int(0)), HitActor.bHidden)))
			{
				continue;
				continue;
			}
			if(Greater_FloatFloat(HitActor.GetMomentumToPenetrate(HitLocation, HitNormal, HitMaterial), MomentumToPenetrateThreshold))
			{
				TraceBlocked = true;
				break;
			}
		}
		if(Not_PreBool(TraceBlocked))
		{
			Candidate.ReactToBeingPepperSprayed(self, PlayerPepperSprayedDuration, AIPepperSprayedDuration, SPPlayerProtectiveEquipmentDurationScaleFactor, MPPlayerProtectiveEquipmentDurationScaleFactor);
			continue;
		}
	}
	return;
}

latent simulated function EndFiring()
{
	super(FiredWeapon).EndFiring();
	if(NeedsReload())
	{
		EquipOtherAfterUsed = true;
		if(Owner.IsA('SwatPlayer'))
		{
			SwatPlayer(Owner).SetupReequip();
		}
	}
	return;
}

simulated function HandheldEquipment.EquipmentSlot GetSlotForReequip()
{
	return 0;
	return;
}

defaultproperties
{
	MomentumToPenetrateThreshold=20.0000000
	PlayerPepperSprayedDuration=12.0000000
	AIPepperSprayedDuration=12.0000000
	MPPlayerProtectiveEquipmentDurationScaleFactor=0.2500000
	MagazineSize=10
	PlayerAmmoOption=/* Array type was not detected. */
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=2.0000000
	bCanShootThroughGlass=false
	bAimAtHead=true
	MaxAimError=20.0000000
	SmallAimErrorRecoveryRate=120.0000000
	LargeAimErrorRecoveryRate=250.0000000
	AimErrorBreakingPoint=16.0000000
	InjuredAimErrorPenalty=16.0000000
	EquippedAimErrorPenalty=17.0000000
	StandingAimError=15.0000000
	WalkingAimError=16.0000000
	RunningAimError=17.0000000
	CrouchingAimError=14.0000000
	AvailableFireMode=/* Array type was not detected. */
	Range=300
	FirstPersonModelClass=Class'SwatEquipmentModels.Pepperspray_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.Pepperspray_ThirdPerson'
	Description="While generally used for riot control, handheld pepper spray canisters can be an effective tool for subduing uncooperative targets.  The active ingredient in pepper spray is Oleoresin Capsicum or OC.  OC is an inflammatory agent that causes the eyes to swell up and close.  It also causes a burning sensation on any exposed skin.  Due to its limited range and area of effect it is best used in addition to other non-lethal devices to cause a suspect or hostage to comply."
	FriendlyName="Pepper Spray"
	GUIImage=Texture'gui_tex.equip_pepperspray'
	Slot=6
	UnequipAnimationRate=2.0000000
}