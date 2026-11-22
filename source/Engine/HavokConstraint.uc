class HavokConstraint extends HavokActor
	abstract
	native
	config(SwatGame)
	placeable
	hidecategories(Karma,Havok,LightColor,Lighting,Movement,Force,Display,Collision,Ballistics);

cpptext
{
#ifdef UNREAL_HAVOK

	virtual bool HavokInitActor();
	virtual void HavokQuitActor();
	virtual void HavokScriptMoveUpdate(FLOAT dt);

	virtual void Spawned(); // override the default (rigidbody) one in HavokActor

	virtual void PostEditChange(); // this wil auto recreate the constraint if not in Editor
	virtual void PostEditMove();

	virtual void RecreateConstraint(); // call this if you change of the constraint data and the attached body names and change tto/from 0 for damping and strength values (requires extra constraint layer to be changed)
    virtual void UpdateConstraintDetails(); // call this if you just change of the updateable constraint data (limits, positions etc, not the attached bodies though)
	virtual void ActivateAttachedBodies(); // called automatically when you update the constraint, but you can use it anytime.
	virtual void AutoComputeLocalValues(); // compute the Local Axis based on some set other axis (either from the other Actor or from this constraint actor itself). Called automatically on create and update.

	virtual void PrivateSetupExtraData(); // internal call
	virtual void PrivateUpdateExtraData(); // internal call
	virtual void* GetRigidBodyPtrA(); // internal call
	virtual void* GetRigidBodyPtrB(); // internal call
	virtual void* GetBaseConstraint(); // internal call

	virtual void CheckForErrors(); // used for checking that this constraint is valid during map build
	virtual void RenderEditorSelected(FLevelSceneNode* SceneNode,FRenderInterface* RI, FDynamicActor* FDA);
	virtual UBOOL CheckOwnerUpdated();

#endif

}

enum EAutoComputeConstraint
{
	HKC_DontAutoCompute,            // 0
	HKC_AutoComputeBothFromC,       // 1
	HKC_AutoComputeAFromC,          // 2
	HKC_AutoComputeBFromC,          // 3
	HKC_AutoComputeAFromB,          // 4
	HKC_AutoComputeBFromA           // 5
};

var const transient int hkConstraintPtr;
var const transient bool hkInitCalled;
var() edfindable Actor hkAttachedActorA;
var() name hkAttachedSubPartA "If hkAttachedActorA is a skeletal pawn and PHYS_HavokSkeletal, this option specifies the bone of the skeleton to which the constraint should attach";
var() edfindable Actor hkAttachedActorB;
var() name hkAttachedSubPartB "If hkAttachedActorB is a skeletal pawn and PHYS_HavokSkeletal, this option specifies the bone of the skeleton to which the constraint should attach";
var() bool bDisableCollisions "If true, collisions between hkAttachedActorA and hkAttachedActorB will be disabled";
var() float fMaxForceToBreak "Maximum force required to break the constraint (i.e., un-attached the two actors from each other), in Newtons. If 0, the constraint will never break";
var() float fSpecificStrength "Large impulses or forces can stretch all constraints; the speed of recovery is determined by the constraint's strength (or 'tau' value). Higher values mean that the constraint recovers more quickly. Values can range from 0 to 1";
var() float fSpecificDamping "The damping value governs how quickly the oscillation of a constraint settles down. Low values create springy behavior, while high values will reduce any oscillations very quickly with the size of the oscillations getting much smaller each time. Values can range from 0 to 1";
var() HavokConstraint.EAutoComputeConstraint AutoComputeLocals;
var() Vector LocalPosA;
var() Vector LocalAxisA;
var() Vector LocalPerpAxisA;
var() Vector LocalPosB;
var() Vector LocalAxisB;
var() Vector LocalPerpAxisB;

// Export UHavokConstraint::execRecreateConstraint(FFrame&, void* const)
native function RecreateConstraint();

// Export UHavokConstraint::execUpdateConstraintDetails(FFrame&, void* const)
native function UpdateConstraintDetails();

// Export UHavokConstraint::execActivateAttachedBodies(FFrame&, void* const)
native function ActivateAttachedBodies();

// Export UHavokConstraint::execComputeLocalValues(FFrame&, void* const)
native function ComputeLocalValues();

defaultproperties
{
	bDisableCollisions=true
	AutoComputeLocals=1
	LocalAxisA=(X=1.0000000,Y=0.0000000,Z=0.0000000)
	LocalPerpAxisA=(X=0.0000000,Y=1.0000000,Z=0.0000000)
	LocalAxisB=(X=1.0000000,Y=0.0000000,Z=0.0000000)
	LocalPerpAxisB=(X=0.0000000,Y=1.0000000,Z=0.0000000)
	DrawType=1
	bHidden=true
	Texture=Texture'Engine_res.Havok.S_HkConstraint'
	bCollideActors=false
	bBlockActors=false
	bBlockPlayers=false
	bProjTarget=false
	bBlockKarma=false
	bBlockHavok=false
}