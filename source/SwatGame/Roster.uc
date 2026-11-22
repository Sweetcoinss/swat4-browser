class Roster extends Object
	abstract
	editinlinenew
	collapsecategories
	hidecategories(Object);

var Class<Archetype> ArchetypeClass;
var() IntegerRange Count;
var() editinline array<editinline ChanceArchetypePair> Archetypes;
var() name SpawnerGroup;

function name PickArchetype()
{
	return Class'SwatGame.Archetype'.static.PickArchetype(Archetypes);
	return;
}
