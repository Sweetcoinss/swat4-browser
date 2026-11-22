class HeavyBodyArmor extends BodyArmor
	config
	hidecategories(Karma);

defaultproperties
{
	ProtectedRegion=2
	MomentumToPenetrate=385.0000000
	PenetratedDamageFactor=(Min=1.1000000,Max=2.5000000)
	BlockedDamageFactor=(Min=0.8500000,Max=1.0000000)
	WearerMesh=SkeletalMesh'SWATMaleAnimation.SWATheavy'
	Description="Heavy body armor is laden with ceramic plates that provide the best possible ballistic protection.  It is extremely effective against pistols and sub-machineguns, but will still not provide much protection from assault rifles and shotgun AP slugs.  Heavy armor also reduces the effects of sting grenades and the less lethal shotgun by half.  The drawback is that the extreme weight of the ceramic plates reduces the wearer's speed."
	FriendlyName="Heavy Armor"
	GUIImage=Texture'gui_tex.equip_heavyarmor'
	DrawType=0
}