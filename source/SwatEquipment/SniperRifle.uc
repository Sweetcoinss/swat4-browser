class SniperRifle extends ClipBasedWeapon
	config(SwatEquipment)
	hidecategories(Karma);

function PostBeginPlay()
{
	super(HandheldEquipment).PostBeginPlay();
	return;
}

simulated function ReloadedHook()
{
	Ammo.OnReloaded();
	return;
}

simulated function CreateThirdPersonModel(Class<HandheldEquipmentModel> SelectedThirdPersonModelClass)
{
	return;
}

function OnPreEquipped()
{
	local ICanHoldEquipment Holder;

	super(HandheldEquipment).OnPreEquipped();
	Holder = ICanHoldEquipment(Owner);
	AssertWithDescription(NotEqual_ObjectObject(Holder, none), Concat_StrStr(Concat_StrStr("[tcohen] AnimNotify_Equip was called on ", string(Owner)), " which cannot hold equipment."));
	Holder.OnEquipKeyFrame();
	return;
}

simulated function GetPerfectFireStart(out Vector outLocation, out Rotator outDirection)
{
	outLocation = SniperPawn(Owner).GetViewportLocation();
	outDirection = SniperPawn(Owner).GetViewportDirection();
	return;
}

defaultproperties
{
	EnemyUsesAmmo=/* Array type was not detected. */
	MuzzleVelocity=40463.0000000
	SmallAimErrorRecoveryRate=120.0000000
	LargeAimErrorRecoveryRate=250.0000000
	AimErrorBreakingPoint=3.0000000
	RecoilBackDuration=0.1000000
	RecoilForeDuration=0.5000000
	RecoilMagnitude=1500.0000000
	RagdollDeathImpactMomentumMultiplier=50.0000000
	Range=3000
	Description="If you are reading this, file a bug that the sniper rifle description is being shown."
	FriendlyName="Remington 700 Sniper rifle"
	ZoomedFOV=10.0000000
	Slot=1
	ShouldHaveFirstPersonModel=false
	ShouldHaveThirdPersonModel=false
}