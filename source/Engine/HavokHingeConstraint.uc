class HavokHingeConstraint extends HavokConstraint
	native
	config(SwatGame)
	placeable
	hidecategories(Karma,Havok,LightColor,Lighting,Movement,Force,Display,Collision,Ballistics);

cpptext
{
#ifdef UNREAL_HAVOK
	virtual bool HavokInitActor();
	virtual void UpdateConstraintDetails();
#endif

}

enum EHavokHingeType
{
	HKH_Normal,                     // 0
	HKH_Motorized,                  // 1
	HKH_Controlled                  // 2
};

enum EHavokHingeMotorType
{
	HKHM_SpringDamper,              // 0
	HKHM_Blending                   // 1
};

var(HavokConstraint) HavokHingeConstraint.EHavokHingeType hkHingeType;
var(HavokConstraint) HavokHingeConstraint.EHavokHingeMotorType hkHingeMotorType;
var(HavokConstraint) bool hkMotorActive;
var(HavokConstraint) float hkDesiredAngVel;
var(HavokConstraint) float hkMaxForce;
var(HavokConstraint) float hkMotorDamping;
var(HavokConstraint) float hkDesiredAngleA;
var(HavokConstraint) float hkDesiredAngleB;
var(HavokConstraint) bool hkUseDesiredAngleB;
var const float hkCurrentAngle;

auto state Default
{	stop;
}

state() ToggleMotor
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if(EqualEqual_IntInt(int(hkHingeType), int(1)))
		{
			hkDesiredAngleA = hkCurrentAngle;
			hkUseDesiredAngleB = false;
			hkHingeType = 2;
		}
		else
		{
			hkHingeType = 1;
		}
		UpdateConstraintDetails();
		return;
	}
Begin:

	hkHingeType = 2;
	hkUseDesiredAngleB = false;
	UpdateConstraintDetails();
	stop;
}

state() ControlMotor
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if(NotEqual_IntInt(int(hkHingeType), int(1)))
		{
			hkHingeType = 1;
			UpdateConstraintDetails();
		}
		return;
	}

	function UnTrigger(Actor Other, Pawn EventInstigator)
	{
		if(EqualEqual_IntInt(int(hkHingeType), int(1)))
		{
			hkDesiredAngleA = hkCurrentAngle;
			hkUseDesiredAngleB = false;
			hkHingeType = 2;
			UpdateConstraintDetails();
		}
		return;
	}
Begin:

	hkHingeType = 2;
	hkUseDesiredAngleB = false;
	UpdateConstraintDetails();
	stop;
}

state() ToggleDesired
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		if(hkUseDesiredAngleB)
		{
			hkUseDesiredAngleB = false;
		}
		else
		{
			hkUseDesiredAngleB = true;
		}
		UpdateConstraintDetails();
		return;
	}
	stop;
}

state() ControlDesired
{
	function Trigger(Actor Other, Pawn EventInstigator)
	{
		hkUseDesiredAngleB = true;
		UpdateConstraintDetails();
		return;
	}

	function UnTrigger(Actor Other, Pawn EventInstigator)
	{
		hkUseDesiredAngleB = false;
		UpdateConstraintDetails();
		return;
	}
	stop;
}

defaultproperties
{
	hkMotorActive=true
	hkMaxForce=10000.0000000
	hkMotorDamping=7500.0000000
	AutoComputeLocals=3
	Texture=Texture'Engine_res.Havok.S_HkHingeConstraint'
	bDirectional=true
}