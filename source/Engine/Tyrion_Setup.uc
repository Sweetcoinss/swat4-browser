class Tyrion_Setup extends Actor
	native
	config
	notplaceable
	hidecategories(Karma);

// Export UTyrion_Setup::execmakeSafeOuter(FFrame&, void* const)
native function makeSafeOuter(Object objOwner, Object Obj);

static function Object shallowCopy(Object Source)
{
	local Object Dest;

	Dest = Source.Class.static.Allocate(self, Source.Outer).;
	Construct_Void();
	if(copyParameters(Source, Dest))
	{
		return Dest;
	}
	else
	{
		return none;
	}
	return;
}

// Export UTyrion_Setup::execcopyParameters(FFrame&, void* const)
native static function bool copyParameters(Object Source, Object Dest);

defaultproperties
{
	DrawType=0
	bHidden=true
}