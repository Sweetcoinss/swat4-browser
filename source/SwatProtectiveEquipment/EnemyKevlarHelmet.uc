class EnemyKevlarHelmet extends ProtectiveEquipment
	config
	hidecategories(Karma);

defaultproperties
{
	AttachmentBone="HeadGear"
	ProtectedRegion=1
	MomentumToPenetrate=250.0000000
	PenetratedDamageFactor=(Min=4.0000000,Max=4.0000000)
	BlockedDamageFactor=(Min=2.0000000,Max=2.7500000)
	Description="If you can read this enter a bug that you can see the Kevlar helmet description!"
	FriendlyName="Kevlar Helmet"
	StaticMesh=StaticMesh'SwatGear_sm.SWATkevlarHelmet'
}