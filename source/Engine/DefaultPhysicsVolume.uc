class DefaultPhysicsVolume extends PhysicsVolume
	native
	config
	notplaceable
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

function Destroyed()
{
	Log(Concat_StrStr(string(self), " destroyed!"));
	assert(false);
	return;
}

defaultproperties
{
	bStatic=false
	bNoDelete=false
}