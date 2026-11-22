class BoobyTrap_Door extends BoobyTrap
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

function OnBoobyTrapInitialize()
{
	BoobyTrapDoor.AttachToBone(self, AttachSocket);
	Log(Concat_StrStr(Concat_StrStr(string(self), " has attached to the door! ... staticmesh: "), string(StaticMesh)));
	Log(Concat_StrStr("BoobyTrap attached to door: ", string(BoobyTrapDoor)));
	return;
}

defaultproperties
{
	QualifyTime=1.0000000
	AttachSocket="C2ChargeLeft"
	StaticMesh=StaticMesh'arms_sm.arms_bathsink'
	DrawScale=0.5000000
	bCollideWorld=true
	bBlockActors=true
}