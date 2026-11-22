class HavokConeLimitConstraint extends HavokConstraint
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

var(HavokConstraint) float hkHalfAngle;
var const transient int basisAIndex;
var const transient int basisBIndex;
var const transient int coneIndex;

defaultproperties
{
	hkHalfAngle=8200.0000000
	AutoComputeLocals=3
	Texture=Texture'Engine_res.Havok.S_HkConeLimitConstraint'
	bDirectional=true
}