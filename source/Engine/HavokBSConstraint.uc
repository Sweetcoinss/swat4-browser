class HavokBSConstraint extends HavokConstraint
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

defaultproperties
{
	Texture=Texture'Engine_res.Havok.S_HkBSConstraint'
}