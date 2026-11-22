class HavokRigidBody extends HavokObject
	native
	editinlinenew
	hidecategories(Object);

cpptext
{
#	ifdef UNREAL_HAVOK
		void PostEditChange();
#	endif

}

const HavokCollisionLayer_All = 0;
const HavokCollisionLayer_Static = 1;
const HavokCollisionLayer_Dynamic = 2;
const HavokCollisionLayer_Keyframed = 5;
const HavokCollisionLayer_Debris = 7;

enum EOrientationConstraint
{
	HKOC_Free,                      // 0
	HKOC_ConstrainX,                // 1
	HKOC_ConstrainY,                // 2
	HKOC_ConstrainZ,                // 3
	HKOC_ConstrainXYZ               // 4
};

var const transient int hkEntityPtr;
var const transient int hkUprightConstraintPtr;
var bool bHighDetailOnly "If true, the object will have physics disabled if the level's physics setting is less than PDL_High, or if running on a dedicated server.";
var bool bClientOnly "If true, the object's physics will be disabled when running on a server (i.e., it will only be physical on clients)";
var float hkMass "The mass of the object.\r" "\r" "WARNING: If mass is set to 0 then the object will be fixed in place, and the hkKeyframed setting will be ignored!";
var bool hkStabilizedInertia "Set this flag to help stabilize the physics of unstable configurations, such as long thin objects. For normal configurations is should be left at the default value of false.";
var float hkFriction "Controls how sticky the object is. Minimum value is 0 and maximum is 1";
var float hkRestitution "Controls how bouncy the object is. Minimum value is 0 and maximum is 1";
var float hkLinearDamping "Controls how much damping is applied to linear velocity. Values are usually very small, and 0 means 'no damping'";
var float hkAngularDamping "Controls how much damping is applied to angular velocity. Values are usually very small, and 0 means 'no damping'";
var bool hkActive "If true, the object will be 'physical' as soon as the level starts (e.g., it will fall to the ground, etc). If false, it will be inactive until it is activated (i.e., it will float in space something collides with it, etc.)";
var bool hkKeyframed "Only set this to true for objects that should block other physics objects but whose movement is controlled by Unreal instead of physical forces. For example, this should be true for Movers.\r" "\r" "WARNING: this flag is ignored if hkMass is 0!";
var Vector hkLinearVel "The initial linear velocity of the object.\r" "\r" "WARNING: this value must be in Unreal units, not meters/second (1 meter = 50 Unreal distance units).";
var Vector hkAngularVel "The initial angular velocity of the object.\r" "\r" "WARNING: this value must be in Unreal units, not radians/second (1 radian = 10430.2192 Unreal angular units).";
var int hkCollisionLayer "The collision layer in which this object resides. Supported values are:\r" "\r" "0 = no filtering, collides with everything\r" "\r" "1 = does not collide with its own group or static (default for static objects and landscape)\r" "\r" "2 = collides with everything (default for free moving rigid bodies)\r" "\r" "5 = does not collide with its own group or static objects (default for keyframed (Movers etc) and the Player Pawn),\r" "\r" "7 = does not collide with its own group (nothing in it by default, intended for fast debris).";
var int hkCollisionSystemGroup;
var int hkCollisionSubpartID;
var int hkCollisionSubpartIgnoreID;
var HavokRigidBody.EOrientationConstraint hkForceUpright "Controls which, if any, of the object's rotational axes are constrained while moving.\r" "\r" "WARNING: this parameter is ignored hkKeyframed is true or hkMass is 0.";
var float hkForceUprightStrength "Governs how quickly an object bounces back when tilted away from its upright axis. Higher values mean that the object recovers more quickly. Values can range from 0 to 1";
var float hkForceUprightDamping "Governs how quickly the oscillation along the vertical axis settles down. Low values create springy behavior, while high values will reduce any oscillations very quickly with the size of the oscillations getting much smaller each time. Values can range from 0 to 1";

defaultproperties
{
	hkMass=1.0000000
	hkFriction=0.8000000
	hkRestitution=0.3000000
	hkAngularDamping=0.0500000
	hkActive=true
	hkForceUprightStrength=0.3000000
	hkForceUprightDamping=0.9000000
}