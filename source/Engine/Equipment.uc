class Equipment extends Actor
	abstract
	native
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma);

function OnGivenToOwner()
{
	return;
}

defaultproperties
{
	bAcceptsProjectors=false
	bAcceptsShadowProjectors=false
	RemoteRole=0
	bOwnerNoSee=true
}