class HavokWeakOrientationConstraint extends HavokConstraint
	native
	config(SwatGame)
	placeable
	hidecategories(Karma,Havok,LightColor,Lighting,Movement,Force,Display,Collision,Ballistics);

cpptext
{
#ifdef UNREAL_HAVOK
	virtual bool HavokInitActor();
	virtual void HavokQuitActor(); // removes the Action, not constraint
	virtual void UpdateConstraintDetails();
	virtual void* GetBaseConstraint(); // returns the Action, not constraint
#endif

}

defaultproperties
{
	fSpecificStrength=0.1000000
	fSpecificDamping=0.0100000
	AutoComputeLocals=3
	Texture=Texture'Engine_res.Havok.S_HkWeakOConstraint'
	bDirectional=true
}