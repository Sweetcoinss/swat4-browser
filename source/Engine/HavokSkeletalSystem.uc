class HavokSkeletalSystem extends HavokObject
	native
	config
	editinlinenew
	hidecategories(Object);

cpptext
{
#ifdef UNREAL_HAVOK
	void PostEditChange();
#endif

}

var const transient int RigidBodySystemNumber;
var const transient int RigidBodyRootBoneIndex;
var const transient int RigidBodyLastBoneIndex;
var const transient int CachedLastRigidBodyRootBoneIndex;
var const transient int BodyCollisionListener;
var bool useIntrusionDrivenUpdates "If false, the Havok representation of this skeleton's bones will be updated every frame to match the on-screen bone location. If true, they will only be updated when another Havok object enters a volume rougly twice the size of this actor's bounding volume. This is a performance optimization; in most cases you should leave it at the default setting.\r" "\r" "NOTE: This is automatically set to true at runtime for keyframed (animated) skeletal meshes.";
var const transient int hkPhantom;
var config string SkeletonPhysicsFile "File from which to load the Havok ragdoll skeleton (e.g., \"myRagdoll.hke\"). File path is relative to \"<ProjectRoot>ContentHavokData\".";
var bool hkActive "If true, the object will behave like a ragdoll as soon as the level starts (e.g., it will fall to the ground, etc). If false, it will be inactive until it is activated (i.e., it will not become a ragdoll until collides with it, etc.)";
var config float hkJointFriction "Global control of ragdoll joint friction";

defaultproperties
{
	hkActive=true
}