class Havok6DOFConstraint extends HavokConstraint
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

var(HavokConstraint) bool bConstrainAngular;
var(HavokConstraint) bool bConstrainLinear;
var const transient int pivotAIndex;
var const transient int pivotBIndex;
var const transient int basisAIndex;
var const transient int basisBIndex;

defaultproperties
{
	bConstrainAngular=true
	bConstrainLinear=true
	Texture=Texture'Engine_res.Havok.S_Hk6DOFConstraint'
	bDirectional=true
}