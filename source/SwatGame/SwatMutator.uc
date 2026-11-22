class SwatMutator extends Mutator
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

function bool MutatorIsAllowed()
{
	return OrOr_BoolBool(OrOr_BoolBool(Not_PreBool(Level.IsDemoBuild()), EqualEqual_ObjectObject(Class, Class'SwatGame.SwatMutator')), super.MutatorIsAllowed());
	return;
}
